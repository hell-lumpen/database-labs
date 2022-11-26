/*
 Создать процедуру, вставляющую записи через первое представление из предыдущего задания.
 Вставить как минимум 2 записи (т.е. вызвать процедуру дважды).
 Получить результат, формируемый третьим представлением (предыдущего задания) через выполнение нескольких запросов,
 объединённых в процедуру.
 Создать процедуру с параметром по умолчанию и выходным параметром.
*/

CREATE OR REPLACE PROCEDURE foo(id INTEGER,
                               event_name VARCHAR,
                               start_time TIME,
                               program_id INTEGER)
    LANGUAGE SQL
    AS $$
    INSERT INTO modified_view
    VALUES (id, event_name, start_time, program_id)
$$;

CALL foo(10, 'event_name2', '11:00:00', 1);
CALL foo(11, 'event_name3', '12:00:00', 2);

-- DELETE FROM modified_view
-- WHERE id IN (10, 11);

CREATE OR REPLACE FUNCTION get_organizers_stat()
RETURNS TABLE (first_name VARCHAR,
               last_name VARCHAR,
               events_count BIGINT,
               programs_count BIGINT,
               average_count NUMERIC,
               min_age SMALLINT)
AS $$
    BEGIN
        RETURN QUERY (SELECT
                         counts.first_name,
                         counts.last_name,
                         counts.events_count,
                         program_count,
                         avg.average_count,
                         counts.min_age
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
        ON (avg.id = counts.id));
    END;
$$
LANGUAGE plpgsql;

SELECT * FROM get_organizers_stat();

CREATE OR REPLACE FUNCTION get_participants_count (name_pattern VARCHAR DEFAULT '%ей',
                                                   OUT count BIGINT)
AS $$
BEGIN
    SELECT count(*) INTO count
    FROM participants
    WHERE
        participants.first_name LIKE name_pattern;
END;
$$
LANGUAGE plpgsql;

SELECT * from get_participants_count('Н%а');