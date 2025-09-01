= Implémentation des challenges <implementation>

#include "frontend.typ"
#pagebreak()

#include "backend.typ"
#pagebreak()

== Intégration sur le site web <integration-site-web>
Modification de db.js pour intégrer les challenges dans le site web existant. Ajout des routes pour chaque challenge et création de la page d'accueil avec la liste des challenges.

db.js
```js
/* ... */
// Support for 2025 challenges
  const flags_2025 = process.env.CHALL_FLAGS_2025.split(';');

    for await (const flag of flags_2025) {
        const elem = flag.split('=');
        assert(elem.length === 2);
        const hash = new SHA3(256);
        hash.update(elem[1]);
        if (!(await Flag.exists({chall_name: "2025_"+elem[0]})))
            await Flag.create({chall_name: "2025_"+elem[0], value: hash.digest('hex')});
    }
```

création de blackoutmain.js

création de blackoutgame.html
```html
<!doctype html>
<head>
    <title>Blackout de le Centre Hospitalier Horizon Santé</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700,800" rel="stylesheet">

    <link rel="stylesheet" href="css/animate.css">
    <link rel="stylesheet" href="css/owl.carousel.min.css">

    <link rel="stylesheet" href="fonts/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="fonts/fontawesome/css/font-awesome.min.css">

    <!-- Theme Style -->
    <link rel="stylesheet" href="css/style.css">
    <style>
        canvas {
            margin: 0 auto;
        }
    </style>

    <link rel="apple-touch-icon" sizes="180x180" href="images/favicons/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="images/favicons/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="images/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="images/favicons/favicon-16x16.png">
</head>
<div class="game blackoutgame" w3-include-html="./header.html"></div>
<body>
    <input id="inputHint" type="text" id="flag" name="flag" placeholder="réponse">
    <button id="sumbitHint" class="submitHint">Valider l'étape !</button>
    <div id="game"></div>
    <iframe id="iframeChall" src="" frameborder="0" style="display: block;background: #000;border: none;overflow:hidden;height:100vh;width:100%">
    </iframe>

    <!-- Challenge popup includes for Blackout 2025 -->
    <div w3-include-html="./challenges2025/0_intro/popup.html"></div>
    <div w3-include-html="./challenges2025/1_mail_contagieux/popup.html"></div>
    <div w3-include-html="./challenges2025/2_portail_frauduleux/popup.html"></div>
    <div w3-include-html="./challenges2025/3_partage_oublie/popup.html"></div>
    <div w3-include-html="./challenges2025/4_cle_cachee/popup.html"></div>
    <div w3-include-html="./challenges2025/5_script_mystere/popup.html"></div>
    <div w3-include-html="./challenges2025/6_cookie_rancon/popup.html"></div>
    <div w3-include-html="./challenges2025/7_blocage_cible/popup.html"></div>
    <div w3-include-html="./challenges2025/8_outro/popup.html"></div>
    <div w3-include-html="./popupSubmitChall.html"></div>
</body>

<script src="js/jquery-3.2.1.min.js"></script>
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/owl.carousel.min.js"></script>
<script src="js/jquery.waypoints.min.js"></script>
<script src="js/template.js"></script>
<script src="js/includehtml.js"></script>
<script>
    includeHTML();
</script>
<script src="js/phaser.min.js"></script>
<script src="js/blackoutmain.js"></script>
<script src="node_modules/@azerion/phaser-input/build/phaser-input.js"></script>

<script src="https://www.google.com/recaptcha/api.js"></script>
```

ajout information dans index.html
```html
<!-- ... -->

const VALID_YEARS = ["2020", "2021", "2025"];
<!-- ... -->
      <a href="./blackoutgame.html" class="btn btn-white btn-outline-white px-3 py-3 long-txt-button col-2 ml-xl-5"> Blackout<span class="ion-arrow-right-c"></span></a>
<!-- ... -->
<!-- ... -->
<section class="section bg-light element-animate" id="game3">
    <div class="container introhacking">
        <div class="row justify-content-center align-items-center mb-5">
            <h2 class="">Blackout de le Centre Hospitalier Horizon Santé</h2>
        </div>
        <div class="row align-items-center mb-5">
            <div class="col-md-7 pr-md-5 mb-5">
                <div class="block-41">
                    <div class="block-41-text">
                        <p>
                            Le Centre Hospitalier Horizon Santé a été victime d'une cyberattaque majeure, mettant en péril la sécurité des données de ses patients.
                        </p>
                        <p>
                            En tant qu'expert en cybersécurité, ta mission de réussir à infiltrer le domaine des attaquants, supprimer les données volées et bloquer les attaquants.
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 ">
                <!-- TODO CHANGE VIDEO LINK-->
                <div class="embed-responsive embed-responsive-16by9">
                    <iframe src="https://www.youtube.com/embed/jgkrl94bnvw" allowfullscreen></iframe>
                </div>
                <br>
                <a href="./blackoutgame.html" class="btn btn-white btn-outline-white px-3 py-3 long-txt-button">Accéder aux
                    défis ! <span class="ion-arrow-right-c"></span></a>
            </div>
        </div>
    </div>
</section>
<!-- ... -->
```

ajout des flags dans .env et .env.prod pour être stocké dans la db mongo
```env
#...
CHALL_FLAGS_2025="chall1=horizonsante-support.com;chall2=co_S3ss10n4Cc3s5;chall3=patient_audit_07-12.zip;
chall4=horizon42;chall5=/admin/monitoring/bot_communication_panel_v2;
chall6=ALL_FILES_DELETED;chall7=BLK_185-225-123-77_OK"
```

