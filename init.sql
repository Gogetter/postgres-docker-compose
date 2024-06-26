-- Create a table for storing patient information
CREATE TABLE patients (
    patient_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a table for storing staff information
CREATE TABLE staff (
    staff_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    hire_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a table for storing appointment information
CREATE TABLE appointments (
    appointment_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    staff_id BIGINT NOT NULL REFERENCES staff(staff_id) ON DELETE CASCADE,
    appointment_date TIMESTAMP NOT NULL,
    appointment_reason TEXT,
    status VARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'Completed', 'Cancelled'))
);

-- Create a table for storing medical records
CREATE TABLE medical_records (
    record_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    staff_id BIGINT REFERENCES staff(staff_id) ON DELETE SET NULL,
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    diagnosis TEXT,
    treatment TEXT,
    notes TEXT
);

-- Insert sample data into patients table
DO $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO patients (first_name, last_name, date_of_birth, gender, contact_number, email, address)
        VALUES (
            'PatientFirst' || i,
            'PatientLast' || i,
            '1990-01-01'::DATE + (i * 365)::INTERVAL,
            CASE WHEN i % 3 = 0 THEN 'M' WHEN i % 3 = 1 THEN 'F' ELSE 'O' END,
            '555-' || lpad(i::TEXT, 4, '0'),
            'patient' || i || '@example.com',
            i || ' Some St, City'
        );
    END LOOP;
END $$;

-- Insert sample data into staff table
DO $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO staff (first_name, last_name, position, contact_number, email, address)
        VALUES (
            'StaffFirst' || i,
            'StaffLast' || i,
            CASE WHEN i % 2 = 0 THEN 'Nurse' ELSE 'Doctor' END,
            '555-' || lpad(i::TEXT, 4, '0'),
            'staff' || i || '@example.com',
            i || ' Work St, City'
        );
    END LOOP;
END $$;

-- Insert sample data into appointments table
DO $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO appointments (patient_id, staff_id, appointment_date, appointment_reason)
        VALUES (
            i,
            ((i - 1) % 50) + 1,
            '2024-06-01 10:00:00'::TIMESTAMP + (i * '1 day'::INTERVAL),
            'Reason for appointment ' || i
        );
    END LOOP;
END $$;

-- Insert sample data into medical records table
DO $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO medical_records (patient_id, staff_id, record_date, diagnosis, treatment, notes)
        VALUES (
            i,
            ((i - 1) % 50) + 1,
            '2024-06-01 10:30:00'::TIMESTAMP + (i * '1 day'::INTERVAL),
            'Diagnosis ' || i,
            'Treatment ' || i,
            'Notes for record ' || i
        );
    END LOOP;
END $$;
