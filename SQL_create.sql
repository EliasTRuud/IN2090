-- Datatypes:
SQL has various datatypes that can be used to store different types of data. Some commonly used datatypes in SQL include:

1. Integer (INT): Used to store whole numbers.
2. Decimal/numeric (DECIMAL/NUMERIC): Used to store precise decimal numbers.
3. Varchar/char (VARCHAR/CHAR): Used to store variable-length character strings.
4. Date (DATE): Used to store date values.
5. Time (TIME): Used to store time values.
6. Timestamp (TIMESTAMP): Used to store date and time values.
7. Boolean (BOOL): Used to store true/false values.
8. Binary (BINARY): Used to store binary data like images or files.
9. Text (TEXT): Used to store large amounts of character data.
10. Blob (BLOB): Used to store large binary objects like images or files.

/*
The most commonly used datatypes in SQL may vary depending on the specific use case and requirements. 
However, VARCHAR, INT, DATE, and DECIMAL (or NUMERIC) are often widely used datatypes that cover a broad range.
*/;



--Constraints
/*
Are rules and limitations applied to the data in database tables. 
They enforce data integrity and ensure that the data meets certain criteria. Here are some common constraints in SQL:
*/
1. PRIMARY KEY: Ensures that a column or a combination of columns uniquely identifies each row in a table. It prevents duplicate or null values in the designated column(s).
2. FOREIGN KEY: Establishes a relationship between two tables by referencing the primary key of one table into another table. It ensures referential integrity by matching values with the primary key in the referenced table.
3. UNIQUE: Restricts a column or a set of columns to hold only unique values. It prevents duplicate values but allows null values.
4. NOT NULL: Ensures that a column cannot have null values. It requires every row to have a value in that column.
5. CHECK: Specifies a condition that must be true for the data to be inserted or updated into a column. It ensures that the data meets certain criteria.
6. DEFAULT: Sets a default value for a column when no value is specified during an insert statement.;

-- Adding contraints after table made using ALTER TABLE:
- Adding a NOT NULL constraint to the "emp_name" column:
    ALTER TABLE employees
    ALTER COLUMN emp_name SET NOT NULL;
This ALTER TABLE statement alters the "employees" table and sets the "emp_name" column as NOT NULL, meaning it must have a value for every record.

- Adding a FOREIGN KEY constraint to the "manager_id" column:
    ALTER TABLE employees
    ADD CONSTRAINT fk_manager
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id);
This ALTER TABLE statement adds a FOREIGN KEY constraint named "fk_manager" to the "employees" table. It specifies that the "manager_id" column references the "emp_id" column in the same table.

- Adding a UNIQUE constraint to the "emp_name" column:
    ALTER TABLE employees
    ADD CONSTRAINT uc_emp_name UNIQUE (emp_name);
This ALTER TABLE statement adds a UNIQUE constraint named "uc_emp_name" to the "employees" table. It ensures that the "emp_name" column values are unique across all records.


-- SERIAL
/*
SERIAL is a data type that automatically generates a unique integer value for each row inserted into a table. 
It is commonly used for primary key columns to ensure each row has a unique identifier.
*/
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);
--Insert a new row into the "customers" table without specifying a value for "customer_id". The value will be automatically generated:
INSERT INTO customers (first_name, last_name, email)
VALUES ('John', 'Doe', 'john.doe@example.com');

-- or Insert a new row into the "customers" table by explicitly setting the value for "customer_id" using the DEFAULT keyword:
INSERT INTO customers (customer_id, first_name, last_name, email)
VALUES (DEFAULT, 'John', 'Doe', 'john.doe@example.com');

customer_id | first_name | last_name |        email        
-------------+------------+-----------+---------------------
           1 | John       | Doe       | john.doe@example.com



-- Important functions 

-- 1. CREATE TABLE: This function is used to create a new table in the database. For example:
CREATE TABLE employees (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  age INT
);
This statement creates a table named "employees" with columns for id, name, and age.

-- 2. ALTER TABLE: This function is used to modify the structure of an existing table. For example:
ALTER TABLE employees
ADD COLUMN salary DECIMAL(10,2);
This statement adds a new column named "salary" to the "employees" table.

-- 3. INSERT INTO: This function is used to add new records to a table. For example:
INSERT INTO employees (id, name, age, salary)
VALUES (1, 'John Doe', 30, 50000);
This statement inserts a new record with the specified values into the "employees" table.

-- 4. UPDATE: This function is used to modify existing records in a table. For example:
    UPDATE employees 
    SET age = 35 
    WHERE id = 1;
This statement updates the "age" column to 35 for the record with id 1 in the "employees" table.

-- 5. DELETE: This function is used to remove one or more records from a table. For example:
    DELETE FROM employees 
    WHERE id = 1;
This statement deletes the record with id 1 from the "employees" table.

-- 6. DROP TABLE: This function is used to delete a table and its associated data. For example:
    DROP TABLE employees;
This statement deletes the "employees" table and removes all of its data.

-- 7. CREATE INDEX: This function is used to create an index on one or more columns of a table for faster data retrieval. For example:
    CREATE INDEX idx_name 
    ON employees (name);
This statement creates an index named "idx_name" on the "name" column of the "employees" table.

-- 8. FOREIGN KEY CONSTRAINT: This function is used to establish a relationship between two tables to enforce referential integrity. For example:
CREATE TABLE departments (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES employees(id)
);
This statement creates a "departments" table with a foreign key constraint that references the "id" column of the "employees" table.

-- 9. PRIMARY KEY CONSTRAINT: This function is used to specify a column or combination of columns that uniquely identifies each row in a table. For example:
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  quantity INT
);
This statement creates an "orders" table with a primary key constraint on the "order_id" column.

-- 10. TRUNCATE: The TRUNCATE statement is used to remove all data from a table. Here's an example of a TRUNCATE statement to remove all rows from the "employees" table:
TRUNCATE TABLE employees;

-- 11. COMMENT: The COMMENT statement is used to add comments to a database object. Here's an example of a COMMENT statement to add a comment to the "employees" table:
COMMENT ON TABLE employees IS 'This table stores employee information';

-- 12. RENAME: The RENAME statement is used to rename an existing database object. Here's an example of a RENAME statement to rename the "employees" table to "staff":
ALTER TABLE employees RENAME TO staff;

-- 13. INDEX: The INDEX statement is used to create an index on one or more columns of a table to improve query performance. Here's an example of an INDEX statement to create an index on the "id" column of the "employees" table:
CREATE INDEX idx_employee_id ON employees(id);

-- 14. SEQUENCE: The SEQUENCE statement is used to create a sequence object in a database, which can be used to generate unique ID numbers for tables. Here's an example of a SEQUENCE statement to create a new sequence object called "employee_id_seq":
CREATE SEQUENCE employee_id_seq;

-- 15. CASCADE:  is a referential action that is used to ensure the consistency of data in related tables. 
-- When a CASCADE constraint is applied to a foreign key, it ensures that the corresponding rows in the referenced table are updated or deleted when a row in the referencing table is updated or deleted.
Consider two tables, "departments" and "employees". The "employees" table has a foreign key "dept_id" that references the "departments" table.

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT REFERENCES departments(dept_id) ON DELETE CASCADE
);

In this example, the ON DELETE CASCADE constraint is applied to the foreign key "dept_id" in the "employees" table. It means that when a department is deleted from the "departments" table, all associated employees will also be deleted automatically.

departments table
+---------+---------------+
| dept_id |  dept_name    |
+---------+---------------+
|   1     | Engineering   |
|   2     | Sales         |
+---------+---------------+

employees table
+---------+--------------+----------+
| emp_id  | emp_name     | dept_id  |
+---------+--------------+----------+
|   101   | John Doe     |    1     |
|   102   | Jane Smith   |    1     |
|   103   | Mike Johnson |    2     |
+---------+--------------+----------+

Now, if we delete the department with dept_id 1 from the "departments" table:

DELETE FROM departments WHERE dept_id = 1;

The result will be:

departments table
+---------+---------------+
| dept_id |  dept_name    |
+---------+---------------+
|   2     | Sales         |
+---------+---------------+

employees table
+---------+--------------+----------+
| emp_id  | emp_name     | dept_id  |
+---------+--------------+----------+
|   103   | Mike Johnson |    2     |
+---------+--------------+----------+

As you can see, not only was the department row deleted from the "departments" table, but also the associated employee rows were automatically deleted from the "employees" table due to the CASCADE constraint.;



-- Combined example for Northwind
/*
In this example, we start by creating a new table named "orders_info" to store information about customer orders. 
We add some constraints and an index to the  table, along with a comment to provide information about its purpose. 
We then create a new sequence to generate unique 
order IDs, and insert a new row into the table using the generated sequence value.

Next, we update the "orders_info" table to add a missing ShipVia value for a specific order. Finally, we drop the table using the DROP statement.
*/;

-- Create a new table named "orders_info"
CREATE TABLE orders_info (
  OrderID INTEGER PRIMARY KEY,
  CustomerID CHAR(5),
  EmployeeID INTEGER,
  OrderDate DATE,
  ShipVia INTEGER,
  ShipCity VARCHAR(15),
  FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
  FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID),
  FOREIGN KEY (ShipVia) REFERENCES shippers(ShipperID)
);

-- Add a comment to the "orders_info" table
COMMENT ON TABLE orders_info IS 'This table stores information about customer orders';

-- Add a check constraint to the "orders_info" table
ALTER TABLE orders_info ADD CONSTRAINT chk_order_date CHECK (OrderDate >= '1996-01-01');

-- Create a new index named "idx_orders_ship_city" on the "ShipCity" column of the "orders_info" table
CREATE INDEX idx_orders_ship_city ON orders_info(ShipCity);

-- Create a new sequence named "order_id_seq" for generating unique order IDs
CREATE SEQUENCE order_id_seq START WITH 10248 INCREMENT BY 1;

-- Insert a new row into the "orders_info" table using the generated sequence value for the OrderID column
INSERT INTO orders_info (OrderID, CustomerID, EmployeeID, OrderDate, ShipVia, ShipCity) VALUES (NEXTVAL('order_id_seq'), 'ALFKI', 2, '1996-07-04', 1, 'Mexico City');

-- Update the "orders_info" table to add a missing ShipVia value for a specific order
UPDATE orders_info SET ShipVia = 2 WHERE OrderID = 10249;

-- Drop the "orders_info" table
DROP TABLE orders_info;