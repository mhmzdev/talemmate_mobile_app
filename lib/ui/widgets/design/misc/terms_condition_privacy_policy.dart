import 'package:taleemmate/configs/configs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Widget for Terms & Conditions and Privacy Policy acceptance
/// with radio button that returns boolean callback
class TermsAndPrivacyWidget extends StatefulWidget {
  const TermsAndPrivacyWidget({
    super.key,
    required this.onChanged,
    this.initialValue = false,
    this.radioActiveColor,
    this.radioInactiveColor,
    this.margin,
    this.crossAxisAlignment = .center,
  });

  /// Callback function that returns the acceptance status
  final ValueChanged<bool> onChanged;

  /// Initial acceptance status
  final bool initialValue;

  /// Active color for the radio button
  final Color? radioActiveColor;

  /// Inactive color for the radio button
  final Color? radioInactiveColor;

  /// Margin around the widget
  final EdgeInsets? margin;

  /// Cross axis alignment for the row
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<TermsAndPrivacyWidget> createState() => _TermsAndPrivacyWidgetState();
}

class _TermsAndPrivacyWidgetState extends State<TermsAndPrivacyWidget> {
  late bool _isAccepted;

  @override
  void initState() {
    super.initState();
    _isAccepted = widget.initialValue;
  }

  @override
  void didUpdateWidget(TermsAndPrivacyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _isAccepted = widget.initialValue;
    }
  }

  /// Handles radio button state change
  void _handleRadioChanged(bool? value) {
    if (value != null) {
      setState(() {
        _isAccepted = value;
      });
      widget.onChanged(_isAccepted);
    }
  }

  // Future<void> _launchUrl(String url) async {
  //   try {
  //     final uri = Uri.parse(url);
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } catch (e) {
  //     'Could not launch URL: $url'.appLog(level: AppLogLevel.error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final defaultTextStyle = AppText.b2;
    final defaultLinkStyle = AppText.b2.copyWith(
      color: AppTheme.c.accent,
      decoration: TextDecoration.underline,
    );

    return Container(
      margin: widget.margin ?? Space.z,
      child: Row(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          RadioGroup(
            onChanged: _handleRadioChanged,
            groupValue: _isAccepted,
            child: Radio<bool>(
              value: true,
              activeColor: widget.radioActiveColor ?? AppTheme.c.accent,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return widget.radioActiveColor ?? AppTheme.c.accent;
                  }
                  return widget.radioInactiveColor ?? AppTheme.c.primary;
                },
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          Space.x.t04,
          Expanded(
            child: GestureDetector(
              onTap: () => _handleRadioChanged(!_isAccepted),
              child: Text.rich(
                TextSpan(
                  style: defaultTextStyle,
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: defaultLinkStyle,
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: defaultLinkStyle,
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
