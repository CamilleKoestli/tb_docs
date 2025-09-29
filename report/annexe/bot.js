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
