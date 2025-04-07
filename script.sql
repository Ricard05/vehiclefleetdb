-- Tabla que representa a los usuarios del sistema, base para Admins y Conductores
CREATE TABLE
    "User" (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único generado automáticamente
        name TEXT NOT NULL, -- Nombre del usuario
        email TEXT UNIQUE NOT NULL, -- Correo electrónico único
        password TEXT NOT NULL, -- Contraseña cifrada
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );

-- Tabla que representa a los administradores del sistema
CREATE TABLE
    Admin (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único del admin
        user_id UUID UNIQUE REFERENCES "User" (id) ON DELETE CASCADE, -- Relación 1:1 con User
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );

-- Tabla que representa a los conductores
CREATE TABLE
    Driver (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único del conductor
        user_id UUID UNIQUE REFERENCES "User" (id) ON DELETE CASCADE, -- Relación 1:1 con User
        first_name TEXT NOT NULL, -- Nombre del conductor
        last_name TEXT NOT NULL, -- Apellido del conductor
        employee_number TEXT UNIQUE NOT NULL, -- Número de empleado único
        license TEXT NOT NULL, -- Licencia del conductor
        license_expiration DATE NOT NULL, -- Fecha de expiración de la licencia
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );

-- Tabla que representa a los vehículos registrados
CREATE TABLE
    Vehicle (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único del vehículo
        model TEXT NOT NULL, -- Modelo del vehículo
        plate TEXT UNIQUE NOT NULL, -- Placa única
        capacity INT NOT NULL, -- Capacidad del vehículo
        mileage INT NOT NULL, -- Kilometraje actual
        last_maintenance_date TIMESTAMP NOT NULL, -- Fecha del último mantenimiento
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
        status TEXT CHECK (status IN ('Activo', 'Inactivo')) NOT NULL, -- Estado del vehículo
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );

-- Tabla que representa las rutas disponibles
CREATE TABLE
    Route (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único de la ruta
        origin TEXT NOT NULL, -- Punto de origen
        destination TEXT NOT NULL, -- Punto de destino
        distance FLOAT NOT NULL, -- Distancia en kilómetros
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );

-- Tabla que define los tipos de carga que pueden transportarse
CREATE TABLE
    CargoType (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único del tipo de carga
        name TEXT UNIQUE NOT NULL, -- Nombre del tipo de carga
        description TEXT, -- Descripción opcional
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );

-- Tabla que representa los viajes realizados o programados
CREATE TABLE
    Trip (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único del viaje
        driver_id UUID REFERENCES Driver (id) ON DELETE CASCADE, -- Conductor asignado
        vehicle_id UUID REFERENCES Vehicle (id) ON DELETE CASCADE, -- Vehículo utilizado
        route_id UUID REFERENCES Route (id) ON DELETE CASCADE, -- Ruta asignada
        cargo_type_id UUID REFERENCES CargoType (id) ON DELETE CASCADE, -- Tipo de carga transportada
        date TIMESTAMP NOT NULL, -- Fecha del viaje
        departure_time TIME NOT NULL, -- Hora de salida
        arrival_time TIME NOT NULL, -- Hora estimada de llegada
        passenger_count INT CHECK (passenger_count >= 0), -- Número de pasajeros, si aplica
        state TEXT CHECK (
            state IN (
                'PENDIENTE', -- Viaje pendiente por iniciar
                'EN_CAMINO_AL_DESTINO', -- En tránsito hacia el destino
                'CARGA_ENTREGADA', -- Carga entregada
                'EN_CAMINO_AL_ORIGEN', -- Regreso al origen
                'FINALIZADO' -- Viaje finalizado
            )
        ) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );

-- Tabla que representa las inspecciones de vehículos realizadas antes o después de un viaje
CREATE TABLE
    VehicleInspection (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Identificador único de la inspección
        trip_id UUID UNIQUE REFERENCES Trip (id) ON DELETE CASCADE, -- Inspección asociada a un viaje
        vehicle_id UUID REFERENCES Vehicle (id) ON DELETE CASCADE, -- Vehículo inspeccionado
        kilometer INT CHECK (kilometer >= 0) NOT NULL, -- Kilometraje actual
        engine_status TEXT NOT NULL, -- Estado del motor
        tire_condition TEXT NOT NULL, -- Condición de las llantas
        brake_status TEXT NOT NULL, -- Estado de los frenos
        fuel_level TEXT NOT NULL, -- Nivel de combustible
        notes TEXT, -- Observaciones adicionales
        inspection_date TIMESTAMP NOT NULL, -- Fecha de la inspección
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación del registro
        is_deleted BOOLEAN DEFAULT FALSE NOT NULL -- Borrado lógico
    );