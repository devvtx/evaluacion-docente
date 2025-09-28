# Evaluación Docente

Aplicación web para que estudiantes se **registren/inicien sesión** y **evalúen a sus docentes**. El sistema calcula **promedios por criterio**, una **calificación total** (1–10) y clasifica al docente como **Activo** o **Inactivo** (si la calificación total < 7).

**by devvtx**

---

##  Tecnologías

- **Frontend:** HTML5, CSS3, Bootstrap 5, JavaScript (fetch + localStorage)
- **Backend:** Node.js, Express, JWT (autenticación), bcryptjs (hash)
- **Base de datos:** MySQL 8
- **ORM/Driver:** mysql2

---

##  Funcionalidades

- Registro e inicio de sesión con **JWT**.
- Cada estudiante puede **evaluar 1 vez por docente** (si vuelve a evaluar, se **actualiza**).
- Escala de evaluación **1..10** para claridad, puntualidad, dominio del tema y trato.
- **Promedios** por docente y **calificación total** con estado:
  - **Activo** (total ≥ 7)
  - **Inactivo** (total < 7) → se muestra en rojo.
- Vista de resultados agregados (`v_resultados_docentes`).
- Archivo `consultas.sql` con queries útiles.

---

##  Estructura del proyecto
evaluacion-docente/
├─ backend/
│ ├─ controllers/
│ │ ├─ authController.js
│ │ └─ evaluacionesController.js
│ ├─ middleware/
│ │ └─ auth.js
│ ├─ models/
│ │ └─ db.js
│ ├─ routes/
│ │ ├─ auth.js
│ │ └─ evaluaciones.js
│ ├─ server.js
│ ├─ package.json
│ └─ package-lock.json (se genera)
├─ database/
│ ├─ schema.sql
│ └─ consultas.sql
├─ frontend/
│ ├─ index.html
│ ├─ evaluar.html
│ ├─ resultados.html
│ ├─ css/
│ │ └─ styles.css
│ ├─ js/
│ │ └─ main.js
│ └─ img/
│ └─ evaluacion.jpg
└─ README.md


---

## ✅ Requisitos

- **Node.js 18+**
- **MySQL 8** en local (con usuario que tenga permisos para crear BD/tablas)

---

##  Configuración y ejecución (local, sin Docker)

### 1) Base de datos
Importa el esquema:

```sql
-- En MySQL (Workbench/CLI)
SOURCE /ruta/completa/a/database/schema.sql;

Esto creará la BD evaluacion_docentes, tablas, seed de docentes, la vista v_resultados_docentes y el procedure sp_guardar_evaluacion.

2) Variables de entorno del backend

Crea un archivo backend/.env:
DB_HOST=localhost
DB_USER=root
DB_PASS=root
DB_NAME=evaluacion_docentes
JWT_SECRET=cambia_este_secreto

Ajusta DB_USER y DB_PASS a tus credenciales reales de MySQL.

3) Instalar dependencias y levantar backend

cd backend
npm install
npm start
# Servidor en http://localhost:3000

Verás en consola: ✅ Conectado a MySQL y 🚀 Servidor corriendo...

4) Abrir frontend

Opción 1 (rápida): abre frontend/index.html con doble clic (protocolo file://).

main.js detecta file:// y usará http://localhost:3000/api.

Opción 2 (recomendado): usa un servidor estático (Live Server en VS Code) apuntando a frontend/.

Uso

En index.html se abrirá un modal para registrarte o iniciar sesión (se guarda el token en localStorage).

En evaluar.html, selecciona un docente y envía tu evaluación (1..10).

Si evalúas de nuevo al mismo docente, se actualiza tu evaluación.

En resultados.html, revisa promedios y calificación total.

Si total < 7 → Inactivo (fila en rojo).

🔌 API (resumen)

Base URL (local): http://localhost:3000/api

Auth

POST /auth/register
Body: { "nombre": "Juan Pérez", "email": "juan@x.com", "password": "1234" }

POST /auth/login
Body: { "email": "juan@x.com", "password": "1234" }
Res: { success, token, user }

Guarda el token y envíalo en Authorization: Bearer <token> para rutas protegidas.

Evaluaciones / Docentes

GET /evaluaciones/docentes → Lista de docentes

POST /evaluaciones/guardar (protegida)
Body:

{
  "id_docente": 1,
  "claridad": 8,
  "puntualidad": 9,
  "dominio_tema": 9,
  "trato_estudiantes": 8,
  "comentarios": "Muy bien"
}

{
  "id_docente": 1,
  "claridad": 8,
  "puntualidad": 9,
  "dominio_tema": 9,
  "trato_estudiantes": 8,
  "comentarios": "Muy bien"
}

Upsert por (id_docente, id_estudiante) del token.

GET /evaluaciones/resultados → Promedios, calificación total y estado por docente

 SQL de consulta

En database/consultas.sql tienes:

Listados básicos (docentes, estudiantes, evaluaciones).

Agregados + estado (igual que backend).

Top 5 por calificación total.

Detalle por docente/estudiante.

Varios filtros (por materia, por nombre) y ejemplos de UPSERT.

Notas de seguridad

Cambia JWT_SECRET por uno fuerte en producción.

No subas credenciales reales al repo (usa .env).

En producción, sirve el frontend detrás de un servidor y el backend con HTTPS.

 Troubleshooting

“Error en el servidor” al registrar/iniciar sesión:
Verifica que importaste schema.sql y que el backend puede conectar a MySQL (DB_HOST/USER/PASS/NAME correctos).

ER_NOT_SUPPORTED_AUTH_MODE (MySQL 8):
Actualiza el plugin de auth del usuario o crea uno con mysql_native_password.

401/No autorizado al guardar evaluación:
Asegúrate de enviar el header Authorization: Bearer <token> (el frontend lo hace automáticamente tras login/registro).

CORS:
El backend ya trae cors habilitado.

 Autor

by devvtx
