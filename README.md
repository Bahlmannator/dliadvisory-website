# DLI Advisory Website

Static site for **dliadvisory.com**. Single-file HTML pages (self-contained, images embedded), ready to deploy on any static host (GitHub Pages, Netlify, Cloudflare Pages).

## How this site is run (read this first)

The site is hosted on **GitHub Pages** and deploys itself automatically. Here is the whole picture in plain terms.

**Where the files live.** The working copy lives in the Second Brain vault at
`projects/internal/dliadvisory-website-repo/`. That same folder is a Git repository
connected to GitHub at `https://github.com/Bahlmannator/dliadvisory-website`. Editing
the files in the vault and pushing is the way changes are made. (If the repo is later
moved into a DLI GitHub organisation, update the remote URL in `push-to-github.sh`.)

**How a change goes live (three commands).** After editing any page, open Terminal in
this folder and run:

```
git add -A
git commit -m "Describe the change"
git push origin main
```

The GitHub login is saved in the Mac keychain, so the push will not ask for a password.
Pushing to `main` automatically triggers the deploy (see next point). The live site
updates roughly one to two minutes later.

**How the deploy works.** `.github/workflows/deploy-pages.yml` is a GitHub Actions
workflow that runs on every push to `main`. It publishes the repo to GitHub Pages with
no build step. Progress and the live URL are visible in the repo's **Actions** tab. It
can also be run manually from there ("Run workflow").

**The live address.** `dliadvisory.com` (and `www.dliadvisory.com`) point at GitHub
Pages via DNS. The `CNAME` file in this repo holds the domain; do not delete it. HTTPS
is provided automatically by GitHub.

**Working with Claude (Cowork).** In a Cowork session, Claude can edit these files
directly in the vault and prepare the commit. The one manual step is running the three
commands above to push (Claude cannot push on your behalf from Cowork). Everything after
the push is automatic.

**That is the entire operating model.** No servers to manage, no Netlify, no build
tooling. Edit in the vault, push, done.

## Pages

| File | Title | Source (vault) |
|---|---|---|
| `index.html` | DLI Advisory, Africa's Dedicated Sell-Side Exit Practice | `resources/marketing-collateral/dliadvisory-latest.html` |
| `exit-deficit.html` | The Exit Deficit explainer | `resources/marketing-collateral/dli-exit-deficit-explainer.html` |
| `exit-journey-widget.html` | Exit journey interactive widget | `resources/marketing-collateral/dli-exit-journey-widget.html` |
| `platform.html` | Strategic Exit Partnership Platform | `resources/marketing-collateral/dli-platform-v3.html` |

### Alternates (not part of the live site, kept for reference)

| File | Notes |
|---|---|
| `alternates/homepage-v13-feature-rich.html` | Heavier "feature-rich" homepage variant. Candidate alternative to `index.html`. |
| `alternates/homepage-lean.html` | Lean 40KB homepage, "Exit Readiness for Private Equity & Corporates". |

## Provenance and the one thing to confirm

These files are copied from the Second Brain vault `resources/marketing-collateral/` set (the named "latest" versions, dated 14 Apr 2026). They have **not been byte-verified against what is currently live on dliadvisory.com** via Netlify. Before treating this repo as the source of truth, confirm `index.html` matches the live homepage (or swap in `alternates/homepage-v13-feature-rich.html` if that is the live one).

Full version history of every iteration lives in the vault at `archive/html-version-history/` (`dliadvisory_1.html` through `dliadvisory_19.html`, plus the homepage and platform series).

## Analytics / tracking (important on redeploy)

The previous host injected visitor-identification analytics **at the edge**, not in the HTML source. Because they were edge-injected, **they are not present in these files**. On a new host you must either re-add the analytics snippets before `</head>` on each page, or re-apply edge injection on the new platform. The canonical snippets and the cross-domain whitelist rule are held privately in the internal operations notes, not in this public repo.

## Deploy notes

- `.nojekyll` is included so GitHub Pages serves files as-is (no Jekyll processing).
- Pages are standalone with no cross-page links, so filenames can be changed freely without breaking navigation.
- No build step. Push and serve.

## How to publish

**Step 1, first push.** Create an empty repo in the DLI Team GitHub (no README, license, or .gitignore). Open `push-to-github.sh`, set `REMOTE_URL` to the new repo URL, then run `bash push-to-github.sh`.

**Step 2, turn on Pages.** In the repo: Settings > Pages > Build and deployment > Source = **GitHub Actions**.

**Step 3, automatic from then on.** `.github/workflows/deploy-pages.yml` redeploys the site on every push to `main` (and can be run manually from the Actions tab). The live URL appears in the Actions run summary.

**Custom domain (dliadvisory.com).** Once Pages is live, add the domain under Settings > Pages > Custom domain, then point DNS at GitHub Pages. Re-add the analytics trackers (see Analytics section above) since the edge injection does not carry over from the previous host.
