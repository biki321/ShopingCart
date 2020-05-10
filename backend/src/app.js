const express = require('express')
const authRoute = require('./routes/auth.js')
const mongoose = require('mongoose')
const dotenv = require('dotenv')
const bodyParser = require('body-parser')
const keys = require('./config/keys')

const app = express()
dotenv.config()

mongoose.connect(keys.MongoUrl,
    { useNewUrlParser: true ,useUnifiedTopology: true},)

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    console.log('connected to dataserver')
});    

//middlewares
app.use(bodyParser.json())   

app.use('/api/user', authRoute);
// app.use('/test', (req,res)=>{
//     console.log(req.body);
//     res.status(200);
// });



app.listen(3063)
