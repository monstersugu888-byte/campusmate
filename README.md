# CampusMate 🎓

**Your campus, organized.** CampusMate is a responsive student productivity dashboard and campus marketplace starter project.

## Features

- Student dashboard with task counts, completion rate, and weekly progress
- Create, complete, filter, search, and delete tasks
- Weekly calendar with upcoming deadlines
- Campus marketplace with search, category filters, sorting, and demo listings
- Add a marketplace listing
- Editable student profile
- Browser-local persistence, JSON data export, and reset option
- Responsive layout for mobile, tablet, and desktop
- Supabase database schema starter in `supabase/schema.sql`

## Tech stack

- HTML, CSS, vanilla JavaScript
- Browser localStorage for demo persistence
- Supabase-ready SQL schema for a future cloud-backed version
- Vercel static deployment

## Run locally

This is a static app. Open `index.html` in your browser, or run a local static server:

```bash
npx serve .
```

## Deploy on Vercel

1. Import this repository into Vercel.
2. Framework preset: **Other**.
3. Build command: leave empty.
4. Output directory: leave empty / project root.
5. Deploy.

The repository includes `vercel.json` for clean static hosting. Pushes to the connected production branch will redeploy automatically once Git integration is enabled.

## Data and security notes

The current UI is a working local-first demo. Tasks, listings, and profile data live in the browser that created them; they are not shared between users or devices. Marketplace listings are sample data, and the interest button is informational only — there is no messaging or checkout system.

The Settings page can store a Supabase URL and public key locally, but cloud authentication and sync are **not wired into this static starter yet**. Do not enter a Supabase service-role key in the browser. See `supabase/schema.sql` for the starting schema and row-level security policies before implementing real sign-in and shared marketplace data.

## Roadmap

- [ ] Supabase email authentication and user profiles
- [ ] Cloud-synced tasks and marketplace listings
- [ ] Image uploads with Supabase Storage
- [ ] Seller contact flow and listing moderation
- [ ] Automated tests and accessibility audit

## License

MIT
