//__HEAD__
(()=>{var a="3.0.0";var u="SongBook_v",d=""+u+"_cache",c="sw-"+d+"-"+a,t=function(e){return console.log(""+c+" "+e)};t("loaded");var p=["./"];globalThis.addEventListener("fetch",function(e){t("fetch");function i(n){return n?(t("responding with cache "+e.request.url),n):(t("not cached, fetching "+e.request.url),this.fetch(e.request))}return e.respondWith(caches.match(e.request.url).then(i))});globalThis.addEventListener("install",function(e){t("install");function i(n){return t("adding urls to cache"),n.addAll(p),this.skipWaiting()}return e.waitUntil(caches.open(c).then(i))});globalThis.addEventListener("activate",function(e){t("activate");function i(n){var r=this;let s=n.map(async function(o,f){if(t("checking cache "+o),o!==c){t("deleting cache "+o);let l=await r.caches.delete(o);return t("deletion of "+o+" result: "+l)}});return Promise.all(s)}return e.waitUntil(caches.keys().then(i))});})();
//__FOOT__
