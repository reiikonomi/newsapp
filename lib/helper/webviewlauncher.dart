import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shopping2/model/article_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;



class WebView {
  BuildContext get context => context;

  
   Future<void> openInWebView(String url) async {
    if (await url_launcher.canLaunch(url)) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => WebviewScaffold(
                initialChild: const Center(child: CircularProgressIndicator()),
                url: url,
                appBar: AppBar(title: const Text('test')),
              )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article cannot be launched')));
    }
  }
}