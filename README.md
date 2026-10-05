# Construction Risk Reasoning System

A CLIPS knowledge-based system for exploring risks in construction projects. It supports forward reasoning from user-confirmed causes and backward reasoning from a user-selected risk.

## Case Study and How We Applied It

The project is based on the problem in Niwa, Sasaki, and Ihara's 1984 case study, *An Experimental Comparison of Knowledge Representation Schemes*. The study uses risk management for a large construction project to compare four ways of representing knowledge: a simple production system, a structured production system, a frame system, and a logic system. The pilot systems share the same domain and support forward and backward reasoning. The paper also describes an explanation facility for backward reasoning: after the system judges a risk hypothesis, the user may ask which inference steps led to that result.

We treated the paper as a design reference, not as a specification to reproduce every experiment. Our implementation uses CLIPS production rules and an explicit set of risk, cause, and link facts. It does not implement the paper's other three representation schemes, its full historical knowledge base, or its performance experiments.

### Problem-to-Code Mapping

| Case-study idea | Implementation in this project | Why this design was used |
|---|---|---|
| Construction-project risks and their causal factors | `risk` and `risk-cause` templates, populated by `deffacts` | Keep domain entities explicit and inspectable instead of embedding all domain data inside rule bodies. |
| Causal relationship between a cause and a risk | `risk-link` facts | Separate domain relationships from the inference rules, so mappings can be reviewed and extended independently. |
| Forward reasoning: causes supplied by the project manager may imply risks | Search cause descriptions, ask whether each matching cause occurred, then fire `show-risk-alarms` for linked risks | User confirmation is retained as an explicit condition; the system reports possible risks rather than making an autonomous project decision. |
| Keyword-in-context (KWIC) cause search | Read a full line and match the phrase against cause descriptions | A line-based input accepts phrases such as `project manager`, not only a single token. |
| Backward reasoning: investigate a hypothetical risk | Select a risk code, ask about its linked causes, and confirm it only when a linked cause is confirmed | This follows the case study's checklist-style investigation of a risk hypothesis. |
| Explanation of a backward result | Offer to print confirmed cause-to-risk links for the selected risk | The source code stores explicit links, not the paper's original rule execution trace; therefore the explanation reports the evidence represented here and does not invent historical rule numbers. |
| Risk alarms | Store deduced results as `alarm` facts and print them in the forward summary | A template gives the result a structured representation rather than leaving it only in console text. |
| Repeated project-manager analyses | `main` resets the environment before each run and asks whether to continue | A fresh CLIPS `reset` re-instantiates the base facts and prevents mutable conclusions from carrying into the next analysis. |

### Reasoning and Scope Decisions

1. **Use CLIPS production rules.** The comparison paper evaluates multiple knowledge-representation schemes. This project focuses on one working CLIPS rules-based implementation rather than presenting a comparison it did not run.
2. **Keep facts separate from inference.** Risk causes, risks, links, and alarms have distinct templates. The data can be inspected without tracing through rule code, and rules can operate on those relationships.
3. **Treat forward matches as candidates.** A text match alone does not mean a cause happened. The user confirms or rejects each candidate before linked risks are reported.
4. **Treat backward input as a hypothesis.** The selected risk is checked against its mapped causes. A confirmed cause can support that risk; unrelated risks must not be inferred just because they share that cause. The backward confirmation rule is therefore constrained to the selected risk.
5. **Explain only what the implementation can justify.** The source article describes replaying inference rules. This version does not store a rule-by-rule trace, so it explains the selected risk using the confirmed causes and stored links instead of claiming to reproduce the original trace.
6. **Reset between sessions.** Interactive repetition uses CLIPS `reset`, which restores initial facts before the next menu cycle. The state-clearing function also resets the mutable `selected`, `status`, `deduced`, and alarm data at analysis start.
7. **Support every encoded project stage.** The stage menu includes `planning`, `execution`, `delivery`, and `all`, so a risk encoded for delivery can be investigated.

## Features

- Forward and backward reasoning modes.
- Stage filters: `planning`, `execution`, `delivery`, and `all`.
- Multi-word search against cause descriptions.
- User confirmation of proposed causes.
- Backward investigation with an optional evidence explanation.
- Structured alarm facts for deduced risks.
- Repeatable interactive analyses with state reset between runs.

## Repository Contents

- `KBS.clp` — CLIPS templates, domain facts, inference rules, and interactive entry point.
- `requirements.txt` — Python binding dependency used for running and testing the knowledge base.
- `tests/test_kbs.py` — automated knowledge-base tests.
- `README.md` — case-study interpretation, implementation decisions, operation, and limitations.

The case-study PDF is not stored on `main`; it is kept on the separate `study-case` branch.

## Requirements

- Python 3.10 or newer.
- `clipspy` (CLIPS Python bindings).

Install the dependency:

```bash
python -m pip install -r requirements.txt
```

## Run

From the repository directory:

```bash
python -c "import clips; env=clips.Environment(); env.load('KBS.clp'); env.call('main')"
```

Choose `forward` or `backward`, then choose `planning`, `execution`, `delivery`, or `all`.

- In forward mode, enter a keyword or phrase (for example, `project manager`) and answer yes/no for each matching cause.
- In backward mode, enter a risk code for the selected stage and answer yes/no for its proposed causes. The system then offers to explain the confirmed cause-to-risk links.
- At the end of either analysis, choose whether to run another analysis.

To use a CLIPS interactive prompt, load `KBS.clp` and call `(main)`.

## Example

A backward investigation of risk `6107001` can be started by selecting `backward`, choosing `delivery`, and entering `6107001`. The system lists the risk's mapped causes, asks which occurred, reports whether any support the hypothesis, and can print the confirmed links on request.

## Tests

Run the automated checks from the repository root:

```bash
python -m unittest discover -s tests -v
```

The six tests cover knowledge-base loading, startup facts, delivery-stage risk data, clearing mutable cause/risk/alarm state, empty-answer handling, multi-word search, backward risk confirmation, and state reset between consecutive analyses.

## Limitations

This is an educational expert-system implementation, not a substitute for professional project-risk assessment. It reasons only over the manually encoded facts and mappings in `KBS.clp`; it does not estimate likelihood or impact. It also does not reproduce the paper's complete knowledge base, four-system comparison, knowledge-maintenance subsystem, full inference trace, or runtime benchmarks. No performance result from the case study is claimed for this project.
