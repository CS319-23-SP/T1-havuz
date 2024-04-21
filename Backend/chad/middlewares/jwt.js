const jwt = require('jsonwebtoken');
const UserModel = require('../models/User.js');

const SECRET_KEY = 'some-secret-key';
const TOKEN_EXPIRATION = '1h'; 

const encode = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const user = await UserModel.getUserById(userId);
    const payload = {
      userId: user._id,
      userType: user.type,
    };
    const authToken = jwt.sign(payload, SECRET_KEY, { expiresIn: TOKEN_EXPIRATION });
    console.log('Auth', authToken);
    req.authToken = authToken;
    next();
  } catch (error) {
    return res.status(400).json({ success: false, message: error.error });
  }
}

const decode = (req, res, next) => {
  if (!req.headers['authorization']) {
    return res.status(400).json({ success: false, message: 'No access token provided' });
  }
  const accessToken = req.headers.authorization.split(' ')[1];
  try {
    const decoded = jwt.verify(accessToken, SECRET_KEY);
    req.userId = decoded.userId;
    req.userType = decoded.type;
    return next();
  } catch (error) {
    return res.status(401).json({ success: false, message: error.message });
  }
}

module.exports = { encode, decode };
