# 🚛 Sistema de Gestión de Unidades de Transporte

# Administración de Base de Datos

El sistema de gestión de unidades de transporte se enfocará en proporcionar una
solución eficiente para el control y administración de una flota vehicular. Permitirá el
registro de cada unidad, asignación de responsables, seguimiento de rutas y
evaluación del estado mecánico de los vehículos. La implementación de este
sistema contribuirá a optimizar procesos, minimizar tiempos de inactividad, reducir
costos operativos y mejorar la planificación logística.

## Equipo de Desarrollo

- **Gurrola Romero Manuel Eduardo**
- **Marín Ramírez Luis Carlos**
- **Martínez López Gael Ricardo**
- **Cumplido Herrera Diego**
- **Fuentes Reyes Ángel**

## 📂 Estructura del Proyecto

```plaintext
📁 audit/
    └── audit_admin.sql
    └── audit_cargo_type.sql
    └── audit_driver.sql
    └── audit_route.sql
    └── audit_trip.sql
    └── audit_user.sql
    └── audit_vehicle_inspection.sql
    └── audit_vehicle.sql
📁 insert/
    └── insert_admin.sql
    └── insert_cargo_type.sql
    └── insert_driver.sql
    └── insert_route.sql
    └── insert_trip.sql
    └── insert_user.sql
    └── insert_vehicle_inspection.sql
    └── insert_vehicle.sql
📄 README.md
🖼️ er_diagram.png
📄 script.sql
📄 storage_procedures.sql
📄 triggers.sql
```

## 🧩 Requisitos de Instalación

Para poner en marcha el sistema de gestión de unidades de transporte, se requieren los siguientes elementos:

- **PostgreSQL** (versión 13 o superior)
- **pgAdmin** o cualquier cliente compatible con PostgreSQL (opcional para administración visual)
- **Extensión pgcrypto** para generación de UUIDs (ya incluida en PostgreSQL)
- Acceso a un entorno que permita ejecutar scripts SQL
- Editor de texto o entorno de desarrollo (como VS Code)

## 📋 Tabla de Contenidos

- [Introducción](#introducción)
- [Propósito](#propósito)
- [Problematica](#propósito)
- [Características Clave del Sistema](#características-clave-del-sistema)
- [Público Objetivo](#público-objetivo)
- [Requerimientos](#requerimientos)
  - [Funcionales](#requerimientos-funcionales)
  - [No funcionales](#requerimientos-no-funcionales)
- [Diagrama ER](#diagrama-er)
- [Análisis de Relaciones y Cardinalidad](#análisis-de-relaciones-y-cardinalidad)
- [Análisis de Normalización](#-análisis-de-normalización)
  - [Primera Forma Normal (1FN)](#1nf-primera-forma-normal)
  - [Segunda Forma Normal (2FN)](#2nf-segunda-forma-normal)
  - [Tercera Forma Normal (3FN)](#3nf-tercera-forma-normal)
  - [Cuarta Forma Normal (4FN)](#4nf-cuarta-forma-normal)
- [Scripts para la base de datos](#️-scripts-para-la-creación-de-la-base-de-datos)
  - [Fragmento script.sql](#-fragmento-de-scriptsql)
  - [Fragmento storage_procedures.sql](#-fragmento-de-storage_proceduressql)
- [Scripts para la auditoría e inserción de datos](#-scripts-para-la-inserción-de-datos-y-la-auditoria-de-las-tablas)
  - [Tablas auditoras](#tablas-auditoras)
    - [Fragmento de audit_admin.sql](#-fragmento-de-audit_adminsql)
    - [Otras tablas auditoras](#otras-tablas-auditoras)
  - [Inserción de datos](#inserción-de-datos-de-prueba)
    - [Fragmento de insert_admin.sql](#-fragmento-de-insert_adminsql)
    - [Fragmento de insert_cargo_type.sql](#-fragmento-de-insert_cargo_typesql)
    - [Fragmento de insert_driver.sql](#-fragmento-de-insert_driversql)
- [Conclusión](#conclusión)

---

## Introducción

Este repositorio tiene como finalidad identificar y documentar las
necesidades del sistema de gestión de unidades de transporte. Esta base de datos
tiene como objetivo proporcionar un control estructurado y eficiente sobre la
administración de las unidades vehiculares de una empresa, asegurando la
trazabilidad de su uso, la gestión de rutas de entrega, el estado mecánico de cada
unidad y otros datos relevantes.

## Propósito

El propósito de esta documentación es definir las necesidades del sistema de gestión de
unidades de transporte, estableciendo los requerimientos funcionales y no funcionales que
garantizarán una administración eficiente de la `flota vehicular`. Se busca mejorar la
trazabilidad de las unidades, optimizar las rutas de entrega, gestionar el mantenimiento y
reforzar la seguridad operativa mediante una base de datos estructurada.

## Problemática

Las empresas de transporte suelen enfrentar dificultades en el manejo de
información clave debido a la dispersión de datos, el uso de registros manuales o
sistemas obsoletos. Esto puede generar problemas como:

- **Falta de trazabilidad**: No contar con un registro claro sobre qué operador
  está a cargo de qué unidad puede dificultar la asignación de
  responsabilidades..

- **Control deficiente del mantenimiento**: La ausencia de un sistema
  automatizado para registrar el estado mecánico de los vehículos puede
  derivar en fallas inesperadas, incrementando costos y tiempos de inactividad.

- **Ineficiencia en la asignación de rutas**: Sin una gestión adecuada de las
  rutas de entrega, pueden generarse retrasos, recorridos ineficientes y
  sobrecostos en combustible.

- **Pérdida o desactualización de datos**: El uso de métodos manuales o
  archivos desorganizados puede llevar a la pérdida de información relevante
  o a la toma de decisiones basadas en datos inexactos..

## Características Clave del Sistema

- 📁 **Gestión Integral**: Control total de vehículos, conductores, rutas, mantenimientos y auditoría.
- 🔒 **Seguridad y Trazabilidad**: Uso de roles, permisos y auditorías mediante triggers y borrado lógico.
- ⚙️ **Procedimientos Almacenados**: Automatización de tareas clave como el control de estados de viaje.
- 🔁 **Triggers Personalizados**: Automatización de reglas de negocio críticas (ej. borrado en cascada lógico).
- 📦 **Modularidad**: Estructura por carpetas para mantener el orden (audit, insert, triggers, etc.).

## Público Objetivo

- 🏢 Empresas de transporte y logística.
- 👨‍💼💼 Gerentes de operaciones y supervisores de flota.
- 🚚 Conductores y operadores.
- 🏢 Departamentos de mantenimiento, seguridad, administración y finanzas.

## Requerimientos

### Requerimientos Funcionales

1. **Gestión de Unidades:**

   - Registro de vehículos y estado mecánico.
   - Historial de mantenimiento.

2. **Gestión de Conductores:**

   - Registro y asignación de vehículos.
   - Control de permisos.

3. **Gestión de Rutas:**

   - Registro y optimización de rutas.
   - Control de incidencias.

4. **Mantenimiento:**

   - Programación y alertas de revisiones.
   - Registro de reparaciones.

5. **Seguridad y Auditoría:**
   - Roles, permisos y autenticación.
   - Registro de modificaciones.

### Requerimientos No Funcionales

- **Escalabilidad**: Capacidad de crecimiento sin afectar el rendimiento.
- **Seguridad**: Encriptación y control de accesos.
- **Disponibilidad**: Mínimo tiempo de inactividad.
- **Usabilidad**: Interfaz intuitiva para los usuarios.
- **Compatibilidad**: Integración con sistemas ERP, GPS, etc.

---

## Diagrama ER

![Diagrama ER](er_diagram.png)

## Análisis de Relaciones y Cardinalidad

- **1. User → Admin (1:1)**
  o Un usuario puede ser un administrador, pero cada administrador está
  vinculado a un solo usuario.
- **2. User → Driver (1:1)**
  o Un usuario puede ser un conductor, pero cada conductor está
  vinculado a un solo usuario.
- **3. Driver → Trip (1:M)**
  o Un conductor puede realizar múltiples viajes, pero cada viaje tiene
  solo un conductor asignado.
- **4. Vehicle → Trip (1:M)**
  o Un vehículo puede estar involucrado en múltiples viajes, pero cada
  viaje usa solo un vehículo.
- **5. Route → Trip (1:M)**
  o Una ruta puede estar asociada con múltiples viajes, pero cada viaje
  sigue una sola ruta.
- **6. CargoType → Trip (1:M)**
  o Un tipo de carga puede estar asociado con múltiples viajes, pero
  cada viaje solo tiene un tipo de carga.
- **7. Trip → VehicleInspection (1:1)**
  o Cada viaje tiene una única inspección vehicular, y cada inspección
  pertenece a un solo viaje.
- **8. Vehicle → VehicleInspection (1:M)**
  o Un vehículo puede ser inspeccionado varias veces, pero cada
  inspección pertenece a un solo vehículo.

## 🧠 Análisis de Normalización

### 1NF (Primera Forma Normal)

- Todos los atributos contienen valores atómicos.
- No hay listas ni valores repetidos dentro de una misma celda.
- Todas las tablas tienen claves primarias bien definidas.

### 2NF (Segunda Forma Normal)

- No existen dependencias parciales en ninguna tabla.
- Todos los atributos dependen completamente de la clave primaria.

### 3NF (Tercera Forma Normal)

- No existen dependencias transitivas entre atributos.
- Todos los atributos dependen únicamente de la clave primaria.

### 4NF (Cuarta Forma Normal)

- No existen dependencias multivaluadas.
- Cada conductor solo maneja un vehículo, `vehicle_id` depende directamente de `driver_id`.
- La tabla `Trip` relaciona `driver_id`, `vehicle_id` y `route_id` sin valores repetidos.

---

## ⌨️ Scripts para la creación de la base de datos

### 📄 Fragmento de script.sql

```sql
-- Codigo SQL para crear la base de datos

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

CREATE TABLE ...
```

📎 [Ver script.sql script completo](script.sql)

### 📄 Fragmento de storage_procedures.sql

Se usa el siguiente `bloque de código` para crear los diferentes procedimientos almacenados que se usarán en la base de datos (Se incluyen las funciones usadas por los `triggers`).

```sql
CREATE OR REPLACE FUNCTION soft_delete()
RETURNS TRIGGER AS $$
BEGIN
  -- Ejecuta la consulta dinámica para actualizar la tabla correcta
  EXECUTE format('UPDATE ONLY %I SET is_deleted = TRUE WHERE id = $1', TG_TABLE_NAME) USING OLD.id;

  -- Retorna el registro original sin eliminarlo
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_trip_status(
  p_trip_id UUID,  -- ID del viaje
  p_new_state TEXT  -- Nuevo estado para el viaje
)
LANGUAGE plpgsql AS $$
DECLARE
  v_vehicle_id UUID;
  v_inspection_exists BOOLEAN;
BEGIN
  -- Verificar si el nuevo estado es válido
  IF p_new_state NOT IN ('PENDIENTE', 'EN_CAMINO_AL_DESTINO', 'CARGA_ENTREGADA', 'EN_CAMINO_AL_ORIGEN', 'FINALIZADO') THEN
    RAISE EXCEPTION 'Estado no válido: %', p_new_state;
  END IF;

  -- Obtener el ID del vehículo asociado al viaje
  SELECT vehicle_id INTO v_vehicle_id
  FROM Trip
  WHERE id = p_trip_id AND is_deleted = FALSE;

  -- Verificar si se encontró el viaje y obtener el ID del vehículo
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No se encontró un viaje con el ID % o el viaje está marcado como eliminado', p_trip_id;
  END IF;

  -- Verificar si el viaje está en estado PENDIENTE y si se ha realizado la inspección del vehículo
  IF p_new_state = 'EN_CAMINO_AL_DESTINO' OR p_new_state = 'EN_CAMINO_AL_ORIGEN' THEN
    -- Verificar si se ha realizado una inspección para el vehículo
    SELECT EXISTS (
      SELECT 1
      FROM VehicleInspection
      WHERE vehicle_id = v_vehicle_id
        AND is_deleted = FALSE
    ) INTO v_inspection_exists;

    -- Si no existe una inspección registrada, no se puede cambiar a los estados 'EN_CAMINO_AL_DESTINO' ni 'EN_CAMINO_AL_ORIGEN'
    IF NOT v_inspection_exists THEN
      RAISE EXCEPTION 'No se ha realizado una inspección del vehículo asociado al viaje. No se puede cambiar el estado a "%".', p_new_state;
    END IF;
  END IF;

  -- Actualizar el estado del viaje con el ID proporcionado
  UPDATE Trip
  SET state = p_new_state
  WHERE id = p_trip_id AND is_deleted = FALSE;

  -- Verificar si la actualización fue exitosa
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No se pudo actualizar el estado del viaje con el ID %', p_trip_id;
  END IF;

  -- Puedes agregar más lógica aquí, como registrar en una tabla de auditoría si lo deseas
END;
$$;

CREATE OR REPLACE FUNCTION soft_delete_user_when_driver_or_admin_is_deleted()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  -- Si se elimina un conductor, marcar el usuario como eliminado
  IF TG_TABLE_NAME = 'driver' AND NEW.is_delete = true THEN
    UPDATE "user"
    SET is_delete = true
    WHERE id = NEW.user_id;
  END IF;

  -- Si se elimina un administrador, marcar el usuario como eliminado
  IF TG_TABLE_NAME = 'admin' AND NEW.is_delete = true THEN
    UPDATE "user"
    SET is_delete = true
    WHERE id = NEW.user_id;
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION...
```

📎 [Ver storage_procedures.sql script completo](storage_procedures.sql)

### 📄 Fragmento de triggers.sql

Se usa el siguiente bloque de código para crear los diferentes `triggers` que se usarán en la base de datos.

```sql
CREATE TRIGGER soft_delete_user
BEFORE DELETE ON "User"
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER soft_delete_admin
BEFORE DELETE ON Admin
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER soft_delete_driver
BEFORE DELETE ON Driver
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER soft_delete_vehicle
BEFORE DELETE ON Vehicle
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER soft_delete_route
BEFORE DELETE ON Route
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER soft_delete_cargo_type
BEFORE DELETE ON CargoType
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER soft_delete_trip
BEFORE DELETE ON Trip
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER soft_delete_vehicle_inspection
BEFORE DELETE ON VehicleInspection
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

CREATE TRIGGER trg_soft_delete_user_when_driver_or_admin_is_deleted
AFTER UPDATE ON driver
FOR EACH ROW
WHEN (OLD.is_delete = false AND NEW.is_delete = true)
EXECUTE FUNCTION soft_delete_user_when_driver_or_admin_is_deleted();

CREATE TRIGGER trg_soft_delete_user_when_admin_is_deleted...
```

📎 [Ver triggers.sql script completo](triggers.sql)

---

## ⌨️ Scripts para la inserción de datos y la auditoria de las tablas

En esta seccion se encuentran algunos ejemplos de las `tablas auditoras` utilizadas para el monitoreo de las operaciones CRUD en las tablas principales.

### Tablas auditoras

#### 📄 Fragmento de audit_admin.sql

```sql
CREATE TABLE audit_admin (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- ID único de auditoría
    operation_type TEXT NOT NULL,                        -- INSERT, UPDATE, DELETE
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- Momento del cambio
    changed_by TEXT,                                     -- Usuario que realizó el cambio
    old_data JSONB,                                      -- Datos anteriores (para UPDATE y DELETE)
    new_data JSONB                                       -- Datos nuevos (para INSERT y UPDATE)
);

-- Función para registrar auditoría en Admin
CREATE OR REPLACE FUNCTION log_admin_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO audit_admin (
            operation_type, changed_by, new_data
        ) VALUES (
            TG_OP, current_user, to_jsonb(NEW)
        );
        RETURN NEW;

    ELSIF (TG_OP = 'UPDATE') THEN
        -- Verificar si es una actualización de la columna is_deleted
        IF NEW.is_deleted = TRUE AND OLD.is_deleted = FALSE THEN
            -- Registrar como "DELETE lógico"
            INSERT INTO audit_admin (
                operation_type, changed_by, old_data
            ) VALUES (
                'DELETE', current_user, to_jsonb(OLD)
            );
        ELSE
            -- Registrar como una actualización normal
            INSERT INTO audit_admin (
                operation_type, changed_by, old_data, new_data
            ) VALUES (
                TG_OP, current_user, to_jsonb(OLD), to_jsonb(NEW)
            );
        END IF;
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_admin (
            operation_type, changed_by, old_data
        ) VALUES (
            TG_OP, current_user, to_jsonb(OLD)
        );
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_admin
AFTER INSERT OR UPDATE OR DELETE ON Admin
FOR EACH ROW EXECUTE FUNCTION log_admin_changes();
```

📎 [Ver audit_admin.sql script completo](./audit/audit_admin.sql)

Se usa el fragmento anterior para crear una tabla de auditoría para la tabla `Admin` en PostgreSQL. Esta tabla de auditoría registra las operaciones de inserción, actualización y eliminación en la tabla `Admin`, incluyendo los datos antiguos y nuevos, así como el usuario que realizó la operación y el momento en que se realizó. Se utiliza un metodo para hacer un soft delete en la tabla y se detecta si es una actualizacion o un delete lógico, en caso de ser el ultimo se registra como una operacion delete dentro de la tabla.

A continuacion se muestran los diferentes scripts que se utilizaron para la creacion de las `tablas auditoras`:

### Otras tablas auditoras

- 📎 [Ver audit_cargo_type.sql script completo](./audit/audit_cargo_type.sql)

- 📎 [Ver audit_driver.sql script completo](./audit/audit_driver.sql)

- 📎 [Ver audit_route.sql script completo](./audit/audit_route.sql)

- 📎 [Ver audit_trip.sql script completo](./audit/audit_trip.sql)

- 📎 [Ver audit_user.sql script completo](./audit/audit_user.sql)

- 📎 [Ver audit_vehicle.sql script completo](./audit/audit_vehicle.sql)

- 📎 [Ver audit_vehicle_inspection.sql script completo](./audit/audit_vehicle_inspection.sql)

### Inserción de datos de prueba

En los siguientes bloques de código se muestran algunos ejemplos de inserción de datos de prueba para las tablas de la base de datos.

#### 📄 Fragmento de insert_admin.sql

```sql
INSERT INTO "admin" ("id", "created_at", "is_deleted", "user_id") VALUES
('67d6526b-fdb1-4b55-b244-6a3f943d9eb2', '2025-02-24 19:03:51', '1', '840ea9f3-6edc-40da-8628-252906de9b25'),
('1cdd9881-a1a8-4216-b36e-a1d1b67c44b5', '2024-12-13 08:48:48', '1', '5e9c7153-370b-4e9b-970e-039254ad2eeb'),
('00dd82b9-bba1-43c7-bdee-f8010a9cb945', '2025-02-08 04:55:49', '1', 'ab2361ce-db5a-4d11-93ed-628a0ee3c1d7'),
('a7c8cd7f-b815-41e8-a9c6-9439f56b5076', '2024-12-25 05:39:07', '0', '7c740bfa-8d11-4f43-996c-5f1fded8d38c'),
('8cc759bf-cdde-41b6-bcb1-6a22f9646a2f', '2024-06-21 23:46:17', '0', '912f07ca-b7e7-4729-a0e6-3e31482afc36'),
('d66176ca-b62e-4bfd-af10-ad76c24ec163', '2025-01-16 14:28:45', '1', '743407b7-44de-4d9a-b0ea-317a43b6f8a8'),
('6ac18057-12d3-4a6c-939a-938960d62673', '2025-03-13 06:44:07', '1', 'c6d520a4-e4b2-4f0d-9086-ae0b00c1ea1e'),
('f1883362-7a7a-4d80-ac7a-8dfebeae2c86', '2025-03-10 11:09:47', '1', '7a6210d2-f641-41b4-a543-4f7dfdf30f9b'),
('6bf4c162-1447-4209-af71-bf320e308b46', '2025-01-27 23:45:16', '1', 'b9d28eda-f871-48a8-bb4e-2f3ed101a273'),
('89d40a90-bbc4-4e37-8fc1-445acf329d56', '2024-12-28 02:13:53', '0', '95109fa4-9ce8-4fd7-95c9-153d1e869ff1');
```
En este bloque de codigo se insertan los datos de los administradores en la tabla `admin`.

## 📎 [Ver insert_admin.sql script completo](./insert/insert_admin.sql)

#### 📄 Fragmento de insert_cargo_type.sql

```sql
INSERT INTO "cargotype" ("id", "name", "description", "created_at", "is_deleted") VALUES
('70333207-2625-4aa9-aca7-3bf1aff5b898', 'K2', 'Kydex for durable panels', '2024-12-28 11:49:52', '0'),
('5f18b769-8dfe-4bb0-b097-388144624cf9', 'I2', 'Ironwood for supports', '2025-01-01 03:23:28', '0'),
('c3a45879-0d29-4739-9d3a-880193ecaa16', 'I1', 'Iron for framework', '2024-09-09 14:51:58', '1'),
('241450e2-74f9-45a5-8150-0a47af13e47d', 'H2', 'High-density polyethylene for containers', '2024-06-27 02:23:54', '0'),
('81a08a87-8644-4703-b852-b0a528939ea0', 'H1', 'Hemp for biodegradable composites', '2024-10-28 09:47:36', '0'),
('ffd0836a-8467-4bf1-aefd-e2d4e44f238c', 'G1', 'Glass for windows', '2024-04-25 19:53:31', '1'),
('6a241f3a-412f-4561-a066-14dc4e1cf6bb', 'E2', 'Elastic rubber for tires', '2025-03-29 13:37:33', '1'),
('4dad34b2-ffb4-4154-9d52-37f63f5acd50', 'D2', 'Durable plastic for truck beds', '2024-05-21 07:43:50', '1'),
('cde71974-a748-415d-b308-037dca590708', 'C2', 'Concrete for heavy equipment', '2024-09-04 21:51:18', '0'),
('6437b6b3-b98d-482d-8f7d-ba0b0a51ef1e', 'B2', 'Brass for fittings', '2024-04-21 09:24:52', '0');

```
En este bloque de código se insertan registros en la tabla `cargotype` con diferentes valores para los campos `id`, `name`, `description`, `created_at` e `is_deleted`.
## 📎 [Ver insert_cargo_type.sql script completo](./insert/insert_cargo_type.sql)

#### 📄 Fragmento de insert_driver.sql

```sql
INSERT INTO "driver" ("id", "user_id", "first_name", "last_name", "employee_number", "license", "license_expiration", "created_at", "is_deleted") VALUES
('02ea9ed7-78b9-4f2f-b06a-02b8028acfcc', 'b9d28eda-f871-48a8-bb4e-2f3ed101a273', 'Curtice', 'Menilove', 'EMP40111', 'EIMG8TTIX', '2025-05-09', '2025-06-07 14:34:12', '1'),
('05cd6ebd-3690-401c-9a79-f3289dc7114c', 'a1f59b00-464c-4fc2-a40d-7cb6c8a3e628', 'Merrel', 'Hansford', 'EMP79987', 'E54SO0ORI6', '2025-11-23', '2025-04-11 05:17:17', '1'),
('063c9897-e0c1-41b7-bd03-607950c6146d', '01a44e0b-695b-4eeb-835b-e7183766af2d', 'Celesta', 'McKeurtan', 'EMP47387', 'AH6B0Q', '2026-02-02', '2025-06-24 23:05:34', '0'),
('0729ab2f-4e5d-43f6-a038-8adca9327935', '912f07ca-b7e7-4729-a0e6-3e31482afc36', 'Darren', 'Grass', 'EMP21470', 'EG91', '2025-06-25', '2025-08-25 12:47:53', '0'),
('0dfddf7f-a7dc-472d-9e5c-e779a38282e8', 'b092bcdd-95c7-4c66-8b6c-d2cde60aebc7', 'Samson', 'Jeffcock', 'EMP88485', '55', '2025-10-07', '2025-09-14 08:49:24', '1'),
('12160f9c-9906-475d-a170-b803a383abe0', '3d587a5b-a9a6-4663-8d0e-fb1aa3027afb', 'Sophey', 'Benez', 'EMP23139', 'S04BBEXUVBU1FZ', '2025-07-20', '2025-05-23 23:42:47', '0'),
('14bcbcf0-ec2c-4dba-beff-434c1127c74d', '978398f2-f72b-48b0-b9fa-bfe87a727e08', 'Midge', 'Newbury', 'EMP07249', 'LS6KROO', '2025-10-12', '2025-04-28 13:55:35', '1'),
('1794064c-11a7-4415-b874-40bd8797d6a5', '0000b812-ea95-4fbf-ab70-e778257b331f', 'Codie', 'Langford', 'EMP10609', '5DW', '2026-03-16', '2025-09-22 00:18:01', '0'),
('17ac297c-4fc6-455b-b015-c90cd74f2357', 'd542d916-b30f-4e98-84d8-b9bfd727ab62', 'Germana', 'Wraighte', 'EMP04208', 'A2IDW9CTBASU82', '2025-11-25', '2025-04-15 07:14:26', '0'),
('1a1e9d99-dfc3-4adb-9a01-be7802d63b9b', '1646fb81-7a3c-4ab9-91c3-f18f11007eb9', 'Sharon', 'Hugh', 'EMP74236', '24FH0KOQT', '2025-07-18', '2026-01-25 10:13:10', '0'),
('1e68db0a-31ca-497c-8ce8-4fb50e648444', '88f121e4-4b14-4dfe-b51c-615a928e803f', 'Burke', 'Northley', 'EMP69309', 'A5KBMOBSU20FBR7', '2025-10-22', '2025-08-17 09:12:39', '1'),
('22611565-174d-4615-b2f2-09846763c9ff', '2b540536-3909-436f-ac92-ebb019955778', 'Eadie', 'Meriot', 'EMP30700', 'N4LNQ14FVMG', '2026-03-22', '2025-06-16 02:05:50', '0'),
('2546ce56-508b-4f93-907b-2ce76295ff26', '27c39d2a-6397-4eb1-a154-c6d63411e74e', 'Sallyann', 'Maciunas', 'EMP28886', 'I9OEDLE08XAC3', '2025-08-12', '2025-06-27 11:28:53', '1'),
('28d73945-458d-4b2b-9980-2622ea30c18a', 'a0b8b3e3-b0b7-4127-ba04-cd99ab703af7', 'Eada', 'Tuffield', 'EMP16085', 'ZU776IAK', '2025-10-22', '2025-09-02 17:39:03', '0'),
('29986819-2e7b-4e5f-89c9-e13f31c16aae', '7bb34f59-a57d-4593-aa7c-81dabc4f1747', 'Ari', 'Waldrum', 'EMP53772', 'ZNBMF93RK', '2025-08-11', '2025-04-22 10:14:31', '1'),
('36b3dddd-1ec2-465e-8478-3f6a1bcbc3c1', '032a5c8f-3da2-4052-be7e-f8deb24508e7', 'Berna', 'Drust', 'EMP72759', 'Y470K', '2025-09-22', '2025-09-01 01:25:08', '0'),
('38845b28-c1b1-49ea-baa2-295d77e7d201', '4cbc4e51-fbae-4c76-b00d-c17540069a0a', 'Elianore', 'Pluvier', 'EMP65558', 'RVH2RHUZP1AO4B', '2025-04-20', '2026-03-26 01:56:25', '0'),
('39a0fe85-c541-48d6-b578-ccb58ef84ff8', 'a06e88c0-c1d2-4842-b609-2e3a6ff46e8f', 'Roby', 'Flucker', 'EMP65771', 'YRDJFLP7T1O', '2025-08-26', '2025-05-29 18:56:07', '1'),
('3a9b389e-3415-44a0-ad81-a7edfbb214a7', '11ebc63f-2307-4ea1-95e9-53b3290fcec9', 'Kiah', 'Grigoryev', 'EMP78026', 'N0ERKVAGHX08W', '2026-02-16', '2025-08-21 18:12:01', '1'),
('3cba5bba-fc14-481f-801a-6759a4a8cdb6', '14f51e05-9daf-4135-b1fc-ec02a890110c', 'Johnette', 'Hobden', 'EMP48458', 'HM5SOTG0S', '2025-08-28', '2025-10-26 18:22:28', '1')...
```
En este bloque de código se insertan registros en la tabla `driver` de la base de datos. Solo se muestran algunos de los registros como ejemplos, pero el script completo se encuentra en el archivo `insert_driver.sql`.

## 📎 [Ver insert_driver.sql script completo](./insert/insert_driver.sql)
---
## Conclusión

El desarrollo de este sistema de gestión de unidades de transporte representa una
solución efectiva y moderna para la administración de flotas vehiculares, ya que
permite un control integral sobre los recursos más importantes del servicio de
transporte: vehículos, conductores, rutas y mantenimiento. A través de un diseño de
base de datos bien estructurado, se logra centralizar la información, facilitando la
toma de decisiones, reduciendo errores administrativos y optimizando el uso de los
recursos.
La implementación de esta base de datos robusta, confiable y escalable no solo
mejora la eficiencia operativa, sino que también sienta las bases para la
automatización de procesos críticos como la asignación de unidades, el seguimiento
de recorridos, la programación de mantenimientos preventivos y correctivos, y el
control del personal. Asimismo, permite una trazabilidad clara de cada unidad y
conductor, lo que contribuye significativamente a mejorar la seguridad y la calidad
del servicio ofrecido.
