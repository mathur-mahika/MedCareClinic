namespace clinicAppointments;

using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';


entity Countries: CodeList {
    key CountryCode: String(3);
    name: String(100);
    currency: Association to Currencies;
}

type Address : {
    street  : String(50);
    city    : String(50);
    state   : String(50);
    pincode : String(6);
    country : Association to Countries @assert.target;
}

entity Doctors : cuid {
    name : String(50);
    address: Address;
    specialization: Association to Specializations @assert.target;
    Appointments: Association to many Appointments on Appointments.doctor = $self;
    Prescriptions: Association to many Prescriptions on Prescriptions.doctor = $self;
}

entity Specializations : CodeList {
    key code  : String(20);
    title : String(50);
    desc  : String(300);
    doctors: Association to many Doctors on doctors.specialization = $self;
}

entity Currencies : CodeList {
    key code  : String(20);
    title : String(50);
    country  : Association to Countries @assert.target;
    Patient: Association to many Patients on Patient.currencyUsed = $self;
}

entity Patients : cuid {
    name : String(50);
    address: Address;
    dateOfBirth: Date;
    email: String(100) @assert.format : '^[^@] + @[^@] + $' @mandatory;
    phone: String(10);
    currencyUsed: Association to Currencies @assert.target;
    Appointments: Association to many Appointments on Appointments.patient = $self;
    Prescriptions: Association to many Prescriptions on Prescriptions.patient = $self;
}

type appointmentStatus : String(20) enum{
    scheduled = 'SCHEDULED';
    completed = 'COMPLETED';
    cancelled = 'CANCELLED';
    noShow = 'NO SHOW';
}

entity Appointments : cuid, managed {
    appointmentDate: Date;
    appointmentTime: Time;
    status: appointmentStatus default 'SCHEDULED';
    doctor: Association to Doctors @asser.target;
    patient: Association to Patients @asser.target;
    Prescriptions: Composition of many Prescriptions on Prescriptions.appointment = $self;
}

entity Prescriptions: cuid, managed {
    medicineName: String(2000);
    dosage: String(100);
    duration: Integer;
    patient: Association to Patients @asser.target;
    doctor: Association to Doctors @asser.target;
    appointment: Association to Appointments @asser.target;
}
