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

CREATE TABLE forum.post (
    tid int REFERENCES forum.thread(tid),
    username text REFERENCES forum.member(username),
    posted_at timestamp NOT NULL CHECK (posted_at <= now()),
    content text NOT NULL CHECK (content != ''),
    CONSTRAINT post_pk PRIMARY KEY (tid, username, posted_at)
);

CREATE TABLE forum.log_entry (
    lid SERIAL PRIMARY KEY,
    username text REFERENCES forum.member(username),
    log_in timestamp NOT NULL CHECK (log_in <= now()),
    log_out timestamp CHECK (log_out > log_in)
);

CREATE VIEW forum.logged_in AS
SELECT m.username,
    now() - l.log_in AS time_logged_in,
    m.mail
FROM forum.member as M
    INNER JOIN forum.log_entry AS l ON (m.username = l.username)
WHERE l.log_out IS NULL;

CREATE VIEW forum.dash_board AS
SELECT (
        SELECT count(*)
        FROM forum.logged_in --pulls from the View table
    ) AS active_users,
    (
        SELECT count(*)
        FROM forum.log_entry
        WHERE log_out >= current_date::timestamp --casting current_date to timestamp, meaning 00:00:00 midnight
            OR log_out IS NULL
    ) AS logins_today,
    (
        SELECT count(*)
        FROM forum.post
        WHERE posted_at >= current_date::timestamp
    ) AS posts_today,
    (
        SELECT count(*) total_nr_posts
        FROM forum.post
    ) AS total_posts;

COMMIT;


-- 1. Username skal ikke kunne inneholde mellomrom
-- 2. Email skal ha form som en mail, altså <person>@<url> (vanskelig, ikke pensum!)
-- 3. MemberSince skal være før eller lik dagens dato
-- 4. type er enten 'normal' eller 'admin', med 'normal' som standard/defaultverdi
-- 5. posted_at skal være før eller lik nåværende tidspunkt
-- 6. content skal være en ikke-tom streng
-- 7. log_in skal ikke være NULL og være før eller lik nåværende tidspunkt
-- 8. log_out skal være etter log_in