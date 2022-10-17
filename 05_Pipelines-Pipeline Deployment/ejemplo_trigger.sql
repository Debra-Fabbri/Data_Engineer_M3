use henry;

CREATE TABLE IF NOT EXISTS auditoria_alumno(
	IdAuditoria INT NOT NULL AUTO_INCREMENT,
    Descripcion VARCHAR(50) NOT NULL,
    Fecha_Hora DATETIME,
    Usuario VARCHAR(50) NOT NULL,
    PRIMARY KEY(IdAuditoria)
);

DROP TRIGGER audit_alumno;
CREATE TRIGGER audit_alumno AFTER INSERT ON alumno
FOR EACH ROW
INSERT INTO auditoria_alumno (Descripcion, Fecha_Hora, Usuario)
VALUES (concat('Nueva inserción: ', NEW.idAlumno, NEW.nombre, NEW.apellido), NOW(), current_user());