import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> characters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    try {
      int randomPage = Random().nextInt(40) + 1; 
      final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character/?page=$randomPage'));
      
      if (response.statusCode == 200) {
        setState(() {
          characters = jsonDecode(response.body)['results'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        title: Text('Feed', style: AppTextStyles.heading2),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border_rounded, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: SizedBox(
                      height: 105,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return _buildStoryItem(index, characters[index]);
                        },
                      ),
                    ),
                  ),
                  Divider(height: 1, color: AppColors.textSecondary.withOpacity(0.1)),
                  
                  ...characters.skip(8).map((char) {
                    int randomPostImageId = Random().nextInt(826) + 1;
                    int likesCount = Random().nextInt(5000) + 100;
                    String locationName = char['location']['name'] ?? 'Unknown Dimension';
                    List<String> captions = [
                      'Just travelled across the multiverse to $locationName! The dimensions here are absolutely mind-blowing. 🌌',
                      'Wubba Lubba Dub Dub! 🤪 Hanging out in $locationName today.',
                      'Meet ${char['name']}, one of the most interesting ${char['species']}s I have ever seen! 👽',
                      'Nobody exists on purpose. Nobody belongs anywhere. Come watch TV at $locationName. 📺',
                      'Another crazy adventure! 🚀 Status: ${char['status']} right now.',
                      'Got into some trouble at $locationName... Classic Rick and Morty adventure! 🔫',
                      'Studying the anatomy of a ${char['species']} today. Science is fun! 🔬'
                    ];
                    String randomCaption = captions[Random().nextInt(captions.length)];

                    return _PostCard(
                      username: char['name'],
                      location: locationName,
                      avatarUrl: char['image'],
                      postImageUrl: 'https://rickandmortyapi.com/api/character/avatar/$randomPostImageId.jpeg',
                      initialLikes: likesCount,
                      caption: randomCaption,
                      tags: '#RickAndMorty #${char['species'].toString().replaceAll(' ', '')}',
                    );
                  }),
                ],
              ),
      ),
    );
  }

  Widget _buildStoryItem(int index, dynamic character) {
    bool isMyStory = index == 0;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isMyStory ? null : AppColors.primaryGradient,
                  border: isMyStory ? Border.all(color: AppColors.textSecondary.withOpacity(0.2), width: 1) : null,
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    backgroundImage: isMyStory 
                        ? const AssetImage('assets/images/pfp.jpg') as ImageProvider
                        : NetworkImage(character['image']),
                  ),
                ),
              ),
              if (isMyStory)
                Container(
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                )
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Text(
              isMyStory ? 'Your Story' : character['name'],
              style: TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: isMyStory ? FontWeight.w600 : FontWeight.normal),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final String username;
  final String location;
  final String avatarUrl;
  final String postImageUrl;
  final int initialLikes;
  final String caption;
  final String tags;

  const _PostCard({
    required this.username,
    required this.location,
    required this.avatarUrl,
    required this.postImageUrl,
    required this.initialLikes,
    required this.caption,
    required this.tags,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool isLiked = false;
  bool isSaved = false;
  late int likesCount;
  bool showHeart = false; // สำหรับโชว์แอนิเมชันหัวใจกลางรูป

  @override
  void initState() {
    super.initState();
    likesCount = widget.initialLikes;
  }

  void toggleLikeBtn() {
    setState(() {
      isLiked = !isLiked;
      isLiked ? likesCount++ : likesCount--;
    });
  }

  void handleDoubleTap() {
    setState(() {
      showHeart = true;
      if (!isLiked) {
        isLiked = true;
        likesCount++;
      }
    });
    // ตั้งเวลาซ่อนหัวใจ
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => showHeart = false);
    });
  }

  void toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.6),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withOpacity(0.2), backgroundImage: NetworkImage(widget.avatarUrl)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(widget.location, style: TextStyle(color: AppColors.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: handleDoubleTap,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ใช้ Image.network ตรงๆ พร้อม errorBuilder ดักรูปเสีย
                  Image.network(
                    widget.postImageUrl, 
                    width: double.infinity, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primary.withOpacity(0.2),
                      child: const Center(child: Icon(Icons.broken_image_rounded, size: 50, color: AppColors.primary)),
                    ),
                  ),
                  // แอนิเมชันหัวใจ IG
                  AnimatedOpacity(
                    opacity: showHeart ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedScale(
                      scale: showHeart ? 1.2 : 0.5,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 100),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                IconButton(icon: Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded), color: isLiked ? Colors.red : AppColors.textPrimary, iconSize: 28, onPressed: toggleLikeBtn),
                IconButton(icon: const Icon(Icons.chat_bubble_outline_rounded), color: AppColors.textPrimary, iconSize: 26, onPressed: () {}),
                IconButton(icon: const Icon(Icons.send_rounded), color: AppColors.textPrimary, iconSize: 26, onPressed: () {}),
                const Spacer(),
                IconButton(icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded), color: isSaved ? AppColors.primary : AppColors.textPrimary, iconSize: 28, onPressed: toggleSave),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${likesCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} likes', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    children: [
                      TextSpan(text: '${widget.username} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: widget.caption),
                      TextSpan(text: '\n${widget.tags}', style: const TextStyle(color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('View all comments', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}