import 'package:flutter/material.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';

enum AppButtonVariant { filled, tonal, outline }

/// The app's button style, in three variants.
///
/// All variants meet a 48dp minimum height so they stay comfortable touch
/// targets on phones.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.variant = AppButtonVariant.filled,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional leading icon. Pass a [FaIcon] for Font Awesome icons, which
  /// cannot be rendered with a plain [Icon].
  final Widget? leading;

  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tokens.radius),
    );
    final icon = leading ?? const SizedBox.shrink();

    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      ),
      textStyle: WidgetStatePropertyAll(context.texts.labelLarge),
      shape: WidgetStatePropertyAll(shape),
    );

    return switch (variant) {
      AppButtonVariant.filled => FilledButton.icon(
        onPressed: onPressed,
        style: style.copyWith(
          backgroundColor: WidgetStatePropertyAll(colors.primary),
          foregroundColor: WidgetStatePropertyAll(colors.onPrimary),
        ),
        icon: icon,
        label: Text(label),
      ),
      AppButtonVariant.tonal => FilledButton.icon(
        onPressed: onPressed,
        style: style.copyWith(
          backgroundColor: WidgetStatePropertyAll(
            colors.surfaceContainerHighest,
          ),
          foregroundColor: WidgetStatePropertyAll(colors.onSurface),
        ),
        icon: icon,
        label: Text(label),
      ),
      AppButtonVariant.outline => OutlinedButton.icon(
        onPressed: onPressed,
        style: style.copyWith(
          foregroundColor: WidgetStatePropertyAll(colors.onSurface),
          side: WidgetStatePropertyAll(BorderSide(color: context.outline)),
        ),
        icon: icon,
        label: Text(label),
      ),
    };
  }
}
