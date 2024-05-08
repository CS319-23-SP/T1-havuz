const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");



const forumReplySchema = new mongoose.Schema(
  {
    replyID: {
      type: String,
      default: uuidv4,
      unique: true,
    },
    message: mongoose.Schema.Types.Mixed,
    type: {
      type: String,
    },
    postedByUser: {
      type: String,
      required: true,
    },
    parentReplyId: {
      type: String, 
      required: true,
    },
  },
  {
    timestamps: true,
    collection: "forumreplies",
  }
);

forumReplySchema.statics.createForumReply = async function (
  message,
  postedByUser,
  replyID,
  parentReplyId,
) {
  try {
    const forumReply = await this.create({
      message,
      postedByUser,
      replyID,
      parentReplyId, 
    });
    return forumReply;
  } catch (error) {
    throw error;
  }
};

forumReplySchema.statics.createForumReply = async function (
  message,
  postedByUser,
  parentReplyId,
) {
  try {
    const forumReply = await this.create({
      message,
      postedByUser,
      parentReplyId, 
    });
    return forumReply;
  } catch (error) {
    throw error;
  }
};


forumReplySchema.statics.getDirectRepliesOfReply = async function (replyId) {
  try {

    const initialReply =  await this.findOne({ replyID: replyId });
    if (!initialReply) {
      throw new Error("Reply not foundd");
    }

    const directReplies = await this.find({ parentReplyId: replyId });
    if (!directReplies) {
      throw new Error("Reply does not seem to havea parent :D?");
    }

    return directReplies;
  } catch (error) {
    throw error;
  }
};

forumReplySchema.statics.findById = async function (replyId) {
  try {
    const reply = await this.findOne({ replyID: replyId });
    if (!reply) {
      throw new Error("Reply not found");
    }
    return reply;
  } catch (error) {
    throw error;
  }
};


module.exports = mongoose.model("forumReply", forumReplySchema);