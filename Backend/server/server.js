const http = require("http");
const express = require("express");
const mogger = require("morgan");
const cors = require("cors");
const socketio = require("socket.io"); 
const roleChecker = require('../middlewares/roleChecker');

require("../.config/mongo");

const adminRouter = require("../routes/admin");
const authRouter = require("../routes/auth");
const instructorRouter = require("../routes/instructor");
const studentRouter = require("../routes/student");
const questionRouter = require("../routes/question");
const courseRouter = require("../routes/course");
const examRouter = require("../routes/exam");
const assignmentRouter = require("../routes/assignment");
const sectionRouter = require("../routes/section");
const chadRouter = require("../routes/chad");

const { decode } = require('../middlewares/jwt');

const app = express();

const port = process.env.PORT || "8080";
app.set("port", port);

app.use(mogger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());

app.use('/profiles', express.static('uploads'))

app.use("/admin", roleChecker(['admin']), decode, adminRouter);
app.use("/auth", authRouter);
app.use("/instructor", decode, instructorRouter);
app.use("/student", decode, studentRouter);
app.use("/question", decode, questionRouter);
app.use("/course", decode, courseRouter);
app.use("/exam", decode, examRouter);
app.use("/assignment", decode, assignmentRouter);
app.use("/section", decode, sectionRouter);
app.use("/chad", decode, chadRouter);

app.use('*', (req, res) => {
    return res.status(404).json({
      success: false,
      message: 'Endpoint doesnt exist'
    })
  });


const server = http.createServer(app);

//bilal's chat configs dont touch
const io = socketio(server);
global.io = io;
io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });

  socket.on('chat message', (msg) => {
    console.log('Message: ' + msg);
    io.emit('chat message', msg); 
  });
});


server.listen(port);
server.on("listening", () => {
  console.log(`Listening on port:: http://localhost:${port}/`);
});