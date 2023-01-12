import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _inputController = TextEditingController();
  final _resultController = TextEditingController();

  _onGenerate() {
    final inputText = _inputController.text;
    if (inputText.toLowerCase().contains('</svg>')) {
      try {
        final html = parse(inputText);

        ///get defs
        final defs = html.querySelector('defs');

        ///get all nodes in svg
        final nodes = html.querySelector('svg')?.nodes;

        ///move defs to top node
        html.querySelector('svg')?.insertBefore(defs!, nodes![0]);
        // final a = html.querySelector('svg')?.innerHtml;
        // print(html.outerHtml);

        final result = html.querySelector('svg')?.outerHtml;
        _resultController.text = result ?? '';
        setState(() {});
      } catch (_) {}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid SVG! Please try again.'),
        ),
      );
    }
  }

  _copy() {
    if (_resultController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _resultController.text))
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied.'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Field Empty!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.white,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w700),
        title: const Text('SVG Converter by Virak'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              onPressed: _onGenerate,
              child: const Text('Generate'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              onPressed: _copy,
              child: const Text('Copy'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                height: double.infinity,
                child: TextFormField(
                  controller: _inputController,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Paste svg code here to generate . . .',
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                  // maxLines: 100,
                ),
              ),
            ),
            // const VerticalDivider(
            //   color: Colors.black,
            // ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: _resultController,
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Result Here',
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
