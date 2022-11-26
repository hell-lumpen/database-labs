/*
 Создать процедуру, вставляющую записи через первое представление из предыдущего задания.
 Вставить как минимум 2 записи (т.е. вызвать процедуру дважды).
 Получить результат, формируемый третьим представлением (предыдущего задания) через выполнение нескольких запросов,
 объединённых в процедуру. Создать процедуру с параметром по умолчанию и выходным параметром.
 */

CREATE OR REPLACE FUNCTION foo(id INTEGER,
                               event_name VARCHAR,
                               start_time TIME,
                               program_id INTEGER)
    RETURNS void
    LANGUAGE SQL
    AS $$
    INSERT INTO list_of_events_view1
    VALUES (id, event_name, start_time, program_id)
$$;

SELECT foo(10, 'event_name2', '11:00:00', 1);
SELECT foo(11, 'event_name3', '12:00:00', 2);