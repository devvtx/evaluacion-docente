const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const port = 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());

// Rutas
const evaluacionesRoutes = require("./routes/evaluaciones");
app.use("/api/evaluaciones", evaluacionesRoutes);

// Servidor
app.listen(port, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${port}`);
});
