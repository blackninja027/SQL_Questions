CREATE TABLE Trips (
    id INT,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(20),
    request_at DATE
);

INSERT INTO Trips (id, client_id, driver_id, city_id, status, request_at) VALUES
    (1, 1, 10, 1, 'completed', '2023-07-12'),
    (2, 2, 11, 1, 'cancelled_by_driver', '2023-07-12'),
    (3, 3, 12, 6, 'completed', '2023-07-12'),
    (4, 4, 13, 6, 'cancelled_by_client', '2023-07-12'),
    (5, 1, 10, 1, 'completed', '2023-07-13'),
    (6, 2, 11, 6, 'completed', '2023-07-13'),
    (7, 3, 12, 6, 'completed', '2023-07-13'),
    (8, 2, 12, 12, 'completed', '2023-07-14'),
    (9, 3, 10, 12, 'completed', '2023-07-14'),
    (10, 4, 13, 12, 'cancelled_by_driver', '2023-07-14');

CREATE TABLE Users (
    users_id INT,
    banned VARCHAR(3),
    role VARCHAR(10)
);

INSERT INTO Users (users_id, banned, role) VALUES
    (1, 'No', 'client'),
    (2, 'Yes', 'client'),
    (3, 'No', 'client'),
    (4, 'No', 'client'),
    (10, 'No', 'driver'),
    (11, 'No', 'driver'),
    (12, 'No', 'driver'),
    (13, 'No', 'driver');


select * from Trips;
select * from Users;

with Unbanned as(
select t.request_at as Day, count(*) as Total_requests, 
cast(count(case when status like 'cancelled%' then 1 end) as float) as Cancelled_requests 
from Trips as t
join Users as u1
on t.client_id=u1.users_id
join Users as u2
on t.driver_id=u2.users_id
where u1.banned='No' and u2.banned='No'
group by request_at)

select Day, round(Cancelled_requests/ Total_requests, 2)  as Cancellation_Rate
from Unbanned
Order by Day;


