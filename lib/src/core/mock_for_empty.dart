import 'package:dsf_video_player/dsf_video_player.dart';

const String kMockId = '123';
final mock = PlaylistCluster(
  selectedClipUuid: kMockId,
  payload: <GroupName, List<VideosEntryPayload>>{
    'Goals': [
      VideosEntryPayload(
        clipUuid: '123',
        title: 'Video 1',
        description: 'Atletico MG x Tokyo Verdy, 6 - 6',
        videoUrl: 'https://www.youtube.com/watch?v=P5JfPqtD45Q',
        tumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg',
        offset: null,
        spotlight: null,
        matchInfos: null,
      ),
      VideosEntryPayload(
        clipUuid: '456',
        title: 'Video 2',
        description: 'Atletico MG x Tokyo Verdy, 6 - 6',
        videoUrl: 'https://www.youtube.com/watch?v=2HjOLXOXz80',
        tumbnail:
            'https://cdn.britannica.com/53/251253-050-92856127/Christiano-Ronaldo-Al-Nassr-Club-Saudi-Pro-League-2023.jpg',
        offset: null,
        spotlight: null,
        matchInfos: null,
      ),
      VideosEntryPayload(
        clipUuid: '789',
        title: 'Video 3',
        description: 'Atletico MG x Tokyo Verdy, 6 - 6',
        videoUrl: 'https://www.youtube.com/watch?v=oq8rxYDaJoM',
        tumbnail:
            'https://i.superesportes.com.br/F5i9w8gecx-xqRYdz5Ww2be8uok=/750x0/smart/imgsapp.mg.superesportes.com.br/app/noticia_126420360808/2021/09/25/3939662/20210925232437449140a.jpg',
        offset: null,
        spotlight: null,
        matchInfos: null,
      ),
    ],
    'Assists': [],
    'Ball Carry': [],
    'Goals and assists': [],
    'Head shots': [],
  },
);
