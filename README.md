# 🎵 Zull The Club - Sistema de Gestion de Socios

**Aplicacion Web Full-Stack para gestion de socios con Sistema QR, Validaciones y Seguimiento de Visitas**

![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)
![TypeScript](https://img.shields.io/badge/TypeScript-5.0%2B-blue)
![Next.js](https://img.shields.io/badge/Next.js-14.0%2B-black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15%2B-336791)

---

## 📋 Indice
- [Caracteristicas](#caracteristicas)
- [Tech Stack](#tech-stack)
- [Instalacion](#instalacion)
- [Configuracion](#configuracion)
- [Uso](#uso)
- [API Endpoints](#api-endpoints)
- [Base de Datos](#base-de-datos)
- [Deployment](#deployment)

---

## ✨ Caracteristicas

### ✅ Registro de Socios
- Formulario con validación de edad (>= 18 años)
- Validación de email y DNI únicos
- Generación automática de número de socio (ZULL-0001, ZULL-0002, etc.)
- Encriptación de contraseñas con bcryptjs

### ✅ Codigos QR
- Generación automática de código QR por socio
- Envío automático por email via EmailJS
- Lectura desde cámara trasera (móvil/tablet)
- Almacenamiento en base de datos

### ✅ Sistema de Visitas
- Registro automático de visita al registrarse
- Botón para registrar entrada en la asociación
- Seguimiento de visitas por socio
- Histórico de asistencias

### ✅ Autenticacion y Seguridad
- JWT Token con duración de 30 días
- Contraseñas hasheadas con bcryptjs
- Validaciones en Frontend y Backend
- Rutas protegidas

### ✅ Sincronizacion Entre Dispositivos
- Datos centralizados en PostgreSQL
- Acceso desde Desktop, Tablet y Móvil
- Actualización en tiempo real
- Persistencia de datos

### ✅ Panel de Administracion
- Lista completa de socios
- Estadisticas en tiempo real
- Gestion de eventos
- Exportación de datos

---

## 🛠️ Tech Stack

**Frontend:**
- React 18
- Next.js 14 (App Router)
- TypeScript
- Tailwind CSS
- Axios
- QRCode Library

**Backend:**
- Next.js API Routes
- Node.js
- PostgreSQL 15+
- JWT (jsonwebtoken)
- bcryptjs
- EmailJS

**Herramientas:**
- npm
- Git/GitHub
- Vercel (para deployment)

---

## 🚀 Instalacion

### Prerequisitos
- Node.js 18+
- npm o yarn
- PostgreSQL 15+
- Git

### Paso 1: Clonar Repositorio
```bash
git clone https://github.com/kikote1972/zull-theclub.git
cd zull-theclub
```

### Paso 2: Instalar Dependencias
```bash
npm install
```

### Paso 3: Crear Carpetas
```bash
mkdir -p lib pages/api/auth pages/api/entrada pages/api/socios components/ui
```

### Paso 4: Configurar Variables de Entorno
Crear archivo `.env.local` en la raiz del proyecto (ver seccion Configuracion)

### Paso 5: Crear Base de Datos
```bash
creatdb zull_club
psql zull_club < scripts/schema.sql
```

### Paso 6: Ejecutar en Desarrollo
```bash
npm run dev
```

Abrir [http://localhost:3000](http://localhost:3000)

---

## ⚙️ Configuracion

### Archivo .env.local

Crear en la raiz del proyecto con las siguientes variables:

```
DATABASE_URL=postgresql://usuario:contrasena@localhost:5432/zull_club
JWT_SECRET=tu_clave_super_secreta_aqui_2024
NEXT_PUBLIC_EMAILJS_SERVICE_ID=kikote846@gmail.com
NEXT_PUBLIC_EMAILJS_TEMPLATE_ID=template_x9l2pwp
NEXT_PUBLIC_EMAILJS_PUBLIC_KEY=unqv ssck hpoa irrk
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_QR_PREFIX=ZULL
```

### EmailJS Setup

1. Ir a [emailjs.com](https://www.emailjs.com/)
2. Crear cuenta
3. Conectar Gmail
4. Crear template con variables:
   - `{{to_email}}`
   - `{{socio_nombre}}`
   - `{{socio_apellidos}}`
   - `{{numero_socio}}`
   - `{{qr_code}}`
   - `{{fecha_registro}}`

---

## 📱 Uso

### Para Socios

#### 1. Registro
- Ir a `/registro`
- Llenar formulario con datos personales
- Validar edad (debe ser >= 18 anos)
- Submit
- Recibir numero de socio (ZULL-XXXX)
- Recibir email con QR

#### 2. Login
- Ir a `/login`
- Ingresar email y contrasena
- Acceder a `/dashboard`
- Ver datos personales y descargar QR
- Ver historial de visitas

#### 3. Entrada
- Mostrar QR en la entrada
- Admin lee QR desde `/entrada`
- Se suma automaticamente +1 visita

### Para Admin

#### Panel de Administracion
- Ir a `/admin`
- Ver lista de socios
- Ver estadisticas
- Registrar entradas
- Descargar reportes

---

## 🔌 API Endpoints

### Autenticacion
```
POST /api/auth/register    - Registrar nuevo socio
POST /api/auth/login       - Login de socio
```

### Socios
```
GET  /api/socios              - Listar todos los socios
GET  /api/socios/por-numero/[numero]  - Buscar por numero de socio
GET  /api/socios/[id]         - Obtener datos de un socio
PUT  /api/socios/[id]         - Actualizar datos de socio
```

### Entrada
```
POST /api/entrada/registrar   - Registrar entrada
GET  /api/entrada/visitas/[id] - Ver visitas de un socio
```

---

## 🗄️ Base de Datos

### Tablas

#### socios
```sql
id (PK) | nombre | apellidos | dni | email | fecha_nacimiento 
numero_socio | fecha_registro | estado | qr_code | qr_enviado | contrasena
```

#### eventos
```sql
id (PK) | nombre | descripcion | fecha | tipo | ubicacion | fecha_creacion
```

#### asistencia
```sql
id (PK) | socio_id (FK) | evento_id (FK) | tipo_visita 
ubicacion | observaciones | fecha_asistencia
```

---

## 🚀 Deployment

### Vercel (Recomendado)

1. Push a GitHub
2. Ir a [vercel.com](https://vercel.com)
3. Importar proyecto
4. Configurar variables de entorno
5. Deploy automatico

### Comandos Build
```bash
npm run build      # Compilar proyecto
npm start          # Iniciar en producción
npm run lint       # Validar codigo
```

---

## 📞 Contacto Zull The Club

- **Nombre:** Zull The Club
- **Domicilio:** Travesia de la laguna, 2, Fuenlabrada 28942
- **Telefono:** 647 368 072
- **Instagram:** @zulltheclub
- **Reels:** zull.theclub
- **Servicios:** DJ Sessions, DJ Classes, Live Music Events

---

## 📄 Licencia

MIT License - Ver archivo LICENSE para más detalles

---

## 🤝 Soporte

Para reportar bugs o sugerencias, crear un [Issue](https://github.com/kikote1972/zull-theclub/issues)

---

**Developed with ❤️ for Zull The Club**
