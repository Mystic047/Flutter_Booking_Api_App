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

  router.get('/hoteldata/:user_id', (req, res) => {
    const { user_id } = req.params;
    // Assuming you have a way to relate hotels to users, adjust the SQL query accordingly.
    const sql = 'SELECT * FROM hotels WHERE user_id = ?';
    db.query(sql, [user_id], (err, results) => {
      if (err) {
        console.error('Error fetching hotels for user', err);
        return res.status(500).send({ message: 'Error fetching hotels for user' });
      }
      res.json(results);
    });
  });

  router.get('/hoteldata/:user_id', (req, res) => {
    const { user_id } = req.params;
    // Assuming you have a way to relate hotels to users, adjust the SQL query accordingly.
    const sql = 'SELECT * FROM hotels WHERE user_id = ?';
    db.query(sql, [user_id], (err, results) => {
      if (err) {
        console.error('Error fetching hotels for user', err);
        return res.status(500).send({ message: 'Error fetching hotels for user' });
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

  router.get('/hotel_id_from_room/:roomId', (req, res) => {
    const roomId = req.params.roomId;
    const sql = 'SELECT hotel_id FROM rooms WHERE room_id = ?';
    
    console.log(`Fetching hotel ID for room: ${roomId}`);
    db.query(sql, [roomId], (err, results) => {
      if (err) {
        console.error('Error fetching hotel ID from room', err);
        return res.status(500).send({ message: 'Error fetching hotel ID' });
      }
  
      if (results.length > 0) {
        res.json({ hotel_id: results[0].hotel_id });
      } else {
        res.status(404).send({ message: 'Room not found' });
      }
    });
});


router.get('/allbookingdata', (req, res) => {
  // Adjusted SQL query to include a JOIN with the users table
  const sql = `
  SELECT bookings.*, users.first_name
  FROM bookings
  JOIN users ON bookings.user_id = users.user_id`;


  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching bookings with user information', err);
      return res.status(500).send({ message: 'Error fetching bookings with user information' });
    }
    res.json(results);
  });
});


  router.get('/api/allbookingdata/:userId', (req, res) => {
    const userId = req.params.userId;
    const sql = `
      SELECT 
        bookings.*,
        CASE 
          WHEN reviews.review_id IS NOT NULL THEN 1
          ELSE 0
        END as reviewed
      FROM 
        bookings
      LEFT JOIN reviews ON bookings.hotel_id = reviews.hotel_id AND bookings.user_id = reviews.user_id
      WHERE 
        bookings.user_id = ?;
    `;
    
    db.query(sql, [userId], (err, results) => {
      if (err) {
        console.error('Error fetching booking data for user', err);
        return res.status(500).send({ message: 'Error fetching booking data' });
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


  router.get('/rooms/availableFrom', (req, res) => {
    const { start_date } = req.query;
  
    if (!start_date) {
      return res.status(400).send({ message: 'Please provide a start date' });
    }
  
    // Query to select all rooms that are not booked from the given start date onward
    const sql = `
      SELECT * FROM rooms r
      WHERE NOT EXISTS (
        SELECT 1 FROM bookings b
        WHERE b.room_id = r.room_id
        AND b.check_out_date >= ?
      );
    `;
    const values = [start_date];
  
    db.query(sql, values, (err, results) => {
      if (err) {
        console.error('Error fetching available rooms from a date', err);
        return res.status(500).send({ message: 'Error fetching available rooms from a date' });
      }
      res.json({ availableRooms: results });
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