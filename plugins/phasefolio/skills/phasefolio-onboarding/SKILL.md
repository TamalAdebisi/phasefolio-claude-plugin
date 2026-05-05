---
name: phasefolio-onboarding
description: Use when the user first asks about PhaseFolio's MCP tools, or asks "what can phasefolio do" / "what tools are available" — explains the read-only retrieval surface (projects, scenarios, evidence, dossier, landscape, benchmarks, verify, methodology) and the auth model.
---

# PhaseFolio: What This Plugin Does

PhaseFolio is a financial-modeling platform for biotech assets. This plugin connects Claude to PhaseFolio's read-only MCP API — you can pull your projects, scenarios, evidence registers, and IC dossiers into the conversation, query competitive landscapes, look up anonymized network benchmarks, verify signed exports, and cite methodology sections.

**Computation happens in the web app at <https://app.phasefolio.com>.** The MCP surface is for retrieval and analysis of work you've already done there.

## Tool surface (9 tools)

**Project-scoped (require a `PHASEFOLIO_TOKEN`):**

| Tool | What it returns |
| :--- | :--- |
| `get_project` | Project metadata — indication, sub-indication, modality, biomarker, current stage |
| `list_scenarios` | All scenarios in a project, with IDs, names, and timestamps |
| `get_scenario` | Full scenario inputs — stage costs, durations, PoS, commercial assumptions |
| `get_evidence` | Evidence register entries — citations, sources, supporting notes |
| `get_dossier` | Structured IC dossier JSON — same content as the rendered PDF |
| `query_landscape` | Asset-anchored competitive landscape — comparable trials, competing programs |

**Public (no auth required):**

| Tool | What it returns |
| :--- | :--- |
| `query_benchmarks` | Anonymized aggregate statistics across the PhaseFolio network |
| `verify_export` | Verifies a signed PhaseFolio export — content hash, signed-at, engine + methodology versions |
| `get_methodology` | Methodology section content with version stamp and stable citation URL (sections: backtest, pos-calibration, ira-framework, evidence-standards, network-benchmarks) |

## What you can ask Claude

- *"Pull project ABC and summarize the asset I'm valuing."*
- *"List all scenarios in my project and tell me which has the highest rNPV."*
- *"Fetch the IC dossier for scenario X and draft a partner memo from it."*
- *"Surface comparable trials and competing programs for our anti-PD-L1 asset."*
- *"What do the network benchmarks show for Phase II oncology?"*
- *"Verify this signed PhaseFolio export and tell me which methodology version produced it."*
- *"Quote the backtest methodology with the version stamp."*

Claude discovers each tool's input schema automatically — you do not need to memorize tool names or parameter shapes.

## Auth

Set `PHASEFOLIO_TOKEN` in your environment to unlock the project-scoped tools. Without it, the public tools (`query_benchmarks`, `verify_export`, `get_methodology`) work; everything else returns an auth error. Get a token from your account at <https://app.phasefolio.com>.

## Where the data comes from

- **Engine and methodology versions** are embedded in every signed export, so any number you produce is reproducible by a counterparty.
- **Probability of success benchmarks**: BIO/QLS 2021 with stage and biomarker multipliers. Methodology: <https://app.phasefolio.com/methodology>.
- **Landscape**: ClinicalTrials.gov + FDA Drugs@FDA cross-linked, narrowed per sub-indication.
- **Network benchmarks**: anonymized aggregate statistics across opted-in PhaseFolio users.

## Public surfaces (no account needed)

| What | URL |
| :--- | :--- |
| Methodology hub | <https://app.phasefolio.com/methodology> |
| Public benchmarks | <https://app.phasefolio.com/benchmarks> |
| Verify a signed export | <https://app.phasefolio.com/verify> |
| Privacy policy | <https://app.phasefolio.com/privacy> |

## When NOT to use

- **Investment / financial advice.** PhaseFolio outputs are decision-support inputs, not recommendations.
- **PHI / patient-identifiable data.** The engine consumes anonymized clinical-asset metadata only. Do not paste patient-level data into prompts.
