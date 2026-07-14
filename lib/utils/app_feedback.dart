import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global snackbar & dialog helpers for consistent error/success feedback.
class AppFeedback {
  // ── Snackbar helpers ──────────────────────────────────────────────────────

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, const Color(0xFF2E7D32), Icons.check_circle_outline);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, const Color(0xFFC62828), Icons.error_outline);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, const Color(0xFF1565C0), Icons.info_outline);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, const Color(0xFFE65100), Icons.warning_amber_outlined);
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ── Loading dialog ────────────────────────────────────────────────────────

  static void showLoading(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2431),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFFD4A017)),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  // ── Confirm dialog ────────────────────────────────────────────────────────

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'تأكيد',
    String cancelLabel = 'إلغاء',
    Color confirmColor = Colors.redAccent,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C2431),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: GoogleFonts.cairo(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelLabel, style: GoogleFonts.cairo(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(confirmLabel, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
