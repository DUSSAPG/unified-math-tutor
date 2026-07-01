# Figma Naming Rules

Use this format for every top-level frame:

`<Area>.<Screen>.<State>[.<Viewport>]`

Examples:

- `Tab.Home.Default.Mobile`
- `Tab.Practice.Summary.Mobile`
- `Profile.Accessibility.Default.Tablet`
- `Help.ParentTools.PinGate.Mobile`

## Rules

1. Use route ownership as the first segment: `Tab`, `Profile`, `Help`,
   `Onboarding`, `Auth`, or `Global`.
2. Use the route's stable screen concept as the second segment. Do not encode
   marketing copy or translated labels.
3. Always include a state: `Default`, `Loading`, `Empty`, `Error`, `PinGate`,
   `Session`, or `Summary`.
4. Add `Mobile`, `Tablet`, or `Desktop` only when a responsive variant has a
   distinct layout.
5. Keep route names and widget names in `SCREEN_TO_WIDGET_MAP.md`. A renamed
   route, widget, or Figma frame must update that table in the same change.
6. Reusable components are named `Component.<Name>.<State>`, for example
   `Component.RewardsChip.Enabled`.

## Change Control

1. Rename frames only in the same change that updates
   `SCREEN_TO_WIDGET_MAP.md`.
2. Add a distinct frame for meaningful gated, empty, loading, error, and
   completion states.
3. Keep route paths in the mapping document, not in frame names.
4. Review the mapping document before design handoff and before release.
