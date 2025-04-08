const mongoose = require('mongoose');

const historialSchema = new mongoose.Schema({
  producto_id: String,
  modificacion: String,
  valor_anterior: Number,
  valor_nuevo: Number,
  fecha: Date,
  usuario: String
});

module.exports = mongoose.model('HistorialProducto', historialSchema);
