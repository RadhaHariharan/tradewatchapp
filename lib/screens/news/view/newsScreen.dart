import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradewatchapp/common/extensions.dart';
import 'package:tradewatchapp/screens/news/controller/newsController.dart';

// This widget is responsible for displaying the news in the UI
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsCtrlWatch = context.watch<NewsController>();
    return RefreshIndicator(
      onRefresh: () async {
        newsCtrlWatch.getAllNews();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0.wp, vertical: 0.10.hp),
        child: newsCtrlWatch.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: newsCtrlWatch.news.length,
                itemBuilder: (context, index) {
                  final currentNews = newsCtrlWatch.news[index];
                  return Container(
                    height: 10.0.wp,
                    margin: EdgeInsets.only(bottom: 1.0.hp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10.0.wp,
                          height: 10.0.wp,
                          child: CachedNetworkImage(
                            imageUrl: currentNews['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 0.75.wp),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                currentNews['title'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.50.sp,
                                ),
                              ),
                              SizedBox(height: 0.1.hp),
                              Text(
                                currentNews['content'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 4.0.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
