const mysql = require("mysql2");

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",     // Cambia si tienes otro usuario
  password: "root", // Tu contraseña de MySQL
  database: "evaluacion_docentes"
});

connection.connect((err) => {
  if (err) {
    console.error("❌ Error al conectar a MySQL:", err);
    return;
  }
  console.log("✅ Conectado a MySQL");
});

module.exports = connection;
