# Droidex Tracker

A fan-made **collection tracker** for the **Droid Tycoons** Droidex — track which droids you've
collected across every finish (Default, Gold, Diamond, Rainbow, Beskar), with search, filters,
rarity tiers, shiny tracking, and collection milestones.

It's a **single HTML file**. No account, no install, no server. Your collection is saved right
in your browser, and you can export it to a file to back it up or move it to another device.

## Try it

- **Online:** once GitHub Pages is enabled (see below) it lives at
  `https://coastlinecrm.github.io/Droid-Tycoons/`
- **Offline:** download `index.html` and double-click it — it works the same locally.

## How your data is saved

There is **no backend**. When you mark a droid collected, that choice is written to your browser's
`localStorage` on your own device — nobody else sees it, and it stays there between visits.

| Action | Result |
|---|---|
| Mark droids, close tab, come back later | ✅ Your marks are still there |
| Open on a different device or browser | ⚠️ Separate collection (won't sync) |
| Clear browser data / incognito | ❌ Marks are wiped |

To move your collection or keep a backup, use **⬇ Export** (downloads a small `.json`) and
**⬆ Import** to load it back. That's your safety net and it works with zero servers.

## Using the tracker

- **Finish tabs** — switch between Default / Gold / Diamond / Rainbow / Beskar. Each tracks its own count.
- **Checkmark badge** (top-right of a card) — quick-toggle "collected" for the current finish.
- **Click a card** — opens details and lets you toggle each finish individually plus the ✨ shiny variant.
- **Search / filters** — filter by name, role, perk, rarity, or collected/missing.
- **Milestone bar** — shows progress toward the next collection reward.

## Enabling GitHub Pages (one-time, ~20 seconds)

1. Go to the repo on GitHub → **Settings** → **Pages** (left sidebar).
2. Under **Build and deployment → Source**, choose **Deploy from a branch**.
3. Set **Branch** to `main` and folder to `/ (root)`, then **Save**.
4. Wait ~1 minute, then visit `https://coastlinecrm.github.io/Droid-Tycoons/`.

Every push to `main` afterward updates the live site automatically.

## Editing the droid catalog

All droid data lives in one place: the `DROIDEX_DATA` array inside `index.html` (near the top of
the `<script>`). The included ~10 entries are **samples** to get you started (PIT uses its real
in-game values). Add the rest by copying an entry:

```js
{ id: "pit", name: "PIT", rarity: "Common", role: "Worker", perk: "10% Droid Crafting Speed", image: "" },
```

- `id` — unique, lowercase, no spaces (used to save collection state — don't reuse).
- `rarity` — one of: `Common`, `Rare`, `Epic`, `Legendary`, `Mythic`.
- `role` — free text (e.g. `Worker`, `Combat`, `Gatherer`, `Support`). Roles appear in the filter automatically.
- `perk` — the droid's bonus text.
- `image` — a URL to art, or `""` for the placeholder icon.

The `CONFIG` block just above `DROIDEX_DATA` controls finishes, rarity colors, milestones, and the
shiny multiplier — edit those to match the game as it evolves.

---

*Not affiliated with the Droid Tycoons developers — a community tool.*
