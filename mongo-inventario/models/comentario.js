const mongoose = require('mongoose');

const comentarioSchema = new mongoose.Schema({
  producto_id: String,
  comentario: String,
  fecha: Date,
  operador: String
});

module.exports = mongoose.model('Comentario', comentarioSchema);
