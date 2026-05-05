# PhaseFolio Claude Code Plugin

Adds **[PhaseFolio](https://phasefolio.com)** — risk-adjusted NPV and biotech diligence — to Claude Code as a plugin.

This is a thin wrapper around the published [`@phasefolio/mcp`](https://www.npmjs.com/package/@phasefolio/mcp) server, distributed as a Claude Code marketplace so users can install it with one slash command.

## Install

```text
/plugin marketplace add TamalAdebisi/phasefolio-claude-plugin
/plugin install phasefolio@phasefolio
```

The first install will fetch `@phasefolio/mcp` from npm via `npx`, so users do not need to install anything globally.

## What it adds

- **MCP tools** for rNPV computation, PoS benchmark lookup, landscape comparables, and signed-export verification.
- An **onboarding skill** (`phasefolio-onboarding`) that explains the tool surface on first use.

The full engine assumptions are documented at the [methodology hub](https://phasefolio.com/methodology).

## Layout

```
.
├── .claude-plugin/
│   └── marketplace.json          # marketplace catalog
└── plugins/
    └── phasefolio/
        ├── .claude-plugin/
        │   └── plugin.json       # plugin manifest
        ├── .mcp.json             # spawns @phasefolio/mcp via npx
        └── skills/
            └── phasefolio-onboarding/
                └── SKILL.md
```

## Updating

The plugin pins `@phasefolio/mcp@0.1.4`. To take a newer engine:

1. Bump the version in [`plugins/phasefolio/.mcp.json`](plugins/phasefolio/.mcp.json) (the `args` array).
2. Bump `version` in [`plugins/phasefolio/.claude-plugin/plugin.json`](plugins/phasefolio/.claude-plugin/plugin.json) and the matching entry in [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json).
3. Push to `main`. Users see the new version on `/plugin marketplace update`.

The MCP server itself is released independently from `@phasefolio/mcp` on npm and from the Official MCP Registry as `com.phasefolio/phasefolio` — this plugin only re-exposes it inside the Claude Code marketplace surface.

## Local testing

```bash
git clone https://github.com/TamalAdebisi/phasefolio-claude-plugin
cd phasefolio-claude-plugin
# inside Claude Code:
/plugin marketplace add ./
/plugin install phasefolio@phasefolio
```

## Submit to the official Anthropic marketplace

Once this community marketplace is stable, submit at <https://claude.ai/settings/plugins/submit> for inclusion in the Anthropic-curated catalog.

## License

MIT — see [LICENSE](LICENSE).
