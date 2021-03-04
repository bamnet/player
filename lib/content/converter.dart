import 'package:player/content/content.dart';
import 'package:player/client/v2/client.dart' as api;
import 'package:player/content/html.dart';
import 'package:player/content/image.dart';
import 'package:player/content/text.dart';
import 'package:player/content/time.dart';
import 'package:player/content/video.dart';
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
    {api.Content item, Function onFinish, String baseURL, String style}) {
  switch (item.type) {
    case 'Graphic':
      {
        return ConcertoImage(
          url: absoluteURL(baseURL, item.renderDetails['path']),
          style: style,
          duration: Duration(seconds: item.duration),
          onFinish: onFinish,
          id: item.id,
        );
      }
      break;

    case 'Ticker':
      {
        return ConcertoText(
          text: item.renderDetails['data'],
          duration: Duration(seconds: item.duration),
          onFinish: onFinish,
          id: item.id,
        );
      }
      break;

    case 'HtmlText':
      {
        return ConcertoHTML(
          html: item.renderDetails['data'],
          style: style,
          duration: Duration(seconds: item.duration),
          onFinish: onFinish,
          id: item.id,
        );
      }
      break;

    case 'Time':
      {
        return ConcertoTime(
          duration: Duration(seconds: item.duration),
          onFinish: onFinish,
        );
      }
      break;

    case 'zz_video':
      {
        return ConcertoVideo(
          videoUrl: "",
          onFinish: onFinish,
        );
      }
      break;
  }

  return EmptyContent(
    duration: Duration(seconds: 10),
    onFinish: onFinish,
  );
}
