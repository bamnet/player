import 'package:flutter/material.dart';
import 'package:player/client/v2/client.dart' as api;
import 'package:http/http.dart' as http;
import 'package:player/field.dart';
import 'package:player/util.dart';

class Frontend extends StatefulWidget {
  final String baseURL;
  final int screenId;

  Frontend({this.baseURL, this.screenId});

  @override
  _FrontendState createState() => _FrontendState();
}

class _FrontendState extends State<Frontend> {
  @override
  Widget build(BuildContext context) {
    var client = api.ConcertoV2Client(
      httpClient: http.Client(),
      baseURL: widget.baseURL,
    );

    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<api.Screen>(
          future: client.getScreen(screenId: widget.screenId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return screenLayout(context, constraints, client, snapshot.data);
            } else if (snapshot.hasError) {}
            return CircularProgressIndicator();
          });
    });
  }

  Stack screenLayout(BuildContext context, BoxConstraints constraints,
      api.ConcertoV2Client client, api.Screen screen) {
    var w = constraints.maxWidth;
    var h = constraints.maxHeight;
    print('Screen size: $w x $h');

    var templateURL = absoluteURL(widget.baseURL, screen.template.path);
    print('Loading template from $templateURL');
    var background = Positioned.fill(
        child: Image(
      image: Image.network(templateURL).image,
      fit: BoxFit.fill,
    ));

    var positions = screen.template.positions.map((p) {
      return Positioned(
        left: p.left * w,
        top: p.top * h,
        right: w - (p.right * w),
        bottom: h - (p.bottom * h),
        child: Field(
          client: client,
          id: p.field.id,
          name: p.field.name,
          fieldContentPath: p.fieldContentsPath,
          style: p.style,
          config: p.field.config,
        ),
      );
    });

    var layout = <Positioned>[background];
    layout.addAll(positions);
    return Stack(children: layout);
  }
}
