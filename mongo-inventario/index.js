const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());


mongoose.connect('mongodb+srv://admin:inventariodb@inventario-db.tihjvcu.mongodb.net/?retryWrites=true&w=majority&appName=inventario-db')
  .then(() => console.log('Conectado a MongoDB'))
  .catch(err => console.error('Error conectando a MongoDB:', err));


app.get('/', (req, res) => {
  res.send('API de Inventario funcionando');
});


const apiRoutes = require('./routes/api');
app.use('/api', apiRoutes);

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🟢 Servidor escuchando en http://localhost:${PORT}`);
});