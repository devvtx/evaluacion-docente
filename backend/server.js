const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
require("dotenv").config();

const app = express();
const port = 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());

// Rutas
const evaluacionesRoutes = require("./routes/evaluaciones");
const authRoutes = require("./routes/auth");
const catalogosRoutes = require("./routes/catalogos");

app.use("/api/evaluaciones", evaluacionesRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/catalogos", catalogosRoutes);

// Servidor
app.listen(port, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${port}`);
});
