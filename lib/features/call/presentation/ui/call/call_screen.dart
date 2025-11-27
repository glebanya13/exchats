import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exchats/core/widgets/appbar_icon_button.dart';
import 'package:exchats/core/widgets/rounded_avatar.dart';

import 'strings.dart';
import 'active_call_screen.dart';
import 'widgets/connection_request_dialog.dart';

class CallScreen extends StatefulWidget {
  final String? userId;
  final String? userName;
  final bool isIncoming;
  final bool isVideoCall;

  const CallScreen({
    Key? key,
    this.userId,
    this.userName,
    this.isIncoming = false,
    this.isVideoCall = false,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = widget.userName ?? 'Unknown';


    if (!widget.isIncoming) {

      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          context.go(
            '/active_call?userId=${widget.userId}&userName=${Uri.encodeComponent(userName)}&isVideoCall=${widget.isVideoCall}',
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppBarIconButton(
          icon: Icons.arrow_downward,
          iconColor: Colors.white,
          onTap: () => context.pop(),
        ),
        actions: [
          AppBarIconButton(
            icon: Icons.more_vert,
            iconColor: Colors.white,
            onTap: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C27B0),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/profile/user.svg',
                          width: 80.0,
                          height: 80.0,
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
                      widget.isIncoming
                          ? CallStrings.kIncomingCall
                          : CallStrings.kCalling,
                      style: const TextStyle(
                        color: Color(0xFF1677FF),
                        fontSize: 16.0,
                      ),
                    ),
                    if (!widget.isIncoming) ...[
                      const SizedBox(height: 24.0),
                      GestureDetector(
                        onTap: () {
                          context.go(
                            '/active_call?userId=${widget.userId}&userName=${Uri.encodeComponent(userName)}&isVideoCall=${widget.isVideoCall}',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_add,
                                color: const Color(0xFF1677FF),
                                size: 20.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Добавить пользователей',
                                style: const TextStyle(
                                  color: Color(0xFF1677FF),
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.isIncoming) ...[
                    _buildControlButton(
                      icon: Icons.call,
                      backgroundColor: Colors.green,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ActiveCallScreen(
                              userId: widget.userId,
                              userName: userName,
                              isVideoCall: widget.isVideoCall,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    isActive: _isMuted,
                    onTap: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                  ),
                  _buildControlButton(
                    icon: Icons.phone,
                    backgroundColor: Colors.red,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  _buildControlButton(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                    isActive: _isSpeakerOn,
                    onTap: () {
                      setState(() {
                        _isSpeakerOn = !_isSpeakerOn;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (widget.isVideoCall)
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: _buildControlButton(
                  icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                  isActive: !_isVideoEnabled,
                  onTap: () {
                    setState(() {
                      _isVideoEnabled = !_isVideoEnabled;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? backgroundColor,
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
          color: backgroundColor == Colors.red || backgroundColor == Colors.green
              ? Colors.white
              : Colors.black87,
          size: 24.0,
        ),
      ),
    );
  }
}

