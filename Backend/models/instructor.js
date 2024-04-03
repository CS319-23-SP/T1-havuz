const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const Auth = require('../models/auth');

const instructorSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          firstName: String,
          middleName: String,
          lastName: String,
          department: String,
          coursesGiven: [String],
          advisedStudents: [String],
          allTimeCourses: [[String,String,String]], // Term - Course - Section
          enteringYear: Number,
          yearOfDeparture: Number
    },
    {
        timestamps: true,
        collection: "instructors",
    }
);

instructorSchema.statics.createInstructor = async function (firstName, middleName, lastName, department) {
    try {
        const lastInstructor = await this.findOne().sort({ id: -1});
        let id;

        if (lastInstructor) {
            const lastSequentialNumber = parseInt(lastInstructor.id.substring(2));
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}${(lastSequentialNumber + 1).toString().padStart(4, '0')}`;
        } else {
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}0001`;
        }

        const enteringYear = new Date().getFullYear();

        const instructor = await this.create({id, firstName, middleName, lastName, department, enteringYear, yearOfDeparture: 0});
        const authResult = await Auth.create({id: id, password, role});
        return instructor, authResult;
    } catch (error) {
        throw error;
    }
}

instructorSchema.statics.getInstructorByID = async function (id) {
    try {
        const instructor = await this.findOne({ id: id});
        if(!instructor) throw ({error: 'No instructor with this id found' });
        return instructor;
    } catch (error) {
        throw error;
    }
}

instructorSchema.statics.getInstructors = async function () {
    try {
      const instructors = await this.find();
      return instructors;
    } catch (error) {
      throw error;
    }
}

instructorSchema.statics.deleteInstructorByID = async function (id) {
    try {
      const authResult = await Auth.deleteOne({id: id});
      const result = await this.deleteOne({ id: id });
      return authResult, result;
    } catch (error) {
      throw error;
    }
}

instructorSchema.statics.editInstructorByID = async function (id, firstName, middleName, lastName, department, coursesGiven, 
                                                                advisedStudents, enteringYear, yearOfDeparture, allTimeCourses) {
    try {
        const instructor = await this.findOne({id: id});
        const updatedAllTimeCourses = [...instructor.allTimeCourses, ...allTimeCourses];

        const instructorUpdates = {
            id: id,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            department: department,
            coursesGiven: coursesGiven,
            advisedStudents: advisedStudents,
            enteringYear: enteringYear,
            yearOfDeparture: yearOfDeparture,
            allTimeCourses: updatedAllTimeCourses
        };

        const instructorUpdated = await this.findOneandUpdateOne(
            { id: id },
            { $set: instructorUpdates },
            { new: true } 
        );
        return instructorUpdated;
    } catch (error) {
        throw error;
    }
}

module.exports = mongoose.model("Instructor", instructorSchema);