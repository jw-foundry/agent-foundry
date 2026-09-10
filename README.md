# agent-foundry

A dev team as a Claude Code plugin, plus the templates that scaffold a
project to be worked on by it.

## What's here

    agents/      six roles. Three are read-only by construction, which is
                 what stops a "reviewer" from quietly fixing what it was
                 supposed to criticize.
    hooks/       PreToolUse guard + TaskCompleted test gate.
    bin/         the scripts those hooks run.
    templates/   what `fdry new <repo>` drops into a fresh project.

## Install

Locally, on devmini:

    /plugin marketplace add https://github.com/<org>/agent-foundry.git
    /plugin install agent-foundry@agent-foundry

In a workflow:

    plugin_marketplaces: "https://github.com/<org>/agent-foundry.git"
    plugins: "agent-foundry@agent-foundry"

## The roster

| Agent           | Access    | Job |
|-----------------|-----------|-----|
| architect       | read-only | Approved direction → written spec with executable acceptance criteria |
| devils-advocate | read-only | Attacks the plan. Failure modes, not votes. |
| researcher      | read-only | Prior art and what previous attempts got wrong |
| builder         | writes    | Implements assigned tasks, isolated in its own worktree |
| test-engineer   | writes    | Tests from the spec, never from the implementation |
| adversary       | read-only | Tries to break it. Reports; never patches. |

## Changing an agent

Edit the markdown, commit, push. Workflows install the plugin fresh each
run, so the next run picks it up. Local sessions need
`/plugin update agent-foundry`.

Keep the bodies short. Every agent loads its own definition plus
CLAUDE.md on every spawn, so a paragraph you add here is paid for six
times per build.
