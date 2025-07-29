require('dotenv/config');
const cors = require('cors');
const express = require('express');
const cookieParser = require('cookie-parser')
const bodyParser = require('body-parser');
const {v4: uuidv4, validate: uuidValidate} = require('uuid');
const db = require('./db');
const {SHA3} = require('sha3');
const mailValidator = require("email-validator");
const mysql = require('mysql');
const seedrandom = require('seedrandom');
const jwt = require('jsonwebtoken');

const pool = mysql.createPool({
    connectionLimit: 10,
    host: "mysql",
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASS,
    charset: "utf8_general_ci",
    database: "dday"
});

const app = express();

// Configure middlewares
//app.use(cors({origin: "http://localhost:3000", credentials:true, allowedHeaders: "access-control-allow-origin,Origin,X-Requested-With,Content-Type,Accept"}));
app.use(cors({origin: "http://"+process.env.HOST_NAME, credentials:true, allowedHeaders: "access-control-allow-origin,Origin,X-Requested-With,Content-Type,Accept"}));
app.use(cookieParser());
app.use(bodyParser.json());

//app.options('*', cors({origin:"http://localhost:3000", credentials:true, allowedHeaders: "access-control-allow-origin,Origin,X-Requested-With,Content-Type,Accept"}))
app.options('*', cors({origin:"http://"+process.env.HOST_NAME, credentials:true, allowedHeaders: "access-control-allow-origin,Origin,X-Requested-With,Content-Type,Accept"}))

let urlencodedParser = bodyParser.urlencoded({extended: false})

function generateToken(TokenObject, secret, expiresIn) {
    return jwt.sign(TokenObject, secret, {expiresIn: expiresIn});
}

function checkToken(req, res, next) {
    const token = req.cookies.authtoken;
    jwt.verify(token, process.env.TOKEN_SECRET, (err, user) => {
        if (err || user === undefined) {
            console.log(`Session token is invalid or has expired for user`);
            return res.redirect("../login.html");
        }
        next();
    });
}

// Middleware to ensure a user cookie is set
app.use((req, res, next) => {
    // Check if the cookies contain a uuid, and copy it to the request if present, otherwise generate a new one, and add it to the response
    if (req.cookies.uuid && uuidValidate(req.cookies.uuid)) {
        // Cookie valid
        req.uuid = req.cookies.uuid;
		console.log("cookie valid");
        res.cookie('uuid', req.uuid, { maxAge: 30*24*60*60*1000, httpOnly: true})
    } else {
        // Missing or invalid cookie
		console.log("cookie invalid or missing");
        req.uuid = uuidv4();
        res.cookie('uuid', req.uuid, { maxAge: 30*24*60*60*1000, httpOnly: true})
    }

    next()
})

const VALID_YEARS = ["2020", "2021"]

// Submit a flag
app.post('/:year/flag', (req, res) => {
    if (!req.body.chall || !req.body.flag || !req.params.year || !VALID_YEARS.includes(req.params.year)) {
        return res.sendStatus(400);
    } else {
        const year = req.params.year;
        db.models.flag.findOne({chall_name: year + "_" + req.body.chall}, (err, flag) => {
            if (err || !flag)
                return res.sendStatus(404);

            const hash = new SHA3(256);
            hash.update(req.body.flag);
            // Check if flag matches
            if (hash.digest('hex') === flag.value) {
                console.log('valid flag');
                // Check if user exists
                db.models.user.findOne({uuid: req.uuid}, (err, person) => {
                    if (err) return res.send(err);

                    if (!person) {
                        console.log('new user');
                        db.models.user.create({uuid: req.uuid, flagged: [year + "_" + req.body.chall]}).then(() => {
                            return res.sendStatus(200);
                        }).catch((err) => {
                            return res.send(err);
                        });
                    } else {
                        console.log('existing user');
                        if (!person.flagged.includes(year + "_" + req.body.chall)) {
                            console.log('not flagged');
                            person.flagged.push(year + "_" + req.body.chall);
                            person.save().then(() => {
                                return res.sendStatus(200);
                            }).catch((err) => {
                                return res.send(err);
                            });
                        } else {
                            console.log('already flagged');
                            return res.sendStatus(200);
                        }
                    }
                });
            } else {
                console.log('invalid flag');
                return res.sendStatus(401);
            }
        });
    }
});

// Check a flag
app.post('/:year/checkFlag', (req, res) => {
    if (!req.body.chall || !req.body.flag || !req.params.year || !VALID_YEARS.includes(req.params.year)) {
        return res.sendStatus(400);
    } else {
        const year = req.params.year;
        db.models.flag.findOne({chall_name: year + "_" + req.body.chall}, (err, flag) => {
            if (err || !flag)
                return res.sendStatus(404);

            const hash = new SHA3(256);
            hash.update(req.body.flag);
            // Check if flag matches
            if (hash.digest('hex') === flag.value) {
                return res.sendStatus(200);
            } else {
                return res.sendStatus(401);
            }
        });
    }
});

// DB chall endpoint (2020 and 2021 chall)
app.post('/db', (req, res) => {
    if (!req.body.user || !req.body.pass) {
        return res.sendStatus(400);
    } else {
        pool.query("SELECT * FROM users where ID = '" + req.body.user + "' and pass = '" + req.body.pass + "';", function (err, results, fields) {
            if (err) {
                return res.send(err);
            } else {
                return res.send(results);
            }
        });
    }
});

// socialNetwork chall endpoint (2021 chall)
app.post('/db/search', (req, res) => {
    res.setHeader("Content-Type", "application/json; charset=utf-8");
    if (!req.body.search) {
        return res.sendStatus(400);
    }
    else if (req.body.search === "default"){
        console.log("return default search user request");
        let value = req.body.search;
        pool.query("SELECT * FROM posts LIMIT 5;", function (err, results, fields) {
            console.log(results);
            if (err) {
                return res.send(err);
            } else {
                return res.send(results);
            }
        });
    }
    else {
        console.log("return specific search user request");
        let value = req.body.search;
        let name = '';
        if(value.includes(' ')){
            name = value.split(' ')[0].toLowerCase();
        }
        else{
            name = value.toLowerCase();
        }
        pool.query("SELECT * FROM posts where nameLastname LIKE '%" + name + "%';", function (err, results, fields) {
            if (err) {
                return res.send(err);
            } else {
                return res.send(results);
            }
        });
    }
});

// Store username information
app.post('/user', (req, res) => {
    const secret_key = process.env.CAPTCHA_SECRET_KEY;
    const token = req.body.token;
   
    //axios({
    //    method: 'post',
    //    url: `https://www.google.com/recaptcha/api/siteverify?secret=${secret_key}&response=${token}`
    //})
    //.then(response => {
        if (//!response.data.success ||
            !req.body.name ||
            !req.body.surname ||
            !req.body.mail ||
            !mailValidator.validate(req.body.mail)) {
            return res.sendStatus(400);
        }
    
        // Check if user exists
        db.models.user.findOne({uuid: req.uuid}, (err, person) => {
            if (err) return res.send(err);
    
            if (!person){ 
                return res.sendStatus(401);
            }
    
            // Person exists, check if all flags have been solved
            db.models.flag.countDocuments({"chall_name" : {$regex : VALID_YEARS[VALID_YEARS.length-1]}}).then((count) => {
                // If the flagged amount is smaller than the amount of flags, unauthorised
                let yearly_flagged = person.flagged.filter(x =>x.startsWith(VALID_YEARS[VALID_YEARS.length-1]));
                if (yearly_flagged.length < count) {
                    return res.status(402).send(yearly_flagged.map(x => x.substring(VALID_YEARS[VALID_YEARS.length-1].length + 1)));
                }
    
                // Update the values of the person
                person.name = req.body.name;
                person.surname = req.body.surname;
                person.mail = req.body.mail;
                // save the person
                person.save().then(() => {
                    return res.sendStatus(200);
                }).catch((err) => {
                    return res.send(err);
                });
            });
        });
    //})
    //.catch(error => {
    //    return res.sendStatus(401);
    //});
});

// Store username information
app.get('/stats', (req, res) => {
    // retrieve all users
    db.models.user.find({}, (err, persons) => {
        if (err) return res.send(err);

        if (!persons){
            return res.sendStatus(401)
        }
        let result = [];
        for(let i = 0; i < persons.length; i++){
            let yearly_flagged = persons[i].flagged.filter(x =>x.startsWith(VALID_YEARS[VALID_YEARS.length-1])).length
            result.push(yearly_flagged);
        }
        res.send(result);

    });
});

app.post('/login', urlencodedParser, (req, res) => {
    const username = process.env.SHANA_USER;
    const password = process.env.SHANA_PASS;
    if(username === req.body.username && password === req.body.password){
        let authtoken = generateToken({
            mail: req.body.username
        }, process.env.TOKEN_SECRET, '10m');
        return res.cookie('authtoken', authtoken, {
            secure: true,
            httpOnly: true,
            sameSite: "lax" // lax option allows to send existing cookie to server by clicking on link from an external site
        }).redirect('../statistics.html');
    } else {
        return res.status(401).send();
    }
});

app.get('/logout', checkToken, (req, res) => {
    res.clearCookie('authtoken');
    res.status(200).send();
});

app.get('/stats/getEditions', checkToken, (req, res) => {
    // send editions years
    res.status(200).send(VALID_YEARS);
});

app.get('/stats/visitors', checkToken, (req, res) => {
    // retrieve all users
    db.models.visitor.find({}, (err, visitors) => {
        if (err) return res.send(err);
        if (!visitors){
            return res.sendStatus(401)
        }
        res.send(visitors.length.toString());
    });
});
app.get('/stats/finished', checkToken, (req, res) => {
    if(VALID_YEARS.includes(req.query.year)) {
        let numberChalls = 0;
        db.models.flag.find({}, (err, flags) => {
            if (err) return res.status(500).send(err);
            if (!flags){
                return res.sendStatus(401)
            }
            for(let i = 0; i < flags.length; i++){
                if(flags[i].chall_name.startsWith(req.query.year)){
                    numberChalls += 1;
                }
            }
        });
        // retrieve all users
        db.models.user.find({}, (err, persons) => {
            if (err) return res.status(500).send(err);

            if (!persons) {
                return res.sendStatus(401)
            }
            let yearly_flagged = 0;
            for (let i = 0; i < persons.length; i++) {
                if(persons[i].flagged.filter(x => x.startsWith(req.query.year)).length === numberChalls) {
                    yearly_flagged += 1
                }
            }
            return res.status(200).send(yearly_flagged.toString());
        });
    } else {
        return res.status(401).send();
    }
});

app.get('/stats/flagPerChall', checkToken, (req, res) => {
    if(VALID_YEARS.includes(req.query.year)) {
        let numberChalls = 0;
        db.models.flag.find({}, (err, flags) => {
            if (err) return res.status(500).send(err);
            if (!flags){
                return res.sendStatus(401)
            }
            for(let i = 0; i < flags.length; i++){
                if(flags[i].chall_name.startsWith(req.query.year)){
                    numberChalls += 1;
                }
            }
        });
        // retrieve users
        db.models.user.find({}, (err, persons) => {
            if (err) return res.status(500).send(err);
            if (!persons){
                return res.sendStatus(401)
            }
            let result = new Array(numberChalls).fill(0);
            for(let i = 0; i < persons.length; i++){
                let yearly_flagged = persons[i].flagged.filter(x =>x.startsWith(req.query.year)).length
                for (let j = 0; j < yearly_flagged; j++){
                    result[j] += 1;
                }
            }
            return res.status(200).send(result);
        });
    } else {
        return res.sendStatus(401);
    }
});

// Store username information
app.post('/visitor', (req, res) => {
    // retrieve current hour from timestamp (round down to the current hour)
    db.models.visitor.findOne({hour_timestamp: Math.floor(Date.now() / (1000 * 60 * 60 ))}, (err, visitors) => {
        console.log(visitors);
        if (err) return res.send(err);
        // If this is the first visitor, we create a new entry with the current hour with the integer 1
        if (!visitors){
            console.log("toto")
            db.models.visitor.create({hour_timestamp: Math.floor(Date.now() / (1000 * 60 * 60 )), ctr:1}).then(() => {
                return res.sendStatus(200);
            }).catch((err) => {
                return res.send(err);
            });
        }
        // Otherwise, increment the inner counter
        else {
            visitors.ctr += 1;
            visitors.save().then(() => {
                return res.sendStatus(200);
            }).catch((err) => {
                return res.send(err);
            });
        }
    });
});

app.get('/pin', (req, res) => {
	let seed = Math.floor(Date.now() / 60000) // Different seed every minute
	
	let rng = seedrandom(seed);
	return res.send({ pin: Math.floor(rng() * 10000) })
});

app.post('/pin', (req, res) => {
	let seed = Math.floor(Date.now() / 60000) // Different seed every minute
	
	let rng = seedrandom(seed);
	if (req.body.pin !== Math.floor(rng() * 10000)){
            return res.sendStatus(401);
	}
	let flag = process.env.CHALL_FLAGS_2021.split(';').filter((x) => x.startsWith('chall6'))[0].split('=')[1]
	return res.send(flag)
});


// Init DB connection, and then bind port
db.init().then(() =>
    app.listen(process.env.PORT, () =>
        console.log(`app listening on port ${process.env.PORT}!`)
    )
);
