-- makeLibrary.sql - SQL file to create library database
-- create sequences
drop sequence if exists user_id_seq cascade;
create sequence user_id_seq;
drop sequence if exists author_id_seq cascade;
create sequence author_id_seq;
drop sequence if exists book_id_seq cascade;
create sequence book_id_seq;

-- create tables
drop table if exists users cascade;
create table users(
  id integer not null primary key default nextval('user_id_seq'),
  name text,
  username text unique,
  password text,
  enc_pass text,
  salt text
);
drop table if exists authors cascade;
create table authors(
  id integer not null primary key default nextval('author_id_seq'),
  first_name text,
  last_name text,
  email text unique
);
drop table if exists books cascade;
create table books(
  id integer not null primary key default nextval('book_id_seq'),
  title text,
  genre text
);
drop table if exists author_book cascade;
create table author_book(
  author_id integer references authors(id),
  book_id integer references books(id)
);

-- create author_book_view
create or replace view author_book_view as
  select authors.id as authid,authors.first_name,authors,last_name,
  authors.email,books.id as bookid,books.title,books.genre from
  authors join author_book on authors.id=author_book.author_id join
  books on author_book.book_id=books.id;
