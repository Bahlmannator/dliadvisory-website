# Migrating dliadvisory.com from Netlify to GitHub Pages

Primary domain: **dliadvisory.com** (apex), with **www** redirecting to it.
DNS currently hosted at: **Netlify**.
Target host: **GitHub Pages** (repo `Bahlmannator/dliadvisory-website`).

Do these in order. The live cutover happens at Step 3 (DNS), so keep the Netlify
site running until Step 5 confirms GitHub is serving over HTTPS.

## Step 1 — Push the CNAME file (no effect on the live site yet)

The repo now contains a `CNAME` file holding `dliadvisory.com`. Push it:

```
git add -A
git commit -m "Add CNAME for dliadvisory.com"
git push origin main
```

## Step 2 — Tell GitHub the custom domain

Repo → Settings → Pages → Custom domain → enter `dliadvisory.com` → Save.
(GitHub will run a DNS check. It will fail until Step 3 is done — that's expected.)

## Step 3 — Repoint DNS in Netlify (this is the cutover)

Netlify → Domains → dliadvisory.com → DNS settings.

Apex (`dliadvisory.com`, host `@`):
- Remove the existing Netlify apex record (a `NETLIFY`/`ALIAS` record, or an `A`
  record pointing at a Netlify IP such as `75.2.60.5`).
- Add four `A` records, host `@`, pointing to GitHub Pages:
  - 185.199.108.153
  - 185.199.109.153
  - 185.199.110.153
  - 185.199.111.153

www (`www.dliadvisory.com`):
- Replace any existing `www` record with a `CNAME` record:
  - host `www`  →  value `bahlmannator.github.io`

(Optional IPv6 — add `AAAA` records, host `@`, if you want it:
2606:50c0:8000::153, 2606:50c0:8001::153, 2606:50c0:8002::153, 2606:50c0:8003::153)

## Step 4 — Wait for DNS to propagate

Usually minutes, up to a few hours. Back in GitHub Settings → Pages, the DNS
check should turn green. GitHub then automatically provisions a free HTTPS
certificate (Let's Encrypt). This can take a few minutes to ~an hour.

## Step 5 — Enforce HTTPS, then verify

Once the certificate is issued, tick **Enforce HTTPS** in Settings → Pages.
Then visit https://dliadvisory.com and https://www.dliadvisory.com and confirm
the site loads with a valid padlock.

## Step 6 — Decommission Netlify (only after Step 5 is confirmed)

- In Netlify, unpublish/delete the old site (the hosting), or set it to "stop
  publishing", so two versions aren't live.
- Leave Netlify DNS in place for now (it's still answering for the domain).
- Note: the old Netlify build still has the Knock 2 + Pipedrive snippets injected
  at the edge. Decommissioning it removes them along with the old site.

## Notes

- Short HTTPS gap: between the DNS cutover (Step 3) and the certificate being
  issued (Step 4), the site may briefly show a certificate warning. This is
  normal and clears automatically once GitHub provisions the cert.
- Rollback: if anything goes wrong, restore the original Netlify apex record and
  the `www` record in Netlify DNS, and traffic returns to Netlify.
