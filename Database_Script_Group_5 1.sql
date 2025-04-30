DROP SCHEMA IF EXISTS powerlifting_leaderboard;

-- Create the database (schema in MySQL)
CREATE DATABASE powerlifting_leaderboard;

-- Switch to the created database
USE powerlifting_leaderboard;

DROP TABLE IF EXISTS GYM_HISTORY;
DROP TABLE IF EXISTS LIFT_LOG;
DROP TABLE IF EXISTS ATHLETE;
DROP TABLE IF EXISTS COMPETITION_SCHEDULE;
DROP TABLE IF EXISTS EXERCISE;
DROP TABLE IF EXISTS GYM;
DROP TABLE IF EXISTS COACHES;
DROP TABLE IF EXISTS SPONSOR;
DROP TABLE IF EXISTS WEIGHT_CLASS;
DROP TABLE IF EXISTS LOCATION;
DROP TABLE IF EXISTS STATE;
DROP TABLE IF EXISTS CITY;
DROP TABLE IF EXISTS COUNTY;

-- 1. WEIGHT_CLASS table
CREATE TABLE WEIGHT_CLASS (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL
);

-- 2. STATE table
CREATE TABLE STATE (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL
);

-- 3. CITY table
CREATE TABLE CITY (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL
);

-- 4. COUNTY table
CREATE TABLE COUNTY (
    county_id INT AUTO_INCREMENT PRIMARY KEY,
    county_name VARCHAR(50) NOT NULL
);

-- 5. LOCATION table
CREATE TABLE LOCATION (
	location_id INT AUTO_INCREMENT PRIMARY KEY,
    state_id INT NOT NULL,
    county_id INT NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (state_id) REFERENCES STATE(state_id) ON DELETE CASCADE,
    FOREIGN KEY (county_id) REFERENCES COUNTY(county_id) ON DELETE CASCADE,
    FOREIGN KEY (city_id) REFERENCES CITY(city_id) ON DELETE CASCADE,
    UNIQUE KEY (state_id, county_id, city_id)
);

-- 6. SPONSOR table
CREATE TABLE SPONSOR (
    sponsor_id INT AUTO_INCREMENT PRIMARY KEY,
    sponsor_name VARCHAR(100) NOT NULL
);

-- 7. COACHES table
CREATE TABLE COACHES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coach_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 8. GYM table
CREATE TABLE GYM (
    gym_id INT AUTO_INCREMENT PRIMARY KEY,
    gym_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    location_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (location_id) REFERENCES LOCATION(location_id) ON DELETE CASCADE,
	UNIQUE KEY (address, location_id)
);

-- 9. ATHLETE table
CREATE TABLE ATHLETE (
    athlete_id INT AUTO_INCREMENT PRIMARY KEY,
    athlete_name VARCHAR(100) NOT NULL,
    gym_home INT,
    dob DATE NOT NULL,
    height DECIMAL(5, 2) NOT NULL CHECK (height > 0),
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    sponsor_id INT,
    coach_id INT,
    class_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (gym_home) REFERENCES GYM(gym_id) ON DELETE SET NULL,
    FOREIGN KEY (sponsor_id) REFERENCES SPONSOR(sponsor_id) ON DELETE SET NULL,
    FOREIGN KEY (coach_id) REFERENCES COACHES(id) ON DELETE SET NULL,
    FOREIGN KEY (class_id) REFERENCES WEIGHT_CLASS(class_id) ON DELETE NO ACTION
);

-- 10. EXERCISE table
CREATE TABLE EXERCISE (
	id INT AUTO_INCREMENT PRIMARY KEY,
    exercise_name VARCHAR(20) NOT NULL
);

-- 11. LIFT_LOG table
CREATE TABLE LIFT_LOG (
	lift_id INT AUTO_INCREMENT PRIMARY KEY,
    athlete_id INT NOT NULL,
    exercise_id INT NOT NULL,
    lift_date DATE NOT NULL,
    weight_pounds INT NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES ATHLETE(athlete_id) ON DELETE NO ACTION,
    FOREIGN KEY (exercise_id) REFERENCES EXERCISE(id) ON DELETE NO ACTION
);

CREATE INDEX idx_weight_lifted
ON LIFT_LOG (weight_pounds);

-- 12. COMPETITION_SCHEDULE table
CREATE TABLE COMPETITION_SCHEDULE (
	competition_id INT AUTO_INCREMENT PRIMARY KEY,
    competition_name VARCHAR(100) UNIQUE NOT NULL,
    competition_date DATE NOT NULL,
    gym_id INT NOT NULL,
    sponsor_id INT,
    FOREIGN KEY (gym_id) REFERENCES GYM(gym_id) ON DELETE CASCADE,
    FOREIGN KEY (sponsor_id) REFERENCES SPONSOR(sponsor_id) ON DELETE SET NULL
);

-- 13. GYM_HISTORY table
CREATE TABLE GYM_HISTORY (
	history_id INT AUTO_INCREMENT PRIMARY KEY,
    gh_action VARCHAR(8) NOT NULL,
    gh_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    gym_id INT NOT NULL,
    gym_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    location_id INT NOT NULL
);

-- GYM_HISTORY triggers:
DROP TRIGGER IF EXISTS gym_history_insert;
DELIMITER //
CREATE TRIGGER gym_history_insert
AFTER INSERT ON GYM
FOR EACH ROW
BEGIN
    INSERT INTO GYM_HISTORY (gh_action, gh_time, gym_id, gym_name, address, phone, location_id)
	VALUES ('insert', NOW(), NEW.gym_id, NEW.gym_name, NEW.address, NEW.phone, NEW.location_id);
END //
DELIMITER ;

DROP TRIGGER IF EXISTS gym_history_update;
DELIMITER //
CREATE TRIGGER gym_history_update
AFTER UPDATE ON GYM
FOR EACH ROW
BEGIN
	INSERT INTO GYM_HISTORY (gh_action, gh_time, gym_id, gym_name, address, phone, location_id)
    VALUES ('update', NOW(), NEW.gym_id, NEW.gym_name, NEW.address, NEW.phone, NEW.location_id);
END //
DELIMITER ;

DROP TRIGGER IF EXISTS gym_history_delete;
DELIMITER //
CREATE TRIGGER gym_history_delete
BEFORE DELETE ON GYM
FOR EACH ROW
BEGIN
	INSERT INTO GYM_HISTORY (gh_action, gh_time, gym_id, gym_name, address, phone, location_id)
    VALUES ('delete', NOW(), OLD.gym_id, OLD.gym_name, OLD.address, OLD.phone, OLD.location_id);
END //
DELIMITER ;

-- Fill database:
-- WEIGHT_CLASS table:
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('52kg/114lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('56kg/123lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('60kg/132lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('67.5kg/148lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('75kg/165lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('82.5kg/182lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('90kg/198lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('100kg/220lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('110kg/242lb');
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('125kg/275lb');

-- STATE table:
INSERT INTO STATE (state_name) VALUES ('Wisconsin');
INSERT INTO STATE (state_name) VALUES ('Illinois');
INSERT INTO STATE (state_name) VALUES ('California');
INSERT INTO STATE (state_name) VALUES ('Indiana');
INSERT INTO STATE (state_name) VALUES ('Michigan');

-- COUNTY table:
INSERT INTO COUNTY (county_name) VALUES ('Milwaukee');
INSERT INTO COUNTY (county_name) VALUES ('Cook');
INSERT INTO COUNTY (county_name) VALUES ('Kenosha');
INSERT INTO COUNTY (county_name) VALUES ('Los Angeles');
INSERT INTO COUNTY (county_name) VALUES ('Lake');
INSERT INTO COUNTY (county_name) VALUES ('Houghton');

-- CITY table:
INSERT INTO CITY (city_name) VALUES ('Milwaukee');
INSERT INTO CITY (city_name) VALUES ('West Allis');
INSERT INTO CITY (city_name) VALUES ('Oak Creek');
INSERT INTO CITY (city_name) VALUES ('Chicago');
INSERT INTO CITY (city_name) VALUES ('Skokie');
INSERT INTO CITY (city_name) VALUES ('Evanston');
INSERT INTO CITY (city_name) VALUES ('Los Angeles');
INSERT INTO CITY (city_name) VALUES ('Santa Monica');
INSERT INTO CITY (city_name) VALUES ('Long Beach');
INSERT INTO CITY (city_name) VALUES ('Waukegan');
INSERT INTO CITY (city_name) VALUES ('Lake Zurich');
INSERT INTO CITY (city_name) VALUES ('Gary');
INSERT INTO CITY (city_name) VALUES ('Calumet');

-- LOCATION table:
-- Wisconsin
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (1, 1, 1);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (1, 1, 2);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (1, 1, 3);
-- Illinois
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 2, 4);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 2, 5);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 2, 6);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 2, 13);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 5, 10);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 5, 11);
-- California
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (3, 4, 7);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (3, 4, 8);
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (3, 4, 9);
-- Indiana
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (4, 5, 12);
-- Michigan
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (5, 6, 13);

-- SPONSOR table:
INSERT INTO SPONSOR (sponsor_name) VALUES ('John Doe');
INSERT INTO SPONSOR (sponsor_name) VALUES ('PR Beaker');
INSERT INTO SPONSOR (sponsor_name) VALUES ('Bliffert');
INSERT INTO SPONSOR (sponsor_name) VALUES ('Celsius');
INSERT INTO SPONSOR (sponsor_name) VALUES ('Titan Support Systems');
INSERT INTO SPONSOR (sponsor_name) VALUES ('Nike');

-- COACHES table:
INSERT INTO COACHES (coach_name, email) VALUES ('John Doe', 'jdoe@gmail.com');
INSERT INTO COACHES (coach_name, email) VALUES ('Jane Doe', 'janed@gmail.com');
INSERT INTO COACHES (coach_name, email) VALUES ('Kevin McAllister', 'kmickey@hotmail.net');
INSERT INTO COACHES (coach_name, email) VALUES ('Nathan Stemo', 'natestemo115@gmail.com');

-- GYM table:
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Brickyard Gym', '2651 S Kinnickinnic Ave', '(414) 481-7113', 1);
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Milwaukee Barbell', '1539 W St Paul Ave', NULL, 1);
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Rockwell Barbell', '2861 N Clybourn Ave', '(773) 697-4871', 4);
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Barbell Brigade Gym', '646 Gibbons St', '(323) 225-2251', 10);
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('IRON Santa Monica', '1919 Broadway', '(310) 264-9800', 11);
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Lake County Barbell', '290 Telser Rd', '(847) 849-9206', 9);

-- ATHLETE table:
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Collin Brey', 1, '1995-08-15', 5.10, 'M', NULL, 1, 7);
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Taylor Smith', 1, '1990-04-22', 5.07, 'F', 1, NULL, 2);
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Jordan Lee', 3, '1992-06-10', 6.00, 'M', 1, 1, 3);
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Morgan Brown', 2, '1998-12-05', 5.08, 'F', 2, 2, 1); 
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Alex Johnson', 1, '1993-03-18', 6.02, 'M', 3, 1, 4); 
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Casey Rivera', 3, '1997-07-21', 5.09, 'F', NULL, 2, 4);
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Izaiah Murphy', 4, '1999-04-20', 6.06, 'M', 5, NULL, 9);
-- athletes with duplicate names
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Collin Brey', 2, '1997-06-11', 6.2, 'M', 5, 3, 7);
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Taylor Smith', 1, '1990-04-22', 5.07, 'F', 1, NULL, 2); -- duplicate name & gym
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id)
VALUES ('Collin Brey', 5, '1995-08-15', 5.10, 'M', NULL, 1, 6);

-- EXERCISE table:
INSERT INTO EXERCISE (exercise_name) VALUES ('Squat'); -- id: 1
INSERT INTO EXERCISE (exercise_name) VALUES ('Bench'); -- id: 2
INSERT INTO EXERCISE (exercise_name) VALUES ('Deadlift'); -- id: 3

-- LIFT_LOG table:	(note: lifts inserted by date because we want this to function more like a live leaderboard)
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (8, 1, '2024-10-15', 550);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (9, 3, '2024-10-29', 405);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (9, 2, '2024-10-29', 201);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (9, 1, '2024-10-29', 255);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (8, 3, '2024-10-30', 635);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (7, 2, '2024-10-30', 305);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (10, 1, '2024-11-09', 385);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (10, 2, '2024-11-14', 425);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (6, 1, '2024-11-20', 265);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (6, 3, '2024-11-20', 375);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (8, 2, '2024-11-20', 319);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (6, 2, '2024-11-20', 225);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (4, 1, '2024-11-21', 335); -- Morgan is literally insane!
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (4, 3, '2024-11-21', 335);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (4, 2, '2024-11-21', 235);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (6, 1, '2024-11-22', 225);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (6, 3, '2024-11-22', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (6, 2, '2024-11-22', 185);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (5, 1, '2024-11-23', 505);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (7, 3, '2024-11-23', 365);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (5, 3, '2024-11-23', 455);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (5, 2, '2024-11-23', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (4, 1, '2024-11-24', 315); -- Morgan going crazy again
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (4, 3, '2024-11-24', 375);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (10, 3, '2024-11-24', 545);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (4, 2, '2024-11-24', 255);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (2, 1, '2024-11-25', 405);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (3, 3, '2024-11-25', 495);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (2, 2, '2024-11-25', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (1, 2, '2024-11-26', 455);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (1, 3, '2024-11-26', 725);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (1, 1, '2024-11-26', 675);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (3, 3, '2024-11-27', 365);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (2, 2, '2024-11-27', 145);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (7, 2, '2024-11-27', 146);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (2, 1, '2024-11-27', 275);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (1, 2, '2024-11-28', 365);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (3, 3, '2024-11-28', 545);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (10, 1, '2024-11-28', 495);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (3, 1, '2024-11-28', 495);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (2, 2, '2024-11-29', 185);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (2, 1, '2024-11-29', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (2, 3, '2024-11-29', 405);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (1, 2, '2024-11-30', 405);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (3, 3, '2024-11-30', 635);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (1, 1, '2024-11-30', 550);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (7, 1, '2024-12-02', 275);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (7, 3, '2024-12-08', 495);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (8, 3, '2024-12-09', 725);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (8, 2, '2024-12-10', 295);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds)
VALUES (8, 1, '2024-12-10', 575);

-- COMPETITION_SCHEDULE table:
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2024 Nationals', '2024-12-30', 1, 1);
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2024 AMP The Gobbler', '2024-12-30', 3, NULL);
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2025 USA Powerlifting West Loop Winter Classic', '2025-01-25', 3, 4);
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2024 USA Powerlifting Liftmas Open', '2024-12-21', 2, 5);
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2024 USA Powerlifting Merry Liftmas', '2024-12-14', 4, 2);
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2025 USA Powerlifting California State Championship', '2025-02-22', 4, NULL);
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('Quadzgiving III', '2024-12-14', 5, 3);