CREATE TABLE IF NOT EXISTS programs (
    id SERIAL PRIMARY KEY,
    program_name VARCHAR(50) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS events (
    id SERIAL PRIMARY KEY,
    event_name VARCHAR(70) NOT NULL,
    start_time TIME NOT NULL,
    duration INTEGER NOT NULL,
    program_id INT NOT NULL REFERENCES programs(id)
);

CREATE TABLE IF NOT EXISTS participants (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS participants_of_events (
    participant_id INT REFERENCES participants(id) NOT NULL ,
    event_id INT REFERENCES events(id) NOT NULL ,
    PRIMARY KEY (participant_id, event_id)
);

CREATE TABLE IF NOT EXISTS companies (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS organizers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(30) NOT NULL UNIQUE,
    company_id INT NOT NULL REFERENCES companies(id)
);

CREATE TABLE IF NOT EXISTS organizers_of_events (
    organizer_id INT REFERENCES organizers(id) NOT NULL ,
    event_id INT REFERENCES events(id) NOT NULL ,
    PRIMARY KEY (organizer_id, event_id)
);