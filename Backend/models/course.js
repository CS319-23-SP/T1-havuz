const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const exam = require("./exam");

const courseSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          term: String,
          syllabus: String,
          department: String,
          coordinatorID: String,
          credits: String,
          sections: [String],
          exams: [String],
          finalgrades: {String: String}
    },
    {
        timestamps: true,
        collection: "courses",
    }
);

courseSchema.statics.createCourse = async function (id, term, department, coordinatorID, credits) {
    try {
        const course = await this.create({id, term, department, coordinatorID, credits});
        return course;
    } catch (error) {
        throw error;
    }
}

courseSchema.statics.getCourseByID = async function (id) {
    try {
        const course = await this.find({ id: id});
        if(!course) throw ({error: 'No course with this id found' });
        return course;
    } catch (error) {
        throw error;
    }
}

courseSchema.statics.getCourseByTerm = async function (term) {
    try {
        const course = await this.find({ term: term});
        if(!course) throw ({error: 'No course with this term found' });
        return course;
    } catch (error) {
        throw error;
    }
}

courseSchema.statics.getCourseByIDAndTerm = async function (id, term) {
    try {
        const course = await this.find({ id: id, term: term});
        if(!course) throw ({error: 'No course with this id and term found' });
        return course;
    } catch (error) {
        throw error;
    }
}

courseSchema.statics.getCourses = async function () {
    try {
      const courses = await this.find();
      return courses;
    } catch (error) {
      throw error;
    }
}

courseSchema.statics.deleteCourseByIDAndTerm = async function (id, term) {
    try {
      const result = await this.deleteOne({ id: id , term: term});
      return result;
    } catch (error) {
      throw error;
    }
}

courseSchema.statics.editCourseByIDAndTerm = async function (id, term, syllabus, department, coordinatorID, credits, sections, exams, finalgrades) {
    try {
        const course = await this.findOne({id: id, term: term});

        const courseUpdates = {
            syllabus: syllabus,
            department: department,
            coordinatorID: coordinatorID,
            credits: credits,
            sections: sections,
            exams: exams,
            finalgrades: finalgrades
        };

        const courseUpdated = await this.findOneAndUpdate(
            { id: id , term: term},
            { $set: courseUpdates },
            { new: true } 
        );

        console.log("ah");
        return courseUpdated;
    } catch (error) {
        throw error;
    }
}

module.exports = mongoose.model("Course", courseSchema);