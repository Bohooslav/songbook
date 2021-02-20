var APP_PREFIX = "SongBook_v"; // Identifier for this app (this needs to be consistent across every cache update)
var VERSION = "2.0.0.2"; // Version of the off-line cache (change this value everytime you want to update cache)
var CACHE_NAME = APP_PREFIX + VERSION;
var URLS = [
  // Add URL you want to cache in this list.
  "/", // If you have separate JS/CSS files,
  "/index.html", // add path to those files here
  "/static/app/client.css",
  "/static/app/client.js",
  "/static/app/client.js.map",
  "/images/green-leaves-plants.jpeg",
  "/chords/A.png",
  "/chords/A5.png",
  "/chords/A6.png",
  "/chords/A7.png",
  "/chords/A9.png",
  "/chords/Ab.png",
  "/chords/Ab6.png",
  "/chords/Ab7.png",
  "/chords/Abm.png",
  "/chords/Abm7.png",
  "/chords/Adim.png",
  "/chords/Am.png",
  "/chords/Am6.png",
  "/chords/Am7.png",
  "/chords/Am9.png",
  "/chords/Am11.png",
  "/chords/Amaj7.png",
  "/chords/Asus.png",
  "/chords/Asus2.png",
  "/chords/Ax.png",
  "/chords/Ax7.png",
  "/chords/Axm.png",
  "/chords/Axm7.png",
  "/chords/Bb.png",
  "/chords/Bb7.png",
  "/chords/Bb9.png",
  "/chords/Bbm.png",
  "/chords/Bbm7.png",
  "/chords/C.png",
  "/chords/C5.png",
  "/chords/C6.png",
  "/chords/C7.png",
  "/chords/C9.png",
  "/chords/Cadd9.png",
  "/chords/Cdim.png",
  "/chords/Cm.png",
  "/chords/Cm6.png",
  "/chords/Cm7.png",
  "/chords/Cm9.png",
  "/chords/Cm11.png",
  "/chords/Cmaj7.png",
  "/chords/Cmaj9.png",
  "/chords/Csus.png",
  "/chords/Csus2.png",
  "/chords/Cx.png",
  "/chords/Cx7.png",
  "/chords/Cxm.png",
  "/chords/Cxm7.png",
  "/chords/D.png",
  "/chords/D5.png",
  "/chords/D6.png",
  "/chords/D7.png",
  "/chords/D9.png",
  "/chords/D11.png",
  "/chords/Dadd9.png",
  "/chords/Db.png",
  "/chords/Db7.png",
  "/chords/Dbm.png",
  "/chords/Dbm7.png",
  "/chords/Ddim.png",
  "/chords/Ddim7.png",
  "/chords/Dm.png",
  "/chords/Dm7.png",
  "/chords/Dm9.png",
  "/chords/Dm11.png",
  "/chords/Dmaj7.png",
  "/chords/Dsus.png",
  "/chords/Dsus2.png",
  "/chords/Dx.png",
  "/chords/Dx7.png",
  "/chords/Dxm.png",
  "/chords/Dxm7.png",
  "/chords/E.png",
  "/chords/E5.png",
  "/chords/E6.png",
  "/chords/E7.png",
  "/chords/E9.png",
  "/chords/Eb.png",
  "/chords/Eb6.png",
  "/chords/Eb7.png",
  "/chords/Ebm.png",
  "/chords/Ebm6.png",
  "/chords/Ebm7.png",
  "/chords/Edim.png",
  "/chords/Edim7.png",
  "/chords/Em.png",
  "/chords/Em6.png",
  "/chords/Em7.png",
  "/chords/Em9.png",
  "/chords/Em11.png",
  "/chords/Emaj7.png",
  "/chords/Esus.png",
  "/chords/Esus2.png",
  "/chords/F.png",
  "/chords/F5.png",
  "/chords/F6.png",
  "/chords/F7.png",
  "/chords/F9.png",
  "/chords/Fdim.png",
  "/chords/Fdim7.png",
  "/chords/Fm.png",
  "/chords/Fm6.png",
  "/chords/Fm7.png",
  "/chords/Fm11.png",
  "/chords/Fmaj7.png",
  "/chords/Fmaj9.png",
  "/chords/Fsus.png",
  "/chords/Fsus2.png",
  "/chords/Fx.png",
  "/chords/Fx7.png",
  "/chords/Fxm.png",
  "/chords/Fxm7.png",
  "/chords/G.png",
  "/chords/G5.png",
  "/chords/G6.png",
  "/chords/G7.png",
  "/chords/G9.png",
  "/chords/Gb.png",
  "/chords/Gb7.png",
  "/chords/Gbm.png",
  "/chords/Gbm7.png",
  "/chords/Gdim.png",
  "/chords/Gm.png",
  "/chords/Gm6.png",
  "/chords/Gm7.png",
  "/chords/Gm9.png",
  "/chords/Gm11.png",
  "/chords/Gmaj7.png",
  "/chords/Gsus.png",
  "/chords/Gsus2.png",
  "/chords/Gx.png",
  "/chords/Gx7.png",
  "/chords/Gxm.png",
  "/chords/Gxm7.png",
  "/chords/H.png",
  "/chords/H5.png",
  "/chords/H6.png",
  "/chords/H7.png",
  "/chords/H9.png",
  "/chords/Hdim.png",
  "/chords/Hm.png",
  "/chords/Hm6.png",
  "/chords/Hm7.png",
  "/chords/Hm7b5.png",
  "/chords/Hm11.png",
  "/chords/Hmaj7.png",
  "/chords/Hsus.png",
  "/chords/Hsus2.png",
];

// Respond with cached resources
self.addEventListener("fetch", function (e) {
  console.log("fetch request : " + e.request.url);
  e.respondWith(
    caches.match(e.request).then(function (request) {
      if (request) {
        // if cache is available, respond with cache
        console.log("responding with cache : " + e.request.url);
        return request;
      } else {
        // if there are no cache, try fetching request
        console.log("file is not cached, fetching : " + e.request.url);
        return fetch(e.request);
      }

      // You can omit if/else for console.log & put one line below like this too.
      // return request || fetch(e.request)
    })
  );
});

// Cache resources
self.addEventListener("install", function (e) {
  e.waitUntil(
    caches
      .open(CACHE_NAME)
      .then(function (cache) {
        console.log("installing cache : " + CACHE_NAME);
        return cache.addAll(URLS);
      })
      .then(() => {
        return self.skipWaiting();
      })
  );
});

// Delete outdated caches
self.addEventListener("activate", function (e) {
  e.waitUntil(
    caches.keys().then(function (keyList) {
      // `keyList` contains all cache names under your username.github.io
      // filter out ones that has this app prefix to create white list
      var cacheWhitelist = keyList.filter(function (key) {
        return key.indexOf(APP_PREFIX);
      });
      // add current cache name to white list
      cacheWhitelist.push(CACHE_NAME);

      return Promise.all(
        keyList.map(function (key, i) {
          if (cacheWhitelist.indexOf(key) === -1) {
            console.log("deleting cache : " + keyList[i]);
            return caches.delete(keyList[i]);
          }
        })
      );
    })
  );
  return self.clients.claim();
});
