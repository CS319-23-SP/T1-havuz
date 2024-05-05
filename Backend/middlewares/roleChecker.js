const SECRET_KEY = 'some-secret-key';
const jwt = require('jsonwebtoken');

const roleChecker = (allowedRoles) => {
  return (req, res, next) => {
    if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, error: 'Authorization header is missing or invalid' });
    }
    
    const token = req.headers.authorization.split(' ')[1];
    
    try {
      const decoded = jwt.verify(token, SECRET_KEY);
      const role = decoded.role;
      
      if (!allowedRoles.includes(role)) {
        return res.status(401).json({ success: false, error: `Role must be one of: ${allowedRoles.join(', ')}` });
      }
      
      next();
    } catch (error) {
      return res.status(401).json({ success: false, error: 'Invalid token' });
    }
  };
};

module.exports = roleChecker;
