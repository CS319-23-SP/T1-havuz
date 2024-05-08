const makeValidation = require('@withvoid/make-validation');
const Event = require('../models/event');

const createEvent = async (req, res) => {
  try {
    const { userIds, eventCreator, title, date } = req.body;
    console.log(userIds, eventCreator, title, date);
    const result = await Event.createEvent(userIds, eventCreator, title, date);
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getEventDetailstById = async (req, res) => {
  try {
    const eventId = req.params.id;
    const event = await Event.getEventById(eventId);
    if (!event) {
      return res.status(404).json({ message: 'Event not found' });
    }
    res.json(event);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getEventsByUserId = async (req, res) => {
  try {
    const userId = req.params.userId;
    const events = await Event.getEventsByUserId(userId);
    res.json(events);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createEvent,
  getEventDetailstById,
  getEventsByUserId,
};
