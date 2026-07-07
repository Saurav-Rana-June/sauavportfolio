import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:saurav_portfolio/config.dart';
import 'package:saurav_portfolio/data/methods/app_method.dart';
import 'package:saurav_portfolio/data/services/base.service.dart';

class ApiClient {
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 45),
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _log.d(_toCurl(options));
          handler.next(options);
        },
        onError: (error, handler) {
          BaseService.handleUnauthorized(error);
          handler.next(error);
        },
      ),
    );
  }

  final Logger _log = Logger();
  late final Dio _dio;

  Future<T?> request<T>(
    Future<Response<dynamic>> Function(Dio dio) requestFn, {
    T Function(dynamic json)? parser,
    bool withAccessToken = false,
  }) async {
    try {
      if (withAccessToken) {
        final token = AppMethod.getThemeMode();
        if (token != null && token.isNotEmpty) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
        }
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final response = await requestFn(_dio);
      final data = response.data;

      if (parser != null && data != null) {
        return parser(data);
      }
      return data as T?;
    } on DioException catch (error) {
      _log.e('ApiClient request failed: ${error.message}');
      rethrow;
    }
  }

  String _toCurl(RequestOptions options) {
    final method = options.method.toUpperCase();
    final url = options.uri.toString();
    final headers = options.headers.entries
        .map((entry) => "-H '${entry.key}: ${entry.value}'")
        .join(' ');
    return 'curl -X $method $headers \'$url\'';
  }
}
