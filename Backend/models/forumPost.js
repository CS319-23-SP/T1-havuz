const mongoose = require("mongoose");
const { required } = require("nodemon/lib/config");
const { v4: uuidv4 } = require("uuid");


const forumPostSchema = new mongoose.Schema(
  {
    _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
    forumInitiator: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    initialPostId: {
      type: String,
      required: true
    }
    
  },
  {
    timestamps: true,
    collection: "forumposts",
  }
);

forumPostSchema.statics.initiateChat = async function (
  userIds, chatInitiator
) {
  try {
    const availableRoom = await this.findOne({
      userIds: {
        $size: userIds.length,
        $all: [...userIds],
      },
    });
    if (availableRoom) {
      return {
        isNew: false,
        message: 'retrieving an old chat room',
        chatRoomId: availableRoom._doc._id,
      };
    }

    const newRoom = await this.create({ userIds, chatInitiator });
    return {
      isNew: true,
      message: 'creating a new chatroom',
      chatRoomId: newRoom._doc._id,
    };
  } catch (error) {
    console.log('error on start chat method', error);
    throw error;
  }
};


forumPostSchema.statics.getChatRoomByRoomId = async function (roomId) {
  try {
    const room = await this.findOne({ _id: roomId });
    return room;
  } catch (error) {
    throw error;
  }
};

forumPostSchema.statics.getChatRoomsByUserId = async function (userId) {
  try {
    const rooms = await this.find({ userIds: { $in: [userId] } });
    return rooms;
  } catch (error) {
    throw new Error(`Error fetching chat rooms by user ID: ${error.message}`);
  }
};

module.exports = mongoose.model("forumPost", forumPostSchema);

    