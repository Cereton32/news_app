import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/top_headline_model.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:news_app/views/all_category_news.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum newChannelList { abcNews, aryNews, bbcNews,googleNews}

class _HomeScreenState extends State<HomeScreen> {
  String name = 'bbc-news';
  newChannelList? selectedenu;
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    var urltoLaunch;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AllNewsCategory()));
          },
          icon: Image.asset('assests/img/category_icon (1).png',scale: 0.2,),
        ),
        title: Text(
          "News",
          style: GoogleFonts.poppins(
              textStyle:
              TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Colors.black)),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<newChannelList>(
              initialValue: selectedenu,
              onSelected: (newChannelList item) {
                if (newChannelList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                }
                if (newChannelList.aryNews.name == item.name) {
                  name = 'ary-news';
                }
                if (newChannelList.abcNews.name == item.name) {
                  name = 'abc-news';
                }
                if(newChannelList.googleNews.name==item.name){
                  name = 'google-news';
                }
                setState(() {
                  newsViewModel.TopHeadlineFetch(name);
                });
              },
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<newChannelList>>[
                PopupMenuItem(
                  value: newChannelList.abcNews,
                  child: Text('ABC  News'),
                ),
                PopupMenuItem(
                    value: newChannelList.googleNews,
                    child:Text("The Times of india")),
                PopupMenuItem(
                  value: newChannelList.bbcNews,
                  child: Text('BBC News'),
                ),
                PopupMenuItem(
                  value: newChannelList.aryNews,
                  child: Text('ARY News'),
                ),
              ],icon: Icon(Icons.more_vert),)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _buildTopHeadlines(width, height),
            ),
            Expanded(
              child: _buildAllTimeNews(width, height),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeadlines(double width, double height) {
    var urlToLaunch;
    return FutureBuilder<top_headline_model>(
      future: newsViewModel.TopHeadlineFetch(name),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(
              size: 100,
              color: Colors.red,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return ListView.builder(

            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data?.articles?.length,
            itemBuilder: (context, index) {
              var publishedAt = snapshot.data!.articles![index].publishedAt;
              var parsedDate = DateTime.parse(publishedAt!);
              var formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

             return  GestureDetector(
                onTap: () async {
                   urlToLaunch = snapshot.data?.articles?[index].url;
                   try{
                     urlToLaunch!=null && await canLaunchUrl(Uri.parse(urlToLaunch));
                     await launchUrl(Uri.parse(urlToLaunch));
                   }

                   catch(error){

                     ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text("Error Launching url + ${error.toString()}"))
                     );

                   }

                },
                child: Container(
                  child: Stack(

                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              width: width,
                              height: height * .55,
                              imageUrl:
                              snapshot.data!.articles![index].urlToImage.toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SpinKitWaveSpinner(
                                  color: Colors.blue,
                                  size: 80,
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: SpinKitWaveSpinner(
                                  color: Colors.red,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 15,
                        child: Card(

                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            height: height * .22,
                            width: width * .9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      snapshot.data!.articles![index].title.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis)),
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            snapshot.data!.articles![index].source!.id
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }

  Widget _buildAllTimeNews(double width, double height) {
    var urltoLaunch;
    return FutureBuilder<top_headline_model>(
      future: newsViewModel.AlltimeNews("General"),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(
              size: 100,
              color: Colors.red,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data?.articles?.length,
            itemBuilder: (context, index) {
              var publishedAt = snapshot.data!.articles![index].publishedAt;
              var parsedDate = DateTime.parse(publishedAt!);
              var formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

              return GestureDetector(
                  onTap: ()async{
                    urltoLaunch = snapshot.data?.articles?[index].url;
                    try{
                      urltoLaunch!=null && await canLaunchUrl(Uri.parse(urltoLaunch));
                      await launchUrl(Uri.parse(urltoLaunch));
                    }

                    catch(error){

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error Launching url + ${error.toString()}"))
                      );

                    }
                  },
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              width: width,
                              height: height * .55,
                              imageUrl:
                              snapshot.data!.articles![index].urlToImage.toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SpinKitWaveSpinner(
                                  color: Colors.blue,
                                  size: 80,
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: SpinKitWaveSpinner(
                                  color: Colors.red,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 15,
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            height: height * .22,
                            width: width * .9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      snapshot.data!.articles![index].title.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis)),
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            snapshot.data!.articles![index].source!.id
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}
