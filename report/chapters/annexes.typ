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

== API Express (`index.js`) <index.js>
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

== Modèles Mongoose (`db.js`) <db.js>
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

== Base MySQL (`init.sql`) <init.sql>
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
== Docker Compose (`docker-compose.yml`) <docker-compose.yml>
```yaml
services:
  # Traefik reverse proxy
  traefik:
    image: "traefik:v2.10"
    restart: always
    command:
      - "--api.dashboard=false"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      # Global redirection to https
      - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      - "--entrypoints.websecure.address=:443"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
  # Flagger + main backend
  backend:
    build: .
    environment:
      MONGO_URI: mongodb://mongo:27017
      WAIT_HOSTS: mysql:3306, mongo:27017
    restart: always
    volumes:
      - "./:/app"
      - "/app/node_modules"
    labels:
      # Expose the container in the traefik web UI
      - "traefik.enable=true"
      # Match rule to forward backend service
      - "traefik.http.routers.backend.rule=${HOST_RULE} && PathPrefix(`/backend`)"
      - "traefik.http.routers.backend.middlewares=backend-stripprefix"
      - "traefik.http.middlewares.backend-stripprefix.stripprefix.prefixes=/backend"
      - "traefik.http.routers.backend.priority=100"
      # Enable TLS
      - "traefik.http.routers.backend.tls=true"
      # Bound port for backend service
      - "traefik.http.services.backend.loadbalancer.server.port=${PORT}"
  # frontend
  frontend:
    build:
      context: ../DigitalDay_APP
      dockerfile: Dockerfile
    restart: always
    volumes:
      - "../DigitalDay_APP:/DigitalDay_APP"

    labels:
      # Expose the container in the traefik web UI
      - "traefik.enable=true"
      # Match rule to forward frontend service
      - "traefik.http.routers.frontend.rule=${HOST_RULE}"
      - "traefik.http.routers.frontend.priority=10"
      # Enable TLS
      - "traefik.http.routers.frontend.tls=true"
      # Bound port for frontend service
      - "traefik.http.services.frontend.loadbalancer.server.port=${PORT_FRONT}"
  # webssh
  webssh:
    build:
      context: .
      dockerfile: Dockerfile_ssh
    restart: always
    labels:
      # Expose the container in the traefik web UI
      - "traefik.enable=true"
      # Match rule to forward ssh service
      - "traefik.http.routers.webssh.rule=${HOST_RULE} && (PathPrefix(`/ssh`) || PathPrefix(`/static`))"
      - "traefik.http.routers.webssh.middlewares=webssh-stripprefix"
      - "traefik.http.middlewares.webssh-stripprefix.stripprefix.prefixes=/ssh"
      - "traefik.http.routers.webssh.priority=110"
      # Enable TLS
      - "traefik.http.routers.webssh.tls=true"
      # Bound port for frontend service
      - "traefik.http.services.webssh.loadbalancer.server.port=${PORT_SSH}"
  # SSH container
  sshmachine:
    build:
      context: ../docker-ssh
      dockerfile: Dockerfile
    restart: always
  # SSH container forensic 2021
  sshmachine-galactic-forensic:
    build:
      context: ../docker-ssh-galactic-forensic
      dockerfile: Dockerfile
    restart: always
  # SSH container for whois
  sshmachine-whois:
    build:
      context: ../docker-ssh-whois
      dockerfile: Dockerfile
    restart: always
  # Backend DB
  mongo:
    image: mongo:4.4.1
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASS}
# Uncomment to connect to db with MongoDBCompass
#    ports:
#      - 42069:27017
    volumes:
      - "./mongo/:/data/db/"
  # exposed MySQL server
  mysql:
    image: mysql:5
    restart: always
    environment:
      MYSQL_DATABASE: dday
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASS}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT}
      MYSQL_ROOT_HOST: mysql
    volumes:
      - ./mysql/init.sql:/docker-entrypoint-initdb.d/init.sql
```
#pagebreak()

== Implémentation du jeu "Intrusion" (`blackoutmain.js`) <blackoutmain.js>
```js
//BLACKOUT 2025
PlayState = {};

//Const variables for cookie name
const cookieName_currentChall = "bk2025_xH92f_curr";
const cookieName_allChall = "bk2025_mP81x_all";
//URL to backend
const url_backend_flag_request = "/backend/2025/flag";
const url_backend_SQL = "";

// load game fonts here
PlayState.preload = function () {
  //Plugins
  this.game.add.plugin(PhaserInput.Plugin);
  //backgrounds
  this.game.load.image("background", "images/background-black.png");

  //levels datas
  this.game.load.json("level:1", "data/level01Blackout.json");

  //plateforms for Blackout 2025
  this.game.load.image("ground0", "images/redZone.png");
  this.game.load.image("ground1", "images/redZone.png");
  this.game.load.image("ground2", "images/redZone.png");
  this.game.load.image("ground3", "images/redZone.png");
  this.game.load.image("ground4", "images/redZone.png");
  this.game.load.image("ground5", "images/redZone.png");
  this.game.load.image("ground6", "images/redZone.png");
  this.game.load.image("ground7", "images/redZone.png");
  this.game.load.image("ground8", "images/redZone.png");

  //texture for plateform when accessible
  this.game.load.image("finishGround", "images/greenZone.png");
  //invisible ground
  this.game.load.image("inv1", "images/ground.png");
      //hero
    this.game.load.spritesheet('hero', 'images/herov4.png', 27, 50);

};

PlayState.init = function () {
    this.game.renderer.renderSession.roundPixels = true;
};

/////////////////////////////////////////////////////////////////////////
//  HERO
/////////////////////////////////////////////////////////////////////////

function Hero(game, x, y) {
    Phaser.Sprite.call(this, game, x, y, 'hero');
    this.anchor.set(0, 0.5);
    this.game.physics.enable(this);
    this.body.collideWorldBounds = true;
    this.positionx = x;
    this.direction = 1;
    this.accessibleChall = new Set();

    this.animations.add('stop', [0]);
    this.animations.add('run', [0, 1, 2, 3, 4, 5, 6], 8, true); // 8fps looped
}

// inherit from Phaser.Sprite
Hero.prototype = Object.create(Phaser.Sprite.prototype);
Hero.prototype.constructor = Hero;
Hero.prototype.move = function (direction) {
        const SPEED = 300;
        this.body.velocity.x = direction * SPEED;
        if (this.body.velocity.x < 0) {
            this.scale.x = -1;
        } else if (this.body.velocity.x > 0) {
            this.scale.x = 1;
        }
};
Hero.prototype._getAnimationName = function () {
    let name = 'stop'; // default animation

    if (this.body.velocity.x !== 0) {
        name = 'run';
    }
    return name;
};
Hero.prototype.update = function () {
    // update sprite animation, if it needs changing
    let animationName = this._getAnimationName();
    if (this.animations.name !== animationName) {
        this.animations.play(animationName);
    }
};


/////////////////////////////////////////////////////////////////////////
//  load and spawn methodes to create sprites, background ...
/////////////////////////////////////////////////////////////////////////

//create game entities and set up world here
PlayState.create = function () {
  this.game.add.image(0, 0, "background");
  this.data = this.game.cache.getJSON("level:1");
  this._loadLevel(this.data);
  //mouse pointer position
  this.game.pointerX = null;
};

PlayState._loadLevel = function (data) {
  // create all the groups/layers that we need
  this.platforms = this.game.add.group();
  this.invisible_grounds = this.game.add.group();

  //spawn all plateforms
  data.platforms.forEach(this._spawnPlateform, this);
  data.invisible_grounds.forEach(this._spawninvisibleGround, this);
  // spawn hero and enemies
  this._spawnCharacters({ hero: data.hero });
  const GRAVITY = 1200;
  this.game.physics.arcade.gravity.y = GRAVITY;

  // define submit hint button
  submitBtn = document.getElementById("sumbitHint");
  submitBtn.onclick = function () {
    //VERIFY SI OK OR NOT //
    let currentChall = getCookie(cookieName_currentChall);
    let flag = document.getElementById("inputHint").value;
    flag = flag.replace(/ /g, "");
    flag = flag.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    let msgBox = "";
    if (flag === "") {
      msgBox = "Veuillez remplir le champ de réponse avant de valider !";
      showPopupValidation();
    } else {
      //send request
      let content = {
        chall: currentChall,
        flag: flag.toLowerCase(),
      };
      console.log(content);
      let contentJson = JSON.stringify(content);
      var xhr = new XMLHttpRequest();

      xhr.open("POST", url_backend_flag_request, true);
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.withCredentials = true;

      xhr.onreadystatechange = function () {
        //Appelle une fonction au changement d'état.
        if (this.readyState === XMLHttpRequest.DONE) {
          if (this.status === 200) {
            //if chall resolved, adding challenge and the next(updatePlateform) to the accessible challenges
            PlayState.hero.accessibleChall.add(currentChall);
            updatePlatform(currentChall);
            document.getElementById("inputHint").value = "";
            msgBox =
              "Bravo ! Vous avez résolu une étape, passez à la suivante !";
          }
          if (this.status === 404) {
            //bad challenge name
            msgBox =
              "Hum... une erreur étrange à eu lieu, recharge le site web et recommence !";
          }
          if (this.status === 401) {
            //bad challenge flag
            msgBox = "Dommage, ce n'est pas la bonne réponse, persévère !";
          }
          showPopupValidation();
        }
      };
      xhr.send(contentJson);
    }

    function showPopupValidation() {
      var popup = document.getElementById("popupSubmitChall");
      var contentText = document.getElementById("popupSubmitChallContent");
      contentText.innerText = msgBox;
      popup.style.display = "block";
      closeBtn = document.getElementById("popupSubmitChallCloseButton");
      closeBtn.onclick = function () {
        popup.style.display = "none";
      };
      continueBtn = document.getElementById("popupSubmitChallContinue");
      continueBtn.onclick = function () {
        popup.style.display = "none";
      };
    }
  };
  // if the user has never started a challenge, load popup Intro on restart page
  let currentChall = getCookie(cookieName_currentChall);
  if (currentChall === null || currentChall === "chall0") {
    spawnPopup("chall0");
  }

  // on page restart, load the iframe for the last challenge started.
  var urlChall = null;
  data.platforms.forEach((p) => {
    if (p.idChall === currentChall) {
      urlChall = p.urlChall;
    }
  });
  loadIframe(currentChall, urlChall);

  // on page restart, get list of accessible challenge (or finished) to apply the right platform.
  let accessibleChall = getCookie(cookieName_allChall);
  if (accessibleChall != null) {
    PlayState.hero.accessibleChall = new Set(JSON.parse(accessibleChall));
    updatePlatform();
  }
};

PlayState._spawnPlateform = function (platform) {
  let sprite = this.platforms.create(platform.x, platform.y, platform.image);
  sprite.inputEnabled = true;
  sprite.idChall = platform.idChall;
  sprite.urlChall = platform.urlChall;
  sprite.IsAccess = platform.IsAccess;
  sprite.events.onInputDown.add(onclickPlateform, this);

  //on click on a platform, set mouse pointer position to platform position then show the link popup
  function onclickPlateform(plateform) {
    if (PlayState.hero.accessibleChall.has(plateform.idChall)) {
      this.game.pointerX = plateform.position.x;
      spawnPopup(plateform.idChall, plateform.urlChall);
    }
  }
};

PlayState._spawninvisibleGround = function (block) {
  let sprite = this.invisible_grounds.create(block.x, block.y, block.image);
  this.game.physics.enable(sprite);
  sprite.body.immovable = true;
  sprite.body.allowGravity = false;
  sprite.visible = false;
};

PlayState._spawnCharacters = function (data) {
  // spawn hero
  this.hero = new Hero(this.game, data.hero.x, data.hero.y);
  this.hero.body.allowGravity = false;
  this.game.add.existing(this.hero);
};

PlayState._handleCollisions = function () {
  this.game.physics.arcade.collide(this.hero, this.invisible_grounds);
};

/////////////////////////////////////////////////////////////////////////
//  game engine
////////////////////////////////////////////////////////////////////////

PlayState.update = function () {
  this._handleCollisions();

  // move character where the mouse pointer click (on platform)
  if (this.game.pointerX != null) {
    if (
      this.hero.direction === -1 &&
      this.hero.positionx < this.game.pointerX
    ) {
      this.hero.direction = 1;
    }
    if (this.hero.direction === 1 && this.hero.positionx > this.game.pointerX) {
      this.hero.direction = -1;
    }
    this.hero.move(this.hero.direction);

    var stop = false;
    //  if it's overlapping the mouse, don't move any more
    if (
      this.hero.direction === -1 &&
      this.hero.world.x <= this.game.pointerX + 30
    ) {
      stop = true;
    }
    if (this.hero.direction === 1 && this.hero.world.x >= this.game.pointerX) {
      stop = true;
    }
    if (stop) {
      this.hero.body.velocity.setTo(0, 0);
      this.hero.positionx = this.game.pointerX;
    }
  } else {
    this.hero.body.velocity.setTo(0, 0);
  }
};

window.onload = function () {
  // Check for mobile user agent
  var mobile =
    /iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(
      navigator.userAgent.toLowerCase()
    );
  var istablet =
    /ipad|android|android 3.0|xoom|sch-i800|playbook|tablet|kindle/i.test(
      navigator.userAgent.toLowerCase()
    );
  var IsIE10 = /MSIE 10/i.test(navigator.userAgent);
  var IsIE9 = /MSIE 9/i.test(navigator.userAgent);
  var isIE11 = /rv:11.0/i.test(navigator.userAgent);
  var isEdge = /Edge\/\d./i.test(navigator.userAgent);
  if (mobile || istablet) {
    alert(
      "Ce jeu d'ethical hacking est fait pour ordinateur et non pas téléphone."
    );
  }
  if (isIE11 || IsIE10 || IsIE9 || isEdge) {
    alert(
      "Nous conseillons l'utilisation des navigateurs Google Chorme ou Firefox pour le bon fonctionnement du jeu. Vous pouvez les installer facilement via une simple recherche Internet."
    );
  }
  let game = new Phaser.Game(1400, 100, Phaser.AUTO, "game");
  game.state.add("play", PlayState);
  game.state.start("play");
};

/////////////////////////////////////////////////////////////////////////
//  game internal function
////////////////////////////////////////////////////////////////////////

function updatePlatform(currentChall) {
  if (currentChall != null) {
    // extract number of the current chall (7 from chall7) and define next accessible challenge
    let matches = currentChall.match(/\d+/g);
    let nextchall = parseInt(matches[0]) + 1;
    nextchall = "chall" + nextchall;
    PlayState.hero.accessibleChall.add(nextchall);
    setCookie(
      cookieName_allChall,
      JSON.stringify(Array.from(PlayState.hero.accessibleChall))
    );
  }
  // load the right texture for accessible challenge/platform
  PlayState.platforms.forEach(function (element, index) {
    if (PlayState.hero.accessibleChall.has(element.idChall)) {
      element.loadTexture("finishGround");
    }
  });
}

// Modification fonction loadIframe
function loadIframe(idChall, urlChall) {
  var iframe = document.getElementById("iframeChall");

  if (idChall === "chall3") {
    // Chall3 -> navigation
    var queryParams = new URLSearchParams(window.location.search);
    var dirParam = queryParams.get("dir");

    // Mapping paramètres dir vers html
    var fileMapping = {
      "/": "dir.html",
      "/shared": "shared.html",
      "/shared/": "shared.html",
      "/public": "public.html",
      "/public/": "public.html",
      "/archives": "archives.html",
      "/archives/": "archives.html",
      "/archives/2020": "archives_2020.html",
      "/archives/2020/": "archives_2020.html",
      "/archives/2021": "archives_2021.html",
      "/archives/2021/": "archives_2021.html",
      "/archives/2022": "archives_2022.html",
      "/archives/2022/": "archives_2022.html",
      "/archives/2023": "archives_2023.html",
      "/archives/2023/": "archives_2023.html",
      "/archives/2024": "archives_2024.html",
      "/archives/2024/": "archives_2024.html",
      "/archives/2025": "archives_2025.html",
      "/archives/2025/": "archives_2025.html",
    };

    if (dirParam && fileMapping[dirParam]) {
      // Construire chemin vers html
      var basePath = urlChall.replace("index.html", "");
      iframe.src = basePath + fileMapping[dirParam];
    } else if (dirParam) {
      // Paramètre dir inconnu donc vers dir=/
      var basePath = urlChall.replace("index.html", "");
      iframe.src = basePath + "dir.html";
    } else {
      // Pas de paramètre dir vers index.html
      iframe.src = urlChall;
    }
  } else {
    // Normal autres challs
    iframe.src = urlChall;
  }
}

// Navigation chall3
function navigateToDirectory(dirPath) {
  // MAJ URL
  var newUrl = window.location.pathname + "?dir=" + dirPath;
  history.replaceState(null, null, newUrl);

  // Recharge iframe
  var iframe = document.getElementById("iframeChall");
  if (iframe && iframe.src) {
    // Chemin de base chall3
    var basePath = iframe.src.split("/").slice(0, -1).join("/") + "/";

    // Mapping paramètres dir vers html
    var fileMapping = {
      "/": "dir.html",
      "/shared": "shared.html",
      "/public": "public.html",
      "/archives": "archives.html",
      "/archives/2020": "archives_2020.html",
      "/archives/2021": "archives_2021.html",
      "/archives/2022": "archives_2022.html",
      "/archives/2023": "archives_2023.html",
      "/archives/2024": "archives_2024.html",
      "/archives/2025": "archives_2025.html",
    };

    if (fileMapping[dirPath]) {
      iframe.src = basePath + fileMapping[dirPath];
    }
  }
}

function spawnPopup(idChall, urlChall) {
  // get the popup html element from game.html
  var popup = document.getElementById(idChall);
  var beginBtn = null;

  // get current query params
  var queryParams = new URLSearchParams(window.location.search);

  // if chall3, don't set dir parameter initially - let it start on index.html
  if (idChall === "chall3") {
    // Ne pas définir de paramètre dir au début pour commencer sur index.html
    queryParams.delete("dir");
    history.replaceState(
      null,
      null,
      queryParams.toString() ? "?" + queryParams.toString() : ""
    );
  } else {
    queryParams.delete("page");
    queryParams.delete("dir");
    history.replaceState(null, null, "?" + queryParams.toString());
  }

  // if chall0 the normaly start challenge button will close the popup and get next chall accessible, update plateform
  if (idChall === "chall0") {
    closeBtnbis = document.getElementById("intro_close");
    closeBtnbis.onclick = function () {
      popup.style.display = "none";
      setCookie(cookieName_currentChall, idChall);
      PlayState.hero.accessibleChall.add(idChall);
      updatePlatform(idChall);
    };
  }
  if (idChall === "chall8") {
  }
  // else, start challenge button will close popup then load iframe, set cookie for current chall
  else {
    beginBtn = document.getElementById(idChall + "_begin");
    if (beginBtn != null)
      beginBtn.onclick = function () {
        loadIframe(idChall, urlChall);
        popup.style.display = "none";
        setCookie(cookieName_currentChall, idChall);
        //hide hint for all popup
        $(".indice_text").css("display", "none");
      };
  }
  // show the popup, close button will close popup and hide hint for all popup
  popup.style.display = "block";
  closeBtn = document.getElementById(idChall + "_close");
  closeBtn.onclick = function () {
    popup.style.display = "none";
    $(".indice_text").css("display", "none");
  };
}

function setCookie(name, value, expires, path, domain, secure) {
  document.cookie =
    name +
    "=" +
    escape(value) +
    (expires ? "; expires=" + expires.toGMTString() : "") +
    (path ? "; path=" + path : "") +
    (domain ? "; domain=" + domain : "") +
    (secure ? "; secure" : "");
}

function getCookie(name) {
  var arg = name + "=";
  var alen = arg.length;
  var clen = document.cookie.length;
  var i = 0;
  while (i < clen) {
    var j = i + alen;
    if (document.cookie.substring(i, j) === arg) return getCookieVal(j);
    i = document.cookie.indexOf(" ", i) + 1;
    if (i === 0) break;
  }
  return null;

  function getCookieVal(offset) {
    var endstr = document.cookie.indexOf(";", offset);
    if (endstr === -1) endstr = document.cookie.length;
    return unescape(document.cookie.substring(offset, endstr));
  }
}

function show_hide_indice() {
  if ($(".indice_text").css("display") === "block") {
    $(".indice_text").css("display", "none");
  } else {
    $(".indice_text").css("display", "block");
  }
}
```
#pagebreak()

== Implémentation du bot pour le challenge 6 de 2025 (`bot.js`) <bot.js>
```js
import puppeteer from "puppeteer";
import express from "express";
import cors from "cors";
import { v4 as uuidv4 } from "uuid";
import http from "http";
import https from "https";
import fs from "fs";

class AdminBot {
  constructor() {
    this.browser = null;
    this.page = null;
    this.isRunning = false;
    this.sessions = new Map(); // Store sessions
    this.app = express();
    this.setupAPI();
  }

  setupAPI() {
    this.app.use(
      cors({
        origin: true,
        credentials: true,
      })
    );
    this.app.use(express.json());

    // Nouvelle session
    this.app.post("/api/session/create", (req, res) => {
      const sessionId = uuidv4();
      const session = {
        id: sessionId,
        messages: [],
        createdAt: Date.now(),
        lastActivity: Date.now(),
      };
      this.sessions.set(sessionId, session);
      console.log(`[BOT-API] Nouvelle session : ${sessionId}`);
      res.json({ sessionId });
    });

    // Ajout message session
    this.app.post("/api/session/:sessionId/message", (req, res) => {
      const { sessionId } = req.params;
      const { text, isUser } = req.body;

      const session = this.sessions.get(sessionId);
      if (!session) {
        return res.status(404).json({ error: "Session non trouvée" });
      }

      const message = {
        id: uuidv4(),
        text,
        isUser,
        timestamp: Date.now(),
        processed: false,
      };

      session.messages.push(message);
      session.lastActivity = Date.now();

      console.log(
        `[BOT-API] Message ${sessionId}: ${text.substring(0, 50)}...`
      );

      // Si mess user -> traitement bot
      if (isUser) {
        setTimeout(() => this.processUserMessage(sessionId, message), 1000);
      }

      res.json({ success: true, messageId: message.id });
    });

    // Récupère messages session
    this.app.get("/api/session/:sessionId/messages", (req, res) => {
      const { sessionId } = req.params;
      const session = this.sessions.get(sessionId);

      if (!session) {
        return res.status(404).json({ error: "Session non trouvée" });
      }

      res.json({ messages: session.messages });
    });

    // Démarrer serveur sur port 3001
    const port = process.env.BOT_API_PORT || 3001;
    this.app.listen(port, () => {
      console.log(`[BOT-API] Serveur démarré sur le port ${port}`);
    });
  }

  async processUserMessage(sessionId, message) {
    const session = this.sessions.get(sessionId);
    if (!session) return;

    console.log(`[BOT] Traitement ${sessionId}: ${message.text}`);

    let botResponse = `Message reçu : ${message.text}`;
    let stolenCookie = null;

    // Vérifier XSS vol cookies
    const isCookieStealingXSS = 
      message.text.includes("document.cookie") ||
      message.text.includes("document['cookie']") ||
      message.text.includes('document["cookie"]') ||
      (message.text.includes("cookie") && (
        message.text.includes("<script>") ||
        message.text.includes("javascript:") ||
        message.text.includes("onerror=") ||
        message.text.includes("onload=")
      ));

    if (
      message.text.includes("<script>") ||
      message.text.includes("onerror=") ||
      message.text.includes("onload=") ||
      message.text.includes("javascript:") ||
      message.text.includes("<a href=")
    ) {

      if (isCookieStealingXSS) {
        try {

          // Exécuter payload joueur et reprend résultat
          try {
            this.capturedOutput = "";
            this.isCapturingXSS = true;

            let jsCode = "";
            
            // Extraire JavaScript selon payload
            const scriptMatch = message.text.match(/<script[^>]*>(.*?)<\/script>/s);
            const javascriptMatch = message.text.match(/javascript:([^"']*)/);
            
            if (scriptMatch && scriptMatch[1]) {
              // Payload <script>
              jsCode = scriptMatch[1].trim();
              await this.page.evaluate((code) => {
                eval(code);
              }, jsCode);
            } else if (javascriptMatch && javascriptMatch[1]) {
              // Payload javascript
              jsCode = javascriptMatch[1].trim();
              const allCookies = await this.page.cookies();
              const cookieString = allCookies.map(cookie => `${cookie.name}=${cookie.value}`).join('; ');
              this.capturedOutput = cookieString;
              
              await this.page.evaluate((code) => {
                eval(code);
              }, jsCode);
            } else {
              // autres xss
              await this.page.setContent(`<html><body>${message.text}</body></html>`);
              
              // si lien javascript -> simule clic
              if (message.text.includes('<a href="javascript:')) {
                try {
                  await this.page.click('a');
                } catch (e) {
                }
              }
            }
            
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            // stop capture
            this.isCapturingXSS = false;

            // type d'action demandée
            if (scriptMatch && scriptMatch[1]) {
              jsCode = scriptMatch[1].trim();
            } else if (javascriptMatch && javascriptMatch[1]) {
              jsCode = javascriptMatch[1].trim();
            }
            
            // Remplacer par cookie bot
            if (message.text.includes('<a href="javascript:') && jsCode.includes('alert(')) {
              const escapedCookies = this.capturedOutput.replace(/"/g, '\\"').replace(/\n/g, '\\n');
              botResponse = `Message reçu: 

<a href="javascript:alert('Cookies admin volés:\\n${escapedCookies}')">Click me</a>`;
            } else if (jsCode.includes('alert(')) {
              // Si alerte <script> -> alerte 
              if (this.capturedOutput) {
                const escapedCookies = this.capturedOutput.replace(/"/g, '\\"').replace(/\n/g, '\\n');
                botResponse = `Message reçu: ${message.text}

<script>alert("Cookies admin volés:\\n${escapedCookies}")</script>`;
              }
            } else if (jsCode.includes('console.log(')) {
              // Si console.log -> console.log 
              if (this.capturedOutput) {
                const escapedCookies = this.capturedOutput.replace(/"/g, '\\"').replace(/\n/g, '\\n');
                botResponse = `Message reçu: ${message.text}

<script>console.log("Cookies admin volés:", "${escapedCookies}")</script>`;
              }
            } else if (jsCode.includes('fetch(')) {
              // Si fetch -> dans chatbot
              const allCookies = await this.page.cookies();
              const cookieString = allCookies.map(cookie => `${cookie.name}=${cookie.value}`).join('; ');
              botResponse = `Message reçu: ${message.text}

Cookies admin volés: ${cookieString}`;
            } else if (this.capturedOutput) {
              // Autre
              botResponse = `Message reçu: ${message.text}

Cookies admin volés: ${this.capturedOutput}`;
            }
          } catch (error) {
            this.isCapturingXSS = false;
            botResponse = `Message reçu: ${message.text}

Erreur exécution`;
          }
        } catch (error) {
          console.error(`[BOT] Erreur XSS:`, error);
        }
      } else {
        botResponse = `Message reçu: ${message.text}`;
      }
    } else {
      // Commandes bot
      const command = message.text.toLowerCase().trim();
      
      if (command === "help") {
        botResponse = `Message reçu: ${message.text}

Commandes disponibles :
• help - Afficher l'aide
• status - État du système
• admin - Contacter l'administrateur
• stats - Afficher les statistiques
• test - Tester la connexion`;
      } else if (command === "status") {
        botResponse = `Message reçu: ${message.text}

Système opérationnel
Bot admin actif et surveille les messages`;
      } else if (command === "admin") {
        botResponse = `Message reçu: ${message.text}

Demande d'assistance admin enregistrée`;
      } else if (command === "stats") {
        botResponse = `Message reçu: ${message.text}

Statistiques du système :
• Sessions actives: ${this.sessions.size}
• Messages traités: ${Array.from(this.sessions.values()).reduce((total, session) => total + session.messages.length, 0)}`;
      } else if (command === "test") {
        botResponse = `Message reçu: ${message.text}

Connexion OK
Bot admin opérationnel
Latence: ~${Math.floor(Math.random() * 50 + 10)}ms`;
      } else {
        botResponse = `Message reçu: ${message.text}`;
      }
    }

    // Réponse bot
    const adminReply = {
      id: uuidv4(),
      text: botResponse,
      isUser: false,
      timestamp: Date.now(),
      processed: true,
    };

    session.messages.push(adminReply);
    session.lastActivity = Date.now();

    // Message user traité
    message.processed = true;

    console.log(`[BOT] Réponse pour ${sessionId}`);
  }

  cleanOldSessions() {
    const twoHoursAgo = Date.now() - 2 * 60 * 60 * 1000;
    let cleaned = 0;

    for (const [sessionId, session] of this.sessions.entries()) {
      if (session.createdAt < twoHoursAgo) {
        this.sessions.delete(sessionId);
        cleaned++;
      }
    }

    if (cleaned > 0) {
      console.log(`[BOT] ${cleaned} sessions cleaned`);
    }
  }

  async start() {
    try {
      console.log("[BOT] Démarrage bot admin");

      // Démarrer Puppeteer avec contexte
      this.browser = await puppeteer.launch({
        headless: "new",
        ignoreHTTPSErrors: true,
        args: [
          "--no-sandbox",
          "--disable-setuid-sandbox",
          "--disable-dev-shm-usage",
          "--disable-accelerated-2d-canvas",
          "--no-first-run",
          "--no-zygote",
          "--disable-gpu",
          "--ignore-certificate-errors",
          "--ignore-ssl-errors",
          "--disable-web-security",
          "--disable-features=VizDisplayCompositor",
          "--disable-web-security",
          "--allow-running-insecure-content",
        ],
      });

      this.page = await this.browser.newPage();
      await this.page.setUserAgent(
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
      );

      // Variables capturer outputs XSS
      this.capturedOutput = "";
      this.isCapturingXSS = false;

      // Capturer alertes logs
      this.page.on('dialog', async (dialog) => {
        console.log(`[BOT-ALERT] ${dialog.type()}: ${dialog.message()}`);
        
        // Si capture pour xss -> stocke
        if (this.isCapturingXSS) {
          this.capturedOutput = dialog.message();
        }
        
        await dialog.accept();
      });

      this.page.on('console', (msg) => {
        console.log(`[BOT-CONSOLE] ${msg.type()}: ${msg.text()}`);

        // Si capture pour xss et c'est un log -> stocke
        if (this.isCapturingXSS && msg.type() === 'log') {
          this.capturedOutput = msg.text();
        }
      });

      // Serveur HTTP simple contexte
      this.botContextServer = http.createServer((req, res) => {
        res.writeHead(200, { "Content-Type": "text/html" });
        res.end(
          "<html><body><h1>Bot Admin Context</h1><p>Contexte pour cookies Puppeteer</p></body></html>"
        );
      });

      this.botContextServer.listen(3002, () => {
        console.log("[BOT] Serveur contexte démarré port 3002");
      });

      // Domaine valide
      await this.page.goto("http://localhost:3002", {
        waitUntil: "networkidle0",
      });

      // Cookies admin bot
      await this.page.setCookie({
        name: "_xsrf",
        value: "2|a8452827|a77b2cb9c1b7c7b20fa273a9805236a9|1757511565",
        path: "/",
        expires: -1,
        httpOnly: false,
        secure: false,
        sameSite: "Lax",
      });

      await this.page.setCookie({
        name: "bk2025_mP81x_all",
        value: "%5B%22chall0%22%2C%22chall1%22%2C%22chall2%22%2C%22chall3%22%2C%22chall4%22%2C%22chall5%22%2C%22chall6%22%5D",
        path: "/",
        expires: -1,
        httpOnly: false,
        secure: false,
        sameSite: "Lax",
      });

      await this.page.setCookie({
        name: "bk2025_xH92f_curr",
        value: "chall6",
        path: "/",
        expires: -1,
        httpOnly: false,
        secure: false,
        sameSite: "Lax",
      });

      await this.page.setCookie({
        name: "admin",
        value: "ADM1N_53551ON_TOKEN25",
        path: "/",
        expires: -1,
        httpOnly: false,
        secure: false,
        sameSite: "Lax",
      });

      // Vérif cookie est défini
      const cookies = await this.page.cookies();
      console.log("[BOT] Cookies :", cookies);

      this.isRunning = true;
      console.log(
        "[BOT] Bot admin démarré avec Puppeteer"
      );

      // Nettoyage sessions auto
      setInterval(() => {
        this.cleanOldSessions();
      }, 60 * 60 * 1000);

      console.log("[BOT] Nettoyage sessions activé");

      // Monitoring sessions
      this.startMonitoring();
    } catch (error) {
      console.error("[BOT] Erreur démarrage:", error);
    }
  }

  async startMonitoring() {
    console.log("[BOT] Surveillance sessions");

    while (this.isRunning) {
      try {
        console.log(`[BOT] Sessions actives: ${this.sessions.size}`);

        if (this.sessions.size > 0) {
          console.log("[BOT] Détails sessions:");
          for (const [sessionId, session] of this.sessions.entries()) {
            const unprocessed = session.messages.filter(
              (msg) => msg.isUser && !msg.processed
            ).length;
            const shortId = sessionId.substring(0, 12);
            console.log(
              `  └─ ${shortId}... : ${session.messages.length} messages (${unprocessed} non traités)`
            );

            if (unprocessed > 0) {
              console.log(
                `[BOT] Traitement automatique`
              );
            }
          }
        }

        console.log("[BOT] Bot admin OK");

        // 30s pause
        await this.sleep(30000);
      } catch (error) {
        console.error("[BOT] Erreur surveillance:", error);
        await this.sleep(10000);
      }
    }
  }

  async sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  async stop() {
    console.log("[BOT] Arrêt bot admin");
    this.isRunning = false;
    if (this.page) {
      await this.page.close();
      console.log("[BOT] Page Puppeteer fermée");
    }
    if (this.browser) {
      await this.browser.close();
      console.log("[BOT] Navigateur Puppeteer fermé");
    }
    if (this.botContextServer) {
      this.botContextServer.close();
      console.log("[BOT] Serveur contexte fermé");
    }
    console.log("[BOT] Bot admin arrêté");
  }
}

const bot = new AdminBot();

// Arrêt
process.on("SIGINT", async () => {
  console.log("\n[BOT] Signal d'arrêt reçu");
  await bot.stop();
  process.exit(0);
});

process.on("SIGTERM", async () => {
  console.log("\n[BOT] Signal de terminaison reçu");
  await bot.stop();
  process.exit(0);
});

// Démarrer bot
bot.start().catch((error) => {
  console.error("[BOT] Erreur :", error);
  process.exit(1);
});

export default AdminBot;
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
