const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const Auth = require('../models/auth');

const adminSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          firstName: String,
          middleName: String,
          lastName: String,
          title: String,
          enteringYear: Number,
          yearOfDeparture: Number
    },
    {
        timestamps: true,
        collection: "admins",
    }
);

adminSchema.statics.createAdmin = async function (firstName, middleName, lastName, title) {
    try {
        const lastAdmin = await this.findOne().sort({ id: -1});
        let id;

        if (lastAdmin) {
            const lastSequentialNumber = parseInt(lastAdmin.id.substring(2));
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}${(lastSequentialNumber + 1).toString().padStart(2, '0')}`;
        } else {
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}01`;
        }

        const enteringYear = new Date().getFullYear();

        const admin = await this.create({id, firstName, middleName, lastName, title, enteringYear});
        const authResult = await Auth.create({id, password:"1", role:"admin"});
        return admin, authResult;
    } catch (error) {
        throw error;
    }
}

adminSchema.statics.getAdminByID = async function (id) {
    try {
        const admin = await this.findOne({ id: id});
        if(!admin) throw ({error: 'No admin with this id found' });
        return admin;
    } catch (error) {
        throw error;
    }
}

adminSchema.statics.getAdmins = async function () {
    try {
      const admins = await this.find();
      return admins;
    } catch (error) {
      throw error;
    }
}

adminSchema.statics.deleteAdminByID = async function (id) {
    try {
      const authResult = await Auth.deleteOne({id: id});
      const result = await this.deleteOne({ id: id });
      return authResult, result;
    } catch (error) {
      throw error;
    }
}

adminSchema.statics.editAdminByID = async function (id, firstName, middleName, lastName, title, enteringYear, yearOfDeparture) {
    const adminUpdates = {
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        title: title,
        enteringYear: enteringYear,
        yearOfDeparture: yearOfDeparture
    };
    try {
        const existingAdmin = await this.findOne({id: id});

        if(existingAdmin){
            const admin = await this.findOneAndUpdate(
                { id: id },
                { $set: adminUpdates },
                { new: true } 
            );
            return admin;
        } else {
            res.status(404).json({ error: `Admin with the id: ${id} doesn't exist` });
        }
        
    } catch (error) {
        throw error;
    }
}
  
module.exports = mongoose.model("Admin", adminSchema);