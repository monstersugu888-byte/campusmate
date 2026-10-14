-- CampusMate starter schema for Supabase (PostgreSQL)
-- Review and run in the Supabase SQL editor after creating a project.
-- This schema does not itself connect the static demo UI to cloud data.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Student' check (char_length(display_name) <= 80),
  campus text check (char_length(campus) <= 120),
  course text check (char_length(course) <= 120),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 160),
  category text not null default 'Study' check (category in ('Study','Assignment','Exam','Personal')),
  priority text not null default 'Medium' check (priority in ('Low','Medium','High')),
  due_date date,
  is_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.marketplace_listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 120),
  description text check (char_length(description) <= 2000),
  category text not null default 'Other' check (category in ('Books','Electronics','Stationery','Hostel','Other')),
  price numeric(10,2) not null check (price >= 0),
  condition text not null default 'Good condition' check (char_length(condition) <= 80),
  image_url text,
  status text not null default 'active' check (status in ('active','sold','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.tasks enable row level security;
alter table public.marketplace_listings enable row level security;

create policy "Profiles are readable by owner" on public.profiles
  for select to authenticated using (auth.uid() = id);
create policy "Users can create their own profile" on public.profiles
  for insert to authenticated with check (auth.uid() = id);
create policy "Users can update their own profile" on public.profiles
  for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "Users can view their own tasks" on public.tasks
  for select to authenticated using (auth.uid() = user_id);
create policy "Users can create their own tasks" on public.tasks
  for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can update their own tasks" on public.tasks
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete their own tasks" on public.tasks
  for delete to authenticated using (auth.uid() = user_id);

-- Signed-in users can browse active listings. Only sellers can change their own listings.
create policy "Active listings are visible to authenticated users" on public.marketplace_listings
  for select to authenticated using (status = 'active' or auth.uid() = seller_id);
create policy "Users can create their own listings" on public.marketplace_listings
  for insert to authenticated with check (auth.uid() = seller_id);
create policy "Sellers can update their own listings" on public.marketplace_listings
  for update to authenticated using (auth.uid() = seller_id) with check (auth.uid() = seller_id);
create policy "Sellers can delete their own listings" on public.marketplace_listings
  for delete to authenticated using (auth.uid() = seller_id);

-- Create a profile row when a user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'display_name', 'Student'))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
