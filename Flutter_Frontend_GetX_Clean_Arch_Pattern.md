# Flutter Frontend with GetX & Clean Architecture Pattern Blueprint

This document serves as a complete, precise, and reusable architecture blueprint for building Flutter frontend applications. It is designed to be fully readable by AI systems (and human developers) to replicate the exact folder structure, naming conventions, coding style, state management, local caching, and network client patterns of the reference codebase.

---

## 1. Project Overview
* **Purpose:** A social media application where users can share, explore, create, like, save, and dynamically generate memes with AI.
* **Tech Stack:**
  * **Flutter SDK ^3.7.2** (Dart-based UI framework)
  * **GetX ^4.7.2** (State management, dependency injection, and path-based routing)
  * **Dio ^5.9.0** (HTTP client with interceptors, timeouts, and multipart support)
  * **GetStorage ^2.1.1** (Persistent local key-value storage)
  * **JsonSerializable ^6.9.5** (Build runner utility for JSON mapping code generation)
  * **Flutter ScreenUtil ^5.9.3** (UI screen dimensions adaptivity wrapper)
* **Configuration:**
  * **GetMaterialApp** bootstraps the application context in `lib/main.py`.
  * The theme is dynamically set to a custom dark theme (`AppTheme.darkTheme`).
  * Dependencies and states are managed reactive-style via controller variables (`.obs` and `Obx`).

---

## 2. Directory Structure
The application uses a **Feature-Based UI Layout** combined with centralized infrastructure and data layers:

```
pub_meme/
├── assets/                       # Global assets (images, fonts, gifs, logos)
├── lib/
│   ├── main.dart                 # Application bootstrapper and core configuration
│   ├── config.dart               # Environments setup and backend host mappings
│   ├── controllers/              # Central/global business logic controllers
│   │   └── global.controller.dart
│   ├── data/                     # Central data layer (Models, API clients, storage methods)
│   │   ├── enums/                # Common enumerations (e.g. snackbar configurations)
│   │   ├── extensions/           # Dart helpers (e.g. Spacing values)
│   │   ├── managers/             # Local system managers (e.g. media gallery access)
│   │   ├── methods/              # API wrapper setups and local storage helpers
│   │   │   ├── api_client.dart   # Central HTTP client wrapping Dio requests
│   │   │   ├── app_method.dart   # GetStorage read/write wrappers
│   │   │   └── session_cleanup.dart
│   │   ├── models/               # JSON serializable data class representations
│   │   │   ├── api/              # Standard envelopes (ApiResponse)
│   │   │   ├── auth/             # User credential details
│   │   │   └── post/             # Post and Category details
│   │   └── services/             # Endpoint client abstractions (REST API connections)
│   │       ├── base.service.dart # Shared error extraction and code maps
│   │       ├── auth_service.dart
│   │       ├── post_service.dart
│   │       └── profile_service.dart
│   ├── infrastructure/           # Common utilities (Theme definitions, routes, page lists)
│   │   ├── environment/          # Active execution variables
│   │   ├── navigation/           # Core navigation maps
│   │   │   ├── bindings/         # GetX dependency lifecycle bindings
│   │   │   │   └── controllers/  # Lazy controller loaders for each page
│   │   │   ├── navigation.dart   # GetPage routing declarations
│   │   │   └── routes.dart       # String constants path configuration
│   │   └── theme/                # Global styling constants (colors, text, icons)
│   ├── presentation/             # Feature UI modules
│   │   ├── home/                 # Home feed feature
│   │   │   ├── controllers/      # Home business logic state managers
│   │   │   │   └── home.controller.dart
│   │   │   └── home.screen.dart  # Home view widget structure
│   │   ├── create/               # Creation feature
│   │   ├── explore/              # Explore feature
│   │   └── profile/              # User profile feature
│   └── widgets/                  # Shared global widgets (buttons, loaders, dialogs)
```

---

## 3. Clean Architecture Layer Breakdown
The application structure separates concerns into three clear architectural layers:

```
  ┌─────────────────────────────────────────────────────────────┐
  │                    PRESENTATION LAYER                       │
  │  View (GetView<C>)  ──►  Controller (GetxController)        │
  └──────────────────────────────┬──────────────────────────────┘
                                 │  (Calls Services)
                                 ▼
  ┌─────────────────────────────────────────────────────────────┐
  │                        DATA LAYER                           │
  │  Service (REST Client)  ──►  ApiClient (Dio Request / Curl)  │
  └──────────────────────────────┬──────────────────────────────┘
                                 │  (Serializes JSON)
                                 ▼
  ┌─────────────────────────────────────────────────────────────┐
  │                       DOMAIN LAYER                          │
  │  Data Models (PostModel)  ◄──  Generics (ApiResponse<T>)    │
  └─────────────────────────────────────────────────────────────┘
```

* **Data Layer (`lib/data/`):**
  * Contains the low-level client utilities, API services, and parsing models.
  * `ApiClient` abstracts Dio HTTP calls, processes response status envelopes, handles errors globally, and formats responses via parser closures.
  * Services (e.g., `PostService`) declare static endpoints mapping requests onto the generic `ApiClient`.
  * Models declare JSON conversion schemas mapped via build generators.
* **Domain Layer (Mapped inside models and storage helpers):**
  * Provides abstract interfaces like `AppMethod` encapsulating raw memory reading operations (`GetStorage`) and translating generic response packages (`ApiResponse<T>`) into domain logic.
* **Presentation Layer (`lib/presentation/`):**
  * Manages UI construction and state reactions.
  * Views extend `GetView<T>` pointing to their respective controllers, avoiding hard references to `Get.find()`.
  * Controllers inherit from `GetxController`, declare responsive reactive variables (`.obs`), handle lifecycle events (`onInit`, `onClose`), trigger background service updates, and update properties.

---

## 4. GetX Setup & Configuration
* **App Bootstrap:** The application is wrapped in `ScreenUtilInit` to adapt design layouts, building `GetMaterialApp` inside `lib/main.dart`:
  ```dart
  GetMaterialApp(
    title: "PubMeme",
    initialRoute: initialRoute,
    getPages: Nav.routes,
    theme: AppTheme.darkTheme,
    // ...
  )
  ```
* **Dependency Lifecycle Bindings:** Views rely on lazy dependency injection definitions (`Get.lazyPut()`). Each screen is bound to its controller via unique `Bindings` configurations registered inside the `getPages` route list:
  ```dart
  GetPage(
    name: Routes.HOME,
    page: () => const HomeScreen(),
    binding: HomeControllerBinding(),
  )
  ```
* **Global Injection:** App-wide services (such as profile checks or media upload tracking) are registered globally in the initialization thread using `Get.put(GlobalController())`.

---

## 5. Routing Pattern
* **Routes Class (`routes.dart`):** Defines string constants for paths:
  ```dart
  static const HOME = '/home';
  static const PROFILE = '/profile';
  ```
* **Initial Route Mapping:** Checked dynamically in a static accessor in `Routes` before loading:
  ```dart
  static Future<String> get initialRoute async {
    final token = AppMethod.getUserToken();
    if (token != null && token.isNotEmpty) {
      await AuthService().autoSignInWithApi();
    }
    return LANDING;
  }
  ```
* **Pages Collection (`navigation.dart`):** Declares a static list containing all `GetPage` definitions mapping paths, screens, and controller bindings.
* **Transition & Navigation Operations:** GetX APIs control navigation flows:
  * `Get.toNamed(Routes.POST_DETAIL, arguments: {...})` - Navigates passing route argument data packages.
  * `Get.offAllNamed(Routes.LOGIN)` - Clears the navigation stack.
  * `Get.back()` - Navigates to the previous screen.

---

## 6. Controllers (GetX Controllers)
* **Base Pattern:** Inherits from `GetxController` to expose standard lifecycle hooks.
* **State Declaration Style:** Variables are declared as observable wrappers (`RxBool`, `RxInt`, `RxList<T>`, `RxMap<K, V>`) suffixed with `.obs`:
  ```dart
  RxBool isLoading = false.obs;
  RxList<PostModel> allPosts = <PostModel>[].obs;
  ```
* **Lifecycle Hooks:**
  * `onInit()`: Listen to scroll changes, load category profiles, and trigger page fetch requests.
  * `onClose()`: Detach event scroll listeners and dispose ScrollControllers safely in frame callbacks.
* **API Invocations:** Operations set local loading observables (`isLoading.value = true`), execute await service queries, process output, assign list ranges, and catch faults to display snackbars.

---

## 7. Data Models
* **JSON Mapping:** Uses `json_serializable` mapping generation:
  ```dart
  @JsonSerializable(explicitToJson: true)
  class PostModel {
    // ...
    factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
    Map<String, dynamic> toJson() => _$PostModelToJson(this);
  }
  ```
* **Custom Mappings:** When backend JSON schemas differ from standard Firestore formats, models expose custom parsers (e.g. `factory PostModel.fromRemoteApiJson(...)`) to safely map snakes, nulls, and type conversions.
* **State Replication helper:** Models expose standard immutable constructors (`copyWith`) to duplicate instances when local parameters modify state:
  ```dart
  PostModel copyWith({bool? isLiked}) => PostModel(isLiked: isLiked ?? this.isLiked, ...);
  ```

---

## 8. API Provider Layer
* **Base Service (`BaseService`):** Evaluates HTTP responses returned from network operations. Logs validation issues, triggers user logouts when receiving `401 Unauthorized` responses, and raises clean user snackbars.
* **Dio Client Integration:** Centralized in `ApiClient`. It configures BaseOptions, handles API bearer injection, and builds request operations dynamically using functional parameters:
  ```dart
  Future<T?> request<T>(
    Future<Response> Function(Dio dio) requestFn, {
    T Function(dynamic json)? parser,
  }) async { ... }
  ```
* **Logging:** Adds a request interceptor converting outgoing configurations into print-ready standard curl strings.

---

## 9. Repository Layer
* **Abstraction Wrapper:** In this design framework, API Service classes (like `PostService`) act as the repository abstraction layer. They encapsulate the network query layer, inject tokens, define queries, and invoke `ApiClient` parsers.
* **Injection Strategy:** Services expose static endpoint functions which are imported and called directly inside controllers, maintaining simple dependency graphs.

---

## 10. Views & UI Structure
* **GetView Declarations:** Views inherit from `GetView<Controller>` to expose the controller reference:
  ```dart
  class HomeScreen extends GetView<HomeController> { ... }
  ```
* **Responsive State Bindings (`Obx`):** Widgets requiring dynamic UI updates are wrapped inside `Obx` closures to automatically rebuild on state updates:
  ```dart
  Obx(() {
    if (controller.isLoading.value) return const LoadingSpinner();
    return buildList(controller.allPosts);
  })
  ```
* **Method Extraction Pattern:** To keep build trees readable, layout sections are extracted into private helper functions (e.g. `Widget _buildFeedGrid()`).

---

## 11. Bindings
* **Bindings Class Pattern:** Inherits from `Bindings`, loading target controllers lazily when routes activate:
  ```dart
  class HomeControllerBinding extends Bindings {
    @override
    void dependencies() {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
  ```
* **Registration Directory:** Bindings reside in `lib/infrastructure/navigation/bindings/controllers/`, keeping the UI presentation modules independent of navigation routing.

---

## 12. Theme & Styling
* **Centralization:** Dark themes are centralized in `lib/infrastructure/theme/theme.dart`.
* **Colors Nomenclature:** Styled colors are defined as variables (e.g. `scaffoldDark = Color(0xFF0F0F12)`, `primary = Color(0xFF8B5CF6)`).
* **Text Styles:** Typographies are defined as reusable variables utilizing `GoogleFonts.outfit()` (e.g., `r14 = TextStyle(...)`, `r20 = TextStyle(...)`).
* **Spacing Extensions:** Column layouts use custom double extensions to build vertical/horizontal spacer widgets:
  ```dart
  Spacing.s12.h // Returns SizedBox(height: 12)
  ```

---

## 13. Network Layer
* **Dio Client Configuration:** Formats timeouts and header constraints in `ApiClient`:
  ```dart
  connectTimeout: const Duration(seconds: 45),
  headers: {'Content-Type': 'application/json'}
  ```
* **Access Token Attachment:** Checks local storage methods and appends header JWT tokens on requests:
  ```dart
  final token = AppMethod.getUserToken();
  if (token != null) dio.options.headers['Authorization'] = 'Bearer $token';
  ```

---

## 14. Global Widgets
* **Location:** Stored in the shared directory `/lib/widgets/`.
* **Categories:** Sorted into subdirectories:
  * `buttons/`: Custom inkwell shapes.
  * `loaders/`: Shimmer indicators and refresh controls.
  * `modal/`: Sheet validation structures.
  * `form_fields/`: Text input validation forms.

---

## 15. State Management Patterns
* **Obs List Mutations:** Replaces reactive collection items cleanly:
  ```dart
  allPosts.assignAll(items); // Triggers observers
  ```
* **Pagination State Machine:** Handles lazy loading using ScrollControllers, tracking pages via local variables:
  ```dart
  RxBool isLoadingMore = false.obs;
  RxBool hasMorePosts = true.obs;
  int _lastFetchedPage = 0;
  ```

---

## 16. Error Handling (UI Layer)
* **Dio Error Traps:** Catches `DioException` in the client wrapper, extracts response strings, and logs detailed error streams.
* **Notification Popups:** Employs GetX SnackBar interfaces to inform users of operations:
  ```dart
  Get.snackbar('Title', 'Message', backgroundColor: Colors.red);
  ```

---

## 17. Code Style & Conventions
* **Files:** Use `snake_case` with dot extensions for types (e.g., `home.screen.dart`, `home.controller.dart`).
* **Variables:** Use `camelCase` for variable definitions, and prefix private methods with an underscore (e.g., `void _applyFilter()`).
* **Imports:** Standard package paths go first, followed by internal application imports.

---

## 18. AI-Replication Instructions
When writing a new Flutter project based on this pattern, the AI must strictly adhere to the following rules:

1. **Feature Layout Separation:** Group UI screens inside `lib/presentation/{feature}/` containing views and sub-controllers.
2. **Bindings Registration Rules:** Always configure lazy controller bindings inside `lib/infrastructure/navigation/bindings/controllers/` and map them in `navigation.dart`.
3. **GetView Views:** Build screens inheriting from `GetView<T>`. Never access controllers directly via `Get.find()` inside view files.
4. **Obx UI Wrapping:** Wrap reactive widgets inside `Obx` observers, utilizing observable variables (`.obs`) inside controllers for state management.
5. **Base Client Operations:** Route HTTP operations through `ApiClient.request()`, utilizing generic response models (`ApiResponse<T>`) for serialization.
6. **No Direct SetStates:** Implement all mutable logic and layout flags in GetX Controllers rather than using stateful views with `setState()`.
7. **Storage Encapsulation:** Access persistent storage via `AppMethod` wrappers rather than invoking `GetStorage` directly inside feature modules.

---

## 19. Full Code Examples (Critical Section)
The following code snippets present the complete, copy-pasteable layout of a standard CRUD feature (in this case, "Posts") to show the exact pattern.

### ✅ `routes/app_routes.dart`
*File path: `/lib/infrastructure/navigation/routes.dart`*
```dart
import 'package:pub_meme/data/methods/app.method.dart';
import 'package:pub_meme/data/services/auth_service.dart';

class Routes {
  // Static accessor computing the starting screen
  static Future<String> get initialRoute async {
    final token = AppMethod.getUserToken();
    if (token != null && token.isNotEmpty) {
      await AuthService().autoSignInWithApi();
    }
    return LANDING;
  }

  // String constants mapping to specific paths
  static const HOME = '/home';
  static const LANDING = '/landing';
  static const POST_DETAIL = '/post-detail';
}
```

### ✅ `routes/app_pages.dart`
*File path: `/lib/infrastructure/navigation/navigation.dart`*
```dart
import 'package:get/get.dart';
import 'package:pub_meme/infrastructure/navigation/bindings/controllers/controllers_bindings.dart';
import 'package:pub_meme/infrastructure/navigation/routes.dart';
import 'package:pub_meme/presentation/screens.dart';

class Nav {
  // Static router collection mapping routes to widgets and controller bindings
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.LANDING,
      page: () => const LandingScreen(),
      binding: LandingControllerBinding(),
    ),
  ];
}
```

### ✅ `modules/posts/bindings/posts_binding.dart`
*File path: `/lib/infrastructure/navigation/bindings/controllers/home.controller.binding.dart`*
```dart
import 'package:get/get.dart';
import 'package:pub_meme/presentation/home/controllers/home.controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily instantiate target controller when route is loaded
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
```

### ✅ `modules/posts/controllers/posts_controller.dart`
*File path: `/lib/presentation/home/controllers/home.controller.dart`*
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pub_meme/controllers/global.controller.dart';
import 'package:pub_meme/data/enums/snackbar_enum.dart';
import 'package:pub_meme/data/methods/app_method.dart';
import 'package:pub_meme/data/models/post/post.model.dart';
import 'package:pub_meme/data/services/post_service.dart';
import 'package:pub_meme/data/utils/app_utils.dart';

class HomeController extends GetxController {
  final log = Logger();
  final globalController = Get.put(GlobalController());
  
  // Local state constants
  static const int _feedPageSize = 20;
  static const double _loadMoreScrollThreshold = 280;

  // Reactive state fields
  RxList<PostModel> allPosts = <PostModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMorePosts = true.obs;
  
  final ScrollController scrollController = ScrollController();
  int _lastFetchedPage = 0;

  @override
  void onInit() {
    super.onInit();
    // Register scroll event listeners for infinite scroll pagination
    scrollController.addListener(_onScrollNearBottom);
    getPosts(reset: true);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScrollNearBottom);
    // Dispose resources after render frames to avoid detaching conflicts
    final scroll = scrollController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scroll.dispose();
    });
    super.onClose();
  }

  void _onScrollNearBottom() {
    if (!scrollController.hasClients) return;
    if (!hasMorePosts.value || isLoadingMore.value || isLoading.value) return;
    
    final pos = scrollController.position;
    if (pos.maxScrollExtent <= 0) return;
    if (pos.pixels < pos.maxScrollExtent - _loadMoreScrollThreshold) return;
    
    loadMorePosts();
  }

  Future<void> getPosts({bool reset = true}) async {
    if (reset) {
      isLoading.value = true;
      _lastFetchedPage = 0;
      hasMorePosts.value = true;
    } else {
      isLoadingMore.value = true;
    }

    final requestPage = reset ? 1 : _lastFetchedPage + 1;

    try {
      final result = await PostService.fetchPosts(
        page: requestPage,
        pageSize: _feedPageSize,
      );

      if (result != null) {
        final page = result.data;
        final items = page?.items ?? [];
        if (reset) {
          allPosts.assignAll(items);
        } else {
          allPosts.addAll(items);
        }
        _lastFetchedPage = page?.page ?? requestPage;
        hasMorePosts.value = page?.hasMore ?? false;
      }
    } catch (error) {
      log.e('getPosts failed: $error');
      AppUtils.snackbar('Failed!', error.toString(), SnackBarType.ERROR);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMorePosts() async {
    await getPosts(reset: false);
  }
}
```

### ✅ `data/models/post_model.dart`
*File path: `/lib/data/models/post/post.model.dart`*
```dart
import 'package:json_annotation/json_annotation.dart';

part 'post.model.g.dart';

@JsonSerializable(explicitToJson: true)
class PostModel {
  String? docId;
  String? uid;
  String? userName;
  String? imageUrl;
  String? title;
  bool isLiked;
  bool isSaved;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool fromRemoteApi;

  PostModel({
    this.docId,
    this.uid,
    this.userName,
    this.imageUrl,
    this.title,
    this.isLiked = false,
    this.isSaved = false,
    this.fromRemoteApi = false,
  });

  // Default serialization mappings
  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  // Custom parser mapping snake_case keys from REST APIs
  factory PostModel.fromRemoteApiJson(Map<String, dynamic> json) {
    return PostModel(
      docId: (json['id'] as num).toString(),
      uid: (json['user_id'] as num).toString(),
      userName: json['user_name']?.toString(),
      imageUrl: json['image']?.toString(),
      title: json['caption']?.toString() ?? '',
      isLiked: json['is_liked'] == true,
      isSaved: json['is_saved'] == true,
      fromRemoteApi: true,
    );
  }
}
```

### ✅ `data/providers/posts_provider.dart`
*File path: `/lib/data/providers/posts_provider.dart` (Represented as raw API executor layout)*
```dart
import 'package:dio/dio.dart';
import 'package:pub_meme/data/methods/api_client.dart';
import 'package:pub_meme/data/models/api/api_response.model.dart';
import 'package:pub_meme/data/models/post/post_response_paginated.model.dart';

class PostsProvider {
  final ApiClient client = ApiClient();

  /// Execute GET request via Dio fetching paginated json structures
  Future<ApiResponse<PostResponsePaginated>?> getPostsRaw({
    required int page,
    required int pageSize,
  }) async {
    return client.request<ApiResponse<PostResponsePaginated>>(
      (dio) => dio.get(
        'posts/get-all-posts',
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<PostResponsePaginated>.fromJson(
          json,
          (Object? data) {
            return PostResponsePaginated.fromJson(data as Map<String, dynamic>);
          },
        );
      },
    );
  }
}
```

### ✅ `data/repositories/posts_repository.dart`
*File path: `/lib/data/services/post_service.dart` (Representing the service abstraction layer in this codebase)*
```dart
import 'package:pub_meme/data/methods/api_client.dart';
import 'package:pub_meme/data/models/api/api_response.model.dart';
import 'package:pub_meme/data/models/post/post_response_paginated.model.dart';

class PostService {
  PostService._();

  static final ApiClient client = ApiClient();

  /// Abstract static service mapping directly onto ApiClient executions
  static Future<ApiResponse<PostResponsePaginated>?> fetchPosts({
    int page = 1,
    int pageSize = 20,
  }) async {
    return client.request<ApiResponse<PostResponsePaginated>>(
      (dio) => dio.get(
        'posts/get-all-posts',
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<PostResponsePaginated>.fromJson(json, (Object? data) {
          return PostResponsePaginated.fromJson(data as Map<String, dynamic>);
        });
      },
    );
  }
}
```

### ✅ `modules/posts/views/posts_view.dart`
*File path: `/lib/presentation/home/home.screen.dart`*
```dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pub_meme/presentation/home/controllers/home.controller.dart';
import 'package:pub_meme/widgets/feed/pub_feed_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          // Reactive conditional layout loading
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => controller.getPosts(reset: true),
            child: CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                buildMasonryGrid(),
                buildLoadingMoreIndicator(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildMasonryGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childCount: controller.allPosts.length,
        itemBuilder: (context, index) {
          final post = controller.allPosts[index];
          // Masonry grid layout with alternating card heights
          final height = (index % 2 == 0) ? 220.0 : 160.0;
          return PubFeedCard(
            imageUrl: post.imageUrl ?? '',
            imageHeight: height,
            heroTag: post.docId ?? '--',
            title: post.title ?? '',
          );
        },
      ),
    );
  }

  Widget buildLoadingMoreIndicator() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (!controller.isLoadingMore.value) return const SizedBox.shrink();
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
```

### ✅ `modules/posts/widgets/post_card.dart`
*File path: `/lib/widgets/feed/pub_feed_card.dart`*
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PubFeedCard extends StatelessWidget {
  const PubFeedCard({
    super.key,
    required this.imageUrl,
    this.imageHeight,
    required this.heroTag,
    required this.title,
    this.onImageTap,
  });

  final String imageUrl;
  final double? imageHeight;
  final Object heroTag;
  final String title;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Render hero image widget with cached loader
          GestureDetector(
            onTap: onImageTap,
            child: Hero(
              tag: heroTag,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: imageHeight ?? 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: imageHeight ?? 200,
                  color: Colors.white05,
                ),
                errorWidget: (context, url, error) => Container(
                  height: imageHeight ?? 200,
                  color: Colors.white10,
                  child: const Icon(Icons.image_not_supported, color: Colors.white30),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
```
