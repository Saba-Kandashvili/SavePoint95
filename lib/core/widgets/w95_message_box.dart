import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';
import 'package:savepoint95/core/widgets/w95_button.dart';
import 'package:savepoint95/core/widgets/w95_panel.dart';

enum MessageBoxType { info, warning, error }

class W95MessageBox extends StatelessWidget {
  final String title;
  final String message;
  final MessageBoxType type;
  final VoidCallback onOk;

  const W95MessageBox({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.onOk,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    MessageBoxType type = MessageBoxType.info,
  }) {
    return showDialog(
      context: context,
      builder: (context) => W95MessageBox(
        title: title,
        message: message,
        type: type,
        onOk: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: W95Panel(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                color: AppColors.winBlue,
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    // close X button
                    GestureDetector(
                      onTap: onOk,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: Border(
                            top: const BorderSide(
                              color: AppColors.highlight,
                              width: 1,
                            ),
                            left: const BorderSide(
                              color: AppColors.highlight,
                              width: 1,
                            ),
                            right: const BorderSide(
                              color: AppColors.darkShadow,
                              width: 1,
                            ),
                            bottom: const BorderSide(
                              color: AppColors.darkShadow,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildIcon(),
                    const SizedBox(width: 16),
                    Expanded(child: Text(message, style: const TextStyle(fontFamily: 'MS W98 UI'))),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // OK button
              W95Button(
                onTap: onOk,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("OK"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // placeholder icons untill PNGS are added
    switch (type) {
      case MessageBoxType.error:
        return const Icon(Icons.cancel, color: AppColors.winRed, size: 32);
      case MessageBoxType.warning:
        return const Icon(Icons.warning, color: AppColors.winYellow, size: 32);
      case MessageBoxType.info:
      default:
        return const Icon(Icons.info, color: AppColors.winInfoWhite, size: 32);
    }
  }
}
