/*
Вывести участников, которые не посетили ни одного мероприятия
Вывести организаторов с указанием количества участников, посетивших их мероприятия, если таких нет, то написать «неинтересный контент»
Вывести мероприятия с количеством участников мужского пола
*/

-- добавим еще пару участников, которые не пойдут на мероприятия
INSERT INTO participants (id, first_name, last_name, email)
VALUES
    (11, 'Михаил', 'Михайлов', 'mihailov@ya.ru'),
    (12, 'Владимир', 'Владимиров', 'vladimirov@ya.ru');

-- добавим неинтересного автора и неинтересное мероприятие
INSERT INTO organizers (id, first_name, last_name, email, company_id)
VALUES
    (6, 'Иван', 'Неинтересный', 'interesting@ya.ru', 4);

INSERT INTO events (id, event_name, start_time, duration, program_id)
VALUES
    (7, 'Неинтересное мероприятие, на которое никто не запишется', '15:00:00', 100, 2);

INSERT INTO organizers_of_events (organizer_id, event_id) VALUES (6, 7);

-- Вывести участников, которые не посетили ни одного мероприятия
SELECT participants.first_name, participants.last_name, event_id
FROM participants
    LEFT JOIN participants_of_events poe on participants.id = poe.participant_id
WHERE event_id IS NULL;

-- Вывести организаторов с указанием количества участников, посетивших их мероприятия, если таких нет, то написать «неинтересный контент»
-- вариант с case ... end
SELECT first_name, last_name,
       CASE
            WHEN COUNT(participant_id) = 0
                THEN 'неинтересный контент'
                ELSE CAST(COUNT(participant_id) AS VARCHAR(20))
       END

FROM organizers
    RIGHT JOIN organizers_of_events ooe on organizers.id = ooe.organizer_id
    JOIN events e on e.id = ooe.event_id
    LEFT JOIN participants_of_events poe on e.id = poe.event_id
GROUP BY first_name, last_name;


-- Вывести организаторов с указанием количества участников, посетивших их мероприятия, если таких нет, то написать «неинтересный контент»
-- вариант с UNION

SELECT first_name, last_name, CAST(COUNT(participant_id) AS VARCHAR(20))
FROM organizers
    RIGHT JOIN organizers_of_events ooe on organizers.id = ooe.organizer_id
    JOIN events e on e.id = ooe.event_id
    LEFT JOIN participants_of_events poe on e.id = poe.event_id
WHERE participant_id IS NOT NULL
GROUP BY first_name, last_name

UNION

SELECT first_name, last_name, 'неинтересный контент'
FROM organizers
    RIGHT JOIN organizers_of_events ooe on organizers.id = ooe.organizer_id
    JOIN events e on e.id = ooe.event_id
    LEFT JOIN participants_of_events poe on e.id = poe.event_id
WHERE participant_id IS NULL
GROUP BY first_name, last_name;


-- добавим в таблицу participants колонку пол
ALTER TABLE participants
ADD COLUMN participant_gender CHAR NOT NULL DEFAULT 'М';

INSERT INTO events.public.participants (id, first_name, last_name, email, age, participant_gender)
VALUES
    (13, 'Лиза', 'Завьялова', 'liza@ya.ru', 20, 'Ж');

INSERT INTO events.public.participants_of_events (participant_id, event_id)
VALUES
    (13, 1);


-- Вывести мероприятия с количеством участников мужского пола
SELECT event_name, COUNT(participant_id)
FROM events
    JOIN participants_of_events poe on events.id = poe.event_id
    JOIN participants p on p.id = poe.participant_id
WHERE participant_gender = 'М'
GROUP BY event_name;