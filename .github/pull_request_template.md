<!--
Please fill in this PR template to make it easier to review and merge.

It has been designed so that a lot of it can be completed *after* submitting it,
e.g. filling in the checklists.

Notes:
1. Please keep the PR as small as is practicable; the larger a PR gets, the harder it becomes to review and the more time it requires to get it merged.
2. Similarly, please avoid PRs that cover more than one type; it should be a _bug fix_ *OR* a _new feature_ *OR* a _refactor_, etc.
3. Please direct questions to the [`#formulas` channel on Slack](https://saltstackcommunity.slack.com/messages/C7LG8SV54/), which is bridged to `#saltstack-formulas` on Freenode.
-->

### PR progress checklist (to be filled in by reviewers)
<!-- Please leave this checklist for reviewers to tick as they work through the PR. -->

- [ ] Changes to documentation are appropriate (or tick if not required)
- [ ] Changes to tests are appropriate (or tick if not required)
- [ ] Reviews completed

---

### What type of PR is this?
<!-- Please tick each box that is relevant (after creating the PR). -->

#### Primary type
<!-- There really should be only *one* of these types ticked for each PR. -->

- [ ] `[build]`    Changes related to the build system
- [ ] `[chore]`    Changes to the build process or auxiliary tools and libraries such as documentation generation
- [ ] `[ci]`       Changes to the continuous integration configuration
- [ ] `[feat]`     A new feature
- [ ] `[fix]`      A bug fix
- [ ] `[perf]`     A code change that improves performance
- [ ] `[refactor]` A code change that neither fixes a bug nor adds a feature
- [ ] `[revert]`   A change used to revert a previous commit
- [ ] `[style]`    Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc.)

#### Secondary type
<!-- Most PRs should include all of the following types as well. -->

- [ ] `[docs]`     Documentation changes
- [ ] `[test]`     Adding missing or correcting existing tests

### Does this PR introduce a `BREAKING CHANGE`?
<!-- If so, change the following to a `Yes` and explain what the breaking changes are. -->
<!-- If there are multiple breaking changes, list them all. -->

No.

### Related issues and/or pull requests
<!-- Please link any related issues/PRs here, especially any issues that are closed by this PR. -->



### Describe the changes you're proposing
<!-- A clear and concise description of what you have implemented. -->
<!-- Consider explaining each commit if they cover different aspects of the proposed changes. -->



### Pillar / config required to test the proposed changes
<!-- Provide links to the SLS files and/or relevant configs (be sure to remove sensitive info). -->



### Debug log showing how the proposed changes work
<!-- Include a debug log showing how these changes work, e.g. using `salt-minion -l debug`. -->
<!-- Alternatively, linking to Kitchen debug logs is useful, e.g. via. Travis CI. -->
<!-- Most useful is providing a passing InSpec test, which can be used to verify any proposed changes. -->



### Documentation checklist
<!-- Please tick each box that is relevant (after creating the PR). -->

- [ ] Updated the `README` (e.g. `Available states`).
- [ ] Updated `pillar.example`.

### Testing checklist
<!-- Please tick each box that is relevant (after creating the PR). -->

- [ ] Included in Kitchen (i.e. under `state_top`).
- [ ] Covered by new/existing tests (e.g. InSpec, Serverspec, etc.).
- [ ] Updated the relevant test pillar.

### Additional context
<!-- Add any other context about the proposed changes here. -->

