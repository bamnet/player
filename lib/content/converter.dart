import 'package:player/content/content.dart';
import 'package:player/client/v2/client.dart' as api;
import 'package:player/content/html.dart';
import 'package:player/content/image.dart';
import 'package:player/content/text.dart';
import 'package:player/content/time.dart';
import 'package:player/content/weather.dart' as weather;
import 'package:player/util.dart';

/// Convert an API response into the right [ConcertoContent] subclass.
///
/// The [item.type] field from the API is used to infer which
/// Content object should get constructed. Additional parameters
/// may be used based on the content type being constructed.
///
/// * [onFinish] specifies the callback function when the Content
/// is finished being displayed.
/// * [baseURL] is used to make any relative paths absolute if needed.
///
/// If an appropriate [ConcertoContent] cannot be found,
/// a generic [EmptyContent] is returned.
ConcertoContent convert(
    {required api.Content item,
    required Function onFinish,
    required String baseURL,
    required String style}) {
  switch (item.type) {
    case 'Graphic':
      {
        return ConcertoImage(
          url: absoluteURL(baseURL, item.renderDetails['path']!),
          style: style,
          duration: Duration(seconds: item.duration),
          onFinish: onFinish as void Function(),
          id: item.id,
        );
      }

    case 'Ticker':
      {
        return ConcertoText(
          text: item.renderDetails['data']!,
          duration: Duration(seconds: item.duration),
          onFinish: onFinish as void Function(),
          id: item.id,
        );
      }

    case 'HtmlText':
      {
        var weatherContent = weather.upgrade(item, onFinish as void Function());
        if (weatherContent != null) {
          return weatherContent;
        }
        return ConcertoHTML(
          html: item.renderDetails['data']!,
          style: style,
          duration: Duration(seconds: item.duration),
          onFinish: onFinish,
          id: item.id,
        );
      }

    case 'Time':
      {
        return ConcertoTime(
          duration: Duration(seconds: item.duration),
          onFinish: onFinish as void Function(),
        );
      }

    case 'RemoteVideo':
      {
        return ConcertoHTML(
          html: '<iframe src="${item.renderDetails['path']!}"></iframe>',
          style: style,
          duration: Duration(seconds: item.duration),
          onFinish: onFinish as void Function(),
          id: item.id,
        );
      }
  }

  return EmptyContent(
    duration: Duration(seconds: 10),
    onFinish: onFinish as void Function()?,
  );
}
