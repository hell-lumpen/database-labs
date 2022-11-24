/*
Определить организаторов, средняя продолжительность мероприятий которых меньше средней
Уменьшить продолжительность мероприятия на 1 час, если в нем принимает участие не более чем 5 человек
Определить участников, которые приняли участие более чем в половине мероприятий
*/

-- Определить организаторов, средняя продолжительность мероприятий которых меньше средней
SELECT organizers.first_name, organizers.last_name, AVG(events.duration) as average_duration
FROM organizers_of_events
    INNER JOIN events on organizers_of_events.event_id = events.id
    INNER JOIN organizers on organizers_of_events.organizer_id = organizers.id
GROUP BY organizers.first_name, organizers.last_name
HAVING AVG(events.duration) < (SELECT AVG(events.duration) FROM events);

-- вывести мероприятия на которое записано менее 3 человек
SELECT event_name, duration, COUNT(participant_id) as participants_count
FROM participants_of_events
    JOIN events ON participants_of_events.event_id = events.id
GROUP BY event_name, duration
HAVING COUNT(participant_id) < 3;


-- Уменьшить продолжительность мероприятия на 1 час, если в нем принимает участие не более чем 5 человек
UPDATE events
SET duration = events.duration - 5
FROM (
    SELECT event_id, COUNT(participant_id) as count FROM participants_of_events
    GROUP BY event_id
) as count_of_participants
WHERE count_of_participants.count < 3;


-- Определить участников, которые приняли участие более чем в половине мероприятий
SELECT first_name, last_name, COUNT(participants_of_events.participant_id) as number_of_events
FROM participants_of_events
    JOIN participants on participants.id = participants_of_events.participant_id
GROUP BY first_name, last_name
HAVING COUNT(participants_of_events.participant_id) <
       FLOOR((SELECT COUNT(DISTINCT event_id) FROM participants_of_events) / 2)