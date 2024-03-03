const express = require("express");
const {connectToDb, getDb} = require("./db");
const { ObjectId } = require("mongodb");
const cors = require("cors");

const flutterurl = "http://localhost:50885";

const app = express();
app.use(express.json());

app.use(cors());

app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", flutterurl);
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, PATCH");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    next();
  });

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
    db.collection('student')
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
        db.collection('student')
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

    db.collection('student')
        .findOne({ id: student.id })
        .then(existingStudent => {
            if (existingStudent) {
                res.status(400).json({ error: "Student with the ID exists" });
            } else {
                db.collection('student')
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

app.delete(('/student/:id'), (req, res) => {
    const id = parseInt(req.params.id);
    if (!isNaN(id) && Number.isInteger(id)) {
        db.collection('student')
            .findOne({ id: id })
            .then(existingStudent => {
                if (existingStudent) {
                    db.collection('student')
                        .deleteOne({ id: id })
                        .then(result => {
                            res.status(200).json(result);
                        })
                        .catch(err => {
                            res.status(500).json({error: 'Couldnt delete the student'});
                        });
                } else {
                    res.status(404).json({ error: "Student with id doesnt exist" });
                }
            })
            .catch(err => {
                res.status(500).json({ error: 'Error finding the student' });
            });
    } else {
        res.status(400).json({error: 'Not a valid id'});
    }
});

app.patch('/student/:id', (req,res) => {
    const student = req.body;
    db.collection('student')
        .findOne({ id: student.id })
        .then(existingStudent => {
            if (existingStudent) {
                db.collection('student')
                .updateOne({id: student.id}, {$set: student})
                .then(result => {
                    res.status(200).json(result);
                })
                .catch(err => {
                    res.status(500).json({error: 'Couldnt update the document'});
                });
            } else {
                res.status(500).json({ error: "Student doesnt exists" });
            }
        })
        .catch(error => {
            res.status(500).json({ error: "error checking for students" });
        });
});

app.post('/admin', (req, res) => {
    const id = req.body.id;
    const enteredPassword = req.body.password;
    db.collection('admin')
        .findOne({id: id})
        .then(existingAdmin => {
            if(enteredPassword == existingAdmin.password)
                res.status(200).json("succesful adminim");
            else
                res.status(500).json("wrong password madmin");
        })
        .catch(error => {
            db.collection('student')
                .findOne({id: id})
                .then(existingStudent => {
                    if(enteredPassword == existingStudent.password)
                        res.status(201).json("succesfual studo");
                    else
                        res.status(501).json("bari şifreni unutma aw");
                })
                .catch(error => {
                    res.status(503).json({ error: "something went wrong trying to looking for account" });
                });
        });
});

app.patch('/changepassword', (req, res) => {
    const id = req.body.id;
    const newPassword = req.body.password;
    

    db.collection('admin')
        .findOne({id: id})
        .then(existingAdmin => {
            if(existingAdmin){
                db.collection('admin')
                    .updateOne({ id: id }, { $set: { password: newPassword } })
                    .then(result => {
                        res.status(200).json("Password of admin updated");
                })
            }
            else{
                db.collection('student')
                    .findOne({id: id})
                    .then(existingStudent => {
                        db.collection('student')
                            .updateOne({ id: id }, { $set: { password: newPassword } })
                            .then(result => {
                                res.status(200).json("Password of student updated");
                            })
                    })
                    .catch(error => {
                        res.status(503).json({ error: "something went wrong trying to looking for student" });
                    });
            }
        })
        .catch(error => {
                res.status(503).json({ error: "something went wrong trying to looking for admin" });
        });
});


module.exports = app;