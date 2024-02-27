const mysql = require('mysql');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'flutter_booking'
});

db.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL');
});

module.exports = db; // Export the db connection
