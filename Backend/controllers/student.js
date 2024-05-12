const makeValidation = require('@withvoid/make-validation');
const studentModel = require('../models/student');
const Attendance = require("../models/attendance");
const Section = require("../models/section"); 

const onCreateStudent = async (req, res) => {
  try {
    const validation = makeValidation(types => ({
      payload: req.body,
      checks: {
        firstName: { type: types.string },
        lastName: { type: types.string },
        department: { type: types.string },
      }
    }));
    if (!validation.success) return res.status(400).json(validation);

    const { firstName, middleName, lastName, department} = req.body;
    const student = await studentModel.createStudent(firstName, middleName, lastName, department);
    return res.status(200).json({ success: true, student });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
};

const onEditStudentByID = async (req, res) => {
    try {
        const validation = makeValidation(types => ({
        payload: req.params,
        checks: {
            id: { type: types.string },
        }
        }));
        if (!validation.success) return res.status(400).json(validation);

        const {id} = req.params;
        const { firstName, middleName, lastName, department, coursesTaken, advisorID, 
            yearOfDeparture, enteringYear, allTakenCourses, totalGrade, totalCredits} = req.body;
        const student = await studentModel.editStudentByID( id, firstName, middleName, lastName, department, coursesTaken, advisorID, 
            yearOfDeparture, enteringYear, allTakenCourses, totalGrade, totalCredits);
        return res.status(200).json({ success: true, student });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onDeleteStudentByID = async (req, res) => {
    try {
        const student = await studentModel.deleteStudentByID(req.params.id);
        if(student.deletedCount !== 0){
            return res.status(200).json({ 
                success: true, 
                message: `Deleted a student with ID ${req.params.id}.` 
                });
        }
         else {
            res.status(404).json({ error: "Student with id ${req.params.id} doesn't exist" });
         }
        
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetAllStudents = async (req, res) => {
    try {
        const students = await studentModel.getStudents();
        return res.status(200).json({ success: true, students });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetStudentByID = async (req, res) => {
    try {
        const student = await studentModel.getStudentByID(req.params.id);
        return res.status(200).json({ success: true, student });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onGetStudentAttendance = async (req, res) => {
    try {
      const { studentID, term } = req.params; 
      const attendanceRecords = await Attendance.find({ studentID, term });
  
      if (!attendanceRecords || attendanceRecords.length === 0) {
        return res.status(404).json({ success: false, error: "No attendance records found for this student." });
      }
  
      return res.status(200).json({ success: true, attendance: attendanceRecords });
    } catch (error) {
      console.error("Error retrieving attendance:", error);
      return res.status(500).json({ success: false, error: "Failed to retrieve attendance." });
    }
  };

  const onGetSectionsByStudentID = async (req, res) => {
    try {
      const studentID = req.params.studentID;
  
      if (!studentID) {
        return res.status(400).json({ success: false, error: "Student ID is required" });
      }
  
      const term = "2024 Spring"; 
      const sections = await Section.find({
        students: studentID,
        term: term,
      });
  
      if (!sections || sections.length === 0) {
        return res.status(404).json({ success: false, error: "No sections found for this student ID" });
      }
  
      return res.status(200).json({ success: true, sections });
    } catch (error) {
      console.error("Error retrieving sections:", error);
      return res.status(500).json({ success: false, error: "Failed to retrieve sections" });
    }
  };

module.exports = {
    onCreateStudent,
    onEditStudentByID,
    onDeleteStudentByID,
    onGetAllStudents,
    onGetStudentByID,
    onGetStudentAttendance,
    onGetSectionsByStudentID
};