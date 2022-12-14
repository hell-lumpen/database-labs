INSERT INTO events.public.companies (id, company_name)
VALUES
    (1, 'Газпром'),
    (2, 'Яндекс'),
    (3, 'МАИ'),
    (4, 'МФТИ');

INSERT INTO events.public.programs (id, program_name, description)
VALUES
    (1, 'ГЛАВНАЯ СЦЕНА', 'Основная сцена'),
    (2, 'СТУДИЯ', 'Для всех, кого волнует тема образования'),
    (3, 'ЯРМАРКА ОБРАЗОВАНИЯ', 'Для всех, кто хочет учиться и делать это эффективно'),
    (4, 'КОВОРКИНГ', 'Для тех, кто создаёт образовательные сервисы и проекты');

INSERT INTO events.public.organizers (id, first_name, last_name, email, company_id)
VALUES
    (1, 'Дмитрий', 'Сошников', 'soshnikov@mai.ru', 3),
    (2, 'Анна', 'Трунина', 'trunina@yandex-team.ru', 2),
    (3, 'Алексей', 'Малев', 'malev@phystech.ru', 4),
    (4, 'Адель', 'Шадрина', 'shadrina@yandex-team.ru', 2),
    (5, 'Алексей', 'Шпильман', 'shpilman@gasprom.ru', 1);

INSERT INTO events.public.participants (id, first_name, last_name, email)
VALUES
    (1, 'Максим', 'Грубенко', 'grubenko.m@ya.ru'),
    (2, 'Иван', 'Иванов', 'ivanov@ya.ru'),
    (3, 'Петр', 'Петров', 'petrov@ya.ru'),
    (4, 'Сергей', 'Сергеев', 'sergeev@ya.ru'),
    (5, 'Алексей', 'Алексеев', 'alekseev@ya.ru'),
    (6, 'Федор', 'Федоров', 'fedorov@ya.ru'),
    (7, 'Никита', 'Никитин', 'nikitin@ya.ru'),
    (8, 'Дмитрий', 'Иванов', 'email@ya.ru'),
    (9, 'Алексей', 'Иванов', 'ivanov1@ya.ru'),
    (10, 'Никита', 'Петров', 'petrov2@ya.ru');

INSERT INTO events.public.events (id, event_name, start_time, duration, program_id)
VALUES
    (1, 'Как пройти первый месяц онлайн-обучения и не сдаться', '14:00:00', 135, 3),
    (2, 'Как IT помогает переосмыслить подход к инженерному образованию', '13:30:00', 180, 1),
    (3, 'Образование в IT. Что-то тут не так', '10:30:00', 45, 1),
    (4, 'Дорога в IT: реальные кейсы и непридуманные истории', '10:30:00', 75, 2),
    (5, 'Как найти точку приложения прикладной математики?', '15:30:00', 125, 1),
    (6, 'Офлайн против онлайна', '12:00:00', 30, 4);

INSERT INTO events.public.organizers_of_events (organizer_id, event_id)
VALUES
    (1, 2), (2, 4), (3, 6), (4, 1), (5, 3), (1, 5), (1, 1), (3, 2);

INSERT INTO events.public.participants_of_events (participant_id, event_id)
VALUES
    (1, 1), (1, 2), (1, 3), (1, 4), (2, 2), (2, 4), (2, 5), (3, 2), (3, 6), (4, 1),
    (5, 4), (5, 1), (5, 2), (6, 1), (6, 2), (6, 5), (6, 6), (7, 3), (7, 1);