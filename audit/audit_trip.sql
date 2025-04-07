-- Tabla auditora para la tabla Trip
CREATE TABLE audit_trip (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- ID único de auditoría
    operation_type TEXT NOT NULL,                        -- Tipo de operación: INSERT, UPDATE, DELETE
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- Momento del cambio
    changed_by TEXT,                                     -- Usuario que hizo el cambio
    old_data JSONB,                                      -- Datos anteriores (para UPDATE o DELETE)
    new_data JSONB                                       -- Datos nuevos (para INSERT o UPDATE)
);

-- Función de auditoría para la tabla Trip
CREATE OR REPLACE FUNCTION log_trip_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO audit_trip (
            operation_type, changed_by, new_data
        ) VALUES (
            TG_OP, current_user, to_jsonb(NEW)
        );
        RETURN NEW;

    ELSIF (TG_OP = 'UPDATE') THEN
        -- Verificar si es una actualización de la columna is_deleted
        IF NEW.is_deleted = TRUE AND OLD.is_deleted = FALSE THEN
            -- Registrar como "DELETE lógico"
            INSERT INTO audit_trip (
                operation_type, changed_by, old_data
            ) VALUES (
                'DELETE', current_user, to_jsonb(OLD)
            );
        ELSE
            -- Registrar como una actualización normal
            INSERT INTO audit_trip (
                operation_type, changed_by, old_data, new_data
            ) VALUES (
                TG_OP, current_user, to_jsonb(OLD), to_jsonb(NEW)
            );
        END IF;
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_trip (
            operation_type, changed_by, old_data
        ) VALUES (
            TG_OP, current_user, to_jsonb(OLD)
        );
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para auditar cambios en la tabla Trip
CREATE TRIGGER trg_audit_trip
AFTER INSERT OR UPDATE OR DELETE ON Trip
FOR EACH ROW EXECUTE FUNCTION log_trip_changes();
