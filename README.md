 # HOSPITAL MANAGEMENT PROJECT
## Project Overview
This SQL-based Hospital Management System (HMS) project is designed to streamline and optimize hospital operations, enhancing patient care and administrative efficiency. The project integrates various aspects of hospital workflows, from patient registration and appointment scheduling to billing and medication management.

## Objectives
1. Enhance Patient Care: Simplify appointment booking, provide easy access to patient histories, and track treatments efficiently.
2. Improve Operational Efficiency: Facilitate quick retrieval of data, optimize doctor schedules, and streamline billing processes.
3. Ensure Data Integrity and Security: Maintain data consistency and security through a structured database schema and stored procedures.
4. Enable Data-Driven Decisions: Generate insights on patient demographics and analyze patterns in appointments and medical histories.
## Key Features
1. Patient Management: Manage patient data, including personal information, medical history, and visit records.
2. Doctor and Staff Management: Track doctor schedules and workloads to optimize resource distribution.
3. Appointment Scheduling: Schedule and manage patient appointments efficiently.
4. Medical History Tracking: Record and retrieve patient medical histories, including medication and surgeries.
5. Billing and Invoice Generation: Automate billing calculations based on treatments and medications used.
## Database Schema
The project uses a relational database schema with tables for:

1. Patient$: Stores patient details.
2. Doctor$: Stores doctor details.
3. Appointment$: Stores appointment details.
4. PatientsAttendAppointments$: Tracks which patients attend which appointments.
5. MedicalHistory$: Records medical conditions and surgeries for patients.
6. Medication_Cost$: Lists the costs of various medications.
![Screenshot 2024-10-27 105558](https://github.com/user-attachments/assets/e1a3d840-ad87-4d02-8cde-8205cc2ac316)

## SQL Queries & Analysis
Sample SQL queries used in the project include:

1. Patient Appointment Analysis: Retrieves scheduled appointments for a specific doctor. 
![Screenshot 2024-10-27 105700](https://github.com/user-attachments/assets/d488c3bc-f59b-4328-926f-5a879e43a77e)

2. Doctor Workload Analysis: Analyzes doctor workload by counting appointments per doctor.![Screenshot 2024-10-27 105737](https://github.com/user-attachments/assets/73c5d4aa-c66a-403d-a511-ddcea19e441c)

3. Patient Health Analysis: Counts unique medications and surgeries for patients, aiding in personalized care.![Screenshot 2024-10-27 105812](https://github.com/user-attachments/assets/f66c1dd7-b108-4b22-94a2-be9781d89063)

4. Billing Calculation (Stored Procedure): Automates patient billing based on their medical treatments and surgeries.![Screenshot 2024-10-27 105843](https://github.com/user-attachments/assets/46136d51-ee83-441f-b452-c52f49fbb3d2)

## Future Opportunities
1. Enhanced Patient Experience: Improve care delivery and appointment scheduling.
2. Optimized Resource Management: Better allocate resources based on workload analysis.
3. Cost Management: Track and optimize medication and treatment costs.![Screenshot 2024-10-27 105935](https://github.com/user-attachments/assets/166aac88-82e3-40b7-8970-ce1f98b213aa)

## Conclusion
This project demonstrates the potential of data-driven solutions in healthcare, providing a foundation for efficient, scalable hospital management. Through SQL-based data integration and analysis, the system offers insights to enhance patient care, optimize hospital operations, and support healthcare decision-making.
## License
This project is licensed under the MIT License. See the LICENSE file for details.
