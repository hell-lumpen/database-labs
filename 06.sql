/*
Создать представление по мероприятиям с указанием организатора (ФИО или названия организации) и названия программы
Создать итоговое представление по организаторам с указанием количества организованных мероприятий,
участия в различных программах, среднего числа участников его мероприятий, минимальный возраст участника
 */

CREATE OR REPLACE VIEW modified_view AS
SELECT id, event_name, start_time, program_id
FROM events
WHERE id != 7;

INSERT INTO list_of_events_view1
VALUES (9, 'event_name', '10:00:00', 1);

-- Создать представление по мероприятиям с указанием организатора (ФИО или названия организации) и названия программы

CREATE OR REPLACE VIEW list_of_events_view AS
SELECT program_name, event_name, first_name, last_name, company_name
FROM programs
    JOIN events e on programs.id = e.program_id
    JOIN organizers_of_events ooe on e.id = ooe.event_id
    JOIN organizers o on o.id = ooe.organizer_id
    JOIN companies c on c.id = o.company_id;


-- добавим колонку возраст в таблицу participants
ALTER TABLE participants
ADD COLUMN age SMALLINT NOT NULL DEFAULT FLOOR(RANDOM() * (50-14 + 1) + 14);


-- Создать итоговое представление по организаторам с указанием количества организованных мероприятий,
-- участия в различных программах, среднего числа участников его мероприятий, минимальный возраст участника
--
CREATE OR REPLACE VIEW organizer_stats AS
SELECT counts.first_name, counts.last_name, events_count, program_count, average_count, min_age
FROM
    -- эта часть расчитывает среднее число участников мероприятий каждого организатора
    (SELECT id, AVG(count_of_participants.count) as average_count
    FROM (SELECT organizers.id, COUNT(poe.participant_id) as count
            FROM organizers
                LEFT JOIN organizers_of_events ooe on organizers.id = ooe.organizer_id
                LEFT JOIN events e on e.id = ooe.event_id
                LEFT JOIN participants_of_events poe on e.id = poe.event_id
            GROUP BY organizers.id, event_name) as count_of_participants
    GROUP BY id) AS avg
JOIN
    -- всё остальное...
    (SELECT organizers.id, organizers.first_name, organizers.last_name,
           COUNT(DISTINCT ooe.event_id) as events_count,
           COUNT(DISTINCT p.id) as program_count,
           MIN(p2.age) as min_age
    FROM organizers
        LEFT JOIN organizers_of_events ooe on organizers.id = ooe.organizer_id
        LEFT JOIN events e on e.id = ooe.event_id
        LEFT JOIN programs p on p.id = e.program_id
        LEFT JOIN participants_of_events poe on e.id = poe.event_id
        LEFT JOIN participants p2 on poe.participant_id = p2.id
    GROUP BY organizers.id, organizers.first_name, organizers.last_name) AS counts
ON (avg.id = counts.id);