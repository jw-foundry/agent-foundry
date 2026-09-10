# <project>

<One sentence: what this is and who it's for. Replace this line.>

## Commands

- Install: `npm ci`
- Test: `npm test`
- Lint: `npm run lint`
- Typecheck: `npm run typecheck`
- Dev server: `npm run dev`  # binds 0.0.0.0 so it's reachable at devmini:3000

## Definition of done

A task is done when all four hold:

1. `npm test` exits 0
2. `npm run lint` exits 0
3. `npm run typecheck` exits 0
4. The acceptance criterion for the task in `docs/plans/<issue>.md` was
   **executed** and its real output pasted into the PR body

"Should pass" is not "passes". Run it.

## House rules

- Never edit files in the main checkout from a worktree session.
- No new dependency without a sentence in the PR body saying why.
- Match surrounding code style over any general preference.
- If the plan is wrong, stop and say so. Do not build the wrong thing well.
- Adjacent problems you notice go in a list at the end of the PR, not in
  the diff.

## Layout

- `docs/plans/<issue>.md` — the approved spec for issue #N. Source of truth
  for what a build is allowed to touch.
- `.claude/worktrees/` — agent worktrees. Gitignored. `fdry clean` sweeps them.
