const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const MESSAGE_TYPES = {
  TYPE_TEXT: "text",
};

const forumReplySchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      default: uuidv4,
    },
    postId: {
      type: String,
      required: true,
    },
    message: mongoose.Schema.Types.Mixed,
    type: {
      type: String,
      default: MESSAGE_TYPES.TYPE_TEXT,
    },
    postedByUser: {
      type: String,
      required: true,
    },
    parentReply: {
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
  postId,
  message,
  postedByUser,
  parentReply,
) {
  try {
    const forumReply = await this.create({
      postId,
      message,
      postedByUser,
      parentReply, 
    });
    return forumReply;
  } catch (error) {
    throw error;
  }
};


forumReplySchema.statics.getForumRepliesByPostId = async function (
  postId,
  options = {}
) {
  try {
    const pipeline = [
      { $match: { postId } },
      { $sort: { createdAt: -1 } },
      {
        $lookup: {
          from: "auth",
          localField: "postedByUser",
          foreignField: "id",
          as: "postedByUser",
        },
      },
      { $unwind: "$postedByUser" },
      { $skip: options.page * options.limit },
      { $limit: options.limit },
      { $sort: { createdAt: 1 } },
    ];
    const forumReplies = await this.aggregate(pipeline);
    return forumReplies;
  } catch (error) {
    throw error;
  }
};



forumReplySchema.statics.getAllRepliesOfReply = async function (replyId) {
  try {
    // Fetch the initial reply
    const initialReply = await this.findById(replyId);
    if (!initialReply) {
      throw new Error("Reply not found");
    }

    const allReplies = await this.find({ postId: initialReply.postId });

    const subReplies = allReplies.filter((reply) => {
      const isSubReply = reply.message?.parentReplyId === replyId;
      return isSubReply;
    });

    const recursiveReplies = await Promise.all(
      subReplies.map(async (subReply) => {
        return this.getAllRepliesOfReply(subReply._id);
      })
    );

    const allReplyIds = [replyId, ...subReplies.map((reply) => reply._id)];
    const allRepliesFlat = allReplyIds.reduce((acc, id) => {
      const reply = allReplies.find((r) => r._id.equals(id));
      if (reply) {
        acc.push(reply);
      }
      return acc;
    }, []);

    return allRepliesFlat.concat(...recursiveReplies);
  } catch (error) {
    throw error;
  }
};


module.exports = mongoose.model("forumReply", forumReplySchema);
