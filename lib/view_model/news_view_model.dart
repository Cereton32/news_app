import 'package:news_app/models/top_headline_model.dart';
import 'package:news_app/repo/new_repo.dart';

class NewsViewModel{
  final _repo = NewsRepo();


  Future<top_headline_model> AlltimeNews(String name)async{
    final response = _repo.AlltimeNews(name);
    return response;
  }

  Future<top_headline_model> TopHeadlineFetch(String name) async{
    final response = await  _repo.TopHeadlineFetch(name);
    return  response;
  }


}