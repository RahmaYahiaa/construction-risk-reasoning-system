# Construction Risk Reasoning System

A CLIPS knowledge-based system for identifying and investigating risks in construction projects. It supports forward reasoning from user-confirmed causes and backward reasoning from a selected hypothetical risk.

## Project and Research Context

This project is informed by Kiyoshi Niwa, Koji Sasaki, and Hirokazu Ihara's 1984 article, “An Experimental Comparison of Knowledge Representation Schemes” (*AI Magazine*, 5(2), 29–36; [DOI: 10.1609/aimag.v5i2.435](https://doi.org/10.1609/aimag.v5i2.435)). The paper compares four pilot expert systems—simple production rules, structured production rules, frames, and logic—using the same large-construction-project risk-management domain. The systems support both forward and backward reasoning; backward reasoning can explain the inference path when requested.

The article reports a trade-off: structured knowledge representations (including frames and structured production systems) can improve inference efficiency and reduce sensitivity to knowledge-base size, but are harder to design and implement. The frame system showed low inference time in the reported experiment, while the logic system was slower; these are findings from the authors' 1984 systems, not measurements of this CLIPS project.

This repository is an educational CLIPS implementation inspired by the problem and reasoning workflow. It is **not** a reproduction of all four representations, their original knowledge base, or their performance experiment. The included risk/cause facts are the data encoded in `KBS.clp`.

## How the Paper Informs This Implementation

- **Domain model:** risk causes, risks, and cause-to-risk relationships are represented as CLIPS templates and facts.
- **Forward reasoning:** the user searches cause descriptions by keyword or phrase, confirms matching causes, and receives alarms for linked risks.
- **Backward reasoning:** the user selects a risk hypothesis, answers questions about its linked causes, and sees whether a confirmed cause supports the risk.
- **Explanation:** for a backward analysis, the user may request the confirmed cause-to-risk links behind the result. This is a concise explanation of the project's represented links, not a replay of the paper's original rule identifiers or full historical inference trace.
- **Knowledge structure:** explicit templates separate causes, risks, links, and alarms, making the represented relationships visible and maintainable.
- **Scope:** the application does not implement the paper's four-system comparison, knowledge-maintenance subsystem, risk-to-risk consequence chains, or runtime benchmarks.

## Features

- Forward and backward reasoning modes.
- Project-stage filters: `planning`, `execution`, `delivery`, and `all`.
- Multi-word search against cause descriptions.
- Interactive confirmation of causes and candidate risks.
- Backward-analysis explanation of confirmed risk/cause links.
- Structured alarm facts for risks identified during an analysis.
- Analysis-state clearing and an interactive loop for consecutive analyses.
- Case study PDF intentionally excluded from version control; see `.gitignore`.

## Files

- `KBS.clp` — CLIPS templates, domain facts, and inference rules.
- `README.md` — project overview, research context, and run instructions.
- `.gitignore` — excludes the local case-study PDF and generated/temporary files.

## Requirements

- Python 3.10 or newer.
- `clipspy` (CLIPS Python bindings), or a compatible CLIPS environment.

Install the tested Python binding:

```bash
python -m pip install clipspy
```

## Run

From the project directory:

```bash
python -c "import clips; env=clips.Environment(); env.load('KBS.clp'); env.call('main')"
```

The program asks for reasoning mode and stage. In forward mode, enter a keyword or phrase such as `project manager`; confirm whether each matching cause occurred. In backward mode, select a risk code and respond to the proposed cause questions. At the end of a backward analysis, choose whether to view the cause-to-risk explanation. The main loop then offers another analysis.

To run from the CLIPS interactive prompt instead, load the file and call the function:

```clips
(load "KBS.clp")
(main)
```

## Example Workflow

1. Select `backward` and stage `delivery`.
2. Enter risk code `6107001` (failure in final system testing).
3. Answer yes/no to the causes linked to that risk.
4. Request the explanation to see which confirmed cause links support the risk.
5. Choose whether to start another analysis.

## Data and Limitations

The system reasons only over the facts and mappings present in `KBS.clp`. A risk is a possible consequence of a confirmed linked cause; it is not a probability estimate or a professional risk assessment. The knowledge base is small and educational, and the output depends on the completeness and correctness of its manually encoded facts. No inference-time comparison with the 1984 paper is claimed.

The paper is cited above but its PDF is not committed to this repository. The local file `case study-2.pdf` is excluded by `.gitignore`.

## Reference

Niwa, K., Sasaki, K., & Ihara, H. (1984). An Experimental Comparison of Knowledge Representation Schemes. *AI Magazine*, 5(2), 29–36. https://doi.org/10.1609/aimag.v5i2.435
