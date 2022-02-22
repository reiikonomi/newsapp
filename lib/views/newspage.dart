import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:shopping2/helper/categorydata.dart';
import 'package:shopping2/helper/newsdata.dart';
import 'package:shopping2/model/article_model.dart';
import 'package:shopping2/model/categorymodel.dart';
import 'package:shopping2/model/newsmodel.dart';
import 'package:shopping2/model/source_model.dart';
import 'package:shopping2/screens/home_screen.dart';
import 'package:shopping2/views/categorypage.dart';
import 'package:flutter/material.dart';
import 'package:shopping2/model/article_model.dart';
import 'package:expansion_card/expansion_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // get our categories list

  List<CategoryModel> categories = <CategoryModel>[];

  // get our newslist first

  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  getNews() async {
    News newsdata = News();
    await newsdata.getNews();
    articles = newsdata.datatobesavedin;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.green,
          iconSize: 40,
        ),
        title: const Text(
          'News',
          style: TextStyle(color: Colors.green),
        ),
        centerTitle: true,
        /*Row(
          mainAxisAlignment: MainAxisAlignment
              .center, // this is to bring the row text in center
          children: const <Widget>[
            Text(
              "News ",
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),*/
      ),

      // category widgets
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        itemCount: articles.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true, // add this otherwise an error
                        itemBuilder: (context, index) {
                          return NewsTemplate(
                            urlToImage: articles[index].urlToImage,
                            title: articles[index].title,
                            description: articles[index].description,
                            content: articles[index].content,
                            url: articles[index].url,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryName, imageUrl;
  const CategoryTile(
      {Key? key, required this.categoryName, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryFragment(
                category: categoryName.toLowerCase(),
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 170,
                  height: 90,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.center,
              width: 170,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// creating template for news

// ignore: must_be_immutable
class NewsTemplate extends StatelessWidget {
  String title, description, url, urlToImage, content;
  NewsTemplate(
      {Key? key,
      required this.title,
      required this.description,
      required this.urlToImage,
      required this.url,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> openInWebView(String url) async {
      if (await url_launcher.canLaunch(url)) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => WebviewScaffold(
                  initialChild:
                      const Center(child: CircularProgressIndicator(color: Colors.green,)),
                  url: url,
                  appBar: AppBar(title: const Text('Full article'), centerTitle: true,),
                )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Article cannot be launched', style: TextStyle(color: Colors.black),)));
      }
    }

    //String toLaunch = widget.url;
    return Column(
      children: [
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: urlToImage,
                      width: 380,
                      height: 200,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 15.0, color: Colors.grey[800]),
                ),
                ExpansionCard(
                  title: const Text(
                    'Tap to see the whole article!',
                    style: TextStyle(color: Colors.black),
                  ),
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          openInWebView(url);
                        },
                        child: const Text('Tap here'))
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
