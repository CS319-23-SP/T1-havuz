const http = require("http");
const express = require("express");
const logger = require("morgan");
const cors = require("cors");
const socketio = require("socket.io"); 

require("../.config/mongo");

const adminRouter = require("../routes/admin");
const authRouter = require("../routes/auth");
const instructorRouter = require("../routes/instructor");
const studentRouter = require("../routes/student");
const questionRouter = require("../routes/question");

const { decode } = require('../middlewares/jwt');

const app = express();

const port = process.env.PORT || "8080";
app.set("port", port);

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());

/*app.use("/admin", decode, adminRouter);
app.use("/auth", authRouter);
app.use("/instructor", decode, instructorRouter);
app.use("/student", decode, studentRouter);
app.use("/question", decode, questionRouter);*/

app.use("/admin", adminRouter);
app.use("/auth", authRouter);
app.use("/instructor", instructorRouter);
app.use("/student", studentRouter);
app.use("/question", questionRouter);

app.use('*', (req, res) => {
    return res.status(404).json({
      success: false,
      message: 'Endpoint doesnt exist'
    })
  });

const server = http.createServer(app);

server.listen(port);
server.on("listening", () => {
  console.log(`Listening on port:: http://localhost:${port}/`);
});

/*    DELETEEE
try {
    const admin = await adminModel.deleteAdminByID(req.params.id);
    if(admin.deletedCount !== 0){
      return res.status(200).json({ 
        success: true, 
        message: `Deleted an admin with ID ${req.params.id}.` 
      });
    } else {
      res.status(404).json({ error: "Admin with id ${id} doesn't exist" });
    }
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
 */

  /*    EDITTTTTTT
  const instructor = await this.findOne({id: id});
        var updatedAllTimeCourses = instructor.allTimeCourses;
        
        if (instructor && instructor.allTimeCourses && Array.isArray(instructor.allTimeCourses) &&
            allTimeCourses && Array.isArray(allTimeCourses)) {
            updatedAllTimeCourses = [...instructor.allTimeCourses, ...allTimeCourses];
        } 
  */