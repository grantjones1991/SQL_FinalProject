create schema if not exists powerlifting_leaderboard;
use powerlifting_leaderboard;

-- medium queries




-- THESE QUERIES WORK
-- #1 City ~ Select the Cities their state ranked by city name asc
select city_name, state_name from city
inner join (
	select state_name, city_id from state inner join location 
    on state.state_id = location.state_id) as states
on city.city_id = states.city_id
order by city_name asc;

#5 Weight ~ Select the athlete, their gender and their weight class
select athlete_name, gender, class_name from athlete
inner join weight_class on athlete.class_id = weight_class.class_id;





## THESE NEED TO BE FIXED

#2 Squat ~ select squat weights, athletes name and weight class and order by Squat weight desc
-- select athlete_name, weight_pounds, weight_kilos, gender, weight, height from squat
-- inner join athlete on squat.athlete_id = athlete.athlete_id 
-- order by weight_pounds desc;

#3 FIX ~~~~~~~~~~~~~~~~ State ~ Select the total number of athletes from each state (*****GET DUMMY DATA TO TEST*****)
-- select state_name, Count(*) as total_athletes 
-- from state inner join athlete 
-- on state.state_id = athlete.state_id
-- group by athlete_id;

#4 Sponsor ~ Select each athlete and their sponsor
-- select athlete_name, weight, dob, sponsor_name from athlete
-- inner join sponsor on athlete.sponsor_id = sponsor.sponsor_id; 


#6 County ~ Select the county name, the state and names for every female lifter
-- select county_name, (select state_name from state inner join location on state.state_id = location.state_id) as state_name
-- from county inner join location on county.county_id = location.county_id;

#7 FIX ~~~~~~~~~~~~~~~~ Athlete ~ Select the athlete, and all of their max's
-- select athlete_name, (select bench.weight_pounds from bench left join athlete on bench.athlete_id = athlete.athlete_id) as "Bench Max"
-- (select squat.weight_pounds from squat inner join athlete on squat.athlete_id = athlete.athlete_id) as "Squat Max",
-- (select deadlift.weight_pounds from deadlift inner join athlete on deadlift.athlete_id = athlete.athlete_id) as "Deadlift Max"
-- from athlete
-- order by gender asc, athlete_name asc;

#8 Bench ~ Rank the bench weight from highest to lowest
-- select athlete_name, weight_pounds, weight_kilos from bench
-- inner join athlete on bench.athlete_id = athlete.athlete_id 
-- order by weight_pounds desc;

#9 Gym ~ Select all details about the gym, including city and state
-- select gym.*, (select city_name from city inner join location on city.city_id = location.city_id) as "City Name",
-- (select state_name from state inner join location on state.state_id = location.state_id) as "State Name"
-- from gym inner join location 
-- on gym.location_id = location.location_id;

#10 Leaderboard ~ idk, come back to it
-- select athlete_name, leaderboard.weight, result 
-- from leaderboard inner join athlete
-- on leaderboard.athlete_id = athlete.athlete_id
-- order by result desc;

#11 Location ~ select *, rank by state name then county name then city name
-- select * from location
-- order by state_name asc, county_name asc, city_name asc;

#12 Deadlift ~ Rank the deadlifts from Maximum to minimum weight, with int value going from 1 to n, the atlete and the gym they attend
-- select athlete_name, deadlift.weight_pounds
-- from deadlift inner join athlete
-- on deadlift.athlete_id = athlete.athlete_id
-- order by deadlift.weight_pounds desc;

