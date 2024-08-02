import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/top_headline_model.dart';

class NewsRepo{

  Future<top_headline_model> AlltimeNews(String category) async{
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=77851986b72c4f92a8bc52a914d331ae';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
       final body = jsonDecode(response.body);
       print(body);
       return top_headline_model.fromJson(body);
    }
    throw Exception("error");

  }




  Future<top_headline_model> TopHeadlineFetch(String name) async {
    try {
      String url = 'https://newsapi.org/v2/top-headlines?sources=${name}&apiKey=77851986b72c4f92a8bc52a914d331ae';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return top_headline_model.fromJson(body);
      } else {
        throw Exception("Server returned ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error during fetching data: $e");
    }
  }




}