const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const MESSAGE_TYPES = {
  TYPE_TEXT: "text",
};

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
      default: MESSAGE_TYPES.TYPE_TEXT,
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

forumReplySchema.statics.getForumRepliesByReplyID = async function (
  replyID,
  options = {}
) {
  try {
    const pipeline = [
      { $match: { replyID } },
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

/*forumReplySchema.statics.getAllRepliesOfReply = async function (replyId) {
  try {
    const initialReply = await this.findById(replyId);
    if (!initialReply) {
      throw new Error("Reply not found");
    }

    const allReplies = await this.find({ replyID: initialReply.replyID });

    const subReplies = allReplies.filter((reply) => {
      const isSubReply = reply.message?.parentReplyIdId === replyId;
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
};*/


forumReplySchema.statics.getDirectRepliesOfReply = async function (replyId) {
  try {
    //console.log(replyId)

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
