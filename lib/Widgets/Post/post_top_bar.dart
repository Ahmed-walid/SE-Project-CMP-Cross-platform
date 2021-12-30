import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

///[PostTopBar] carries information about post owner
class PostTopBar extends StatefulWidget {
  /// Constructor
  const PostTopBar({
    required final this.avatarPhotoLink,
    required final this.avatarShape,
    required final this.name,
    required final this.blogID,
    required final this.isFollowed,
    required final this.index,
    final Key? key,
  }) : super(key: key);

  /// Link for the Avatar Photo
  final String avatarPhotoLink;

  /// Avatar Shape
  final String avatarShape;

  /// Name of the user published the Post
  final String name;

  /// blog ID of the user published the Post
  final String blogID;

  /// To Show Follow Button
  final bool isFollowed;

  /// the index of the post in the page
  final int index;

  @override
  _PostTopBarState createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  /// Shows modal bottom sheet when
  /// the user clicks on more vert icon button in a post.
  void showEditPostBottomSheet(final BuildContext ctx) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: ctx,
      builder: (final _) {
        return Container(
          height: (User.blogsNames.contains(widget.name)) ? 170 : 200,
          color: Colors.black45,
          child: SingleChildScrollView(
            child: (User.blogsNames.contains(widget.name))
                ? Column(
                    // if it is my post
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): make the request
                        },
                        title: const Text(
                          "Pin Post",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): Make The Request
                        },
                        title: const Text(
                          "Mute notifications",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): Make The Request
                        },
                        title: const Text(
                          "Copy link",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): Make The Request
                        },
                        title: const Text(
                          "Report sensitive content",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): Make The Request
                        },
                        title: const Text(
                          "Repost spam",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): Make The Request
                        },
                        title: const Text(
                          "Report something else",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): Make The Request
                        },
                        title: const Text(
                          "Copy link",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        children: <Widget>[
          PersonAvatar(
            avatarPhotoLink: widget.avatarPhotoLink,
            shape: widget.avatarShape,
            blogID: widget.blogID,
          ),
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!widget.isFollowed)
            TextButton(
              onPressed: () async {
                final Map<String, dynamic> response =
                    await Api().followBlog(int.parse(widget.blogID));

                if (response["meta"]["status"] == "200") {
                  homePosts[widget.index].isFollowed = true;
                  setState(() {});
                }
              },
              child: const Text(
                "Follow",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => showEditPostBottomSheet(context),
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black87,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
