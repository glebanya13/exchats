import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exchats/ui/screens/home/profile/privacy/black_list_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/calls_privacy_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/enable_password_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/forwarding_privacy_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/last_seen_privacy_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/messages_privacy_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/password_settings_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/phone_number_privacy_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/profile_photos_privacy_screen.dart';
import 'package:exchats/ui/screens/home/profile/privacy/voice_messages_privacy_screen.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _hasPassword = false;

  @override
  void initState() {
    super.initState();
    _checkPasswordStatus();
  }

  Future<void> _checkPasswordStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasPassword = prefs.getString('app_password') != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            // Security Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Безопасность',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildSecurityItem(
                    iconAsset: 'assets/profile/black_list.svg',
                    title: 'Черный список',
                    value: '104',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BlackListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildSecurityItem(
                    iconAsset: 'assets/profile/password.svg',
                    title: 'Пароль',
                    value: _hasPassword ? 'Вкл' : 'Выкл',
                    onTap: () async {
                      if (_hasPassword) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PasswordSettingsScreen(),
                          ),
                        );
                        _checkPasswordStatus();
                      } else {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EnablePasswordScreen(),
                          ),
                        );
                        _checkPasswordStatus();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            // Privacy Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Конфиденциальность',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildPrivacyItem(
                    title: 'Номер телефона',
                    value: 'Никто',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PhoneNumberPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildPrivacyItem(
                    title: 'Время захода',
                    value: 'Никто',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LastSeenPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildPrivacyItem(
                    title: 'Фотографии профиля',
                    value: 'Контакты',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfilePhotosPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildPrivacyItem(
                    title: 'Пересылка сообщений',
                    value: 'Все',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForwardingPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildPrivacyItem(
                    title: 'Звонки',
                    value: 'Все',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CallsPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildPrivacyItem(
                    title: 'Голосовые сообщения',
                    value: 'Никто',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const VoiceMessagesPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildPrivacyItem(
                    title: 'Сообщения',
                    value: 'Контакты',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MessagesPrivacyScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityItem({
    required String iconAsset,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 24.0,
              height: 24.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyItem({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

