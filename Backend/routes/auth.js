const express = require('express');
const auth = require('../controllers/auth');
const { encode } = require('../middlewares/jwt');

const router = express.Router();

router
  .get('/', auth.onGetAllAuths)
  .post('/', auth.onCreateAuth)
  .get('/:id', auth.onGetAuthByID)
  .delete('/:id', auth.onDeleteAuthByID)
  .patch('/:id', auth.onEditAuthByID)
  .post('/login/:id', encode, auth.onLogin);

module.exports = router;
