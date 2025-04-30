drop database powerlifting_leaderboard;
-- Create the database (schema in MySQL)
CREATE DATABASE IF NOT EXISTS powerlifting_leaderboard;

-- Switch to the created database
USE powerlifting_leaderboard;

DROP TABLE IF EXISTS WEIGHT_CLASS;
DROP TABLE IF EXISTS STATE;
DROP TABLE IF EXISTS CITY;
DROP TABLE IF EXISTS COUNTY;
DROP TABLE IF EXISTS LOCATION;
DROP TABLE IF EXISTS SPONSOR;
DROP TABLE IF EXISTS COACHES;
DROP TABLE IF EXISTS GYM;
DROP TABLE IF EXISTS ATHLETE;
DROP TABLE IF EXISTS EXERCISE;
DROP TABLE IF EXISTS LIFT_LOG;
DROP TABLE IF EXISTS COMPETITION_SCHEDULE;
DROP TABLE IF EXISTS GYM_HISTORY;

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
    FOREIGN KEY (state_id) REFERENCES STATE(state_id) ON DELETE CASCADE, -- double check the ON DELETE action
    FOREIGN KEY (county_id) REFERENCES COUNTY(county_id) ON DELETE CASCADE, -- double check the ON DELETE action,
    FOREIGN KEY (city_id) REFERENCES CITY(city_id) ON DELETE CASCADE, -- double check the ON DELETE action
    UNIQUE KEY (state_id, county_id, city_id) -- unique composite key to restrict duplicates
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
    FOREIGN KEY (location_id) REFERENCES LOCATION(location_id) ON DELETE CASCADE, -- double check this ON DELETE action
	UNIQUE KEY (address, location_id) -- unique composite key
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
    FOREIGN KEY (class_id) REFERENCES WEIGHT_CLASS(class_id) ON DELETE NO ACTION -- double check this ON DELETE action
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
    FOREIGN KEY (athlete_id) REFERENCES ATHLETE(athlete_id) ON DELETE NO ACTION, -- double check action
    FOREIGN KEY (exercise_id) REFERENCES EXERCISE(id) ON DELETE NO ACTION -- double check action
);

-- 12. COMPETITION_SCHEDULE table
CREATE TABLE COMPETITION_SCHEDULE (
	competition_id INT AUTO_INCREMENT PRIMARY KEY,
    competition_name VARCHAR(100) UNIQUE NOT NULL,
    competition_date DATE NOT NULL,
    gym_id INT NOT NULL,
    sponsor_id INT,
    FOREIGN KEY (gym_id) REFERENCES GYM(gym_id) ON DELETE CASCADE, -- double check action
    FOREIGN KEY (sponsor_id) REFERENCES SPONSOR(sponsor_id) ON DELETE SET NULL
);
-- This table would be like a list of competitions (could be upcoming or previous. not really sure.)
-- But a gym is the one to host a competition. The gym must be in the system, but we don't have to
-- have any athletes attatched to that gym (which could make for interesting queries).
-- This would also make it so that a sponsor can sponsor an athlete and/or a competition.

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
-- Here's some quick test-entries just to make sure everything can be added ok.
-- WEIGHT_CLASS table:
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('52kg/114lb'); -- id: 1
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('56kg/123lb'); -- id: 2
INSERT INTO WEIGHT_CLASS (class_name) VALUES ('90kg/198lb'); -- id: 3

-- STATE table:
INSERT INTO STATE (state_name) VALUES ('Wisconsin'); -- id: 1
INSERT INTO STATE (state_name) VALUES ('Illinois'); -- id: 2

-- COUNTY table:
INSERT INTO COUNTY (county_name) VALUES ('Milwaukee'); -- id: 1
INSERT INTO COUNTY (county_name) VALUES ('Cook'); -- id: 2

-- CITY table:
INSERT INTO CITY (city_name) VALUES ('Milwaukee'); -- id: 1
INSERT INTO CITY (city_name) VALUES ('West Allis'); -- id: 2
INSERT INTO CITY (city_name) VALUES ('Oak Creek'); -- id: 3
INSERT INTO CITY (city_name) VALUES ('Chicago'); -- id: 4
INSERT INTO CITY (city_name) VALUES ('Skokie'); -- id: 5
INSERT INTO CITY (city_name) VALUES ('Evanston'); -- id: 6

-- LOCATION table:
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (1, 1, 1); -- id: 1
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (1, 1, 2); -- id: 2
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (1, 1, 3); -- id: 3
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 2, 4); -- id: 4
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 2, 5); -- id: 5
INSERT INTO LOCATION (state_id, county_id, city_id) VALUES (2, 2, 6); -- id: 6

-- SPONSOR table:
INSERT INTO SPONSOR (sponsor_name) VALUES ('John Doe'); -- id: 1
INSERT INTO SPONSOR (sponsor_name) VALUES ('PR Beaker'); -- id: 2
INSERT INTO SPONSOR (sponsor_name) VALUES ('Bliffert'); -- id: 3

-- COACHES table:
INSERT INTO COACHES (coach_name, email) VALUES ('John Doe', 'jdoe@gmail.com'); -- id: 1

-- GYM table:
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Brickyard Gym', '2651 S Kinnickinnic Ave', '(414) 481-7113', 1); -- id: 1
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Milwaukee Gym', '2653 S Kinnickinnic Ave', '(555) 555-5555', 1); -- id: 2
INSERT INTO GYM (gym_name, address, phone, location_id)
VALUES ('Rockwell Barbell', '2861 N Clybourn Ave', '(773) 697-4871', 4); -- id: 3

-- ATHLETE table:
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id) -- id: 1
VALUES ('Collin Brey', 1, '1995-08-15', 5.10, 'M', NULL, 1, 3); 
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id) -- id: 2
VALUES ('Taylor Smith', 1, '1990-04-22', 5.07, 'F', 1, NULL, 2);
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id) -- id: 3
VALUES ('Jordan Lee', 3, '1992-06-10', 6.00, 'M', 1, 1, 3);
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id) -- id: 4
VALUES ('Morgan Brown', 2, '1998-12-05', 5.08, 'F', 2, 1, 1); 
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id) -- id: 5
VALUES ('Alex Johnson', 1, '1993-03-18', 6.02, 'M', 3, 1, 2); 
INSERT INTO ATHLETE (athlete_name, gym_home, dob, height, gender, sponsor_id, coach_id, class_id) -- id: 6
VALUES ('Casey Rivera', 3, '1997-07-21', 5.09, 'F', NULL, 1, 1); 
-- EXERCISE table:
INSERT INTO EXERCISE (exercise_name) VALUES ('Squat'); -- id: 1
INSERT INTO EXERCISE (exercise_name) VALUES ('Bench'); -- id: 2
INSERT INTO EXERCISE (exercise_name) VALUES ('Deadlift'); -- id: 3

-- LIFT_LOG table:	(note: mix them around a bit)
-- squats:
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 1
VALUES (1, 1, '2024-11-30', 550);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 2
VALUES (2, 1, '2024-11-29', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 3
VALUES (3, 1, '2024-11-28', 495);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 4
VALUES (2, 1, '2024-11-27', 275);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 5
VALUES (1, 1, '2024-11-26', 675);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 6
VALUES (2, 1, '2024-11-25', 405);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 7
VALUES (5, 1, '2024-11-23', 505);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 8
VALUES (4, 1, '2024-11-24', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 9
VALUES (6, 1, '2024-11-22', 225);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 10
VALUES (4, 1, '2024-11-21', 335);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 11
VALUES (6, 1, '2024-11-20', 265);
-- benches:
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 12
VALUES (1, 2, '2024-11-30', 405);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 13
VALUES (2, 2, '2024-11-29', 185);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 14
VALUES (1, 2, '2024-11-28', 365);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 15
VALUES (2, 2, '2024-11-27', 145);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 16
VALUES (1, 2, '2024-11-26', 455);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 17
VALUES (2, 2, '2024-11-25', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 18
VALUES (5, 2, '2024-11-23', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 19
VALUES (4, 2, '2024-11-24', 255);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 20
VALUES (6, 2, '2024-11-22', 185);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 21
VALUES (4, 2, '2024-11-21', 235);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 22
VALUES (6, 2, '2024-11-20', 225);
-- deadlifts:
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 13
VALUES (3, 3, '2024-11-30', 635);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 14
VALUES (2, 3, '2024-11-29', 405);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 15
VALUES (3, 3, '2024-11-28', 545);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 16
VALUES (3, 3, '2024-11-27', 365);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 17
VALUES (1, 3, '2024-11-26', 725);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 18
VALUES (3, 3, '2024-11-25', 495);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 18
VALUES (5, 2, '2024-11-23', 455);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 19
VALUES (4, 2, '2024-11-24', 375);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 20
VALUES (6, 2, '2024-11-22', 315);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 21
VALUES (4, 2, '2024-11-21', 335);
INSERT INTO LIFT_LOG (athlete_id, exercise_id, lift_date, weight_pounds) -- id: 22
VALUES (6, 2, '2024-11-20', 375);
-- COMPETITION_SCHEDULE table:
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2024 Nationals', '2024-12-30', 1, 1);
INSERT INTO COMPETITION_SCHEDULE (competition_name, competition_date, gym_id, sponsor_id)
VALUES ('2024 AMP The Gobbler', '2024-12-30', 3, NULL);

-- Test GYM_HISTORY update and delete trigger
UPDATE GYM
	SET phone = '(222) 222-2222'
	WHERE gym_id = 2;
    
DELETE FROM GYM
	WHERE gym_id = 2;

