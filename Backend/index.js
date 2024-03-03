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

});