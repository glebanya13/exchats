import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessAccountScreen extends StatelessWidget {
  const BusinessAccountScreen({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  _buildBusinessItem(
                    iconAsset: 'assets/profile/bussines/time.svg',
                    iconColor: Colors.orange,
                    title: 'Часы работы',
                    subtitle: 'График работы по всем дням работы',
                  ),
                  const SizedBox(height: 8.0),
                  _buildBusinessItem(
                    iconAsset: 'assets/profile/bussines/fast.svg',
                    iconColor: Colors.pink,
                    title: 'Быстрые ответы',
                    subtitle: 'Заготовки ответов',
                  ),
                  const SizedBox(height: 8.0),
                  _buildBusinessItem(
                    iconAsset: 'assets/profile/bussines/hello.svg',
                    iconColor: Colors.purple,
                    title: 'Приветствия',
                    subtitle:
                        'Автоматическое сообщение для новых пользователей',
                  ),
                  const SizedBox(height: 8.0),
                  _buildBusinessItem(
                    iconAsset: 'assets/profile/bussines/noplace.svg',
                    iconColor: Colors.purple,
                    title: '"Нет на месте"',
                    subtitle: 'Автоматические ответы в нерабочее время',
                  ),
                  const SizedBox(height: 8.0),
                  _buildBusinessItem(
                    iconAsset: 'assets/profile/bussines/link.svg',
                    iconColor: AppColors.primary,
                    title: 'Ссылки на чат',
                    subtitle:
                        'Ссылки для открытия чата с Вами с подстановкой текста',
                  ),
                  const SizedBox(height: 8.0),
                  _buildBusinessItem(
                    iconAsset: 'assets/profile/bussines/chatbot.svg',
                    iconColor: AppColors.primary,
                    title: 'Чат-боты',
                    subtitle:
                        'Подключение сторонних ботов для взаимодействия с пользователями',
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Создать',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessItem({
    required String iconAsset,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 28.0,
                height: 28.0,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
