---
name: phasefolio-onboarding
description: Use when the user first asks about PhaseFolio's MCP tools, or asks "what can phasefolio do" / "what tools are available" — explains the rNPV, PoS, landscape, and verify tool surface and typical workflows.
---

# PhaseFolio: What This Plugin Does

PhaseFolio is a risk-adjusted NPV (rNPV) calculator and competitive intelligence engine for biotech assets. The MCP server bundled with this plugin exposes the same engine that powers `phasefolio.com`.

## What you can ask

- **Valuation** — "Compute the rNPV for an NSCLC EGFR-mutant 2L+ asset entering Phase II"
- **Benchmarks** — "What is the PoS for rheumatoid arthritis, antibody, no biomarker?"
- **Landscape** — "Pull comparable trials for a Phase III oncology asset"
- **Trust** — "Verify this signed PhaseFolio export"

The MCP server self-describes its tool surface — Claude sees the full tool list at session start, with required-input schemas (indication, modality, stage durations, costs, PoS, etc.). You do not need to memorize tool names.

## Where the data comes from

- **rNPV engine.** `engine_version` and `methodology_version` are embedded in every signed export so a counterparty can verify exactly what produced a number.
- **PoS benchmarks.** BIO/QLS 2021 with stage / biomarker multipliers. Methodology: <https://phasefolio.com/methodology>.
- **Landscape.** ClinicalTrials.gov + FDA Drugs@FDA cross-linked, narrowed per sub-indication.

## Public surfaces (no auth needed)

| What | URL |
| :--- | :--- |
| Methodology hub | <https://phasefolio.com/methodology> |
| Public benchmarks | <https://phasefolio.com/benchmarks> |
| Verify a signed export | <https://phasefolio.com/verify> |
| Build log | <https://phasefolio.com> |

## When NOT to use

- **Investment / financial advice.** PhaseFolio outputs are decision-support inputs, not recommendations.
- **PHI / patient-identifiable data.** The engine consumes anonymized clinical-asset metadata only.
