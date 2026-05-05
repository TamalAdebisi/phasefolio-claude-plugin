# PhaseFolio for Claude Code

> Bring your PhaseFolio biotech-diligence work directly into Claude Code.

[PhaseFolio](https://phasefolio.com) is a financial-modeling platform for biotech assets — risk-adjusted NPV (rNPV), competitive landscape, evidence registers, and signed IC dossiers. This plugin connects Claude to PhaseFolio's read-only MCP API so you can pull projects, scenarios, dossiers, and benchmarks into the conversation, and verify signed reports — without leaving your terminal.

## Install

In any Claude Code session:

```text
/plugin marketplace add TamalAdebisi/phasefolio-claude-plugin
/plugin install phasefolio@phasefolio
```

The plugin connects directly to `https://app.phasefolio.com/api/mcp` over HTTP — no Node.js install, no `npx`, no local subprocess.

## What you can ask Claude

Once installed, prompts like these will Just Work:

- *"Pull project ABC from PhaseFolio and summarize the asset I'm valuing."*
- *"List all scenarios in my project and tell me which has the highest rNPV."*
- *"Fetch the IC dossier for scenario X and draft a partner memo from it."*
- *"Surface comparable trials and competing programs for our anti-PD-L1 asset."*
- *"What do the network benchmarks say for Phase II oncology PoS?"*
- *"Verify this signed PhaseFolio export and tell me which methodology version produced it."*
- *"What does PhaseFolio do?"* — the bundled onboarding skill answers.

Claude discovers each tool's input schema automatically — you don't need to memorize tool names.

## What's inside

The plugin exposes **9 read-only MCP tools** in two tiers:

### Project-scoped (require a token)

| Tool | What it returns |
| :--- | :--- |
| `get_project` | Project metadata — indication, modality, biomarker, current stage |
| `list_scenarios` | All scenarios in a project, with IDs and timestamps |
| `get_scenario` | Full scenario inputs — stage costs, durations, PoS, commercial assumptions |
| `get_evidence` | Evidence register entries — citations, sources, notes |
| `get_dossier` | Structured IC dossier JSON — same content as the rendered PDF |
| `query_landscape` | Asset-anchored competitive landscape — comparable trials, competing programs |

### Public (no auth)

| Tool | What it returns |
| :--- | :--- |
| `query_benchmarks` | Anonymized aggregate statistics across the PhaseFolio network |
| `verify_export` | Verifies a signed PhaseFolio export — content hash, engine + methodology versions |
| `get_methodology` | Methodology section content with stable citation URL and version stamp |

Computation (rNPV, sensitivity, Monte Carlo) happens in the web app. The MCP surface is for retrieval and analysis of work already done at <https://app.phasefolio.com>.

## Authentication

To unlock the six project-scoped tools, set `PHASEFOLIO_TOKEN` in your environment before starting Claude Code:

```bash
export PHASEFOLIO_TOKEN="your-token-here"
```

Tokens are issued from your account at <https://app.phasefolio.com>. Without a token, the three public tools still work.

## Trust artifacts

Every PhaseFolio export embeds the exact `engine_version`, `methodology_version`, and `benchmark_dataset_versions` that produced it, so any number you produce is reproducible by a counterparty. The verify endpoint is public:

- **Methodology hub** — <https://phasefolio.com/methodology>
- **Public benchmarks** — <https://phasefolio.com/benchmarks>
- **Verify a signed export** — <https://phasefolio.com/verify>
- **Privacy policy** — <https://phasefolio.com/privacy>

## Important notes

- **Not financial advice.** PhaseFolio outputs are decision-support inputs. Investment decisions are yours.
- **No PHI.** The engine consumes anonymized clinical-asset metadata only. Do not paste patient-level data into prompts.
- **Free academic access.** A Research Tier exists for academic and nonprofit use — see the [contact page](https://phasefolio.com/contact).

## Source

| Component | Where |
| :--- | :--- |
| This Claude Code plugin | [TamalAdebisi/phasefolio-claude-plugin](https://github.com/TamalAdebisi/phasefolio-claude-plugin) |
| MCP endpoint | `https://app.phasefolio.com/api/mcp` |
| MCP server (npm fallback) | [`@phasefolio/mcp`](https://www.npmjs.com/package/@phasefolio/mcp) |
| MCP server (Official Registry) | `com.phasefolio/phasefolio` |
| Web app | <https://phasefolio.com> |

## License

MIT — see [LICENSE](LICENSE).
