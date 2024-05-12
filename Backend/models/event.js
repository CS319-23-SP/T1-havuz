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

const eventNotificationSchema = new mongoose.Schema(
  {
    title: String,
    date: Date,
    userId: String,
    isSeen: {
      type: Boolean,
      default: false 
    },
  },
  {
    timestamps: true,
    collection: "eventnotifications",
  }
);

eventNotificationSchema.statics.markAsSeen = async function(notificationId) {
  try {
    const notification = await this.findById(notificationId);
    if (!notification) {
      throw new Error("Notification not found");
    }
    notification.isSeen = true;
    await notification.save();
    return notification;
  } catch (error) {
    throw error;
  }
};

eventSchema.statics.createEvent = async function (
  userIds, eventCreator, title, messageText, date
) {
  try {
    const participants = Array.from(new Set([...userIds, eventCreator]));
    const event = await this.create({ participants, eventCreator, title, messageText, date });

    const notificationPromises = userIds.map(async (userId) => {
        try {
            const EventNotification = mongoose.model("EventNotification", eventNotificationSchema);
            const eventNotification = await EventNotification.create({ title, date, userId });
            console.log(`Event notification created for user ID ${userId}`);
            return eventNotification;
        } catch (notificationError) {
            console.log(`Error creating event notification for user ID ${userId}:`, notificationError);
            throw notificationError;
        }
    });

    await Promise.all(notificationPromises);

    return {
        event
    };
  } catch (error) {
    console.log('Error on create event method', error);
    throw error;
  }
};


eventNotificationSchema.statics.getEventNotificationsByUserId = async function(userId) {
  try {
    const notifications = await this.find({ userId });
    return notifications;
  } catch (error) {
    throw new Error(`Error fetching event notifications by user ID: ${error.message}`);
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
const EventNotification = mongoose.model("EventNotification", eventNotificationSchema);
module.exports = { Event, EventNotification };
