'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"apple-touch-icon.png": "d03e8df6831132bd65650ab25791d388",
"assets/AssetManifest.bin": "28402e81379e05a8a903f4d75564acd0",
"assets/AssetManifest.bin.json": "0a0ae1815fb08a9f1fe281301e71e84a",
"assets/AssetManifest.json": "056139017cf2b221ed81b863e131b62d",
"assets/assets/cv/SAURAV_RANA_RESUME_01.pdf": "98cd1db5749744bdc9d17353da9c7bc0",
"assets/assets/fonts/fa-brands-400.ttf": "e9a507bae9d52442aa73f9072bf318dc",
"assets/assets/fonts/fa-light-300.ttf": "13cb2d219ef25b15d50aadecbe9c86cb",
"assets/assets/fonts/fa-regular-400.ttf": "1e6d83dbc4dcc0fc65b746f6db19e4f6",
"assets/assets/fonts/fa-solid-900.ttf": "5803286fc41b825ba38a7a850ff2cae5",
"assets/assets/images/logo.svg": "36bf7e20c4fb70c0bc4fb77c94f9bdbb",
"assets/assets/images/mentora/app_logo.png": "ef88c72554dab25f57d2e4fb026f6cf7",
"assets/assets/images/mentora/feature%2520graphic.png": "a2a8274887993af3a6be39b8838847ee",
"assets/assets/images/mentora/ss_1.png": "f768f1047c3d1d0e1032c50f665f28af",
"assets/assets/images/mentora/ss_10.png": "595f51598992da1ebf351c31a610413c",
"assets/assets/images/mentora/ss_11.png": "b60dbb7b9754c82da5e2566ffb08c962",
"assets/assets/images/mentora/ss_12.png": "67b8ad3808f2261334736e768fd37305",
"assets/assets/images/mentora/ss_13.png": "9b815cf03ee541791a473f0f137ef451",
"assets/assets/images/mentora/ss_14.png": "42a0109e553e5f45500e675847204fdd",
"assets/assets/images/mentora/ss_15.png": "7a826903ef6be2d0c29347240cd817c3",
"assets/assets/images/mentora/ss_16.png": "aed5149cb353079f9f370ee1dfaf62c8",
"assets/assets/images/mentora/ss_17.png": "c79f8b1ed06a67b734311f57ef411fc3",
"assets/assets/images/mentora/ss_18.png": "95c49f23458c0bc1c1aed8faf1583a83",
"assets/assets/images/mentora/ss_19.png": "1951e6cc14f98152af84d6fe4f513a25",
"assets/assets/images/mentora/ss_2.png": "e4c883f20f604fcfc3a2a8a1fc3c5081",
"assets/assets/images/mentora/ss_3.png": "b15e099091e1b7c180451cbd6b3ff0b1",
"assets/assets/images/mentora/ss_4.png": "4b416b33eef5bc1e410e28bec3a8c793",
"assets/assets/images/mentora/ss_5.png": "ec5371763912d24e80f83c5284dcbc63",
"assets/assets/images/mentora/ss_6.png": "2eab3a4ff739b2264bc3f71273703c8c",
"assets/assets/images/mentora/ss_7.png": "34c540d0107d506e295555c1bf5a5040",
"assets/assets/images/mentora/ss_8.png": "8b639399a0510c45eaa8764b76447c7e",
"assets/assets/images/mentora/ss_9.png": "0f7e42fa5b682ec579296deb59e5fe20",
"assets/assets/images/mentora_cms/app_logo.png": "ef88c72554dab25f57d2e4fb026f6cf7",
"assets/assets/images/mentora_cms/desktop.ini": "6f5cfe4b244bba32fa723f2e954b70fb",
"assets/assets/images/mentora_cms/feature%2520graphic.png": "a2a8274887993af3a6be39b8838847ee",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214632.png": "1ee133a108bf538dbeaac8de167f3dd6",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214750.png": "820a75070da6e1767d5f6d57f1c67ef7",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214836.png": "a2d7e9486adf1550bf80770b1d163439",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214855.png": "a35e7518d90be3e7fdf55151eb4c10a3",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214911.png": "e60f25b3a258b6e56b9e767a06ef945a",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214922.png": "6e37f485edc80c8438d09b6aed04b493",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214938.png": "04b2806f21c5a246932aec4732b6df2e",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520214955.png": "7d1301e6721b86479b0f3df1fcd4a6f4",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520215005.png": "6cb8f9fbe5372a539a27de28c2c729e6",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520215023.png": "96cdfdbb1ece3a793a3b789f10898710",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520215034.png": "1ab327c0b288c9d6bb4d34336ecb8a23",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520215044.png": "0feb9ddaa39ab4527495b759a23b6e81",
"assets/assets/images/mentora_cms/Screenshot%25202026-10-04%2520215054.png": "49218194a1564e720a2027bce56a790c",
"assets/assets/images/pubmeme/app_logo.png": "8707229cfb7fa839ad033395359c77f4",
"assets/assets/images/pubmeme/feature%2520graphic.jpg": "5799541a81c1733edd0590f07af348d3",
"assets/assets/images/pubmeme/ss_1.png": "a0a3b84ffa2563a917a75c367b46c527",
"assets/assets/images/pubmeme/ss_2.png": "d05430c7ffe8bc7da2736675e9fceb0b",
"assets/assets/images/pubmeme/ss_3.png": "8a0203a42f187e89e3a4c2835cb23a20",
"assets/assets/images/pubmeme/ss_4.png": "fdedc65194dd88138d826dcdd503627e",
"assets/assets/images/pubmeme/ss_5.png": "812a17009be4174ac4e887dae123045d",
"assets/assets/images/pubmeme/ss_6.png": "0a60c4a8e7a31a7166037a856f0bc3ed",
"assets/assets/images/schoolbox/app_logo.png": "38ade887bb9d45b950ac8581be1950f4",
"assets/assets/images/schoolbox/feature%2520graphic.png": "2f041b01c3ca012b3cbff7fda4d4d0f1",
"assets/assets/images/schoolbox/ss_1.png": "bd66a95cfe3c1d7c232396bdef4c2ac5",
"assets/assets/images/schoolbox/ss_10.png": "3a03d628f11cb19cdff4c590e504ec01",
"assets/assets/images/schoolbox/ss_11.png": "2e886daa55ce630cf416d93e875c6d9d",
"assets/assets/images/schoolbox/ss_2.png": "514f94734f8b600f5d56c4c0b2504b45",
"assets/assets/images/schoolbox/ss_3.png": "a9c1b55ab09ec8dd868c4fbf086ae011",
"assets/assets/images/schoolbox/ss_4.png": "912a126b6e03a5fd57a994833190f22e",
"assets/assets/images/schoolbox/ss_5.png": "fb046ccbeabfcaeee8a8120620e4fc94",
"assets/assets/images/schoolbox/ss_6.png": "b377d8e5bb2c6486b1fb2faa0e9d8d08",
"assets/assets/images/schoolbox/ss_7.png": "c266d6ff83a4d6f42cdcc3ed967ea7cd",
"assets/assets/images/schoolbox/ss_8.png": "c58493f3a1f0d9985a43c6dfa30b667d",
"assets/assets/images/schoolbox/ss_9.png": "6c5a4fe3c214fb74e4391563c804dbf5",
"assets/FontManifest.json": "363ac0a37dc1147a82cfb228bdd8ca4d",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "e13fe0053f050471d20d8f4a45c97ed3",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.ico": "76a0d7a4dd7dc49a31b19752db0285ac",
"favicon.png": "d03e8df6831132bd65650ab25791d388",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "9fd2407380b9e87b8d39902931161df9",
"icons/icon-192-maskable.png": "6c42cd08f2b04885f8f7e6ce9a8cf969",
"icons/Icon-192.png": "cc982e88a667628e37162d2ab250c3b8",
"icons/icon-512-maskable.png": "5df15c8ece682ab7b1679bcea542521f",
"icons/Icon-512.png": "2de712242be95e746ccdc27996e30ac7",
"icons/Icon-maskable-192.png": "6c42cd08f2b04885f8f7e6ce9a8cf969",
"icons/Icon-maskable-512.png": "5df15c8ece682ab7b1679bcea542521f",
"index.html": "4c99c93149e320ea543f8a89a7e4ab83",
"/": "4c99c93149e320ea543f8a89a7e4ab83",
"main.dart.js": "9e1b00b3390a4c3c5946bad2770e7565",
"manifest.json": "273b8c3a4903b7672f070b6c1174f411",
"version.json": "054c112556bc0cf4613c5dc57f381cfe"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
