import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slipbuddy/constants/secure_storage.dart';

class ApiManager {
  getRequest(String url) async {
    var token = await UserSecureStorage.fetchToken();

    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 403 ||
        response.statusCode == 203) {
      return response;
    } else {
      return null;
    }
  }

  putRequest(var alertBody, var url) async {
    var response = await http.put(
      Uri.parse(url),
      body: alertBody,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      return response;
    } else {
      return null;
    }
  }

  postRequest(var body, String url) async {
    var token = await UserSecureStorage.fetchToken();
    Response? response;

    if (token == null) {
      response = await http.post(
        Uri.parse(url.trim()),
        body: jsonEncode(body),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          }
      );
    } else {
      response = await http.post(Uri.parse(url.trim()), body: body, headers: {
        "Authorization": "Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });
    }

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      return response;
    } else {
      return null;
    }
  }
  postWithoutRequest(String url) async {
    var token = await UserSecureStorage.fetchToken();
    http.Response? response;

    if (token == null) {
      response = await http.post(
        Uri.parse(url.trim()),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );
    } else {
      response = await http.post(
        Uri.parse(url.trim()),
        headers: {
          "Authorization": "Bearer $token",
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );
    }

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      return response;
    } else {
      return null;
    }
  }
  multiRequestRoute(
      String userName, String mobileNumber, image, String url) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          image.path,
        ),
      );
    }

    request.fields['user_name'] = userName;
    request.fields['user_phone'] = mobileNumber;

    final token = await UserSecureStorage.fetchToken();

    request.headers['Authorization'] = "Bearer $token";

    try {
      final response = await request.send();

      return http.Response.fromStream(response);
    } catch (error) {
      // Handle errors

      return http.Response('Error sending request', 500);
    }
  }

  registerComplainFormRequest(
      String categoryType,
      String type,
      String subject,
      String description,
      String blockId,
      String unitId,
      String priorityId,
      List<File> documentFiles,
      url) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (documentFiles.isNotEmpty) {
      for (var i = 0; i < documentFiles.length; i++) {
        request.files.add(await http.MultipartFile.fromBytes(
          'attch_file[]',
          await documentFiles[i].readAsBytes(),
          filename: documentFiles[i].path.split('/').last,
        ));
      }
    }

    request.fields['category_type'] = categoryType;
    request.fields['type'] = type;
    request.fields['subject'] = subject;
    request.fields['description'] = description;
    request.fields['block_id'] = blockId;
    request.fields['unit_id'] = unitId;
    request.fields['priority_level'] = priorityId;

    final token = await UserSecureStorage.fetchToken();

    request.headers['Authorization'] = "Bearer $token";

    try {
      final response = await request.send();

      return http.Response.fromStream(response);
    } catch (error) {
      // Handle errors

      return http.Response('Error sending request', 500);
    }
  }

  uploadIncomingDocument(
      String documentId, List<File> documentFiles, url) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (documentFiles.isNotEmpty) {
      for (var i = 0; i < documentFiles.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
          'documents[]',
          await documentFiles[i].readAsBytes(),
          filename: documentFiles[i].path.split('/').last,
        ));
      }
    }

    request.fields['documentId'] = documentId;

    final token = await UserSecureStorage.fetchToken();

    request.headers['Authorization'] = "Bearer $token";

    try {
      final response = await request.send();

      return http.Response.fromStream(response);
    } catch (error) {
      // Handle errors

      return http.Response('Error sending request', 500);
    }
  }

}
