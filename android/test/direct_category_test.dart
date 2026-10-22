import 'package:flutter_test/flutter_test.dart';
import 'package:goplay/services/stream_decryptor.dart';

const testDirectCategoryEndpoints = {
  'bangla': 'channels/Qk4xNzY3MDIzMTU1NzMy.txt',
  'kolkata': 'channels/S29sa2F0YTE3NjcwMDgwNjY5MDg.txt',
  'kids': 'channels/S2lkczE3NjcwMDgyMjAzNzM.txt',
};

void main() {
  test('Fetch and decrypt all direct category channels', () async {
    for (final entry in testDirectCategoryEndpoints.entries) {
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
