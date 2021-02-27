RegExp _protocolRe = new RegExp(r'^[a-z0-9]+://');

/// Convert a path into an absolute URL if needed.
///
/// If the supplied [path] does not include a hostname
/// or protocol, the [baseURL] is prepended to turn it
/// into an absolute URL.
String absoluteURL(String baseURL, String path) {
  if (!_protocolRe.hasMatch(path)) {
    if (baseURL.endsWith('/')) {
      baseURL = baseURL.substring(0, baseURL.length - 1);
    }
    if (path.startsWith('/')) {
      path = path.substring(1, path.length);
    }
    return '$baseURL/$path';
  }
  return path;
}
