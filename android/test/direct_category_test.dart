import 'package:flutter_test/flutter_test.dart';
import 'package:goplay/providers/app_providers.dart';
import 'package:goplay/services/stream_decryptor.dart';

void main() {
  test('Fetch and decrypt all direct category channels', () async {
    for (final entry in directCategoryEndpoints.entries) {
      final channels = await StreamDecryptor.fetchCategoryChannels(
        endpoint: entry.value,
        categoryId: entry.key,
      );
      expect(channels, isNotEmpty);
      expect(channels.first.streamUrl, contains('pro/'));
      print('${entry.key}: ${channels.length} channels verified. First: ${channels.first.name} (${channels.first.id})');
    }
  });
}
