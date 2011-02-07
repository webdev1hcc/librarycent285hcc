-- addEntryFuncs.sql - to add functions to make it easier to enter data
-- make sure language is available
drop language if exists plpgsql cascade;
create language plpgsql;

-- function to insert Author and return id from authors record
create or replace function insertAuthor(_first text, _last text, _email text)
  returns integer as
  $func$
  begin
    execute 'insert into authors (first_name, last_name,email) values ('
      || quote_literal(_first) || ',' || quote_literal(_last) ||
      ',' || quote_literal(_email) || ')';
    return currval('author_id_seq');
  end;
  $func$
  language 'plpgsql';
  
-- function to insert Book and return id from books record
create or replace function insertBook(_title text, _isbn text)
  returns integer as
  $func$
  begin
    execute 'insert into books (title, isbn) values ('
      || quote_literal(_title) || ',' || quote_literal(_isbn) ||
      ')';
    return currval('book_id_seq');
  end;
  $func$
  language 'plpgsql';
  
-- function to insert author and book in one process
create or replace function insertAuthBook(_fname text,_lname text,
  _email text,_title text,_isbn text)
  returns boolean as
  $func$
  declare
    sql1 text;
    sql2 text;
    authid integer;
    bookid integer;
  begin
    sql1 := 'coalesce((select id from authors where email = ' || ''
      || quote_literal(_email) || '' || ')' || ',insertAuthor(' 
      || '''' || _fname || '''' || ',' || '''' ||  _lname || '''' || 
      ',' || '''' ||  _email || '''' || '))';
    sql2 := 'coalesce((select id from books where isbn = ' || ''
      || quote_literal(_isbn) || '' || ')' || ',insertBook(' ||
      '''' || _title || '''' || ',' || '''' || _isbn || '''' || '))';
    execute 'insert into author_book (author_id,book_id) values ('
      || sql1 || ',' || sql2 || ')';
    return 't';
  end;
  $func$
  language 'plpgsql';
  
-- rule to aid in inserting 
create or replace rule auth_book_insert as on insert to author_book_view
  do instead select insertAuthBook(new.first_name,new.last_name,
  new.email,new.title,new.isbn);
