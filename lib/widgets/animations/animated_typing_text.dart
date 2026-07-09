import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedTypingText extends StatefulWidget {
  const AnimatedTypingText({
    super.key,
    required this.texts,
    required this.style,
    this.typingSpeed = const Duration(milliseconds: 80),
    this.deletingSpeed = const Duration(milliseconds: 40),
    this.delayBetweenTexts = const Duration(milliseconds: 1800),
  });

  final List<String> texts;
  final TextStyle style;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration delayBetweenTexts;

  @override
  State<AnimatedTypingText> createState() => _AnimatedTypingTextState();
}

class _AnimatedTypingTextState extends State<AnimatedTypingText> {
  int _currentTextIndex = 0;
  String _currentDisplayedText = '';
  bool _isDeleting = false;
  Timer? _typingTimer;
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    if (widget.texts.isNotEmpty) {
      _startTyping();
    }
    _startCursorBlink();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  void _startTyping() {
    if (widget.texts.isEmpty) return;
    
    final fullText = widget.texts[_currentTextIndex];
    
    _typingTimer = Timer.periodic(
      _isDeleting ? widget.deletingSpeed : widget.typingSpeed,
      (timer) {
        if (!mounted) return;
        
        setState(() {
          if (_isDeleting) {
            _showCursor = true;
            if (_currentDisplayedText.isNotEmpty) {
              _currentDisplayedText = _currentDisplayedText.substring(0, _currentDisplayedText.length - 1);
            } else {
              _typingTimer?.cancel();
              _isDeleting = false;
              _currentTextIndex = (_currentTextIndex + 1) % widget.texts.length;
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) _startTyping();
              });
            }
          } else {
            _showCursor = true;
            if (_currentDisplayedText.length < fullText.length) {
              _currentDisplayedText = fullText.substring(0, _currentDisplayedText.length + 1);
            } else {
              _typingTimer?.cancel();
              _isDeleting = true;
              Future.delayed(widget.delayBetweenTexts, () {
                if (mounted) _startTyping();
              });
            }
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _currentDisplayedText,
          style: widget.style,
        ),
        AnimatedOpacity(
          opacity: _showCursor ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: Text(
            '|',
            style: widget.style.copyWith(
              color: widget.style.color ?? Theme.of(context).primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
