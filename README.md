# RoboFleet Database System 

## Overview

RoboFleet is a relational database system designed to manage and organize information for a fleet of robots. The database stores details about robots, their locations, assigned missions, sensors, and sensor readings.

The goal of this project is to demonstrate how database systems can be designed to manage complex real-world data using relational database concepts, SQL queries, and structured data relationships.

This project focuses on database design, data organization, and efficient retrieval of information using SQL.

---

## Problem Statement

Managing a large fleet of robots requires an organized system to store and track important information such as:

- Robot specifications
- Current locations
- Mission assignments
- Sensor information
- Sensor-generated data

The RoboFleet Database provides a structured solution for storing and managing this information while maintaining data consistency through relationships between tables.

---

## Features

- Store and manage robot details
- Track robot locations
- Create and manage missions
- Assign robots to missions
- Store sensor information
- Record sensor readings
- Retrieve information using SQL queries
- Maintain relationships between different data entities
- Use primary keys and foreign keys for data integrity

---

# Database Design

The database follows a relational database model consisting of the following entities:

## Robots

Stores information about each robot in the fleet.

**Attributes include:**
- Robot ID
- Robot name
- Model
- Status
- Battery level
- Location information

---

## Locations

Stores information about robot locations.

**Attributes include:**
- Location ID
- Location name
- Coordinates
- Area information

---

## Missions

Stores details about robot tasks and assignments.

**Attributes include:**
- Mission ID
- Mission name
- Description
- Start date
- End date
- Mission status

---

## Sensors

Stores information about sensors installed on robots.

**Attributes include:**
- Sensor ID
- Robot ID
- Sensor type
- Installation date

---

## Sensor Readings

Stores data collected from robot sensors.

**Attributes include:**
- Reading ID
- Sensor ID
- Reading value
- Timestamp

---

# Entity Relationship Diagram (ERD)

The database structure and relationships are represented using an Entity Relationship Diagram.

![RoboFleet ER Diagram](robofleet-erd.png)

---

# Relationships

The database contains the following relationships:

- One robot can have one or multiple sensors.
- One robot can perform multiple missions.
- One location can contain multiple robots.
- One sensor can generate multiple sensor readings.
- Foreign keys are used to connect related tables.

---

# Technologies Used

- SQL
- SQLite
- Relational Database Management Systems (RDBMS)
- Database Schema Design
- Entity Relationship Diagrams (ERD)
- Git and GitHub
