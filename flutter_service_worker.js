'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "4cfa1e15a26763c691c40f82ba316ed8",
".git/config": "e64ad3772f1369c28cf859cc241d0ec5",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "b9261dab7103ea13f3005d851c94b438",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "f58963409fed6fb3bfd2c1f73cdc3f39",
".git/logs/refs/heads/gh-pages": "f58963409fed6fb3bfd2c1f73cdc3f39",
".git/logs/refs/remotes/origin/gh-pages": "00499adf14a7aa919c7acf1577a140da",
".git/objects/02/1d4f3579879a4ac147edbbd8ac2d91e2bc7323": "9e9721befbee4797263ad5370cd904ff",
".git/objects/0f/aa93990903969fa273556b9a7dfb842f9bde8a": "8e6c4942a99b87f8d05ad870c0d9b9c4",
".git/objects/15/87aacd7d07fddfa79a73fc6f35fdb8150bd686": "0f44b73d4add4a3c257866d0f9d54b0e",
".git/objects/20/3a3ff5cc524ede7e585dff54454bd63a1b0f36": "4b23a88a964550066839c18c1b5c461e",
".git/objects/28/d63ddbeb6b53281f6b0cb8ffc3104c981bb993": "3c5ef4807782428223e9df2f221cf788",
".git/objects/29/b19886313457f83e826f0d2615ddbdecc4f698": "95c442bcba8c81b6057331903b3d6778",
".git/objects/29/f22f56f0c9903bf90b2a78ef505b36d89a9725": "e85914d97d264694217ae7558d414e81",
".git/objects/38/e3e38926251742ef3b92dd9feaa25430ca2f67": "871ff0c56d1540f9f77d3bc8693fcf63",
".git/objects/3e/c9e3f268da30fccb63f637b94360ef98e2c11a": "c65805f0a1113d9ffcb61219d888e38f",
".git/objects/41/5c059c8094b888b0159fdedfd4e3cb08a8028e": "86914685ccd40e82a7fe5b70459fb9f7",
".git/objects/4d/bf9da7bcce5387354fe394985b98ebae39df43": "534c022f4a0845274cbd61ff6c9c9c33",
".git/objects/4f/40dabe4430b4d7288c6ae92d8fc3e17cf8e410": "7c1843130f2c3787540ded5445c7793a",
".git/objects/4f/fbe6ec4693664cb4ff395edf3d949bd4607391": "2beb9ca6c799e0ff64e0ad79f9e55e69",
".git/objects/50/de41c8315c248a4b380111aeb4d8faa5ac5a40": "b8583ff2d9af57a0745d7845cf867d55",
".git/objects/5c/de260703cf4c9544f88ac777692a1fda75d743": "bba9848ab4dc74ab7beea46305156df8",
".git/objects/6d/70080970b1b498278915befe7d9419b4dbd132": "f787791f07ba950795ef48ec254f1b4d",
".git/objects/76/0ff6af40e4946e3b2734c0e69a6e186ab4d8f4": "009b8f1268bb6c384d233bd88764e6f8",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/81/3fb23b6651768e1543cc38607fa633001a51fb": "f951835a2189ebbf9df89105effafc9a",
".git/objects/82/039646eae58381941a128edf3dd254c98a2961": "ba71a4099c57c699fe2ac9b609735b8e",
".git/objects/85/001eb1f52d907b1cec894098b20573dcb6af01": "81340b598ef17c13d5de9cbc3a89981d",
".git/objects/85/fba96197db179344dc21df2d0f690e432910b0": "fb22425c3116149082439ca92bff582c",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8c/99266130a89547b4344f47e08aacad473b14e0": "41375232ceba14f47b99f9d83708cb79",
".git/objects/94/5ff28c6728a787d8b85355e951b0155f6bbc6a": "48d9f1c390747b3924bd205fe158c81f",
".git/objects/98/0d49437042d93ffa850a60d02cef584a35a85c": "8e18e4c1b6c83800103ff097cc222444",
".git/objects/9b/3ef5f169177a64f91eafe11e52b58c60db3df2": "91d370e4f73d42e0a622f3e44af9e7b1",
".git/objects/9b/6d24b566c34b915b216f50d84aa4454036ec1c": "facd0d2edf00f16ae73ce2d74fe38a87",
".git/objects/9e/3b4630b3b8461ff43c272714e00bb47942263e": "accf36d08c0545fa02199021e5902d52",
".git/objects/aa/c62202f8a07b714b7e61f1fd2bb72bd7b1f4fd": "0f2c48320cde3c758a619cf55849a73d",
".git/objects/ad/4c0ba9842f4de544316a62269732d33f652961": "d2648c4f7ac6a01d24dedabffef3980b",
".git/objects/b2/6ec0f7df14315319d7464f8390b593ed47fd79": "bd4cf5fb52145bf76cc4435dd19f68fb",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c0/a48ad6472a3ffd196382a842351cedcd866809": "96e465143d02f6602100f4867fbbbd04",
".git/objects/c0/da74f61d2be77a8dcd360293d16c26f860c64b": "a3ac9b7e41a82022e7bc3760f2df2058",
".git/objects/c4/016f7d68c0d70816a0c784867168ffa8f419e1": "fdf8b8a8484741e7a3a558ed9d22f21d",
".git/objects/c5/819b399da43d6d92ba52d46d67f97741946f0f": "641a49a799ce281bc595dbfaebb03e36",
".git/objects/c8/e1038b06b3c36bea8b945182cb230d567c17c9": "8664ad5a336b099404236e72780505eb",
".git/objects/ca/3bba02c77c467ef18cffe2d4c857e003ad6d5d": "316e3d817e75cf7b1fd9b0226c088a43",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d5/64d0bc3dd917926892c55e3706cc116d5b165e": "ab5f20dcd5b558888db7d80b0f979f8a",
".git/objects/d5/80ce749ea55b12b92f5db7747290419c975070": "8b0329dbc6565154a5434e6a0f898fdb",
".git/objects/d5/95e2806a069a8b6863d5e1755e5d37ebaeb538": "26999ce129cbca9064b7435a1331ee72",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/db/6e8e438d3c8aaef8fcc0bd7a4adbf0bc9eb635": "c7561ee280d823c21de55b929e418061",
".git/objects/e0/f937b9d934a12c97f46df79f8d9b6f296753b3": "42894323e72a775fcb52cae31fa50103",
".git/objects/e2/4796d812c4e5c97cec0783fb9c0f910c0fb591": "26e23fca776466bec9a26a9e48f8db5b",
".git/objects/e3/e9ee754c75ae07cc3d19f9b8c1e656cc4946a1": "14066365125dcce5aec8eb1454f0d127",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/b55d4deb8363b6afa65df71d1f9fd8c7787f22": "886ebb77561ff26a755e09883903891d",
".git/objects/ef/4e6a5c0949bff498f370c264fd8151566ec5c7": "20b8c053ed62db25a7ad5f3a6bd8b6f5",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/fa/13d80c88e3954e43ed3445a39f5e9498843003": "c67657e1d8ff4737cd3d49cc0824ff71",
".git/objects/fb/2292b36fa3e3ca2d1a2cb2af6886e1c7260aa4": "2f21b5e1de899b1d0db353e988fd3a0d",
".git/objects/fe/3b987e61ed346808d9aa023ce3073530ad7426": "dc7db10bf25046b27091222383ede515",
".git/objects/fe/a640e906ec867778b0c96506db0a476905c02e": "fc3b0d987b85448f1e3a41bad66559d4",
".git/refs/heads/gh-pages": "d352197334968739951c50a6932e3777",
".git/refs/remotes/origin/gh-pages": "d352197334968739951c50a6932e3777",
"assets/AssetManifest.bin": "94c65a7dbf2e3bfdb270aacf2ef4c7d7",
"assets/AssetManifest.bin.json": "21ec9e5908350c6cc2b76d904a98d297",
"assets/AssetManifest.json": "131e09b6cc829d59f4c7d23f715e1da8",
"assets/assets/fonts/fa-brands-400.ttf": "e9a507bae9d52442aa73f9072bf318dc",
"assets/assets/fonts/fa-light-300.ttf": "13cb2d219ef25b15d50aadecbe9c86cb",
"assets/assets/fonts/fa-regular-400.ttf": "1e6d83dbc4dcc0fc65b746f6db19e4f6",
"assets/assets/fonts/fa-solid-900.ttf": "5803286fc41b825ba38a7a850ff2cae5",
"assets/assets/images/logo.svg": "36bf7e20c4fb70c0bc4fb77c94f9bdbb",
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
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "69104214b09a66f4511be3a1153f8872",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "a412fdaa4c56f3d02ef187b41ad19d2e",
"/": "a412fdaa4c56f3d02ef187b41ad19d2e",
"main.dart.js": "1f4a7206e6cc7aac37e98c599d33b887",
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
