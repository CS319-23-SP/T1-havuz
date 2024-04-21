const express = require('express');
const forum = require('../controllers/forum.js');

const router = express.Router();

router
  .post('/post', forum.post)
  .post('/:replid/reply', forum.reply)
  .post('/:replid', forum.getAllReplies)
  .get('/', forum.getAll)

module.exports = router;
