CREATE TABLE persons (
    id SERIAL PRIMARY KEY,
    vivo_uri VARCHAR(256),
    label VARCHAR(256),
    first_name VARCHAR(256),
    last_name VARCHAR(256),
    contact_information JSON,
    publications JSON,
    projects JSON
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    vivo_uri VARCHAR(256),
    label VARCHAR(256),
    researchers JSON
);

CREATE TABLE publications (
    id SERIAL PRIMARY KEY,
    vivo_uri VARCHAR(256),
    label VARCHAR(256),
    authors JSON
);
