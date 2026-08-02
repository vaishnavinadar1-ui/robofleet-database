-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
PRAGMA foreign_keys = ON;

CREATE TABLE robot_types (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL
);

CREATE TABLE locations (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    zone TEXT NOT NULL,
    description TEXT
);

CREATE TABLE robots (
    id INTEGER PRIMARY KEY,
    serial_number TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    robot_type_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    battery_level REAL NOT NULL DEFAULT 100.0,
    registered_at NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (robot_type_id)
    REFERENCES robot_types(id),

    FOREIGN KEY (location_id)
    REFERENCES locations(id),

    CHECK (battery_level >= 0 AND battery_level <= 100),

    CHECK (
    status IN ('ACTIVE', 'IN_MAINTENANCE', 'OFFLINE', 'RETIRED')
    )
);

CREATE TABLE missions (
    id INTEGER PRIMARY KEY,
    robot_id INTEGER NOT NULL,
    mission_type TEXT NOT NULL,
    start_location_id INTEGER NOT NULL,
    destination_location_id INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'ASSIGNED',
    started_at NUMERIC,
    completed_at NUMERIC,

    FOREIGN KEY (robot_id)
    REFERENCES robots(id),

    FOREIGN KEY (start_location_id)
    REFERENCES locations(id),

    FOREIGN KEY (destination_location_id)
    REFERENCES locations(id),

    CHECK (
        mission_type IN ('DELIVERY', 'INSPECTION', 'PATROL', 'EMERGENCY')
        ),

    CHECK (
        status IN ('ASSIGNED', 'ACTIVE', 'COMPLETED', 'FAILED', 'CANCELLED')
    ),
    CHECK (
        completed_at IS NULL OR started_at IS NOT NULL
    )
);

CREATE TABLE mission_events (
    id INTEGER PRIMARY KEY,
    mission_id INTEGER NOT NULL,
    event_type TEXT NOT NULL,
    description TEXT NOT NULL,
    recorded_at NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (mission_id)
    REFERENCES missions(id)
    ON DELETE CASCADE
);

CREATE TABLE sensors (
    id INTEGER PRIMARY KEY,
    robot_id INTEGER NOT NULL,
    sensor_type TEXT NOT NULL,
    serial_number TEXT NOT NULL UNIQUE,
    installed_at NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL DEFAULT 'ACTIVE',

    FOREIGN KEY (robot_id)
    REFERENCES robots(id),

    CHECK (
    status IN ('ACTIVE', 'INACTIVE', 'FAULTY')
    )
);

CREATE TABLE sensor_readings (
    id INTEGER PRIMARY KEY,
    sensor_id INTEGER NOT NULL,
    value REAL NOT NULL,
    unit TEXT NOT NULL,
    recorded_at NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (sensor_id)
    REFERENCES sensors(id)
    ON DELETE CASCADE
);

CREATE TABLE maintenance_records (
    id INTEGER PRIMARY KEY,
    robot_id INTEGER NOT NULL,
    issue_type TEXT NOT NULL,
    description TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'OPEN',
    reported_at NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at NUMERIC,

    FOREIGN KEY (robot_id)
    REFERENCES robots(id),

    CHECK (
    status IN ('OPEN', 'IN_PROGRESS', 'COMPLETED')
    ),

    CHECK (
    resolved_at IS NULL OR status = 'COMPLETED'
    )
);

CREATE INDEX idx_robots_status
ON robots(status);

CREATE INDEX idx_missions_robot_id
ON missions(robot_id);

CREATE INDEX idx_missions_status
ON missions(status);

CREATE INDEX idx_sensor_readings_sensor_time
ON sensor_readings(sensor_id, recorded_at);

CREATE INDEX idx_maintenance_robot_status
ON maintenance_records(robot_id, status);

CREATE VIEW robot_overview AS
SELECT
    robots.id,
    robots.name AS robot_name,
    robot_types.name AS robot_type,
    locations.name AS current_location,
    robots.status,
    robots.battery_level
FROM robots
JOIN robot_types
    ON robots.robot_type_id = robot_types.id
JOIN locations
    ON robots.location_id = locations.id;

CREATE VIEW robots_requiring_attention AS
SELECT
    robots.id,
    robots.name,
    robots.status,
    robots.battery_level
FROM robots
WHERE robots.battery_level < 25
   OR robots.status = 'IN_MAINTENANCE'
   OR robots.status = 'OFFLINE';

CREATE VIEW mission_summary AS
SELECT
    robots.name AS robot_name,
    COUNT(missions.id) AS total_missions,
    SUM(
        CASE
            WHEN missions.status = 'COMPLETED'
            THEN 1
            ELSE 0
        END
    ) AS completed_missions,
    SUM(
        CASE
            WHEN missions.status = 'FAILED'
            THEN 1
            ELSE 0
        END
    ) AS failed_missions
FROM robots
LEFT JOIN missions
    ON robots.id = missions.robot_id
GROUP BY robots.id;


