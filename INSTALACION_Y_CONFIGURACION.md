# Guia Completa de Instalacion y Configuracion - Zull The Club

## PASO A PASO PARA IMPLEMENTAR LA APLICACION

### REQUISITOS PREVIOS

- Node.js 18 o superior
- PostgreSQL 15 o superior
- npm o yarn
- Git
- Visual Studio Code (recomendado)

### PASO 1: CREAR EL PROYECTO

```bash
npm create next-app@latest zull-theclub --typescript --tailwind --eslint
cd zull-theclub
```

En el wizard, selecciona:
- ESLint: Yes
- Tailwind CSS: Yes
- src/ directory: No
- App Router: Yes

### PASO 2: INSTALAR DEPENDENCIAS

```bash
npm install pg @types/pg bcryptjs jsonwebtoken qrcode emailjs-com axios react-qr-reader dotenv
```

### PASO 3: CREAR CARPETAS

```bash
mkdir -p lib pages/api/auth pages/api/entrada pages/api/socios components/ui
mkdir -p public styles scripts
```

### PASO 4: CREAR ARCHIVO .env.local

En la raiz del proyecto, crear archivo `.env.local`:

```
DATABASE_URL=postgresql://usuario:contrasena@localhost:5432/zull_club
JWT_SECRET=tu_clave_super_secreta_aqui_2024_signum_xyz
NEXT_PUBLIC_EMAILJS_SERVICE_ID=kikote846@gmail.com
NEXT_PUBLIC_EMAILJS_TEMPLATE_ID=template_x9l2pwp
NEXT_PUBLIC_EMAILJS_PUBLIC_KEY=unqv ssck hpoa irrk
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_QR_PREFIX=ZULL
```

### PASO 5: CREAR BASE DE DATOS

```bash
# Crear base de datos
createdb zull_club

# Conectarse a la base de datos
psql zull_club
```

Pegar el siguiente SQL:

```sql
-- Tabla de socios
CREATE TABLE socios (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  dni VARCHAR(20) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  fecha_nacimiento DATE NOT NULL,
  telefono VARCHAR(20),
  numero_socio VARCHAR(20) UNIQUE,
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  estado VARCHAR(20) DEFAULT 'activo',
  qr_code TEXT,
  qr_enviado BOOLEAN DEFAULT FALSE,
  contrasena VARCHAR(255) NOT NULL
);

-- Tabla de eventos
CREATE TABLE eventos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL,
  descripcion TEXT,
  fecha TIMESTAMP NOT NULL,
  tipo VARCHAR(50),
  ubicacion VARCHAR(200),
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de asistencia
CREATE TABLE asistencia (
  id SERIAL PRIMARY KEY,
  socio_id INT REFERENCES socios(id) ON DELETE CASCADE,
  evento_id INT REFERENCES eventos(id) ON DELETE SET NULL,
  tipo_visita VARCHAR(50),
  ubicacion VARCHAR(100),
  observaciones TEXT,
  fecha_asistencia TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear indices
CREATE INDEX idx_socios_email ON socios(email);
CREATE INDEX idx_socios_dni ON socios(dni);
CREATE INDEX idx_socios_numero ON socios(numero_socio);
CREATE INDEX idx_asistencia_socio ON asistencia(socio_id);
CREATE INDEX idx_asistencia_fecha ON asistencia(fecha_asistencia);
```

### PASO 6: COPIAR ARCHIVOS DE CODIGO

Ver los archivos en la carpeta `/code` del repositorio:

1. **lib/db.ts** - Conexion a base de datos
2. **lib/auth.ts** - Autenticacion y seguridad
3. **lib/qrcode.ts** - Generacion de QR
4. **lib/age-validation.ts** - Validacion de edad
5. **lib/member-number.ts** - Generacion de numero de socio
6. **pages/api/auth/register.ts** - API registro
7. **pages/api/auth/login.ts** - API login
8. **pages/api/entrada/registrar.ts** - API entrada
9. **pages/api/socios/index.ts** - API listar socios
10. **pages/api/socios/por-numero/[numero].ts** - API buscar por numero
11. **pages/index.tsx** - Home
12. **pages/registro.tsx** - Formulario registro
13. **pages/login.tsx** - Formulario login
14. **pages/dashboard.tsx** - Dashboard personal
15. **pages/entrada.tsx** - Panel entrada
16. **pages/admin.tsx** - Panel admin
17. Y todos los componentes reutilizables

### PASO 7: EJECUTAR LA APLICACION

```bash
npm run dev
```

Abrir en navegador: http://localhost:3000

### PASO 8: DESPLEGAR A PRODUCCION (Vercel)

```bash
# Instalar CLI de Vercel
npm i -g vercel

# Deploy
vercel
```

Seguir las instrucciones en pantalla.

---

## URLS IMPORTANTES

- **Home**: http://localhost:3000
- **Registro**: http://localhost:3000/registro
- **Login**: http://localhost:3000/login
- **Dashboard**: http://localhost:3000/dashboard
- **Entrada**: http://localhost:3000/entrada
- **Admin**: http://localhost:3000/admin

---

## CONTACTO ZULL THE CLUB

- Telefono: 647 368 072
- Instagram: @zulltheclub
- Direccion: Travesia de la laguna, 2, Fuenlabrada 28942
