import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/data/success_models.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_complete_view.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_feedback_view.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_rate_view.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_thank_you_view.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    required this.driver,
    required this.totalFare,
  });

  final DriverInfo driver;
  final int totalFare;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final TextEditingController _feedbackController =
  TextEditingController();

  SuccessStage _stage = SuccessStage.rideComplete;

  int _rating = 0;

  final Set<String> _selectedFeedback = {};

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _setStage(SuccessStage stage) {
    setState(() => _stage = stage);
  }

  void _setRating(int rating) {
    setState(() => _rating = rating);
  }

  void _toggleFeedback(String option) {
    setState(() {
      if (!_selectedFeedback.add(option)) {
        _selectedFeedback.remove(option);
      }
    });
  }

  void _submitFeedback() {
    // TODO: Send rating + quick feedback + text to API.
    _setStage(SuccessStage.feedbackSuccess);
  }

  void _backHome() {
    Navigator.of(context).popUntil(
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            key: ValueKey(_stage),
            child: _content,
          ),
        ),
      ),
    );
  }

  Widget get _content {
    switch (_stage) {
      case SuccessStage.rideComplete:
        return SuccessCompleteView(
          driver: widget.driver,
          totalFare: widget.totalFare,
          onRateDriver: () {
            _setStage(SuccessStage.rateDriver);
          },
          onInvoice: () {
            // TODO: Fare invoice.
          },
        );

      case SuccessStage.rateDriver:
        return SuccessRateView(
          driver: widget.driver,
          rating: _rating,
          options: quickFeedbackOptions,
          selectedOptions: _selectedFeedback,
          onBack: () {
            _setStage(SuccessStage.rideComplete);
          },
          onRatingChanged: _setRating,
          onOptionTap: _toggleFeedback,
          onContinue: () {
            _setStage(SuccessStage.feedback);
          },
        );

      case SuccessStage.feedback:
        return SuccessFeedbackView(
          controller: _feedbackController,
          onBack: () {
            _setStage(SuccessStage.rateDriver);
          },
          onSubmit: _submitFeedback,
          onSkip: () {
            _setStage(SuccessStage.feedbackSuccess);
          },
        );

      case SuccessStage.feedbackSuccess:
        return SuccessThankYouView(
          onHome: _backHome,
        );
    }
  }
}