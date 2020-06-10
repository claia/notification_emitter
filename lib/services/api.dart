import 'package:http/http.dart' as http;

// imports
import 'package:emitterk/models/faculties.dart';
export 'package:emitterk/models/faculties.dart';

class ApiService {
  final String url = "https://utesawebservice.herokuapp.com";
  // final String url = "http://10.0.0.9:8080";

  Future<bool> emitNotification(String title, String body) async {
    if (title.isEmpty || body.isEmpty) return false;

    final endpoint = "$url/api/notification/send";

    try {
      final res = await http.post(endpoint,
          body: {"title": title.toString(), "body": body.toString()});

      if (res.statusCode == 422 ||
          res.statusCode == 500 ||
          res.statusCode == 401) return false;

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> emitNotificationByFaculties(
      String title, String body, int facultadid) async {
    if (title.isEmpty || body.isEmpty || facultadid == null) return false;

    print(facultadid);

    final endpoint = "$url/api/notification/sendByFaculties";

    try {
      final res = await http.post(endpoint, body: {
        "title": title.toString(),
        "body": body.toString(),
        "facultadid": facultadid.toString()
      });

      if (res.statusCode == 422 ||
          res.statusCode == 500 ||
          res.statusCode == 401) {
        print(res.body);
        return false;
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<Faculties>> getFaculties() async {
    final endpoint = "$url/api/notification/faculties";

    try {
      final res = await http.get(endpoint);

      if (res.statusCode == 422 ||
          res.statusCode == 500 ||
          res.statusCode == 401) return [];

      return facultiesFromJson(res.body);
    } catch (err) {
      print(err.toString());
      return [];
    }
  }
}
