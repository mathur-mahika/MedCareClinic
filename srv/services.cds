using clinicAppointments as db from '../db/schema';

service ClinicService {

    entity Appointments as projection on db.Appointments;
    entity Prescriptions as projection on db.Prescriptions;
    entity Patients as projection on db.Patients;
    entity Doctors as projection on db.Doctors;
    entity Specializations as projection on db.Specializations;

}