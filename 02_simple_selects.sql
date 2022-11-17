/*
Наполнить	таблицы	тестовыми	данными	(5-10	записей	в	каждой)	с использованием запросов модификации данных (insert, update, delete).
Для сущностей полученной БД написать по три простых запроса каждого из следующих видов:
1.	Содержащий условие сравнения (>, <, >=, <=, <>, =)
2.	Содержащий оператор BETWEEN
3.	Содержащий оператор IN
4.	Содержащий оператор LIKE
5.	Содержащий оператор DISTINCT или предикат IS NULL/NOT IS NULL

Результатом	выполнения	задания	является	сам	запрос	и	полученная (результирующая) таблица.
В отчете привести запросы и результаты их выполнения.
*/

SELECT event_name, start_time FROM events.public.events
WHERE program_id = 1;

SELECT event_name, duration FROM events.public.events
WHERE duration > '01:00:00' AND program_id = 1;

SELECT first_name, last_name FROM events.public.organizers
WHERE company_id <> 3;

SELECT event_name, duration FROM events.public.events
WHERE start_time BETWEEN '14:00:00' AND '18:00:00';

SELECT * FROM events.public.participants
WHERE id BETWEEN 3 AND 6 AND first_name <> 'Сергей';

SELECT program_name, description FROM events.public.programs
WHERE id BETWEEN 2 AND 4;

SELECT * FROM events.public.organizers
WHERE first_name IN ('Дмитрий', 'Алексей') AND company_id IN (1, 2);

SELECT * FROM events.public.participants
WHERE last_name IN ('Николаев', 'Иванов', 'Федоров');

SELECT * FROM events.public.companies
WHERE company_name IN ('Microsoft', 'Apple', 'Яндекс', 'VK');

SELECT first_name, last_name FROM events.public.participants
WHERE first_name LIKE 'А%й';

SELECT first_name, last_name FROM events.public.participants
WHERE last_name LIKE '%в';

SELECT first_name, last_name FROM events.public.organizers
WHERE last_name LIKE '_а%';

SELECT first_name, last_name FROM events.public.organizers
WHERE last_name LIKE '_а%';

SELECT DISTINCT first_name FROM events.public.participants;

SELECT * FROM events.public.programs
WHERE description IS NOT NULL;

SELECT * FROM events.public.participants_of_events
WHERE participants_of_events.event_id IS NULL;
