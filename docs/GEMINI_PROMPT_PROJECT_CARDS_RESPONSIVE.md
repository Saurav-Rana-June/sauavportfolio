# Gemini Task: Fix Responsive “My Work” / Project Cards (Flutter Web)

> **How to use this prompt:** Paste this entire document into Gemini (attach the two screenshots listed in §2). Ask Gemini to return **complete, copy-paste-ready Dart patches** for the files in §5—not pseudo-code. Require a short “why this works” section tied to Flutter layout constraints.

---

## 1. Role & mission

You are a **senior Flutter layout engineer** specializing in **Flutter Web**, responsive grids, and constraint-driven UI.

**Mission:** Fix the **Projects / “My Work”** section so project cards look correct at **all viewport widths** when resizing from **desktop → tablet → mobile** (and back). The fix must be **production-quality**, match the existing codebase style (GetX, `AppScale`, theme tokens), and **preserve** hover animations, border effects, and tap behavior.

**Success = zero** of these at any breakpoint:

| Symptom | What users see |
|--------|----------------|
| **A. Dead vertical gap** | Large empty space **between** the description and the tech tags / footer, while the card is still tall (often on single-column mobile or banner-heavy cards like Schoolbox). |
| **B. Text clipping** | Description glyphs cut off at the bottom or visually “squashed” (often **2-column tablet** or mid-width desktop). |
| **C. Inconsistent card heights** | Grid rows feel wrong: some cards look stretched, others cramped, when crossing **600px** and **1024px** breakpoints. |

---

## 2. Visual evidence (attach to Gemini)

Attach these screenshots from the repo (same issues still present after one fix attempt):

1. `assets/Screenshot_2026-11-28_104539-94be24fc-b834-40ed-861f-abcc0d558008.png`  
   - Two cards side-by-side (ScenarioKit + My Portfolio): description clipped; tags/footer cramped at bottom.

2. `assets/Screenshot_2026-11-28_104252-be61713e-63d2-4019-9649-3426c9251f79.png`  
   - Schoolbox card: **huge empty band** between short description and bottom tags/footer.

**Interpretation for layout debugging:**

- Symptoms A + B together strongly suggest **`GridView` + fixed `childAspectRatio` + inner `Column`/`Expanded`/`Spacer` fighting intrinsic content height**—not a simple “wrong maxLines” issue.
- Schoolbox has a **tall raster banner**; package cards (ScenarioKit) use a **custom SVG/fallback banner** with different visual weight—one aspect ratio will not fit all card types.

---

## 3. Project context

| Item | Value |
|------|--------|
| **App** | Personal portfolio, **Flutter Web** primary |
| **State** | GetX (`HomeController`, etc.) |
| **Scaling** | `flutter_screenutil` + custom `AppScale` breakpoints |
| **Design size** | `ScreenUtilInit` → `designSize: Size(1440, 1024)` (see `RESPONSIVE_DESIGN_SYSTEM.md`) |
| **Breakpoints** (`AppScale`) | Mobile: `< 600`, Tablet: `600–1024`, Desktop: `> 1024` |
| **Content max width** | Mobile: full width; Tablet: `920`; Desktop: `1200` |

**Architecture rules (do not violate):**

- No business logic in widgets beyond presentation; keep `onTap` wiring as-is.
- Reuse `AppScale`, `AppTextStyles`, `AppColors`.
- Do not remove hover/border animations on `ProjectCard`.
- Prefer **minimal diff**; solving layout may require **replacing** `GridView` fixed aspect ratio—that is allowed if justified.

---

## 4. Files you must read and likely edit

| Path | Responsibility |
|------|----------------|
| `lib/presentation/home/widgets/projects_section.dart` | Grid: `crossAxisCount`, `childAspectRatio`, single-card `AspectRatio`, `_AnimatedProjectCard` |
| `lib/widgets/portfolio/project_card.dart` | Card structure: banner `SizedBox`, body `Column`, description, tags, footer, hover `Transform.scale` |
| `lib/infrastructure/theme/app_scale.dart` | `projectCardAspectRatio()` and breakpoint helpers |
| `RESPONSIVE_DESIGN_SYSTEM.md` | **Pattern C** documents *different* aspect ratios (`1.5` mobile / `1.3` tablet / `1.1` desktop) — **conflicts** with current `~0.76–0.92` values. Reconcile or replace pattern intentionally. |
| `lib/data/services/portfolio_service.dart` | Seed `ProjectModel` list — long descriptions, mixed banner types |

**Widget tree (simplified):**

```
ProjectsSection
  └─ GridView.builder (shrinkWrap, NeverScrollableScrollPhysics)
       └─ SliverGridDelegateWithFixedCrossAxisCount
            • crossAxisCount: 3 | 2 | 1
            • childAspectRatio: AppScale.projectCardAspectRatio()
       └─ _AnimatedProjectCard (scale + translate animation; may return raw child after opacity=1)
            └─ ProjectCard
                 └─ LayoutBuilder
                      └─ Transform.scale (hover)
                           └─ Column
                                ├─ SizedBox(height: bannerHeight)  // 118–165
                                └─ Expanded
                                     └─ Column
                                          ├─ title row
                                          ├─ Text description (maxLines 2–3)
                                          ├─ Spacer()  // pins tags/footer down
                                          ├─ Wrap tags
                                          └─ footer row
```

**Known constraint math (why tablet breaks):**

For tablet width `W`, padding `P`, spacing `S`, 2 columns:

`cellWidth ≈ (min(W, 920) - 2P - S) / 2`  
`cellHeight ≈ cellWidth / childAspectRatio`

Fixed `bannerHeight` (~150–165) + minimum body (title + 2–3 lines + tags + footer + padding) can **exceed** `cellHeight` when `childAspectRatio` is too high (cell too short). That produces **overflow/clipping** (Symptom B).

When `childAspectRatio` is lowered (taller cell), `Spacer()` in the body **absorbs** leftover height → **Symptom A** (Schoolbox).

**Conclusion you should act on:** Tuning only `childAspectRatio` is a **local optimum**; a robust fix likely needs **one or more** of:

1. **Intrinsic-height grid** (e.g. `Wrap` + fixed card width, `flutter_staggered_grid_view`, or manual row layout with `LayoutBuilder`).
2. **`mainAxisExtent` / computed extent** per breakpoint from measured content (title + description line count + tag rows).
3. **Remove `AspectRatio` + fixed ratio entirely** for projects; let card height follow content with a **max width** per column.
4. **Split layout**: fixed banner + **non-flexing** body with `mainAxisSize: min` inside a parent that does **not** force equal row heights—or equalize rows only on desktop where 3-col widths are stable.

Pick the approach that satisfies §7 acceptance tests.

---

## 5. Failed fix attempt (do not repeat blindly)

A prior agent tried:

1. Removed `Expanded` around description; added `Spacer()` before tags.
2. Responsive `bannerHeight` (140 / 150 / 165) + “compact” mode if `maxHeight < 340`.
3. Added `AppScale.projectCardAspectRatio()` (mobile `0.88`, tablet `0.76–0.86`, desktop `0.92`).

**User report:** Issues **unchanged** after hot restart.

**Your job:** Diagnose why (e.g. `Transform.scale` affecting paint but not constraints; `_AnimatedProjectCard` stripping transforms; `GridView` still forcing equal heights; `Spacer` still creating dead space; `LayoutBuilder` getting unbounded/infinite max height in grid children; breakpoint flicker at 600/1024; etc.) and implement a **structural** fix.

---

## 6. Functional requirements (preserve)

- Filter tabs (`ProjectCategoryFilter`) and project counts — unchanged behavior.
- Card actions: Play Store, App Store, Pub.dev, GitHub, external link, scroll-to-top — unchanged.
- `onTap` routing in `projects_section.dart` (pub.dev, portfolio scroll, `openProject`) — unchanged.
- Visual design: dark card, accent border flow on hover, badges — unchanged unless spacing fix requires 1–2px tweaks.

---

## 7. Acceptance criteria (mandatory)

Test by **resizing browser width** continuously (do not only test exact breakpoints).

| Viewport | Columns | Pass conditions |
|----------|---------|-----------------|
| **≥ 1100px** | 3 | No clipped text; tags + footer visible; row heights tolerable (equal height OK if no dead gap > ~16–24px below description). |
| **768–1024px** | 2 | **No glyph clipping** on longest seed descriptions; no overflow yellow/black stripes in debug. |
| **600–720px** | 2 | Same as above (narrow 2-col is the worst case). |
| **< 600px** | 1 | No enormous empty block between description and tags on Schoolbox; description ellipsis OK but not mid-line vertical clip. |
| **Filter: Packages & Tools** | varies | ScenarioKit + My Portfolio cards match quality of mobile app cards. |
| **Filter: single project** | 1 | `AspectRatio` wrapper path (≤1 item) must not regress. |

**Optional but valuable:** Golden/widget test with `flutter_test` at widths `360`, `600`, `768`, `1280` asserting no `RenderFlex overflow`.

---

## 8. Implementation guidance (strong suggestions)

### 8.1 Prefer content-driven height

Pseudo-pattern (adapt to this codebase):

```dart
// Option: Replace fixed childAspectRatio grid with width-based Wrap
LayoutBuilder(
  builder: (context, constraints) {
    final columns = ...;
    final gap = AppScale.w(16);
  final itemWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
    return Wrap(
      spacing: gap,
      runSpacing: AppScale.h(16),
      children: projects.map((p) => SizedBox(
        width: itemWidth,
        child: ProjectCard(...),
      )).toList(),
    );
  },
);
```

Inside `ProjectCard`, prefer:

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    AspectRatio(aspectRatio: 16 / 9, child: banner), // or fixed banner with width-based height
    Padding(..., child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, description, tags, footer],
    )),
  ],
);
```

**Remove** `Spacer()` and outer `Expanded` if the parent no longer forces a fixed height.

### 8.2 If keeping `GridView`

You must **compute** `childAspectRatio` from:

- `itemWidth`
- measured or estimated **total card height** = `bannerHeight + bodyMinHeight`

Example:

```dart
double _projectTileAspectRatio(double itemWidth) {
  const banner = 150.0;
  const bodyMin = 132.0; // title + 2 lines + tags + footer + padding; measure with TextPainter if needed
  final height = banner + bodyMin;
  return itemWidth / height;
}
```

Use `LayoutBuilder` in `ProjectsSection` to get `maxWidth`, not only `AppScale._width`.

### 8.3 Hover scale

`Transform.scale` on hover **does not** change layout constraints but can cause **visual** clipping if parent clips. Ensure `clipBehavior: Clip.none` where needed or reduce scale factor on small cards.

### 8.4 Align design doc

Update `RESPONSIVE_DESIGN_SYSTEM.md` Pattern C **or** `AppScale.projectCardAspectRatio()` so documentation matches the implemented strategy (avoid future regressions).

---

## 9. Deliverables from Gemini

1. **Root cause** (2–4 sentences) referencing Flutter constraints (`BoxConstraints`, `childAspectRatio`, `Expanded`, `Spacer`).
2. **Full updated source** for each changed file (or unified diff).
3. **Before/after** explanation per breakpoint table in §7.
4. **Manual test checklist** filled in as “passed” with widths tested.
5. If you add a dependency (e.g. `flutter_staggered_grid_view`), justify in one line and show `pubspec.yaml` snippet.

---

## 10. Copy-paste starter message for Gemini chat

```
Read the attached GEMINI_PROMPT_PROJECT_CARDS_RESPONSIVE.md and both screenshots.

You are fixing Flutter Web project cards in repo sauravPortfolio.

Constraints:
- Edit only what is needed in projects_section.dart, project_card.dart, app_scale.dart (and pubspec if required).
- Preserve GetX, animations, and onTap logic.
- Do not use a fixed childAspectRatio unless you derive it from itemWidth and minimum content height.
- Return complete Dart file bodies for every file you change.

The previous fix (Spacer + projectCardAspectRatio tuning) did NOT work. Propose a structural layout change and implement it.
```

---

## 11. Current `projectCardAspectRatio()` (reference)

```dart
static double projectCardAspectRatio() {
  if (isMobile) return 0.88;
  if (isTablet) {
    return _width < 720 ? 0.76 : 0.86;
  }
  return 0.92;
}
```

## 12. Current grid snippet (reference)

```dart
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: crossAxisCount,
  crossAxisSpacing: AppScale.w(16),
  mainAxisSpacing: AppScale.h(16),
  childAspectRatio: AppScale.projectCardAspectRatio(),
),
```

---

**End of prompt.** The implementing model should treat Symptoms A and B as a **single constraint problem**, not separate CSS-style tweaks.