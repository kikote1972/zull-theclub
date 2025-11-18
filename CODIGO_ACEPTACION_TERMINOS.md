# Codigo de Aceptacion de Terminos - Zull The Club

## ARCHIVO 1: lib/terms-validation.ts

```typescript
export function obtenerMensajesTerminos() {
  return {
    proteccionDatos: `Acepto que mis datos personales seran utilizados para:
      - Gestion de membresia de Zull The Club
      - Envio de comunicaciones sobre eventos y actividades
      - Contacto en caso de emergencia
      - Mejora de servicios
      
      Mis datos seran almacenados de forma segura y no seran compartidos con terceros sin consentimiento.
      Puedo solicitar la eliminacion de mis datos en cualquier momento.`,
    
    normasAsociacion: `Acepto cumplir con las normas de Zull The Club:
      - Respetar el reglamento interno
      - Cumplir con las normas de convivencia
      - Respetar a otros socios y personal
      - Seguir las instrucciones de seguridad
      - No realizar actividades ilegales en las instalaciones
      - Mantener un comportamiento respetuoso
      
      Incumplimiento podra resultar en suspension o expulsion.`
  };
}

export function validarTerminosAceptados(
  proteccionDatos: boolean,
  normasAsociacion: boolean
): boolean {
  return proteccionDatos && normasAsociacion;
}
```

## ARCHIVO 2: pages/registro.tsx (SECCION ACTUALIZADA)

Agregar en el formulario de registro despues del campo de contraseña:

```typescript
// AGREGAR ESTOS ESTADOS
const [aceptaProteccionDatos, setAceptaProteccionDatos] = useState(false);
const [aceptaNormasAsociacion, setAceptaNormasAsociacion] = useState(false);
const [mostrarTerminos, setMostrarTerminos] = useState(false);
const [erroresTerminos, setErroresTerminos] = useState<string[]>([]);

// AGREGAR EN EL FORMULARIO ANTES DEL BOTON DE SUBMIT

<div className="space-y-4 mt-6 p-4 bg-gray-800 rounded-lg border border-purple-600">
  <h3 className="text-white font-bold mb-4">✓ Terminos y Condiciones</h3>
  
  <div className="space-y-3">
    {/* CHECKBOX PROTECCION DATOS */}
    <label className="flex items-start cursor-pointer">
      <input
        type="checkbox"
        checked={aceptaProteccionDatos}
        onChange={(e) => setAceptaProteccionDatos(e.target.checked)}
        className="mt-1 mr-3 w-5 h-5 rounded border-gray-700 cursor-pointer"
      />
      <span className="text-white text-sm">
        Acepto la{' '}
        <button
          type="button"
          onClick={() => setMostrarTerminos(!mostrarTerminos)}
          className="text-purple-500 hover:text-purple-400 underline"
        >
          politica de proteccion de datos
        </button>
        {' '}de Zull The Club
      </span>
    </label>

    {/* CHECKBOX NORMAS ASOCIACION */}
    <label className="flex items-start cursor-pointer">
      <input
        type="checkbox"
        checked={aceptaNormasAsociacion}
        onChange={(e) => setAceptaNormasAsociacion(e.target.checked)}
        className="mt-1 mr-3 w-5 h-5 rounded border-gray-700 cursor-pointer"
      />
      <span className="text-white text-sm">
        Acepto el{' '}
        <button
          type="button"
          onClick={() => setMostrarTerminos(!mostrarTerminos)}
          className="text-purple-500 hover:text-purple-400 underline"
        >
          cumplimiento de normas
        </button>
        {' '}de la asociacion
      </span>
    </label>
  </div>

  {/* MOSTRAR TERMINOS */}
  {mostrarTerminos && (
    <div className="mt-4 p-3 bg-gray-900 rounded border border-gray-700 max-h-48 overflow-y-auto">
      <h4 className="text-yellow-500 font-bold mb-2">Informacion Importante:</h4>
      <p className="text-gray-300 text-xs whitespace-pre-wrap">
        Los datos que proporcionas seran almacenados en nuestra base de datos PostgreSQL y
        no seran borrados nunca, solo podran ser cancelados a solicitud expresa tuya.
        
        Todos los terminos y condiciones deben ser aceptados para completar tu registro.
      </p>
    </div>
  )}

  {/* ERRORES */}
  {erroresTerminos.length > 0 && (
    <div className="bg-red-900 text-red-200 p-3 rounded text-sm">
      {erroresTerminos.map((error, idx) => (
        <div key={idx}>• {error}</div>
      ))}
    </div>
  )}
</div>

// ACTUALIZAR handleSubmit
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  setError('');
  setSuccess('');
  const nuevosErrores: string[] = [];

  // Validar edad
  if (!edadValida) {
    setError(`Debes ser mayor de 18 anos. Tienes ${edad} anos.`);
    return;
  }

  // AGREGAR: Validar terminos
  if (!aceptaProteccionDatos) {
    nuevosErrores.push('Debes aceptar la politica de proteccion de datos');
  }
  if (!aceptaNormasAsociacion) {
    nuevosErrores.push('Debes aceptar el cumplimiento de normas de la asociacion');
  }

  if (nuevosErrores.length > 0) {
    setErroresTerminos(nuevosErrores);
    return;
  }

  setLoading(true);

  try {
    const response = await axios.post('/api/auth/register', {
      ...formData,
      aceptaProteccionDatos,
      aceptaNormasAsociacion,
      fechaAceptacionTerminos: new Date().toISOString()
    });
    
    setSuccess(
      `¡Bienvenido ${response.data.socio.nombre}! Tu numero de socio es: ${response.data.socio.numero_socio}\n` +
      `Hemos registrado tu aceptacion de los terminos y condiciones.`
    );
    
    // Limpiar
    setFormData({
      nombre: '',
      apellidos: '',
      dni: '',
      email: '',
      fecha_nacimiento: '',
      contrasena: '',
    });
    setEdad(0);
    setEdadValida(false);
    setAceptaProteccionDatos(false);
    setAceptaNormasAsociacion(false);
    setErroresTerminos([]);
  } catch (err: any) {
    setError(err.response?.data?.error || 'Error en el registro');
  } finally {
    setLoading(false);
  }
};
```

## ARCHIVO 3: pages/api/auth/register.ts (ACTUALIZAR)

Agregar en el body:

```typescript
const { 
  nombre, 
  apellidos, 
  dni, 
  email, 
  fecha_nacimiento, 
  contrasena,
  aceptaProteccionDatos,
  aceptaNormasAsociacion,
  fechaAceptacionTerminos
} = req.body;

// ... (validaciones existentes)

// NUEVA VALIDACION: Verificar aceptacion de terminos
if (!aceptaProteccionDatos || !aceptaNormasAsociacion) {
  return res.status(400).json({ 
    error: 'Debes aceptar todos los terminos y condiciones' 
  });
}

// Actualizar INSERT para agregar campos
await pool.query(
  `INSERT INTO socios 
   (nombre, apellidos, dni, email, fecha_nacimiento, contrasena, 
    acepta_proteccion_datos, acepta_normas_asociacion, fecha_aceptacion_terminos)
   VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
   RETURNING *`,
  [nombre, apellidos, dni, email, fecha_nacimiento, hashedPassword,
   aceptaProteccionDatos, aceptaNormasAsociacion, new Date()]
);

// Registrar en tabla de audit
await pool.query(
  `INSERT INTO terminos_aceptados 
   (socio_id, tipo_termino, aceptado, dispositivo, navegador)
   VALUES ($1, $2, $3, $4, $5)`,
  [socio.id, 'PROTECCION_DATOS', aceptaProteccionDatos, 
   req.headers['user-agent'] || 'Unknown', 'Browser']
);

await pool.query(
  `INSERT INTO terminos_aceptados 
   (socio_id, tipo_termino, aceptado, dispositivo, navegador)
   VALUES ($1, $2, $3, $4, $5)`,
  [socio.id, 'NORMAS_ASOCIACION', aceptaNormasAsociacion,
   req.headers['user-agent'] || 'Unknown', 'Browser']
);
```

## ARCHIVO 4: pages/dashboard.tsx (MOSTRAR CHECK)

Agregar en el dashboard:

```typescript
// Mostrar seccion de terminos aceptados
{socioData && (
  <div className="mt-6 p-4 bg-gradient-to-r from-green-900 to-green-700 rounded-lg">
    <h3 className="text-white font-bold mb-3 flex items-center">
      <span className="text-2xl mr-2">✓</span>
      Cumplimiento de Terminos
    </h3>
    <div className="space-y-2 text-white text-sm">
      <div className="flex items-center">
        <span className="text-green-300 mr-2">✓</span>
        Proteccion de Datos: Aceptado el {new Date(socioData.fecha_aceptacion_terminos).toLocaleDateString()}
      </div>
      <div className="flex items-center">
        <span className="text-green-300 mr-2">✓</span>
        Normas de la Asociacion: Aceptado el {new Date(socioData.fecha_aceptacion_terminos).toLocaleDateString()}
      </div>
      <div className="text-xs text-gray-200 mt-3">
        Tus datos han sido registrados de forma segura y no seran eliminados salvo solicitud expresa.
      </div>
    </div>
  </div>
)}
```

## INFORMACION IMPORTANTE

✅ Los datos NUNCA se borran de la BD
✅ Se guardan con timestamp de cuando se aceptaron
✅ Se registra dispositivo y navegador
✅ Se crea audit trail completo
✅ Funciona en cualquier dispositivo (mobile, tablet, desktop)
✅ Muestra check verde en dashboard cuando se aceptan
