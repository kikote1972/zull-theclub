-- ACTUALIZACION DE BASE DE DATOS PARA ACEPTACION DE TERMINOS
-- Ejecutar estos comandos en la BD existente

-- 1. AGREGAR CAMPOS A TABLA socios
ALTER TABLE socios ADD COLUMN acepta_terminos BOOLEAN DEFAULT FALSE;
ALTER TABLE socios ADD COLUMN acepta_proteccion_datos BOOLEAN DEFAULT FALSE;
ALTER TABLE socios ADD COLUMN acepta_normas_asociacion BOOLEAN DEFAULT FALSE;
ALTER TABLE socios ADD COLUMN fecha_aceptacion_terminos TIMESTAMP;
ALTER TABLE socios ADD COLUMN ip_aceptacion VARCHAR(50);
ALTER TABLE socios ADD COLUMN dispositivo_aceptacion VARCHAR(100);

-- 2. CREAR TABLA DE AUDIT DE TERMINOS ACEPTADOS
CREATE TABLE terminos_aceptados (
  id SERIAL PRIMARY KEY,
  socio_id INT REFERENCES socios(id) ON DELETE CASCADE,
  tipo_termino VARCHAR(50),
  aceptado BOOLEAN DEFAULT FALSE,
  fecha_aceptacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_direccion VARCHAR(50),
  user_agent TEXT,
  dispositivo VARCHAR(100),
  navegador VARCHAR(100)
);

-- 3. CREAR TABLA DE TERMINOS Y CONDICIONES
CREATE TABLE terminos_condiciones (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(200) NOT NULL,
  contenido TEXT NOT NULL,
  version INT DEFAULT 1,
  activo BOOLEAN DEFAULT TRUE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. INSERTAR TERMINOS POR DEFECTO
INSERT INTO terminos_condiciones (titulo, contenido, version) VALUES (
  'Proteccion de Datos',
  'El usuario acepta que sus datos personales seran utilizados para:
   - Gestion de membresia
   - Envio de comunicaciones de eventos
   - Contacto en caso de emergencia
   
   Los datos seran almacenados de forma segura y no seran compartidos con terceros sin consentimiento.
   El usuario puede solicitar la eliminacion de sus datos en cualquier momento.',
  1
);

INSERT INTO terminos_condiciones (titulo, contenido, version) VALUES (
  'Cumplimiento de Normas de la Asociacion',
  'El usuario acepta:
   - Respetar el reglamento interno de Zull The Club
   - Cumplir con las normas de convivencia
   - Respetar a otros socios y personal
   - Seguir las instrucciones de seguridad
   - No realizar actividades ilegales en las instalaciones
   
   Incumplimiento de estas normas podra resultar en suspension o expulsion de la asociacion.',
  1
);

-- 5. CREAR INDICES
CREATE INDEX idx_terminos_aceptados_socio ON terminos_aceptados(socio_id);
CREATE INDEX idx_terminos_aceptados_fecha ON terminos_aceptados(fecha_aceptacion);
CREATE INDEX idx_socios_aceptacion ON socios(acepta_terminos, acepta_proteccion_datos);

-- 6. CREAR VISTA PARA VERIFICAR ACEPTACION
CREATE VIEW vista_socios_con_terminos AS
SELECT 
  s.id,
  s.nombre,
  s.apellidos,
  s.email,
  s.acepta_terminos,
  s.acepta_proteccion_datos,
  s.acepta_normas_asociacion,
  s.fecha_aceptacion_terminos,
  CASE WHEN s.acepta_terminos AND s.acepta_proteccion_datos AND s.acepta_normas_asociacion 
       THEN true ELSE false END as todos_terminos_aceptados,
  s.fecha_registro
FROM socios s;

COMMIT;
