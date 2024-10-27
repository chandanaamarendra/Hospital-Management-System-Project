select * from Patient$
select * from Doctor$
select * from PatientsAttendAppointments$
select * from Appointment$
select * from MedicalHistory$
select * from Medication_Cost$
select * from PatientsFillHistory$

//*1.Find the names of patients 
who have attended appointments scheduled by Dr. John Doe.*//

SELECT 
CONCAT(d.fname,d.Lname) as doc_name,
CONCAT(p.fname,p.lname) as Patient_name
FROM Patient$ p
 INNER JOIN PatientsAttendAppointments$ paa on p.PatientID = paa.PatientID
 INNER JOIN Appointment$ a on paa.AppointmentID = a.AppointmentID
 INNER JOIN Doctor$ d on d.DoctorID=a.DoctorID
WHERE d.DoctorID = 'D0001'

//*2.Calculate the average age of all patients.*//
SELECT ROUND(AVG(age),0) as avg_age_of_patients 
FROM Patient$

//*3.Create a stored procedure to 
get the total number of appointments for a given patient.*//

CREATE PROCEDURE Tot_app
@patientid nvarchar(5)
AS
BEGIN
    SELECT COUNT(*) as Total_appointments
	FROM Appointment$ a
	inner join PatientsAttendAppointments$ paa ON 
	a.AppointmentID = paa.AppointmentID
	WHERE paa.PatientID = @patientid;
END;
 
exec Tot_app P0002

//*4.Create a trigger to update the 
appointment status to 'Completed' when the appointment date has passed.*//
 
CREATE TRIGGER updatestatus
ON Appointment$
AFTER update
AS
BEGIN
    update a 
	SET a.Status = 'completed'
	FROM Appointment$ a
	inner join inserted i ON
	a.AppointmentID= i.AppointmentID
	WHERE i.Date < GETDATE();
END;
select * from Appointment$
UPDATE Appointment$
 SET  EndTime = '2023-11-07 11:20:00.000'
 WHERE  EndTime = '2023-11-07 10:20:00.000'
UPDATE Appointment$
 SET  EndTime = '2023-11-10 14:30:00.000'
 WHERE  EndTime = '2023-11-10 14:20:00.000' 
 
//*5.Find the names of patients along with their 
 appointment details and the corresponding doctor's name.*//

SELECT CONCAT(p.fname,p.lname) as Patients_name,a.AppointmentID,
 a.Date,a.EndTime,a.Status,CONCAT(d.fname,d.lname) as Doc_name
FROM Patient$ p
INNER JOIN Appointment$ a on p.PatientID = a.PatientID
INNER JOIN Doctor$ d on a.DoctorID = d.DoctorID;

//*6.Find the patients who have a medical history of diabetes 
  and their next appointment is scheduled within the next 7 days.*//

WITH PatientAppointments AS (
    SELECT 
	 p.PatientID, 
	 p.Fname, 
	 p.Lname, 
	 a.Date as FirstAppointmentDate
    FROM Patient$ p
    INNER JOIN PatientsAttendAppointments$ pa ON p.PatientID = pa.PatientID
    INNER JOIN Appointment$ a ON pa.AppointmentID = a.AppointmentID
    inner join MedicalHistory$ mh ON mh.PatientID=p.PatientID
	WHERE  
	 mh.Condition = 'Diabetes'
    GROUP BY 
	 p.PatientID, p.Fname, p.Lname, a.Date
)
SELECT 
 CONCAT(pa.Fname,' ',pa.Lname) as Patient_name,
 a.Date AS NextAppointmentDate
FROM PatientAppointments pa
INNER JOIN PatientsAttendAppointments$ pa2 ON pa.PatientID = pa2.PatientID
INNER JOIN Appointment$ a ON pa2.AppointmentID = a.AppointmentID
WHERE a.Date > pa.FirstAppointmentDate
  AND a.Date BETWEEN pa.FirstAppointmentDate 
  AND DATEADD(DAY, 7, pa.FirstAppointmentDate);

//*7.Find patients who have multiple appointments scheduled.*//
 
SELECT 
 p.PatientID,
 CONCAT(p.fname,' ',p.lname) as Patient_name,
 COUNT(*) as Total_appointments
FROM Patient$ p
INNER JOIN PatientsAttendAppointments$ paa ON p.PatientID=paa.PatientID
INNER JOIN Appointment$ a ON a.AppointmentID=paa.AppointmentID
GROUP BY p.PatientID,CONCAT(p.fname,' ',p.lname)
HAVING COUNT(*) > 1

//*8.Calculate the average duration of appointments for each doctor.*//

SELECT d.DoctorID,CONCAT(d.fname,' ',d.lname) as doctor_name,
  AVG(CASE
           WHEN a.EndTime > a.Date THEN DATEDIFF(minute, a.Date, a.EndTime)
           ELSE DATEDIFF(minute, a.Date, DATEADD(day, 1, a.EndTime))
       END) AS Avg_Duration_in_mins
FROM Doctor$ d
INNER JOIN Appointment$ a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID,CONCAT(d.fname,' ',d.lname)  

//*9.Find Patients with Most Appointments*//

SELECT p.PatientID as ID,
 CONCAT(p.fname,' ',p.lname) as Patient_name,
 COUNT(a.AppointmentID) as total_appointments
FROM Patient$ p
INNER JOIN PatientsAttendAppointments$ paa ON p.PatientID=paa.PatientID
INNER JOIN Appointment$ a ON a.AppointmentID=paa.AppointmentID
GROUP BY p.PatientID,CONCAT(p.fname,' ',p.lname) 
HAVING COUNT(a.AppointmentID) > 1;

//*10.Calculate the total cost of medication for each patient.*//

SELECT p.PatientID,mh.Medication,SUM(mc.Cost_in$) as total_cost
FROM Patient$ p
INNER JOIN MedicalHistory$ mh ON mh.PatientID = p.PatientID
INNER JOIN Medication_Cost$ mc ON mc.Medication = mh.Medication
GROUP BY p.PatientID,mh.Medication
ORDER BY SUM(mc.Cost_in$) desc
 

//*11.Create a stored procedure named CalculatePatientBill 
that calculates the total bill for a patient based on their 
medical history and medication costs. The procedure should take 
the PatientID as a parameter and calculate the total cost by 
summing up the medication costs and applying a charge of $50 
for each surgery in the patient's medical history. 
If the patient has no medical history, the procedure 
should still return a basic charge of $50.*//

CREATE PROCEDURE calculatepatientbill   
@patientid NVARCHAR(5)
AS
BEGIN    
DECLARE @totalmedicalcost DECIMAL(10,2) = 0;  
DECLARE @surgerycost DECIMAL(10,2) = 0;
   SELECT @totalmedicalcost = SUM(mc.cost_in$)
   FROM Medication_Cost$ mc
    INNER JOIN MedicalHistory$ mh ON mh.Medication = mc.Medication
    WHERE mh.PatientID = @patientid;
   SELECT @surgerycost = COUNT(*) * 50    
   FROM MedicalHistory$ mh 
    WHERE mh.PatientID = @patientid AND mh.Surgeries IS NOT NULL;
    DECLARE @totalbill DECIMAL(10,2) = @totalmedicalcost + @surgerycost; 
	IF @totalbill = 0         
	SET @totalbill = 50;   
	SELECT @totalbill AS Total_bill;
END;

exec calculatepatientbill P0001
exec calculatepatientbill P0002
exec calculatepatientbill P0003
exec calculatepatientbill P0004



 