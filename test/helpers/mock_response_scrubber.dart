class MockResponseScrubber {

  Map<String, dynamic> scrub({required Map<String, dynamic> json}) {
    return json['data'] ?? json;
  }
}