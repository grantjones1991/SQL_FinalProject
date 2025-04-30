-- Final Project Dummy Data
use final_project;


-- Insert into ATHLETE table
INSERT INTO ATHLETE (athlete_id, athlete_name, state_id, dob, weight, height, gender, sponsor_id, class_id)
VALUES (1, 'Collin Brey', 1, '1995-08-15', 198.00, 5.10, 'M', NULL, 1);

-- Insert into SQUAT table
INSERT INTO SQUAT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (1, '2024-11-30', 550, 249.48);

-- Insert into BENCH table
INSERT INTO BENCH (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (1, '2024-11-30', 405, 183.70);

-- Insert into DEADLIFT table
INSERT INTO DEADLIFT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (1, '2024-11-30', 635, 288.03);

-- Optionally, insert into LEADERBOARD table
INSERT INTO LEADERBOARD (leaderboard_id, weight, result, athlete_id)
VALUES (1, 198.00, 1590.00, 1);

-- Insert into ATHLETE table
INSERT INTO ATHLETE (athlete_id, athlete_name, state_id, dob, weight, height, gender, sponsor_id, class_id)
VALUES (2, 'Taylor Smith', 2, '1990-04-22', 145.00, 5.07, 'F', NULL, 2);

-- Insert into SQUAT table
INSERT INTO SQUAT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (2, '2024-11-29', 315, 142.88);

-- Insert into BENCH table
INSERT INTO BENCH (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (2, '2024-11-29', 185, 83.91);

-- Insert into DEADLIFT table
INSERT INTO DEADLIFT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (2, '2024-11-29', 405, 183.70);

-- Optionally, insert into LEADERBOARD table
INSERT INTO LEADERBOARD (leaderboard_id, weight, result, athlete_id)
VALUES (2, 145.00, 905.00, 2);

-- Insert into ATHLETE table
INSERT INTO ATHLETE (athlete_id, athlete_name, state_id, dob, weight, height, gender, sponsor_id, class_id)
VALUES (3, 'Jordan Lee', 3, '1992-06-10', 220.00, 6.00, 'M', NULL, 3);

-- Insert into SQUAT table
INSERT INTO SQUAT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (3, '2024-11-28', 495, 224.53);

-- Insert into BENCH table
INSERT INTO BENCH (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (3, '2024-11-28', 365, 165.56);

-- Insert into DEADLIFT table
INSERT INTO DEADLIFT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (3, '2024-11-28', 545, 247.21);

-- Optionally, insert into LEADERBOARD table
INSERT INTO LEADERBOARD (leaderboard_id, weight, result, athlete_id)
VALUES (3, 220.00, 1405.00, 3);

-- Insert into ATHLETE table
INSERT INTO ATHLETE (athlete_id, athlete_name, state_id, dob, weight, height, gender, sponsor_id, class_id)
VALUES (4, 'Morgan Brown', 4, '1988-12-05', 165.00, 5.09, 'F', NULL, 2);

-- Insert into SQUAT table
INSERT INTO SQUAT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (4, '2024-11-27', 275, 124.74);

-- Insert into BENCH table
INSERT INTO BENCH (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (4, '2024-11-27', 145, 65.77);

-- Insert into DEADLIFT table
INSERT INTO DEADLIFT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (4, '2024-11-27', 365, 165.56);

-- Optionally, insert into LEADERBOARD table
INSERT INTO LEADERBOARD (leaderboard_id, weight, result, athlete_id)
VALUES (4, 165.00, 785.00, 4);

-- Insert into ATHLETE table
INSERT INTO ATHLETE (athlete_id, athlete_name, state_id, dob, weight, height, gender, sponsor_id, class_id)
VALUES (5, 'Alex Carter', 5, '1994-01-15', 275.00, 6.04, 'M', NULL, 4);

-- Insert into SQUAT table
INSERT INTO SQUAT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (5, '2024-11-26', 675, 306.17);

-- Insert into BENCH table
INSERT INTO BENCH (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (5, '2024-11-26', 455, 206.38);

-- Insert into DEADLIFT table
INSERT INTO DEADLIFT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (5, '2024-11-26', 725, 328.85);

-- Optionally, insert into LEADERBOARD table
INSERT INTO LEADERBOARD (leaderboard_id, weight, result, athlete_id)
VALUES (5, 275.00, 1855.00, 5);

-- Insert into ATHLETE table
INSERT INTO ATHLETE (athlete_id, athlete_name, state_id, dob, weight, height, gender, sponsor_id, class_id)
VALUES (6, 'Casey Green', 6, '1985-09-30', 198.00, 5.11, 'M', NULL, 3);

-- Insert into SQUAT table
INSERT INTO SQUAT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (6, '2024-11-25', 405, 183.70);

-- Insert into BENCH table
INSERT INTO BENCH (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (6, '2024-11-25', 315, 142.88);

-- Insert into DEADLIFT table
INSERT INTO DEADLIFT (athlete_id, lift_date, weight_pounds, weight_kilos)
VALUES (6, '2024-11-25', 495, 224.53);

-- Optionally, insert into LEADERBOARD table
INSERT INTO LEADERBOARD (leaderboard_id, weight, result, athlete_id)
VALUES (6, 198.00, 1215.00, 6);

-- City and states
insert into location()
