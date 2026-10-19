import 'package:flutter_test/flutter_test.dart';
import 'package:goplay/models/channel.dart';
import 'package:goplay/services/stream_decryptor.dart';

void main() {
  test('fetchChannelStreams decrypts multiple stream servers for Tier-1 channel manifest', () async {
    final bangla = await StreamDecryptor.fetchCategoryChannels(
      endpoint: 'channels/Qk4xNzY3MDIzMTU1NzMy.txt',
      categoryId: 'bangla',
    );
    expect(bangla, isNotEmpty);
    final firstChannel = bangla.first;

    final servers = await StreamDecryptor.fetchChannelStreams(
      linksPath: firstChannel.streamUrl,
      channelId: firstChannel.id,
      channelName: firstChannel.name,
      category: firstChannel.category,
    );

    expect(servers, isNotEmpty);
    expect(servers.length, greaterThanOrEqualTo(1));
    for (int i = 0; i < servers.length; i++) {
      final s = servers[i];
      expect(s.id, 'playz_bangla_ekushey_tv_server_$i');
      expect(s.category, firstChannel.category);
      expect(s.streamUrl, isNotEmpty);
      expect(s.name, isNotEmpty);
    }
  });

  test('Server IDs do not contaminate category channels list', () {
    final channels = [
      Channel(
        id: 'playz_bangla_ekushey_tv',
        name: 'Ekushey Tv',
        category: 'Bangla',
        streamUrl: 'pro/test.txt',
      ),
      Channel(
        id: 'playz_bangla_ekushey_tv_server_0',
        name: 'Server 1: HD',
        category: 'Bangla',
        streamUrl: 'https://stream.example/live.m3u8',
      ),
      Channel(
        id: 'playz_bangla_ekushey_tv_server_1',
        name: 'Server 2: SD',
        category: 'Bangla',
        streamUrl: 'https://stream2.example/live.m3u8',
      ),
      Channel(
        id: 'playz_bangla_somoy_tv',
        name: 'Somoy TV',
        category: 'Bangla',
        streamUrl: 'pro/somoy.txt',
      ),
    ];

    // Filter used in player screen and top header
    final categoryChannels = channels
        .where((c) => c.category == 'Bangla' && !c.id.contains('_server_'))
        .toList();

    expect(categoryChannels.length, 2);
    expect(categoryChannels.map((c) => c.id).toList(), [
      'playz_bangla_ekushey_tv',
      'playz_bangla_somoy_tv',
    ]);
  });
}
