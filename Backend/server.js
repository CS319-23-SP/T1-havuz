const express = require("express");
//const cors = require("cors");

const mongoose = require('mongoose')
mongoose.connect("mongodb://localhost/havuzdb")
const db = mongoose.connection
db.on('error', (error) => console.log(error))
db.once('open', () => console.log('Database Connected'))

const app = express();
app.use(express.json());
const flutterurl = "http://localhost:50885";

app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", flutterurl);
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, PATCH");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    next();
  });

const studentsRoute = require('./routes/student');
app.use('/student', studentsRoute); 

const instructorsRoute = require('./routes/instructor');
app.use('/instructor', instructorsRoute); 

const adminsRoute = require('./routes/admin');
app.use('/admin', adminsRoute);

const questionRoute = require('./routes/question');
app.use('/question', questionRoute); 

const authRoute = require('./routes/auth');
app.use('/auth', authRoute); 


app.listen(8080, ()=> console.log('Server Started on port 8080'));


