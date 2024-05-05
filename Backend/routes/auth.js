const express = require('express');
const auth = require('../controllers/auth');
const { encode } = require('../middlewares/jwt');
const { decode } = require('../middlewares/jwt');
const upload = require('../middlewares/multer');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', roleChecker(['admin']), decode, auth.onGetAllAuths)
  .post('/', roleChecker(['admin']), decode, upload.single('profile'), auth.onCreateAuth)
  .get('/:id',  decode, auth.onGetAuthByID)
  .delete('/:id', roleChecker(['admin']), decode, auth.onDeleteAuthByID)
  .patch('/:id', decode, auth.onEditAuthByID)
  .post('/login/:id', encode, auth.onLogin);

module.exports = router;
