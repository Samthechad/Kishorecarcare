# Kishore Car Care

A responsive React + Vite dashboard for tracking car services, customer balances, and payment history. It uses Supabase as its database and is ready to deploy on Vercel.

## Local setup

1. Install dependencies with `npm install`.
2. Create a Supabase project.
3. In the Supabase SQL Editor, run [`supabase/schema.sql`](./supabase/schema.sql).
4. Copy `.env.example` to `.env`.
5. Add your credentials:
   ```env
   VITE_SUPABASE_URL=your_supabase_project_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```
6. Start the app with `npm run dev`.
7. Create a production build with `npm run build`.

## Supabase security

The supplied SQL deliberately creates open MVP RLS policies, allowing anonymous browser reads and writes. This suits an internal, unauthenticated dashboard only. Before exposing the app publicly, add Supabase Auth and replace those policies with user-scoped rules. Never use a service-role key in this frontend.

## Vercel deployment

1. Import the GitHub repository into Vercel.
2. Vercel will detect Vite. Use build command `npm run build` and output directory `dist`.
3. In **Project Settings → Environment Variables**, add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` for the required environments.
4. Deploy. `vercel.json` includes the SPA rewrite for safe refreshes.

## Notes

Payments are stored as individual records. Dashboard totals, payment status, and balances are calculated from those records, so payment history is never overwritten while editing a car.

