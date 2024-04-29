const express = require('express');
const forum = require('../controllers/forum.js');

const router = express.Router();

router
  .post('/', forum.post)
  .post('/:replid', forum.createForumReply)
  .get('/:replid', forum.getForumRepliesByReplyId)
  .get('/', forum.getAll)

module.exports = router;
