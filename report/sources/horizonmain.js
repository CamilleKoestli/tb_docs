//HORIZON 2025
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
  this.game.load.json("level:1", "data/level01Horizon.json");

  //plateforms for Horizon 2025
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
