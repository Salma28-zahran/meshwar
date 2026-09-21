import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  final List<_ChatMessage> _messages = [];

  bool get _canSend =>
      _messageController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          time: DateTime.now(),
          isMe: true,
        ),
      );

      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _sendQuickMessage(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _ChatHeader(
              onBack: () => Navigator.maybePop(context),
              onCall: () {
                // TODO: Call driver
              },
            ),

            Divider(
              height: 1,
              color: colors.outlineVariant.withValues(
                alpha: .6,
              ),
            ),

            Expanded(
              child: _messages.isEmpty
                  ? const _EmptyChat()
                  : _MessagesList(
                messages: _messages,
                controller: _scrollController,
              ),
            ),

            _QuickReplies(
              onSelected: _sendQuickMessage,
            ),

            _MessageComposer(
              controller: _messageController,
              canSend: _canSend,
              onChanged: (_) {
                setState(() {});
              },
              onSend: _sendMessage,
              onAttachment: () {
                // TODO: Attachment picker
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.onBack,
    required this.onCall,
  });

  final VoidCallback onBack;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 22.r,
              color: colors.primary,
            ),
          ),

          _DriverAvatar(),

          SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'user name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                  theme.textTheme.titleMedium?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: AppSpacing.xs),

                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 15.r,
                      color: colors.primary,
                    ),

                    SizedBox(width: AppSpacing.xs),

                    Flexible(
                      child: Text(
                        '4.8 • Your Driver',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        theme.textTheme.labelSmall?.copyWith(
                          color: colors.secondary.withValues(
                            alpha: .65,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onCall,
            icon: Icon(
              Icons.phone_outlined,
              size: 22.r,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          padding: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.primary,
              width: 2.r,
            ),
          ),
          child: CircleAvatar(
            backgroundColor:
            colors.primary.withValues(alpha: .08),
            child: Icon(
              Icons.person_rounded,
              size: 24.r,
              color: colors.primary,
            ),
          ),
        ),

        Positioned(
          right: 0,
          bottom: 1.r,
          child: Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.bgColor,
                width: 2.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// EMPTY CHAT
// =============================================================================

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62.r,
              height: 62.r,
              decoration: BoxDecoration(
                color: colors.primary.withValues(
                  alpha: .08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 28.r,
                color: colors.primary,
              ),
            ),

            SizedBox(height: AppSpacing.md),

            Text(
              'Start a conversation',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppSpacing.sm),

            Text(
              'Send a message to your driver.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.secondary.withValues(
                  alpha: .6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MESSAGES
// =============================================================================

class _MessagesList extends StatelessWidget {
  const _MessagesList({
    required this.messages,
    required this.controller,
  });

  final List<_ChatMessage> messages;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _TodayLabel();
        }

        final message = messages[index - 1];

        return _MessageBubble(
          message: message,
        );
      },
    );
  }
}

class _TodayLabel extends StatelessWidget {
  const _TodayLabel();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
      child: Center(
        child: Text(
          'Today',
          style:
          Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.secondary.withValues(
              alpha: .55,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
  });

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: AppSpacing.ms,
          left: message.isMe ? 52.r : 0,
          right: message.isMe ? 0 : 52.r,
        ),
        child: Column(
          crossAxisAlignment: message.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _BubbleBody(
              message: message,
            ),

            SizedBox(height: AppSpacing.xs),

            _MessageTime(
              message: message,
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleBody extends StatelessWidget {
  const _BubbleBody({
    required this.message,
  });

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (message.isMe) {
      return Container(
        constraints: BoxConstraints(
          maxWidth:
          MediaQuery.sizeOf(context).width * .68,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.ms,
        ),
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(5),
          ),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onPrimary,
            height: 1.4,
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth:
        MediaQuery.sizeOf(context).width * .68,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.ms,
      ),
      decoration: BoxDecoration(
        color: AppColors.chatGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(5),
        ),
      ),
      child: Text(
        message.text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colors.secondary,
          height: 1.4,
        ),
      ),
    );
  }
}

class _MessageTime extends StatelessWidget {
  const _MessageTime({
    required this.message,
  });

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final hour = message.time.hour == 0
        ? 12
        : message.time.hour > 12
        ? message.time.hour - 12
        : message.time.hour;

    final minute =
    message.time.minute.toString().padLeft(2, '0');

    final period =
    message.time.hour >= 12 ? 'PM' : 'AM';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$hour:$minute $period',
          style:
          Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 9.sp,
            color: colors.secondary.withValues(
              alpha: .65,
            ),
          ),
        ),

        if (message.isMe) ...[
          SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.done_all_rounded,
            size: 13.r,
            color: colors.primary,
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// QUICK REPLIES
// =============================================================================

class _QuickReplies extends StatelessWidget {
  const _QuickReplies({
    required this.onSelected,
  });

  final ValueChanged<String> onSelected;

  static const replies = [
    'I’m waiting outside',
    'Where are you?',
    'I’m at the pickup',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant.withValues(
              alpha: .35,
            ),
          ),
        ),
      ),
      child: SizedBox(
        height: 34.r,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          itemCount: replies.length,
          separatorBuilder: (_, __) {
            return SizedBox(width: AppSpacing.sm);
          },
          itemBuilder: (context, index) {
            final text = replies[index];

            return ActionChip(
              onPressed: () => onSelected(text),
              elevation: 0,
              side: BorderSide.none,
              backgroundColor:
              colors.secondary.withValues(
                alpha: .06,
              ),
              shape: const StadiumBorder(),
              label: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                  color: colors.secondary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// MESSAGE COMPOSER
// =============================================================================

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.canSend,
    required this.onChanged,
    required this.onSend,
    required this.onAttachment,
  });

  final TextEditingController controller;
  final bool canSend;

  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final VoidCallback onAttachment;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.ms,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: .05,
            ),
            blurRadius: 12.r,
            offset: Offset(0, -3.r),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onAttachment,
            icon: Icon(
              Icons.attach_file_rounded,
              size: 22.r,
              color: colors.secondary,
            ),
          ),

          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 48.r,
                maxHeight: 110.r,
              ),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(
                  alpha: .05,
                ),
                borderRadius: AppBorders.lg,
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                minLines: 1,
                maxLines: 4,
                textInputAction:
                TextInputAction.newline,
                style:
                Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                    colors.secondary.withValues(
                      alpha: .45,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.ms,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: AppSpacing.sm),

          _SendButton(
            enabled: canSend,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SEND BUTTON
// =============================================================================

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : .45,
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: enabled ? onPressed : null,
            customBorder: const CircleBorder(),
            child: Icon(
              Icons.send_rounded,
              size: 21.r,
              color: colors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MODEL
// =============================================================================

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.time,
    required this.isMe,
  });

  final String text;
  final DateTime time;
  final bool isMe;
}