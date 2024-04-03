const jwt = require('jsonwebtoken');
const authModel = require('../models/auth.js');

const SECRET_KEY = 'some-secret-key';
const TOKEN_EXPIRATION = '1h'; 

const encode = async (req, res, next) => {
  try {
    const {id} = req.params;  
  
    const auth = await authModel.getAuthById(id);    

    const payload = {
      id: auth._id,
      password: auth.password,
      role: auth.role
    };

    const authToken = jwt.sign(payload, SECRET_KEY, { expiresIn: TOKEN_EXPIRATION });
    console.log('Auth', authToken);
    req.authToken = authToken;
    next();
  } catch (error) {
    return res.status(400).json({ success: false, message: error.message });
  }
}

const decode = (req, res, next) => {
  if (!req.headers['authorization']) {
    return res.status(400).json({ success: false, message: 'No access token provided' });
  }
  const accessToken = req.headers.authorization.split(' ')[1];
  try {
    const decoded = jwt.verify(accessToken, SECRET_KEY);
    req.password = decoded.password;
    req._id = decoded.id;
    req.role = decoded.role;
    return next();
  } catch (error) {
    return res.status(401).json({ success: false, message: error.message });
  }
}

module.exports = { encode, decode };
