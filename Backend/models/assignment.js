const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const assignmentSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          term: String,
          sectionID: String,
          deadline: String,
          solutionKey: String,
          questions: [String],
          grades: [{String: String}]
    },
    {
        timestamps: true,
        collection: "assignments",
    }
);

assignmentSchema.statics.createAssignment = async function (term, sectionID, questions, deadline) {
    try {
        const lastAssignment = await this.findOne({term: term, sectionID: sectionID}).sort({ id: -1});
        let id;

        if (lastAssignment) {
            const lastSequentialNumber = parseInt(lastAssignment.id);
            id = `${(lastSequentialNumber + 1).toString().padStart(2, '0')}`;
        } else {
            id = `01`;
        }

        const assignment = await this.create({id, term, sectionID, questions, deadline});
        return assignment;
    } catch (error) {
        throw error;
    }
}

assignmentSchema.statics.getAssignment = async function (id, term, sectionID) {
    try {
        const assignment = await this.find({ id: id, term: term, sectionID: sectionID});
        if(!assignment) throw ({error: 'No assignment with this id, term, or section ID found' });
        return assignment;
    } catch (error) {
        throw error;
    }
}

assignmentSchema.statics.getAssignments = async function () {
    try {
        const assignments = await this.find();
        return assignments;
      } catch (error) {
        throw error;
      }
}

assignmentSchema.statics.deleteAssignment = async function (id, term, sectionID) {
    try {
      const result = await this.deleteOne({ id: id, term: term, sectionID: sectionID});
      return result;
    } catch (error) {
      throw error;
    }
}

assignmentSchema.statics.editAssignment = async function (id, term, sectionID, questions, deadline, grades, solutionKey) {
    try {
        const assignmentUpdates = {
            questions: questions,
            grades: grades,
            deadline: deadline,
            solutionKey: solutionKey
        };

        const assignmentUpdated = await this.findOneAndUpdate(
            { id: id, term: term, sectionID: sectionID},
            { $set: assignmentUpdates },
            { new: true } 
        );

        console.log("ah");
        return assignmentUpdated;
    } catch (error) {
        throw error;
    }
}

module.exports = mongoose.model("Assignment", assignmentSchema);