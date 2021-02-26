import 'package:flutter/material.dart';
import 'package:player/client/v2/client.dart' as api;
import 'package:http/http.dart' as http;
import 'package:player/field.dart';

class Frontend extends StatefulWidget {
  final String baseURL;
  final int screenId;

  Frontend({this.baseURL, this.screenId});

  @override
  _FrontendState createState() => _FrontendState();
}

class _FrontendState extends State<Frontend> {
  api.ConcertoV2Client _client;
  Future<api.Screen> _screen;

  @override
  void initState() {
    super.initState();

    _client = api.ConcertoV2Client(
        httpClient: http.Client(), baseURL: widget.baseURL);
    _screen = _client.getScreen(screenId: widget.screenId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<api.Screen>(
          future: _screen,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return screenLayout(context, constraints, snapshot.data);
            } else if (snapshot.hasError) {}
            return CircularProgressIndicator();
          });
    });
  }

  Stack screenLayout(
      BuildContext context, BoxConstraints constraints, api.Screen screen) {
    double w = constraints.maxWidth;
    double h = constraints.maxHeight;
    print("Screen size: $w x $h");

    var templateURL = '${widget.baseURL}${screen.template.path}';
    print("Loading template from $templateURL");
    Positioned background = Positioned.fill(
        child: Image(
      image: Image.network(templateURL).image,
      fit: BoxFit.fill,
    ));

    Iterable<Positioned> positions = screen.template.positions.map((p) {
      return Positioned(
        left: p.left * w,
        top: p.top * h,
        right: w - (p.right * w),
        bottom: h - (p.bottom * h),
        child: Field(
          client: this._client,
          id: p.field.id,
          name: p.field.name,
          fieldContentPath: p.fieldContentsPath,
          style: p.style,
          config: p.field.config,
        ),
      );
    });

    List<Positioned> layout = [background];
    layout.addAll(positions);
    return Stack(children: layout);
  }
}
