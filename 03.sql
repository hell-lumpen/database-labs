/*
Написать три запроса в соответствии со своим вариантом. В запросах НЕ ИСПОЛЬЗОВАТЬ JOIN и подзапросы.

Для каждой из программ определить количество мероприятий
Определить мероприятия, в которых принимают участие более чем 10 человек
Определить организаторов, чьи мероприятия длятся дольше 2 часов с указанием их количества
*/

SELECT programs.program_name, COUNT(events.public.events.program_id) as number_of_events FROM programs, events
WHERE events.public.events.program_id = programs.id
GROUP BY programs.program_name;

SELECT events.public.events.event_name, COUNT(participant_id) as number_of_participant
FROM participants_of_events, events
WHERE events.public.events.id = participants_of_events.event_id
GROUP BY events.public.events.event_name
HAVING COUNT(participants_of_events.participant_id) > 3;