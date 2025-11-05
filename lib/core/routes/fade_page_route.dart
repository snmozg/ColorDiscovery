// lib/core/routes/fade_page_route.dart
import 'package:flutter/material.dart';

// Standart 'MaterialPageRoute' yerine bu 'Fade' (Solma) efektini kullanacağız
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({required this.child})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,

          // 'transitionsBuilder' -> Animasyonun nasıl olacağını belirler
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation, // Opaklığı (görünürlüğü) animasyona bağla
            child: child,
          ),

          // Geçişin ne kadar süreceğini belirle
          transitionDuration: const Duration(milliseconds: 300), 
        );
}