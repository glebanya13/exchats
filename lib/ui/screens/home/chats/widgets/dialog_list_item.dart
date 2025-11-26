import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:exchats/ui/screens/home/chat/dialog/dialog_screen.dart';
import 'package:exchats/ui/shared_widgets/rounded_avatar.dart';

class DialogListItem extends StatefulWidget {
  DialogListItem({Key? key}) : super(key: key);

  @override
  _DialogListItemState createState() => _DialogListItemState();
}

class _DialogListItemState extends State<DialogListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final chatViewModel = context.read<ChatViewModel>();
        if (chatViewModel is DialogViewModel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<ChatViewModel>.value(
                    value: chatViewModel,
                  ),
                  ChangeNotifierProvider<DialogViewModel>.value(
                    value: chatViewModel,
                  ),
                ],
                child: const DialogScreen(),
              ),
            ),
          );
        } else if (chatViewModel is GroupViewModel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<ChatViewModel>.value(
                    value: chatViewModel,
                  ),
                  ChangeNotifierProvider<GroupViewModel>.value(
                    value: chatViewModel,
                  ),
                ],
                child: const DialogScreen(),
              ),
            ),
          );
        }
      },
      child: SizedBox(
        height: 72.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildLeading(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 14.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _buildTitle(),
                        _buildSubtitle(),
                      ],
                    ),
                    const Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: -14.0,
                      child: Divider(height: 0.5),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    final theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Builder(
          builder: (context) {
            final chatViewModel = context.watch<ChatViewModel>();
            String title = '';
            if (chatViewModel is DialogViewModel) {
              title = chatViewModel.title;
            } else if (chatViewModel is GroupViewModel) {
              title = chatViewModel.title;
            }
            return AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/profile/user.svg',
                    width: 24.0,
                    height: 24.0,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Builder(
          builder: (context) {
            final chatViewModel = context.watch<ChatViewModel>();
            bool dialogUserOnline = false;
            if (chatViewModel is DialogViewModel) {
              dialogUserOnline = chatViewModel.dialogUserOnline;
            }

            return Positioned(
              right: 0.0,
              bottom: 0.0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                reverseDuration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                transitionBuilder: (child, animation) {
                  final scale =
                      Tween<double>(begin: 0.0, end: 1.0).animate(animation);
                  return ScaleTransition(
                    scale: scale,
                    child: child,
                  );
                },
                child: dialogUserOnline
                    ? Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Builder(
              builder: (context) {
                final chatViewModel = context.watch<ChatViewModel>();
                String title = '';
                if (chatViewModel is DialogViewModel) {
                  title = chatViewModel.title;
                } else if (chatViewModel is GroupViewModel) {
                  title = chatViewModel.title;
                }
                return Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
            ),
            Builder(
              builder: (context) {
                final listItemViewModel = context.watch<DialogListItemViewModel>();
                if (listItemViewModel.lastMessage.text.isEmpty) {
                  return const SizedBox(width: 48.0);
                }
                return Container(
                  width: 48.0,
                  margin: const EdgeInsets.only(
                    left: 6.0,
                    bottom: 2.0,
                  ),
                  child: Text(
                    DateFormat('kk:mm').format(listItemViewModel.lastMessage.createdAt),
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 130, 143, 152),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    final theme = Theme.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Builder(
              builder: (context) {
                final listItemViewModel = context.watch<DialogListItemViewModel>();
                if (listItemViewModel.lastMessage.text.isEmpty) {
                  return const Expanded(child: SizedBox());
                }
                return Expanded(
                  child: Text(
                    listItemViewModel.lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 130, 143, 152),
                    ),
                  ),
                );
              },
            ),
            Builder(
              builder: (context) {
                final chatViewModel = context.watch<ChatViewModel>();
                int unreadMessageCounter = 0;
                if (chatViewModel is DialogViewModel) {
                  unreadMessageCounter = chatViewModel.unreadMessageCounter;
                } else if (chatViewModel is GroupViewModel) {
                  unreadMessageCounter = chatViewModel.unreadMessageCounter;
                }
                if (unreadMessageCounter > 0) {
                  return Container(
                    width: 48.0,
                    margin: const EdgeInsets.only(left: 6.0),
                    child: UnconstrainedBox(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 24.0,
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        constraints: const BoxConstraints(
                          minWidth: 24.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          color: theme.colorScheme.secondary,
                        ),
                        child: Center(
                          child: Text(
                            '$unreadMessageCounter',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
