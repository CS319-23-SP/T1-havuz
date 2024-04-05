const express = require('express');
const admin = require('../controllers/admin');

const router = express.Router();

router
  .get('/', admin.onGetAllAdmins)
  .post('/', admin.onCreateAdmin)
  .get('/:id', admin.onGetAdminByID)
  .delete('/:id', admin.onDeleteAdminByID)
  .patch('/:id', admin.onEditAdminByID);

module.exports = router;
