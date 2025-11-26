import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exchats/domain/entity/call_entity.dart';
import 'package:exchats/ui/screens/home/call/active_call_screen.dart';

import 'new_call_screen.dart';
import 'strings.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  _CallsScreenState createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<CallEntity> _calls = _generateMockCalls();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: CallsStrings.kSearch,
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 20.0,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    context.push('/new_call');
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: const Color(0xFF1677FF),
                          size: 24.0,
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          CallsStrings.kNewCall,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1677FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                CallsStrings.kRecent,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _calls.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: index < _calls.length - 1 ? 8.0 : 0,
                    ),
                    child: _buildCallItem(_calls[index], theme),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallItem(CallEntity call, ThemeData theme) {
    final isMissed = call.type == CallType.Missed;
    final isIncoming = call.type == CallType.Incoming;
    final callCount = _getCallCount(call.userId);
    final showCount = isMissed && callCount > 1;

    return Container(
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
            context.push(
              '/active_call?userId=${call.userId}&userName=${Uri.encodeComponent(call.userName)}&isVideoCall=false',
            );
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/profile/user.svg',
                      width: 28.0,
                      height: 28.0,
                      colorFilter: ColorFilter.mode(
                        Colors.pink,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showCount ? '${call.userName} ($callCount)' : call.userName,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: isMissed ? Colors.red : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            isMissed
                                ? Icons.call_missed
                                : isIncoming
                                    ? Icons.call_received
                                    : Icons.call_made,
                            size: 16.0,
                            color: isMissed ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            call.formattedDate,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.phone,
                  color: theme.colorScheme.secondary,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getCallCount(String userId) {
    return _calls
        .where((call) => call.userId == userId && call.type == CallType.Missed)
        .length;
  }

  static List<CallEntity> _generateMockCalls() {
    final now = DateTime.now();
    return [
      CallEntity(
        id: 'call1',
        userId: 'user2',
        userName: 'Артём',
        type: CallType.Missed,
        date: now.subtract(const Duration(days: 1)),
      ),
      CallEntity(
        id: 'call2',
        userId: 'user3',
        userName: 'Елена',
        type: CallType.Incoming,
        date: DateTime(2024, 10, 14, 20, 55),
      ),
      CallEntity(
        id: 'call3',
        userId: 'user4',
        userName: 'Иван',
        type: CallType.Outgoing,
        date: DateTime(2024, 10, 12, 20, 55),
      ),
      CallEntity(
        id: 'call4',
        userId: 'user5',
        userName: 'София',
        type: CallType.Incoming,
        date: DateTime(2024, 10, 10, 20, 55),
      ),
      CallEntity(
        id: 'call5',
        userId: 'user6',
        userName: 'Дмитрий',
        type: CallType.Missed,
        date: DateTime(2024, 10, 9, 20, 55),
      ),
    ];
  }
}
