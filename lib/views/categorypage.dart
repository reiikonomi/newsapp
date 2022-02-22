import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:shopping2/helper/categorydata.dart';
import 'package:shopping2/helper/newsdata.dart';
import 'package:shopping2/model/categorymodel.dart';
import 'package:shopping2/model/newsmodel.dart';
import 'package:flutter/material.dart';

class CategoryFragment extends StatefulWidget {
  String category;
  CategoryFragment({required this.category});
  @override
  _CategoryFragmentState createState() => _CategoryFragmentState();
}

class _CategoryFragmentState extends State<CategoryFragment> {
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  getNews() async {
    CategoryNews newsdata = CategoryNews();
    await newsdata.getNews(widget.category);
    articles = newsdata.datatobesavedin;
    setState(() {
      // important method otherwise you would have to perform hot relod always
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment
              .center, // this is to bring the row text in center
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Text(
                widget.category.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      // category widgets
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: ListView.builder(
                  itemCount: articles.length,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true, // add this otherwise an error
                  itemBuilder: (context, index) {
                    return NewsTemplate(
                      urlToImage: articles[index].urlToImage,
                      title: articles[index].title,
                      description: articles[index].description,
                      url: articles[index].url,
                      content: articles[index].content,
                    );
                  },
                ),
              ),
            ),
    );
  }
}

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
            const SnackBar(content: Text('Article cannot be launched', style: TextStyle(color: Colors.white),)));
      }
    }
    return Container(
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
    );
  }
}
