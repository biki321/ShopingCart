const router = require('express').Router()
const User = require('../model/User')
const Joi = require('@hapi/joi')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const { registerValidation, loginValidation } = require('../helper/validation')
const createCartEventEmitter = require('../events/createCart');

//REGISTRATION
router.post('/register', async (req, res) => {

    //validation of datalike email  password   
    const { error } = registerValidation(req.body);
    if (error) return res.status(400).json({ err: error.details[0].message });

    //check if given email already exist 
    const emailExist = await User.findOne({ email: req.body.email });
    if (emailExist) return res.status(400).json({ err: 'Email already exist' });

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
                    res.status(200).json({ success: 'SignedUp Successfully' });  
                    
                    //this emitter will emit event to create a cart for user_id
                    createCartEventEmitter.emit('createCart', user._id);                

                }).catch((err) => {
                    res.status(400).json({ err: 'Some Problem' });
                    throw err;
                }
                );
        });
    });
})

//LOGIN
router.post('/login', async (req, res, next) => {
    //validation of datalike email  password
    // const { error } = loginValidation(req.body);
    // if (error) return res.status(400).send(error.details[0].message);

    //check if user exist
    try {        
        const user = await User.findOne({ email: req.body.email });
        if (!user) return res.status(400).json({ err: 'Email is wrong' });

        //matching password
        const match = await bcrypt.compare(req.body.password, user.password);
        if (match) {                  
            const token = jwt.sign({ user_id: user._id }, process.env.TOKEN_SECRET, { expiresIn: '15d' });            
            return res.status(200).header('jwt', token).json({ success: 'Logined In' });

        } else {
            res.status(400).json({ err: "Wrong password" });
        }
    } catch{
        error => {
            throw error;
        }
    }



});

router.delete('/delete', (req, res, next) => {
    User.deleteMany({}, (err, result) => {
        if (err) {
            console.log(err); res.end({});
        }});
    console.log('deleted');
    res.end({ result: result });
});

router.get('/data', function (req, res) {
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
