-- ========================================
-- Función: soft_delete
-- Descripción: Realiza una eliminación lógica de un registro, actualizando el campo 'is_deleted' a TRUE
-- Parámetro:
--   Ninguno (se utiliza el valor OLD.id para identificar el registro en la tabla correspondiente)
-- ========================================
CREATE OR REPLACE FUNCTION soft_delete()
RETURNS TRIGGER AS $$
BEGIN
  -- Ejecuta la consulta dinámica para actualizar la tabla correcta
  EXECUTE format('UPDATE ONLY %I SET is_deleted = TRUE WHERE id = $1', TG_TABLE_NAME) USING OLD.id;

  -- Retorna el registro original sin eliminarlo
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- Función: update_trip_status
-- Descripción: Actualiza el estado de un viaje en la tabla "Trip"
-- Parámetros:
--   p_trip_id UUID: ID del viaje a actualizar
--   p_new_state TEXT: Nuevo estado para el viaje
--   (debe ser uno de los siguientes: 'PENDIENTE', 'EN_CAMINO_AL_DESTINO', 'CARGA_ENTREGADA', 'EN_CAMINO_AL_ORIGEN', 'FINALIZADO')
-- ========================================
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

-- ========================================
-- Función: soft_delete_user_when_driver_or_admin_is_deleted
-- Descripción: Marca como eliminado el usuario asociado a un conductor o administrador eliminado
-- Parámetros:
--   Ninguno (se utiliza el valor NEW.user_id para identificar el usuario en la tabla "user")
-- ========================================
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

-- ========================================
-- Función: soft_delete_driver_or_admin_when_user_is_deleted
-- Descripción: Marca como eliminado el conductor o administrador asociado a un usuario eliminado
-- Parámetros:
--   Ninguno (se utiliza el valor NEW.id para identificar el usuario en la tabla "user")
-- ========================================
CREATE OR REPLACE FUNCTION soft_delete_driver_or_admin_when_user_is_deleted()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  -- Si se elimina un usuario, marcar al conductor como eliminado
  IF TG_TABLE_NAME = 'user' AND NEW.is_delete = true THEN
    UPDATE driver
    SET is_delete = true
    WHERE user_id = NEW.id;

    -- Marcar el admin como eliminado si el usuario es admin
    UPDATE admin
    SET is_delete = true
    WHERE user_id = NEW.id;
  END IF;

  RETURN NEW;
END;
$$;

-- ========================================
-- Función: validate_driver_license
-- Descripción: Valida que la licencia del conductor no esté expirada antes de iniciar un viaje
-- Parámetros:
--   Ninguno (se utiliza el valor NEW.driver_id para identificar al conductor en la tabla "Driver")
-- ========================================
CREATE OR REPLACE FUNCTION validate_driver_license()
RETURNS TRIGGER AS $$
DECLARE 
  license_expiration DATE;  -- Manteniendo el mismo nombre de la variable
BEGIN
  -- Obtener la fecha de expiración de la licencia del conductor
  SELECT Driver.license_expiration INTO license_expiration FROM Driver WHERE id = NEW.driver_id;
  
  -- Si la licencia ha expirado, lanzar un error
  IF license_expiration < CURRENT_DATE THEN
    RAISE EXCEPTION 'El conductor tiene la licencia expirada y no puede iniciar un viaje';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- Función: check_driver_has_active_trip_and_date
-- Descripción: Verifica si el conductor tiene un viaje activo y si la fecha del nuevo viaje ya está ocupada por otro viaje activo
-- Parámetros:
--   Ninguno (se utiliza el valor NEW.driver_id y NEW.date para identificar al conductor y la fecha del nuevo viaje)
-- ========================================
CREATE OR REPLACE FUNCTION check_driver_has_active_trip_and_date()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  -- Verificar si el conductor tiene un viaje activo
  IF EXISTS (
    SELECT 1 FROM Trip
    WHERE driver_id = NEW.driver_id
    AND state IN ('PENDIENTE', 'EN_CAMINO_AL_DESTINO', 'CARGA_ENTREGADA', 'EN_CAMINO_AL_ORIGEN')
  ) THEN
    RAISE EXCEPTION 'El conductor ya tiene un viaje activo y no puede ser asignado a otro viaje.';
  END IF;

  -- Verificar si la fecha del nuevo viaje ya está ocupada por otro viaje activo
  IF EXISTS (
    SELECT 1 FROM Trip
    WHERE vehicle_id = NEW.vehicle_id
    AND date = NEW.date
    AND state IN ('PENDIENTE', 'EN_CAMINO_AL_DESTINO', 'CARGA_ENTREGADA', 'EN_CAMINO_AL_ORIGEN')
  ) THEN
    RAISE EXCEPTION 'Ya existe un viaje en la misma fecha para este vehículo, y aún no ha finalizado.';
  END IF;

  RETURN NEW;
END;
$$;

-- ========================================
-- Función: validate_driver_status
-- Descripción: Verifica si el conductor está eliminado antes de iniciar un viaje
-- Parámetros:
--   Ninguno (se utiliza el valor NEW.driver_id para identificar al conductor en la tabla "Driver")
-- ========================================
CREATE OR REPLACE FUNCTION public.validate_driver_status()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  is_deleted BOOLEAN;  -- Variable para almacenar el estado de eliminación del conductor
BEGIN
  -- Obtener el valor de is_deleted del conductor
  SELECT Driver.is_deleted INTO is_deleted FROM Driver WHERE id = NEW.driver_id;
  
  -- Verificar si el conductor está eliminado
  IF is_deleted THEN
    RAISE EXCEPTION 'El conductor está eliminado y no puede iniciar un viaje';
  END IF;

  RETURN NEW;
END;
$function$
;

-- ========================================
-- Función: get_pending_trips_by_driver
-- Descripción: Obtiene los viajes pendientes de un conductor específico
-- Parámetros:
--   p_driver_id UUID: ID del conductor
-- Retorna:
--   Un conjunto de registros con los detalles de los viajes pendientes del conductor
-- ========================================
CREATE OR REPLACE FUNCTION get_pending_trips_by_driver(p_driver_id UUID)
RETURNS TABLE (trip_id UUID, route_id UUID, date TIMESTAMP, departure_time TIME, state TEXT) AS $$
BEGIN
  RETURN QUERY
  SELECT t.id, t.route_id, t.date, t.departure_time, t.state
  FROM Trip t
  WHERE t.driver_id = p_driver_id
    AND t.state = 'PENDIENTE'
    AND t.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql;


