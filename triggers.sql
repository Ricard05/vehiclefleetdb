-- ========================================
-- Trigger: soft_delete_user
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "User"
-- ========================================
CREATE TRIGGER soft_delete_user
BEFORE DELETE ON "User"
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_admin
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "Admin"
-- ========================================
CREATE TRIGGER soft_delete_admin
BEFORE DELETE ON Admin
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_driver
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "Driver"
-- ========================================
CREATE TRIGGER soft_delete_driver
BEFORE DELETE ON Driver
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_vehicle
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "Vehicle"
-- ========================================
CREATE TRIGGER soft_delete_vehicle
BEFORE DELETE ON Vehicle
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_route
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "Route"
-- ========================================
CREATE TRIGGER soft_delete_route
BEFORE DELETE ON Route
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_cargo_type
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "CargoType"
-- ========================================
CREATE TRIGGER soft_delete_cargo_type
BEFORE DELETE ON CargoType
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_trip
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "Trip"
-- ========================================
CREATE TRIGGER soft_delete_trip
BEFORE DELETE ON Trip
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_vehicle_inspection
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "VehicleInspection"
-- ========================================
CREATE TRIGGER soft_delete_vehicle_inspection
BEFORE DELETE ON VehicleInspection
FOR EACH ROW
EXECUTE FUNCTION soft_delete();

-- ========================================
-- Trigger: soft_delete_driver_inspection
-- Descripción: Activa la función soft_delete antes de eliminar un registro en la tabla "DriverInspection"
-- ========================================
CREATE TRIGGER trg_soft_delete_user_when_driver_or_admin_is_deleted
AFTER UPDATE ON driver
FOR EACH ROW
WHEN (OLD.is_delete = false AND NEW.is_delete = true)
EXECUTE FUNCTION soft_delete_user_when_driver_or_admin_is_deleted();

-- ========================================
-- Trigger: soft_delete_user_when_driver_or_admin_is_deleted
-- Descripción: Marca como eliminado el usuario asociado a un conductor o administrador eliminado
-- ========================================
CREATE TRIGGER trg_soft_delete_user_when_admin_is_deleted
AFTER UPDATE ON admin
FOR EACH ROW
WHEN (OLD.is_delete = false AND NEW.is_delete = true)
EXECUTE FUNCTION soft_delete_user_when_driver_or_admin_is_deleted();

-- ========================================
-- Trigger: soft_delete_driver_or_admin_when_user_is_deleted
-- Descripción: Marca como eliminado el conductor o administrador asociado a un usuario eliminado
-- ========================================
CREATE TRIGGER trg_soft_delete_driver_or_admin_when_user_is_deleted
AFTER UPDATE ON "user"
FOR EACH ROW
WHEN (OLD.is_delete = false AND NEW.is_delete = true)
EXECUTE FUNCTION soft_delete_driver_or_admin_when_user_is_deleted();

-- ========================================
-- Trigger: validate_driver_license
-- Descripción: Valida que la licencia del conductor no esté expirada antes de iniciar un viaje
-- ========================================
CREATE TRIGGER trg_validate_driver_license
BEFORE INSERT ON Trip
FOR EACH ROW
EXECUTE FUNCTION validate_driver_license();

-- ========================================
-- Trigger: validate_driver_status
-- Descripción: Valida que el estado del conductor no este eliminado antes de iniciar un viaje
-- ========================================
CREATE TRIGGER trg_validate_driver_status
BEFORE INSERT ON Trip
FOR EACH ROW
EXECUTE FUNCTION validate_driver_status()

-- ========================================
-- Trigger: check_driver_has_active_trip_and_date
-- Descripción: Verifica que el conductor no tenga un viaje activo en la misma fecha
-- ========================================
CREATE TRIGGER trg_check_driver_has_active_trip_and_date
BEFORE INSERT ON Trip
FOR EACH ROW
EXECUTE FUNCTION check_driver_has_active_trip_and_date();