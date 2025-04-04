-- Create Healthcare Data Database
CREATE DATABASE health_care_data_DB;
USE health_care_data_DB;

-- Create Patient Dimension Table
CREATE TABLE dim_patient (
    Patient_ID INT PRIMARY KEY,
    Name VARCHAR(35),
    Gender CHAR(1),
    Age INT,
    Address VARCHAR(100),
    Contact_Number VARCHAR(20)
);

-- Create Doctor Dimension Table
CREATE TABLE dim_doctor (
    Doctor_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Specialization VARCHAR(50),
    Department VARCHAR(50),
    Contact VARCHAR(20)
);

-- Create Hospital Dimension Table
CREATE TABLE dim_hospital (
    Hospital_ID INT PRIMARY KEY,
    Hospital_Name VARCHAR(55),
    Location VARCHAR(55),
    Capacity INT
);

-- Create Diagnosis Dimension Table
CREATE TABLE dim_diagnosis (
    Diagnosis_ID INT PRIMARY KEY,
    Disease_Name VARCHAR(55),
    Severity VARCHAR(50),
    Treatment VARCHAR(55)
);

-- Create Fact Table for Patient Visits
CREATE TABLE fact_patient_visits (
    Visit_ID INT PRIMARY KEY,
    Patient_ID INT,
    Doctor_ID INT,
    Hospital_ID INT,
    Diagnosis_ID INT,
    Admission_Date DATE,
    Discharge_Date DATE,
    Total_Cost DECIMAL(10,2),
    Insurance_Covered DECIMAL(10,2),
    
    FOREIGN KEY (Patient_ID) REFERENCES dim_patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES dim_doctor(Doctor_ID) ON DELETE CASCADE,
    FOREIGN KEY (Hospital_ID) REFERENCES dim_hospital(Hospital_ID) ON DELETE CASCADE,
    FOREIGN KEY (Diagnosis_ID) REFERENCES dim_diagnosis(Diagnosis_ID) ON DELETE CASCADE
);

-- Insert sample data into Patient Dimension Table
INSERT INTO dim_patient VALUES
(501, 'Luffy', 'M', 45, 'NY, USA', '123-456-7890'),
(502, 'Naruto', 'F', 32, 'CA, USA', '987-654-3210');

-- Insert sample data into Doctor Dimension Table
INSERT INTO dim_doctor VALUES
(301, 'Dr. Shanks', 'Cardiologist', 'Cardiology', '555-1111'),
(302, 'Dr. Jiraiya', 'Neurologist', 'Neurology', '555-2222');

-- Insert sample data into Hospital Dimension Table
INSERT INTO dim_hospital VALUES
(101, 'One Piece Hospital', 'NY, USA', 500),
(102, 'Leaf Village Hospital', 'CA, USA', 700);

-- Insert sample data into Diagnosis Dimension Table
INSERT INTO dim_diagnosis VALUES
(201, 'Memory Loss', 'High', 'Cognitive therapy'),
(202, 'Anxiety', 'Medium', 'Counseling');

-- Insert sample data into Patient Visits Fact Table
INSERT INTO fact_patient_visits VALUES
(1001, 501, 301, 101, 201, '2024-03-10', '2024-03-12', 5000.00, 4000.00),
(1002, 502, 302, 102, 202, '2024-03-11', '2024-03-15', 12000.00, 10000.00);

## Sample Queries for Data Analysis
#Total Patients Treated Per Hospital
SELECT h.Hospital_Name, COUNT(DISTINCT v.Patient_ID) AS Total_Patients
FROM fact_patient_visits v
JOIN dim_hospital h ON v.Hospital_ID = h.Hospital_ID
GROUP BY h.Hospital_Name;

#Average Treatment Cost Per Disease
SELECT d.Disease_Name, AVG(v.Total_Cost) AS Avg_Cost
FROM fact_patient_visits v
JOIN dim_diagnosis d ON v.Diagnosis_ID = d.Diagnosis_ID
GROUP BY d.Disease_Name;

#Insurance Coverage Percentage
SELECT 
    (SUM(Insurance_Covered) / SUM(Total_Cost)) * 100 AS Coverage_Percentage
FROM fact_patient_visits;

# Average Length of Hospital Stay
SELECT h.Hospital_Name, AVG(DATEDIFF(v.Discharge_Date, v.Admission_Date)) AS Avg_Stay_Days
FROM fact_patient_visits v
JOIN dim_hospital h ON v.Hospital_ID = h.Hospital_ID
GROUP BY h.Hospital_Name;




