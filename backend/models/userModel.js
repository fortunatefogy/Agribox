const db = require('../config/db');

// Create new user with improved error handling
exports.createUser = (user, callback) => {
  // First check if table exists, create if not
  const checkTableQuery = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      phone VARCHAR(20) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `;
  
  db.query(checkTableQuery, (err) => {
    if (err) {
      console.error('Error checking/creating users table:', err);
      return callback(err, null);
    }
    
    // Now insert the user
    const query = 'INSERT INTO users (name, email, password, phone) VALUES (?, ?, ?, ?)';
    
    db.query(
      query, 
      [user.name, user.email, user.password, user.phone],
      (err, result) => {
        if (err) {
          // Check for duplicate email error (MySQL error code 1062)
          if (err.code === 'ER_DUP_ENTRY') {
            console.error('Duplicate email error:', err.message);
            return callback({ message: 'Email already exists' }, null);
          }
          
          console.error('Error creating user:', err);
          return callback(err, null);
        }
        console.log('User created successfully, ID:', result.insertId);
        callback(null, result);
      }
    );
  });
};

// Get user by email with improved error handling
exports.getUserByEmail = (email, callback) => {
  // First check if table exists
  const checkTableQuery = `
    SHOW TABLES LIKE 'users'
  `;
  
  db.query(checkTableQuery, (err, tables) => {
    if (err) {
      console.error('Error checking users table:', err);
      return callback(err, null);
    }
    
    // If table doesn't exist, return null (no user found)
    if (tables.length === 0) {
      console.log('Users table does not exist yet');
      return callback(null, null);
    }
    
    // Now query for the user
    const query = 'SELECT * FROM users WHERE email = ?';
    
    db.query(query, [email], (err, results) => {
      if (err) {
        console.error('Error fetching user by email:', err);
        return callback(err, null);
      }
      
      // Return the first matching user or null if no match
      callback(null, results.length > 0 ? results[0] : null);
    });
  });
};