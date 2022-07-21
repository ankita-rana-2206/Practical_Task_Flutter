import 'package:practical/ui/common/stringConstant.dart';

///
/// This class contains all URL which is being called to fetch data from server
///
class ApiClient {

  final String jsonHeaderName = "Content-Type";
  final String jsonHeaderValue = "application/json; charset=UTF-8";
  final String token = "token";

  static String baseUrl =
      "http://205.134.254.135/~mobile/MtProject/public/api/";
  static const int successResponse = 200;

  Map<String, String> getJsonHeader() {
    var header = <String, String>{};
    header[jsonHeaderName] = jsonHeaderValue;
    return header;
  }

  Future<Map<String, String>> getAuthorizedHeader() async {
    final header = getJsonHeader();
    header[token] = StringConstants.token;
    return header;
  }


  Uri addQueryParamsToUrl(String originalUrl, Map<String, String> queryParams) {
    var oldUrl = Uri.parse(originalUrl);
    var oldQueryParams = oldUrl.queryParameters;
    var newQueryParams = {
      ...oldQueryParams,
      if (queryParams.isNotEmpty) ...queryParams,
    };
    var newUrl = oldUrl.replace(queryParameters: newQueryParams);
    return newUrl;
  }
}
