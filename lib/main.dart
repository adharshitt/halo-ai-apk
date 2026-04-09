import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

void main() {
  runApp(const HaloApp());
}

class HaloApp extends StatelessWidget {
  const HaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: const Color(0xFF3A3A3C),
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  bool _isExpanded = false;
  bool _isGenerating = false;
  bool _showToast = false;

  void _handleSend() async {
    if (_promptController.text.isEmpty) return;
    setState(() {
      _isGenerating = true;
      _isExpanded = false;
    });

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    setState(() {
      _isGenerating = false;
      _showToast = true;
      _promptController.clear();
    });

    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    setState(() => _showToast = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Image.asset(
                            'assets/images/icons8-wrong-50.png',
                            width: 16,
                            height: 16,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Halo',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Balance for X button
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: 500.ms,
                      child: _isGenerating
                          ? const HaloLogoView()
                          : Container(
                              margin: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                image: const DecorationImage(
                                  image: NetworkImage('https://picsum.photos/800/1200'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                // Input Area Space (Adjusted for Keyboard)
                SizedBox(height: _isExpanded ? 180 : 100),
              ],
            ),
          ),

          // Success Toast
          if (_showToast)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5EA),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Creating your edit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          Text("We'll let you know when it's done", style: TextStyle(color: Colors.black54, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: -1, end: 0, curve: Curves.easeOutCubic).fadeIn(),
            ),

          // Bottom Bar Overlay
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: 300.ms,
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_isExpanded ? 32 : 40),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promptController,
                              onTap: () => setState(() => _isExpanded = true),
                              maxLines: _isExpanded ? 3 : 1,
                              decoration: InputDecoration(
                                hintText: 'Describe your edit...',
                                hintStyle: const TextStyle(color: Colors.black26),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: _isExpanded ? 8 : 0),
                              ),
                            ),
                          ),
                          if (!_isExpanded)
                            GestureDetector(
                              onTap: _isGenerating ? null : _handleSend,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF636366),
                                  shape: BoxShape.circle,
                                ),
                                child: _isGenerating
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset('assets/images/icons8-loading-50.gif', color: Colors.white),
                                      )
                                    : const Icon(Icons.arrow_upward, color: Colors.white, size: 24),
                              ),
                            ),
                        ],
                      ),
                      if (_isExpanded) ...[
                        const Divider(height: 24, color: Color(0xFFF2F2F7)),
                        Row(
                          children: [
                            const ActionChip(imagePath: 'assets/images/enhanced_Screenshot_20260409_174454_Gallery.png'),
                            const SizedBox(width: 8),
                            const ActionChip(imagePath: 'assets/images/enhanced_Screenshot_20260409_175148_Gallery.png'),
                            const SizedBox(width: 8),
                            const ActionChip(imagePath: 'assets/images/enhanced_Screenshot_20260409_180110_Video Player.png', label: 'Fast'),
                            const SizedBox(width: 8),
                            const ActionChip(imagePath: 'assets/images/enhanced_Screenshot_20260409_180320_Gallery.png', label: 'Auto'),
                            const Spacer(),
                            GestureDetector(
                              onTap: _isGenerating ? null : _handleSend,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: _isGenerating
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset('assets/images/icons8-loading-50.gif', color: Colors.white),
                                      )
                                    : const Icon(Icons.arrow_upward, color: Colors.white, size: 24),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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

class ActionChip extends StatelessWidget {
  final String imagePath;
  final String? label;
  const ActionChip({super.key, required this.imagePath, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: label != null ? 12 : 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 18,
            height: 18,
            fit: BoxFit.contain,
          ),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(label!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF3A3A3C))),
          ],
        ],
      ),
    );
  }
}

class HaloLogoView extends StatelessWidget {
  const HaloLogoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(painter: HaloLogoPainter()),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms, color: Colors.white),
        const SizedBox(height: 40),
        const Text(
          'Halo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }
}

class HaloLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final wingPath = Path();
    // Left Wing
    wingPath.moveTo(size.width * 0.4, size.height * 0.4);
    wingPath.cubicTo(
      size.width * 0.2, size.height * 0.3,
      size.width * 0.1, size.height * 0.5,
      size.width * 0.2, size.height * 0.7,
    );
    wingPath.cubicTo(
      size.width * 0.3, size.height * 0.8,
      size.width * 0.4, size.height * 0.6,
      size.width * 0.4, size.height * 0.4,
    );

    // Right Wing
    wingPath.moveTo(size.width * 0.6, size.height * 0.4);
    wingPath.cubicTo(
      size.width * 0.8, size.height * 0.3,
      size.width * 0.9, size.height * 0.5,
      size.width * 0.8, size.height * 0.7,
    );
    wingPath.cubicTo(
      size.width * 0.7, size.height * 0.8,
      size.width * 0.6, size.height * 0.6,
      size.width * 0.6, size.height * 0.4,
    );

    canvas.drawPath(wingPath, paint);

    // Halo Ring
    final haloPaint = Paint()
      ..color = const Color(0xFFF2C94C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.35),
        width: 60,
        height: 20,
      ),
      haloPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
