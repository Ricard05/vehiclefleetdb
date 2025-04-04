CREATE TABLE
    "User" (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );

CREATE TABLE
    Admin (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        user_id UUID UNIQUE REFERENCES "User" (id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );

CREATE TABLE
    Driver (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        user_id UUID UNIQUE REFERENCES "User" (id) ON DELETE CASCADE,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        employee_number TEXT UNIQUE NOT NULL,
        license TEXT NOT NULL,
        license_expiration DATE NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );

CREATE TABLE
    Vehicle (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        model TEXT NOT NULL,
        plate TEXT UNIQUE NOT NULL,
        capacity INT NOT NULL,
        mileage INT NOT NULL,
        last_maintenance_date TIMESTAMP NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );

CREATE TABLE
    Route (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        origin TEXT NOT NULL,
        destination TEXT NOT NULL,
        distance FLOAT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );

CREATE TABLE
    CargoType (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        name TEXT UNIQUE NOT NULL,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );

CREATE TABLE
    Trip (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        driver_id UUID REFERENCES Driver (id) ON DELETE CASCADE,
        vehicle_id UUID REFERENCES Vehicle (id) ON DELETE CASCADE,
        route_id UUID REFERENCES Route (id) ON DELETE CASCADE,
        cargo_type_id UUID REFERENCES CargoType (id) ON DELETE CASCADE,
        date TIMESTAMP NOT NULL,
        departure_time TIME NOT NULL,
        arrival_time TIME NOT NULL,
        passenger_count INT CHECK (passenger_count >= 0),
        state TEXT CHECK (
            state IN (
                'PENDIENTE',
                'EN_CAMINO_AL_DESTINO',
                'CARGA_ENTREGADA',
                'EN_CAMINO_AL_ORIGEN',
                'FINALIZADO'
            )
        ) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );

CREATE TABLE
    VehicleInspection (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        trip_id UUID UNIQUE REFERENCES Trip (id) ON DELETE CASCADE,
        vehicle_id UUID REFERENCES Vehicle (id) ON DELETE CASCADE,
        kilometer INT CHECK (kilometer >= 0) NOT NULL,
        engine_status TEXT NOT NULL,
        tire_condition TEXT NOT NULL,
        brake_status TEXT NOT NULL,
        fuel_level TEXT NOT NULL,
        notes TEXT,
        inspection_date TIMESTAMP NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL
    );