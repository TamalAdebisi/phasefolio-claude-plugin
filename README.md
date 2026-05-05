# PhaseFolio for Claude Code

> Risk-adjusted NPV (rNPV) and biotech diligence — directly inside Claude Code.

[PhaseFolio](https://phasefolio.com) is a financial-modeling engine for biotech assets. This plugin connects Claude to the same engine that powers the PhaseFolio web app — so you can value pipelines, look up clinical-trial probabilities of success, scan competitive landscapes, and verify signed reports without leaving your terminal.

## Install

In any Claude Code session:

```text
/plugin marketplace add TamalAdebisi/phasefolio-claude-plugin
/plugin install phasefolio@phasefolio
```

The MCP server is fetched from npm on first use. Nothing else to install.

## What you can ask Claude

Once installed, prompts like these will Just Work:

- *"Compute the rNPV for an NSCLC EGFR-mutant 2L+ asset entering Phase II with $30M Phase II spend over 24 months."*
- *"What's the probability of success for rheumatoid arthritis, antibody, no biomarker?"*
- *"Pull comparable trials and competing programs for a Phase III oncology asset."*
- *"Verify this signed PhaseFolio export."* (paste signature)
- *"What does PhaseFolio do?"* (the bundled onboarding skill answers)

Claude discovers the available tools and their input schemas automatically — you don't need to memorize names.

## What's inside

The plugin exposes PhaseFolio's MCP tool surface for four use cases:

| Use case | What it does |
| :--- | :--- |
| **Valuation** | Computes risk-adjusted NPV across clinical stages with custom costs, durations, peak sales, and discount rates. |
| **Benchmarks** | Looks up published probabilities of success by indication × modality × biomarker, with stage and IO multipliers. |
| **Landscape** | Surfaces comparable trials and competing programs from ClinicalTrials.gov + FDA Drugs@FDA, narrowed per sub-indication. |
| **Trust** | Verifies signed PhaseFolio export signatures and surfaces the embedded engine, methodology, and benchmark versions. |

## Why "trust" is a tool

Every PhaseFolio export — PDF, Excel, dossier — embeds the exact `engine_version`, `methodology_version`, and `benchmark_dataset_versions` that produced it. That makes any number a counterparty receives reproducible: they can verify the signature publicly and inspect the methodology that was current when the export was issued.

Public surfaces (no account needed):

- **Methodology hub** — <https://phasefolio.com/methodology>
- **Public benchmarks** — <https://phasefolio.com/benchmarks>
- **Verify a signed export** — <https://phasefolio.com/verify>

## Important notes

- **Not financial advice.** PhaseFolio outputs are decision-support inputs. Investment decisions are yours.
- **No PHI.** The engine consumes anonymized clinical-asset metadata only. Do not paste patient-level data into prompts.
- **Free academic access.** A Research Tier exists for academic and nonprofit use — see the [contact page](https://phasefolio.com/contact).

## Source

| Component | Where |
| :--- | :--- |
| This Claude Code plugin | [TamalAdebisi/phasefolio-claude-plugin](https://github.com/TamalAdebisi/phasefolio-claude-plugin) |
| MCP server (npm) | [`@phasefolio/mcp`](https://www.npmjs.com/package/@phasefolio/mcp) |
| MCP server (Official Registry) | `com.phasefolio/phasefolio` |
| Web app | <https://phasefolio.com> |

## License

MIT — see [LICENSE](LICENSE).
