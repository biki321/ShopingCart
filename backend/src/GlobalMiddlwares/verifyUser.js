const jwt = require("jsonwebtoken");

//middleware to veify user
function verifyUser(req, res, next) {
  //getting the json web token fromo the client
  var str = req.get("Authorization");
  //console.log(`auth: ${str}`);
  if (str === "") {
    return res.status(401).json({ err: "you are not logged in" });
  }

  try {
    var payload = jwt.verify(str, process.env.TOKEN_SECRET);
    //console.log(payload);
    res.locals.payload = payload;
    next();
  } catch {
    return res.status(403).json({ err: "Bad Token" });
  }
}

module.exports = verifyUser;
