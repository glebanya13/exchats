import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/ui/icons/app_icons.dart';
import '../shared_widgets/message_input.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';
import 'package:exchats/ui/shared_widgets/rounded_avatar.dart';
import '../../../../../../core/di/locator.dart';
import '../../../store/message_store.dart';

class SavedMessagesScreen extends StatefulWidget {
  const SavedMessagesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SavedMessagesScreenState();
}

class _SavedMessagesScreenState extends State<SavedMessagesScreen>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _messagesListKey = GlobalKey();
  late final MessageStore _messageStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _messageStore = locator<MessageStore>();
    _messageStore.watchMessages('saved_messages');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageStore.dispose();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    context.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8.0,
        title: Row(
          children: <Widget>[
            RoundedAvatar(
              icon: AppIcons.saved_messages,
              backgroundColor: theme.colorScheme.secondary,
              radius: 21.0,
              iconSize: 21.0,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Избранное',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.displayLarge!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          onTap: () => context.pop(),
        ),
        actions: <Widget>[
          AppBarIconButton(
            onTap: () {},
            icon: Icons.more_vert,
            iconSize: 24.0,
            iconColor: Theme.of(context).textTheme.displayLarge!.color!,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.white,
          ),
          Column(
            children: <Widget>[
              _buildMessageList(),
              MessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: AnimatedList(
        key: _messagesListKey,
        initialItemCount: _messageStore.messages.length,
        reverse: true,
        itemBuilder: (context, index, animation) {
          return SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: animation.drive(Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOutCubic))),
            child: const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
