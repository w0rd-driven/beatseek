---
name: enrich-security-finding
description: Enrich a security finding file with remediation/mitigation plans. Use when processing penetration test results or sobelow findings.
---

# Security Finding Enrichment

Enrich a finding with context, impact analysis, and a concrete remediation or mitigation plan.

## When to Use

- Processing annual penetration test findings
- Investigating a `mix sobelow` warning that needs a tracked decision
- Responding to a GitHub security advisory on a dependency

## Preference Order

1. **Remediation** — fix the root cause
2. **Mitigation** — reduce the risk without fixing the root cause (acceptable when remediation requires a major framework upgrade or architectural change)
3. **Acceptance** — documented acceptance with justification (only when remediation and mitigation are both infeasible; requires explicit sign-off)

## Procedure

Given a finding file path (`$ARGUMENTS`):

1. **Read the finding file** — extract: Finding ID, description, affected component, severity (Critical/High/Medium/Low/Informational), and any existing notes.

2. **Locate affected code** — search the codebase for the affected module, route, or pattern:

   ```bash
   # Find the affected module
   grep -r "pattern_from_finding" lib/
   # Check sobelow output for context
   mix sobelow --details <check-name>
   ```

3. **Assess impact** — consider:
   - Is this reachable by unauthenticated users?
   - Does it affect Spotify credentials, user tokens, or PII?
   - Is it a Postgres-only concern (will SQLite migration change the surface)?
   - What is the realistic attack scenario in Beatseek's context (personal app vs. multi-user SaaS)?

4. **Propose remediation or mitigation** — include:
   - File path(s) and line numbers to change
   - Specific code change or configuration update
   - Whether the change is backward-compatible
   - Any risks introduced by the fix itself

5. **Update the finding file** — add sections for:

   ```markdown
   ## Impact Assessment

   [Realistic impact for Beatseek's deployment context]

   ## Proposed Resolution

   **Approach:** Remediation / Mitigation / Acceptance
   **Rationale:** [why this approach]

   ### Changes Required

   - `lib/beatseek_web/router.ex:42` — [what to change and why]
   - `config/config.exs` — [if config change needed]

   ### Code

   ```elixir
   # Before
   ...
   # After
   ...
   ```

   ### Risks

   [Any risks introduced by the fix]

   ## Linked Issue

   GitHub Issue: #<NNN>
   ```

6. **Create or update a GitHub issue** — link the finding to a tracked issue:

   ```bash
   gh issue create \
     --title "Security: <finding title>" \
     --label "security" \
     --body "$(cat finding-file.md)"

   # Or update existing:
   gh issue edit <NNN> --body "$(cat finding-file.md)"
   ```

7. **Summarise** — report to the user:
   - Finding ID and severity
   - Chosen approach (remediation/mitigation/acceptance)
   - Files affected
   - GitHub issue URL

## Related Skills

- `use-github-cli` — Create and update GitHub issues
- `security-engineer` agent — Deep security review of a PR diff
