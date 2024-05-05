const express = require('express');
const chadRoom = require('../controllers/chad.js');

const router = express.Router();

router
  //.get('/', chatRoom.getRecentConversation)
  .get('/:roomId', chadRoom.getConversationByRoomId)
  .post('/initiate', chadRoom.initiate)
  .post('/:roomId', chadRoom.postMessage)
  .get('/', chadRoom.getConversations)

module.exports = router;
