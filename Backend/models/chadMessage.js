  const mongoose = require("mongoose");
  const { v4: uuidv4 } = require("uuid");

  const MESSAGE_TYPES = {
    TYPE_TEXT: "text",
  };


  const chadMessageSchema = new mongoose.Schema(
    {
      _id: {
        type: String,
        default: uuidv4,
      },
      chatRoomId: String,
      message: mongoose.Schema.Types.Mixed,
      type: {
        type: String,
        default: MESSAGE_TYPES.TYPE_TEXT,
      },
      postedByUser: {
        type: String,
        required: true
      },
    },
    {
      timestamps: true,
      collection: "chatmessages",
    }
  );

  chadMessageSchema.statics.createPostInChatRoom = async function (
    chatRoomId,
    message,
    postedByUser
  ) {
    try {
      const post = await this.create({
        chatRoomId,
        message,
        postedByUser,
        readByRecipients: { readByUserId: postedByUser },
      });
      const aggregate = await this.aggregate([
        { $match: { _id: post._id } },
        {
          $lookup: {
            from: "users",
            localField: "postedByUser",
            foreignField: "_id",
            as: "postedByUser",
          },
        },
        { $unwind: "$postedByUser" },
        {
          $lookup: {
            from: "chatrooms",
            localField: "chatRoomId",
            foreignField: "_id",
            as: "chatRoomInfo",
          },
        },
        { $unwind: "$chatRoomInfo" },
        { $unwind: "$chatRoomInfo.userIds" },
        {
          $lookup: {
            from: "users",
            localField: "chatRoomInfo.userIds",
            foreignField: "_id",
            as: "chatRoomInfo.userProfile",
          },
        },
        { $unwind: "$chatRoomInfo.userProfile" },
        {
          $group: {
            _id: "$chatRoomInfo._id",
            postId: { $last: "$_id" },
            chatRoomId: { $last: "$chatRoomInfo._id" },
            message: { $last: "$message" },
            type: { $last: "$type" },
            postedByUser: { $last: "$postedByUser" },
            chatRoomInfo: { $addToSet: "$chatRoomInfo.userProfile" },
            createdAt: { $last: "$createdAt" },
            updatedAt: { $last: "$updatedAt" },
          },
        },
      ]);
      return aggregate[0];
    } catch (error) {
      throw error;
    }
  };

  chadMessageSchema.statics.getConversationByRoomId = async function (chatRoomId, options = {}) {
    try {
        const pipeline = [
            { $match: { chatRoomId } }, 
            { $sort: { createdAt: -1 } },
          {
                $lookup: {
                    from: 'auth',
                    localField: 'postedByUser',
                    foreignField: 'id',
                    as: 'postedByUser',
                }
            },
            { $unwind: "$postedByUser" },
            { $skip: options.page * options.limit },
            { $limit: options.limit },
            { $sort: { createdAt: 1 } },
        ];
        const messages = await this.aggregate(pipeline);
        console.log(messages)

        return messages;
    } catch (error) {
        throw error;
    }
  };


  module.exports = mongoose.model("chadMessage", chadMessageSchema);
