const express = require("express");
const router = express.Router();
const db = require("../models/db");

// Campus
router.get("/campus", (_req, res) => {
  db.query("SELECT id_campus, nombre FROM campus ORDER BY nombre", [], (err, rows) => {
    if (err) return res.status(500).json({ success:false, message:"Error" });
    res.json(rows);
  });
});

// Carreras
router.get("/carreras", (_req, res) => {
  db.query("SELECT id_carrera, nombre FROM carreras ORDER BY nombre", [], (err, rows) => {
    if (err) return res.status(500).json({ success:false, message:"Error" });
    res.json(rows);
  });
});

module.exports = router;
