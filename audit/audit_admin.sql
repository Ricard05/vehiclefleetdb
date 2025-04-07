-- Tabla auditora para Admin usando JSONB
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

-- Trigger para auditar la tabla Admin
CREATE TRIGGER trg_audit_admin
AFTER INSERT OR UPDATE OR DELETE ON Admin
FOR EACH ROW EXECUTE FUNCTION log_admin_changes();
