const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const authSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          username: String,
          password: String,
          role: String,
    },
    {
        timestamps: true,
        collection: "auth",
    }
);

authSchema.statics.createAuth = async function (id, password, role) {
    try {
        const auth = await this.create({id, password, role});
        return auth;
    } catch (error) {
        throw error;
    }
}

authSchema.statics.getAuthById = async function (id) {
    try {
        const auth = await this.findOne({ _id: id});

        if(!auth) throw ({error: 'No user with this id found' });
        return auth;
    } catch (error) {
        throw error;
    }
}

authSchema.statics.getAuths = async function () {
    try {
      const auths = await this.find();
      return auths;
    } catch (error) {
      throw error;
    }
}

authSchema.statics.deleteAuthByID = async function (id) {
    try {
      const result = await this.deleteOne({ id: id });
      return result;
    } catch (error) {
      throw error;
    }
}

authSchema.statics.editAuthByID = async function (id, password, role) {
    const authUpdates = {
        id: id,
        password: password,
        role: role
    };
    try {
        const auth = await this.findOneandUpdate(
            { id: id },
            { $set: authUpdates },
            { new: true } 
        );
        return auth;
    } catch (error) {
        throw error;
    }
}
  
module.exports = mongoose.model("Auth", authSchema);