import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:emarket_app/util/util.dart';
import 'package:flutter/material.dart';

class PostCategoryComponent extends StatefulWidget {
  PostCategoryComponent(
      {@required this.categoryId,
      @required this.actualPostId,
      this.userEmail,
      this.myFavorits,
      this.showPictures});

  final int categoryId;
  final int actualPostId;
  final String userEmail;
  final List<Favorit> myFavorits;
  final bool showPictures;

  @override
  PostCategoryComponentState createState() => PostCategoryComponentState();
}

class PostCategoryComponentState extends State<PostCategoryComponent> {
  final PostService _postService = new PostService();
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  final FavoritService _favoritService = new FavoritService();
  List<Favorit> myFavorits = new List();

  List<Post> postList = new List();
  List<Post> postListItems = new List();
  bool showPictures = true;
  String userEmail;
  int perPage = 10;
  int present = 0;

  @override
  void initState() {
    super.initState();
    //_readShowPictures();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return FutureBuilder(
      future: _loadPost(widget.categoryId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)
                          .translate('same_category_post'),
                      style: GlobalStyling.styleNormalBlackBold,
                    ),
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 3),
                  height: SizeConfig.screenHeight * 0.69,
                  child: PostCardComponentPage(
                      postList: snapshot.data,
                      myFavorits: myFavorits,
                      userEmail: widget.userEmail ?? userEmail,
                      showPictures: showPictures),
                ),
              ],
            );
          } else {
            return Container(
              height: 0.0,
              width: 0.0,
            );
          }
        } else if (snapshot.hasError) {
          MyNotification.showInfoFlushbar(
              context,
              AppLocalizations.of(context).translate('error'),
              AppLocalizations.of(context).translate('error_loading'),
              Icon(
                Icons.info_outline,
                size: 28,
                color: Colors.redAccent,
              ),
              Colors.redAccent,
              4);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/gif/loading.gif",
              ),
              Text(
                AppLocalizations.of(context).translate('loading'),
              )
            ],
          ),
        );
      },
    );
  }

  Future<List<Post>> _loadPost(int categoryId) async {
    List<Post> _postList = await _postService.fetchPostByCategory(categoryId);

    //remove actual displaying Post from the resultlist
    _postList.removeWhere((post) => post.id == widget.actualPostId);
    //fetch image to display
    for (var post in _postList) {
      await post.getImageUrl();
    }

    postList = _postService.sortDescending(_postList);

    await _readShowPictures();

    await _loadMyFavorits();

    return postList;
  }

  Future<void> _loadMyFavorits() async {
    if (widget.userEmail != null && widget.userEmail.isNotEmpty) {
      myFavorits =
          await _favoritService.fetchFavoritByUserEmail(widget.userEmail);
    } else {
      userEmail = await _sharedPreferenceService.read(USER_EMAIL);

      if (userEmail != null && userEmail.isNotEmpty) {
        myFavorits = await _favoritService.fetchFavoritByUserEmail(userEmail);
      }
    }
  }

  _readShowPictures() async {
    showPictures = await Util.readShowPictures(_sharedPreferenceService);
  }
}
