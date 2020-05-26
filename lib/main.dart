import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:youtube_extractor/youtube_extractor.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
    debugShowCheckedModeBanner: false,
  ));
SystemChrome.setSystemUIOverlayStyle(
  SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,

  )
);
}



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool processed;
  var _videoDownloadurl;
  String _audioDownloadurl;
  var yt = YoutubeExplode();
  var extractor=YouTubeExtractor();
  TextEditingController _txtyoutubeUrlContoller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("assets/youtubes.jpg"),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Youtube Url",
                    labelText: "youtube url"
                ),
                controller: _txtyoutubeUrlContoller,
              ),
              SizedBox(height: 20,),
              OutlineButton(onPressed:_getDownloadLink,
                child: Text("Process"),),
              SizedBox(height: 40,),
              processed==true?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(onPressed: (){
                    _launchurl(context, _videoDownloadurl);
                  },
                    child: Text("Video"),),
                  SizedBox(width: 20,),
                  RaisedButton(onPressed: (){
                    _launchurl(context, _audioDownloadurl);
                  },
                    child: Text("Audio"),)
                ],
              )
                  :Text(""),
            ],
          ),
        ),
      ),
    );
  }
  void _getDownloadLink()async{
    print(_txtyoutubeUrlContoller.text);
    String youtubeUrl= _txtyoutubeUrlContoller.text;
    var id = YoutubeExplode.parseVideoId(_txtyoutubeUrlContoller.text);
    if(youtubeUrl.isNotEmpty){
      //get the video id
      youtubeUrl= youtubeUrl.replaceAll("https://www.youtube.com/watch?v=","");
      youtubeUrl=youtubeUrl.replaceAll("https://youtu.be/", "");
      //after replace, we get the id
      print(youtubeUrl);
      var audioUrlinfo=await extractor.getMediaStreamsAsync(youtubeUrl);
      var mediaStreams =await  yt.getVideoMediaStream(id);
      // _audioDownloadurl=audioUrlinfo.audio.first.url;
      var videourlinfo=await extractor.getMediaStreamsAsync(youtubeUrl);
      _videoDownloadurl=mediaStreams.muxed.first.url.toString();
      print(_videoDownloadurl);
      setState(() {
        //_videoDownloadurl=_videoDownloadurl.first.url;
        processed=true;
      });
    }
  }
  void _launchurl(BuildContext context,String url)async{

    try{
      await launch(url, option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding:true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn()
      ));
    }catch(e){
      print(e.toString());
    }
  }
}
