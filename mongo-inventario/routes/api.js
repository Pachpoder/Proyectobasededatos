const express = require('express');
const router = express.Router();

const Transaccion = require('../models/transaccion');
const HistorialProducto = require('../models/historialProducto');
const Comentario = require('../models/comentario');

// POST - Crear una transacción histórica
router.post('/transacciones', async (req, res) => {
  const nueva = new Transaccion(req.body);
  await nueva.save();
  res.status(201).json(nueva);
});

// GET - Obtener todas las transacciones
router.get('/transacciones', async (req, res) => {
  const data = await Transaccion.find();
  res.json(data);
});

//  POST - Crear un historial de modificación de producto
router.post('/historial', async (req, res) => {
  const nuevo = new HistorialProducto(req.body);
  await nuevo.save();
  res.status(201).json(nuevo);
});

//  POST - Agregar un comentario de operador
router.post('/comentarios', async (req, res) => {
  const nuevo = new Comentario(req.body);
  await nuevo.save();
  res.status(201).json(nuevo);
});

//  GET - Obtener todo el historial de productos
router.get('/historial', async (req, res) => {
    const historial = await HistorialProducto.find();
    res.json(historial);
  });
  
  // GET - Obtener todos los comentarios de operadores
  router.get('/comentarios', async (req, res) => {
    const comentarios = await Comentario.find();
    res.json(comentarios);
  });

module.exports = router;
