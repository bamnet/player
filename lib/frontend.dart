import 'package:flutter/material.dart';
import 'package:player/client/v2/client.dart' as api;
import 'package:http/http.dart' as http;
import 'package:player/content_manager.dart';
import 'package:player/settings.dart';
import 'package:provider/provider.dart';
import 'package:player/field.dart';
import 'package:player/util.dart';

class Frontend extends StatefulWidget {
  Frontend();

  @override
  _FrontendState createState() => _FrontendState();
}

class _FrontendState extends State<Frontend> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(builder: (context, settings, child) {
      var client = api.ConcertoV2Client(
        httpClient: http.Client(),
        baseURL: settings.baseUrl,
      );

      return LayoutBuilder(builder: (context, constraints) {
        return FutureBuilder<api.Screen>(
            future: client.getScreen(screenId: settings.screenId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return screenLayout(
                    context, constraints, client, snapshot.data);
              } else if (snapshot.hasError) {}
              return CircularProgressIndicator();
            });
      });
    });
  }

  Stack screenLayout(BuildContext context, BoxConstraints constraints,
      api.ConcertoV2Client client, api.Screen screen) {
    var w = constraints.maxWidth;
    var h = constraints.maxHeight;
    print('Screen size: $w x $h');

    var templateURL = absoluteURL(client.baseURL, screen.template.path);
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
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<AppSettings>(create: (_) => AppSettings()),
              ChangeNotifierProxyProvider<AppSettings, ContentManager>(
                create: (context) {
                  var manager = ContentManager(
                      client: client,
                      fieldName: p.field.name,
                      fieldContentPath: p.fieldContentsPath,
                      style: p.style);
                  manager.maybeRefresh();
                  return manager;
                },
                update: (context, settings, manager) {
                  // Return a new manager if the server or field id
                  // path has changed.
                  if (manager.client.baseURL != settings.baseUrl ||
                      manager.fieldContentPath != p.fieldContentsPath) {
                    var newManager = ContentManager(
                        client: client,
                        fieldName: p.field.name,
                        fieldContentPath: p.fieldContentsPath,
                        style: p.style);
                    newManager.maybeRefresh();
                    return newManager;
                  } else {
                    // Nothing has changed, keep using the existing manager.
                    return manager;
                  }
                },
              ),
            ],
            child: Field(
              style: p.style,
              config: p.field.config,
            )),
      );
    });

    var layout = <Positioned>[background];
    layout.addAll(positions);
    return Stack(children: layout);
  }
}
