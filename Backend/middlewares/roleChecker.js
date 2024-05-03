const roleChecker = (allowedRoles) => {
    return (req, res, next) => {
      const { role } = req;
      if (!allowedRoles.includes(role)) {
        return res.status(401).json({ success: false, error: `Role must be one of: ${allowedRoles.join(', ')}` });
      }
      next();
    };
  };

  module.exports = roleChecker;