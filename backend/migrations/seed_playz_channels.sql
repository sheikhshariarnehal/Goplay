INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_ekushey_tv', 'Ekushey Tv', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgY5AH5dSDvOfXE6MGR4Ao6aLsW1BeGGOJlemmiCT8cq1rZsxHS5ArCGwUYjJ6mgFatmMK4y4NpG_7UlyAOLKgcRdkDTE16OzglZ1NDLwnzxs5LDN3ubh59lGYTvHJrPdG6UYatrlCl0dMV-ghhab_gBr7GzU7bwYyJHEbPmq72-cQ1yVMO7yAG9WgFqYE/s16000/1000404411.jpg', 'bangla', 'pro/Qk5iMTc2NzAyMzE1NTczMg.txt', 'pro/Qk5iMTc2NzAyMzE1NTczMg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_ekushey_tv_srv1', 'playz_bangla_ekushey_tv', 'Server 1', 'pro/Qk5iMTc2NzAyMzE1NTczMg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_somoy_tv', 'SOMOY TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRL3tAuELgKO6oUCwASBq8VAS_qbOEdpwjwnd6JIXzzOA&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZXNoIFR2MTc2NzA0MDE1Mzk5NA.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZXNoIFR2MTc2NzA0MDE1Mzk5NA.txt', true, 2)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_somoy_tv_srv1', 'playz_bangla_somoy_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZXNoIFR2MTc2NzA0MDE1Mzk5NA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_deepto_tv', 'Deepto TV', 'https://i.postimg.cc/3x8z4MR4/Picsart-25-12-22-10-56-59-829.jpg', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZWVwdG8gVFYxNzY3MDg2MjEzMzgw.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZWVwdG8gVFYxNzY3MDg2MjEzMzgw.txt', true, 3)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_deepto_tv_srv1', 'playz_bangla_deepto_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZWVwdG8gVFYxNzY3MDg2MjEzMzgw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_boishakhi_tv', 'Boishakhi TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5gWAVR1rGn3K2O6T0_4hfjjKpa3_K4QJZSkWJ8yUDVA&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCb2lzaGFraGkgVFYxNzY3MDg2MjU5Nzk1.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCb2lzaGFraGkgVFYxNzY3MDg2MjU5Nzk1.txt', true, 4)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_boishakhi_tv_srv1', 'playz_bangla_boishakhi_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCb2lzaGFraGkgVFYxNzY3MDg2MjU5Nzk1.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_maasranga', 'MAASRANGA', 'https://play-lh.googleusercontent.com/Ls0I7UY9msY-B-HqpMc3fKnfDmMDPzM7J0dpPCCPX680Em_Ovo-bSjqZyc08F4ykNEs', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNQUFTUkFOR0ExNzY3MDg2MzA1NzYy.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNQUFTUkFOR0ExNzY3MDg2MzA1NzYy.txt', true, 5)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_maasranga_srv1', 'playz_bangla_maasranga', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNQUFTUkFOR0ExNzY3MDg2MzA1NzYy.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_my_tv', 'My Tv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaSwWX4Abf8_ewGBl7bJbJKZsg7-oUu5sA2kTDuwO21HyARZZR6QAWtCM3&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNeSBUdjE3NjcwODYzNDgzMjg.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNeSBUdjE3NjcwODYzNDgzMjg.txt', true, 6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_my_tv_srv1', 'playz_bangla_my_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNeSBUdjE3NjcwODYzNDgzMjg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_btv', 'BTV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ_OIeGzpVLyEwc0MBWH63gfabnlcnySdmhDHuTLnbOQ&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYxNzY3MDg2Mzc4MzEx.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYxNzY3MDg2Mzc4MzEx.txt', true, 7)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_btv_srv1', 'playz_bangla_btv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYxNzY3MDg2Mzc4MzEx.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_btv_world', 'BTV World', 'https://i.postimg.cc/Y2QZ4VKj/Picsart-25-12-23-03-06-12-218.jpg', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYgV29ybGQxNzY3MDg2NDM0ODYx.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYgV29ybGQxNzY3MDg2NDM0ODYx.txt', true, 8)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_btv_world_srv1', 'playz_bangla_btv_world', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYgV29ybGQxNzY3MDg2NDM0ODYx.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_btv_chattogram', 'BTV Chattogram', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRH0LsRdDHYdFgUA6Uus-wPC6V5G59KENdmzhDy3mhX_TGU0YAEX1NBTzs_&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYgQ2hhdHRvZ3JhbTE3NjcwODY0NjY2OTQ.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYgQ2hhdHRvZ3JhbTE3NjcwODY0NjY2OTQ.txt', true, 9)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_btv_chattogram_srv1', 'playz_bangla_btv_chattogram', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCVFYgQ2hhdHRvZ3JhbTE3NjcwODY0NjY2OTQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_probashi_tv_news', 'Probashi TV News', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLUC9yUS7xvdNr27M-bGJLasearhB7X1m3HFqwR_exMQYJZWUvW6tohz0&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlQcm9iYXNoaSBUViBOZXdzMTc2NzA4NjU0NzMxMg.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlQcm9iYXNoaSBUViBOZXdzMTc2NzA4NjU0NzMxMg.txt', true, 10)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_probashi_tv_news_srv1', 'playz_bangla_probashi_tv_news', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlQcm9iYXNoaSBUViBOZXdzMTc2NzA4NjU0NzMxMg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_channel_s', 'Channel S', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMJXkjA1gFsPbG9lGvLMXJ8YdiskGipmnYfeRJrN44-sKo3emSvkvyN_k&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIFMxNzY3MDg2NTg1NDgw.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIFMxNzY3MDg2NTg1NDgw.txt', true, 11)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_channel_s_srv1', 'playz_bangla_channel_s', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIFMxNzY3MDg2NTg1NDgw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_deshe_bideshe', 'Deshe Bideshe', 'https://pbs.twimg.com/profile_images/739539785304281088/zMwNO936_400x400.jpg', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZXNoZSBCaWRlc2hlMTc2NzA4NjY5NDc5NQ.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZXNoZSBCaWRlc2hlMTc2NzA4NjY5NDc5NQ.txt', true, 12)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_deshe_bideshe_srv1', 'playz_bangla_deshe_bideshe', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEZXNoZSBCaWRlc2hlMTc2NzA4NjY5NDc5NQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_bangla_tv', 'Bangla Tv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH-uVVAAAgIHb1PBqbV9KF7v3OpuCDLg4EGA&usqp=CAU', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCYW5nbGEgVHYxNzY3MDg2NzM3MDI4.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCYW5nbGEgVHYxNzY3MDg2NzM3MDI4.txt', true, 13)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_bangla_tv_srv1', 'playz_bangla_bangla_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCYW5nbGEgVHYxNzY3MDg2NzM3MDI4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_channel_24', 'Channel 24', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTd6QEug7hTGaCBRSXLscoXSbK4xkoVC3VvWNE_EQLjhBW0aJPHxp2tapA&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIDI0MTc2NzA4Njc3NzM0OQ.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIDI0MTc2NzA4Njc3NzM0OQ.txt', true, 14)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_channel_24_srv1', 'playz_bangla_channel_24', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIDI0MTc2NzA4Njc3NzM0OQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_independent_tv', 'INDEPENDENT TV', 'https://freekaj.com/assets/images/stock/image/2024/01/14/65a43a0c66cd91705261580.jpg', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlJTkRFUEVOREVOVCBUVjE3NjcwODY4MTg2Nzg.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlJTkRFUEVOREVOVCBUVjE3NjcwODY4MTg2Nzg.txt', true, 15)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_independent_tv_srv1', 'playz_bangla_independent_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlJTkRFUEVOREVOVCBUVjE3NjcwODY4MTg2Nzg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_ekattor_tv', 'Ekattor TV', 'https://freekaj.com/assets/images/stock/image/2024/01/14/65a433e7a25e51705260007.jpg', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlFa2F0dG9yIFRWMTc2NzA4Njg1MzYyNw.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlFa2F0dG9yIFRWMTc2NzA4Njg1MzYyNw.txt', true, 16)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_ekattor_tv_srv1', 'playz_bangla_ekattor_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlFa2F0dG9yIFRWMTc2NzA4Njg1MzYyNw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_jamuna_tv', 'JAMUNA TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUSFDf5lXQRMCiCd7L279m0eUqqN7-d6dJLExaEPGTmLYej7FAkPSjraVW&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlKQU1VTkEgVFYxNzY3MDg2ODgyNjk0.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlKQU1VTkEgVFYxNzY3MDg2ODgyNjk0.txt', true, 17)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_jamuna_tv_srv1', 'playz_bangla_jamuna_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlKQU1VTkEgVFYxNzY3MDg2ODgyNjk0.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_atn_news', 'ATN NEWS', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-mNXsJZaKS44HLCN63745yPK0Hhlh4QvSemYmfxPoJ4jI44kA0As60Oko&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBVE4gTkVXUzE3NjcwODY5ODg2MDk.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBVE4gTkVXUzE3NjcwODY5ODg2MDk.txt', true, 18)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_atn_news_srv1', 'playz_bangla_atn_news', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBVE4gTkVXUzE3NjcwODY5ODg2MDk.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_atn_bangla', 'ATN Bangla', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPN-ffiePa_aKKBUsWq3S2nqCpdHjJd94VVIxWIm1XCwdrzopLRUiBz3c&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBVE4gQmFuZ2xhMTc2NzA4NzQwNDcyMw.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBVE4gQmFuZ2xhMTc2NzA4NzQwNDcyMw.txt', true, 19)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_atn_bangla_srv1', 'playz_bangla_atn_bangla', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBVE4gQmFuZ2xhMTc2NzA4NzQwNDcyMw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_ntv', 'NTV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5biJr-hiH7QZN0ctIcu1s-Ds_gWAf6UEn5jZybWYcg10XFbc1uNNu86g&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlOVFYxNzY3MDg3NDMyOTA2.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlOVFYxNzY3MDg3NDMyOTA2.txt', true, 20)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_ntv_srv1', 'playz_bangla_ntv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlOVFYxNzY3MDg3NDMyOTA2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_channel_i', 'Channel I', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRa6Gvr3dIBfcB6u0TCoxFS6OBl-3jqPC4nmdyOEzfVIA&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIEkxNzY3MDg3NDY4NzM5.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIEkxNzY3MDg3NDY4NzM5.txt', true, 21)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_channel_i_srv1', 'playz_bangla_channel_i', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIEkxNzY3MDg3NDY4NzM5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_ananda_tv', 'Ananda TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjARIUM0QyNmdecClg2_bSsq1vPKJup3Pp9xmKIqwjXQ&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBbmFuZGEgVFYxNzY4NzE2NTEwMDk4.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBbmFuZGEgVFYxNzY4NzE2NTEwMDk4.txt', true, 22)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_ananda_tv_srv1', 'playz_bangla_ananda_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBbmFuZGEgVFYxNzY4NzE2NTEwMDk4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_bijoy_tv', 'Bijoy TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV5h2rW-OwrD_J4wZUztePangnyyd-85kghw&s', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCaWpveSBUVjE3Njg3MTY5MTQxNTM.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCaWpveSBUVjE3Njg3MTY5MTQxNTM.txt', true, 23)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_bijoy_tv_srv1', 'playz_bangla_bijoy_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCaWpveSBUVjE3Njg3MTY5MTQxNTM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_banglavision', 'BANGLAVISION', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-QgTkHBs0p94PxAK2dUqI72FgQjSGslfexOY21D9nww&s=10 ', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCQU5HTEFWSVNJT04xNzcyNjMzNzIyMDE4.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCQU5HTEFWSVNJT04xNzcyNjMzNzIyMDE4.txt', true, 24)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_banglavision_srv1', 'playz_bangla_banglavision', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlCQU5HTEFWSVNJT04xNzcyNjMzNzIyMDE4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_desh_tv', 'Desh Tv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwjVSQMrNzAOI0etoBKq-aliKWXD77x9F1IZcS1Mhe8w&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlTT01PWTE3NzI2MzM4MjcxOTA.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlTT01PWTE3NzI2MzM4MjcxOTA.txt', true, 25)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_desh_tv_srv1', 'playz_bangla_desh_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlTT01PWTE3NzI2MzM4MjcxOTA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_gtv', 'GTV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGt_N01rtwlh5_sPZhwFJocI2EhKv2a-ZbRySwX4TNXA&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlHVFYxNzcyNjMzODg0MDA1.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlHVFYxNzcyNjMzODg0MDA1.txt', true, 26)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_gtv_srv1', 'playz_bangla_gtv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlHVFYxNzcyNjMzODg0MDA1.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_rtv', 'RTV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZXP7N3XBlZqSnz1gXpqZ1qK9ZwKccSKE04-mSGrhpeg&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlSVFYxNzcyNjMzOTI2OTY4.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlSVFYxNzcyNjMzOTI2OTY4.txt', true, 27)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_rtv_srv1', 'playz_bangla_rtv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlSVFYxNzcyNjMzOTI2OTY4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_asian', 'Asian', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6ln4rwXBygeF9uP10EegsLUbJYCUwdRyVffG8JBKnyHrKbfk4NSL0QgGN&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBc2lhbjE3ODYwMjk3NDkwNjU.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBc2lhbjE3ODYwMjk3NDkwNjU.txt', true, 28)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_asian_srv1', 'playz_bangla_asian', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlBc2lhbjE3ODYwMjk3NDkwNjU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_dbc_news', 'DBC NEWS', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpIr7yFg0meE5ObzS2syrjfUd3h0AhfvTkspwqrSmxPQ&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEQkMgTkVXUzE3ODYwMzAxMDM1MDI.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEQkMgTkVXUzE3ODYwMzAxMDM1MDI.txt', true, 29)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_dbc_news_srv1', 'playz_bangla_dbc_news', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEQkMgTkVXUzE3ODYwMzAxMDM1MDI.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_duronto_tv', 'Duronto TV', 'https://mir-s3-cdn-cf.behance.net/projects/202/085a3357868699.Y3JvcCw3MTksNTYzLDMyMSw4Mw.jpg', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEdXJvbnRvIFRWMTc4NjAzMDIyMDE5OA.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEdXJvbnRvIFRWMTc4NjAzMDIyMDE5OA.txt', true, 30)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_duronto_tv_srv1', 'playz_bangla_duronto_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlEdXJvbnRvIFRWMTc4NjAzMDIyMDE5OA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_global_tv', 'GLOBAL TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf6Kz6Tfs9Z6XxnQ_QfY-djFonRP1oKnXpOCRO5WMy4Q&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlHTE9CQUwgVFYxNzg4MjQ2NDk0MDY3.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlHTE9CQUwgVFYxNzg4MjQ2NDk0MDY3.txt', true, 31)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_global_tv_srv1', 'playz_bangla_global_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlHTE9CQUwgVFYxNzg4MjQ2NDk0MDY3.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_nexus_tv', 'NEXUS TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6sSM9RgO-Zh8aDCZnXrkrO6Ho4jUdPYhojn6GACIiww&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlORVhVUyBUVjE3ODgyNDY2MzkzMTY.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlORVhVUyBUVjE3ODgyNDY2MzkzMTY.txt', true, 32)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_nexus_tv_srv1', 'playz_bangla_nexus_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlORVhVUyBUVjE3ODgyNDY2MzkzMTY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_mohona_tv', 'Mohona TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSctRBVJQ9ZPdfHr0IC6zI_zyvS2ewlMPNPouKUwEa_wg&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNb2hvbmEgVFYxNzg4MjQ2NzQzOTE0.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNb2hvbmEgVFYxNzg4MjQ2NzQzOTE0.txt', true, 33)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_mohona_tv_srv1', 'playz_bangla_mohona_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlNb2hvbmEgVFYxNzg4MjQ2NzQzOTE0.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_channel_9', 'Channel 9', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiNty1IWhKB2tY8xhm1Np_X4MV2KFx8g3jdZSUgz1wQw&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIDkxNzg4MjUyNDgxODQ4.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIDkxNzg4MjUyNDgxODQ4.txt', true, 34)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_channel_9_srv1', 'playz_bangla_channel_9', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlDaGFubmVsIDkxNzg4MjUyNDgxODQ4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_sa_tv', 'SA TV', 'https://www.satv.tv/wp-content/uploads/2021/08/satv-logo-1.jpg', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlTQSBUVjE3ODgyNTI1ODY2MjY.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlTQSBUVjE3ODgyNTI1ODY2MjY.txt', true, 35)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_sa_tv_srv1', 'playz_bangla_sa_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlTQSBUVjE3ODgyNTI1ODY2MjY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_ekhon_tv', 'Ekhon TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWZ9s6yG_kZUdvDGuZzVMSLWXWsGfWzWkK2aMsqs5h9g&s=10', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlFa2hvbiBUVjE3ODgyNTI2NDk4ODA.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlFa2hvbiBUVjE3ODgyNTI2NDk4ODA.txt', true, 36)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_ekhon_tv_srv1', 'playz_bangla_ekhon_tv', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlFa2hvbiBUVjE3ODgyNTI2NDk4ODA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_bangla_news24', 'News24 ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLaZNezL94GTQ_d7ieXwaV4zoadQYKuK8m6w&s', 'bangla', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlOZXdzMjQgMTc4ODI1MzQ5OTIyNA.txt', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlOZXdzMjQgMTc4ODI1MzQ5OTIyNA.txt', true, 37)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_bangla_news24_srv1', 'playz_bangla_news24', 'Server 1', 'pro/UWs0eE56WTNNREl6TVRVMU56TXlOZXdzMjQgMTc4ODI1MzQ5OTIyNA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_zee_bangla', 'Zee Bangla', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOaSGgArMtdJBaRP8TjsqmPtIOHB7FqIIpleMNSy0blA&s=10', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYTE3NjcwODgzNDU3OTQ.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYTE3NjcwODgzNDU3OTQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_zee_bangla_srv1', 'playz_kolkata_zee_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYTE3NjcwODgzNDU3OTQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_star_jalsha', 'Star Jalsha', 'https://assets-playztv.pages.dev/category/Kolkata/sj.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU3RhciBKYWxzaGExNzY3MDg3ODIyMDk4.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU3RhciBKYWxzaGExNzY3MDg3ODIyMDk4.txt', true, 2)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_star_jalsha_srv1', 'playz_kolkata_star_jalsha', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU3RhciBKYWxzaGExNzY3MDg3ODIyMDk4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_colors_bangla', 'Colors Bangla', 'https://assets-playztv.pages.dev/category/Kolkata/cb.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQ29sb3JzIEJhbmdsYTE3NjcwODg0MjY3NDM.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQ29sb3JzIEJhbmdsYTE3NjcwODg0MjY3NDM.txt', true, 3)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_colors_bangla_srv1', 'playz_kolkata_colors_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQ29sb3JzIEJhbmdsYTE3NjcwODg0MjY3NDM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_sony_aath', 'Sony Aath', 'https://assets-playztv.pages.dev/category/Kolkata/sa.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU29ueSBBYXRoMTc2NzA4ODU3MDA4MQ.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU29ueSBBYXRoMTc2NzA4ODU3MDA4MQ.txt', true, 4)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_sony_aath_srv1', 'playz_kolkata_sony_aath', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU29ueSBBYXRoMTc2NzA4ODU3MDA4MQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_jalsha_movie', 'Jalsha Movie', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiGT1RQx3LxNgG20otZo7gTgkGGu_uMjrcHcdhB-kRMg&s=10', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnSmFsc2hhIE1vdmllMTc2NzA4ODk1MTQ2MQ.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnSmFsc2hhIE1vdmllMTc2NzA4ODk1MTQ2MQ.txt', true, 5)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_jalsha_movie_srv1', 'playz_kolkata_jalsha_movie', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnSmFsc2hhIE1vdmllMTc2NzA4ODk1MTQ2MQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_rupashi_bangla', 'Rupashi Bangla', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT334YZnRK-kX_8r6I_VSVeh9bXQHdgmmDeHMJOsAQDcw&s=10', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnUnVwYXNoaSBCYW5nbGExNzY3MDg4NTk1MTI2.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnUnVwYXNoaSBCYW5nbGExNzY3MDg4NTk1MTI2.txt', true, 6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_rupashi_bangla_srv1', 'playz_kolkata_rupashi_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnUnVwYXNoaSBCYW5nbGExNzY3MDg4NTk1MTI2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_akash_aath', 'Akash Aath', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIdAYrLEBViwbxCC2uJC6VXFw4Wsnmek_yF6vwKYSitg&s=10', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQWthc2ggQWF0aDE3NjcwODg2NDM1MTI.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQWthc2ggQWF0aDE3NjcwODg2NDM1MTI.txt', true, 7)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_akash_aath_srv1', 'playz_kolkata_akash_aath', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQWthc2ggQWF0aDE3NjcwODg2NDM1MTI.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_enter10_bangla', 'Enter10 Bangla', 'https://yt3.googleusercontent.com/ytc/AIdro_kUVgsElgaFpQZNYILWQ0HLa-MAmbEjWNRBRqKms5qML2Q=s900-c-k-c0x00ffffff-no-rj', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnRW50ZXIxMCBCYW5nbGExNzY3MDg4NjY2MjYz.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnRW50ZXIxMCBCYW5nbGExNzY3MDg4NjY2MjYz.txt', true, 8)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_enter10_bangla_srv1', 'playz_kolkata_enter10_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnRW50ZXIxMCBCYW5nbGExNzY3MDg4NjY2MjYz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_sun_bangla', 'Sun Bangla', 'https://assets-playztv.pages.dev/category/Kolkata/sb.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU3VuIEJhbmdsYTE3NjcwODg3NTk4OTM.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU3VuIEJhbmdsYTE3NjcwODg3NTk4OTM.txt', true, 9)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_sun_bangla_srv1', 'playz_kolkata_sun_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU3VuIEJhbmdsYTE3NjcwODg3NTk4OTM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_khusboo_bangla', 'khusboo Bangla', 'https://assets-playztv.pages.dev/category/Kolkata/kb.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURna2h1c2JvbyBCYW5nbGExNzY3MDg4NzgyNTQ4.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURna2h1c2JvbyBCYW5nbGExNzY3MDg4NzgyNTQ4.txt', true, 10)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_khusboo_bangla_srv1', 'playz_kolkata_khusboo_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURna2h1c2JvbyBCYW5nbGExNzY3MDg4NzgyNTQ4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_dd_bangla', 'DD Bangla', 'https://assets-playztv.pages.dev/category/Kolkata/db.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnREQgQmFuZ2xhMTc2NzA4ODgxNTA5OA.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnREQgQmFuZ2xhMTc2NzA4ODgxNTA5OA.txt', true, 11)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_dd_bangla_srv1', 'playz_kolkata_dd_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnREQgQmFuZ2xhMTc2NzA4ODgxNTA5OA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_sananda', 'Sananda', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTylaokf1TCdYunrrVZdAbn9A1lolFbzxMEmLAOGipEbT9xQaqF4-eo27nn&s=10', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU2FuYW5kYTE3NjcwODg4ODQxMTU.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU2FuYW5kYTE3NjcwODg4ODQxMTU.txt', true, 12)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_sananda_srv1', 'playz_kolkata_sananda', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnU2FuYW5kYTE3NjcwODg4ODQxMTU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_bangla', 'Bangla+', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQshDlozqT2hxQaCWgBf6Fv4aXNjPXKrp9YeA&s', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQmFuZ2xhKzE3NjcwODg5MTM4NDg.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQmFuZ2xhKzE3NjcwODg5MTM4NDg.txt', true, 13)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_bangla_srv1', 'playz_kolkata_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnQmFuZ2xhKzE3NjcwODg5MTM4NDg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_zee_bangla_cinema', 'Zee Bangla Cinema', 'https://assets-playztv.pages.dev/category/Kolkata/zbc.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYSBDaW5lbWExNzY3MDg4OTg1NTY3.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYSBDaW5lbWExNzY3MDg4OTg1NTY3.txt', true, 14)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_zee_bangla_cinema_srv1', 'playz_kolkata_zee_bangla_cinema', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYSBDaW5lbWExNzY3MDg4OTg1NTY3.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_zee_bangla_sonar', 'Zee Bangla Sonar', 'https://i.postimg.cc/GmzS2s5Y/zbs.jpg', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYSBTb25hcjE3Njg3MTkzOTE0NjA.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYSBTb25hcjE3Njg3MTkzOTE0NjA.txt', true, 15)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_zee_bangla_sonar_srv1', 'playz_kolkata_zee_bangla_sonar', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnWmVlIEJhbmdsYSBTb25hcjE3Njg3MTkzOTE0NjA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kolkata_discovery_bangla', 'DISCOVERY BANGLA', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcmEREIBDMfqbBjddQKkP5IBWeyVfmIFMEPAWXV1KEiA&s=10', 'kolkata', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnRElTQ09WRVJZIEJBTkdMQTE3NzU3MjA0Njk4NjY.txt', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnRElTQ09WRVJZIEJBTkdMQTE3NzU3MjA0Njk4NjY.txt', true, 16)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kolkata_discovery_bangla_srv1', 'playz_kolkata_discovery_bangla', 'Server 1', 'pro/UzI5c2EyRjBZVEUzTmpjd01EZ3dOalk1TURnRElTQ09WRVJZIEJBTkdMQTE3NzU3MjA0Njk4NjY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_cartoon_network', 'Cartoon Network', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4tjJ7hifFIfe3242PTvV_KX27ocHjgam4MLXphtyJRg&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uIE5ldHdvcmsxNzY3MTYyNTI0MDI5.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uIE5ldHdvcmsxNzY3MTYyNTI0MDI5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_cartoon_network_srv1', 'playz_kids_cartoon_network', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uIE5ldHdvcmsxNzY3MTYyNTI0MDI5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_disney', 'Disney', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTapLxqSPj9fsdSNUQWzvrXcah9VDKF2-CBTZvFF4AEDQ&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EaXNuZXkxNzY3MTYyNTk1OTUz.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EaXNuZXkxNzY3MTYyNTk1OTUz.txt', true, 2)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_disney_srv1', 'playz_kids_disney', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EaXNuZXkxNzY3MTYyNTk1OTUz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_wow_kidz', 'WOW KIDZ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvkwYHTOiE_vHKL5HzaPQN6jsOP4_Hi7_Y_wwMFCj61g&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1XT1cgS0lEWjE3OTAyNDA5NjIzMjU.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1XT1cgS0lEWjE3OTAyNDA5NjIzMjU.txt', true, 3)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_wow_kidz_srv1', 'playz_kids_wow_kidz', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1XT1cgS0lEWjE3OTAyNDA5NjIzMjU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_nick', 'Nick', 'https://i.postimg.cc/NLhH7J9H/Picsart_25_12_24_19_58_42_811.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1OaWNrMTc2NzE2MjY5OTI1NQ.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1OaWNrMTc2NzE2MjY5OTI1NQ.txt', true, 4)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_nick_srv1', 'playz_kids_nick', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1OaWNrMTc2NzE2MjY5OTI1NQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_tvcarib_kids_teens', 'TVCARiB Kids & Teens', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTwulzwLTra2aiTtAzqMaGp7IVnLEJPHTR0fe0CXtCxvnVYrL0MHJLesU&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1UVkNBUmlCIEtpZHMgJiBUZWVuczE3NjcxNjI3MjI0NzU.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1UVkNBUmlCIEtpZHMgJiBUZWVuczE3NjcxNjI3MjI0NzU.txt', true, 5)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_tvcarib_kids_teens_srv1', 'playz_kids_tvcarib_kids_teens', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1UVkNBUmlCIEtpZHMgJiBUZWVuczE3NjcxNjI3MjI0NzU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_duronto_tv', 'Duronto TV', 'https://i.postimg.cc/8cfhcC8h/Picsart-25-12-22-10-35-04-231.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EdXJvbnRvIFRWMTc2NzE2Mjc0NTQ0OQ.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EdXJvbnRvIFRWMTc2NzE2Mjc0NTQ0OQ.txt', true, 6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_duronto_tv_srv1', 'playz_kids_duronto_tv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EdXJvbnRvIFRWMTc2NzE2Mjc0NTQ0OQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_pbs_kids', 'PBS Kids', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMAAAADACAMAAABlApw1AAAA4VBMVEUmOMT///+ZzxYlN8Wf1wCd1AAAAL0kNcUjNMai2wAhMscbMMP19vweLskgMcj8/P4ULMIAHsDX2fHv8PoaKcsOKMHj5PXe3/QAFb8uP8aUmt3O0e+vs+VNWctjbdCDitjBxOp1fNQ/ScgWJM0PHc9VYMy1ueebod98hNfIyuwLGNFrdNKprOMwRbw/TchOVMksQL9RcJuPwjFVdZltlXdHY6hCXK6UyCpWd5SFtUxxmnKArliLvEE1S7lEX6pNa6B4o2VKZ6RafI9fgoo6UrVlioV8qV90nmw+V7BqkYEAANZ+kRVOAAAYhklEQVR4nNVdCVfquhauhJJCB1qgQEHGMioiIooIKgJO7///oJfSOUMtyDnes99a963lAbK/ZM9Jdriz01I2K0n50vC837jsXrcNg+OA0R53W4PKebNalKRs9sQDcif8rXwpN+wPanoqVS5ruipCCDhEAEJR1TWtnErp41a/mSvmTzjoqQBIuWZ/MNYQ4+KeazoBUdfKem2AUJwKxEkA5JuVVk2M5j2MQqxdVprFU4z9cwDSeatm6DGZD4DQjVrr/Ofr8FMA1bqI6CDmfRCIutVfBCCVKlpKPYp5D4Sa0iol6VcAFIeXmgZ/wr1NUCvXf6AOxwLIjeop/UeT7xNahu6o9FcBlBo1XT0N9zapeq1yHIRjAEiDtnqc3kaQqLYbx+jC4QCkvqCeQPQJAlAV+odDOBSA1APlU0++j6EMeod6hsMAZKuXqT8x+x7BVL16WLh3EIBiRdT/JPsW6eph2nwIgF73VIYzioBeOz9gEeIDkFrwZ143NonCZXxljg2gWv5L7HOWZyvHDpFiApAqqb/G/h5CqhJzEeIByNW1v8m+RVo9dzoAves/bnxI0q97pwJQMU4a98QllaucBsBA/6O+i01Qb50AQL7718Xfp0L328jiOwC57i+Iv0967TtV/gZAtfaL879HcD38CYDm+Ffnf4+g3TweQJX7FfMTJhVErkEUgKEh/jb3FolGFIIIAE3uP8E/QgAipIgNYNj+D8iPTeqYHdsxAeR+I3xgUYQ1ZQHI1/5D/KPQrsbyaCwAv+u/SNK7hwEY/MB/AQCgIBdMs3PhUMcsyAL8WUKhDQ4BUDly/gHMKArkjMnuZTtbL1fTeSKRmM9Xy9ntzuCsfzqedHpsSgXQM44aKSMrk93zzex9lUimk0me5xM28XwynZ6uHz45+fhlgAY1P6ABKF0fZUCVz9uv9Yq3OE/QKJmcf7zI8tEI1GuaKaIAkC6PE6DOe4Jn8O5hmH/cF46WI71OyZMpACpsBUb6yZaBzjIZyb0tTdOtLByLQKOoAQmgSqk/QCgollkxZVk2LZuiUGyKOYsBAEF4jNRlZAfkwp7kDMRHSZEemQCQ1bAvoR8UjKvd7Ww5TfDpdJKfr9Zvd1dGRsE+WNjGApBILxXWGkAFDXW/nX2s1x+zzfPVhFMywVFAmRAiAkArpMBQLhi7l7f3ucV50KgklptPGLYp8k08AIn0Wqavgczdb94TyIChsdB/0vxidvPJBZVGbeFVRxxAL7hqGRPebT+QYaGoJp+czu4UJTj8czoegETyrUBhXzBfHqfhodDIq8fbielBAOJ5NIBi11sAWDB3X8sp27Dw/PTxKmAVhae4ABLzO9KaFiaPc9pE8YnlljPdaRW7xSgAWc8FCx35wRL6aEb46XPHFzcuNgB+DXEhMp8XzJlKrB7MjPM5vZKNAFC1C7hQMccfiW9suk3ph44nc4U4X7Bp/hJeAlC4jZys5GLiqAJQq2wA+bq1ACAzeX5Px1TIRPLL00gzNv+J5CMXNgAP3yw2n94YttnT63kmgF7K4p97WfJx2bfoTXAQmFOMCaQ/e3tC8savdpkA/4XX74QVYV5+2lOV6rEASMCyz/AqjkcN8DK/cWyRiUvxdPkx+/r6elwkyF98DRgwZUJTX2Kg1e3ebgtAYgDol/dCBt8OAoB++MmezcIyzEby7slQkEcFT3eP+JfS24AzixWEWFP1tjcZ5T4dgCTYYim/HMQ/YnRmz2ZhHQaQntgRB0pvhDtsipOPflRVuI2r/fzM3E+xRAXQcFxAZsc0aAxKP+2ns/AYnsj0zptlULgP/xu/NFwAEKzijpdcXVjfUBs0AKW2o4tAeDwQQPJ9v7TyFwbgM1BY6nyE/pFfTFzjVdjGH2mynxLYLlEAVDwfzPxFnuWWk4b1wzIWzaWDipr5DLk5fuVmfZB7jy1BWzsEAWqFBFDqetMlP09pTPLzxXK5mNMCo+TWkk35AQMQ9Fbwah4G4K6AfEcbjcr/0gUtdksEgJG/iQ25Jc4kn54/3tzvnp6e7m/fSZPB72VTuQ3HEsnbIIBJSNL5hasD8pYaKpKJKYpb3BUF+ggHUKwHwmjzg2DwdQIzSkYQBEURbsiYZ36FLKn4igF4iACwdlwxND4IAChYn83W0yQ2zsb/ObVexAAMU/5YnHxLALjy0xdgfpJzdoukM3OPAdgEomZMhNJvjjQIO9wG8dMHlPWZ5kXhZRFw0PyHGYg+UsMwgHAiL0zmCexHP0OenzTcXyahp0gzAgCUu7ASvzjikLnHx5runPgQyBf3766P5pehLEh3TyM4AErhQ0Ad3BMkb4MAoEEoybpDJgRBABCLM6b3DgDlFf+pr4uALBRe7KGSCxBMnlByWQoBwCoRJmbRPWfrTucDvuzLAkAAwt8KJF6KGY5P+OWVM58ZXKP4m2C6BgpXb0iOkssnLAVyKxQOAOz8pPKJAeAXoeRaucdMH7+EFgAsFnozbSaUzgQzC/yby0/mAR9qa4Z4ycgv0/T7U2gCrSXVggCqKeyfL3BTyYcACE+YDPELjgJgti/v/q/ziSeL/NTLKZUNPtTCDJc7gLzbTDIcTk6JxQZQx2uJF7iQp0NaDLk1DgDFZvAJYyWZ5qereSKdJky6b1FEfAVQxFbAyi4ZWhVDrfsAJAH/AFHjCRcSIMCMN7IRFgDcoLBo+ulJROaF9ItfkxgVVChIHoAecQo0s8NV670T/PIEi1/4d5Mw9WwKirlyT/n391cTl3mCgNjzALSI7UggEDlewLghJce8D/94AID0rOBPGOnIrJ+bznad7yCILRdAvkbupyp4iJg2AoIp42Y0YTldeBUvLHvLBCQWco+UdIznpx+7TrQgift9MwtA08AlCMkQoQQvvhJkrvD0fW4JdTwA/OrzIqhyhQfWJ5f3F3j9NUjAaDoAaBtKyj1unh89JVAAkcPuo9GYK8Cn368CawAnhFv3Prh4hhEQ9ptOCEC+RQEgPOHMrBwAgvy0xMPRpBUKxRahRHJ+C3yBZC8BiqrfnzOkC3ABtPJ7ADmKCpB2JjHdZxMZc7JZEUKb3DsaSEgWk7HEG/DWAIpr9teS89kTrRJskWhtfyMATdpReiDgxZX5q6wUOru3JVmD4pd7ExUfgIXA11Al6ns8v7jvkPzZPDb3APrULSWZCJk3F59ber03bZfZDgCAGHv1EchPUXVYfrox6YqgjSwA+QF1T4+WqrJS+g/bZNMBMGvOAa7kz+jS4rZARaAP8ghAkaYCSNif4laH+KlTmSMAzFeL9/XHejGdU/hLzgJRp0xzZ4EhtlRjJNaKCECOfiQdQDJXZdCD4zNxK5T8+t9FB9GFudu8U6qfwQhMflpHLsINzakBPYcADPFQ2qHCVzz2+UfOrfBgoYQXAALFFG5I2/UQNC8y9zZnV0j5+RVtYxBlxlyWrsNW4hsrsuGXEzdoYQKw/q3wucBdYyg+RP7leUnE3f5vrYOxmEvaKMtl6TpMybroP7zy+CcBbENTfIdNCL8KR/FANm6nzEVIPlEcmj7IchJdh60oK4YW86uOv7R4PhAqqyA5wjfCpzuMJygrG9ZOAbZeNok1iZOYN8I6MWqWH2YwsMQyslBhixIyTMm9SmDKb4ytxX3tDP+4KHF5hg5bpYlvuOen29CeO5ET34YYlF8wGcJ3+uxZMI3tkroMD5SQIpXnSkwA8k00+/z7XThXxcsq6dcwgFdMqeZU28gJBeOGVn99NMnPpkrcsMwCkIlKcfn06maCHV/CC1vp51BSJd/gK+ABAJ3QTMDCZEvWdt8pAMpD7px5uAaYTAB8er6ZEEc2BCyRDuzQWFR4w7Mgd4WEzrsSFnCBXH5+SbmFpJ1zLDfAUWor9g+h/70/m5RKB14bTV8FP6MQ0cLUKdWI8iq94MIIQGGDF//8PZ0AgD7XYB/PIgqMFvfT1ftGvKAKb+YOq40GRgTy5AN3ZCvbhStWpZXHa29ELMYvrkgAeoNrsc/Hya84gPnj5hl0WIfGlBcsU3P21jmQKcj3a6KAZQt1ZrLPZ5LL+5CVAfIjDoAjx1VbXJ19wps4vcFPLwoRx60UrMg2f7kSTbODAO9uH0kfy+/9HOQe3QW57QR1pjDDa2eUmFqsc92I819EhTQdeZtPxsuc09Vi+f6+Xi5Wc1oqsc8q5TePw/mj4ecIApHTflCsEOxy7QiWLvAEJX0fVW2SiS1+3iWSe5QGWbGBGawsWotQsDfAoYnvEiW2FEcG2lzUGVcT1zu3YE6nQrxTf+5vWaGcHHYdfHq64aCQUQQBN0J26YkAYHCUopbPEV7d4peM/Nr+eOwUKOFUYhSiEMOn+eXXw+3XithIXNFO/SIAUaTc4z8zpUXlHoDYO9b7bVbICdQ9buucMrkZzc+i5o5BcEL4c8Z5QxtA/DMW+z1fIB9wyICaD1gUtQYAEEeYorTYjLvljgzOLXIRymucY0LON1b0tTc4in/2AUA8mOBppsADEHd/g0/cWjZduGJVRUli2D844cZR54AhYVfWEZJoxq3DzHe2MZOZdV2ckh/0iYNj7joKQIbYgVuxAUAh3rmrxGLicoMQxPvOlKEBsBYVShDb6wmrxMs8ey5cxTg3yvOLbcaXBjnmWZuHDN3ao1AiIpijbWDNn5nbJsouSTF/YfbTi+1TyJAp3Nf3Bxb5GWDICQrmIsJpa6+PqHbSMlObgHH/8LiwDrjTYSTTifXrFV7uh5lXsuSF8f8BWcuOwumIhMZKEgnT/sUOJkAGkbK7eftYzPe3aPZkH0RP86vZHZApsSxQhOgQJD0zmXqKEppzZk7MWVYK33vg1xF21GIHiHLBvLi4MI3d8+vLzcNms908vHxynQuTtVsEOpMls4rNJ24ivH/5nGtGAQAQT8r4ZZTjCH5VUGTZuYtBv/ERoEznbj2lxKw8P1/vomas3Iwoq1hEnAfjV5/MPaufkCw/vy3D5/GQ7E0/bjKRe62pUkRha/+74WoairOmz9/uoR9FQC48vb6tV7yjO2l+ut7eQ/rOhkepfERp0aJANQ0xn1zNXp+i4u+fkSALk6fd8/ZtNvvavn4+Tb69+meVFpnF3T0pz3s7ap1CR8xzSJiFP9ljBUArm0HKo8hKhrgjQZJV3GWW1/eU2S0S8+lqvfk0L8wf3CP8Q2SV15kbHHuCk83meWJ2ClF7/r9HWj/LnbGLoxbBQlQh5bepPGRv8v0LZG/yMbZZ/wWyt1kZG92nIuv+KLQp6ibpUWRvdJ+NTtU+BYiqbpG/okDXoWFM2mOL2hMDHtpYNZrsowZnzR+Zdn9W4aR72Ro0Gi3/ID9oVUa95rCas6g67PUbVmvbo6/j4kM7hz2ox23ifN/qAFzWvQthWr+Ytw4SZnvukgKO6CMq5XqV9omaHbrHbagHnr4jqKXKVvfi6tBbgrJ7v2voigngaE37pFJfZ41oqUtsHtwDT8f0MBDbjWE+L2XR+nluxLtvXXUL+QDQG3JkS3XKIkA9ldIAB8vo/2JJtXvkjHroj6DQbXQgeu1afPnT3btFuWvB/Q6zJ8pIxGZaEMVGzj5SL1X71zE6EfuH/mjHLsMftTpFG20fp+rdZwxE485Z4MB1nAgA4YvLaIRxP3RLtdjvct+0FvSPXVIOvoZIh91Wo98buhfN0HDeXbpATUCsuYO7R7GjAJyFclmxSwibdF7Hb8djAFpnZ8yjx0FSW027sbInasLYtS7FwKVUOHFX5dID4FwUyVbPe73eMGyTAu1PxGta2+P8uRYxs8Gjx+Th7yB5PUE8e+vfpKsEqkpQdAd2zZoHQBqgzxntbj3Ykzbvb9qlGG2bqxzbvgQPf5PH74Mkuo1l3JkFmqsB4ThKcxfflSsA3as6Dd2KKERVbAfu0vZc/dEZjV8C9oCk4PF78gJEkIDh8usw5venCN9cKTt/zbp/Bl5vKU9VhLJ/Cc8zHilvXbKSFNJliR2ohS5A4FdQwgA4dx5He0sqqN78jEMyWs7jACABgAOevztzcym16zJd6rcuG+c5X6CaTKcdvoIS1Y4EyZA7acP9lqbHgYR9S3MH7hMAAr5SNDz+mrah1Nx7/vl2WVf1stbtO9ar1GZqMXYJqBQVnqgtd82tWrzm9ZOtYsZLcwOHPiFCQWfv32d2rELZ7RXhnD8Earm913aJ3WcQv4Yl1SPCCdFr2Yg8FPS6vmXxNlaaa/X9FXA/GwQgGC4Axyp4S+qroqjXc8ifsOUCvwjHPHy5H9Fr7DNQgObNH1FV1d35HuF+IBxupVyRd1TUA5CtpLw4UK9VovqspdyxqJdBMQKcu8Y9VR+4AiQRkHWXkXMnTPA9cRiAOx9ZW7c1v9dFteu1VhajvBh5GTR4HZcg3Z31nOa5zGyX+H3vjmzPiAbgBRi2FRDavnvL9urG9w1aKddxgxeiSQANZ4qyfjvlERl+eC67SQBoRAHgysFWhFJzEOF/baJdiA5FBRj5C+aNNJyQLtK7KN50SvAsAJ4ddf4sGKG2QdJwUI5cBOqVdL8pAEnCGI8Vsw1KHygvRBq2XQDuRDWilNiyKeGfl5paVHBDbwrgtWWgINabZziNdELkVDekqTqbz15KGSrAim33N3zLoePNyqVxhGult2XwGmNQqIy3JbJGb+NqL7rzWHVCMMA5DkQKpt1lTwFzY08OtTHWth99hcUOEOiNMZzWJDTSaa9L5AcwvAiim5LlPADO1/KBC+MC8FSgF5hlVa2E5ZRt2FmtSc4k1m5sIIUMUnYU7qjtA3DCTA9AgBmgjTwVaATFBJbH/dAqVBlKCZnNYfwAnfjOhJpxZJuhpqpe4lDyAGRdAO5aAc3zhGdF7LSYoI0bwRx0QDfs7PY8ToMkGpV9tQ+9KJZvB7WTAOBGPTnXyYipgDCOHJEFXvYuqkZAm3scTQuiGiS5LaooqD0zVBoPQvow9nXNy+pdp+gBqLZ1RVRVXQu2S5ScCBjqdd8pAlXzhsrTyj1AjGhRFWgShpEXwuW7WtkI1dsG3qMuwrXzp6IDAI7dP4wqDauwEZo7Z7lFo4miP18UoeZZKdqJyugmYd7QxNcuXWlGmbiq9wKLIFXce5EEAIHVptWini1AcF+e6nV9t+LLCAXAN23amBUWcewmTVYID/VKYC4lt8pGAFAxB0sbyAlhi5WxG316ACgiBCDedBQHkGUcvyk7AOw0EqiXgYnIOpPpA3CMDrvacHbuWCDNdarZ0ug6hTJKUfccXY4E4CWHTABks0ibvADMNh1AbQcVwU6HiBWgtde0B2k4iwZg4I/54nmjO255zmBE7OgAjXjgJV67zkDE625qwlSwofiwLFAA+EFDmP2m6pou2KZ+wqZLXBhAnHadjAqFZ4aq3rqWe4HpaBqCDyDvrkCPfBFHKvbGgSnS2U8kDAlPHK9hKj3B9wLekleMg+IoYIyQ14HjXK5UylWHIycaFev9816zWs0VEeWLxVK1eT6YlEOGTifLug4bRE2LCFkZAFAsRiqyV0oo+gsrAieskUrN0WCCpnVc63ZrbdErk4nWHpSB/lq/RFTvtrUykS/qY+ojXtkRfsRIvabt98Rt2wyIwqfFHzeq9vqNy3ptspdqIFgPHWIDWw+DIi9sEb6p4fyK0KVE6yMOS/kgF7ttM3XTyWsWGzxbYfFqlWzpnMUloMLrUXgVsi1ypQ5onI3iA+KcV9kV1VEQXGQb5AMgCFrqul+VrMdn0X9yjTIxg4e1Lqc0j9esBZTypWbrD539ELVUyui2WvVrkfLe4qHN48nnZ9RBszeq1EH5Tz6rAK2tfpo8akxry35AAX+AQFTLmvZHnhP8no54QMEqLWBz/Xunco56wgI5V/AfOYcjckc9IvIfesYl6nm4yId0hv+Jh3S4ox/S+W88ZTT+wVNGaA1++zEXrfbN84LfPuf1u8+5MGPV2AD++QfVzv75J+0QVX7HGKnGiR4V/PefdUR55GX00Z3TE9Au4z2SGw/AP/+06dnfflxWi/eu6SEA9s/7/h3+VTiI/0BxfAB/74HlbiztPQLAWbGi/o0nrhnnz04A4Cxbrf/Tj4wjyv/bz7xbJFXEP5IZA6gK1BrdqQFYVcu2esprAHv2RbVN24z+IwCQZ67U9JPaVFXvHvY8/Q8BIAijbupUng2oqfroOPaPB4BsarNePkWEBLVyvXmQ5TwRAKuqXin/cBnQ5GuV0jGyfwoAFlW7gnikRgOrFt/9JuX94wCsY/KtmnHo7SQg6rpRa50favX/BABE+WblsiZqMUFY1ymEWqvyA8EP0EkAIMrnmqNBTStHo9hffNKty0O5n8+9TacCYFG+mGv2W9dqKlXWNF0VnUcNrT0mVde0ciqlj1uI9+KpmLfolAAssnZY8qXmqDK47F63DcM6stIed1uD/nmzlLd2YE484P8BI+5Y0o7/+OEAAAAASUVORK5CYII=', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1QQlMgS2lkczE3NjcxNjI4MDQ0NDA.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1QQlMgS2lkczE3NjcxNjI4MDQ0NDA.txt', true, 7)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_pbs_kids_srv1', 'playz_kids_pbs_kids', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1QQlMgS2lkczE3NjcxNjI4MDQ0NDA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_toonzkids', 'ToonzKids', 'https://img.airtel.tv/unsafe/fit-in/500x0/filters:format(webp)/https://xstreamcp-assets-msp.streamready.in/assets/DISTROTV/LIVECHANNEL/66698969bac4421ebc5336c3/images/1080_logo_dtv_logo.jpg?o=production', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Ub29uektpZHMxNzY3MTYyODMwOTM4.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Ub29uektpZHMxNzY3MTYyODMwOTM4.txt', true, 8)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_toonzkids_srv1', 'playz_kids_toonzkids', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Ub29uektpZHMxNzY3MTYyODMwOTM4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_kids_tv_india_music', 'Kids TV India Music', 'https://cdn.marschannels.com/files/video_libraries/36_988/image_category/recTKZjS3iSrQq6J0.png', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzIFRWIEluZGlhIE11c2ljMTc2NzE2Mjg2MDU4OA.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzIFRWIEluZGlhIE11c2ljMTc2NzE2Mjg2MDU4OA.txt', true, 9)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_kids_tv_india_music_srv1', 'playz_kids_kids_tv_india_music', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzIFRWIEluZGlhIE11c2ljMTc2NzE2Mjg2MDU4OA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_discovery_kids', 'Discovery Kids', 'https://i.postimg.cc/W4vGr05W/Picsart-25-12-25-18-10-27-321.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EaXNjb3ZlcnkgS2lkczE3NjcxNjI4ODk3NjY.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EaXNjb3ZlcnkgS2lkczE3NjcxNjI4ODk3NjY.txt', true, 10)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_discovery_kids_srv1', 'playz_kids_discovery_kids', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1EaXNjb3ZlcnkgS2lkczE3NjcxNjI4ODk3NjY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_kushi_tv', 'Kushi TV', 'https://i.postimg.cc/vHc0Wsv5/Picsart_25_12_25_00_57_53_468.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LdXNoaSBUVjE3NjcxNjMwMjQ0MDY.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LdXNoaSBUVjE3NjcxNjMwMjQ0MDY.txt', true, 11)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_kushi_tv_srv1', 'playz_kids_kushi_tv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LdXNoaSBUVjE3NjcxNjMwMjQ0MDY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_chutti_tv', 'Chutti TV', 'https://static.wikia.nocookie.net/chloescloset/images/a/ad/Chutti_TV_Logo.jpg/revision/latest/scale-to-width-down/225?cb=20230516145655', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DaHV0dGkgVFYxNzY3MTYzMDU1ODMz.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DaHV0dGkgVFYxNzY3MTYzMDU1ODMz.txt', true, 12)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_chutti_tv_srv1', 'playz_kids_chutti_tv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DaHV0dGkgVFYxNzY3MTYzMDU1ODMz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_kochu', 'Kochu', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrn34EEu3Ouhy4pfrD1UP3RsRSGxnZeTRxN8XQ3ru0Jw&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Lb2NodTE3NjcxNjMwODUxODk.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Lb2NodTE3NjcxNjMwODUxODk.txt', true, 13)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_kochu_srv1', 'playz_kids_kochu', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Lb2NodTE3NjcxNjMwODUxODk.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_chintu_tv', 'Chintu TV', 'https://i.postimg.cc/gkngvWKZ/Picsart_25_12_25_00_58_45_517.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DaGludHUgVFYxNzY3MTYzMTE1NTY0.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DaGludHUgVFYxNzY3MTYzMTE1NTY0.txt', true, 14)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_chintu_tv_srv1', 'playz_kids_chintu_tv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DaGludHUgVFYxNzY3MTYzMTE1NTY0.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_maasranga_hd', 'MAASRANGA HD', 'https://play-lh.googleusercontent.com/Ls0I7UY9msY-B-HqpMc3fKnfDmMDPzM7J0dpPCCPX680Em_Ovo-bSjqZyc08F4ykNEs', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1NQUFTUkFOR0EgSEQxNzY3MTYzMTQ5OTcw.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1NQUFTUkFOR0EgSEQxNzY3MTYzMTQ5OTcw.txt', true, 15)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_maasranga_hd_srv1', 'playz_kids_maasranga_hd', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1NQUFTUkFOR0EgSEQxNzY3MTYzMTQ5OTcw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_rongeentv', 'Rongeentv', 'https://play-lh.googleusercontent.com/aB9kpZngTtp3usFm1i6X4E_9zBlCwq3b43LiVUEXfplqRK7Ye1y_CqSgkjWNXuhGPWqb=w240-h480-rw', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Sb25nZWVudHYxNzY3MTYzMTcyNDAz.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Sb25nZWVudHYxNzY3MTYzMTcyNDAz.txt', true, 16)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_rongeentv_srv1', 'playz_kids_rongeentv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Sb25nZWVudHYxNzY3MTYzMTcyNDAz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_kushboo_bangla', 'KUSHBOO Bangla', 'https://assets-playztv.pages.dev/category/Kolkata/kb.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LVVNIQk9PIEJhbmdsYTE3NjcxNjMxOTM3NTM.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LVVNIQk9PIEJhbmdsYTE3NjcxNjMxOTM3NTM.txt', true, 17)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_kushboo_bangla_srv1', 'playz_kids_kushboo_bangla', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LVVNIQk9PIEJhbmdsYTE3NjcxNjMxOTM3NTM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_kids_flix', 'Kids Flix', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0k28gkBwXV1BCKJU9ys6b4fEjzFWabmv_xR3BsIKYQg&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzIEZsaXgxNzY3MTYzMjE5MjU1.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzIEZsaXgxNzY3MTYzMjE5MjU1.txt', true, 18)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_kids_flix_srv1', 'playz_kids_kids_flix', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzIEZsaXgxNzY3MTYzMjE5MjU1.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_gopal_bhar_24_7', 'Gopal Bhar 24/7', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTc4oXrY0sBBMOzBWtK64NLM9pse6KCVwG_XRd8SzSiAIQ9ker9nb5P208&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Hb3BhbCBCaGFyIDI0LzcxNzY3MTYzMjQyNjAz.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Hb3BhbCBCaGFyIDI0LzcxNzY3MTYzMjQyNjAz.txt', true, 19)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_gopal_bhar_24_7_srv1', 'playz_kids_gopal_bhar_24_7', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Hb3BhbCBCaGFyIDI0LzcxNzY3MTYzMjQyNjAz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_cartoon_24_7', 'Cartoon 24/7', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyAzYotMhTYqn0odORrgrmov15hKcM1VTcUQbaQQOrlWRk08_I3iZmVGwJ&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uIDI0LzcxNzY3MTYzMjY4MDg3.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uIDI0LzcxNzY3MTYzMjY4MDg3.txt', true, 20)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_cartoon_24_7_srv1', 'playz_kids_cartoon_24_7', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uIDI0LzcxNzY3MTYzMjY4MDg3.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_doraemon_24_7', 'Doraemon 24/7', 'https://static.vecteezy.com/system/resources/thumbnails/022/036/287/small/doraemon-cartoon-japanese-free-vector.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Eb3JhZW1vbiAyNC83MTc2NzE2MzI5MjE4NA.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Eb3JhZW1vbiAyNC83MTc2NzE2MzI5MjE4NA.txt', true, 21)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_doraemon_24_7_srv1', 'playz_kids_doraemon_24_7', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Eb3JhZW1vbiAyNC83MTc2NzE2MzI5MjE4NA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_gubbare', 'Gubbare', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxDTeoDXTG1Deh6DCMv3wJVKYv9aNvdngmgw&usqp=CAU', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1HdWJiYXJlMTc2NzE2MzMxNTg2NA.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1HdWJiYXJlMTc2NzE2MzMxNTg2NA.txt', true, 22)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_gubbare_srv1', 'playz_kids_gubbare', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1HdWJiYXJlMTc2NzE2MzMxNTg2NA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_pogo', 'Pogo', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmsB7W4H7j9q07tmSy-LHFfrCGDZIW8XE9Mg&usqp=CAU', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Qb2dvMTc2NzE2MzM0MjIyOA.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Qb2dvMTc2NzE2MzM0MjIyOA.txt', true, 23)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_pogo_srv1', 'playz_kids_pogo', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Qb2dvMTc2NzE2MzM0MjIyOA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_hungama', 'Hungama', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYVCQCmdjL7uqccQOxKVGnotluLMH5Vy1Yfg&usqp=CAU', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1IdW5nYW1hMTc2NzE2MzQzOTcyNw.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1IdW5nYW1hMTc2NzE2MzQzOTcyNw.txt', true, 24)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_hungama_srv1', 'playz_kids_hungama', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1IdW5nYW1hMTc2NzE2MzQzOTcyNw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_sonic', 'Sonic', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrn4P3BrORwxSONm5XBFgnazMD-1LElPo9D619OwWD4g&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Tb25pYzE3NjcxNjM0NjQwNjU.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Tb25pYzE3NjcxNjM0NjQwNjU.txt', true, 25)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_sonic_srv1', 'playz_kids_sonic', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1Tb25pYzE3NjcxNjM0NjQwNjU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_kids', 'Kids', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1epOtEU7zJS63yVWgQbets96dtgk6KFEcyljD7gwYbQ&s=10', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzMTc2ODQyNTY2ODMzMg.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzMTc2ODQyNTY2ODMzMg.txt', true, 26)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_kids_srv1', 'playz_kids_kids', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1LaWRzMTc2ODQyNTY2ODMzMg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_sony_yay', 'SONY YAY', 'https://i.postimg.cc/zGHDF9Vv/Picsart-26-02-04-11-38-51-985.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1TT05ZIFlBWTE3Njg0NTkwNDQ3MDE.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1TT05ZIFlBWTE3Njg0NTkwNDQ3MDE.txt', true, 27)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_sony_yay_srv1', 'playz_kids_sony_yay', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1TT05ZIFlBWTE3Njg0NTkwNDQ3MDE.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_24_7_bantul_the_great', '24/7 Bantul The Great', 'https://i.postimg.cc/7hrsjZ1v/doraemon.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IEJhbnR1bCBUaGUgR3JlYXQxNzY4NzE4NzM3MTk5.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IEJhbnR1bCBUaGUgR3JlYXQxNzY4NzE4NzM3MTk5.txt', true, 28)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_24_7_bantul_the_great_srv1', 'playz_kids_24_7_bantul_the_great', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IEJhbnR1bCBUaGUgR3JlYXQxNzY4NzE4NzM3MTk5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_24_7_ninja_hattori', '24/7 Ninja Hattori', 'https://i.postimg.cc/Kz0h2LzX/ninja-hattori.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IE5pbmphIEhhdHRvcmkxNzY4NzE4ODY5ODYz.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IE5pbmphIEhhdHRvcmkxNzY4NzE4ODY5ODYz.txt', true, 29)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_24_7_ninja_hattori_srv1', 'playz_kids_24_7_ninja_hattori', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IE5pbmphIEhhdHRvcmkxNzY4NzE4ODY5ODYz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_24_7_oggy_and_the_cockroaches', '24/7 Oggy and the Cockroaches', 'https://i.postimg.cc/25T1j5cX/oggy2.jpg', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IE9nZ3kgYW5kIHRoZSBDb2Nrcm9hY2hlczE3Njg3MTg5MDk3Mjg.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IE9nZ3kgYW5kIHRoZSBDb2Nrcm9hY2hlczE3Njg3MTg5MDk3Mjg.txt', true, 30)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_24_7_oggy_and_the_cockroaches_srv1', 'playz_kids_24_7_oggy_and_the_cockroaches', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek0yNC83IE9nZ3kgYW5kIHRoZSBDb2Nrcm9hY2hlczE3Njg3MTg5MDk3Mjg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_baby_shark_tv', 'Baby Shark TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwfu0SlseEVLQZcpBzoo8SwIhBLE2DqK60b8x9A2L3dw&s', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1CYWJ5IFNoYXJrIFRWMTc3NTQ1ODg0MTIyOQ.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1CYWJ5IFNoYXJrIFRWMTc3NTQ1ODg0MTIyOQ.txt', true, 31)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_baby_shark_tv_srv1', 'playz_kids_baby_shark_tv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1CYWJ5IFNoYXJrIFRWMTc3NTQ1ODg0MTIyOQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_ytv', 'YTV', 'https://i.imgur.com/LXoPZ8x.png', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1ZVFYxNzc1NDU5MzU0OTE4.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1ZVFYxNzc1NDU5MzU0OTE4.txt', true, 32)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_ytv_srv1', 'playz_kids_ytv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1ZVFYxNzc1NDU5MzU0OTE4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_cartoonito', 'Cartoonito', 'https://images.indihometv.com/assets/88_CARTOONITO_2025_03_17_14_46_33.png', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uaXRvMTc3NTQ1OTYxNTk3Mw.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uaXRvMTc3NTQ1OTYxNTk3Mw.txt', true, 33)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_cartoonito_srv1', 'playz_kids_cartoonito', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1DYXJ0b29uaXRvMTc3NTQ1OTYxNTk3Mw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_adn_tv', 'ADN TV+', 'https://i.imgur.com/HQZQyWt.png', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1BRE4gVFYrMTc3NTQ2MDA4NTIzNg.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1BRE4gVFYrMTc3NTQ2MDA4NTIzNg.txt', true, 34)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_adn_tv_srv1', 'playz_kids_adn_tv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1BRE4gVFYrMTc3NTQ2MDA4NTIzNg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_abc_kids', 'ABC KIDS', 'https://static.wikia.nocookie.net/logopedia/images/2/29/ABC_Kids_%282020%29.svg/revision/latest/scale-to-width-down/512', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1BQkMgS0lEUzE3NzU0NjAxNDY4MDM.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1BQkMgS0lEUzE3NzU0NjAxNDY4MDM.txt', true, 35)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_abc_kids_srv1', 'playz_kids_abc_kids', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1BQkMgS0lEUzE3NzU0NjAxNDY4MDM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_kids_baby_shark_tv', 'Baby Shark TV', 'https://i.imgur.com/SbBKr8L.png', 'kids', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1CYWJ5IFNoYXJrIFRWMTc3NTQ2MDIxNzc1MQ.txt', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1CYWJ5IFNoYXJrIFRWMTc3NTQ2MDIxNzc1MQ.txt', true, 36)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_kids_baby_shark_tv_srv1', 'playz_kids_baby_shark_tv', 'Server 1', 'pro/UzJsa2N6RTNOamN3TURneU1qQXpOek1CYWJ5IFNoYXJrIFRWMTc3NTQ2MDIxNzc1MQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ptv_sports', 'PTV Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpME2S30OXOnmJ-sdPSrhlfT0gnjOSP1spZQW4iJCJ7TLNe0AQNebv044&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFRWIFNwb3J0czE3NjcyOTY0NjIwMDk.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFRWIFNwb3J0czE3NjcyOTY0NjIwMDk.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ptv_sports_srv1', 'playz_sports_ptv_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFRWIFNwb3J0czE3NjcyOTY0NjIwMDk.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_a_sports', 'A Sports', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh61qAM07BQioheL4FWkgQEhhtdfILVTD-Bw-i50gsuXYkcpd7TkfUNIACYhUnRlOuQ-9UODn0PsSW3k9Zoopuu-EPp4DASgq5JLA0YLRBULauSCKX9GDXOf0KmULZOSsH3FVO4xHVaHpYTCQODRvNz1UKJtmgiCxOKxVU1K-sekyhpJeRMT3wXB48PUIc/s16000/1000408129.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQSBTcG9ydHMxNzY3Mjk2NDc3NzI1.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQSBTcG9ydHMxNzY3Mjk2NDc3NzI1.txt', true, 2)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_a_sports_srv1', 'playz_sports_a_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQSBTcG9ydHMxNzY3Mjk2NDc3NzI1.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_willow', 'Willow', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgbFhO0M4908lPjDqRlNW7-nrpBKZEmt7AW7Y0_yAeaEGnEgdRuit8SWYyeqIolyUAiy44ruBz5WZhne-ZaOcOazSKizriVZSsOBzpapboWxoTA44kt-DZR_a-GkUO85oi9Dnx3LNXSKW5yvyf3TEQlEFnGdC-uqdALcMFE2V__FxatOQ6JTEma5IMOxUo/s1600/1000408133.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV2lsbG93MTc2NzI5NjQ5NDIyNg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV2lsbG93MTc2NzI5NjQ5NDIyNg.txt', true, 3)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_willow_srv1', 'playz_sports_willow', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV2lsbG93MTc2NzI5NjQ5NDIyNg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_fancode', 'Fancode', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3gn0wT8O2Us67OLa4gGiyHAPpAJsnhGuDaKoqPPvww&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXN0cm8gQ3JpY2tldDE3NjcyOTY1OTE0Mjc.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXN0cm8gQ3JpY2tldDE3NjcyOTY1OTE0Mjc.txt', true, 4)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_fancode_srv1', 'playz_sports_fancode', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXN0cm8gQ3JpY2tldDE3NjcyOTY1OTE0Mjc.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_t_sports', 'T Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNoRTQBtjGlMCjMXhwKV3COXy4njZjxwq9SUqdJ1LjLQ&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVCBTcG9ydHMxNzY3Mjk2NjQ0MTkw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVCBTcG9ydHMxNzY3Mjk2NjQ0MTkw.txt', true, 5)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_t_sports_srv1', 'playz_sports_t_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVCBTcG9ydHMxNzY3Mjk2NjQ0MTkw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_rta_sports', 'Rta Sports', 'https://yt3.googleusercontent.com/__SV8qSW52pXpQLmnc2LmdkgEEzRyuFCeIyrQGwfnFoVZDJkJ2FAGJF2FIqPo2hRAi-xTB-fqw=s900-c-k-c0x00ffffff-no-rj', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUnRhIFNwb3J0czE3NjcyOTY3MjUwNTU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUnRhIFNwb3J0czE3NjcyOTY3MjUwNTU.txt', true, 6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_rta_sports_srv1', 'playz_sports_rta_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUnRhIFNwb3J0czE3NjcyOTY3MjUwNTU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sky_sports_cricket', 'Sky Sports Cricket', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3T1tf3dkagTK_N_4uvQEoJGdWMAmCqnUYlL5tPZzuhw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU2t5IFNwb3J0cyBDcmlja2V0MTc2NzI5Njc0Nzc1MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU2t5IFNwb3J0cyBDcmlja2V0MTc2NzI5Njc0Nzc1MA.txt', true, 7)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sky_sports_cricket_srv1', 'playz_sports_sky_sports_cricket', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU2t5IFNwb3J0cyBDcmlja2V0MTc2NzI5Njc0Nzc1MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_fifa', 'FIFA+', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4_zmZ6rV-kE34ohg0x6knzA8x8E_VuKsYWqSH9sSwOg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRklGQSsxNzY3Mjk2Nzg1NzIy.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRklGQSsxNzY3Mjk2Nzg1NzIy.txt', true, 8)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_fifa_srv1', 'playz_sports_fifa', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRklGQSsxNzY3Mjk2Nzg1NzIy.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_geo_super', 'Geo Super', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9VxCYZYZuAwpc0-xh2RQCLOUmcnIlGwvLgZmzsm6a3g&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR2VvIFN1cGVyMTc2NzI5NjgxMzA1Nw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR2VvIFN1cGVyMTc2NzI5NjgxMzA1Nw.txt', true, 9)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_geo_super_srv1', 'playz_sports_geo_super', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR2VvIFN1cGVyMTc2NzI5NjgxMzA1Nw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ten_sports', 'Ten Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqROTprqy56aBl6lZ37UcVnYwXEUyuNiya6lYZmW5rSg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVuIFNwb3J0czE3NjcyOTY4NzcyMzg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVuIFNwb3J0czE3NjcyOTY4NzcyMzg.txt', true, 10)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ten_sports_srv1', 'playz_sports_ten_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVuIFNwb3J0czE3NjcyOTY4NzcyMzg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ten_cricket', 'Ten Cricket', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHPuFzfR4Z8Zx4aK-Fi6Sz7q8dR6ybOKKfbeZDAorRmA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVuIENyaWNrZXQxNzY3Mjk2ODk1NjA2.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVuIENyaWNrZXQxNzY3Mjk2ODk1NjA2.txt', true, 11)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ten_cricket_srv1', 'playz_sports_ten_cricket', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVuIENyaWNrZXQxNzY3Mjk2ODk1NjA2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_astro_cricket', 'Astro Cricket', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj9oNKJS_EX1oiXEUvC_gAs8lr7Aq2yE1vo9tHDDeopxYcrZAejnhzXWMrZveOkjxLRt8t3M5PNYQ3OjL6aGLs4S76fMBnNYh54tm6MQ2rW2wKolizCJc3bfy6CPYV-_a3gLbtfcP6VzKdI4-0HZLlE1NkFbvYumEbTmGuMq30Y7u35tq4t_UfSsqFmLUk/s1600/1000408140.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRmFuY29kZTE3NjczMzQ2MjYzNjY.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRmFuY29kZTE3NjczMzQ2MjYzNjY.txt', true, 12)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_astro_cricket_srv1', 'playz_sports_astro_cricket', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRmFuY29kZTE3NjczMzQ2MjYzNjY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_dd_sports', 'DD Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQad82RySdLMlbOCZCQ_Im_1gL38fOzsm4fw9rUFcxN1A&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjREQgU3BvcnRzMTc2NzM0NDE1OTA2Ng.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjREQgU3BvcnRzMTc2NzM0NDE1OTA2Ng.txt', true, 13)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_dd_sports_srv1', 'playz_sports_dd_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjREQgU3BvcnRzMTc2NzM0NDE1OTA2Ng.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nfl', 'NFL', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEVGqOxsyZpNjf5sbc0CN1G2HBzAfGctlSYJXkAsLZUA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkZMMTc2NzM0NDQ2MjkwNA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkZMMTc2NzM0NDQ2MjkwNA.txt', true, 14)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nfl_srv1', 'playz_sports_nfl', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkZMMTc2NzM0NDQ2MjkwNA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_mlb', 'MLB', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZA9r9tlhlMiig_GKywoUcEiqfCcVN4QLiNCyzlXjR5A&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUxCMTc2NzM0NDQ3NDExOA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUxCMTc2NzM0NDQ3NDExOA.txt', true, 15)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_mlb_srv1', 'playz_sports_mlb', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUxCMTc2NzM0NDQ3NDExOA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_premier_league', 'Premier League', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD8s5TKgPn0CxatBMaOdlc0r8vLZZ4TfYgbptqDSkBkw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllciBMZWFndWUxNzY3MzQ0NDk4Mjgz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllciBMZWFndWUxNzY3MzQ0NDk4Mjgz.txt', true, 16)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_premier_league_srv1', 'playz_sports_premier_league', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllciBMZWFndWUxNzY3MzQ0NDk4Mjgz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nba', 'NBA', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7K-0aow_u9uZB-V4cJ13TyX7R36LfPyLyBAohNDmqOA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJBMTc2NzM0NDUxMjY0NQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJBMTc2NzM0NDUxMjY0NQ.txt', true, 17)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nba_srv1', 'playz_sports_nba', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJBMTc2NzM0NDUxMjY0NQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ufc', 'UFC', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSWFUOUy0LCyksX4O3rlZQUCFlElDNkzWthLaZmGgbvg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVUZDIFR2MTc2NzM0NDU1Njk2Ng.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVUZDIFR2MTc2NzM0NDU1Njk2Ng.txt', true, 18)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ufc_srv1', 'playz_sports_ufc', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVUZDIFR2MTc2NzM0NDU1Njk2Ng.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_real_madrid', 'Real Madrid', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjwYXLedLHDaudBvm7sYchYkpYAPtzdNA2roUT-ipQd8TbugW2gXUdkJz51w7sia9nVv5aqLXJmIDFXEgDmWhZoe1dNNJ3Kw8U6fxO56BRrEiyKTNAwwlm1jMUFBSFUgxr2HM8NoPXHA5byi709g7f6Lg0IM8gaEXj-UFe6KKKCkT4KNk_dK8oa6S-doaA/s1600/1000408273.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmVhbCBNYWRyaWQgVGIxNzY3MzQ0NTkwODQ1.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmVhbCBNYWRyaWQgVGIxNzY3MzQ0NTkwODQ1.txt', true, 19)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_real_madrid_srv1', 'playz_sports_real_madrid', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmVhbCBNYWRyaWQgVGIxNzY3MzQ0NTkwODQ1.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bundesliga', 'Bundesliga', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX2ROdx0kL_YWVFDt1WXecRbnidlAweYpdisOfTIay4g&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQnVuZGVzbGlnYTE3NjczNDQ2OTQ4NjY.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQnVuZGVzbGlnYTE3NjczNDQ2OTQ4NjY.txt', true, 20)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bundesliga_srv1', 'playz_sports_bundesliga', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQnVuZGVzbGlnYTE3NjczNDQ2OTQ4NjY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_laliga_tv', 'LaLiga Tv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOWUpfTvNxcjWNNz8MQFFbgI29wIDHlEmAtX4dBOwecQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGEgTGlnYSBUdjE3NjczNDQ3MzQwOTc.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGEgTGlnYSBUdjE3NjczNDQ3MzQwOTc.txt', true, 21)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_laliga_tv_srv1', 'playz_sports_laliga_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGEgTGlnYSBUdjE3NjczNDQ3MzQwOTc.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_barca', 'Barca', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIs4B2Xdx7idoKRlYtDWO8k4jcc6NZkrFJ7A&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmFyY2EgVHYxNzY3MzQ0ODIyODE0.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmFyY2EgVHYxNzY3MzQ0ODIyODE0.txt', true, 22)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_barca_srv1', 'playz_sports_barca', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmFyY2EgVHYxNzY3MzQ0ODIyODE0.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nhl', 'NHL', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTU3SuapszR-oBIaMWEvslcmupvr8H5Zc6Aj5dXN7E1Dw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkhMIFR2MTc2NzM0NDg3Mjk2NQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkhMIFR2MTc2NzM0NDg3Mjk2NQ.txt', true, 23)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nhl_srv1', 'playz_sports_nhl', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkhMIFR2MTc2NzM0NDg3Mjk2NQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_wwe', 'WWE', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTQyabVUvU0G01JW2jkAH9kvGAGyMXM749IC4oVkJ4mg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV1dFMTc2NzM0NDkyMzMyOQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV1dFMTc2NzM0NDkyMzMyOQ.txt', true, 24)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_wwe_srv1', 'playz_sports_wwe', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV1dFMTc2NzM0NDkyMzMyOQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_olympic', 'Olympic', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7dBZvfvRsDX8q-_YIdBGGgnGaT_BBtXZ5nuqWtHX1pg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT2x5bXBpYzE3NjczNDUxNDE5MzM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT2x5bXBpYzE3NjczNDUxNDE5MzM.txt', true, 25)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_olympic_srv1', 'playz_sports_olympic', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT2x5bXBpYzE3NjczNDUxNDE5MzM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_redbull', 'Redbull ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZNIvKyv5_3F7I9xXd0j3G2D6CfqYg5iJKoyazV_4UFA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmVkYnVsbCAxNzY3MzQ1NTU1ODc5.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmVkYnVsbCAxNzY3MzQ1NTU1ODc5.txt', true, 26)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_redbull_srv1', 'playz_sports_redbull', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmVkYnVsbCAxNzY3MzQ1NTU1ODc5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_testing_stream', 'Testing Stream', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgLzzs-Wgy6FL4Xzs9-LdHTKRqVV4cHo9W0wCfYpB8cmq_mVMoIZHj6EAQnRI14nfQXbwZgfuggogL0qHkJ4OSdqr4vzGXCjVABgbd0j-olGkCZBPhiP87GA7Fz3-cFs1hxKXLGCi2QtPA61hp6Q68DvciwF7ERiLHfBdSHlQgNwoGPpn3LVPK1-wFPixA/s1600/1000408278.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVzdGluZyBTdHJlYW0xNzY3MzYyODM4OTQ2.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVzdGluZyBTdHJlYW0xNzY3MzYyODM4OTQ2.txt', true, 27)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_testing_stream_srv1', 'playz_sports_testing_stream', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVzdGluZyBTdHJlYW0xNzY3MzYyODM4OTQ2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_espn', 'ESPN', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfrViYXQAm3cKFYgiYp-up4ToClRMblF52Zz9i60tJ8Q&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRVNQTjE3NjczNjMyMTkwODY.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRVNQTjE3NjczNjMyMTkwODY.txt', true, 28)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_espn_srv1', 'playz_sports_espn', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRVNQTjE3NjczNjMyMTkwODY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tsn', 'TSN', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxdJo8EHNhTO2u8s5_ETdckAXzVkWtQJTSYOe_gbUnRA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFNOMTc2NzM2MzI2MTc0OQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFNOMTc2NzM2MzI2MTc0OQ.txt', true, 29)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tsn_srv1', 'playz_sports_tsn', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFNOMTc2NzM2MzI2MTc0OQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_canal_sport', 'Canal Sport ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1slVBBR4yB6UAIrAylC6sqQeO4G8WHgTcLlkJY4misQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ2FuYWwgU3BvcnQgMTc2NzM2MzM3NDE0NQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ2FuYWwgU3BvcnQgMTc2NzM2MzM3NDE0NQ.txt', true, 30)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_canal_sport_srv1', 'playz_sports_canal_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ2FuYWwgU3BvcnQgMTc2NzM2MzM3NDE0NQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_arena_sport', 'Arena Sport', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7Szaj0r1w9ZF8MxHOVxnb3D0edNgCHZ9MV2hrOeAdNzeML97hQ6-PjcM&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXJlbmEgU3BvcnQxNzY3MzYzNTkwOTQz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXJlbmEgU3BvcnQxNzY3MzYzNTkwOTQz.txt', true, 31)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_arena_sport_srv1', 'playz_sports_arena_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXJlbmEgU3BvcnQxNzY3MzYzNTkwOTQz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_euro_sports', 'Euro Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjKe3N57rVixqCtDQJHkS8uTFVHYOVl0E_WP58NMZltg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRXVybyBTcG9ydHMxNzY3MzYzNjcyMjc3.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRXVybyBTcG9ydHMxNzY3MzYzNjcyMjc3.txt', true, 32)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_euro_sports_srv1', 'playz_sports_euro_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRXVybyBTcG9ydHMxNzY3MzYzNjcyMjc3.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nova_sports', 'Nova Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5xyaPtM47QT6Ti76jVK9_o2_72YGxrC3QFNUXIocHng&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTm92YSBTcG9ydHMxNzY3MzYzNjkyMTI1.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTm92YSBTcG9ydHMxNzY3MzYzNjkyMTI1.txt', true, 33)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nova_sports_srv1', 'playz_sports_nova_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTm92YSBTcG9ydHMxNzY3MzYzNjkyMTI1.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sportv', 'Sportv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTltVnHcIu9cwJ-3vCYSqjy0j4PrS6gB1OgGPmfxwQbEg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnR2MTc2NzM2Mzc3MTM1OQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnR2MTc2NzM2Mzc3MTM1OQ.txt', true, 34)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sportv_srv1', 'playz_sports_sportv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnR2MTc2NzM2Mzc3MTM1OQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_cbs_sports', 'CBS Sports', 'https://yt3.googleusercontent.com/jnGO8vkeg1R9IAaIHIej_SS9tzYXtyk54KwbHovEq2No3HfvV6mw2CYVIoFg2ThbFTnkUiSIBw=s900-c-k-c0x00ffffff-no-rj', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0JTIFNwb3J0czE3NjczNjM4NTgxMDU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0JTIFNwb3J0czE3NjczNjM4NTgxMDU.txt', true, 35)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_cbs_sports_srv1', 'playz_sports_cbs_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0JTIFNwb3J0czE3NjczNjM4NTgxMDU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_fubo_sports', 'Fubo Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGGP9M64adVy-H4vB-r4UfSg9fCnKP9dDORg&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRnVibyBTcG9ydHMxNzY3MzYzOTEwMjgy.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRnVibyBTcG9ydHMxNzY3MzYzOTEwMjgy.txt', true, 36)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_fubo_sports_srv1', 'playz_sports_fubo_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRnVibyBTcG9ydHMxNzY3MzYzOTEwMjgy.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_fox_sports', 'Fox Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXn9wz0tljw0x-Y2gdpediSwq5mP0Uou2wYGrPt3KN9g&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRm94IFNwb3J0czE3NjczNjM5NDg0MjQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRm94IFNwb3J0czE3NjczNjM5NDg0MjQ.txt', true, 37)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_fox_sports_srv1', 'playz_sports_fox_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRm94IFNwb3J0czE3NjczNjM5NDg0MjQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_dubai_sports', 'Dubai Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6YTI2Z2aXPKRlj-0MD9Vz5b03qMITV2kbcSLTEDXJWA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRHViYWkgU3BvcnRzMTc2NzM2NDA1Njg5MQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRHViYWkgU3BvcnRzMTc2NzM2NDA1Njg5MQ.txt', true, 38)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_dubai_sports_srv1', 'playz_sports_dubai_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRHViYWkgU3BvcnRzMTc2NzM2NDA1Njg5MQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_spo_tv', 'Spo Tv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2V5vEE_wDbcFtt5Ea6-K0hw_2kKvHRsXVC2ZYBv1how&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvIFR2MTc2NzM2NDEwNTcwNQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvIFR2MTc2NzM2NDEwNTcwNQ.txt', true, 39)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_spo_tv_srv1', 'playz_sports_spo_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvIFR2MTc2NzM2NDEwNTcwNQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bbc_sport', 'BBC Sport', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBB1uBkhMBwviG_8YkDpCjuUec1-on9oCwDYfhTexd4w&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkJDIFNwb3J0MTc2NzM2NDMzMzkxMA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkJDIFNwb3J0MTc2NzM2NDMzMzkxMA.txt', true, 40)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bbc_sport_srv1', 'playz_sports_bbc_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkJDIFNwb3J0MTc2NzM2NDMzMzkxMA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_viaplay', 'Viaplay', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzJNIPltCLI06yOZEXMxAXUcnKxd2zoFWTblX_hNrTTA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVmlhcGxheTE3NjczNjQ0NjgyOTM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVmlhcGxheTE3NjczNjQ0NjgyOTM.txt', true, 41)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_viaplay_srv1', 'playz_sports_viaplay', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVmlhcGxheTE3NjczNjQ0NjgyOTM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_30a_golf_kingdom', '30A Golf Kingdom', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRHNFeY7vMdZegD9eEDqe_dOqTyf24O_NpKgOmdc11Og&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjMzBBIEdvbGYgS2luZ2RvbTE3NjczNjQ2MTQyNTU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjMzBBIEdvbGYgS2luZ2RvbTE3NjczNjQ2MTQyNTU.txt', true, 42)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_30a_golf_kingdom_srv1', 'playz_sports_30a_golf_kingdom', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjMzBBIEdvbGYgS2luZ2RvbTE3NjczNjQ2MTQyNTU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_a_spor', 'A Spor', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXwCyCOA6O5vZc2a9pd7xyB_MXKqUldlYAEvSU0W9BVQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQSBTcG9yMTc2NzM2NDcyMTU1MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQSBTcG9yMTc2NzM2NDcyMTU1MA.txt', true, 43)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_a_spor_srv1', 'playz_sports_a_spor', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQSBTcG9yMTc2NzM2NDcyMTU1MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_accdn', 'ACCDN', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlxsG2Nh2h1Xm5X4HmTXPl50kyJFKhImAkk1V8MtJwvA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUNDRE4xNzY3MzY0ODg3ODM3.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUNDRE4xNzY3MzY0ODg3ODM3.txt', true, 44)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_accdn_srv1', 'playz_sports_accdn', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUNDRE4xNzY3MzY0ODg3ODM3.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_aci_sport_tv', 'ACI Sport TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzYIIKnlD0i_-sRKH6Yl0I3NXqbHZD07MVu8PEVCov-Q&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUNJIFNwb3J0IFRWMTc2NzM2NDk2MjIxOA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUNJIFNwb3J0IFRWMTc2NzM2NDk2MjIxOA.txt', true, 45)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_aci_sport_tv_srv1', 'playz_sports_aci_sport_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUNJIFNwb3J0IFRWMTc2NzM2NDk2MjIxOA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ado_tv', 'ADO TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN8CUnOAqyJo3Z6c3Fc9t9DtRSmVYSyTkbUywCVzvCUw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQURPIFRWMTc2NzM2NTEwNDAxNw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQURPIFRWMTc2NzM2NTEwNDAxNw.txt', true, 46)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ado_tv_srv1', 'playz_sports_ado_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQURPIFRWMTc2NzM2NTEwNDAxNw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_africa_24_sport', 'Africa 24 Sport', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5whuMe3w5dn520RmUTDy9DDrEAO94GBpEO7q_v4yWtg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWZyaWNhIDI0IFNwb3J0MTc2NzM2NTIyNDc4OA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWZyaWNhIDI0IFNwb3J0MTc2NzM2NTIyNDc4OA.txt', true, 47)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_africa_24_sport_srv1', 'playz_sports_africa_24_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWZyaWNhIDI0IFNwb3J0MTc2NzM2NTIyNDc4OA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_alkass_three', 'Alkass Three', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmwiLnl0jKjB_v9gA3WIaplKznYz6oFuJB7OJWy4ypzg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWxrYXNzIFRocmVlMTc2NzM2NTM4MDgxNQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWxrYXNzIFRocmVlMTc2NzM2NTM4MDgxNQ.txt', true, 48)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_alkass_three_srv1', 'playz_sports_alkass_three', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWxrYXNzIFRocmVlMTc2NzM2NTM4MDgxNQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bahrain_sports', 'Bahrain Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStqmOQWToD0IN-E3PzAcU62DznxcSSIH38a992Io6jDTju8zq0MQsoJlM&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmFocmFpbiBTcG9ydHMgMTE3NjczNjg5MzI0MzU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmFocmFpbiBTcG9ydHMgMTE3NjczNjg5MzI0MzU.txt', true, 49)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bahrain_sports_srv1', 'playz_sports_bahrain_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmFocmFpbiBTcG9ydHMgMTE3NjczNjg5MzI0MzU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bein_sports', 'BeIN Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6ClTsbKp_ExRbBYdlcd3czQvE5aOhCPjnz-laVNeqGQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmVJTiBTcG9ydHMxNzY3MzY5MTQwMjQ2.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmVJTiBTcG9ydHMxNzY3MzY5MTQwMjQ2.txt', true, 50)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bein_sports_srv1', 'playz_sports_bein_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmVJTiBTcG9ydHMxNzY3MzY5MTQwMjQ2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bek_tv_sports_west', 'BEK TV Sports West', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEO_2xboeLgTj5QxiAFpBDNNy-QV5R9P5ChZVfYzjpm-hoAbi0fE-KZ8Su&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkVLIFRWIFNwb3J0cyBXZXN0MTc2NzM2OTMwNTg4NQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkVLIFRWIFNwb3J0cyBXZXN0MTc2NzM2OTMwNTg4NQ.txt', true, 51)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bek_tv_sports_west_srv1', 'playz_sports_bek_tv_sports_west', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkVLIFRWIFNwb3J0cyBXZXN0MTc2NzM2OTMwNTg4NQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bellator_mma', 'Bellator MMA', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMvSvDhZ1rspXyNAjC4CqNfyiGI1eQdo2EYFmgT1nrbQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmVsbGF0b3IgTU1BMTc2NzM2OTM5NzE0OA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmVsbGF0b3IgTU1BMTc2NzM2OTM5NzE0OA.txt', true, 52)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bellator_mma_srv1', 'playz_sports_bellator_mma', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQmVsbGF0b3IgTU1BMTc2NzM2OTM5NzE0OA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_canal_do_inter', 'Canal do Inter', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVin6RMgROHAD8bX9jpfaecAx8Qyt6uvL7uwoYDsE29A&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ2FuYWwgZG8gSW50ZXIxNzY3MzcwOTYxOTg0.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ2FuYWwgZG8gSW50ZXIxNzY3MzcwOTYxOTg0.txt', true, 53)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_canal_do_inter_srv1', 'playz_sports_canal_do_inter', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ2FuYWwgZG8gSW50ZXIxNzY3MzcwOTYxOTg0.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_colimdot_tv', 'ColimdoT TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcd-0aJGqb-wigqaas5ZBPMP7XCOTp-WZuJnv91UZiIA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ29saW1kb1QgVFYxNzY3MzcxMzYxMTc4.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ29saW1kb1QgVFYxNzY3MzcxMzYxMTc4.txt', true, 54)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_colimdot_tv_srv1', 'playz_sports_colimdot_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ29saW1kb1QgVFYxNzY3MzcxMzYxMTc4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_t_sport', 'ČT Sport', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWhKvLvce646KU8ufBTKIraaAWu45FNQKyZzPS1ySO6Q&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjxIxUIFNwb3J0MTc2NzM3MTQ0OTAzMw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjxIxUIFNwb3J0MTc2NzM3MTQ0OTAzMw.txt', true, 55)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_t_sport_srv1', 'playz_sports_t_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjxIxUIFNwb3J0MTc2NzM3MTQ0OTAzMw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_dazn', 'DAZN', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGX1BpOoZmPWp6wkSNeaJUnQlbgCUkqBGFqxFtU64j9A&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjREFaTjE3NjczNzE1MzI3MjM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjREFaTjE3NjczNzE1MzI3MjM.txt', true, 56)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_dazn_srv1', 'playz_sports_dazn', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjREFaTjE3NjczNzE1MzI3MjM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_others', ' Others', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ03tIBnkg5JfY5o4ZkpOZx4KSXlIxD-okflA&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjIE90aGVyczE3NjczNzMyMTQ0OTE.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjIE90aGVyczE3NjczNzMyMTQ0OTE.txt', true, 57)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_others_srv1', 'playz_sports_others', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjIE90aGVyczE3NjczNzMyMTQ0OTE.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_solh_sports', 'Solh Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRr6h73Oxp35h-VShg6bZv6sLZk7AUth2A8BxZJ6Ep14A&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU29saCBTcG9ydHMxNzY3Mzc0MDM1MjE2.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU29saCBTcG9ydHMxNzY3Mzc0MDM1MjE2.txt', true, 58)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_solh_sports_srv1', 'playz_sports_solh_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU29saCBTcG9ydHMxNzY3Mzc0MDM1MjE2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_futbol', 'Futbol', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRipxGU8lfq9Pqo54rtCEuPg3Wld6QUUehNGrfAQcorTw&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRnV0Ym9sMTc2NzM3NDc1ODU5Mw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRnV0Ym9sMTc2NzM3NDc1ODU5Mw.txt', true, 59)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_futbol_srv1', 'playz_sports_futbol', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRnV0Ym9sMTc2NzM3NDc1ODU5Mw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_golf_channel', 'Golf Channel', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShgkhL3oV9fiQNvoWI7CbB9FtLCKlUFl_LXK5mmwfw0w&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR29sZiBDaGFubmVsMTc2NzM3NDkxMTU5Mg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR29sZiBDaGFubmVsMTc2NzM3NDkxMTU5Mg.txt', true, 60)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_golf_channel_srv1', 'playz_sports_golf_channel', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR29sZiBDaGFubmVsMTc2NzM3NDkxMTU5Mg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_horse_tv', 'Horse TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRguTgQrusswtRi84kTB21FK3n-BzKMeDtuXD1gTk007Q&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSG9yc2UgVFYxNzY3NDA4NTM5NTUy.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSG9yc2UgVFYxNzY3NDA4NTM5NTUy.txt', true, 61)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_horse_tv_srv1', 'playz_sports_horse_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSG9yc2UgVFYxNzY3NDA4NTM5NTUy.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_cricket', 'Cricket', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShj5QOQLbanF4_UzMAGSm-_QrSIEboUyDG98nOcYar5g&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY2tldDE3Njc0MDk1MzEwMDM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY2tldDE3Njc0MDk1MzEwMDM.txt', true, 62)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_cricket_srv1', 'playz_sports_cricket', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY2tldDE3Njc0MDk1MzEwMDM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_oman_sports_tv', 'Oman Sports TV ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3ejy6MLIl9ouHs2e7pa-Am5gJmUOSlJPanGCGdamXIw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT21hbiBTcG9ydHMgVFYgMTc2NzQxMDU1MjEyNA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT21hbiBTcG9ydHMgVFYgMTc2NzQxMDU1MjEyNA.txt', true, 63)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_oman_sports_tv_srv1', 'playz_sports_oman_sports_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT21hbiBTcG9ydHMgVFYgMTc2NzQxMDU1MjEyNA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_persiana', 'Persiana', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTISkd6SGrXSlYmXXR1IfaanQMjx07858LxObP9z1WPYA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVyc2lhbmExNzY3NDEwNzc4MDk5.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVyc2lhbmExNzY3NDEwNzc4MDk5.txt', true, 64)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_persiana_srv1', 'playz_sports_persiana', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVyc2lhbmExNzY3NDEwNzc4MDk5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ad_sports', 'Ad Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSApVH4gksdUpgOeGjdmC3iWYKgb4pAO6CfyQ&usqp=CAU', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWQgU3BvcnRzMTc2NzU1MjY0NzYwOQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWQgU3BvcnRzMTc2NzU1MjY0NzYwOQ.txt', true, 65)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ad_sports_srv1', 'playz_sports_ad_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQWQgU3BvcnRzMTc2NzU1MjY0NzYwOQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_premier_sports', 'Premier Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2N3muMyMzp3uu939QXWUO6cCn_tFRHVE8C7xqEn3Oryc-GW6ZQ9P1OyV8&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllciBTcG9ydHMxNzY3NTUzMzg1NTE0.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllciBTcG9ydHMxNzY3NTUzMzg1NTE0.txt', true, 66)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_premier_sports_srv1', 'playz_sports_premier_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllciBTcG9ydHMxNzY3NTUzMzg1NTE0.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tennis', 'Tennis', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfah2yJLgESmJjBXvh-C3hHpTBr8re_w5pYg&usqp=CAU', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVubmlzMTc2NzU1NDA0NzE4Mw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVubmlzMTc2NzU1NDA0NzE4Mw.txt', true, 67)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tennis_srv1', 'playz_sports_tennis', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVubmlzMTc2NzU1NDA0NzE4Mw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_usa_network', 'USA Network ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8CGaNMZllqJ_iTx0PEpY2DCuXWVboKsetUQ&usqp=CAU', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVVNBIE5ldHdvcmsgMTc2NzU1NDM4MDc1Ng.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVVNBIE5ldHdvcmsgMTc2NzU1NDM4MDc1Ng.txt', true, 68)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_usa_network_srv1', 'playz_sports_usa_network', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVVNBIE5ldHdvcmsgMTc2NzU1NDM4MDc1Ng.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nbc_sports', 'NBC Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRD7-UcWBcy7a0dG_fq2y1Q3dlCMSF11qU5xDjV2bDPtg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJDIFNwb3J0czE3Njc1NTQ1NzQwNzg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJDIFNwb3J0czE3Njc1NTQ1NzQwNzg.txt', true, 69)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nbc_sports_srv1', 'playz_sports_nbc_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJDIFNwb3J0czE3Njc1NTQ1NzQwNzg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_go3_sport', 'Go3 Sport', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShOOEY8P7cBNGSBiK7sVWUB-sXvhfa7mPSLg&usqp=CAU', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR28zIFNwb3J0MTc2NzU5NDYyMzk4MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR28zIFNwb3J0MTc2NzU5NDYyMzk4MA.txt', true, 70)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_go3_sport_srv1', 'playz_sports_go3_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjR28zIFNwb3J0MTc2NzU5NDYyMzk4MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_peacocktv', 'Peacocktv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuVSDXCR-SIPFlGUUmt8figmhQB2WvQIk8601RcgUUYvSnZ28DuftzUoJQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVhY29ja3R2MTc2NzU5NDg1MTg2Ng.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVhY29ja3R2MTc2NzU5NDg1MTg2Ng.txt', true, 71)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_peacocktv_srv1', 'playz_sports_peacocktv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVhY29ja3R2MTc2NzU5NDg1MTg2Ng.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sportsbaltic', 'Sportsbaltic', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6k-ZKKCiKUY8pqzL-SdyBnb8xNu_EBIZolQe6tFWwwODm0u8U9B2sEo8&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnRzYmFsdGljMTc2NzU5NTI0MDc1Nw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnRzYmFsdGljMTc2NzU5NTI0MDc1Nw.txt', true, 72)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sportsbaltic_srv1', 'playz_sports_sportsbaltic', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnRzYmFsdGljMTc2NzU5NTI0MDc1Nw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bek', 'BEK', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-nWZdCFZiGlqzYU0djTCC7c59LBjZexdAy_-eihB7MGdezf0Pw33dKyM5&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkVLMTc2NzU5NTU0MzQwNw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkVLMTc2NzU5NTU0MzQwNw.txt', true, 73)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bek_srv1', 'playz_sports_bek', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkVLMTc2NzU5NTU0MzQwNw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_rally_tv', 'RALLY TV', 'https://play-lh.googleusercontent.com/yGC9brvzJBdkj8D2iyr1FmtE2FOM4myhn83rWR1DsJR4jXBwpQSHa7OkS9Q1_XVqQGl-', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUkFMTFkgVFYxNzY3NTk1NTkxNjcy.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUkFMTFkgVFYxNzY3NTk1NTkxNjcy.txt', true, 74)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_rally_tv_srv1', 'playz_sports_rally_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUkFMTFkgVFYxNzY3NTk1NTkxNjcy.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_lequipe_live', 'LeQUIPE LIVE', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkGd_8rAKSB19Wq8D8QsItUb5QA3eQ3uHpqNCzYCSvlXrgh5s-JqSGHm8&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGVRVUlQRSBMSVZFMTc2NzU5NTY4MjA2Nw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGVRVUlQRSBMSVZFMTc2NzU5NTY4MjA2Nw.txt', true, 75)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_lequipe_live_srv1', 'playz_sports_lequipe_live', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGVRVUlQRSBMSVZFMTc2NzU5NTY4MjA2Nw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_unbeaten', 'UNBEATEN', 'https://i.ibb.co/n3sjJ1d/unbeaten.png', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVU5CRUFURU4xNzY3NTk1Nzg5NDgx.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVU5CRUFURU4xNzY3NTk1Nzg5NDgx.txt', true, 76)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_unbeaten_srv1', 'playz_sports_unbeaten', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVU5CRUFURU4xNzY3NTk1Nzg5NDgx.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_pac_12_insider', 'PAC 12 INSIDER', 'https://image.xumo.com/v1/channels/channel/99991143/500x400.webp?type=color_onBlack', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUEFDIDEyIElOU0lERVIxNzY3NTk1ODY0NzAz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUEFDIDEyIElOU0lERVIxNzY3NTk1ODY0NzAz.txt', true, 77)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_pac_12_insider_srv1', 'playz_sports_pac_12_insider', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUEFDIDEyIElOU0lERVIxNzY3NTk1ODY0NzAz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_draftkings_network', 'DRAFTKINGS NETWORK', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRsPApu5ls96HbcmC1sT7PuifAKvDSiXmTEd7Qz3sDGnioe1rZLKQ6XqNM&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRFJBRlRLSU5HUyBORVRXT1JLMTc2NzU5NTkxMjY3Mg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRFJBRlRLSU5HUyBORVRXT1JLMTc2NzU5NTkxMjY3Mg.txt', true, 78)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_draftkings_network_srv1', 'playz_sports_draftkings_network', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRFJBRlRLSU5HUyBORVRXT1JLMTc2NzU5NTkxMjY3Mg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_strongman_champions_league', 'STRONGMAN CHAMPIONS LEAGUE', 'https://image.xumo.com/v1/channels/channel/99951180/500x400.webp?type=color_onBlack', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1RST05HTUFOIENIQU1QSU9OUyBMRUFHVUUxNzY3NTk1OTk3MTAy.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1RST05HTUFOIENIQU1QSU9OUyBMRUFHVUUxNzY3NTk1OTk3MTAy.txt', true, 79)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_strongman_champions_league_srv1', 'playz_sports_strongman_champions_league', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1RST05HTUFOIENIQU1QSU9OUyBMRUFHVUUxNzY3NTk1OTk3MTAy.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_combate_global', 'COMBATE GLOBAL', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0RE6SoPasVYTVfOGbKsrFlP9mmyj_IMvkjBBflQpa4tDg2S9UwvJ8wGsf&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ09NQkFURSBHTE9CQUwxNzY3NTk2MDQ3MjUw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ09NQkFURSBHTE9CQUwxNzY3NTk2MDQ3MjUw.txt', true, 80)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_combate_global_srv1', 'playz_sports_combate_global', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ09NQkFURSBHTE9CQUwxNzY3NTk2MDQ3MjUw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_hard_knocks', 'HARD KNOCKS', 'https://i.ibb.co/MGq0gyX/hard-knocks.webp', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSEFSRCBLTk9DS1MxNzY3NTk2MDc1MDg0.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSEFSRCBLTk9DS1MxNzY3NTk2MDc1MDg0.txt', true, 81)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_hard_knocks_srv1', 'playz_sports_hard_knocks', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSEFSRCBLTk9DS1MxNzY3NTk2MDc1MDg0.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_fight_network', 'FIGHT NETWORK', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXaU7G424R7UYqH547MVlAyU-EVETBWwPDZa3bLheyHVZRA2H_VdSM_LQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRklHSFQgTkVUV09SSzE3Njc1OTYxNDg0ODM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRklHSFQgTkVUV09SSzE3Njc1OTYxNDg0ODM.txt', true, 82)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_fight_network_srv1', 'playz_sports_fight_network', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRklHSFQgTkVUV09SSzE3Njc1OTYxNDg0ODM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_professional_fighters_league', 'PROFESSIONAL FIGHTERS LEAGUE', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLaJYMcoNn1-dV0SMtcHxEJdmtFl6aKK1bK3go-byGRQxt3FLR3qteu6c&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFJPRkVTU0lPTkFMIEZJR0hURVJTIExFQUdVRTE3Njc1OTYyMjY0NTM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFJPRkVTU0lPTkFMIEZJR0hURVJTIExFQUdVRTE3Njc1OTYyMjY0NTM.txt', true, 83)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_professional_fighters_league_srv1', 'playz_sports_professional_fighters_league', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFJPRkVTU0lPTkFMIEZJR0hURVJTIExFQUdVRTE3Njc1OTYyMjY0NTM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tudn', 'Tudn', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2D5wfRZOhKgkyVL1xVJHRlDarNcwqbP34wsg6qNmVrF4z_U_71ApixmM&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVHVkbjE3Njc1OTYyNTExMzM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVHVkbjE3Njc1OTYyNTExMzM.txt', true, 84)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tudn_srv1', 'playz_sports_tudn', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVHVkbjE3Njc1OTYyNTExMzM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_dpworldtour', 'Dpworldtour', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1KImuhdqvkfFNFW7cMhb1XCgy-FqwVbkGyxpFNwZbxHHG6PV77PqJB1bK&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRHB3b3JsZHRvdXIxNzY3NTk2NDU2Mzcx.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRHB3b3JsZHRvdXIxNzY3NTk2NDU2Mzcx.txt', true, 85)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_dpworldtour_srv1', 'playz_sports_dpworldtour', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRHB3b3JsZHRvdXIxNzY3NTk2NDU2Mzcx.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_rugbypasstv', 'Rugbypasstv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWPt78Uyi5Xus4xmf_Tx3Wz6JWlSTHeTSxlP6ntVt9Ow&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUnVnYnlwYXNzdHYxNzY3NTk2NTYyNjI4.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUnVnYnlwYXNzdHYxNzY3NTk2NTYyNjI4.txt', true, 86)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_rugbypasstv_srv1', 'playz_sports_rugbypasstv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUnVnYnlwYXNzdHYxNzY3NTk2NTYyNjI4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_super_sport', 'Super Sport', 'https://i.postimg.cc/d3wWhMMZ/Picsart-26-01-18-20-31-47-597.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3VwZXIgU3BvcnQxNzY4NzQ2NTU1OTY3.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3VwZXIgU3BvcnQxNzY4NzQ2NTU1OTY3.txt', true, 87)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_super_sport_srv1', 'playz_sports_super_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3VwZXIgU3BvcnQxNzY4NzQ2NTU1OTY3.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_lemar_tv', 'Lemar Tv', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeO7fvuh0MCaJ95gspAgRW4zUVqkXZxcrNtmcNKnws7Q&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGVtYXIgVHYxNzY4ODM2Mzg0MzY2.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGVtYXIgVHYxNzY4ODM2Mzg0MzY2.txt', true, 88)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_lemar_tv_srv1', 'playz_sports_lemar_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTGVtYXIgVHYxNzY4ODM2Mzg0MzY2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_criclife2', 'CricLife2', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPdozfCK0VWsB4rBeKU9l_HA9UvJtARO-B52qUAJEufQ&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY0xpZmUyMTc2ODg5ODg0MzI1MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY0xpZmUyMTc2ODg5ODg0MzI1MA.txt', true, 89)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_criclife2_srv1', 'playz_sports_criclife2', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY0xpZmUyMTc2ODg5ODg0MzI1MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_persiana_sports', 'Persiana Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfa1LJy0816tRWD7ITg3sWkdlkoEIYdiddN4b9v3ZDtg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVyc2lhbmEgU3BvcnRzMTc2OTA2MjcwOTczOA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVyc2lhbmEgU3BvcnRzMTc2OTA2MjcwOTczOA.txt', true, 90)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_persiana_sports_srv1', 'playz_sports_persiana_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUGVyc2lhbmEgU3BvcnRzMTc2OTA2MjcwOTczOA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_cricbuzz', 'CricBuZZ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMvq94WjL66OAH1MdvghxkPGQSRUdA3V-hsKnYCv9lUQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY0J1WloxNzY5MDc0MjgzNTAz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY0J1WloxNzY5MDc0MjgzNTAz.txt', true, 91)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_cricbuzz_srv1', 'playz_sports_cricbuzz', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ3JpY0J1WloxNzY5MDc0MjgzNTAz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_max_sport_1', 'Max Sport 1', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQU-Ixuaf8s6trXEcz1LNz0BQYebvBhbckS4dXaLljhIw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWF4IFNwb3J0IDExNzY5NTc2MzQyOTcw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWF4IFNwb3J0IDExNzY5NTc2MzQyOTcw.txt', true, 92)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_max_sport_1_srv1', 'playz_sports_max_sport_1', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWF4IFNwb3J0IDExNzY5NTc2MzQyOTcw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_af_tolo_sport', 'AF Tolo Sport', 'https://i.postimg.cc/zXCrn0M1/Picsart-26-02-08-17-56-18-839.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUYgVG9sbyBTcG9ydDE3NzA1NTE4OTgxNjU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUYgVG9sbyBTcG9ydDE3NzA1NTE4OTgxNjU.txt', true, 93)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_af_tolo_sport_srv1', 'playz_sports_af_tolo_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQUYgVG9sbyBTcG9ydDE3NzA1NTE4OTgxNjU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_atn_sports', 'ATN SPORTS ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbZv4CTnyWXXBY-dORvl0q5h4v7S44QGCjEvQ-xg1yuw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVJJQU5BMTc3MDk2NDAyODE3Mw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVJJQU5BMTc3MDk2NDAyODE3Mw.txt', true, 94)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_atn_sports_srv1', 'playz_sports_atn_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVJJQU5BMTc3MDk2NDAyODE3Mw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sportdigital_fhd', 'Sportdigital FHD', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoQMhn4MeA51c7hqZYFb-06DPx9Upn9NbkiatJyyRTsw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnRkaWdpdGFsIEZIRDE3NzE1MjE2NDU0Nzg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnRkaWdpdGFsIEZIRDE3NzE1MjE2NDU0Nzg.txt', true, 95)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sportdigital_fhd_srv1', 'playz_sports_sportdigital_fhd', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnRkaWdpdGFsIEZIRDE3NzE1MjE2NDU0Nzg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_psn_sports', 'PSN Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkzas4QZXhx4a74gwsH2YbqWK_Qv5-FwLqT-tX_k2L_Q&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFNOIFNwb3J0czE3NzI3MzUzMzU2NzY.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFNOIFNwb3J0czE3NzI3MzUzMzU2NzY.txt', true, 96)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_psn_sports_srv1', 'playz_sports_psn_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUFNOIFNwb3J0czE3NzI3MzUzMzU2NzY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_me_watch', 'ME WATCH', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaG_G9k-qmR6ZQsORwV3wDChjxfSS6nj_dQTLq6EYHEw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUUgV0FUQ0gxNzc0OTY1NTM4MzE4.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUUgV0FUQ0gxNzc0OTY1NTM4MzE4.txt', true, 97)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_me_watch_srv1', 'playz_sports_me_watch', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUUgV0FUQ0gxNzc0OTY1NTM4MzE4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tap_sport', 'TAP SPORT', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4g9NzrI6iIJ6LEhNGmdrezmUKSzXz1b1Zg4IsyRcId_apvDblsS97scM&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVEFQIFNQT1JUMTc3NTc2MjY3OTczNg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVEFQIFNQT1JUMTc3NTc2MjY3OTczNg.txt', true, 98)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tap_sport_srv1', 'playz_sports_tap_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVEFQIFNQT1JUMTc3NTc2MjY3OTczNg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_telemundo_tv', 'Telemundo TV', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Telemundo_logo_2018.svg/1920px-Telemundo_logo_2018.svg.png', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVsZW11bmRvIFRWMTc3NTc2MzA3MzkxNg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVsZW11bmRvIFRWMTc3NTc2MzA3MzkxNg.txt', true, 99)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_telemundo_tv_srv1', 'playz_sports_telemundo_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVsZW11bmRvIFRWMTc3NTc2MzA3MzkxNg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nba_tv', 'NBA TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFpX7NdB6NbpNylGV1CcBKhkeLDGFEpq9szuY0GGSv0Q&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJBIFRWMTc3NTc2MzI5OTE1MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJBIFRWMTc3NTc2MzI5OTE1MA.txt', true, 100)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nba_tv_srv1', 'playz_sports_nba_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkJBIFRWMTc3NTc2MzI5OTE1MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nfl_network', 'NFL NETWORK', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMS1yRICaWN2_2utzHKURNO4szMxlZ413Ceg_uIDD5Sw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkZMIE5FVFdPUksxNzc1NzYzNDcwNDI5.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkZMIE5FVFdPUksxNzc1NzYzNDcwNDI5.txt', true, 101)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nfl_network_srv1', 'playz_sports_nfl_network', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTkZMIE5FVFdPUksxNzc1NzYzNDcwNDI5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_now_sports_pl', 'NOW SPORTS PL', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8Er8H73BRLHmpcL3b_IpTtmpAIBITOyWIekgkue4t_w&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTk9XIFNQT1JUUyBQTDE3NzU4ODY5MTM0Mzc.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTk9XIFNQT1JUUyBQTDE3NzU4ODY5MTM0Mzc.txt', true, 102)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_now_sports_pl_srv1', 'playz_sports_now_sports_pl', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTk9XIFNQT1JUUyBQTDE3NzU4ODY5MTM0Mzc.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_telewebion', 'Telewebion', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_MySNuhhdhN7-_M2TreCBYP0MDWB4nt6d4rQ-nh27jw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVsZXdlYmlvbjE3NzY3OTQwOTY4ODc.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVsZXdlYmlvbjE3NzY3OTQwOTY4ODc.txt', true, 103)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_telewebion_srv1', 'playz_sports_telewebion', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVGVsZXdlYmlvbjE3NzY3OTQwOTY4ODc.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ept_sports', 'EPT Sports ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTnBu4H4CMDJ004T0GbX3rLO_DCIvuzU37oSv5EXF45A&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRVBUIFNwb3J0cyAxNzc2OTg1Mzg3NDIz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRVBUIFNwb3J0cyAxNzc2OTg1Mzg3NDIz.txt', true, 104)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ept_sports_srv1', 'playz_sports_ept_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRVBUIFNwb3J0cyAxNzc2OTg1Mzg3NDIz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tv4_sports', 'TV4 SPORTS', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrAxaktD9Y1od1Rm6AHtVyprjayZtcxluw0uFLg_WgdA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFY0IFNQT1JUUzE3NzY5ODc4OTM1NDk.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFY0IFNQT1JUUzE3NzY5ODc4OTM1NDk.txt', true, 105)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tv4_sports_srv1', 'playz_sports_tv4_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFY0IFNQT1JUUzE3NzY5ODc4OTM1NDk.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sport_1_cz', 'Sport 1 CZ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzmci4zeFnWZJZmewBr0CROtiviOKG5VHGSYRIJ78ZWyzHLLUNKKZgBgGd&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgMSBDWjE3NzcwMjEwMzA1Mzg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgMSBDWjE3NzcwMjEwMzA1Mzg.txt', true, 106)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sport_1_cz_srv1', 'playz_sports_sport_1_cz', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgMSBDWjE3NzcwMjEwMzA1Mzg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_cosmote', 'COSMOTE', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSH2K_3jyV-gUVWA7QdBPegjpG96Trj2n27XD8TeKWDXA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ09TTU9URTE3Nzc5NDk3NDAyMjM.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ09TTU9URTE3Nzc5NDk3NDAyMjM.txt', true, 107)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_cosmote_srv1', 'playz_sports_cosmote', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ09TTU9URTE3Nzc5NDk3NDAyMjM.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tvri_sport', 'TVRI SPORT', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhAGhVTsaXzxvt6bdxVprLlB-b6SHcTgSedmjTj-EU7Q&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZSSSBTUE9SVDE3NzkzNDY0NDczNjg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZSSSBTUE9SVDE3NzkzNDY0NDczNjg.txt', true, 108)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tvri_sport_srv1', 'playz_sports_tvri_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZSSSBTUE9SVDE3NzkzNDY0NDczNjg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_arena_sports_cg', 'ARENA SPORTS CG', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOmMKxpO9S21RATWQrTGsvvYv6kLExRvIScZgKrtUPaA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVJFTkEgU1BPUlRTIENHMTc3OTM0NjU3NjI4Mw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVJFTkEgU1BPUlRTIENHMTc3OTM0NjU3NjI4Mw.txt', true, 109)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_arena_sports_cg_srv1', 'playz_sports_arena_sports_cg', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVJFTkEgU1BPUlRTIENHMTc3OTM0NjU3NjI4Mw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_f1_italy', 'F1 Italy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjaGb3uq6LYOhCI5x_Eynj5jv0PwUoaOnGVeUDmn7DgQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRjEgSXRhbHkxNzc5MzQ3OTg4MDEz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRjEgSXRhbHkxNzc5MzQ3OTg4MDEz.txt', true, 110)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_f1_italy_srv1', 'playz_sports_f1_italy', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRjEgSXRhbHkxNzc5MzQ3OTg4MDEz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_moto_sports', 'MOTO SPORTS ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkvg9Fl4SX9hQqDds269SAzWlNS1lrCQrreg&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTU9UTyBTUE9SVFMgMTc3OTM0ODMzNzI5Mw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTU9UTyBTUE9SVFMgMTc3OTM0ODMzNzI5Mw.txt', true, 111)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_moto_sports_srv1', 'playz_sports_moto_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTU9UTyBTUE9SVFMgMTc3OTM0ODMzNzI5Mw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_setanta_sports', 'Setanta Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCvH__oMJWBlecBw2m7-jLHGkgXmQI2rYrf94s-ONw7g&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU2V0YW50YSBTcG9ydHMxNzc5MzQ5NjU4NzI2.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU2V0YW50YSBTcG9ydHMxNzc5MzQ5NjU4NzI2.txt', true, 112)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_setanta_sports_srv1', 'playz_sports_setanta_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU2V0YW50YSBTcG9ydHMxNzc5MzQ5NjU4NzI2.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sporsmart_1', 'Sporsmart 1', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3ChcCoDVLZGfHu4wm0NUm_HgxVyMAs6Ic_iFZPZ5OtA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnNtYXJ0IDExNzc5MzQ5ODY1OTM5.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnNtYXJ0IDExNzc5MzQ5ODY1OTM5.txt', true, 113)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sporsmart_1_srv1', 'playz_sports_sporsmart_1', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnNtYXJ0IDExNzc5MzQ5ODY1OTM5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_racing_tv', 'Racing TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAHrya2bp_4Agtx4LiMmFWJouVsMNfNn8RsEO9xFJAyA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmFjaW5nIFRWMTc3OTM1MDIwNjM5MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmFjaW5nIFRWMTc3OTM1MDIwNjM5MA.txt', true, 114)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_racing_tv_srv1', 'playz_sports_racing_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUmFjaW5nIFRWMTc3OTM1MDIwNjM5MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tve_la', 'TVE La', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqLSDHxvq56tEXfP0ZEpPMzbvPI0rF9Px4og-aQoT71Q&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZFIExhMTc3OTM1MDM0NzM5Mg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZFIExhMTc3OTM1MDM0NzM5Mg.txt', true, 115)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tve_la_srv1', 'playz_sports_tve_la', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZFIExhMTc3OTM1MDM0NzM5Mg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tv5_monde', 'TV5 Monde', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm6i0lMpiDswFZjiNkU5bmNr54Aanz8_xGxA&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFY1IE1vbmRlMTc3OTM1MDc0ODAzMA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFY1IE1vbmRlMTc3OTM1MDc0ODAzMA.txt', true, 116)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tv5_monde_srv1', 'playz_sports_tv5_monde', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFY1IE1vbmRlMTc3OTM1MDc0ODAzMA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tvr_sport', 'TVR Sport', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKpQL-1Epixt-bYRWArpoXrVqjmuOSJWAZFyMeBNgHag&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZSIFNwb3J0MTc3OTM1MDg0MDYxOA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZSIFNwb3J0MTc3OTM1MDg0MDYxOA.txt', true, 117)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tvr_sport_srv1', 'playz_sports_tvr_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZSIFNwb3J0MTc3OTM1MDg0MDYxOA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_mnb_sport', 'MNB Sport', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBxyUtWKWSd1-f1PPvhvvir1JSyStV7U90tOrX91eyjw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTU5CIFNwb3J0MTc3OTM1MTQ4NDI0OQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTU5CIFNwb3J0MTc3OTM1MTQ4NDI0OQ.txt', true, 118)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_mnb_sport_srv1', 'playz_sports_mnb_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTU5CIFNwb3J0MTc3OTM1MTQ4NDI0OQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sport', 'Sport  🇩🇪', 'v', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgIPCfh6nwn4eqMTc3OTM1Mjc0ODA4MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgIPCfh6nwn4eqMTc3OTM1Mjc0ODA4MA.txt', true, 119)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sport_srv1', 'playz_sports_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgIPCfh6nwn4eqMTc3OTM1Mjc0ODA4MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_sport_italia_plus', 'Sport Italia Plus', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZotUGMgwAEzAxc3-oli3x7ERdMB_VJ4TqgiviGf7-3w&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgSXRhbGlhIFBsdXMxNzc5MzUzNTQwOTky.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgSXRhbGlhIFBsdXMxNzc5MzUzNTQwOTky.txt', true, 120)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_sport_italia_plus_srv1', 'playz_sports_sport_italia_plus', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU3BvcnQgSXRhbGlhIFBsdXMxNzc5MzUzNTQwOTky.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ct_sports', 'CT Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSw2p4J1WnIflvaXrJ8o6IAMqld_4jgq9CTPutDRFtzEA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ1QgU3BvcnRzMTc3OTM1Mzg3MTM2MA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ1QgU3BvcnRzMTc3OTM1Mzg3MTM2MA.txt', true, 121)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ct_sports_srv1', 'playz_sports_ct_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ1QgU3BvcnRzMTc3OTM1Mzg3MTM2MA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_arena_sport_slovakia', 'Arena Sport Slovakia', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFjTOAs_OMkcuAp9kfXnWmMFp-mvdxFbK--w&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXJlbmEgU3BvcnQgU2xvdmFraWExNzc5MzU0MjU1NTAw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXJlbmEgU3BvcnQgU2xvdmFraWExNzc5MzU0MjU1NTAw.txt', true, 122)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_arena_sport_slovakia_srv1', 'playz_sports_arena_sport_slovakia', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQXJlbmEgU3BvcnQgU2xvdmFraWExNzc5MzU0MjU1NTAw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_premiere_sports_br', 'Premiere Sports BR', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8_VUUyGGpMfqKPZHi1vPFHrE9tMXaX6ttV1_9G36GqprADCL6aHgZjpK3&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllcmUgU3BvcnRzIFVTQTE3ODAxNjAwOTM2Mzg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllcmUgU3BvcnRzIFVTQTE3ODAxNjAwOTM2Mzg.txt', true, 123)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_premiere_sports_br_srv1', 'playz_sports_premiere_sports_br', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUHJlbWllcmUgU3BvcnRzIFVTQTE3ODAxNjAwOTM2Mzg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_spotv_now', 'SPOTV NOW', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx-k3O4WUYNXjh_apAPk4V4lJ4LoBXKC_E6jo21BFZPaCEjBQuCfVy7uc&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1BPVFYgTk9XMTc4MDE2MDY2MzkwNQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1BPVFYgTk9XMTc4MDE2MDY2MzkwNQ.txt', true, 124)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_spotv_now_srv1', 'playz_sports_spotv_now', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1BPVFYgTk9XMTc4MDE2MDY2MzkwNQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_milan_tv', 'Milan TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIo9tDcowGpafL7MKi038a-hBziLWuiN15DAi_fJrkIrdFexKdQdhpzyNI&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWlsYW4gVFYxNzgwNTA4MjI4MjAz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWlsYW4gVFYxNzgwNTA4MjI4MjAz.txt', true, 125)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_milan_tv_srv1', 'playz_sports_milan_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWlsYW4gVFYxNzgwNTA4MjI4MjAz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_mlb_network', 'MLB Network', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShcHQkzqo0T_YYrxilvz0O6KhNMi_Vpyk9ndFaFI89FaM5PuobSptbC2c&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUxCIE5ldHdvcmsxNzgwNTEyNTUyOTg4.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUxCIE5ldHdvcmsxNzgwNTEyNTUyOTg4.txt', true, 126)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_mlb_network_srv1', 'playz_sports_mlb_network', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTUxCIE5ldHdvcmsxNzgwNTEyNTUyOTg4.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_stadium', 'STADIUM', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS29Oayrz7r-YmBPJgnbInUScLHU1QKFSDfUhPeUeRMg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1RBRElVTTE3ODA1MTI2OTI1NDc.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1RBRElVTTE3ODA1MTI2OTI1NDc.txt', true, 127)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_stadium_srv1', 'playz_sports_stadium', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1RBRElVTTE3ODA1MTI2OTI1NDc.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_hbo_boxing', 'HBO Boxing', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtyGcOVEiq4ePp2g-HSdkSXcqKXK3gIHVMkI5g647SKwu2glJp5eQYM5M&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSEJPIEJveGluZzE3ODA1MTI3MzMyMzU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSEJPIEJveGluZzE3ODA1MTI3MzMyMzU.txt', true, 128)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_hbo_boxing_srv1', 'playz_sports_hbo_boxing', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSEJPIEJveGluZzE3ODA1MTI3MzMyMzU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tna_impact', 'TNA IMPACT', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVJCFa8vZx4aXrhGQLwGEbnJRespGxxPUxk4vU-9jwTQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVE5BIElNUEFDVDE3ODA1MTMwNTQ1NTA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVE5BIElNUEFDVDE3ODA1MTMwNTQ1NTA.txt', true, 129)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tna_impact_srv1', 'playz_sports_tna_impact', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVE5BIElNUEFDVDE3ODA1MTMwNTQ1NTA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tyc_sports', 'TyC Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKesO0J9lX8w3GsHvRw65ZMpJi-YuOybGnZooJlAgs4g&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVHlDIFNwb3J0czE3ODEwMTU2ODM0MDI.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVHlDIFNwb3J0czE3ODEwMTU2ODM0MDI.txt', true, 130)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tyc_sports_srv1', 'playz_sports_tyc_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVHlDIFNwb3J0czE3ODEwMTU2ODM0MDI.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_caze_tv', 'CAZE TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHcTCeTFVYonuXpJ2I-kgGFppqQ3BmrHGv-zVxeFnaJA&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0FaRSBUVjE3ODIxMTA3MjA4MzQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0FaRSBUVjE3ODIxMTA3MjA4MzQ.txt', true, 131)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_caze_tv_srv1', 'playz_sports_caze_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0FaRSBUVjE3ODIxMTA3MjA4MzQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_rtb_sports', 'RTB Sports', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQL8H_gBJtKX_FYwR_A2hBErZZNE_lLXgVDk7WeNdOgDw&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUlRCIFNwb3J0czE3ODIxMTA5NTM1Mjg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUlRCIFNwb3J0czE3ODIxMTA5NTM1Mjg.txt', true, 132)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_rtb_sports_srv1', 'playz_sports_rtb_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUlRCIFNwb3J0czE3ODIxMTA5NTM1Mjg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_win_sports', 'WIN SPORTS', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSt7T54_nP7ZK3SyDRo3YWNhuLJ8ILInTGbMEApyC9XKg&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV0lOIFNQT1JUUzE3ODM2MjM3NzU5MDY.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV0lOIFNQT1JUUzE3ODM2MjM3NzU5MDY.txt', true, 133)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_win_sports_srv1', 'playz_sports_win_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjV0lOIFNQT1JUUzE3ODM2MjM3NzU5MDY.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_mtrspt', 'MTRSPT ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSU0JeKGeMtSLwNiyyoCvvNsQBluJZiGv6w0JPRNgO2tP65blnuKBkT0DRc&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTVRTUFQxNzgzNzY2Mzg3NDY5.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTVRTUFQxNzgzNzY2Mzg3NDY5.txt', true, 134)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_mtrspt_srv1', 'playz_sports_mtrspt', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTVRTUFQxNzgzNzY2Mzg3NDY5.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tve_la1_spanish', 'TVE La1 SPANISH', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgPx7TirkVq15N7KWmrvH1wqyFKAzEcGvnjUA-ljN2VA&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZFIExhMSBTUEFOSVNIMTc4NDUzODYzMTIwNA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZFIExhMSBTUEFOSVNIMTc4NDUzODYzMTIwNA.txt', true, 135)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tve_la1_spanish_srv1', 'playz_sports_tve_la1_spanish', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFZFIExhMSBTUEFOSVNIMTc4NDUzODYzMTIwNA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_ctv_sports', 'CTV SPORTS', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX6bSTsN87LuwR9-HxE_0je4GsaVpjjHy_RUWcMSce0w&s', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ1RWIFNQT1JUUzE3ODQ1Mzg2NjQxMDU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ1RWIFNQT1JUUzE3ODQ1Mzg2NjQxMDU.txt', true, 136)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_ctv_sports_srv1', 'playz_sports_ctv_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ1RWIFNQT1JUUzE3ODQ1Mzg2NjQxMDU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_d_sports', 'D SPORTS ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAsrs8ylCD_LJMr6opI--Hvu7v15G8VTbNo9u3mXC5LKRXHHawdj-jqyst&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRCBTUE9SVFMgMTc4NDUzODcyMjE3Mg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRCBTUE9SVFMgMTc4NDUzODcyMjE3Mg.txt', true, 137)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_d_sports_srv1', 'playz_sports_d_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjRCBTUE9SVFMgMTc4NDUzODcyMjE3Mg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_qazakhstan', 'QAZAKHSTAN', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQimMCcwaOhuAOvqlk2MjcRoxutTsDMnNYJs2w0Kt-td5VjWLCH0hc4uOCS&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjS0FaQUtIU1RBTjE3ODQ1Mzg3OTc2OTA.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjS0FaQUtIU1RBTjE3ODQ1Mzg3OTc2OTA.txt', true, 138)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_qazakhstan_srv1', 'playz_sports_qazakhstan', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjS0FaQUtIU1RBTjE3ODQ1Mzg3OTc2OTA.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_match_football_fhd', 'Match Football FHD', 'https://png.pngtree.com/png-vector/20190903/ourmid/pngtree-football-logo-designs-inspiration-isolated-on-white-background-png-image_1721380.jpg', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWF0Y2ggRm9vdGJhbGwgRkhEMTc4NDUzODgyMTA3Ng.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWF0Y2ggRm9vdGJhbGwgRkhEMTc4NDUzODgyMTA3Ng.txt', true, 139)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_match_football_fhd_srv1', 'playz_sports_match_football_fhd', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTWF0Y2ggRm9vdGJhbGwgRkhEMTc4NDUzODgyMTA3Ng.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_tudn_mexico', 'TUDN MEXICO', 'https://play-lh.googleusercontent.com/_9Iz8w2Ke_iHRjlgyUCz2HDSlujDqu-L-eOjsRUnUCKDRhZ97SIQCI2R4A4nwJ-Cz_qde3-t004NG3aBRbQRAiw', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFVETiBNRVhJQ08xNzg0NTM4ODc0Nzg3.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFVETiBNRVhJQ08xNzg0NTM4ODc0Nzg3.txt', true, 140)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_tudn_mexico_srv1', 'playz_sports_tudn_mexico', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjVFVETiBNRVhJQ08xNzg0NTM4ODc0Nzg3.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_canal5_aq', 'CANAL5 - AQ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGKOta2GtXZ9Y1lO1Z8JjxP6nXZH63GaPg_78PL_Xg1A&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0FOQUw1IC0gQVExNzg0NTM4ODkzNjIy.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0FOQUw1IC0gQVExNzg0NTM4ODkzNjIy.txt', true, 141)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_canal5_aq_srv1', 'playz_sports_canal5_aq', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQ0FOQUw1IC0gQVExNzg0NTM4ODkzNjIy.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_rte_sports', 'RTE SPORTS', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1RgXxdbnMlihUF8eu5Ul-_s1WHmAeeVa8HJ0bX-innmRDv3c_wSF_CJM&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUlRFIFNQT1JUUzE3ODQ1Mzg5MjI0ODc.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUlRFIFNQT1JUUzE3ODQ1Mzg5MjI0ODc.txt', true, 142)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_rte_sports_srv1', 'playz_sports_rte_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUlRFIFNQT1JUUzE3ODQ1Mzg5MjI0ODc.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_bordo_spor', 'BORDO SPOR', 'https://volleybox.net/media/upload/teams/big_1696260169WOI2Y.png', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQk9SRE8gU1BPUjE3ODU0MjQ4NjEzNjU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQk9SRE8gU1BPUjE3ODU0MjQ4NjEzNjU.txt', true, 143)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_bordo_spor_srv1', 'playz_sports_bordo_spor', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQk9SRE8gU1BPUjE3ODU0MjQ4NjEzNjU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_barcelona_hd', 'BARCELONA HD', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV6zHZsg5xeL9l2LT0h9NULMksp_Vka_8TlNL1bD7JzHFhhNElv9RaEto&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkFSQ0VMT05BIEhEMTc4NTU5Mzk2NDM3OQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkFSQ0VMT05BIEhEMTc4NTU5Mzk2NDM3OQ.txt', true, 144)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_barcelona_hd_srv1', 'playz_sports_barcelona_hd', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQkFSQ0VMT05BIEhEMTc4NTU5Mzk2NDM3OQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_mu_tv', 'MU TV', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFmrJfctFN5W3-3h6T6hGcrw5B8XU4AUHkG0OJkcAKBQ&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTVUgVFYxNzg1NTk0MDE4NzYw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTVUgVFYxNzg1NTk0MDE4NzYw.txt', true, 145)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_mu_tv_srv1', 'playz_sports_mu_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTVUgVFYxNzg1NTk0MDE4NzYw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_atn_sports', 'ATN SPORTS', 'v', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVROIFNQT1JUUzE3ODY4OTc4Mzk0NzI.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVROIFNQT1JUUzE3ODY4OTc4Mzk0NzI.txt', true, 146)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_atn_sports_srv1', 'playz_sports_atn_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjQVROIFNQT1JUUzE3ODY4OTc4Mzk0NzI.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_swerve_combat', 'SWERVE COMBAT', 'https://yt3.googleusercontent.com/jkUY7W0FRnMvtxHymn4Gm5HWUkIEkcJoHjfuvlFcfgKCQ9P45bKmogj8Rbly9ofVnz1fuxjU=s900-c-k-c0x00ffffff-no-rj', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1dFUlZFIENPTUJBVDE3ODc0ODIxNTUwOTU.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1dFUlZFIENPTUJBVDE3ODc0ODIxNTUwOTU.txt', true, 147)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_swerve_combat_srv1', 'playz_sports_swerve_combat', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjU1dFUlZFIENPTUJBVDE3ODc0ODIxNTUwOTU.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_one_fight', 'ONE FIGHT', 'https://upload.wikimedia.org/wikipedia/en/b/b0/ONE_Championship_company_logo.png?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=original', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT05FIEZJR0hUMTc4NzQ4MjI0NDA5Mw.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT05FIEZJR0hUMTc4NzQ4MjI0NDA5Mw.txt', true, 148)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_one_fight_srv1', 'playz_sports_one_fight', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjT05FIEZJR0hUMTc4NzQ4MjI0NDA5Mw.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_nova_sport', 'NOVA SPORT ', 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Nova_Sport.png?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=original', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTk9WQSBTUE9SVCAxNzg3NDgzMzExMDUx.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTk9WQSBTUE9SVCAxNzg3NDgzMzExMDUx.txt', true, 149)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_nova_sport_srv1', 'playz_sports_nova_sport', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjTk9WQSBTUE9SVCAxNzg3NDgzMzExMDUx.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_itv', 'ITV', 'https://yt3.googleusercontent.com/W9GOUTsGfQVjp3CW_gfhadrI9TB5nAli5miphJfTr46PsrP5ThGVw8XoO6TEU8VF8q4WFLVF908=s900-c-k-c0x00ffffff-no-rj', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSVRWMTc4NzQ4NDk5NDY3Ng.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSVRWMTc4NzQ4NDk5NDY3Ng.txt', true, 150)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_itv_srv1', 'playz_sports_itv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSVRWMTc4NzQ4NDk5NDY3Ng.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_joj_sports', 'JOJ SPORTS ', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgFr2X2Hu74oo5W3npqMrwJ02pIQ3A2Yk_N9GX5rkPQRrhwxej3iRJNUzq&s=10', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSk9KIFNQT1JUUyAxNzg3NTkzMzYzOTgz.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSk9KIFNQT1JUUyAxNzg3NTkzMzYzOTgz.txt', true, 151)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_joj_sports_srv1', 'playz_sports_joj_sports', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjSk9KIFNQT1JUUyAxNzg3NTkzMzYzOTgz.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_unite8_sports_2_hd', 'unite8 sports 2 HD', 'https://yt3.googleusercontent.com/K7y_STeJgNr3tP3m0F_Gk0rwsWE3Rs5GITVwKqc2ootLiKtyIxIH0K1XLk8NvwjI-iFqCJM78w=s900-c-k-c0x00ffffff-no-rj', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjdW5pdGU4IHNwb3J0cyAyIEhEMTc5MDc1NjI2NzMzMg.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjdW5pdGU4IHNwb3J0cyAyIEhEMTc5MDc1NjI2NzMzMg.txt', true, 152)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_unite8_sports_2_hd_srv1', 'playz_sports_unite8_sports_2_hd', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjdW5pdGU4IHNwb3J0cyAyIEhEMTc5MDc1NjI2NzMzMg.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('playz_sports_pbb_tv', 'PBB TV', 'x', 'sports', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUEJCIFRWMTc5MjMzODc3MDA5OQ.txt', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUEJCIFRWMTc5MjMzODc3MDA5OQ.txt', true, 153)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('playz_sports_pbb_tv_srv1', 'playz_sports_pbb_tv', 'Server 1', 'pro/VTNCdmNuUnpJREUzTmpjd01EY3dNamMxTmpjUEJCIFRWMTc5MjMzODc3MDA5OQ.txt', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_0', 'Premier League TV', 'https://assets.myco.io/public/compressed/thumbnails/20260327/mycolive-1920x1080-1774610836063.webp', 'pakistan', 'https://cdn01.medialive.one:2096/mycolive2/index.m3u8', 'https://cdn01.medialive.one:2096/mycolive2/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_0_srv1', 'm3u_pakistan_0', 'Server 1', 'https://cdn01.medialive.one:2096/mycolive2/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_1', 'myco sports 24/7', 'https://assets.myco.io/public/compressed/thumbnails/20260523/mycolive-Group_4-1779534476704.webp', 'pakistan', 'https://cdn01.medialive.one:2096/mycolive1/index.m3u8', 'https://cdn01.medialive.one:2096/mycolive1/index.m3u8', true, 2)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_1_srv1', 'm3u_pakistan_1', 'Server 1', 'https://cdn01.medialive.one:2096/mycolive1/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_2', 'Al Jazeera', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Al-Jazeera-1771347547574.webp', 'pakistan', 'https://cdn01.medialive.one:2096/ALJAZEERAFHD/index.m3u8', 'https://cdn01.medialive.one:2096/ALJAZEERAFHD/index.m3u8', true, 3)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_2_srv1', 'm3u_pakistan_2', 'Server 1', 'https://cdn01.medialive.one:2096/ALJAZEERAFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_3', 'CGTN English', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-CGTN-english-1771350239747.webp', 'pakistan', 'https://livealiglobal-myco.cctv.cn/hls/yyctzb2m/playlist.m3u8?wsSecret=0b171fe55bcf55d8a063b1109782b431&wsTime=1780317133', 'https://livealiglobal-myco.cctv.cn/hls/yyctzb2m/playlist.m3u8?wsSecret=0b171fe55bcf55d8a063b1109782b431&wsTime=1780317133', true, 4)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_3_srv1', 'm3u_pakistan_3', 'Server 1', 'https://livealiglobal-myco.cctv.cn/hls/yyctzb2m/playlist.m3u8?wsSecret=0b171fe55bcf55d8a063b1109782b431&wsTime=1780317133', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_4', 'Hum TV', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-hum-tv-1771351912443.webp', 'pakistan', 'https://cdn01.medialive.one:2096/HUMENTFHD/index.m3u8', 'https://cdn01.medialive.one:2096/HUMENTFHD/index.m3u8', true, 5)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_4_srv1', 'm3u_pakistan_4', 'Server 1', 'https://cdn01.medialive.one:2096/HUMENTFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_5', 'Green Entertainment TV | Live Free Streaming', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Green-Entertainment-1771351669169.webp', 'pakistan', 'https://cdn01.medialive.one:2096/GREENENTFHD/index.m3u8', 'https://cdn01.medialive.one:2096/GREENENTFHD/index.m3u8', true, 6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_5_srv1', 'm3u_pakistan_5', 'Server 1', 'https://cdn01.medialive.one:2096/GREENENTFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_6', 'HBO 2', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-HBO2-1771351753823.webp', 'pakistan', 'https://cdn01.medialive.one:2096/HBO2FHD/index.m3u8', 'https://cdn01.medialive.one:2096/HBO2FHD/index.m3u8', true, 7)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_6_srv1', 'm3u_pakistan_6', 'Server 1', 'https://cdn01.medialive.one:2096/HBO2FHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_7', 'Geo Entertainment', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-GEO-1771351398088.webp', 'pakistan', 'https://cdn01.medialive.one:2096/GEOENTFHD/index.m3u8', 'https://cdn01.medialive.one:2096/GEOENTFHD/index.m3u8', true, 8)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_7_srv1', 'm3u_pakistan_7', 'Server 1', 'https://cdn01.medialive.one:2096/GEOENTFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_8', 'ARY Digital', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-ary-hd-1771348948665.webp', 'pakistan', 'https://cdn01.medialive.one:2096/ARYDIGITALFHD/index.m3u8', 'https://cdn01.medialive.one:2096/ARYDIGITALFHD/index.m3u8', true, 9)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_8_srv1', 'm3u_pakistan_8', 'Server 1', 'https://cdn01.medialive.one:2096/ARYDIGITALFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_9', 'Bol Entertainment', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-BOL-1771349378715.webp', 'pakistan', 'https://cdn01.medialive.one:2096/BOLENTFHD/index.m3u8', 'https://cdn01.medialive.one:2096/BOLENTFHD/index.m3u8', true, 10)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_9_srv1', 'm3u_pakistan_9', 'Server 1', 'https://cdn01.medialive.one:2096/BOLENTFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_10', 'Express Entertainment', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Express-hd-1771351175130.webp', 'pakistan', 'https://cdn01.medialive.one:2096/EXPENTFHD/index.m3u8', 'https://cdn01.medialive.one:2096/EXPENTFHD/index.m3u8', true, 11)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_10_srv1', 'm3u_pakistan_10', 'Server 1', 'https://cdn01.medialive.one:2096/EXPENTFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_11', 'Buypass TV', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Buy-Pass-TV-1771349581379.webp', 'pakistan', 'https://cdn01.medialive.one:2096/BUYPASSTVFHD/index.m3u8', 'https://cdn01.medialive.one:2096/BUYPASSTVFHD/index.m3u8', true, 12)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_11_srv1', 'm3u_pakistan_11', 'Server 1', 'https://cdn01.medialive.one:2096/BUYPASSTVFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_12', 'SAB TV', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Sab-TV-1771351045739.webp', 'pakistan', 'https://cdn01.medialive.one:2096/SABENTFHD/index.m3u8', 'https://cdn01.medialive.one:2096/SABENTFHD/index.m3u8', true, 13)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_12_srv1', 'm3u_pakistan_12', 'Server 1', 'https://cdn01.medialive.one:2096/SABENTFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_13', 'Day-14 | Tennis | Wimbledon 2026 | Your Seat at The Centre Court | Bangladesh | only on myco', 'https://assets.myco.io/public/compressed/thumbnails/20260701/mycolive-1920x1080_LIVE-FREE-1782910318345.webp', 'pakistan', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', true, 14)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_13_srv1', 'm3u_pakistan_13', 'Server 1', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_14', 'Day-12 | Tennis | Wimbledon 2026 | Your Seat at The Centre Court | Bangladesh | only on myco', 'https://assets.myco.io/public/compressed/thumbnails/20260701/mycolive-1920x1080_LIVE-FREE-1782910096742.webp', 'pakistan', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', true, 15)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_14_srv1', 'm3u_pakistan_14', 'Server 1', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_15', 'Day-13 | Tennis | Wimbledon 2026 | Your Seat at The Centre Court | Bangladesh | only on myco', 'https://assets.myco.io/public/compressed/thumbnails/20260701/mycolive-1920x1080_LIVE-FREE-1782910177579.webp', 'pakistan', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', true, 16)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_15_srv1', 'm3u_pakistan_15', 'Server 1', 'https://tencent-live.myco.io/v1/019d54636d6e15e8f0601f740a5939/019d5463e42015e8f4121e4aae90f7/main.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_16', 'Premier League TV', 'https://assets.myco.io/public/compressed/thumbnails/20260327/mycolive-1920x1080-1774610836063.webp', 'pakistan', 'https://cdn01.medialive.one:2096/mycolive2/index.m3u8', 'https://cdn01.medialive.one:2096/mycolive2/index.m3u8', true, 17)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_16_srv1', 'm3u_pakistan_16', 'Server 1', 'https://cdn01.medialive.one:2096/mycolive2/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_17', 'myco sports 24/7', 'https://assets.myco.io/public/compressed/thumbnails/20260523/mycolive-Group_4-1779534476704.webp', 'pakistan', 'https://cdn01.medialive.one:2096/mycolive1/index.m3u8', 'https://cdn01.medialive.one:2096/mycolive1/index.m3u8', true, 18)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_17_srv1', 'm3u_pakistan_17', 'Server 1', 'https://cdn01.medialive.one:2096/mycolive1/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_18', 'Al Jazeera', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Al-Jazeera-1771347547574.webp', 'pakistan', 'https://cdn01.medialive.one:2096/ALJAZEERAFHD/index.m3u8', 'https://cdn01.medialive.one:2096/ALJAZEERAFHD/index.m3u8', true, 19)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_18_srv1', 'm3u_pakistan_18', 'Server 1', 'https://cdn01.medialive.one:2096/ALJAZEERAFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_19', 'CGTN Arabic', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-CGTN-Arabia-1771349829623.webp', 'pakistan', 'https://livealiglobal-myco.cctv.cn/hls/ayuchangtai2m/playlist.m3u8?wsSecret=306feac2cef75fe7e8c400005c710c6d&wsTime=1780316098', 'https://livealiglobal-myco.cctv.cn/hls/ayuchangtai2m/playlist.m3u8?wsSecret=306feac2cef75fe7e8c400005c710c6d&wsTime=1780316098', true, 20)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_19_srv1', 'm3u_pakistan_19', 'Server 1', 'https://livealiglobal-myco.cctv.cn/hls/ayuchangtai2m/playlist.m3u8?wsSecret=306feac2cef75fe7e8c400005c710c6d&wsTime=1780316098', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_20', 'MUN TV', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-MUNN-TV-1771351661783.webp', 'pakistan', 'https://cdn01.medialive.one:2096/MUNTVFHD/index.m3u8', 'https://cdn01.medialive.one:2096/MUNTVFHD/index.m3u8', true, 21)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_20_srv1', 'm3u_pakistan_20', 'Server 1', 'https://cdn01.medialive.one:2096/MUNTVFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_21', 'Buypass TV', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Buy-Pass-TV-1771349581379.webp', 'pakistan', 'https://cdn01.medialive.one:2096/BUYPASSTVFHD/index.m3u8', 'https://cdn01.medialive.one:2096/BUYPASSTVFHD/index.m3u8', true, 22)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_21_srv1', 'm3u_pakistan_21', 'Server 1', 'https://cdn01.medialive.one:2096/BUYPASSTVFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_22', 'Mix TV - Hollywood', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-MIX-tv-1771351720744.webp', 'pakistan', 'https://ml-pull-hwc.myco.io/MixTV/hls/index.m3u8', 'https://ml-pull-hwc.myco.io/MixTV/hls/index.m3u8', true, 23)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_22_srv1', 'm3u_pakistan_22', 'Server 1', 'https://ml-pull-hwc.myco.io/MixTV/hls/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_23', 'Discover Pakistan', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Discover-hd-1771350386975.webp', 'pakistan', 'https://cdn01.medialive.one:2096/DISCOVERPAKFHD/index.m3u8', 'https://cdn01.medialive.one:2096/DISCOVERPAKFHD/index.m3u8', true, 24)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_23_srv1', 'm3u_pakistan_23', 'Server 1', 'https://cdn01.medialive.one:2096/DISCOVERPAKFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_24', 'CGTN Documentary', 'https://assets.myco.io/public/compressed/thumbnails/20250128/mycolive-cgtnjpg-1738072396919.webp', 'pakistan', 'https://global.cgtn.cicc.media.caton.cloud/master/cgtn-documentary_myco.m3u8', 'https://global.cgtn.cicc.media.caton.cloud/master/cgtn-documentary_myco.m3u8', true, 25)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_24_srv1', 'm3u_pakistan_24', 'Server 1', 'https://global.cgtn.cicc.media.caton.cloud/master/cgtn-documentary_myco.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_25', 'Watch Aaj News Live Stream for Free on myco', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Aj-News-1771347190122.webp', 'pakistan', 'https://cdn01.medialive.one:2096/AAJNEWSFHD/index.m3u8', 'https://cdn01.medialive.one:2096/AAJNEWSFHD/index.m3u8', true, 26)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_25_srv1', 'm3u_pakistan_25', 'Server 1', 'https://cdn01.medialive.one:2096/AAJNEWSFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_26', 'Saudi Quran TV', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Al-Quran-1771347645745.webp', 'pakistan', 'https://cdn01.medialive.one:2096/SAUDIQURANFHD/index.m3u8', 'https://cdn01.medialive.one:2096/SAUDIQURANFHD/index.m3u8', true, 27)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_26_srv1', 'm3u_pakistan_26', 'Server 1', 'https://cdn01.medialive.one:2096/SAUDIQURANFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_27', 'Hyder TV', 'https://assets.myco.io/public/compressed/thumbnails/20260217/mycolive-Hyder-TV-Canada-1771352008728.webp', 'pakistan', 'https://cdn01.medialive.one:2096/HYDERTVFHD/index.m3u8', 'https://cdn01.medialive.one:2096/HYDERTVFHD/index.m3u8', true, 28)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_27_srv1', 'm3u_pakistan_27', 'Server 1', 'https://cdn01.medialive.one:2096/HYDERTVFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_28', 'Peace TV Urdu', 'https://assets.myco.io/public/compressed/thumbnails/20260307/mycolive-33_copy_21-1772917179916.webp', 'pakistan', 'https://cdn01.medialive.one:2096/PEACETVURDUFHD/index.m3u8', 'https://cdn01.medialive.one:2096/PEACETVURDUFHD/index.m3u8', true, 29)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_28_srv1', 'm3u_pakistan_28', 'Server 1', 'https://cdn01.medialive.one:2096/PEACETVURDUFHD/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_29', 'Channel 30', '', 'pakistan', 'https://api-ott.tidpix.com/loggingmediaurlpassthrough/a.m3u8?version=12&id=10&partner=general_test', 'https://api-ott.tidpix.com/loggingmediaurlpassthrough/a.m3u8?version=12&id=10&partner=general_test', true, 30)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_29_srv1', 'm3u_pakistan_29', 'Server 1', 'https://api-ott.tidpix.com/loggingmediaurlpassthrough/a.m3u8?version=12&id=10&partner=general_test', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_30', '92 News HD', '', 'pakistan', 'http://92news.vdn.dstreamone.net/92newshd/92hd/playlist.m3u8', 'http://92news.vdn.dstreamone.net/92newshd/92hd/playlist.m3u8', true, 31)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_30_srv1', 'm3u_pakistan_30', 'Server 1', 'http://92news.vdn.dstreamone.net/92newshd/92hd/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_31', 'City News HD', '', 'pakistan', 'http://cdn.citymediagroupreg.com:1935/citynewshd/myStream/playlist.m3u8', 'http://cdn.citymediagroupreg.com:1935/citynewshd/myStream/playlist.m3u8', true, 32)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_31_srv1', 'm3u_pakistan_31', 'Server 1', 'http://cdn.citymediagroupreg.com:1935/citynewshd/myStream/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_32', 'Dunya News', '', 'pakistan', 'https://ukintl.dunyanews.tv/liveuk/ngrp:dunyalive_all/playlist.m3u8', 'https://ukintl.dunyanews.tv/liveuk/ngrp:dunyalive_all/playlist.m3u8', true, 33)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_32_srv1', 'm3u_pakistan_32', 'Server 1', 'https://ukintl.dunyanews.tv/liveuk/ngrp:dunyalive_all/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_33', 'Fazal TV', '', 'pakistan', 'http://cdn9.live247stream.com/punjabitvcanada/tv/playlist.m3u8', 'http://cdn9.live247stream.com/punjabitvcanada/tv/playlist.m3u8', true, 34)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_33_srv1', 'm3u_pakistan_33', 'Server 1', 'http://cdn9.live247stream.com/punjabitvcanada/tv/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_34', 'Gawahi TV', '', 'pakistan', 'https://livecdn.live247stream.com/gawahi/tv/playlist.m3u8', 'https://livecdn.live247stream.com/gawahi/tv/playlist.m3u8', true, 35)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_34_srv1', 'm3u_pakistan_34', 'Server 1', 'https://livecdn.live247stream.com/gawahi/tv/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_35', 'God Stands TV', '', 'pakistan', 'https://online.godstands.tv:5443/WebRTCApp/streams/mainlive.m3u8', 'https://online.godstands.tv:5443/WebRTCApp/streams/mainlive.m3u8', true, 36)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_35_srv1', 'm3u_pakistan_35', 'Server 1', 'https://online.godstands.tv:5443/WebRTCApp/streams/mainlive.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_36', 'God Stands TV Arabic', '', 'pakistan', 'https://online.godstands.tv:5443/WebRTCApp/streams/Arabic.m3u8', 'https://online.godstands.tv:5443/WebRTCApp/streams/Arabic.m3u8', true, 37)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_36_srv1', 'm3u_pakistan_36', 'Server 1', 'https://online.godstands.tv:5443/WebRTCApp/streams/Arabic.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_37', 'God Stands TV Chinese', '', 'pakistan', 'https://online.godstands.tv:5443/WebRTCApp/streams/chineselive.m3u8', 'https://online.godstands.tv:5443/WebRTCApp/streams/chineselive.m3u8', true, 38)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_37_srv1', 'm3u_pakistan_37', 'Server 1', 'https://online.godstands.tv:5443/WebRTCApp/streams/chineselive.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_38', 'God Stands TV Hindi', '', 'pakistan', 'https://online.godstands.tv:5443/WebRTCApp/streams/HindiStreaming.m3u8', 'https://online.godstands.tv:5443/WebRTCApp/streams/HindiStreaming.m3u8', true, 39)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_38_srv1', 'm3u_pakistan_38', 'Server 1', 'https://online.godstands.tv:5443/WebRTCApp/streams/HindiStreaming.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_39', 'God Stands TV Urdu', '', 'pakistan', 'https://online.godstands.tv:5443/WebRTCApp/streams/UrduStreaming.m3u8', 'https://online.godstands.tv:5443/WebRTCApp/streams/UrduStreaming.m3u8', true, 40)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_39_srv1', 'm3u_pakistan_39', 'Server 1', 'https://online.godstands.tv:5443/WebRTCApp/streams/UrduStreaming.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_40', 'Grace Network', '', 'pakistan', 'https://livecdn.live247stream.com/grace/tv/playlist.m3u8', 'https://livecdn.live247stream.com/grace/tv/playlist.m3u8', true, 41)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_40_srv1', 'm3u_pakistan_40', 'Server 1', 'https://livecdn.live247stream.com/grace/tv/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_41', 'Hum TV', '', 'pakistan', 'https://g4wlkwx8l23a-hls-live.5centscdn.com/HUM/271ddf829afeece44d8732757fba1a66.sdp/playlist_dvr.m3u8', 'https://g4wlkwx8l23a-hls-live.5centscdn.com/HUM/271ddf829afeece44d8732757fba1a66.sdp/playlist_dvr.m3u8', true, 42)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_41_srv1', 'm3u_pakistan_41', 'Server 1', 'https://g4wlkwx8l23a-hls-live.5centscdn.com/HUM/271ddf829afeece44d8732757fba1a66.sdp/playlist_dvr.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_42', 'Joshua TV', '', 'pakistan', 'https://livecdn.live247stream.com/joshua/tv/playlist.m3u8', 'https://livecdn.live247stream.com/joshua/tv/playlist.m3u8', true, 43)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_42_srv1', 'm3u_pakistan_42', 'Server 1', 'https://livecdn.live247stream.com/joshua/tv/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_43', 'King TV', '', 'pakistan', 'https://streamer12.vdn.dstreamone.net/kingtv/kingtv/playlist.m3u8', 'https://streamer12.vdn.dstreamone.net/kingtv/kingtv/playlist.m3u8', true, 44)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_43_srv1', 'm3u_pakistan_43', 'Server 1', 'https://streamer12.vdn.dstreamone.net/kingtv/kingtv/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_44', 'PMI TV', '', 'pakistan', 'https://cdn.live247stream.com/pmi/tv/playlist.m3u8', 'https://cdn.live247stream.com/pmi/tv/playlist.m3u8', true, 45)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_44_srv1', 'm3u_pakistan_44', 'Server 1', 'https://cdn.live247stream.com/pmi/tv/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_45', 'Praise TV', '', 'pakistan', 'https://pixelsmedia.live/livepraisetv/index.m3u8', 'https://pixelsmedia.live/livepraisetv/index.m3u8', true, 46)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_45_srv1', 'm3u_pakistan_45', 'Server 1', 'https://pixelsmedia.live/livepraisetv/index.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

INSERT INTO public.channels (id, name, logo, category, stream_url, playz_links, is_active, sort_order)
VALUES ('m3u_pakistan_46', 'Such TV', '', 'pakistan', 'https://video.primexsports.com/suchnews/live/playlist.m3u8', 'https://video.primexsports.com/suchnews/live/playlist.m3u8', true, 47)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  playz_links = EXCLUDED.playz_links,
  sort_order = EXCLUDED.sort_order;

INSERT INTO public.stream_servers (id, channel_id, server_name, stream_url, is_active, sort_order)
VALUES ('m3u_pakistan_46_srv1', 'm3u_pakistan_46', 'Server 1', 'https://video.primexsports.com/suchnews/live/playlist.m3u8', true, 1)
ON CONFLICT (id) DO UPDATE SET
  stream_url = EXCLUDED.stream_url;

UPDATE public.sync_versions 
SET channels_version = channels_version + 1, updated_at = NOW() 
WHERE id = (SELECT id FROM public.sync_versions LIMIT 1);
