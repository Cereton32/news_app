import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/top_headline_model.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class AllNewsCategory extends StatefulWidget {
  const AllNewsCategory({super.key});

  @override
  State<AllNewsCategory> createState() => _AllNewsCategoryState();
}

NewsViewModel? _newsViewModel;

class _AllNewsCategoryState extends State<AllNewsCategory> {
  List<String> Category = [
    "General",
    "Health",
    "Sport",
    "Entertainment",
    "Buisness",
    "Technology"
  ];

  String name = 'General';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    var urltoLaunch;
    return Scaffold(
      appBar: AppBar(
        title: Text("Total News"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .066,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Category.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextButton(
                        onPressed: () {
                          name=Category[index];
                          setState(() {

                          });
                        },
                        child: Container(
                          width: width * .3,
                          decoration: BoxDecoration(
                              color: name==Category[index]?Colors.blue:Colors.grey,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                            Category[index].toString(),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.white)),
                          )),
                        ),
                      ));
                }),
          ),
          FutureBuilder<top_headline_model>(
              future: NewsViewModel().AlltimeNews(name),
              builder: (BuildContext context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(

                    child: SpinKitCircle(
                      color: Colors.blue,
                    ),
                  );
                } else if(snapshot.hasData) {

                  return Expanded(

                    child: ListView.builder(

                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.articles?.length,
                        itemBuilder: (context,index){
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
                           }
                            ,
                            child: Container(
                              width: width,
                              height: height,
                              child: Column(
                                children: [
                                  Container(
                                    height: height * 0.5,
                                    width: width ,

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(

                                    child: Container(
                                      height: height * 0.3,
                                      width: width,
                                      child: Column(

                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),
                                        textAlign: TextAlign.center
                                        ,style: GoogleFonts.poppins(
                                            textStyle:TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700
                                            )
                                          ),),
                                          15.heightBox,
                                          Text(snapshot.data!.articles![index].description.toString(),
                                            textAlign: TextAlign.center
                                            ,style: GoogleFonts.poppins(
                                                textStyle:TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400
                                                )
                                            ),),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                        ],
                                      ),
                                    )
                                  )

                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  );
                }
                else {
                  return Container(
                    child: Text("error exist ${snapshot.error}"),
                  );
                }
              })
        ],
      ),
    );
  }
}
