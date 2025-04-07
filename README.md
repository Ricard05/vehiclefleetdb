# 🚛 Sistema de Gestión de Unidades de Transporte

# Administración de Base de Datos

El sistema de gestión de unidades de transporte se enfocará en proporcionar una
solución eficiente para el control y administración de una flota vehicular. Permitirá el
registro de cada unidad, asignación de responsables, seguimiento de rutas y
evaluación del estado mecánico de los vehículos. La implementación de este
sistema contribuirá a optimizar procesos, minimizar tiempos de inactividad, reducir
costos operativos y mejorar la planificación logística.

## 📑 Diagrama ER

![Diagrama ER](er_diagram.png)

## Equipo de Desarrollo

- **Gurrola Romero Manuel Eduardo**
- **Marín Ramírez Luis Carlos**
- **Martínez López Gael Ricardo**
- **Cumplido Herrera Diego**
- **Fuentes Reyes Ángel**

## 📋 Tabla de Contenidos

- [Introducción](#introducción)
- [Propósito](#propósito)
- [Objetivos](#objetivos)
- [Público Objetivo](#público-objetivo)
- [Requerimientos](#requerimientos)
  - [Funcionales](#requerimientos-funcionales)
  - [No funcionales](#requerimientos-no-funcionales)
- [Problemática](#problemática)
- [Estructura del Repositorio](#estructura-del-repositorio)
- [Diagrama ER](#diagrama-er)

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
garantizarán una administración eficiente de la flota vehicular. Se busca mejorar la
trazabilidad de las unidades, optimizar las rutas de entrega, gestionar el mantenimiento y
reforzar la seguridad operativa mediante una base de datos estructurada.

## Objetivos

- 🚚 Centralizar la información de las unidades, rutas y responsables.
- 📊 Optimizar la planificación y monitoreo de rutas.
- 🛠️ Gestionar el mantenimiento preventivo y correctivo.
- 🔑 Asegurar la trazabilidad de la información mediante auditorías y seguridad.
- 📈 Facilitar la toma de decisiones con reportes y análisis de datos.

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

```

📎 [Ver script.sql script completo](script.sql)

### 📄 Fragmento de storage_procedures.sql
Se usa el siguiente bloque de código para crear los diferentes procedimientos almacenados que se usarán en la base de datos (Se incluyen las funciones usadas por los triggers).

```sql
-- Este es un bloque de código SQL
```
