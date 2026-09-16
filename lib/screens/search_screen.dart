import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<int> randomCharacterIds;

  @override
  void initState() {
    super.initState();
    _generateRandomImages();
  }

  void _generateRandomImages() {
    randomCharacterIds = List.generate(60, (index) => Random().nextInt(826) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search multiverses...',
                      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6)),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _generateRandomImages();
                    });
                  },
                  color: AppColors.primary,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: randomCharacterIds.length,
                    itemBuilder: (context, index) {
                      int charId = randomCharacterIds[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SearchDetailPopup(characterId: charId),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                          child: Image.network(
                            'https://rickandmortyapi.com/api/character/avatar/$charId.jpeg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image_rounded, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDetailPopup extends StatefulWidget {
  final int characterId;
  const SearchDetailPopup({super.key, required this.characterId});

  @override
  State<SearchDetailPopup> createState() => _SearchDetailPopupState();
}

class _SearchDetailPopupState extends State<SearchDetailPopup> {
  Map<String, dynamic>? characterData;
  bool isLoading = true;
  late int randomPosterId;

  @override
  void initState() {
    super.initState();
    randomPosterId = Random().nextInt(826) + 1;
    fetchCharacterDetail();
  }

  Future<void> fetchCharacterDetail() async {
    try {
      final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character/${widget.characterId}'));
      if (response.statusCode == 200) {
        setState(() {
          characterData = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.bgGradient,
      ),
      child: isLoading
          ? const SizedBox(height: 300, child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
          : SingleChildScrollView(
              child: _DetailPostCard(
                username: characterData!['name'],
                location: characterData!['location']['name'] ?? 'Unknown',
                avatarUrl: 'https://rickandmortyapi.com/api/character/avatar/$randomPosterId.jpeg',
                postImageUrl: characterData!['image'],
                initialLikes: Random().nextInt(5000) + 100,
                caption: 'Check out this awesome view at ${characterData!['location']['name']}! The multiverse never ceases to amaze me. 🚀',
                tags: '#RickAndMorty #${characterData!['species'].toString().replaceAll(' ', '')} #Explore',
              ),
            ),
    );
  }
}

class _DetailPostCard extends StatefulWidget {
  final String username;
  final String location;
  final String avatarUrl;
  final String postImageUrl;
  final int initialLikes;
  final String caption;
  final String tags;

  const _DetailPostCard({
    required this.username,
    required this.location,
    required this.avatarUrl,
    required this.postImageUrl,
    required this.initialLikes,
    required this.caption,
    required this.tags,
  });

  @override
  State<_DetailPostCard> createState() => _DetailPostCardState();
}

class _DetailPostCardState extends State<_DetailPostCard> {
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                )
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
                  Image.network(
                    widget.postImageUrl, 
                    width: double.infinity, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primary.withOpacity(0.2),
                      child: const Center(child: Icon(Icons.broken_image_rounded, size: 50, color: AppColors.primary)),
                    ),
                  ),
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}