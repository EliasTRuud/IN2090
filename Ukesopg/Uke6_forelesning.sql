-- https://www.uio.no/studier/emner/matnat/ifi/IN2090/h23/undervisningsmateriale/06-eksempler.pdf

--Realiser databasen fra diagrammet i et skjema ved navn "forum":

--Lag skjema:
BEGIN;
DROP SCHEMA forum CASCADE;

CREATE SCHEMA forum;

CREATE TABLE forum.member(
    username text PRIMARY KEY CHECK (username NOT LIKE '% %'), -- opg.1 
    mail text CHECK  (mail ~  '^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'), -- opg.2 regex for mail
    --member_since date CHECK (member_since <= current_date),
    member_since timestamp CHECK (member_since >= now()) -- opg.3
    mem_type text CHECK (mem_type IN ('normal', 'admin')) DEFAULT 'normal'
);
CREATE TABLE forum.thread(
    tid int PRIMARY KEY,
    navn text
);
CREATE TABLE orum.log_entry(
    lid int PRIMARY KEY,
    username text REFERENCES forum.member(username),
    log_in timestamp,
    log_out timestamp
);
CREATE TABLE forum.post(
    posted_at timestamp CHECK (posted_at <= now()), -- opg 5
    username text REFERENCES forum.member(username), -- FK -> member(username)
    thread int REFERENCES forum.thread(tid), -- FK -> thread(tid)
    content text,
    CONSTRAINT post_pk PRIMARY KEY (posted_at, username, thread)
); -- PK {posted_at, username, thread}

COMMIT;


-- 1. Username skal ikke kunne inneholde mellomrom
-- 2. Email skal ha form som en mail, altså <person>@<url> (vanskelig, ikke pensum!)
-- 3. MemberSince skal være før eller lik dagens dato
-- 4. type er enten 'normal' eller 'admin', med 'normal' som standard/defaultverdi
-- 5. posted_at skal være før eller lik nåværende tidspunkt
-- 6. content skal være en ikke-tom streng
-- 7. log_in skal ikke være NULL og være før eller lik nåværende tidspunkt
-- 8. log_out skal være etter log_in