const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const eventSchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      default: () => uuidv4().replace(/\-/g, ""),
    },
    title: String,
    messageText: String,
    date: Date,
    participants: Array,
    eventCreator: {
      type: String,
      required: true
    },
  },
  {
    timestamps: true,
    collection: "events",
  }
);

eventSchema.statics.createEvent = async function (
  userIds, eventCreator, title,messageText, date
) {
  try {
    const participants = Array.from(new Set([...userIds, eventCreator]));

    const event = await this.create({ participants, eventCreator, title,messageText, date });
    return {
      event
    };
  } catch (error) {
    console.log('Error on create event method', error);
    throw error;
  }
};



eventSchema.statics.getEventById = async function (eventId) {
  try {
    const event = await this.findOne({ _id: eventId });
    return event;
  } catch (error) {
    throw error;
  }
};

eventSchema.statics.getEventsByUserId = async function (userId) {
  try {
    const events = await this.find({ participants: { $in: [userId] } });
    return events;
  } catch (error) {
    throw new Error(`Error fetching events by user ID: ${error.message}`);
  }
};

const Event = mongoose.model("Event", eventSchema);
module.exports = Event;
