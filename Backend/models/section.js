const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const Assignment = require('../models/assignment');

const sectionSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          term: String,
          courseID: String,
          quota: String,
          students: [String],
          assignments: [String],
          midterm: [{
            studentID: String,
            grade: Number,
          }],
          final: [{
            studentID: String,
            grade: Number,
          }],
          instructorID: String,
          material: [String]
    },
    {
        timestamps: true,
        collection: "sections",
    }
);

sectionSchema.statics.createSection = async function (term, courseID, quota) {
    try {
        const lastSection = await this.findOne({term: term, courseID: courseID}).sort({ id: -1});
        let id;

        if (lastSection) {
            const lastSequentialNumber = parseInt(lastSection.id);
            id = `${(lastSequentialNumber + 1).toString().padStart(2, '0')}`;
        } else {
            id = `01`;
        }

        const section = await this.create({id, term, courseID, questions, deadline});
        return section;
    } catch (error) {
        throw error;
    }
}

sectionSchema.statics.getSection = async function (id, term, courseID) {
    try {
        const section = await this.find({ id: id, term: term, courseID: courseID});
        if(!section) throw ({error: 'No section with this id, term, or course ID found' });
        return section;
    } catch (error) {
        throw error;
    }
}

sectionSchema.statics.getSections = async function () {
    try {
        const sections = await this.find();
        return sections;
      } catch (error) {
        throw error;
      }
}

sectionSchema.statics.getSectionsbyTerm = async function (term) {
    try {
        const sections = await this.find({term: term});
        return sections;
      } catch (error) {
        throw error;
      }
}

sectionSchema.statics.deleteSection = async function (id, term, courseID) {
    try {
      const result = await this.deleteOne({ id: id, term: term, courseID: courseID});
      return result;
    } catch (error) {
      throw error;
    }
}
sectionSchema.statics.getSectionByIDAndTerm = async function (id, term) {
    try {
        const section = await this.find({
            $and: [
                { term: term },
                {
                    $or: [
                        { instructorID: id }, 
                        { students: { $in: [id] } }, 
                    ],
                },
            ],
        });        if(!section) throw ({error: 'No section with this id and term found' });
        return section;
    } catch (error) {
        throw error;
    }
}

sectionSchema.statics.editSection = async function (id, term, courseID, quota, students, assignments, instructorID, material) {
    try {
        const sectionUpdates = {
            quota: quota,
            students: students,
            assignments: assignments,
            instructorID: instructorID,
            material: material
        };

        const sectionUpdated = await this.findOneAndUpdate(
            { id: id, term: term, courseID: courseID},
            { $set: sectionUpdates },
            { new: true } 
        );

        console.log("ah");
        return sectionUpdated;
    } catch (error) {
        throw error;
    }
}

module.exports = mongoose.model("Section", sectionSchema);