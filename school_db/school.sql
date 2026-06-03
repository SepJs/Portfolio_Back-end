CREATE TABLE students (
    id INT PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(32) NOT NULL,
    last_name VARCHAR(32) NOT NULL,
    passcode INT UNIQUE NOT NULL,
    category TEXT NOT NULL CHECK(category IN('Math', 'Biology')),
    class TEXT CHECK(class IN('01',))
)