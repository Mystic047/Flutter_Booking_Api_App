

const express = require('express');
const router = express.Router();
const db = require('./dbConnection');



router.post('/save', (req, res) => {
  const { email, password, firstName, lastName, phoneNumber } = req.body;

  if (!email || !password || !firstName || !lastName || !phoneNumber) {
    return res.status(400).send({ message: 'Please provide all required fields' });
  }

  const sql = 'INSERT INTO users (email, password, first_name, last_name, phone_number) VALUES (?, ?, ?, ?, ?)';
  const values = [email, password, firstName, lastName, phoneNumber];

  db.query(sql, values, (err, results) => {
    if (err) {
      console.error('Error inserting data into the database', err);
      return res.status(500).send({ message: 'Error inserting data into the database' });
    }
    res.send({ message: 'User data submitted successfully', userId: results.insertId });
  });
});

router.post('/hotel', (req, res) => {
  const { name, description, address, city, state ,country , zip_code , rating } = req.body;

  if (!name || !description || !address || !city || !state || !country || !zip_code|| !rating) {
    return res.status(400).send({ message: 'Please provide all required fields' });
  }

  const sql = 'INSERT INTO hotels (name, description, address, city, state ,country , zip_code , rating) VALUES (?, ?, ?, ?, ?, ?, ? , ?)';
  const values = [name, description, address, city, state ,country , zip_code , rating];

  db.query(sql, values, (err, results) => {
    if (err) {
      console.error('Error inserting data into the database', err);
      return res.status(500).send({ message: 'Error inserting data into the database' });
    }
    res.send({ message: 'Hotels data submitted successfully', userId: results.insertId });
  });
});


router.post('/room', (req, res) => {
  const { hotelId, number_of_rooms, type, amenities, price  } = req.body;

  if (!hotelId || !number_of_rooms || !type || !amenities || !price ) {
    return res.status(400).send({ message: 'Please provide all required fields' });
  }

  const sql = 'INSERT INTO rooms (hotel_id, number_of_rooms, type, amenities, price) VALUES (?, ?, ?, ?, ?)';
  const values = [hotelId, number_of_rooms, type, amenities, price];

  db.query(sql, values, (err, results) => {
    if (err) {
      console.error('Error inserting data into the database', err);
      return res.status(500).send({ message: 'Error inserting data into the database' });
    }
    res.send({ message: 'Rooms data submitted successfully', userId: results.insertId });
  });
});


router.post('/createBooking', async (req, res) => {
  
  const { user_id, room_id, check_in_date, check_out_date, total_price, status } = req.body;
  // Simple validation
  if (!user_id || !room_id || !check_in_date || !check_out_date || !total_price || !status) {
    return res.status(400).json({ message: 'Missing required booking fields' });
  }

  const sql = 'INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, total_price, status) VALUES (?, ?, ?, ?, ?, ?)';
  const values = [user_id, room_id, check_in_date, check_out_date, total_price, status];

  try {
    const results = await db.query(sql, values);

    // Explicitly setting the status to 200 for successful booking creation
    res.status(200).json({ message: 'Booking created successfully', bookingId: results.insertId });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      // This means the entry is a duplicate
      res.status(409).json({ message: 'Duplicate entry, this booking already exists.' });
    } else {
      console.error('Database error:', err);
      // It's unusual to consider an insert successful if there's an error without a clear success indication.
    }
  }
});


router.post('/addReview', (req, res) => {
  // Extract the review data from the request body
  const { review_id, hotel_id, user_id, rating, comment } = req.body;
  
  // Check for the presence of all required fields
  if (!review_id || !hotel_id || !user_id || !rating || !comment) {
    return res.status(400).send({ message: 'Please provide all required fields.' });
  }

  // Prepare the SQL query to insert review data
  const sql = 'INSERT INTO reviews (review_id, hotel_id, user_id, rating, comment) VALUES (?, ?, ?, ?, ?)';
  const values = [review_id, hotel_id, user_id, rating, comment];

  // Execute the query
  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Error adding review data to the database', err);
      return res.status(500).send({ message: 'Error adding review data to the database' });
    }
    res.status(200).send({ message: 'Review added successfully', reviewId: result.insertId });
  });
});





module.exports = router;
