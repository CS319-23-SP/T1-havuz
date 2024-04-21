const express = require('express');
const chadRoom = require('../controllers/chad.js');

const router = express.Router();

router
  //.get('/', chatRoom.getRecentConversation)
  .get('/:roomId', chadRoom.getConversationByRoomId)
  .post('/initiate', chadRoom.initiate)
  .post('/:roomId/message', chadRoom.postMessage)

module.exports = router;
