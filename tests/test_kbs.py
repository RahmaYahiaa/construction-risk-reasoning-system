import unittest

import clips


PROJECT_FILE = "KBS.clp"


class KnowledgeBaseTests(unittest.TestCase):
    def setUp(self):
        self.env = clips.Environment()
        self.env.load(PROJECT_FILE)
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


if __name__ == "__main__":
    unittest.main()
