const mongoose = require('mongoose');

const transaccionSchema = new mongoose.Schema({
  producto_id: String,
  nombre_producto: String,
  cantidad: Number,
  fecha: Date,
  valor_total: Number
});

module.exports = mongoose.model('Transaccion', transaccionSchema);
