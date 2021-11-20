import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/Constants/colors.dart';
import '/Constants/ui_styles.dart';
import '/Methods/api.dart';
import '/Providers/followed_tags_sign_up.dart';
import '/Screens/Sign_Up_Screens/Choose_Tag/tags_list_and_colors.dart';

class AddYourOwnTag extends StatefulWidget {
  @override
  _AddYourOwnTagState createState() => _AddYourOwnTagState();
}

class _AddYourOwnTagState extends State<AddYourOwnTag> {
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;
  late List<String> _trending;

  void initializeTrending() async {
    Map<String, dynamic> response = await Api().getTrendingTags();

    if (response["meta"]["status"] == "200") {
      var json = response["response"]["tags"] as List<dynamic>;
      setState(() => _trending.addAll(json.map((e) => e["tag_description"])));
    } else {
      Fluttertoast.showToast(
        msg: response["meta"]["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _trending = [];
    initializeTrending();
    _controller = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBackgroundColor,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<FollowedTags>(context, listen: false)
                    .addFollowTag(_controller.text);
                if (!tagsNames.contains(_controller.text))
                  setState(() => tagsNames.insert(1, _controller.text));
                Navigator.pop(context);
              }
            },
            child: const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Pick your own topics",
                style: titleTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Didn't find what you wanted? Add it below",
                style: subTitleTextStyle,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: 70,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (s) => s!.isEmpty ? "Please add a tag" : null,
                  controller: _controller,
                  maxLength: 30,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // should be with the color theme
                      prefixIcon: const Icon(Icons.add),
                      hintText: "Add Topic",
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(width: 2, color: Colors.black))),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Trending",
                style: TextStyle(
                    fontSize: 27, color: Color.fromRGBO(200, 209, 216, 1)),
              ),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _trending.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      onTap: () {
                        Provider.of<FollowedTags>(context, listen: false)
                            .addFollowTag(_trending[i]);
                        if (!tagsNames.contains(_trending[i]))
                          setState(() => tagsNames.insert(1, _trending[i]));
                        Navigator.pop(context);
                      },
                      leading: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      dense: true,
                      title: Text(_trending[i],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(200, 209, 216, 1))));
                })
          ],
        ),
      ),
    );
  }
}
