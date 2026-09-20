import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

enum SupportStep {
  selectIssue,
  submitRequest,
  success,
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  SupportStep _step = SupportStep.selectIssue;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController();

  String? _selectedIssue;
  String _searchQuery = '';

  final List<_SupportIssue> _issues = const [
    _SupportIssue(
      title: 'Delivery Issue',
      icon: Icons.delivery_dining_outlined,
    ),
    _SupportIssue(
      title: 'Package Damaged',
      icon: Icons.inventory_2_outlined,
    ),
    _SupportIssue(
      title: 'Package Not\nReceived',
      icon: Icons.inventory_2_outlined,
    ),
    _SupportIssue(
      title: 'Driver Issue',
      icon: Icons.person_outline_rounded,
    ),
    _SupportIssue(
      title: 'Payment Issue',
      icon: Icons.credit_card_outlined,
    ),
    _SupportIssue(
      title: 'Safety Concern',
      icon: Icons.shield_outlined,
    ),
    _SupportIssue(
      title: 'Other',
      icon: Icons.more_horiz_rounded,
    ),
  ];

  List<_SupportIssue> get _filteredIssues {
    if (_searchQuery.trim().isEmpty) {
      return _issues;
    }

    return _issues.where((issue) {
      return issue.title
          .replaceAll('\n', ' ')
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectIssue(String issue) {
    setState(() {
      _selectedIssue = issue;
    });
  }

  void _continue() {
    if (_selectedIssue == null) return;

    setState(() {
      _step = SupportStep.submitRequest;
    });
  }

  void _submitRequest() {
    if (_descriptionController.text.trim().isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _step = SupportStep.success;
    });
  }

  void _back() {
    switch (_step) {
      case SupportStep.selectIssue:
        Navigator.maybePop(context);

      case SupportStep.submitRequest:
        setState(() {
          _step = SupportStep.selectIssue;
        });

      case SupportStep.success:
        setState(() {
          _step = SupportStep.submitRequest;
        });
    }
  }

  void _backToHome() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(.06, 0),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
          child: switch (_step) {
            SupportStep.selectIssue => _issueSelection(),
            SupportStep.submitRequest => _submitRequestView(),
            SupportStep.success => _successView(),
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // STEP 1
  // ===========================================================================

  Widget _issueSelection() {
    return Column(
      key: const ValueKey('issue-selection'),
      children: [
        _SupportAppBar(
          title: 'Meshwar Support',
          onBack: _back,
          showInfo: true,
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                Text(
                  'Select the issue related to your trip.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: .65),
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                _SearchField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),

                SizedBox(height: AppSpacing.lg),

                _IssueGrid(
                  issues: _filteredIssues,
                  selectedIssue: _selectedIssue,
                  onSelected: _selectIssue,
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Opacity(
            opacity: _selectedIssue == null ? .45 : 1,
            child: AppButton(
              label: 'Continue',
              onPressed: _selectedIssue == null ? null : _continue,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STEP 2
  // ===========================================================================

  Widget _submitRequestView() {
    return Column(
      key: const ValueKey('submit-request'),
      children: [
        _SupportAppBar(
          title: 'Tell us more',
          onBack: _back,
          showInfo: true,
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.md),

                _SelectedIssueCard(
                  issue: _selectedIssue ?? '',
                ),

                SizedBox(height: AppSpacing.lg),

                Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                _DescriptionField(
                  controller: _descriptionController,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                SizedBox(height: AppSpacing.lg),

                Text(
                  'Attachments (Optional)',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                _AttachmentBox(
                  onTap: () {
                    // TODO: image picker
                  },
                ),

                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: AppButton(
            label: 'Submit request',
            onPressed: _descriptionController.text.trim().isEmpty
                ? null
                : _submitRequest,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STEP 3
  // ===========================================================================

  Widget _successView() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      key: const ValueKey('success'),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          const Spacer(flex: 2),

          Container(
            width: 88.r,
            height: 88.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 52.r,
              color: colors.onPrimary,
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          Text(
            'Request Submitted',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.ms),

          Text(
            'Your support request has been\n'
                'submitted successfully. Our support\n'
                'team will review it and get back to you.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colors.secondary.withValues(alpha: .7),
              height: 1.6,
            ),
          ),

          const Spacer(flex: 4),

          AppButton(
            label: 'Back To Home',
            onPressed: _backToHome,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// APP BAR
// =============================================================================

class _SupportAppBar extends StatelessWidget {
  const _SupportAppBar({
    required this.title,
    required this.onBack,
    this.showInfo = false,
  });

  final String title;
  final VoidCallback onBack;
  final bool showInfo;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 58.r,
      child: Row(
        children: [
          SizedBox(
            width: 52.r,
            child: IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 22.r,
                color: colors.primary,
              ),
            ),
          ),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(
            width: 52.r,
            child: showInfo
                ? IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.info_outline_rounded,
                size: 21.r,
                color: colors.secondary,
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SEARCH
// =============================================================================

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search issue',
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colors.secondary.withValues(alpha: .6),
        ),
        filled: true,
        fillColor: colors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.lg,
          borderSide: BorderSide(
            color: colors.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.lg,
          borderSide: BorderSide(
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ISSUE GRID
// =============================================================================

class _IssueGrid extends StatelessWidget {
  const _IssueGrid({
    required this.issues,
    required this.selectedIssue,
    required this.onSelected,
  });

  final List<_SupportIssue> issues;
  final String? selectedIssue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - AppSpacing.ms) / 2;

        return Wrap(
          spacing: AppSpacing.ms,
          runSpacing: AppSpacing.ms,
          children: issues.map((issue) {
            return SizedBox(
              width: itemWidth,
              child: _IssueCard(
                issue: issue,
                selected: selectedIssue == issue.title,
                onTap: () => onSelected(issue.title),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({
    required this.issue,
    required this.selected,
    required this.onTap,
  });

  final _SupportIssue issue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.lg,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 112.r,
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: selected
                ? colors.primary.withValues(alpha: .08)
                : colors.surface,
            borderRadius: AppBorders.lg,
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.outlineVariant.withValues(alpha: .7),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: .03),
                blurRadius: 12.r,
                offset: Offset(0, 4.r),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary.withValues(alpha: .08),
                ),
                child: Icon(
                  issue.icon,
                  size: 22.r,
                  color: colors.primary,
                ),
              ),

              SizedBox(height: AppSpacing.ms),

              Text(
                issue.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SELECTED ISSUE
// =============================================================================

class _SelectedIssueCard extends StatelessWidget {
  const _SelectedIssueCard({
    required this.issue,
  });

  final String issue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .08),
        borderRadius: AppBorders.lg,
      ),
      child: Row(
        children: [
          Icon(
            Icons.credit_card_outlined,
            color: colors.primary,
            size: 22.r,
          ),

          SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SELECTED ISSUE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.secondary.withValues(alpha: .6),
                  ),
                ),

                SizedBox(height: AppSpacing.xs),

                Text(
                  issue.replaceAll('\n', ' '),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DESCRIPTION
// =============================================================================

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 7,
      minLines: 7,
      decoration: InputDecoration(
        hintText: 'Describe your issue...',
        alignLabelWithHint: true,
        filled: true,
        fillColor: colors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.lg,
          borderSide: BorderSide(
            color: colors.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.lg,
          borderSide: BorderSide(
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ATTACHMENT
// =============================================================================

class _AttachmentBox extends StatelessWidget {
  const _AttachmentBox({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: _DashedBorderPainter(
        color: colors.outlineVariant,
        radius: 14.r,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorders.lg,
          child: SizedBox(
            width: double.infinity,
            height: 160.r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.secondary.withValues(alpha: .08),
                  ),
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: colors.secondary,
                    size: 21.r,
                  ),
                ),

                SizedBox(height: AppSpacing.ms),

                Text(
                  'Add Photo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                Text(
                  'Photos can help us understand the issue\nfaster.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                    colors.secondary.withValues(alpha: .65),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    const dashWidth = 7.0;
    const dashSpace = 5.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(
            distance,
            distance + dashWidth,
          ),
          paint,
        );

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
      covariant _DashedBorderPainter oldDelegate,
      ) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius;
  }
}

// =============================================================================
// MODEL
// =============================================================================

class _SupportIssue {
  const _SupportIssue({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;
}