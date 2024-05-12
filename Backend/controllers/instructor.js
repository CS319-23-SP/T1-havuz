const makeValidation = require('@withvoid/make-validation');
const instructorModel = require('../models/instructor');
const studentModel = require('../models/student');
const sectionModel = require('../models/section');
const Attendance = require("../models/attendance");

const onCreateInstructor = async (req, res) => {
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
    const instructor = await instructorModel.createInstructor(firstName, middleName, lastName, department);
    return res.status(200).json({ success: true, instructor });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
};

const onEditInstructorByID = async (req, res) => {
    try {
        const validation = makeValidation(types => ({
        payload: req.params,
        checks: {
            id: { type: types.string },
        }
        }));
        if (!validation.success) return res.status(400).json(validation);

        const {id} = req.params;
        const {firstName, middleName, lastName, department, coursesGiven, advisedStudents, enteringYear, yearOfDeparture, allTimeCourses} = req.body;
        const instructor = await instructorModel.editInstructorByID( id, firstName, middleName, lastName, department, coursesGiven, advisedStudents, enteringYear, yearOfDeparture, allTimeCourses);
        return res.status(200).json({ success: true, instructor });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onDeleteInstructorByID = async (req, res) => {
    try {
        const instructor = await instructorModel.deleteInstructorByID(req.params.id);
        if(instructor.deletedCount !== 0){
            return res.status(200).json({ 
                success: true, 
                message: `Deleted an instructor with ID ${req.params.id}.` 
            });
        } else {
            res.status(404).json({ error: "Instructor with id ${id} doesn't exist" });
        }
        
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetAllInstructors = async (req, res) => {
    try {
        const instructors = await instructorModel.getInstructors();
        return res.status(200).json({ success: true, instructors });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetInstructorByID = async (req, res) => {
    try {
        const instructor = await instructorModel.getInstructorByID(req.params.id);
        return res.status(200).json({ success: true, instructor });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onGiveAttendance = async (req, res) => {
    try {
      const validation = makeValidation((types) => ({
        payload: req.body,
        checks: {
          attendances: {
            type: types.array,
            optional: false,
            children: {
              studentID: { type: types.string },
              sectionID: { type: types.string },
              date: { type: types.date }, 
              hour: { type: types.boolean },
            },
          },
        },
      }));
  
      if (!validation.success) {
        return res.status(400).json({ success: false, error: "Invalid data" });
      }
      const { attendances } = req.body;
      const { term } = req.params;       
      for (const attendance of attendances) {
        const { studentID, sectionID, date, hour} = attendance;


        const attendanceDate = new Date(date);
        attendanceDate.setDate(attendanceDate.getDate()+1);
        const existingAttendance = await Attendance.findOne({
          studentID,
          sectionID,
          term,
          date: attendanceDate,
        });
  
        if (existingAttendance) {
          await Attendance.updateOne(
            { _id: existingAttendance._id },
            {
              $inc: {
                totalHour: 1,
                hour: hour ? 1 : 0, 
              },
            }
          );
        } else {
          await Attendance.create({
            studentID,
            sectionID,
            date: attendanceDate,
            hour: hour ? 1 : 0,
            totalHour: 1,
            term,
          });
        }
      }
  
      return res.status(200).json({ success: true, message: "Attendance updated successfully." });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  };  

  const onGetAttendance = async (req, res) => {
    try {
      const { studentID, sectionID } = req.body;

      console.log(req.body);
  
      if (!studentID || !sectionID) {
        return res.status(400).json({ success: false, error: "Missing studentID or sectionID in query parameters" });
      }
  
      const attendances = await Attendance.find({ studentID, sectionID });
  
      return res.status(200).json({ success: true, data: attendances });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  };

module.exports = {
    onCreateInstructor,
    onEditInstructorByID,
    onDeleteInstructorByID,
    onGetAllInstructors,
    onGetInstructorByID,
    onGiveAttendance,
    onGetAttendance
};