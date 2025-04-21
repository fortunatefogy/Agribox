const userModel = require('../models/userModel');
const bcrypt = require('bcrypt');

// Register user with improved error handling and logging
exports.registerUser = (req, res) => {
  const { name, email, password, phone } = req.body;
  console.log('Registration attempt:', { name, email, phone, passwordLength: password?.length });

  if (!name || !email || !password || !phone) {
    console.log('Missing fields in registration request');
    return res.status(400).json({ message: 'All fields are required' });
  }

  // First check if user already exists
  userModel.getUserByEmail(email, (err, existingUser) => {
    if (err) {
      console.error('Database error checking existing user:', err);
      return res.status(500).json({ message: 'Database error' });
    }
    
    if (existingUser) {
      console.log('Email already in use:', email);
      return res.status(409).json({ message: 'Email already in use' });
    }
    
    // Hash password before storing
    bcrypt.hash(password, 10, (err, hashedPassword) => {
      if (err) {
        console.error('Password encryption failed:', err);
        return res.status(500).json({ message: 'Password encryption failed' });
      }

      const user = { 
        name, 
        email, 
        password: hashedPassword, 
        phone 
      };

      userModel.createUser(user, (err, result) => {
        if (err) {
          console.error('Database error creating user:', err);
          return res.status(500).json({ message: 'Database error', error: err.message });
        }
        console.log('User registered successfully:', { email });
        res.status(201).json({ message: 'User registered successfully' });
      });
    });
  });
};

// Login user with improved error handling
exports.loginUser = (req, res) => {
  const { email, password } = req.body;
  console.log('Login attempt:', { email });

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  userModel.getUserByEmail(email, (err, user) => {
    if (err) {
      console.error('Database error during login:', err);
      return res.status(500).json({ message: 'Database error' });
    }
    
    if (!user) {
      console.log('Invalid login attempt - user not found:', { email });
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    // Compare submitted password with stored hash
    bcrypt.compare(password, user.password, (err, isMatch) => {
      if (err) {
        console.error('Authentication error:', err);
        return res.status(500).json({ message: 'Authentication error' });
      }
      
      if (isMatch) {
        // Remove password from user object before sending to client
        const userResponse = {...user};
        delete userResponse.password;
        
        console.log('Login successful:', { email });
        res.status(200).json({ 
          message: 'Login successful', 
          user: userResponse 
        });
      } else {
        console.log('Invalid login attempt - wrong password:', { email });
        res.status(401).json({ message: 'Invalid email or password' });
      }
    });
  });
};