// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/keywords.dart';
import 'package:flutter_application_1/controller/my_authentication_service.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/screens/art%20guide/scr.art_guide.dart';
import 'package:flutter_application_1/screens/landing/pages/comments.dart';
import 'package:flutter_application_1/screens/profile/scr_profile.dart';
import 'package:flutter_application_1/screens/signin/scr_signin.dart';
import 'package:flutter_application_1/utils/my_date_format.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import '../landing/widgets/bottom_nav.dart';
import '../landing/widgets/my_bottom_sheet.dart';

class MyPostScreen extends StatefulWidget {
  final UserData userData;
  const MyPostScreen({super.key, required this.userData});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  final String _userName = "user_0012001";
  final String _imgCategory = "all category";
  final String _userEmail = "user_0012001@gmail.com";
  int _pageIndex = 0;
  final Logger logger = Logger();
  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool _isDataLoading = true;
  String _dropDownValue = "All Category";
  String _likes = "23";
  String _comments = "30";
  final String _uploadedTime = "12, june 2023";
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Post>? posts;
  late ScrollController _scrollController = ScrollController();
  late CollectionReference _collectionReferencePOST;
  late CollectionReference _collectionReferenceLIKER;

// >>
  @override
  void initState() {
    super.initState();
    logger.d("I am Init");
    _collectionReferencePOST = firebaseFirestore.collection(MyKeywords.POST);
    _collectionReferenceLIKER = firebaseFirestore
        .collection(MyKeywords.POST)
        .doc()
        .collection(MyKeywords.LIKER);

    mLoadData(); // c: Load latest 10 posts from firebase firestore

    mControlListViewSrolling(); // c: Post listView scroll listener for control pagination

    mAddCollectionReferencePOSTListener();
    mAddCollectionReferenceLIKERListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.v("Build: Landing Screen");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "My Posts",
            style: TextStyle(color: MyColors.secondColor),
          ),
          iconTheme: const IconThemeData(color: MyColors.secondColor),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: vHome());
  }

  Widget vPostList() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: posts!.length + 1,
        itemBuilder: ((context, index) {
          return index < posts!.length
              ? vItem(index)
              : MyWidget.vPostPaginationShimmering(context: context);
        }));
  }

  Widget vCatAndCap(Post post) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              // height: MyScreenSize.mGetHeight(context, 1),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: MyColors.thirdColor),
              child: Text(
                post.category!,
                style: TextStyle(color: MyColors.secondColor),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(post.caption!),
          ],
        ),
      ],
    );
  }

  Widget vItem(int index) {
    Post post = posts![index];
    return GFCard(
      // color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 5,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      image: Image.network(
        post.imgUri!,
        fit: BoxFit.cover,
      ),

      showImage: true,
      title: GFListTile(
        margin: EdgeInsets.only(bottom: 6),
        shadow: BoxShadow(color: Colors.white),
        color: Colors.white,
        avatar: GFAvatar(
          size: 24,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        titleText: post.users!.username,
        subTitleText: mFormatDateTime(post),
      ),
      content: vCatAndCap(post),
      buttonBar: GFButtonBar(
        padding: EdgeInsets.all(6),
        spacing: 16,
        children: <Widget>[
          vLikeButton(post),
          vCommentButton(post),
          vRemoveButton(post, index),
        ],
      ),
    );
  }

  Widget vLikeButton(Post post) {
    return InkWell(
      onTap: () async {
        mOnClickLikeButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            backgroundColor: post.likeStatus!
                ? Colors.deepOrange
                : Colors.black12 /* GFColors.PRIMARY */,
            size: GFSize.SMALL,
            child: Icon(
              Icons.favorite_outline,
              color: post.likeStatus! ? Colors.white : MyColors.secondColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Likes",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 4,
          ),
          post.numOfLikes == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfLikes}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  Widget vCommentButton(Post post) {
    return InkWell(
      onTap: () {
        mOnClickCommentButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            size: GFSize.SMALL,
            backgroundColor: Colors.black12,
            child: Icon(
              Icons.comment,
              color: MyColors.secondColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Comments",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 4,
          ),
          post.numOfComments == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfComments}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  void mOnClickCommentButton(Post post) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
        post: post,
      );
    }));
  }

  Widget vHome() {
    return Stack(children: [
      vHomeBody(),
      // vCurvedHeader(),
    ]);
  }

  void mOnClickSignOut() async {
    await MyAuthenticationService.mSignOut(firebaseAuth: _firebaseAuth)
        .then((value) {
      if (value) {
        logger.w("Sign Out");
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      }
    });
  }

  void mLoadData() async {
    logger.d("Loading post...");
    MyFirestoreService.mFetchMyPosts(
            firebaseFirestore: firebaseFirestore,
            category: _imgCategory,
            user: widget.userData)
        .then((value) {
      setState(() {
        posts = value;
        /*  int i = posts!
            .indexWhere((element) => element.postId == "C71CC8DQdedbivs0kbXD");
        logger.d("Index is: $i"); */
        _isDataLoading = false;
      });
    });
  }

  String mFormatDateTime(Post post) {
    int currentDate = DateTime.now().day;
    int uploadedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)).day;
/*     MyDateForamt.mFormateDate2(
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!))); */
    const String today = "Today";
    const String yesterday = "Yesterday";

    if (currentDate == uploadedDate) {
      return today;
    } else if (uploadedDate == currentDate - 1) {
      return yesterday;
    } else {
      return MyDateForamt.mFormateDate2(
          DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)));
    }
  }

  void mControlListViewSrolling() {
    // c: add a scroll listener to scrollController
    _scrollController.addListener(mScrollListener);
  }

  void mScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // c: Reached the end of the ListView
      // c: Perform any actions or load more data
      // c: You can trigger pagination or fetch more items here

      logger.w("End of List");
      mLoadMore();
    }
  }

  void mLoadMore() async {
    await MyFirestoreService.mFetchMorePosts(
            firebaseFirestore: firebaseFirestore,
            category: _dropDownValue,
            lastVisibleDocumentId: posts!.last.postId!)
        .then((value) {
      logger.w(value.length);
      if (value.isNotEmpty) {
        /*     List<Post> tempPosts = posts!;
        posts!.clear(); */
        setState(() {
          posts!.addAll(value);
        });
      } else {
        logger.w("No Data exist");
      }
    });
  }

  Future<void> mOnClickLikeButton(Post post) async {
    await MyFirestoreService.mStoreLikeData(
            firebaseFirestore: firebaseFirestore,
            email: post.email!,
            postId: post.postId!)
        .then((like) {
      if (like != null) {
        if (like) {
          // c: like
          logger.w("Like");
          posts![posts!.indexOf(post)].likeStatus = true;
        } else {
          // c: unlike
          logger.w("UnLike");
          posts![posts!.indexOf(post)].likeStatus = false;
        }
        // c: refresh
        setState(() {});
      }
    });
  }

  void mAddCollectionReferencePOSTListener() {
    _collectionReferencePOST.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED new item id: ${docChange.doc.id}");
        } else if (docChange.type == DocumentChangeType.modified) {
          logger.w("MODIFIED Post at ${docChange.doc.id}");
          var modifiedDocId = docChange.doc.id;
          int i =
              posts!.indexWhere((element) => element.postId == modifiedDocId);
          mUpdatePostData(docChange.doc, i);
          setState(() {});
          // logger.d("Index is: $i");
        }
      }
    });
  }

  void mAddCollectionReferenceLIKERListener() {
    _collectionReferenceLIKER.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED one item ${docChange.newIndex}");
        } else if (docChange.type == DocumentChangeType.modified) {
          setState(() {
            logger
                .w("MODIFIED one item ${docChange.doc.get(MyKeywords.email)}");
          });
        } else if (docChange.type == DocumentChangeType.removed) {
          setState(() {
            logger
                .w("REMOVED one item: ${docChange.doc.get(MyKeywords.email)}");
          });
        }
      }
    });
  }

  void mUpdatePostData(DocumentSnapshot<Object?> doc, int i) {
    posts![i].numOfLikes = doc.get(MyKeywords.num_of_likes);
    posts![i].numOfComments = doc.get(MyKeywords.num_of_comments);
  }

  Widget vNoResultFound() {
    return SizedBox(
      height: MyScreenSize.mGetHeight(context, 100),
      child: Center(
        child: Text(
          "No result found.",
          style: TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  vCurvedHeader() {
    return SizedBox(
      height: MyScreenSize.mGetHeight(context, 10),
      child: CustomPaint(
        painter: HeaderCurvedContainerForHome(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  vHomeBody() {
    return _isDataLoading
        ? vPostShimmering()
        : posts == null || posts!.isEmpty
            ? vNoResultFound()
            : vPostList();
  }

  vPostShimmering() {
    return MyWidget.vPostShimmering(context: context);
  }

  vRemoveButton(Post post, int index) {
    return InkWell(
      onTap: () async {
        // m: Call delete method
        await MyFirestoreService.mRemoveMyPost(
                firebaseFirestore: firebaseFirestore,
                user: widget.userData,
                postId: post.postId!)
            .then((value) {
          if (value) {
            setState(() {
              posts!.removeAt(index);
            });
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            backgroundColor: Colors.black12 /* GFColors.PRIMARY */,
            size: GFSize.SMALL,
            child: Icon(
              Icons.delete_forever_outlined,
              color: Colors.black45,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Remove",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}