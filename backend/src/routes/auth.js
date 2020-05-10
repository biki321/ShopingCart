const router = require('express').Router()
const User = require('../model/User')
const Joi = require('@hapi/joi')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const { registerValidation, loginValidation } = require('../helper/validation')

//REGISTRATION
router.post('/register', async (req, res) => {

    //validation of datalike email  password
    console.log('val check')
    const { error } = registerValidation(req.body);
    console.log('val check done')
    console.log(error)
    if (error) return res.status(400).send(error.details[0].message);

    //check if given email already exist 
    console.log('findone')
    const emailExist = await User.findOne({ email: req.body.email });
    console.log('findone done')
    if (emailExist) return res.status(400).send('Email already exist');

    console.log('User')
    const user = new User({
        name: req.body.name,
        email: req.body.email,
        password: req.body.password,
        //password: hashedpassword    
    });
    //user.password = hashedpassword;

    bcrypt.genSalt(10, function (err, salt) {
        if (err) throw err;
        bcrypt.hash(user.password, salt, function (err, hashedPassword) {
            if (err) throw err;
            //set normal password to hashed password
            user.password = hashedPassword;
            //save user to database
            user.save()
                .then(user => {
                    res.status(200).json({ user_id: user._id });
                }).catch(err => res.status(400).send(err));
        });
    });
})

//LOGIN
router.post('/login', async (req, res, next) => {
    //validation of datalike email  password
    // const { error } = loginValidation(req.body);
    // if (error) return res.status(400).send(error.details[0].message);

    //check if user exist
    const user = await User.findOne({ email: req.body.email });
    if (!user) return res.status(400).send('Email is wrong');

    //compare user entered password and password from 'user.password from database'   
    bcrypt.compare(req.body.password, user.password).then(result => {
        console.log(result);
        if (!result) return res.status(400).end("Invalid Password");
    }).catch(err => { throw err; });

    //create and assign a token
    const token = jwt.sign({ _id: user._id }, process.env.TOKEN_SECRET, {expiresIn: '15d'});
    res.send(token);

});

router.delete('/delete', (req, res, next) => {
    User.deleteMany({}, (err, result) => {
        if (err) {
            console.log(err); res.end({});
            res.end({ result: result });
        }

    });
    console.log('deleted');
});

router.get('/data', function(req, res) {
    var str = req.get('Authorization');
    try {
      jwt.verify(str, process.env.TOKEN_SECRET);
      res.send("Very Secret Data");
    } catch {
      res.status(401);
      res.send("Bad Token");
    }
  
  });

module.exports = router;
