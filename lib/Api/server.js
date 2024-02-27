const express = require('express');
const db = require('./dbConnection'); 
const bodyParser = require('body-parser');
const addRoutes = require('./Api_add'); // Make sure the path is correct
const updateRoutes = require('./Api_update');
const authRoutes = require('./Api_Auth');
const fetchRoutes = require('./Api_fetchdata');
const deleteRoute = require('./Api_detele')
const cors = require('cors');




const app = express();
const port = 3000;
app.use(cors());
app.use(bodyParser.json()); // for parsing application/json

app.use('/api_add', addRoutes); // Use the routes defined in Api_add.js
app.use('/api_update', updateRoutes); 
app.use('/api_auth', authRoutes); 
app.use('/api_fetch', fetchRoutes);
app.use('/api_delete', deleteRoute);





app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
