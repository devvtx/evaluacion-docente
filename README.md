# Evaluación Docente

Aplicación web para que estudiantes se **registren/inicien sesión** y **evalúen a sus docentes**. El sistema calcula **promedios por criterio**, una **calificación total** (1–10) y clasifica al docente como **Activo** o **Inactivo** (si la calificación total < 7).

**by devvtx**

---

## Tecnologías

- **Frontend:** HTML5, CSS3, Bootstrap 5, JavaScript (fetch + localStorage)
- **Backend:** Node.js, Express, JWT (autenticación), bcryptjs (hash)
- **Base de datos:** MySQL 8
- **ORM/Driver:** mysql2

---

## Funcionalidades

- Registro e inicio de sesión con **JWT**.
- Cada estudiante puede **evaluar 1 vez por docente** (si vuelve a evaluar, se **actualiza**).
- Escala de evaluación **1..10** para claridad, puntualidad, dominio del tema y trato.
- **Promedios** por docente y **calificación total** con estado:
  - **Activo** (total ≥ 7)
  - **Inactivo** (total < 7) → se muestra en rojo.
- Vista de resultados agregados (`v_resultados_docentes`).
- Archivo `consultas.sql` con queries útiles.

---

## 🗂 Estructura del proyecto

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


## Requisitos

- **Node.js 18+**
- **MySQL 8** en local (con usuario que tenga permisos para crear BD/tablas)



SQL de consulta
En database/consultas.sql tienes:

Listados básicos (docentes, estudiantes, evaluaciones).
Agregados + estado (igual que backend).
Top 5 por calificación total.
Detalle por docente/estudiante.
Varios filtros (por materia, por nombre) y ejemplos de UPSERT.

Notas de seguridad
Cambia JWT_SECRET por uno fuerte en producción.



 Troubleshooting
“Error en el servidor” al registrar/iniciar sesión:
Verifica que importaste schema.sql y que el backend puede conectar a MySQL (DB_HOST/USER/PASS/NAME correctos).

ER_NOT_SUPPORTED_AUTH_MODE (MySQL 8):
Actualiza el plugin de auth del usuario o crea uno con mysql_native_password.

401/No autorizado al guardar evaluación:
Asegúrate de enviar el header Authorization: Bearer <token> (el frontend lo hace automáticamente tras login/registro).

CORS:
El backend ya trae cors habilitado.

✍️ Autor
by devvtx


