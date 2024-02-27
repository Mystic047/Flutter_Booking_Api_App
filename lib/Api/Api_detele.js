// File: Api_delete.js (or wherever you're defining your delete route)
const express = require('express');
const router = express.Router();
const db = require('./dbConnection');
require('dotenv').config();


router.delete('/deleteuser', (req, res) => {
    const user_id = req.query.user_id;
  
    console.log('Attempting to delete user with ID:', user_id);
  
    if (!user_id) {
      return res.status(400).send({ message: 'User ID is required' });
    }
  
    const sql = 'DELETE FROM users WHERE user_id = ?';
    db.query(sql, [user_id], (err, result) => {
      if (err) {
        console.error('Error deleting user from the database', err);
        return res.status(500).send({ message: 'Error deleting user from the database' });
      }
      if (result.affectedRows === 0) {
        return res.status(404).send({ message: 'User not found' });
      }
      res.send({ message: 'User deleted successfully' });
    });
  });

  router.delete('/deletehotel', (req, res) => {
    const hotel_id = req.query.hotel_id;
  
    console.log('Attempting to delete hotel with ID:', hotel_id);
  
    if (!hotel_id) {
      return res.status(400).send({ message: 'Hotel ID is required' });
    }
  
    const sql = 'DELETE FROM hotels WHERE hotel_id = ?';
    db.query(sql, [hotel_id], (err, result) => {
      if (err) {
        console.error('Error deleting user from the database', err);
        return res.status(500).send({ message: 'Error deleting user from the database' });
      }
      if (result.affectedRows === 0) {
        return res.status(404).send({ message: 'User not found' });
      }
      res.send({ message: 'User deleted successfully' });
    });
  });
  

  router.delete('/deleteroom', (req, res) => {
    const room_id = req.query.room_id;
  
    console.log('Attempting to delete room with ID:', room_id);
  
    if (!room_id) {
      return res.status(400).send({ message: 'room ID is required' });
    }
  
    const sql = 'DELETE FROM rooms WHERE room_id = ?';
    db.query(sql, [room_id], (err, result) => {
      if (err) {
        console.error('Error deleting room from the database', err);
        return res.status(500).send({ message: 'Error deleting room from the database' });
      }
      if (result.affectedRows === 0) {
        return res.status(404).send({ message: 'room not found' });
      }
      res.send({ message: 'room deleted successfully' });
    });
  });


module.exports = router;
