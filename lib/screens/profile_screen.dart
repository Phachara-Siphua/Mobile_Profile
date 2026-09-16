import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Text('Profile Page', style: AppTextStyles.heading1),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 65,
                          backgroundColor: AppColors.secondary,
                          backgroundImage: AssetImage('assets/images/pfp.jpg'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Account Settings',
                    style: AppTextStyles.heading2.copyWith(fontSize: 22),
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuCard(
                  children: [
                    HoverableListTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Manage your password',
                      iconRight: Icons.arrow_forward_ios,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    HoverableListTile(
                      icon: Icons.notifications_none_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage your notifications',
                      iconRight: Icons.arrow_forward_ios,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    HoverableListTile(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      subtitle: 'Sign out of your account',
                      iconRight: Icons.arrow_forward_ios,
                      onTap: () {
                        // เพิ่ม showDialog เพื่อแสดง Popup ยืนยันการออกจากระบบ
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                'Confirm Logout',
                                style: AppTextStyles.heading2.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to log out of your account?',
                                style: AppTextStyles.heading3.copyWith(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    ); // ปิด Popup หากเปลี่ยนใจ
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // เปลี่ยนเส้นทางจาก '/login' เป็น '/onboarding'
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/onboarding',
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Preferences',
                    style: AppTextStyles.heading2.copyWith(fontSize: 22),
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuCard(
                  children: [
                    HoverableListTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: 'Toggle app theme',
                      iconRight: Icons.arrow_forward_ios,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    HoverableListTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'Change app language',
                      iconRight: Icons.arrow_forward_ios,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        height: 1,
        color: AppColors.textSecondary.withOpacity(0.1),
      ),
    );
  }
}

class HoverableListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final IconData iconRight;
  final VoidCallback? onTap;

  const HoverableListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconRight,
    this.onTap,
    super.key,
  });

  @override
  State<HoverableListTile> createState() => _HoverableListTileState();
}

class _HoverableListTileState extends State<HoverableListTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: _isHovering ? AppColors.hoverBg : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isHovering ? AppColors.hoverBorder : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isHovering
                      ? Colors.white
                      : AppColors.bgGradient.colors.first.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovering
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  size: 22,
                ),
              ),
              title: Text(
                widget.title,
                style: AppTextStyles.heading2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                widget.subtitle,
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.only(right: _isHovering ? 4 : 8),
                child: Icon(
                  widget.iconRight,
                  size: 14,
                  color: _isHovering
                      ? AppColors.primary
                      : AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
