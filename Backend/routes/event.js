const express = require('express');
const event = require('../controllers/event.js');

const router = express.Router();

router
  .post('/', event.createEvent)
  .get('/details/:eventId', event.getEventDetailstById)
  .get('/:userId', event.getEventsByUserId)
  .get('/notifications/:userId', event.getEventNotificationsByUserId)
  .post('/:notificationId', event.markNotificationAsSeen);

module.exports = router;
