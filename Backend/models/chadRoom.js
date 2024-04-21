const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");


const chadRoomSchema = new mongoose.Schema(
  {
    _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
    userIds: Array,
    chatInitiator: {
      type: String,
      required: true
    },
  },
  {
    timestamps: true,
    collection: "chatrooms",
  }
);

chadRoomSchema.statics.initiateChat = async function (
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


chadRoomSchema.statics.getChatRoomByRoomId = async function (roomId) {
  try {
    const room = await this.findOne({ _id: roomId });
    return room;
  } catch (error) {
    throw error;
  }
};

const chadRoom = mongoose.model("chadRoom", chadRoomSchema);
module.exports = chadRoom;

    