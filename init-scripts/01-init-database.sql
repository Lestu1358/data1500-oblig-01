-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller
-- Opprett tabeller

CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    phone VARCHAR(15),
    email VARCHAR(255),
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

CREATE TABLE station (
    station_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE lock (
    lock_id SERIAL PRIMARY KEY,
    station_id INTEGER REFERENCES station(station_id),
    lock_number INTEGER
);

CREATE TABLE bike (
    bike_id SERIAL PRIMARY KEY,
    current_station_id INTEGER REFERENCES station(station_id),
    current_lock_id INTEGER REFERENCES lock(lock_id)
);

CREATE TABLE rental (
    rental_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customer(customer_id),
    bike_id INTEGER REFERENCES bike(bike_id),
    rented_at TIMESTAMP,
    returned_at TIMESTAMP,
    amount NUMERIC(10,2)
);




-- Sett inn testdata
INSERT INTO customer (phone, email, first_name, last_name) VALUES
('90000001','ola@test.no','Ola','Nordmann'),
('90000002','kari@test.no','Kari','Nordmann'),
('90000003','per@test.no','Per','Hansen'),
('90000004','anne@test.no','Anne','Olsen'),
('90000005','lars@test.no','Lars','Johansen');

INSERT INTO station (name, address) VALUES
('Sentrum','Gate 1'),
('Stasjon Øst','Gate 2'),
('Stasjon Vest','Gate 3'),
('Universitetet','Gate 4'),
('Parken','Gate 5');

INSERT INTO lock (station_id, lock_number)
SELECT s, l
FROM generate_series(1,5) AS s,
     generate_series(1,20) AS l;

INSERT INTO bike (current_station_id, current_lock_id)
SELECT
    (random()*4 + 1)::int,
    (random()*99 + 1)::int
FROM generate_series(1,100);

INSERT INTO rental (customer_id, bike_id, rented_at, returned_at, amount)
SELECT
    (random()*4 + 1)::int,
    (random()*99 + 1)::int,
    NOW() - interval '2 days',
    NOW() - interval '1 day',
    (random()*50 + 10)::numeric(10,2)
FROM generate_series(1,50);



-- DBA setninger (rolle: kunde, bruker: kunde_1)
CREATE ROLE kunde;
CREATE USER kunde_1 WITH password 'kunde123';
GRANT kunde TO kunde_1;

GRANT SELECT ON customer TO kunde;
GRANT SELECT ON station TO kunde;
GRANT SELECT ON lock TO kunde;
GRANT SELECT ON bike TO kunde;
GRANT SELECT ON rental TO kunde;




-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;