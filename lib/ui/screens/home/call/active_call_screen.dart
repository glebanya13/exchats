import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:exchats/ui/shared_widgets/rounded_avatar.dart';
import 'widgets/connection_request_dialog.dart';

class ActiveCallScreen extends StatefulWidget {
  final String? userId;
  final String? userName;
  final bool isVideoCall;
  final List<CallParticipant> participants;

  const ActiveCallScreen({
    Key? key,
    this.userId,
    this.userName,
    this.isVideoCall = false,
    this.participants = const [],
  }) : super(key: key);

  @override
  _ActiveCallScreenState createState() => _ActiveCallScreenState();
}

class CallParticipant {
  final String id;
  final String name;
  final bool isMuted;
  final bool hasVideo;
  final bool isActive;

  CallParticipant({
    required this.id,
    required this.name,
    this.isMuted = false,
    this.hasVideo = false,
    this.isActive = false,
  });
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoEnabled = true;
  bool _isScreenSharing = false;
  bool _showParticipants = false;
  String _callStatus = 'Вызов...';
  DateTime _callStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Simulate call connection
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _callStatus = 'Звонок';
        });
      }
    });
    // Simulate connection request after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        ConnectionRequestDialog.show(
          context,
          userName: 'Дмитрий Алексеев',
          onAllow: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Пользователь добавлен в звонок')),
            );
          },
          onDeny: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Запрос отклонен')),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = widget.userName ?? 'Unknown';

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Video background or avatar
          _buildVideoBackground(userName, theme),
          // Participants list (if shown)
          if (_showParticipants) _buildParticipantsList(theme),
          // Bottom controls
          _buildBottomControls(theme),
        ],
      ),
    );
  }

  Widget _buildVideoBackground(String userName, ThemeData theme) {
    if (widget.isVideoCall && _isVideoEnabled) {
      // Simulated video feed - in real app this would be actual video
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/profile/user.svg',
                    width: 40.0,
                    height: 40.0,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Static background with avatar
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/profile/user.svg',
                    width: 40.0,
                    height: 40.0,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _callStatus,
                style: const TextStyle(
                  color: Color(0xFF1677FF),
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showParticipants = !_showParticipants;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/profile/add_account.svg',
                      width: 20.0,
                      height: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Добавить пользователей',
                      style: const TextStyle(
                        color: Color(0xFF1677FF),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildParticipantsList(ThemeData theme) {
    final participants = widget.participants.isEmpty
        ? [
            CallParticipant(
              id: '1',
              name: 'Артём',
              isMuted: true,
              isActive: false,
            ),
            CallParticipant(
              id: '2',
              name: 'Елена',
              isMuted: false,
              isActive: true,
            ),
            CallParticipant(
              id: '3',
              name: 'Иван',
              isMuted: true,
              isActive: false,
            ),
            CallParticipant(
              id: '4',
              name: 'София',
              isMuted: true,
              isActive: false,
            ),
          ]
        : widget.participants;

    return Positioned(
      top: 120.0,
      left: 0,
      right: 0,
      bottom: 120.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: participants.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // "Добавить пользователя" как первый item
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // TODO: Add user functionality
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/profile/add_account.svg',
                            width: 20.0,
                            height: 20.0,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            'Добавить пользователя',
                            style: const TextStyle(
                              color: Color(0xFF1677FF),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            
            final participant = participants[index - 1];
            return Container(
              margin: EdgeInsets.only(
                bottom: index < participants.length ? 8.0 : 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: Participant tap functionality
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE91E63).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/profile/user.svg',
                              width: 22.0,
                              height: 22.0,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFE91E63),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            participant.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Icon(
                          participant.isMuted ? Icons.mic_off : Icons.mic,
                          color: Colors.grey[600],
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomControls(ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.volume_up,
                isActive: _isSpeakerOn,
                backgroundColor: Colors.white,
                iconColor: Colors.black87,
                onTap: () {
                  setState(() {
                    _isSpeakerOn = !_isSpeakerOn;
                  });
                },
              ),
              _buildControlButton(
                icon: Icons.cast,
                isActive: _isScreenSharing,
                backgroundColor: const Color(0xFF1677FF),
                iconColor: Colors.white,
                onTap: () {
                  setState(() {
                    _isScreenSharing = !_isScreenSharing;
                  });
                },
              ),
              _buildControlButton(
                icon: _isMuted ? Icons.mic_off : Icons.mic,
                isActive: _isMuted,
                backgroundColor: _isMuted ? Colors.white : const Color(0xFF1677FF),
                iconColor: _isMuted ? Colors.black87 : Colors.white,
                onTap: () {
                  setState(() {
                    _isMuted = !_isMuted;
                  });
                },
              ),
              _buildControlButton(
                icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                isActive: !_isVideoEnabled,
                backgroundColor: Colors.white,
                iconColor: Colors.black87,
                onTap: () {
                  setState(() {
                    _isVideoEnabled = !_isVideoEnabled;
                  });
                },
              ),
              _buildControlButton(
                icon: Icons.call_end,
                backgroundColor: Colors.red,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.black87,
          size: 24.0,
        ),
      ),
    );
  }
}

