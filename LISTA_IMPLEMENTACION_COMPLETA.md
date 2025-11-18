# LISTA DE IMPLEMENTACION COMPLETA - ZULL THE CLUB

## RESUMEN EJECUTIVO

Este documento proporciona la lista completa de tareas necesarias para implementar el sistema de gestión de socios **Zull The Club** con todas las funcionalidades requeridas incluyendo:

✓ Validación de edad (>= 18 años)
✓ Generación y envío automático de QR por email
✓ Registro automático de visitas
✓ Lectura de QR desde cámara trasera
✓ Aceptación de términos y condiciones
✓ Persistencia permanente de datos
✓ Confirmación visual en dashboard

---

## FASE 1: PREPARACIÓN DEL ENTORNO

### 1.1 Instalación de dependencias
- [ ] Node.js 18+ instalado
- [ ] PostgreSQL 14+ configurado
- [ ] npm o yarn disponible
- [ ] Git configurado

### 1.2 Variables de entorno (.env.local)
```bash
DATABASE_URL=postgresql://usuario:contraseña@localhost:5432/zull_theclub
NEXTAUTH_SECRET=tu-secreto-aqui
EMAILJS_SERVICE_ID=tu-service-id
EMAILJS_TEMPLATE_ID=tu-template-id
EMAILJS_PUBLIC_KEY=tu-public-key
NEXTAUTH_URL=http://localhost:3000
```

### 1.3 Setup inicial
- [ ] Clonar repositorio
- [ ] `npm install`
- [ ] Crear base de datos PostgreSQL
- [ ] Ejecutar migraciones SQL

---

## FASE 2: CONFIGURACIÓN DE BASE DE DATOS

### 2.1 Ejecutar scripts SQL (en orden)
```sql
-- 1. ACTUALIZACION_BD_TERMINOS.sql
-- Crear tablas de términos y audit trail
-- Agregar columnas a tabla socios
-- Crear índices y vistas
```

### 2.2 Verificar tablas creadas
- [ ] Tabla `socios` con campos de términos
- [ ] Tabla `terminos_aceptados` creada
- [ ] Tabla `terminos_condiciones` creada
- [ ] Índices optimizados
- [ ] Vistas de reporte funcionando

### 2.3 Datos iniciales
- [ ] Insertar versiones de términos en `terminos_condiciones`
- [ ] Configurar permisos de bases de datos

---

## FASE 3: BACKEND - API ENDPOINTS

### 3.1 Autenticación
- [ ] `pages/api/auth/register.ts` - Actualizado con validación de términos
  - Incluir validación: `aceptaProteccionDatos` boolean
  - Incluir validación: `aceptaNormasAsociacion` boolean
  - Rechazar si alguno es false
  - Guardar en `terminos_aceptados` tabla
  - Registrar dispositivo/navegador

- [ ] `pages/api/auth/login.ts`
  - Validar usuario existe
  - Generar JWT token
  - Devolver datos de usuario

### 3.2 Gestión de Socios
- [ ] `pages/api/socios/index.ts` - Listar socios
- [ ] `pages/api/socios/por-numero/[numero].ts` - Búsqueda por número

### 3.3 Entrada y Visitas
- [ ] `pages/api/entrada/registrar.ts`
  - Validar QR escaneado
  - Verificar edad (solo >= 18)
  - Registrar visita en BD
  - Devolver confirmación

### 3.4 Validación de Términos
- [ ] `lib/terms-validation.ts` utility creado
  - `getTermsContent()` - Obtener textos de términos
  - `validateTermsAcceptance()` - Validar checkboxes
  - `recordTermsAcceptance()` - Guardar en BD

---

## FASE 4: FRONTEND - PÁGINAS

### 4.1 Página de Registro - `pages/registro.tsx`
- [ ] Formulario de registro con campos:
  - Nombre completo
  - Email
  - Fecha de nacimiento
  - Teléfono
  - Dirección
  - **Checkbox: Acepto Protección de Datos**
  - **Checkbox: Acepto Normas de la Asociación**

- [ ] Validaciones
  - Edad >= 18 años (calcular automáticamente)
  - Email válido (regex)
  - Teléfono válido
  - **Ambos checkboxes deben estar marcados**
  - Botón submit DESHABILITADO si algún checkbox sin marcar

- [ ] UI/UX
  - Mostrar mensaje de error si < 18 años
  - Botón "Ver términos y condiciones" expandible
  - Indicador visual de checkboxes requeridos
  - Spinner en submit
  - Mensaje de éxito al registrarse

### 4.2 Página de Login - `pages/login.tsx`
- [ ] Formulario login
- [ ] Validación de credenciales
- [ ] Redirección a dashboard

### 4.3 Dashboard - `pages/dashboard.tsx`
ÜPER IMPORTANTE - Mostrar sección de confirmación de términos:

- [ ] Sección "Cumplimiento de Términos" con fondo verde
  - Mostrar: ✓ Protección de Datos: Aceptado el [DATE]
  - Mostrar: ✓ Normas de la Asociación: Aceptado el [DATE]
  - Mostrar: Timestamp exacto de aceptación
  - Mostrar: Dispositivo desde el que se aceptó

- [ ] Sección de información de socio
  - Número de socio (ZULL-XXXX format)
  - QR escaneado
  - Email registrado
  - Total de visitas
  - Última visita

- [ ] Botón para descargar QR
- [ ] Historial de visitas

### 4.4 Página de Entrada - `pages/entrada.tsx`
- [ ] Lector QR con cámara trasera (facingMode: "environment")
- [ ] Botón para escanear
- [ ] Confirmación de visita registrada
- [ ] Mostrar: Nombre de socio + visita #X

### 4.5 Página Admin - `pages/admin.tsx` (OPCIONAL)
- [ ] Panel de administración
- [ ] Listar todos los socios
- [ ] Ver aceptaciones de términos
- [ ] Descargar reportes

---

## FASE 5: COMPONENTES FRONTEND

### 5.1 Componentes Reutilizables
- [ ] `components/ui/Button.tsx` - Botones consistentes
- [ ] `components/ui/Input.tsx` - Inputs con validación
- [ ] `components/ui/Card.tsx` - Tarjetas de contenido
- [ ] `components/ProtectedRoute.tsx` - Rutas protegidas
- [ ] `components/Navbar.tsx` - Barra de navegación
- [ ] `components/Footer.tsx` - Pie de página

### 5.2 Componentes Específicos
- [ ] `components/QRScanner.tsx` - Lector de QR
- [ ] `components/TermsAcceptance.tsx` - Checkboxes de términos
- [ ] `components/ConfirmationCheckmark.tsx` - Marca de confirmación
- [ ] `components/VisitHistory.tsx` - Historial de visitas

---

## FASE 6: UTILIDADES Y LIBRERÍAS

### 6.1 Autenticación
- [ ] `lib/auth.ts`
  - bcryptjs para hasheado de contraseñas
  - jsonwebtoken para JWT
  - Cookie management

### 6.2 Base de Datos
- [ ] `lib/db.ts`
  - Connection pooling con postgres
  - Error handling
  - Transaction support

### 6.3 Validaciones
- [ ] `lib/age-validation.ts` - Calcular y validar edad
- [ ] `lib/email-validation.ts` - Validar emails
- [ ] `lib/terms-validation.ts` - Validar aceptación

### 6.4 Generación de QR
- [ ] `lib/qrcode.ts`
  - Generar QR con número de socio
  - Convertir a base64
  - Devolver como imagen

### 6.5 Números de Socio
- [ ] `lib/member-number.ts`
  - Generar formato ZULL-XXXX
  - Asegurar unicidad
  - Increment automático

### 6.6 Email
- [ ] `lib/email.ts`
  - Integración con EmailJS
  - Plantilla con QR adjunto
  - Envío automático en registro

---

## FASE 7: TESTING Y VALIDACIONES

### 7.1 Pruebas Funcionales
- [ ] **Registro:**
  - Menor de 18 años es rechazado
  - Checkbox sin marcar rechaza envío
  - Ambos checkboxes requeridos
  - Email se recibe con QR
  - Datos guardados en BD

- [ ] **Login:**
  - Credenciales incorrectas rechazadas
  - Login exitoso redirige a dashboard
  - Token JWT se crea correctamente

- [ ] **Dashboard:**
  - ✓ marca visible para términos aceptados
  - Muestra fecha/hora de aceptación
  - Muestra información de socio correcta
  - QR descargable
  - Historial de visitas completo

- [ ] **Entrada:**
  - Escaneo de QR registra visita
  - Cámara trasera activa (environment)
  - Confirmación visual
  - Solo >= 18 años pueden entrar

### 7.2 Pruebas de Dispositivos
- [ ] Desktop (Chrome, Firefox, Safari)
- [ ] Tablet (iPad, Android)
- [ ] Mobile (iPhone, Android)
- [ ] Cámara trasera en todos los dispositivos

### 7.3 Pruebas de Seguridad
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] CSRF tokens
- [ ] Password hashing
- [ ] JWT validation
- [ ] Edad validada server-side

---

## FASE 8: DEPLOYMENT

### 8.1 Preparación
- [ ] Variables de entorno production configuradas
- [ ] SSL/TLS certificado
- [ ] Backup de BD configurado
- [ ] Logs configurados

### 8.2 Hosting
- [ ] Deploy a Vercel (o similar)
- [ ] BD PostgreSQL en hosting (AWS RDS, etc)
- [ ] Dominio DNS configurado
- [ ] Email SMTP configurado para producción

### 8.3 Post-Deployment
- [ ] Verificar todas las funcionalidades
- [ ] Prueba de end-to-end
- [ ] Monitoreo activado
- [ ] Backups automáticos

---

## CRÍTICO - REQUISITOS NO NEGOCIABLES

✓ **Datos NUNCA se borran** - Solo eliminable con solicitud expresa  
✓ **Edad >= 18 SIEMPRE** - Validada server-side  
✓ **Términos obligatorios** - Ambos checkboxes REQUERIDOS  
✓ **Funciona en CUALQUIER dispositivo** - Mobile, tablet, desktop  
✓ **Cámara trasera (environment)** - ÚNICO modo de QR  
✓ **Persistencia garantizada** - Todos los datos en BD permanente  
✓ **Confirmación visible** - ✓ marca en dashboard siempre visible  
✓ **Timestamp auditado** - Cada aceptación de términos registrada  

---

## ARCHIVOS A MODIFICAR/CREAR

### Archivos Nuevos
```
LISTA_IMPLEMENTACION_COMPLETA.md (este archivo)
RESUMEN_FINAL_PROYECTO.md (próximo)
```

### Archivos Modificados
```
pages/registro.tsx - Agregar checkboxes de términos
pages/api/auth/register.ts - Validar términos
pages/dashboard.tsx - Mostrar ✓ confirmación
lib/terms-validation.ts - Validaciones de términos
```

### Archivos Existentes (Sin cambios)
```
README.md
INSTALACION_Y_CONFIGURACION.md
ACTUALIZACION_BD_TERMINOS.sql
CODIGO_ACEPTACION_TERMINOS.md
```

---

## ESTIMACIÓN DE TIEMPO

- Fase 1: 30 minutos
- Fase 2: 20 minutos
- Fase 3: 2 horas
- Fase 4: 3 horas
- Fase 5: 1.5 horas
- Fase 6: 1 hora
- Fase 7: 2 horas
- Fase 8: 1 hora

**TOTAL ESTIMADO: 11 horas de implementación**

---

## CONTACTO Y SOPORTE

Para preguntas sobre la implementación, referirse a:
- README.md - Documentación general
- INSTALACION_Y_CONFIGURACION.md - Setup
- CODIGO_ACEPTACION_TERMINOS.md - Código específico de términos

---

**Última actualización:** 2025-01-23
**Estado:** LISTO PARA IMPLEMENTACIÓN
**Versión:** 1.0
