drop table if exists app_user cascade;
create table app_user
(
  id        text primary key default gen_random_uuid(),
  email     text not null,
  firstname text not null,
  lastname  text not null,
  role      text
);

drop table if exists app_credentials cascade;
create table app_credentials
(
  id       text  primary key default gen_random_uuid(),
  password text not null
);

drop table if exists organizations cascade;
create table organizations
(
  id   text  primary key default gen_random_uuid(),
  name text,
  tags text[]
);

drop table if exists projects cascade;
create table projects
(
  id   text primary key  default gen_random_uuid(),
  name text,
  tags text[],

  organizationId text references organizations(id)
);

drop table if exists teams cascade;
create table teams
(
  id   text primary key  default gen_random_uuid(),
  name text,
  tags text[],

  projectId text references projects(id)
);

drop table if exists tasks cascade;
create table tasks (
  id   text primary key  default gen_random_uuid(),
  activity text not null,
  comment text,
  duration integer,
  date timestamptz,
  status text,

  "user" text references app_user(id),
  team text references teams(id)
);

insert into app_user (email, firstname, lastname, role) values ('text@example.com', 'John', 'Doe', 'admin');
insert into app_credentials (password) values ('password');
