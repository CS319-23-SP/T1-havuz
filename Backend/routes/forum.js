const express = require('express');
const forumController = require('../controllers/forum.js');

const router = express.Router();

router
  .post('/', forumController.createForumPost)
  .post('/:parentReplyId', forumController.createForumReply)
  .get('/:replId', forumController.getForumRepliesByReplyId)
  .get('/section/:sectionId', forumController.getForumPostsBySectionId);

module.exports = router;
