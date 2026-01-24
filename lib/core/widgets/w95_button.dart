import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';

class W95Button extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap; // standard dart type for a fucntion () {}

static const TextStyle _defaultTextStyle = TextStyle(
    fontFamily: 'MS W98 UI',
  );

  // W95 styled button with a text label in MS Sans Serif by default
  W95Button.text({
    super.key,
    required String label,
    required this.onTap,
    TextStyle? style,
  }) : child = Text(label, style: _defaultTextStyle.merge(style));

   const W95Button({super.key, required this.child, required this.onTap});


  @override
  State<W95Button> createState() => _W95ButtonState();
}

class _W95ButtonState extends State<W95Button> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap(); // run the fucniton passed form parent
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: _isPressed ? AppColors.darkShadow : AppColors.highlight,
              width: 2.0,
            ),
            left: BorderSide(
              color: _isPressed ? AppColors.darkShadow : AppColors.highlight,
              width: 2.0,
            ),
            right: BorderSide(
              color: _isPressed ? AppColors.highlight : AppColors.darkShadow,
              width: 2.0,
            ),
            bottom: BorderSide(
              color: _isPressed ? AppColors.highlight : AppColors.darkShadow,
              width: 2.0,
            ),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
