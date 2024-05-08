const express = require('express');
const event = require('../controllers/event.js');

const router = express.Router();

router
  .post('/', event.createEvent)
  .get('/:eventId', event.getEventDetailstById)
  .get('/', event.getEventsByUserId)

module.exports = router;
