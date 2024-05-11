const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const abetSchema = new mongoose.Schema(
  {    
    _id: {
    type: String,
    default: () => uuidv4().replace(/\-/g, ""),
  },
  sectionId: {
    type: String,
    required: true,
  },
    messageText: {
      type: String,
      required: true
    },
  },
  {
    timestamps: true,
    collection: "abets",
  }
);

abetSchema.statics.createAbet = async function (sectionId, messageText) {
  try {
    const abet = await this.create({
      sectionId,
      messageText, 
    });

    return abet;
  } catch (error) {
    throw error;
  }
};

abetSchema.statics.getAllAbetsBySectionId = async function (sectionId) {
  try {
    const abet = await this.findOne({sectionId });
    return abet;
  } catch (error) {
    throw error;
  }
};


module.exports = mongoose.model("abet", abetSchema);
