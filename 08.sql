/* Создать процедуру и триггеры (в том числе триггер, вызывающий
процедуру) по варианту, а также разработать небольшое приложение,
связывающееся с разработанной БД. Из приложения осуществить вставку
(удаление или изменение) данных, влекущую запуск триггера, осуществить
вызов хранимой процедуры, а также осуществить выполнение набора
команд (нескольких запросов) в виде единого пакета (транзакции) с откатом
в случае, если хотя бы одна из этих операций завершится неудачно.

   1. Разработать процедуру, формирующую расписание мероприятий
   2. Создать триггер на добавление участника, если дата регистрации не указана, установить текущую
   3. Разработать триггер на добавление мероприятия, если их в программе не более 3,
   в противном случае откатить транзакцию
   4. Разработать триггер на добавление участника на мероприятие, обновляющий
   общее число участников (для обновления разработать процедуру)
*/


-- Разработать процедуру, формирующую расписание мероприятий
CREATE OR REPLACE FUNCTION get_schedule()

    RETURNS TABLE (program_name VARCHAR,
                   event_name VARCHAR,
                   start_time TIME,
                   o_first_name VARCHAR,
                   o_last_name VARCHAR)
AS $$
    BEGIN
        RETURN QUERY SELECT p.program_name,
                            events.event_name,
                            events.start_time,
                            o.first_name,
                            o.last_name
        FROM events
            JOIN programs p on p.id = events.program_id
            JOIN organizers_of_events ooe on events.id = ooe.event_id
            JOIN organizers o on o.id = ooe.organizer_id
        ORDER BY p.id, events.start_time;
    END;
$$
LANGUAGE plpgsql;

SELECT * FROM get_schedule();

ALTER TABLE participants
ADD COLUMN registration_time TIMESTAMP;


-- Создать триггер на добавление участника, если дата регистрации не указана, установить текущую
CREATE OR REPLACE FUNCTION on_insert_in_participants()
RETURNS trigger
AS $$
    BEGIN
--         IF NEW.registration_time IS NULL THEN
--             NEW.registration_time = NOW();
--         END IF;
        NEW.registration_time = NOW();
        RETURN NEW;
    END;
$$LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_insert
BEFORE INSERT ON participants
FOR EACH ROW
WHEN (NEW.registration_time IS NULL)
EXECUTE FUNCTION on_insert_in_participants();

-- Тестирование
INSERT INTO participants (id, first_name, last_name, email, age, participant_gender)
VALUES
    (14, 'Имя', 'Фамилия', 'test@ya.ru', 20, 'М');

DELETE FROM participants
WHERE id = 14;


-- Разработать триггер на добавление мероприятия, если их в программе не более 3,
-- в противном случае откатить транзакцию
CREATE OR REPLACE FUNCTION on_insert_in_events()
RETURNS trigger
AS $$
    DECLARE
        event_count BIGINT;
    BEGIN
        event_count = (SELECT COUNT(*) FROM events WHERE events.program_id = NEW.program_id);
        IF event_count >= 3 THEN
            RAISE NOTICE 'on_insert_in_events(): В программе более 3 мероприятий. '
                'Добавление новых невозможно';
            RETURN NULL;
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_insert_into_events
BEFORE INSERT ON events
FOR EACH ROW
EXECUTE FUNCTION on_insert_in_events();

-- Тестирование
INSERT INTO events (id, event_name, start_time, duration, program_id)
VALUES
    (12, 'Название события', '13:25:00', 65, 1);

DELETE FROM events
WHERE id = 12;


-- Разработать триггер на добавление участника на мероприятие, обновляющий
-- общее число участников (для обновления разработать процедуру)

ALTER TABLE events
ADD COLUMN count_of_participants BIGINT;

CREATE OR REPLACE FUNCTION bad_update_participants()
    RETURNS void
AS $$
    DECLARE
        _id INTEGER;
        count BIGINT;
    BEGIN
        FOR _id, count IN (SELECT events.id, count(poe.participant_id) as count
            FROM events LEFT JOIN participants_of_events poe on events.id = poe.event_id
            GROUP BY events.id, event_name)
        LOOP
            UPDATE events
            SET count_of_participants = count
            WHERE id = _id;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM bad_update_participants();

CREATE OR REPLACE FUNCTION recount_participants()
RETURNS trigger
AS $$
    BEGIN
        UPDATE events
        SET count_of_participants = events.count_of_participants + 1
        WHERE events.id = NEW.event_id;
        RAISE NOTICE 'обновлено количество участников';
        RETURN NEW;
    END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_participants_count
AFTER INSERT ON participants_of_events
FOR EACH ROW
EXECUTE FUNCTION recount_participants();

INSERT INTO events.public.participants_of_events (participant_id, event_id)
VALUES
    (13, 2);