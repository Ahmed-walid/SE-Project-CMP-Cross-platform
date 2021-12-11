import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:tumbler/Constants/colors.dart";
import 'package:tumbler/Providers/blogs.dart';
import 'package:tumbler/Screens/Home_Page/home_page.dart';
/// a page for entering the new blog name
class CreateNewBlog extends StatefulWidget {
  /// constructor
  const CreateNewBlog({final Key? key}) : super(key: key);

  @override
  State<CreateNewBlog> createState() => _CreateNewBlogState();
}

class _CreateNewBlogState extends State<CreateNewBlog> {
  TextEditingController? _textEditingController;
  bool isValid(){
    if(_textEditingController!.text.isEmpty)
      {
        return false;
      }
    return true;
  }
  bool _succeeded= true;
  /// post the blog
  Future<void> postBlog(final BuildContext context, final String username)
  async {
    await Provider.of<BlogsData>(context, listen: false)
        .addAndUpdateBlogs(username).catchError((final Object? error) async{
      await showErrorDialog(context, error.toString());
      setState(() {
        _succeeded = false;
      });
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController= TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController!.dispose();
  }
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 1,
        title: const Text(
          "Create a new Tumbler",
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (){},
              child: Text("Save",
                style: TextStyle(
                  color: floatingButtonColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO(Donia): make it random
              Image.asset("assets/images/intro_3.jpg",
                width: 40,height: 40,fit: BoxFit.cover,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                  controller: _textEditingController,
                    onChanged: (final String val){
                    },
                    onSubmitted: (val)async{
                      print(val);
                      if(isValid())
                        {
                          // TODO(Donia): call postBlog
                          await postBlog(context, _textEditingController!.text);

                          if(_succeeded)
                            {
                              final int length=await Provider.of<BlogsData>
                                (context, listen: false)
                                  .get_Blogs().then((final value) =>
                              value.length,);
                              await Provider.of<BlogsData>
                                (context, listen: false)
                                .updateCurrentBlogIndex(
                                length,);
                              Navigator.pop(context);
                            }
                        }
                    },
                  decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    hintText: "name",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  ),
                ),
              ),
              IconButton(
              onPressed: (){
                _textEditingController?.clear();
              },
              icon: const Icon(CupertinoIcons.xmark, color: Colors.white,),
                constraints: const BoxConstraints(maxHeight: 28,minHeight: 28),
              )
            ],
          ),
        ),
      ),
    );
  }
}
