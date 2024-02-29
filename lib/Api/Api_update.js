// Api_update.js

const express = require('express');
const router = express.Router();
const db = require('./dbConnection'); // Reuse the database connection

// Route to update user data
router.put('/update/:id', (req, res) => {
  const { id } = req.params;
  const { email, firstName, lastName, phoneNumber } = req.body;
  
  if (!email || !firstName || !lastName || !phoneNumber) {
    return res.status(400).send({ message: 'Please provide all required fields.' });
  }

  const sql = 'UPDATE users SET email = ?, first_name = ?, last_name = ?, phone_number = ? WHERE user_id = ?';
  const values = [email, firstName, lastName, phoneNumber, id];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Error updating data in the database', err);
      return res.status(500).send({ message: 'Error updating data in the database' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).send({ message: 'User not found' });
    }
    res.send({ message: 'User data updated successfully' });
  });
});

router.put('/updateHotel/:id', (req, res) => {
  const { id } = req.params;
  const { name, description, address, city,state ,country , zip_code} = req.body;
  
  if (!name || !description || !address || !city || !state || !country || !zip_code) {
    return res.status(400).send({ message: 'Please provide all required fields.' });
  }

  const sql = 'UPDATE hotels SET name = ?, description = ?, address = ?, city = ?, state = ?, country = ?, zip_code = ? WHERE hotel_id = ?';
  const values = [name, description, address, city,state ,country , zip_code, id];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Error updating data in the database', err);
      return res.status(500).send({ message: 'Error updating data in the database' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).send({ message: 'Hotel not found' });
    }
    res.send({ message: 'Hotel data updated successfully' });
  });
});

router.put('/updateRoom/:id', (req, res) => {
  const { id } = req.params;
  const { hotelId, roomId, number_of_rooms, type,amenities ,price } = req.body;
  
  if (!hotelId || !roomId || !number_of_rooms || !type || !amenities || !price) {
    return res.status(400).send({ message: 'Please provide all required fields.' });
  }

  const sql = 'UPDATE rooms SET hotel_id = ?, room_id = ?, number_of_rooms = ?, type = ?, amenities = ?, price = ? WHERE room_id = ?';
  const values = [hotelId, roomId, number_of_rooms, type,amenities ,price, id];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Error updating data in the database', err);
      return res.status(500).send({ message: 'Error updating data in the database' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).send({ message: 'Room not found' });
    }
    res.send({ message: 'Romm data updated successfully' });
  });
});

router.put('/updateBooking/:id', (req, res) => {
  const {
    booking_id,
    user_id,
    room_id,
    check_in_date,
    check_out_date,
    total_price,
    status
  } = req.body;

  // Validate that all required fields are provided
  if (!user_id || !room_id || !check_in_date || !check_out_date || !total_price || !status) {
    return res.status(400).send({ message: 'Please provide all required fields.' });
  }

  // Prepare the SQL query to update booking data
  const sql = 'UPDATE bookings SET user_id = ?, room_id = ?, check_in_date = ?, check_out_date = ?, total_price = ?, status = ? WHERE booking_id = ?';
  const values = [user_id, room_id, check_in_date, check_out_date, total_price, status, booking_id];

  // Execute the SQL query
  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Error updating data in the database', err);
      return res.status(500).send({ message: 'Error updating data in the database' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).send({ message: 'Booking not found' });
    }
    res.send({ message: 'Booking updated successfully.' });
  });
});

router.put('/updateReview/:id', (req, res) => {
  const { id } = req.params;
  const { review_id, hotel_id, user_id, comment,rating } = req.body;
  
  if (!review_id || !hotel_id || !user_id || !comment || !rating ) {
    return res.status(400).send({ message: 'Please provide all required fields.' });
  }

  const sql = 'UPDATE reviews SET hotel_id = ?, user_id = ?, comment = ?, rating = ? WHERE review_id = ?';
  const values = [ hotel_id, user_id, comment,rating , id];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Error updating data in the database', err);
      return res.status(500).send({ message: 'Error updating data in the database' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).send({ message: 'Review not found' });
    }
    res.send({ message: 'Review data updated successfully' });
  });
});


module.exports = router;
