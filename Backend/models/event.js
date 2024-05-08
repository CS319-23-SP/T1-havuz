const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const eventSchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      default: () => uuidv4().replace(/\-/g, ""),
    },
    title: String,
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
  userIds, eventCreator, title, date
) {
  try {
    const oldEvent = await this.findOne({
      userIds: {
        $size: userIds.length,
        $all: [...userIds],
      },
    });
    if (oldEvent) {
      return {
        isNew: false,
        message: 'retrieving an old event',
        EventId: oldEvent._doc._id,
      };
    }

    const newEvent = await this.create({ userIds, eventCreator, title, date });
    return {
      isNew: true,
      message: 'creating a new  event',
      EventId: newEvent._doc._id,
    };
  } catch (error) {
    console.log('error on create event method', error);
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
    const events = await this.find({ userIds: { $in: [userId] } });
    return events;
  } catch (error) {
    throw new Error(`Error fetching events by user ID: ${error.message}`);
  }
};

const Event = mongoose.model("Event", eventSchema);
module.exports = Event;
