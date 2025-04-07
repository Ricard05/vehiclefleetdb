-- Tabla auditora para User
CREATE TABLE audit_user (
    audit_id SERIAL PRIMARY KEY,
    operation TEXT NOT NULL, -- INSERT, UPDATE, DELETE
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB,
    new_data JSONB
);

-- Trigger function para User
CREATE OR REPLACE FUNCTION log_user_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_user(operation, new_data)
        VALUES ('INSERT', row_to_json(NEW));
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        -- Verificar si es una actualización de la columna is_deleted
        IF NEW.is_deleted = TRUE AND OLD.is_deleted = FALSE THEN
            -- Registrar como "DELETE lógico"
            INSERT INTO audit_user(operation, old_data)
            VALUES ('DELETE', row_to_json(OLD));
        ELSE
            -- Registrar como una actualización normal
            INSERT INTO audit_user(operation, old_data, new_data)
            VALUES ('UPDATE', row_to_json(OLD), row_to_json(NEW));
        END IF;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_user(operation, old_data)
        VALUES ('DELETE', row_to_json(OLD));
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Trigger para User
CREATE TRIGGER trg_audit_user
AFTER INSERT OR UPDATE OR DELETE ON "User"
FOR EACH ROW EXECUTE FUNCTION log_user_changes();