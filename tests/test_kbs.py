import json
import subprocess
import sys
import unittest
from pathlib import Path

import clips


PROJECT_DIR = Path(__file__).resolve().parents[1]
PROJECT_FILE = PROJECT_DIR / "KBS.clp"


class KnowledgeBaseTests(unittest.TestCase):
    def setUp(self):
        self.env = clips.Environment()
        self.env.load(str(PROJECT_FILE))
        self.env.reset()

    def test_reset_asserts_startup_fact(self):
        self.assertTrue(any(f.template.name == "initial-fact" for f in self.env.facts()))

    def test_delivery_risk_is_present(self):
        risks = [f for f in self.env.facts() if f.template.name == "risk"]
        delivery = [f for f in risks if f["stage"] == "delivery"]
        self.assertTrue(any(f["code"] == "6107001" for f in delivery))

    def test_analysis_state_clear_resets_flags_and_alarms(self):
        cause = next(f for f in self.env.facts() if f.template.name == "risk-cause")
        risk = next(f for f in self.env.facts() if f.template.name == "risk")
        cause.modify_slots(selected=clips.Symbol("TRUE"), status=clips.Symbol("confirmed"))
        risk.modify_slots(deduced=clips.Symbol("TRUE"))
        self.env.assert_string(
            '(alarm (code "TEST") (description "test") '
            '(deduced TRUE) (hypothesis FALSE))'
        )

        self.env.call("clear-analysis-state")

        self.assertEqual(cause["selected"], clips.Symbol("FALSE"))
        self.assertEqual(cause["status"], clips.Symbol("unknown"))
        self.assertEqual(risk["deduced"], clips.Symbol("FALSE"))
        self.assertFalse(any(f.template.name == "alarm" for f in self.env.facts()))

    def run_interactive(self, answers):
        script = (
            "import clips, json; "
            f"env=clips.Environment(); env.load({str(PROJECT_FILE)!r}); "
            "env.call('main'); "
            "risks=[f['code'] for f in env.facts() "
            "if f.template.name=='risk' and f['deduced']==clips.Symbol('TRUE')]; "
            "alarms=[f['code'] for f in env.facts() if f.template.name=='alarm']; "
            "print('FINAL_STATE='+json.dumps({'risks':risks,'alarms':alarms}))"
        )
        result = subprocess.run(
            [sys.executable, "-c", script],
            cwd=PROJECT_DIR,
            input=answers,
            text=True,
            capture_output=True,
            timeout=20,
            check=True,
        )
        final_line = next(
            line for line in result.stdout.splitlines() if line.startswith("FINAL_STATE=")
        )
        return result.stdout, json.loads(final_line.removeprefix("FINAL_STATE="))

    def test_delivery_backward_reasoning_confirms_only_selected_risk(self):
        output, final_state = self.run_interactive(
            "backward\ndelivery\n6107001\nyes\nno\nyes\nno\n"
        )

        self.assertIn("[6107001] Failure in final system testing", output)
        self.assertIn("Explanation: the selected risk is linked", output)
        self.assertIn("[6107001] ", output)
        self.assertNotIn("Risk confirmed: [2103002]", output)
        self.assertEqual(final_state["risks"], ["6107001"])
        self.assertEqual(final_state["alarms"], ["6107001"])

    def test_empty_confirmation_input_is_reprompted(self):
        output, final_state = self.run_interactive(
            "forward\nall\ntesting\n\nyes\nno\n"
        )

        self.assertIn("Invalid input.", output)
        self.assertIn(">>> Possible RISK: [6107001]", output)
        self.assertEqual(final_state["risks"], ["6107001"])

    def test_multi_word_search_and_repeat_reset_between_sessions(self):
        output, final_state = self.run_interactive(
            "forward\nall\nproject manager\nyes\nyes\nyes\nyes\n"
            "backward\ndelivery\n6107001\nno\nno\nno\nno\n"
        )

        for cause_code in ("2E31", "2G31", "2H31"):
            self.assertIn(f"Cause matched: [{cause_code}]", output)
        self.assertIn("Run another risk analysis?", output)
        self.assertIn("No causes were confirmed for this risk.", output)
        self.assertEqual(final_state["risks"], [])
        self.assertEqual(final_state["alarms"], [])


if __name__ == "__main__":
    unittest.main()
