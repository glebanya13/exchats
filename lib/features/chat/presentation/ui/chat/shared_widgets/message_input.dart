import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../../../domain/entity/message_entity.dart';
import '../../../../../../features/user/domain/entity/user_entity.dart';
import 'package:exchats/core/icons/app_icons.dart';

class MessageInput extends StatefulWidget {
  final MessageEntity? replyToMessage;
  final UserEntity? replyToUser;
  final VoidCallback? onReplyCancel;

  const MessageInput({
    Key? key,
    this.replyToMessage,
    this.replyToUser,
    this.onReplyCancel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _isKeyboardVisible = false;
  bool _showSendMessageButton = false;
  final TextEditingController _textController = TextEditingController();

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 125),
      vsync: this,
    )..forward(from: 1.0);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didUpdateWidget(MessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.replyToMessage != widget.replyToMessage) {
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        _isKeyboardVisible ? _showKeyboard() : _hideKeyboard();
      }
    } else if (state == AppLifecycleState.inactive) {
      final bool keyboardVisibility =
          WidgetsBinding.instance!.window.viewInsets.bottom > 0.0;
      setState(() => _isKeyboardVisible = keyboardVisibility);

      if (!keyboardVisibility) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }
  }

  void _showKeyboard() {
    WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) => SystemChannels.textInput.invokeMethod('TextInput.show'));
  }

  void _hideKeyboard() {
    WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        color: Colors.white,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            constraints: BoxConstraints(
              minHeight: widget.replyToMessage != null ? 60.0 : 50.0,
              maxHeight: 150.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                if (widget.replyToMessage != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48.0, 8.0, 48.0, 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCF8C6),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border(
                          left: BorderSide(
                            color: const Color(0xFF4CAF50),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ответ для ${widget.replyToUser?.firstName ?? ''}',
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  widget.replyToMessage!.text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: widget.onReplyCancel,
                            child: Icon(
                              Icons.close,
                              color: const Color(0xFF4CAF50),
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.attach_file,
              size: 24.0,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: AnimatedSize(
              curve: Curves.easeInOutCubic,
              duration: const Duration(milliseconds: 250),
              alignment: Alignment.topCenter,
              child: TextField(
              controller: _textController,
              onTap: () {
                if (!_isKeyboardVisible)
                  setState(() => _isKeyboardVisible = true);
              },
              onChanged: (text) {
                if (text.trim().isNotEmpty) {
                  if (!_showSendMessageButton) {
                    _controller.reverse().whenComplete(() {
                      setState(() => _showSendMessageButton = true);
                      _controller.forward();
                    });
                  } else
                    _controller.forward();
                } else {
                  if (_showSendMessageButton)
                    _controller.reverse().whenComplete(() {
                      setState(() => _showSendMessageButton = false);
                      _controller.forward();
                    });
                  else
                    _controller.forward();
                }
              },
              autocorrect: true,
              cursorColor: theme.colorScheme.secondary,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                hintText: 'Начините писать',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.0,
                ),
              ),
            ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.emoji_emotions_outlined,
              size: 24.0,
              color: Colors.grey[600],
            ),
          ),
          Builder(builder: (_) {
            if (_showSendMessageButton)
              return _SendMessageEntityButton(controller: _controller);

            return Container(
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  AppIcons.mic,
                  size: 24.0,
                  color: Colors.grey[600],
                ),
              ),
            );
          }),
                  ],
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

class _SendMessageEntityButton extends AnimatedWidget {
  final AnimationController controller;

  _SendMessageEntityButton({
    Key? key,
    required this.controller,
  })   : _scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutCubic,
          ),
        ),
        super(key: key, listenable: controller);

  final Animation<double> _scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform.scale(
          scale: _scale.value,
          child: _buildSendMessageEntityButton(context),
        ),
      ],
    );
  }

  Widget _buildSendMessageEntityButton(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        AppIcons.send,
        size: 21.0,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class _AttachFileAndMicButtons extends AnimatedWidget {
  final AnimationController animation;

  _AttachFileAndMicButtons({
    Key? key,
    required this.animation,
  })   : _scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ),
        ),
        _position = Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ),
        ),
        super(key: key, listenable: animation);

  final Animation<double> _scale;
  final Animation<Offset> _position;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SlideTransition(
          position: _position,
          child: ScaleTransition(
            scale: _scale,
            child: _buildAttachFileButton(context),
          ),
        ),
        ScaleTransition(
          scale: _scale,
          child: _buildMicButton(context),
        ),
      ],
    );
  }

  Widget _buildAttachFileButton(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        AppIcons.attach_file,
        size: 24.0,
        color: Theme.of(context).textTheme.displaySmall!.color,
      ),
    );
  }

  Widget _buildMicButton(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        AppIcons.mic,
        size: 24.0,
        color: Theme.of(context).textTheme.displaySmall!.color,
      ),
    );
  }
}
