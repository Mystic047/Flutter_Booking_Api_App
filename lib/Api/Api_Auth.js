const express = require('express');
const router = express.Router();
const db = require('./dbConnection'); 
const jwt = require('jsonwebtoken');

const SECRET_KEY = 'MYSTIC2545'; // Ideally, store this in an environment variable

// Login route
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).send({ message: 'Please provide both email and password' });
  }

  const sql = 'SELECT * FROM users WHERE email = ?';
  db.query(sql, [email], (err, results) => {
    if (err) {
      console.error('Error querying the database', err);
      return res.status(500).send({ message: 'Error querying the database' });
    }
    if (results.length === 0 || password !== results[0].password) {
      return res.status(401).send({ message: 'Incorrect email or password' });
    }
    
    // Respond with the email and password for demonstration purposes
    res.json({ message: 'Login successful', email: email});
  });
});

module.exports = router;
