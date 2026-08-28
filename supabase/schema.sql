-- Run this in the Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.cars (
 id uuid primary key default gen_random_uuid(), customer_name text not null, phone text, vehicle_number text not null, car_model text,
 wash_type text not null check (wash_type in ('Daily Clean','Alternate Days','Weekly Twice','Weekly Once','One-Time Wash')),
 amount numeric(12,2) not null check (amount >= 0), service_date date, notes text, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table if not exists public.payments (
 id uuid primary key default gen_random_uuid(), car_id uuid not null references public.cars(id) on delete cascade, amount numeric(12,2) not null check (amount > 0),
 payment_method text not null check (payment_method in ('Cash','UPI','Card','Bank Transfer','Other')), payment_date timestamptz not null default now(), note text, created_at timestamptz not null default now());
create index if not exists cars_vehicle_number_idx on public.cars (vehicle_number);
create index if not exists cars_customer_name_idx on public.cars (customer_name);
create index if not exists payments_car_id_idx on public.payments (car_id);
create index if not exists payments_payment_date_idx on public.payments (payment_date desc);
create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists cars_updated_at on public.cars;
create trigger cars_updated_at before update on public.cars for each row execute function public.set_updated_at();
-- Deliberately open initial MVP: enable RLS but permit public browser access. Replace these with authenticated rules before going public.
alter table public.cars enable row level security; alter table public.payments enable row level security;
create policy "Open MVP car access" on public.cars for all using (true) with check (true);
create policy "Open MVP payment access" on public.payments for all using (true) with check (true);

