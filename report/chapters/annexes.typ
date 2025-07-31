= Annexes
== Fichier JSON de configuration <annex-config-json>
```json
{
    "platforms": [
        {"image": "ground0", "x": 100, "y": 60, "idChall": "chall0", "urlChall":  ""},
        {"image": "ground1", "x": 200, "y": 60, "idChall": "chall1", "urlChall":  "./challenges/01_windows_login/windows_login.html"},
        {"image": "ground2", "x":300, "y": 60, "idChall": "chall2", "urlChall":  "./challenges/02_browser_history/browser_history.html"},
        {"image": "ground3", "x": 400, "y": 60, "idChall": "chall3", "urlChall":  "./challenges/03_same_color_text/index-01.html"},
        {"image": "ground4", "x": 500, "y": 60, "idChall": "chall4", "urlChall":  "./challenges/04_html_comment/comment.html"},
        {"image": "ground5", "x": 600, "y": 60, "idChall": "chall5", "urlChall":  "./challenges/05_admin_cookie/index.html"},
        {"image": "ground6", "x": 700, "y": 60, "idChall": "chall6", "urlChall":  "./challenges/06_caesar_cipher/cesar_data.html"},
        {"image": "ground7", "x": 800, "y": 60, "idChall": "chall7", "urlChall":  "./challenges/07_url_modification/gallery1.html"},
        {"image": "ground8", "x": 900, "y": 60, "idChall": "chall8", "urlChall":  "./challenges/08_SQL_injection/sql_injection.html"},
        {"image": "ground9", "x": 1000, "y": 60, "idChall": "chall9", "urlChall":  "./challenges/09_image_forensic/index.html"},
        {"image": "ground10", "x": 1100, "y": 60, "idChall": "chall10", "urlChall":  ""}
    ],
    "roads": [
        {"image":  "road", "x": 115, "y":  70}
    ],
    "invisible_grounds": [
        {"image":  "inv1", "x": 1, "y":  70}
    ],
    "hero": {"x": 100, "y": 50}
}

```

#pagebreak()

== API Express (index.js) <index.js>
```js
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
```
#pagebreak()

== Modèles Mongoose (db.js) <db.js>
```js
const mongoose = require('mongoose');
const assert = require('assert');
const {SHA3} = require('sha3');

// Connect to DB
mongoose.connect(`${process.env.MONGO_URI}/test`, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    auth: {
        user: process.env.MONGO_USER,
        password: process.env.MONGO_PASS
    },
    authSource: 'admin',
});
// Create models
const Flag = mongoose.model('Flag', {chall_name: String, value: String});
const User = mongoose.model('User', {
    uuid: String,
    name: String,
    surname: String,
    mail: String,
    flagged: [String]
});
const Visitor = mongoose.model('Visitor', {
    hour_timestamp: Number,
    ctr: Number
})


// Init flags from environment variables
async function initFlags() {
    const flags_2020 = process.env.CHALL_FLAGS_2020.split(';');

    for await (const flag of flags_2020) {
        const elem = flag.split('=');
        assert(elem.length === 2);
        const hash = new SHA3(256);
        hash.update(elem[1]);
        if (!(await Flag.exists({chall_name: "2020_"+elem[0]})))
            await Flag.create({chall_name: "2020_"+elem[0], value: hash.digest('hex')});
    }

    const flags_2021 = process.env.CHALL_FLAGS_2021.split(';');

    for await (const flag of flags_2021) {
        const elem = flag.split('=');
        assert(elem.length === 2);
        const hash = new SHA3(256);
        hash.update(elem[1]);
        if (!(await Flag.exists({chall_name: "2021_"+elem[0]})))
            await Flag.create({chall_name: "2021_"+elem[0], value: hash.digest('hex')});
    }
}

exports.init = initFlags;
exports.models = {flag: Flag, user: User, visitor:Visitor};
```

#pagebreak()

== Base MySQL (init.sql) <init.sql>
```sql
drop database IF EXISTS dday;

create database dday;

use dday;

create table users(
    ID varchar(50), 
    pass varchar(50) NOT NULL, 
    PRIMARY KEY (ID)
);

create table posts(
    ID int,
    img varchar(50),
    nameLastname varchar(50),
    datepost varchar(50),
    PRIMARY KEY (ID)
);

insert into users value ("admin@admin.ch", "Ws3drftgzh$bjnimkl");
insert into users value ("jean.dupont@truite.ch", "Pass1234.");
insert into users value ("sille.vinpas@sini.ch", "flopPl0pPlipPlop");
insert into users value ("Fort@fili.pnato", "Vive_Sha3");

insert into posts (ID,img,nameLastname,datepost) value (1,"./img/resto.jpg","zortak Nekmi", "29 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (2,"","brehuk cheunh", "25 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (3,"","bobo fatt", "30 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (4,"./img/vaisseau.png","raj raj sknib", "01 Novembre 2123");

insert into posts (ID,img,nameLastname,datepost) value (5,"","zinwhu", "06 Novembre 2123");

insert into posts (ID,img,nameLastname,datepost) value (6,"","zinwhu", "01 Novembre 2123");

insert into posts (ID,img,nameLastname,datepost) value (7,"","zinwhu", "27 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (8,"./img/resto2.jpg","zinwhu", "24 Octobre 2123");
```

#pagebreak()

== Présentation des challenges (ancienne version des défis) <présentation>
#image("../annexe/présentation_challenges (1)/présentation_challenges-1.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-2.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-3.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-4.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-5.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-6.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-7.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-8.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-9.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-10.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-11.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-12.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-13.svg", width: 95%)
#image("../annexe/présentation_challenges (1)/présentation_challenges-14.svg", width: 95%)
