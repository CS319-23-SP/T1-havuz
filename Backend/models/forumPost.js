const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const forumPostSchema = new mongoose.Schema(
  {
    forumInitiator: {
      type: String,
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    initialReplyId: {
      type: String,
      default: uuidv4,
      unique: true, 
    },
  },
  {
    timestamps: true,
    collection: "forumposts",
  }
);

forumPostSchema.statics.createForumPost = async function (forumInitiator, title) {
  try {
    const forumPost = await this.create({
      forumInitiator,
      title,
    });
    return forumPost;
  } catch (error) {
    throw error;
  }
};

forumPostSchema.statics.getFirstReplyWithReplies = async function (postId) {
  try {
    const forumPost = await this.findById(postId);
    if (!forumPost) {
      throw new Error("Forum post not found");
    }

    const firstReply = await ForumReply.findOne({ replyID: forumPost.initialReplyId });

    if (!firstReply) {
      return [];
    }

    const directReplies = await ForumReply.getDirectRepliesOfReply(firstReply._id);

    return [firstReply, ...directReplies];
  } catch (error) {
    throw error;
  }
};


module.exports = mongoose.model("forumPost", forumPostSchema);
