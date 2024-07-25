//
// import 'dart:convert';
//
// import 'package:testapi/repo.dart';
// import 'package:http/http.dart' as http;
//
// class GitHubService {
//   final String apiUrl = "https://api.github.com/users/flutter/repos";
//
//   Future<List<Repo>> fetchRepos() async {
//     final response = await http.get(Uri.parse(apiUrl));
//
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((repo) => Repo.fromJson(repo)).toList();
//     } else {
//       throw Exception('Failed to load repos');
//     }
//   }
// }
