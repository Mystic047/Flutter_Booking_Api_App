const express = require('express');
const router = express.Router();
const db = require('./dbConnection'); 

router.get('/alluserdata', (req, res) => {
    const sql = 'SELECT * FROM users';
    db.query(sql, (err, results) => {
      if (err) {
        console.error('Error querying the database', err);
        return res.status(500).send({ message: 'Error querying the database' });
      }
      res.json(results);
    });
  });

  router.get('/alluserdatabyEmail', (req, res) => {
    const email = req.query.email;
    const sql = 'SELECT * FROM users WHERE email = ?';
    db.query(sql, [email], (err, results) => {
      if (err) {
        console.error('Error querying the database', err);
        return res.status(500).send({ message: 'Error querying the database' });
      }
      res.json(results);
    });
  });
  
  

  router.get('/allhoteldata', (req, res) => {
    const sql = 'SELECT * FROM hotels';
    db.query(sql, (err, results) => {
      if (err) {
        console.error('Error fetching hotels', err);
        return res.status(500).send({ message: 'Error fetching hotels' });
      }
      res.json(results);
    });
  });

  router.get('/allroomdata', (req, res) => {
    const sql = 'SELECT * FROM rooms';
    db.query(sql, (err, results) => {
      if (err) {
        console.error('Error fetching hotels', err);
        return res.status(500).send({ message: 'Error fetching hotels' });
      }
      res.json(results);
    });
  });

  router.get('/allbookingdata', (req, res) => {
    const sql = 'SELECT * FROM bookings';
    db.query(sql, (err, results) => {
      if (err) {
        console.error('Error fetching hotels', err);
        return res.status(500).send({ message: 'Error fetching hotels' });
      }
      res.json(results);
    });
  });

  router.get('/allreviewdata', (req, res) => {
    const sql = 'SELECT * FROM reviews';
    db.query(sql, (err, results) => {
      if (err) {
        console.error('Error fetching hotels', err);
        return res.status(500).send({ message: 'Error fetching hotels' });
      }
      res.json(results);
    });
  });

  router.get('/rooms/available', (req, res) => {
    const { check_in_date, check_out_date } = req.query;
  
    if (!check_in_date || !check_out_date) {
      return res.status(400).send({ message: 'Please provide both check-in and check-out dates' });
    }
  
    // Query to select all rooms that are not booked within the given date range
    const sql = `
      SELECT * FROM rooms
      WHERE room_id NOT IN (
        SELECT room_id FROM bookings
        WHERE NOT (
          check_out_date <= ? OR
          check_in_date >= ?
        )
      );
    `;
    const values = [check_in_date, check_out_date];
  
    db.query(sql, values, (err, results) => {
      if (err) {
        console.error('Error fetching available rooms', err);
        return res.status(500).send({ message: 'Error fetching available rooms' });
      }
      res.json({ availableRooms: results });
    });
  });
  
  

  module.exports = router;