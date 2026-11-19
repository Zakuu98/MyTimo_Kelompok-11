import 'dart:async';
import 'package:flutter/material.dart';

/// Pop up dialog konfirmasi sukses login dan pendaftaran sesuai panduan UI MyTimo
class AppSuccessDialog {
  AppSuccessDialog._();

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onContinue,
    String buttonText = 'Lanjut ke Beranda',
    Duration? autoDismissDuration = const Duration(milliseconds: 1400),
  }) async {
    bool hasContinued = false;
    Timer? timer;

    void handleContinue(BuildContext dialogCtx) {
      if (hasContinued) return;
      hasContinued = true;
      timer?.cancel();
      if (dialogCtx.mounted && Navigator.of(dialogCtx).canPop()) {
        Navigator.of(dialogCtx).pop();
      }
      onContinue();
    }

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        if (autoDismissDuration != null) {
          timer = Timer(autoDismissDuration, () {
            handleContinue(dialogCtx);
          });
        }

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (!hasContinued) {
              hasContinued = true;
              timer?.cancel();
              onContinue();
            }
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 8,
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 28),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Check Circle
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE7FDDD), Color(0xFFC5F3C1)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF178401).withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF178401),
                        size: 38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xFF7E7E7E),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Button "Lanjut ke Beranda"
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF389D33), Color(0xFF178401)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF178401).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => handleContinue(dialogCtx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
