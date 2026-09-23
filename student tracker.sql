DROP DATABASE IF EXISTS student_tracker;
CREATE DATABASE student_tracker;
USE student_tracker;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address VARCHAR(100),
    admission_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    department_id INT,
    joining_date DATE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(60) NOT NULL,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE(student_id, course_id)
);

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    attendance_date DATE,
    status ENUM('Present','Absent','Late'),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks_obtained DECIMAL(5,2),
    grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Departments VALUES
(1,'Computer Science'),
(2,'Information Technology'),
(3,'Commerce'),
(4,'Data Science'),
(5,'Management');

INSERT INTO Students VALUES
(101,'Rahul Patel','2005-04-12','Male','rahul@gmail.com','9876543210','Ahmedabad','2024-07-10',1),
(102,'Priya Shah','2005-08-21','Female','priya@gmail.com','9876543211','Nikol','2024-07-12',4),
(103,'Jay Mehta','2004-11-15','Male','jay@gmail.com','9876543212','Bapunagar','2023-07-08',2),
(104,'Neha Desai','2005-02-18','Female','neha@gmail.com','9876543213','Maninagar','2024-07-15',3),
(105,'Karan Joshi','2004-06-30','Male','karan@gmail.com','9876543214','Vastral','2023-07-11',1),
(106,'Mansi Trivedi','2005-09-09','Female','mansi@gmail.com','9876543215','Chandkheda','2024-07-18',4),
(107,'Dev Solanki','2004-12-25','Male','dev@gmail.com','9876543216','Ghatlodia','2023-07-20',2),
(108,'Het Shah','2005-05-14','Male','het@gmail.com','9876543217','Naranpura','2024-07-22',5);

INSERT INTO Faculty VALUES
(201,'Amit Patel','amit.faculty@gmail.com','9898989801',1,'2019-06-10'),
(202,'Rina Shah','rina.faculty@gmail.com','9898989802',2,'2018-07-15'),
(203,'Suresh Mehta','suresh.faculty@gmail.com','9898989803',3,'2021-06-20'),
(204,'Kavita Joshi','kavita.faculty@gmail.com','9898989804',4,'2020-08-01');

INSERT INTO Courses VALUES
(301,'Python Programming',201),
(302,'Database Management',202),
(303,'Business Accounting',203),
(304,'Machine Learning',204),
(305,'Web Development',201),
(306,'Data Analytics',NULL);

INSERT INTO Enrollments VALUES
(401,101,301,'2024-07-15'),
(402,101,302,'2024-07-16'),
(403,102,304,'2024-07-16'),
(404,102,306,'2024-07-17'),
(405,103,302,'2024-07-18'),
(406,103,305,'2024-07-18'),
(407,104,303,'2024-07-19'),
(408,105,301,'2024-07-19'),
(409,105,305,'2024-07-20'),
(410,106,304,'2024-07-20'),
(411,107,302,'2024-07-21');

INSERT INTO Attendance VALUES
(501,101,301,'2024-08-01','Present'),
(502,101,301,'2024-08-02','Present'),
(503,101,301,'2024-08-03','Absent'),
(504,101,301,'2024-08-04','Present'),
(505,102,304,'2024-08-01','Present'),
(506,102,304,'2024-08-02','Present'),
(507,102,304,'2024-08-03','Present'),
(508,102,304,'2024-08-04','Present'),
(509,103,302,'2024-08-01','Absent'),
(510,103,302,'2024-08-02','Present'),
(511,103,302,'2024-08-03','Absent'),
(512,103,302,'2024-08-04','Late'),
(513,104,303,'2024-08-01','Present'),
(514,104,303,'2024-08-02','Present'),
(515,104,303,'2024-08-03','Present'),
(516,105,301,'2024-08-01','Present'),
(517,105,301,'2024-08-02','Absent'),
(518,105,301,'2024-08-03','Present');

INSERT INTO Grades VALUES
(601,101,301,88,'A'),
(602,101,302,76,'B'),
(603,102,304,94,'A+'),
(604,102,306,91,'A+'),
(605,103,302,69,'C'),
(606,103,305,82,'A'),
(607,104,303,73,'B'),
(608,105,301,58,'C'),
(609,105,305,79,'B'),
(610,106,304,87,'A'),
(611,107,302,64,'C');

INSERT INTO Students VALUES
(109,'Yash Parmar','2005-03-16','Male','yash@gmail.com','9876543218','Naroda','2024-07-25',1);

UPDATE Students
SET phone_number='9999999999',
address='Ahmedabad East'
WHERE student_id=109;

DELETE FROM Students
WHERE student_id=109;

SELECT *
FROM Students
WHERE department_id=1;

SELECT s.name,g.marks_obtained
FROM Students s
JOIN Grades g ON s.student_id=g.student_id
WHERE g.marks_obtained>70;

SELECT *
FROM Students
LIMIT 10;

SELECT department_id,COUNT(*) AS total_students
FROM Students
GROUP BY department_id
HAVING COUNT(*)>1;

SELECT s.name,g.marks_obtained
FROM Students s
JOIN Grades g ON s.student_id=g.student_id
WHERE g.marks_obtained<60
AND s.student_id IN (
    SELECT student_id
    FROM Attendance
    GROUP BY student_id
    HAVING SUM(status='Present')/COUNT(*)*100<50
);

SELECT DISTINCT s.name
FROM Students s
LEFT JOIN Grades g ON s.student_id=g.student_id
WHERE g.marks_obtained>90
OR s.student_id IN (
    SELECT student_id
    FROM Attendance
    GROUP BY student_id
    HAVING SUM(status='Present')/COUNT(*)*100>90
);

SELECT f.*
FROM Faculty f
WHERE NOT EXISTS (
    SELECT 1
    FROM Courses c
    WHERE c.faculty_id=f.faculty_id
);

SELECT *
FROM Students
ORDER BY name;

SELECT d.department_name,COUNT(s.student_id) AS total_students
FROM Departments d
LEFT JOIN Students s ON d.department_id=s.department_id
GROUP BY d.department_id,d.department_name;

SELECT c.course_name,ROUND(AVG(g.marks_obtained),2) AS average_marks
FROM Courses c
JOIN Grades g ON c.course_id=g.course_id
GROUP BY c.course_id,c.course_name;

SELECT ROUND(SUM(status='Present')/COUNT(*)*100,2) AS average_attendance
FROM Attendance;

SELECT MAX(marks_obtained) AS highest_marks
FROM Grades;

SELECT MIN(marks_obtained) AS lowest_marks
FROM Grades;

SELECT COUNT(*) AS total_students
FROM Students;

SELECT ROUND(AVG(marks_obtained),2) AS average_marks
FROM Grades;

SELECT s.student_id,s.name,d.department_name
FROM Students s
JOIN Departments d ON s.department_id=d.department_id;

SELECT f.faculty_id,f.name,d.department_name
FROM Faculty f
JOIN Departments d ON f.department_id=d.department_id;

SELECT s.name,d.department_name
FROM Students s
INNER JOIN Departments d ON s.department_id=d.department_id;

SELECT s.student_id,s.name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id=e.student_id
WHERE e.enrollment_id IS NULL;

SELECT c.course_name,f.name AS faculty_name
FROM Faculty f
RIGHT JOIN Courses c ON f.faculty_id=c.faculty_id
WHERE f.faculty_id IS NULL;

SELECT s.student_id,s.name,g.course_id,g.marks_obtained
FROM Students s
LEFT JOIN Grades g ON s.student_id=g.student_id
UNION
SELECT s.student_id,s.name,g.course_id,g.marks_obtained
FROM Students s
RIGHT JOIN Grades g ON s.student_id=g.student_id;

SELECT s.name,g.marks_obtained
FROM Students s
JOIN Grades g ON s.student_id=g.student_id
WHERE g.marks_obtained>(
    SELECT AVG(marks_obtained)
    FROM Grades
);

SELECT c.course_name,f.name
FROM Courses c
JOIN Faculty f ON c.faculty_id=f.faculty_id
WHERE TIMESTAMPDIFF(YEAR,f.joining_date,CURDATE())>=5;

SELECT s.name,COUNT(a.attendance_id) AS absent_classes
FROM Students s
JOIN Attendance a ON s.student_id=a.student_id
WHERE a.status='Absent'
GROUP BY s.student_id,s.name
HAVING COUNT(a.attendance_id)>10;

SELECT attendance_date,MONTH(attendance_date) AS attendance_month
FROM Attendance;

SELECT name,
TIMESTAMPDIFF(YEAR,admission_date,CURDATE()) AS years_since_admission
FROM Students;

SELECT attendance_id,
DATE_FORMAT(attendance_date,'%d-%m-%Y') AS formatted_date
FROM Attendance;

SELECT UPPER(name) AS student_name
FROM Students;

SELECT TRIM(name) AS clean_name
FROM Students;

SELECT name,IFNULL(email,'Not Provided') AS email
FROM Students;

SELECT s.name,g.marks_obtained,
RANK() OVER(ORDER BY g.marks_obtained DESC) AS student_rank
FROM Students s
JOIN Grades g ON s.student_id=g.student_id;

SELECT course_id,student_id,status,
ROUND(
SUM(status='Present') OVER(
PARTITION BY course_id
ORDER BY attendance_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) /
COUNT(*) OVER(
PARTITION BY course_id
ORDER BY attendance_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)*100,2
) AS running_attendance
FROM Attendance;

SELECT DATE_FORMAT(enrollment_date,'%Y-%m') AS month,
COUNT(*) AS monthly_enrollment,
SUM(COUNT(*)) OVER(
ORDER BY DATE_FORMAT(enrollment_date,'%Y-%m')
) AS running_total
FROM Enrollments
GROUP BY DATE_FORMAT(enrollment_date,'%Y-%m');

SELECT s.name,g.marks_obtained,
CASE
WHEN g.marks_obtained>90 THEN 'Excellent'
WHEN g.marks_obtained BETWEEN 75 AND 90 THEN 'Good'
ELSE 'Needs Improvement'
END AS performance_level
FROM Students s
JOIN Grades g ON s.student_id=g.student_id;

SELECT s.name,
ROUND(SUM(a.status='Present')/COUNT(*)*100,2) AS attendance_percentage,
CASE
WHEN SUM(a.status='Present')/COUNT(*)*100>80 THEN 'Regular'
WHEN SUM(a.status='Present')/COUNT(*)*100 BETWEEN 50 AND 80 THEN 'Irregular'
ELSE 'Defaulter'
END AS attendance_category
FROM Students s
JOIN Attendance a ON s.student_id=a.student_id
GROUP BY s.student_id,s.name;