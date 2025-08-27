import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    Key? key,
    required this.allList,
  }) : super(key: key);

  final List allList;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchBarWidget> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List _filteredList = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _filterLogListBySearchText(String searchText) {
    setState(() {
      _filteredList = widget.allList
          .where((logObj) =>
              logObj.notes.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return ScaffoldWidget(
      showAppbar: false,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(5)),
            child: TextFieldWidget(
              name: "search",
              hintText: "Search...",
              controller: _textController,
              prefixIcon: Icons.search_rounded,
              suffixIcon: Icons.clear_rounded,
              onPrefixPressed: () => FocusScope.of(context).unfocus(),
              onSuffixPressed: () {
                _textController.text = "";
                _filterLogListBySearchText("");
              },
              onChanged: (value) => _filterLogListBySearchText(value!),
              onFieldSubmitted: (value) =>
                  _filterLogListBySearchText(value ?? ""),
            ),
          ),
          ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: _filteredList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 10),
            itemBuilder: (BuildContext context, int index) {
              // Todo
            },
          ),
        ],
      ),
    );
  }
}
