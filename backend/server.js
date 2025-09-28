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

app.use("/api/evaluaciones", evaluacionesRoutes);
app.use("/api/auth", authRoutes);

// Servidor
app.listen(port, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${port}`);
});
