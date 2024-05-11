const http = require("http");
const express = require("express");
const mogger = require("morgan");
const cors = require("cors");
const socketio = require("socket.io"); 
const WebSockets = require("../utils/WebSockets")
const roleChecker = require('../middlewares/roleChecker');
const bodyParser = require('body-parser');

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
const forumRouter = require("../routes/forum");
const fileRouter = require("../routes/fileHandler");
const eventRouter = require("../routes/event");
const evaluationRouter = require("../routes/evaluation");


const { decode } = require('../middlewares/jwt');

const app = express();

const port = process.env.PORT || "8080";
app.set("port", port);

app.use(mogger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

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
app.use("/forum", decode, forumRouter);
app.use("/document", fileRouter);
app.use("/event", decode, eventRouter);
app.use("/evaluation", decode, evaluationRouter);

app.use('*', (req, res) => {
    return res.status(404).json({
      success: false,
      message: 'Endpoint doesnt exist'
    })
  });


const server = http.createServer(app);

const io = socketio(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});
global.io = io;

WebSockets.init(io);


server.listen(port);
server.on("listening", () => {
  console.log(`Listening on port:: http://localhost:${port}/`);
});