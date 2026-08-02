-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

INSERT INTO robot_types (name, description)
VALUES
    ('DELIVERY', 'Transports packages and materials between locations'),
    ('INSPECTION', 'Inspects equipment and industrial facilities'),
    ('SECURITY', 'Monitors areas for security and safety issues'),
    ('MAINTENANCE', 'Performs automated maintenance tasks');

INSERT INTO locations (name, zone, description)
VALUES
    ('Warehouse A', 'Storage Zone', 'Main storage and package handling area'),
    ('Factory Floor', 'Assembly Zone', 'Industrial assembly and manufacturing area'),
    ('Charging Station 1', 'Energy Zone', 'Primary charging station for robots'),
    ('Security Gate', 'Entrance Zone', 'Main entrance monitoring area'),
    ('Maintenance Bay', 'Service Zone', 'Area for robot repairs and maintenance');

INSERT INTO robots (
    serial_number,
    name,
    robot_type_id,
    location_id,
    status,
    battery_level
)
VALUES
    ('RF-DEL-001', 'Atlas', 1, 1, 'ACTIVE', 87.5),
    ('RF-INS-001', 'Scout', 2, 2, 'ACTIVE', 62.0),
    ('RF-SEC-001', 'Guardian', 3, 4, 'ACTIVE', 94.0),
    ('RF-MNT-001', 'Fixer', 4, 5, 'IN_MAINTENANCE', 35.0),
    ('RF-DEL-002', 'Runner', 1, 3, 'OFFLINE', 12.5),
    ('RF-INS-002', 'Observer', 2, 2, 'ACTIVE', 76.0);

INSERT INTO missions (
    robot_id,
    mission_type,
    start_location_id,
    destination_location_id,
    status,
    started_at,
    completed_at
)
VALUES
    (1, 'DELIVERY', 1, 3, 'COMPLETED',
     '2026-07-15 09:00:00',
     '2026-07-15 09:45:00'),

    (2, 'INSPECTION', 2, 5, 'ACTIVE',
     '2026-07-15 10:00:00',
     NULL),

    (3, 'PATROL', 4, 1, 'COMPLETED',
     '2026-07-15 11:00:00',
     '2026-07-15 12:00:00'),

    (6, 'INSPECTION', 2, 5, 'FAILED',
     '2026-07-16 14:00:00',
     '2026-07-16 14:20:00');

INSERT INTO mission_events (
    mission_id,
    event_type,
    description
)
VALUES
    (1, 'STARTED', 'Robot began delivery mission'),

    (1, 'ARRIVED', 'Robot arrived at charging station'),

    (1, 'COMPLETED', 'Delivery mission completed successfully'),

    (2, 'STARTED', 'Inspection mission started'),

    (2, 'OBSTACLE_DETECTED', 'Obstacle detected near assembly zone'),

    (3, 'PATROL_COMPLETED', 'Security patrol completed successfully'),

    (4, 'SENSOR_FAILURE', 'Inspection sensor stopped responding');

INSERT INTO sensors (
    robot_id,
    sensor_type,
    serial_number,
    status
)
VALUES
    (1, 'TEMPERATURE', 'SEN-TEMP-001', 'ACTIVE'),
    (1, 'BATTERY', 'SEN-BAT-001', 'ACTIVE'),
    (2, 'DISTANCE', 'SEN-DIST-001', 'ACTIVE'),
    (2, 'TEMPERATURE', 'SEN-TEMP-002', 'ACTIVE'),
    (3, 'MOTION', 'SEN-MOT-001', 'ACTIVE'),
    (4, 'TEMPERATURE', 'SEN-TEMP-003', 'FAULTY'),
    (6, 'DISTANCE', 'SEN-DIST-002', 'ACTIVE');

INSERT INTO sensor_readings (
    sensor_id,
    value,
    unit
)
VALUES
    (1, 35.2, 'C'),
    (1, 36.8, 'C'),
    (1, 42.5, 'C'),

    (2, 87.5, 'PERCENT'),
    (2, 75.0, 'PERCENT'),

    (3, 2.5, 'METERS'),
    (3, 1.2, 'METERS'),

    (4, 38.1, 'C'),
    (4, 41.7, 'C'),

    (5, 1.0, 'MOTION'),

    (6, 90.5, 'C'),

    (7, 4.2, 'METERS');

INSERT INTO maintenance_records (
    robot_id,
    issue_type,
    description,
    status,
    reported_at,
    resolved_at
)
VALUES
    (
        4,
        'BATTERY',
        'Battery capacity has significantly decreased',
        'IN_PROGRESS',
        '2026-07-15 08:00:00',
        NULL
    ),

    (
        6,
        'SENSOR',
        'Distance sensor stopped responding during inspection',
        'OPEN',
        '2026-07-16 14:30:00',
        NULL
    ),

    (
        1,
        'SOFTWARE',
        'Navigation software updated',
        'COMPLETED',
        '2026-07-10 09:00:00',
        '2026-07-10 10:30:00'
    );


-- Find all robots currently active.
SELECT *
FROM robots
WHERE status = 'ACTIVE';

-- Find robots whose battery level is below 25%.
SELECT
    name,
    battery_level,
    status
FROM robots
WHERE battery_level < 25
ORDER BY battery_level ASC;

-- Find all completed missions.
SELECT
    id,
    robot_id,
    mission_type,
    status,
    started_at,
    completed_at
FROM missions
WHERE status = 'COMPLETED';

-- Display the most recent sensor readings.
SELECT
    sensor_id,
    value,
    unit,
    recorded_at
FROM sensor_readings
ORDER BY recorded_at DESC;

-- Register a new robot in the fleet.
INSERT INTO robots (
    serial_number,
    name,
    robot_type_id,
    location_id,
    status,
    battery_level
)
VALUES (
    'RF-DEL-003',
    'Courier',
    1,
    1,
    'ACTIVE',
    92.0
);

-- Update a robot's battery level after charging.
UPDATE robots
SET battery_level = 100.0
WHERE id = 5;

-- Update the current location of a robot.
UPDATE robots
SET location_id = 3
WHERE id = 1;

-- Mark an active mission as completed.
UPDATE missions
SET
    status = 'COMPLETED',
    completed_at = CURRENT_TIMESTAMP
WHERE id = 2;

-- Remove a test robot that was accidentally registered.
DELETE FROM robots
WHERE serial_number = 'RF-DEL-003';

-- Display each robot with its type and current location.
SELECT
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

-- Display each mission and the robot assigned to it.
SELECT
    missions.id AS mission_id,
    robots.name AS robot_name,
    missions.mission_type,
    missions.status
FROM missions
JOIN robots
    ON missions.robot_id = robots.id;

-- Display which robot owns each sensor.
SELECT
    robots.name AS robot_name,
    sensors.sensor_type,
    sensors.serial_number,
    sensors.status
FROM sensors
JOIN robots
    ON sensors.robot_id = robots.id;

-- Display sensor readings together with the robot that produced them.
SELECT
    robots.name AS robot_name,
    sensors.sensor_type,
    sensor_readings.value,
    sensor_readings.unit,
    sensor_readings.recorded_at
FROM sensor_readings
JOIN sensors
    ON sensor_readings.sensor_id = sensors.id
JOIN robots
    ON sensors.robot_id = robots.id
ORDER BY sensor_readings.recorded_at DESC;

-- Display every robot and the number of missions it has received.
SELECT
    robots.name AS robot_name,
    COUNT(missions.id) AS total_missions
FROM robots
LEFT JOIN missions
    ON robots.id = missions.robot_id
GROUP BY robots.id
ORDER BY total_missions DESC;

-- Show robots requiring attention.
SELECT *
FROM robots_requiring_attention;

-- Show the complete robot overview.
SELECT *
FROM robot_overview;

-- Show mission performance by robot.
SELECT *
FROM mission_summary;

-- Count how many robots exist in each status.
SELECT
    status,
    COUNT(*) AS robot_count
FROM robots
GROUP BY status;

-- Calculate the average battery level for each robot type.
SELECT
    robot_types.name AS robot_type,
    ROUND(AVG(robots.battery_level), 2) AS average_battery
FROM robots
JOIN robot_types
    ON robots.robot_type_id = robot_types.id
GROUP BY robot_types.id;

-- Count missions by their current status.
SELECT
    status,
    COUNT(*) AS total_missions
FROM missions
GROUP BY status
ORDER BY total_missions DESC;

-- Find the highest recorded value for every sensor.
SELECT
    sensor_id,
    MAX(value) AS highest_reading
FROM sensor_readings
GROUP BY sensor_id;

-- Find robots whose battery is below the fleet average.
SELECT
    name,
    battery_level
FROM robots
WHERE battery_level < (
    SELECT AVG(battery_level)
    FROM robots
)
ORDER BY battery_level ASC;

-- Find robots that have completed at least one mission.
SELECT
    name
FROM robots
WHERE id IN (
    SELECT robot_id
    FROM missions
    WHERE status = 'COMPLETED'
);

-- Find the robot with the highest number of missions.
SELECT
    name
FROM robots
WHERE id = (
    SELECT robot_id
    FROM missions
    GROUP BY robot_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Generate a performance report for every robot.
SELECT
    robots.name AS robot_name,
    robot_types.name AS robot_type,
    robots.status,
    robots.battery_level,
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
JOIN robot_types
    ON robots.robot_type_id = robot_types.id
LEFT JOIN missions
    ON robots.id = missions.robot_id
GROUP BY robots.id
ORDER BY completed_missions DESC;

-- Identify robots that may require maintenance attention.
SELECT
    robots.name AS robot_name,
    robots.status AS robot_status,
    robots.battery_level,
    maintenance_records.issue_type,
    maintenance_records.status AS maintenance_status,
    maintenance_records.reported_at
FROM robots
JOIN maintenance_records
    ON robots.id = maintenance_records.robot_id
WHERE maintenance_records.status <> 'COMPLETED'
ORDER BY maintenance_records.reported_at ASC;

-- Display the highest reading recorded for each sensor.
SELECT
    robots.name AS robot_name,
    sensors.sensor_type,
    MAX(sensor_readings.value) AS highest_value,
    sensor_readings.unit
FROM robots
JOIN sensors
    ON robots.id = sensors.robot_id
JOIN sensor_readings
    ON sensors.id = sensor_readings.sensor_id
GROUP BY
    robots.id,
    sensors.id,
    sensor_readings.unit
ORDER BY highest_value DESC;

-- Calculate the mission success rate for each robot.
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
    ROUND(
        100.0 * SUM(
            CASE
                WHEN missions.status = 'COMPLETED'
                THEN 1
                ELSE 0
            END
        ) / COUNT(missions.id),
        2
    ) AS success_rate
FROM robots
JOIN missions
    ON robots.id = missions.robot_id
GROUP BY robots.id
HAVING COUNT(missions.id) > 0
ORDER BY success_rate DESC;


