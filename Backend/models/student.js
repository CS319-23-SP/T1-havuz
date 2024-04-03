const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const Auth = require('../models/auth');

const studentSchema = new mongoose.Schema(
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
          enteringYear: Number,
          coursesTaken: [String],
          advisorID: String,
          yearOfDeparture: Number,
          allTakenCourses: [[String,String,String,String]], // Term - Course - Section - Grade
          totalGrade: Number,
          totalCredits: Number
    },
    {
        timestamps: true,
        collection: "students",
    }
);

studentSchema.statics.createStudent = async function (firstName, middleName, lastName, department) {
    try {
        const lastStudent = await this.findOne().sort({ id: -1});
        let id;

        if (lastStudent) {
            const lastSequentialNumber = parseInt(lastStudent.id.substring(2));
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}${(lastSequentialNumber + 1).toString().padStart(6, '0')}`;
        } else {
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}000001`;
        }

        const enteringYear = new Date().getFullYear();

        const student = await this.create({id, firstName, middleName, lastName, department, enteringYear, totalGrade: 0, totalCredits: 0});
        const authResult = await Auth.create({id: id, password, role});
        return student, authResult;
    } catch (error) {
        throw error;
    }
}

studentSchema.statics.getStudentByID = async function (id) {
    try {
        const student = await this.findOne({ id: id});
        if(!student) throw ({error: 'No student with this id found' });
        return student;
    } catch (error) {
        throw error;
    }
}

studentSchema.statics.getStudents = async function () {
    try {
      const students = await this.find();
      return students;
    } catch (error) {
      throw error;
    }
}

studentSchema.statics.deleteStudentByID = async function (id) {
    try {
      const authResult = await Auth.deleteOne({id: id});
      const result = await this.deleteOne({ id: id });
      return authResult, result;
    } catch (error) {
      throw error;
    }
}

studentSchema.statics.editStudentByID = async function (id, firstName, middleName, lastName, department, coursesTaken, advisorID, 
                                                        yearOfDeparture, enteringYear, allTakenCourses, totalGrade, totalCredits) {
    try {
        const student = await this.findOne({id: id});
        const updatedAllTakenCourses = [...student.allTakenCourses, ...allTakenCourses];

        const studentUpdates = {
            id: id,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            department: department,
            coursesGiven: coursesGiven,
            coursesTaken: coursesTaken,
            advisorID: advisorID,
            enteringYear: enteringYear,
            yearOfDeparture: yearOfDeparture,
            totalGrade: totalGrade,
            totalCredits: totalCredits,
            allTimeCourses: updatedAllTakenCourses
        };

        const studentUpdated = await this.findOneandUpdateOne(
            { id: id },
            { $set: studentUpdates },
            { new: true } 
        );
        return studentUpdated;
    } catch (error) {
        throw error;
    }
}

module.exports = mongoose.model("Student", studentSchema);