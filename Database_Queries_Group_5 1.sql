USE powerlifting_leaderboard;

-- Medium queries:
-- 1.) Show everyone whose gym home is in Los Angeles
SELECT a.athlete_name
	FROM ATHLETE a
	JOIN GYM g ON a.gym_home = g.gym_id
	JOIN LOCATION l ON g.location_id = l.location_id
	JOIN CITY c ON l.city_id = c.city_id
	WHERE c.city_name = 'Los Angeles';

-- 2.) Show a count of how many competitions are occurring for each state
SELECT s.state_name, COUNT(cs.competition_id) AS total_competitions
	FROM COMPETITION_SCHEDULE cs
	JOIN GYM g ON cs.gym_id = g.gym_id
	JOIN LOCATION l ON g.location_id = l.location_id
	JOIN STATE s ON l.state_id = s.state_id
	GROUP BY s.state_name;

-- 3.) Show the top 5 athletes (based on total weight lifted) across all exercises and weight classes
SELECT ll.athlete_id, a.athlete_name, SUM(ll.weight_pounds) AS total_weight
	FROM LIFT_LOG ll
	JOIN ATHLETE a ON ll.athlete_id = a.athlete_id
	GROUP BY ll.athlete_id
	ORDER BY total_weight DESC
	LIMIT 5;

-- 4.) Show how many athletes there are in each weight class for the state of California
SELECT wc.class_name, COUNT(a.athlete_id) AS total_athletes
	FROM WEIGHT_CLASS wc
	JOIN ATHLETE a ON wc.class_id = a.class_id
	JOIN GYM g ON a.gym_home = g.gym_id
	JOIN LOCATION l ON g.location_id = l.location_id
	JOIN STATE s ON l.state_id = s.state_id
	WHERE s.state_name = 'California'
	GROUP BY wc.class_name
	ORDER BY total_athletes DESC;

-- 5.) Show the average weight lifted across all athletes and weight classes for each exercise
SELECT e.exercise_name, AVG(ll.weight_pounds) AS avg_weight
	FROM EXERCISE e
	JOIN LIFT_LOG ll ON e.id = ll.exercise_id
	GROUP BY e.exercise_name;

-- 6.) Show all athlete names that exist in at least 3 different gyms (different athletes that share the same name)
SELECT a.athlete_name, COUNT(DISTINCT a.gym_home) AS gym_count
	FROM ATHLETE a
	JOIN GYM g ON a.gym_home = g.gym_id
	GROUP BY a.athlete_name
	HAVING gym_count > 2;

#7 City ~ Select the Cities their state ranked by city name asc
select city_name, state_name from city
inner join (
	select state_name, city_id from state inner join location 
    on state.state_id = location.state_id) as states
on city.city_id = states.city_id
order by city_name asc;

#8 Squat ~ select squat weights, athletes name and weight class and order by Squat weight desc
select athlete.athlete_id, athlete.athlete_name, lift_log.weight_pounds, athlete.gender, athlete.height from lift_log
inner join athlete on lift_log.athlete_id = athlete.athlete_id
where lift_log.exercise_id = 1
order by lift_log.weight_pounds desc;

#9 State ~ Select the total number of athletes from each state
select state_name, Count(*) as total_athletes
from state inner join(
	select ath2gym.athlete_name, ath2gym.gym_id, location.location_id, location.state_id
	from location inner join (
		select athlete.athlete_name, athlete.athlete_id, gym.gym_id, gym.location_id  
		from athlete inner join gym
		on athlete.gym_home = gym.gym_id
	) as ath2gym
	on location.location_id = ath2gym.location_id
) as ath2state
on state.state_id = ath2state.state_id
group by state.state_id
order by total_athletes desc;

#10 Sponsor ~ Select each athlete and their sponsor
select athlete_id, athlete_name, dob, sponsor_name from athlete
inner join sponsor on athlete.sponsor_id = sponsor.sponsor_id;

-- 11.) Show the number of gyms that exist in each county.
SELECT COUNTY.county_name, COUNT(*) AS total_gyms
	FROM GYM
    JOIN LOCATION ON GYM.location_id = LOCATION.location_id
    JOIN COUNTY ON LOCATION.county_id = COUNTY.county_id
    GROUP BY COUNTY.county_name
    ORDER BY total_gyms DESC;

-- Hard queries:
-- 1.) List all gym entries that are in the state of Wisconsin
SELECT g.gym_name, c.city_name, s.state_name
	FROM GYM g
    JOIN LOCATION l ON g.location_id = l.location_id
    JOIN CITY c ON l.city_id = c.city_id
    JOIN STATE s ON l.state_id = s.state_id
    WHERE s.state_name = "Wisconsin";

-- 2.) Show the total number of gyms for each state
SELECT l.state_id, s.state_name, COUNT(g.gym_id) AS total_gyms
	FROM GYM g
    JOIN LOCATION l ON g.location_id = l.location_id
    JOIN STATE s ON l.state_id = s.state_id
    GROUP BY l.state_id;

-- 3.) List all athletes (id, name, and gym home name) who have the same name as at least one other person.
SELECT a.athlete_id, a.athlete_name, g.gym_name
	FROM ATHLETE a
    JOIN GYM g ON a.gym_home = g.gym_id
    WHERE a.athlete_name IN (
		SELECT athlete_name
        FROM ATHLETE
		GROUP BY athlete_name
		HAVING COUNT(athlete_name) > 1
		)
	ORDER BY athlete_name;

-- View: Display the max for each type of lift for every athlete in the DB
CREATE VIEW highest_lifts_per_athlete AS
SELECT 
a.athlete_id,
a.athlete_name,
wc.class_name AS weight_class,
MAX(CASE WHEN e.exercise_name = 'Squat' THEN ll.weight_pounds ELSE NULL END) AS max_squat,
MAX(CASE WHEN e.exercise_name = 'Bench' THEN ll.weight_pounds ELSE NULL END) AS max_bench,
MAX(CASE WHEN e.exercise_name = 'Deadlift' THEN ll.weight_pounds ELSE NULL END) AS max_deadlift
FROM LIFT_LOG ll
JOIN EXERCISE e ON ll.exercise_id = e.id
JOIN ATHLETE a ON ll.athlete_id = a.athlete_id
JOIN WEIGHT_CLASS wc ON a.class_id = wc.class_id
GROUP BY a.athlete_id, a.athlete_name, wc.class_name
ORDER BY a.athlete_id ASC;

-- Cursor:
DELIMITER //
CREATE PROCEDURE GetAthleteLifts(IN athlete_id_input INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE exercise_name VARCHAR(50);
    DECLARE max_weight INT;
    DECLARE athlete_name VARCHAR(100);
 
    -- Declare the cursor
    DECLARE lift_cursor CURSOR FOR
    SELECT 
        e.exercise_name,
        MAX(ll.weight_pounds)
    FROM 
        LIFT_LOG ll
    JOIN 
        EXERCISE e ON ll.exercise_id = e.id
    WHERE 
        ll.athlete_id = athlete_id_input
    GROUP BY 
        e.exercise_name;
 
    -- Handler for cursor completion
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
 
    -- Retrieve the athlete's name
    SELECT athlete_name 
    INTO athlete_name
    FROM ATHLETE
    WHERE athlete_id = athlete_id_input;
 
    -- Output the athlete's name
    SELECT CONCAT('Athlete: ', athlete_name) AS AthleteName;
 
    -- Open the cursor
    OPEN lift_cursor;
 
    -- Cursor loop
    lift_loop: LOOP
        FETCH lift_cursor INTO exercise_name, max_weight;
        IF done THEN
            LEAVE lift_loop;
        END IF;
        -- Output the result
        SELECT CONCAT('Exercise: ', exercise_name, ', Max Weight: ', max_weight) AS LiftDetails;
    END LOOP lift_loop;
 
    -- Close the cursor
    CLOSE lift_cursor;
END //
DELIMITER ;

-- Test procedure:
CALL GetAthleteLifts(2);

-- Test GYM_HISTORY update and delete trigger
-- Update a specific gym's phone number
UPDATE GYM
	SET phone = '(222) 222-2222'
	WHERE gym_id = 2;

-- Delete every gym that ends with 'Barbell'
DELETE FROM GYM
	WHERE gym_name LIKE '%Barbell';
