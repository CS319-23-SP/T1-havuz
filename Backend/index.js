const express = require("express");
const {connectToDb, getDb} = require("./db");
const { ObjectId } = require("mongodb");

const app = express();
app.use(express.json());

let db;
connectToDb((err) => {
    if(! err){
        app.listen(3000, () => {
            console.log("listen on port 3000, database connected");
        });
        db = getDb();
    }
});

app.get("/student", (req,res) => {
    let students = [];

    db.collection('db')
        .find()
        .sort({id: 1})
        .forEach(student => students.push(student))
        .then(() => {
            res.status(200).json(students);
        })
        .catch(() => {
            res.status(500).json({error: "Coudlnt fetch students"});
        })
});

app.get("/student/:id", (req, res) => {
    const id = parseInt(req.params.id);
    if (!isNaN(id) && Number.isInteger(id)) {
        db.collection('db')
            .findOne({ id: id })
            .then(student => {
                if (student) {
                    res.status(200).json(student);
                } else {
                    res.status(404).json({ error: 'Student not found' });
                }
            })
            .catch(err => {
                res.status(500).json({error: 'Couldnt fetch one student'});
            });
    } else {
        res.status(500).json({error: 'Not a valid id'});
    }

});

app.post('/student', (req, res) => {
    const student = req.body;

    db.collection('db')
        .findOne({ id: student.id })
        .then(existingStudent => {
            if (existingStudent) {
                res.status(400).json({ error: "Student with the ID exists" });
            } else {
                db.collection('db')
                    .insertOne(student)
                    .then(result => {
                        res.status(201).json(result);
                    })
                    .catch(error => {
                        res.status(500).json({ error: "Could not create new student" });
                    });
            }
        })
        .catch(error => {
            res.status(500).json({ error: "error checking for students" });
        });
});