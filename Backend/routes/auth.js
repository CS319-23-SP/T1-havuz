const express = require('express');
const auth = require('../controllers/auth');
const { encode } = require('../middlewares/jwt');
const { decode } = require('../middlewares/jwt');

const router = express.Router();

router
  .get('/', decode, auth.onGetAllAuths)
  .post('/', decode, auth.onCreateAuth)
  .get('/:id', decode, auth.onGetAuthByID)
  .delete('/:id', decode, auth.onDeleteAuthByID)
  .patch('/:id', decode, auth.onEditAuthByID)
  .post('/login/:id', encode, auth.onLogin);

module.exports = router;
