# Construction Risk Reasoning System

A CLIPS-based knowledge-based system for exploring construction-project risks through forward and backward chaining.

## Contents

- `KBS.clp` — templates, risk/cause facts, mappings, and inference rules.
- The accompanying research case study is intentionally excluded from this repository.

## Requirements

- CLIPS 6.3 or later (or a compatible CLIPS environment).

## Run

Load `KBS.clp` in CLIPS and run the rules:

```clips
(load "KBS.clp")
(reset)
(run)
```

Choose `forward` to search causes by a keyword or phrase and confirm matched causes. Choose `backward` to investigate a risk code and confirm possible causes. Select `planning`, `execution`, `delivery`, or `all` for the project stage.

## Notes

This is an educational expert-system case study. The knowledge base represents the causes and risk relationships encoded in `KBS.clp`; it does not replace professional project-risk assessment.
