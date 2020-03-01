// var CACHE_NAME = 'v0.0.1';
// var urlsToCache = [
//   '/',
//   // 'index.html',
//   'client.js',
//   'index.css',
//   'fonts/stylesheet.css',
//   'images/39d13a8f6b1750f9f7a63a76f89d436e.jpg',
//   'images/spaces_-LSPhP31nsEVE02x38XJ_avatar.png'
// ];

// self.addEventListener('install', function (event) {
//   event.waitUntil(
//     caches.open(CACHE_NAME)
//     .then(function (cache) {
//       console.log('👷', 'Opened cache');
//       return cache.addAll(urlsToCache);
//     })
//   );
// });

// self.addEventListener('fetch', (event) => {
//   event.respondWith(
//     caches.match(event.request).then((resp) => {
//       return fetch(event.request).then((response) => {
//         if (!response || response.status !== 200 || response.type !== 'basic') {
//           return response;
//         }
//         var responseToCache = response.clone();

//         caches.open(CACHE_NAME)
//           .then(function (cache) {
//             cache.put(event.request, responseToCache);
//           });
//         console.log("saved response")

//         return response;
//       }) || resp;
//     }).catch(() => {
//       return caches.match('/');
//       // return caches.match('/songbook/dist/index.html');
//     })
//   );
// });

// self.addEventListener('activate', (event) => {
//   var cacheKeeplist = [CACHE_NAME];
//   event.waitUntil(
//     caches.keys().then((keyList) => {
//       return Promise.all(keyList.map((key) => {
//         if (cacheKeeplist.indexOf(key) === -1) {
//           return caches.delete(key);
//         }
//       }));
//     })
//   );
//   console.log('👷', 'SW is activated');
// });

var APP_PREFIX = 'SongBook_' // Identifier for this app (this needs to be consistent across every cache update)
var VERSION = 'version_01' // Version of the off-line cache (change this value everytime you want to update cache)
var CACHE_NAME = APP_PREFIX + VERSION
var URLS = [ // Add URL you want to cache in this list.
  '/songbook/', // If you have separate JS/CSS files,
  '/songbook/index.html', // add path to those files here
  '/songbook/dist/client.js',
  '/songbook/dist/index.css',
  '/songbook/dist/fonts/stylesheet.css',
  '/songbook/dist/images/39d13a8f6b1750f9f7a63a76f89d436e.jpg',
  '/songbook/dist/images/spaces_-LSPhP31nsEVE02x38XJ_avatar.png'
]

// Respond with cached resources
self.addEventListener('fetch', function (e) {
  console.log('fetch request : ' + e.request.url)
  e.respondWith(
    caches.match(event.request).then((resp) => {
      return fetch(event.request).then((response) => {
        if (!response || response.status !== 200 || response.type !== 'basic') {
          return response;
        }
        var responseToCache = response.clone();

        caches.open(CACHE_NAME)
          .then(function (cache) {
            cache.put(event.request, responseToCache);
          });
        console.log("saved response")

        return response;
      }) || resp;
    }).catch(() => {
      return caches.match('/');
      // return caches.match('/songbook/dist/index.html');
    })
  )
})

// Cache resources
self.addEventListener('install', function (e) {
  e.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      console.log('installing cache : ' + CACHE_NAME)
      return cache.addAll(URLS)
    })
  )
})

// Delete outdated caches
self.addEventListener('activate', function (e) {
  e.waitUntil(
    caches.keys().then(function (keyList) {
      // `keyList` contains all cache names under your username.github.io
      // filter out ones that has this app prefix to create white list
      var cacheWhitelist = keyList.filter(function (key) {
        return key.indexOf(APP_PREFIX)
      })
      // add current cache name to white list
      cacheWhitelist.push(CACHE_NAME)

      return Promise.all(keyList.map(function (key, i) {
        if (cacheWhitelist.indexOf(key) === -1) {
          console.log('deleting cache : ' + keyList[i])
          return caches.delete(keyList[i])
        }
      }))
    })
  )
})
