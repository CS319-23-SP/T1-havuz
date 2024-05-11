const express = require('express');
const forumController = require('../controllers/forum.js');

const router = express.Router();

router
  .post('/:term/:sectionId', forumController.createForumPost)
  .post('/:parentReplyId', forumController.createForumReply)
  .get('/:replId', forumController.getForumRepliesByReplyId)
  .get('/:term/:sectionId', forumController.getForumPostsBySectionId);

module.exports = router;