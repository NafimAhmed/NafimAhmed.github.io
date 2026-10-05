import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'portfolio_data.dart';
import 'portfolio_theme.dart';

const double _maxContentWidth = 1180;
const double _navHeight = 74;
const String _cvUrl = 'assets/assets/Nafim_Ahmed_CV.pdf';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  static const _themeKey = 'portfolio-theme';
  bool _isLight = false;

  @override
  void initState() {
    super.initState();
    _restoreTheme();
  }

  Future<void> _restoreTheme() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _isLight = preferences.getString(_themeKey) == 'light');
  }

  Future<void> _setTheme(bool light) async {
    setState(() => _isLight = light);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeKey, light ? 'light' : 'dark');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nafim Ahmed | Software Engineer',
      debugShowCheckedModeBanner: false,
      theme: buildPortfolioTheme(isLight: _isLight),
      home: PortfolioPage(
        isLight: _isLight,
        onThemeChanged: _setTheme,
      ),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    required this.isLight,
    required this.onThemeChanged,
    super.key,
  });

  final bool isLight;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'education': GlobalKey(),
    'certifications': GlobalKey(),
    'skills': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'packages': GlobalKey(),
    'contact': GlobalKey(),
  };

  String _activeSection = 'home';
  bool _menuOpen = false;
  bool _showBackToTop = false;
  bool _navScrolled = false;

  PortfolioPalette get _palette => PortfolioPalette(isLight: widget.isLight);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    final showBackToTop = offset > 650;
    final navScrolled = offset > 10;

    String current = 'home';
    for (final entry in _sectionKeys.entries) {
      final sectionContext = entry.value.currentContext;
      final renderObject = sectionContext?.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        final y = renderObject.localToGlobal(Offset.zero).dy;
        if (y <= 145) current = entry.key;
      }
    }

    if (showBackToTop != _showBackToTop ||
        navScrolled != _navScrolled ||
        current != _activeSection) {
      setState(() {
        _showBackToTop = showBackToTop;
        _navScrolled = navScrolled;
        _activeSection = current;
      });
    }
  }

  Future<void> _scrollTo(String section) async {
    setState(() => _menuOpen = false);
    final sectionContext = _sectionKeys[section]?.currentContext;
    if (sectionContext == null) return;

    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  Future<void> _openUrl(String value, {bool sameTab = false}) async {
    final Uri uri;
    if (value.startsWith('http://') ||
        value.startsWith('https://') ||
        value.startsWith('mailto:')) {
      uri = Uri.parse(value);
    } else {
      uri = Uri.base.resolve(value);
    }

    await launchUrl(
      uri,
      webOnlyWindowName: sameTab ? '_self' : '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewport) {
        final width = viewport.maxWidth;
        final desktop = width > 980;

        return Scaffold(
          backgroundColor: _palette.background,
          body: Stack(
            children: [
              Positioned.fill(child: _Background(palette: _palette)),
              Positioned.fill(
                child: SelectionArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: desktop,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          _HeroSection(
                            key: _sectionKeys['home'],
                            palette: _palette,
                            viewportWidth: width,
                            onScrollToProjects: () => _scrollTo('projects'),
                            onOpenUrl: _openUrl,
                          ),
                          _StatsSection(
                            palette: _palette,
                            viewportWidth: width,
                          ),
                          _AboutSection(
                            key: _sectionKeys['about'],
                            palette: _palette,
                            viewportWidth: width,
                            onOpenUrl: _openUrl,
                          ),
                          _EducationSection(
                            key: _sectionKeys['education'],
                            palette: _palette,
                            viewportWidth: width,
                          ),
                          _TrainingSection(
                            key: _sectionKeys['certifications'],
                            palette: _palette,
                            viewportWidth: width,
                            onOpenUrl: _openUrl,
                          ),
                          _SkillsSection(
                            key: _sectionKeys['skills'],
                            palette: _palette,
                            viewportWidth: width,
                          ),
                          _ExperienceSection(
                            key: _sectionKeys['experience'],
                            palette: _palette,
                            viewportWidth: width,
                          ),
                          _ProjectsSection(
                            key: _sectionKeys['projects'],
                            palette: _palette,
                            viewportWidth: width,
                            onOpenUrl: _openUrl,
                          ),
                          _PackagesSection(
                            key: _sectionKeys['packages'],
                            palette: _palette,
                            viewportWidth: width,
                            onOpenUrl: _openUrl,
                          ),
                          _PublicationsSection(
                            palette: _palette,
                            viewportWidth: width,
                            onOpenUrl: _openUrl,
                          ),
                          _ContactSection(
                            key: _sectionKeys['contact'],
                            palette: _palette,
                            viewportWidth: width,
                            onOpenUrl: _openUrl,
                          ),
                          _Footer(
                            palette: _palette,
                            onScrollHome: () => _scrollTo('home'),
                            onOpenUrl: _openUrl,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _NavigationBar(
                palette: _palette,
                activeSection: _activeSection,
                scrolled: _navScrolled,
                desktop: desktop,
                menuOpen: _menuOpen,
                onMenuToggle: () => setState(() => _menuOpen = !_menuOpen),
                onThemeToggle: () => widget.onThemeChanged(!widget.isLight),
                onNavigate: _scrollTo,
              ),
              if (!desktop && _menuOpen)
                Positioned(
                  top: _navHeight + 10,
                  left: 20,
                  right: 20,
                  child: _MobileMenu(
                    palette: _palette,
                    activeSection: _activeSection,
                    onNavigate: _scrollTo,
                  ),
                ),
              Positioned(
                right: 22,
                bottom: 22,
                child: IgnorePointer(
                  ignoring: !_showBackToTop,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showBackToTop ? 1 : 0,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 250),
                      offset:
                          _showBackToTop ? Offset.zero : const Offset(0, .3),
                      child: _BackToTopButton(
                        onTap: () => _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeInOutCubic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.palette});

  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: palette.background,
      child: Stack(
        children: [
          Positioned(
            left: -170,
            top: -120,
            child: _GlowCircle(
              size: 560,
              color: PortfolioColors.primary.withOpacity(.12),
            ),
          ),
          Positioned(
            right: -160,
            top: -170,
            child: _GlowCircle(
              size: 600,
              color: PortfolioColors.secondary.withOpacity(.13),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withOpacity(0)],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.palette,
    required this.activeSection,
    required this.scrolled,
    required this.desktop,
    required this.menuOpen,
    required this.onMenuToggle,
    required this.onThemeToggle,
    required this.onNavigate,
  });

  final PortfolioPalette palette;
  final String activeSection;
  final bool scrolled;
  final bool desktop;
  final bool menuOpen;
  final VoidCallback onMenuToggle;
  final VoidCallback onThemeToggle;
  final ValueChanged<String> onNavigate;

  static const _navItems = <MapEntry<String, String>>[
    MapEntry('home', 'Home'),
    MapEntry('about', 'About'),
    MapEntry('education', 'Education'),
    MapEntry('certifications', 'Training'),
    MapEntry('skills', 'Skills'),
    MapEntry('experience', 'Experience'),
    MapEntry('projects', 'Projects'),
    MapEntry('packages', 'Packages'),
    MapEntry('contact', 'Contact'),
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: _navHeight,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: palette.isLight
                  ? const Color.fromRGBO(244, 247, 251, .78)
                  : const Color.fromRGBO(7, 17, 31, .66),
              border: Border(
                bottom: BorderSide(
                  color: scrolled ? palette.border : Colors.transparent,
                ),
              ),
              boxShadow: scrolled
                  ? [
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .13),
                        blurRadius: 35,
                        offset: Offset(0, 10),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => onNavigate('home'),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    PortfolioColors.primary,
                                    PortfolioColors.secondary,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: PortfolioColors.primary
                                        .withOpacity(.25),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'NA',
                                style: TextStyle(
                                  color: Color(0xFF04120D),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            if (desktop) ...[
                              const SizedBox(width: 12),
                              Text(
                                'Nafim Ahmed',
                                style: TextStyle(
                                  color: palette.text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -.3,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (desktop)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: _navItems.map((item) {
                            return _NavLink(
                              label: item.value,
                              active: activeSection == item.key,
                              palette: palette,
                              onTap: () => onNavigate(item.key),
                            );
                          }).toList(),
                        ),
                      if (desktop) const SizedBox(width: 14),
                      _SquareIconButton(
                        palette: palette,
                        tooltip: 'Toggle theme',
                        onTap: onThemeToggle,
                        child: Text(
                          palette.isLight ? '☀' : '☾',
                          style: TextStyle(
                            color: palette.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (!desktop) ...[
                        const SizedBox(width: 10),
                        _SquareIconButton(
                          palette: palette,
                          tooltip: menuOpen ? 'Close menu' : 'Open menu',
                          onTap: onMenuToggle,
                          child: Text(
                            menuOpen ? '✕' : '☰',
                            style: TextStyle(
                              color: palette.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({
    required this.palette,
    required this.activeSection,
    required this.onNavigate,
  });

  final PortfolioPalette palette;
  final String activeSection;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    const items = <MapEntry<String, String>>[
      MapEntry('home', 'Home'),
      MapEntry('about', 'About'),
      MapEntry('education', 'Education'),
      MapEntry('certifications', 'Training'),
      MapEntry('skills', 'Skills'),
      MapEntry('experience', 'Experience'),
      MapEntry('projects', 'Projects'),
      MapEntry('packages', 'Packages'),
      MapEntry('contact', 'Contact'),
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.surfaceSolid,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(18),
          boxShadow: palette.shadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            final active = activeSection == item.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onNavigate(item.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? palette.surfaceLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.value,
                    style: TextStyle(
                      color: active ? palette.text : palette.muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.active,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool active;
  final PortfolioPalette palette;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.active || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color:
                      highlighted ? widget.palette.text : widget.palette.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.active ? 26 : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: PortfolioColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatefulWidget {
  const _SquareIconButton({
    required this.palette,
    required this.tooltip,
    required this.onTap,
    required this.child,
  });

  final PortfolioPalette palette;
  final String tooltip;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_SquareIconButton> createState() => _SquareIconButtonState();
}

class _SquareIconButtonState extends State<_SquareIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 43,
            height: 43,
            alignment: Alignment.center,
            transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
            decoration: BoxDecoration(
              color: widget.palette.surface,
              border: Border.all(
                color: _hovered
                    ? PortfolioColors.primary.withOpacity(.55)
                    : widget.palette.border,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.palette,
    required this.viewportWidth,
    required this.onScrollToProjects,
    required this.onOpenUrl,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;
  final VoidCallback onScrollToProjects;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final desktop = viewportWidth > 980;
    final mobile = viewportWidth <= 720;
    final heroNameSize = desktop
        ? (viewportWidth * .082).clamp(54.0, 113.0).toDouble()
        : (viewportWidth * .17).clamp(51.0, 80.0).toDouble();

    final copy = Column(
      crossAxisAlignment:
          desktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        _AvailabilityPill(palette: palette),
        const SizedBox(height: 22),
        const Text(
          'HELLO, I’M',
          style: TextStyle(
            color: PortfolioColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.1,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Nafim',
          textAlign: desktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            color: palette.text,
            fontSize: heroNameSize,
            height: .93,
            fontWeight: FontWeight.w900,
            letterSpacing: -5,
          ),
        ),
        _GradientText(
          text: 'Ahmed.',
          fontSize: heroNameSize,
          textAlign: desktop ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 18),
        _TypingLine(palette: palette),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'Software Engineer with 5+ years of experience building mobile applications, enterprise ERP solutions, AI-powered products, APIs and connected IoT systems. Currently contributing to Oracle EBS–integrated mobile solutions at PRAN-RFL Group.',
            textAlign: desktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: palette.muted,
              fontSize: 16.5,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 31),
        _ResponsiveActions(
          centered: !desktop,
          fullWidth: viewportWidth <= 470,
          children: [
            _ActionButton(
              label: 'Explore my work ↗',
              primary: true,
              palette: palette,
              onTap: onScrollToProjects,
            ),
            _ActionButton(
              label: 'Download CV ↓',
              palette: palette,
              onTap: () => onOpenUrl(_cvUrl),
            ),
            _ActionButton(
              label: 'Let’s work together',
              palette: palette,
              onTap: () => onOpenUrl('mailto:recentnafimahmed@gmail.com'),
            ),
          ],
        ),
        const SizedBox(height: 29),
        Wrap(
          alignment: desktop ? WrapAlignment.start : WrapAlignment.center,
          spacing: 21,
          runSpacing: 12,
          children: [
            _TextLink(
              label: 'GitHub ↗',
              palette: palette,
              onTap: () => onOpenUrl('https://github.com/NafimAhmed'),
            ),
            _TextLink(
              label: 'LinkedIn ↗',
              palette: palette,
              onTap: () => onOpenUrl(
                'https://www.linkedin.com/in/nafim-ahmed-recent/',
              ),
            ),
            _TextLink(
              label: 'Pub.dev ↗',
              palette: palette,
              onTap: () => onOpenUrl('https://pub.dev/publishers/'),
            ),
          ],
        ),
      ],
    );

    final profile = _ProfileCard(palette: palette);

    return _ContentContainer(
      padding: EdgeInsets.only(
        top: _navHeight + (desktop ? 50 : 75),
        bottom: 70,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: desktop ? 720 : 0),
        child: desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 13, child: copy),
                  SizedBox(width: (viewportWidth * .08).clamp(40.0, 100.0).toDouble()),
                  Expanded(flex: 7, child: profile),
                ],
              )
            : Column(
                children: [
                  copy,
                  SizedBox(height: mobile ? 58 : 70),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 390),
                    child: profile,
                  ),
                ],
              ),
      ),
    );
  }
}

class _AvailabilityPill extends StatefulWidget {
  const _AvailabilityPill({required this.palette});

  final PortfolioPalette palette;

  @override
  State<_AvailabilityPill> createState() => _AvailabilityPillState();
}

class _AvailabilityPillState extends State<_AvailabilityPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: PortfolioColors.primary.withOpacity(.07),
        border: Border.all(
          color: PortfolioColors.primary.withOpacity(.28),
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PortfolioColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: PortfolioColors.primary.withOpacity(
                        .55 * (1 - _controller.value),
                      ),
                      spreadRadius: 9 * _controller.value,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 9),
          const Text(
            'Open to impactful opportunities',
            style: TextStyle(
              color: PortfolioColors.primary,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText({
    required this.text,
    required this.fontSize,
    required this.textAlign,
  });

  final String text;
  final double fontSize;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          PortfolioColors.primary,
          Color(0xFF8FFFD5),
          PortfolioColors.secondary,
        ],
        stops: [0, .45, 1],
      ).createShader(bounds),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            height: .93,
            fontWeight: FontWeight.w900,
            letterSpacing: -5,
          ),
        ),
      ),
    );
  }
}

class _TypingLine extends StatefulWidget {
  const _TypingLine({required this.palette});

  final PortfolioPalette palette;

  @override
  State<_TypingLine> createState() => _TypingLineState();
}

class _TypingLineState extends State<_TypingLine> {
  Timer? _timer;
  int _phraseIndex = 0;
  int _characterIndex = typingPhrases.first.length;
  bool _deleting = true;
  bool _cursorVisible = true;

  @override
  void initState() {
    super.initState();
    _schedule(const Duration(milliseconds: 1500));
  }

  void _schedule(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;

    final phrase = typingPhrases[_phraseIndex];
    var nextDelay = const Duration(milliseconds: 58);

    setState(() {
      _cursorVisible = !_cursorVisible;

      if (_deleting) {
        _characterIndex = (_characterIndex - 1).clamp(0, phrase.length).toInt();
        if (_characterIndex == 0) {
          _deleting = false;
          _phraseIndex = (_phraseIndex + 1) % typingPhrases.length;
          nextDelay = const Duration(milliseconds: 420);
        } else {
          nextDelay = const Duration(milliseconds: 38);
        }
      } else {
        final newPhrase = typingPhrases[_phraseIndex];
        _characterIndex =
            (_characterIndex + 1).clamp(0, newPhrase.length).toInt();
        if (_characterIndex == newPhrase.length) {
          _deleting = true;
          nextDelay = const Duration(milliseconds: 1800);
        } else {
          nextDelay = const Duration(milliseconds: 58);
        }
      }
    });

    _schedule(nextDelay);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phrase = typingPhrases[_phraseIndex];
    final visibleLength = _characterIndex.clamp(0, phrase.length).toInt();

    return DefaultTextStyle(
      style: TextStyle(
        color: widget.palette.muted,
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'I build '),
            TextSpan(
              text: phrase.substring(0, visibleLength),
              style: TextStyle(color: widget.palette.text),
            ),
            TextSpan(
              text: _cursorVisible ? '|' : ' ',
              style: const TextStyle(color: PortfolioColors.primary),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.palette});

  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Transform.rotate(
            angle: .0872665,
            child: Container(
              margin: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(
                  color: PortfolioColors.primary.withOpacity(.24),
                ),
                borderRadius: BorderRadius.circular(34),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: palette.surface,
            border: Border.all(color: palette.border),
            borderRadius: BorderRadius.circular(30),
            boxShadow: palette.shadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1 / 1.04,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: ColoredBox(
                    color: palette.surfaceLight,
                    child: Image.network(
                      'https://avatars.githubusercontent.com/u/49490709?v=4',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          'NA',
                          style: TextStyle(
                            color: palette.text,
                            fontSize: 72,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Software Engineer',
                      style: TextStyle(
                        color: palette.text,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Flutter • ERP • AI • IoT',
                      style: TextStyle(color: palette.muted),
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final oneColumn = constraints.maxWidth < 330;
                        final width = oneColumn
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 10) / 2;
                        const items = [
                          ('Based in', 'Dhaka, Bangladesh'),
                          ('Experience', '5+ Years'),
                          ('Focus', 'Product Engineering'),
                          ('Work mode', 'Remote / On-site'),
                        ];
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: items
                              .map(
                                (item) => SizedBox(
                                  width: width,
                                  child: _MetaTile(
                                    label: item.$1,
                                    value: item.$2,
                                    palette: palette,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.025),
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: palette.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: .9,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: palette.text,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({
    required this.palette,
    required this.viewportWidth,
  });

  final PortfolioPalette palette;
  final double viewportWidth;

  @override
  Widget build(BuildContext context) {
    final columns = viewportWidth <= 470
        ? 1
        : viewportWidth <= 720
            ? 2
            : 4;

    return Transform.translate(
      offset: const Offset(0, -20),
      child: _ContentContainer(
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: palette.surface,
            border: Border.all(color: palette.border),
            borderRadius: BorderRadius.circular(22),
            boxShadow: palette.shadow,
          ),
          child: _FixedGrid(
            columns: columns,
            spacing: 14,
            children: const [
              ('5+', 'Years of experience'),
              ('80+', 'GitHub repositories'),
              ('8', 'Published packages'),
              ('2', 'Research publications'),
            ]
                .map(
                  (item) => _StatCard(
                    value: item.$1,
                    label: item.$2,
                    palette: palette,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.palette,
  });

  final String value;
  final String label;
  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.025),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: PortfolioColors.primary,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: palette.muted,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({
    required this.palette,
    required this.viewportWidth,
    required this.onOpenUrl,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final desktop = viewportWidth > 980;

    final aboutCard = _Panel(
      palette: palette,
      padding: EdgeInsets.all(viewportWidth <= 470 ? 25 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I am a Software Engineer and Flutter specialist from Dhaka, Bangladesh, experienced in designing production-grade mobile applications and integrating them with complex backend and Oracle ERP systems.',
            style: TextStyle(
              color: palette.text,
              fontSize: 17,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'I have worked across REST APIs, real-time communication, offline-first applications, QR and barcode workflows, NFC/RFID devices, printing, location services, Firebase, computer vision and intelligent chatbot systems.',
            style: TextStyle(color: palette.muted, height: 1.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Beyond application development, I build reusable Flutter packages and explore AI, IoT and embedded systems to turn experimental concepts into useful, maintainable products.',
            style: TextStyle(color: palette.muted, height: 1.7),
          ),
          const SizedBox(height: 30),
          _ResponsiveActions(
            fullWidth: viewportWidth <= 470,
            children: [
              _ActionButton(
                label: 'Contact me',
                primary: true,
                palette: palette,
                onTap: () => onOpenUrl('mailto:recentnafimahmed@gmail.com'),
              ),
              _ActionButton(
                label: 'Download CV ↓',
                palette: palette,
                onTap: () => onOpenUrl(_cvUrl),
              ),
              _ActionButton(
                label: 'View GitHub',
                palette: palette,
                onTap: () => onOpenUrl('https://github.com/NafimAhmed'),
              ),
            ],
          ),
        ],
      ),
    );

    final focus = _Panel(
      palette: palette,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: const [
          (
            '01',
            'Enterprise Mobile Engineering',
            'ERP mobile applications, Oracle EBS integrations, secure APIs, role-based workflows and offline-ready business processes.',
          ),
          (
            '02',
            'AI-powered Experiences',
            'Computer vision, intelligent chatbots, prediction systems, model integration and AI-enabled mobile products.',
          ),
          (
            '03',
            'IoT and Hardware Integration',
            'RFID, NFC, QR scanners, Arduino/ESP32 communication, real-time controllers and connected automation.',
          ),
          (
            '04',
            'Developer Tools and Packages',
            'Reusable Flutter packages, clean APIs, documentation and components designed for other developers.',
          ),
        ]
            .map(
              (item) => _FocusItem(
                number: item.$1,
                title: item.$2,
                description: item.$3,
                palette: palette,
              ),
            )
            .toList(),
      ),
    );

    return _Section(
      heading: _SectionHeading(
        tag: 'About me',
        title:
            'Engineering practical products that connect people, data and operations.',
        description:
            'My work sits at the intersection of mobile engineering, enterprise systems, artificial intelligence and real-world automation.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 95, child: aboutCard),
                const SizedBox(width: 28),
                Expanded(flex: 105, child: focus),
              ],
            )
          : Column(
              children: [
                aboutCard,
                const SizedBox(height: 28),
                focus,
              ],
            ),
    );
  }
}

class _FocusItem extends StatelessWidget {
  const _FocusItem({
    required this.number,
    required this.title,
    required this.description,
    required this.palette,
  });

  final String number;
  final String title;
  final String description;
  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _HoverLift(
        lift: 0,
        horizontalShift: 5,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.025),
            border: Border.all(color: palette.border),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PortfolioColors.primary.withOpacity(.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: PortfolioColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: palette.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        color: palette.muted,
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationSection extends StatelessWidget {
  const _EducationSection({
    required this.palette,
    required this.viewportWidth,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;

  @override
  Widget build(BuildContext context) {
    final desktop = viewportWidth > 980;

    final highlight = Container(
      constraints: const BoxConstraints(minHeight: 290),
      padding: EdgeInsets.all(viewportWidth <= 470 ? 28 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PortfolioColors.primary.withOpacity(.14),
            palette.surface,
          ],
          stops: const [0, .62],
        ),
        border: Border.all(
          color: PortfolioColors.primary.withOpacity(.28),
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: palette.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  PortfolioColors.primary,
                  Color(0xFF8FFFD5),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: PortfolioColors.primary.withOpacity(.2),
                  blurRadius: 30,
                  offset: const Offset(0, 13),
                ),
              ],
            ),
            child: const Text('🎓', style: TextStyle(fontSize: 25)),
          ),
          const SizedBox(height: 30),
          Text(
            'Academic Journey',
            style: TextStyle(
              color: palette.text,
              fontSize: 34,
              height: 1.12,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SSC 2014 • HSC 2016 • BSc in CSE 2022',
            style: TextStyle(color: palette.muted),
          ),
        ],
      ),
    );

    final list = Column(
      children: [
        _EducationCard(
          level: "Bachelor's Degree",
          year: '2022',
          title: 'BSc in Computer Science and Engineering',
          institute: 'Daffodil International University',
          note:
              'Completed the undergraduate degree with a foundation in software engineering, algorithms, databases, networking, artificial intelligence and computer systems.',
          palette: palette,
        ),
        const SizedBox(height: 16),
        _EducationCard(
          level: 'Higher Secondary Certificate',
          year: '2016',
          title: 'Higher Secondary Certificate (HSC)',
          institute: 'Completed in 2016',
          palette: palette,
        ),
        const SizedBox(height: 16),
        _EducationCard(
          level: 'Secondary School Certificate',
          year: '2014',
          title: 'Secondary School Certificate (SSC)',
          institute: 'Completed in 2014',
          palette: palette,
        ),
      ],
    );

    return _Section(
      heading: _SectionHeading(
        tag: 'Education',
        title: 'My academic journey from secondary education to computer science.',
        description:
            'A progressive academic path that built my analytical thinking, technical foundation and professional software-engineering skills.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 34, child: highlight),
                const SizedBox(width: 22),
                Expanded(flex: 66, child: list),
              ],
            )
          : Column(
              children: [
                highlight,
                const SizedBox(height: 22),
                list,
              ],
            ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({
    required this.level,
    required this.year,
    required this.title,
    required this.institute,
    required this.palette,
    this.note,
  });

  final String level;
  final String year;
  final String title;
  final String institute;
  final String? note;
  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(19),
          boxShadow: palette.shadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 430;
                final badge = _TagPill(
                  text: level,
                  palette: palette,
                  primary: true,
                );
                final yearText = Text(
                  year,
                  style: const TextStyle(
                    color: PortfolioColors.secondary,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                );
                return narrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          badge,
                          const SizedBox(height: 8),
                          yearText,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: badge),
                          const Spacer(),
                          yearText,
                        ],
                      );
              },
            ),
            const SizedBox(height: 13),
            Text(
              title,
              style: TextStyle(
                color: palette.text,
                fontSize: 20,
                height: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              institute,
              style: TextStyle(
                color: palette.muted,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (note != null) ...[
              const SizedBox(height: 11),
              Text(
                note!,
                style: TextStyle(
                  color: palette.muted,
                  fontSize: 13.5,
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TrainingSection extends StatelessWidget {
  const _TrainingSection({
    required this.palette,
    required this.viewportWidth,
    required this.onOpenUrl,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final columns = viewportWidth > 720 ? 2 : 1;
    return _Section(
      heading: _SectionHeading(
        tag: 'Training & Certifications',
        title:
            'Verified learning in Flutter, AI engineering, augmented reality and information security.',
        description:
            'Professional certificates and completed courses that strengthen my work in mobile engineering, artificial intelligence, immersive technology and enterprise systems.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: _FixedGrid(
        columns: columns,
        spacing: 18,
        children: trainingItems
            .map(
              (item) => _TrainingCard(
                item: item,
                palette: palette,
                onOpenUrl: onOpenUrl,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  const _TrainingCard({
    required this.item,
    required this.palette,
    required this.onOpenUrl,
  });

  final TrainingItem item;
  final PortfolioPalette palette;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      lift: 7,
      child: Container(
        constraints: const BoxConstraints(minHeight: 390),
        padding: const EdgeInsets.all(27),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PortfolioColors.secondary.withOpacity(.055),
              palette.surface,
            ],
            stops: const [0, .58],
          ),
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PortfolioColors.secondary.withOpacity(.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                item.icon,
                style: const TextStyle(
                  color: PortfolioColors.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.type.toUpperCase(),
              style: const TextStyle(
                color: PortfolioColors.primary,
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              item.title,
              style: TextStyle(
                color: palette.text,
                fontSize: 20,
                height: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.description,
              style: TextStyle(
                color: palette.muted,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),
            ...item.metadata.map(
              (entry) => Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: palette.border),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 115,
                      child: Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          color: palette.muted,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: palette.text,
                          fontSize: 12.5,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.topics
                  .map(
                    (topic) => _Chip(
                      label: topic,
                      palette: palette,
                      dense: true,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SmallLinkButton(
                  label: 'View certificate ↗',
                  palette: palette,
                  onTap: () => onOpenUrl(item.certificateUrl),
                ),
                if (item.verifyUrl != null)
                  _SmallLinkButton(
                    label: 'Verify credential ↗',
                    palette: palette,
                    secondary: true,
                    onTap: () => onOpenUrl(item.verifyUrl!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({
    required this.palette,
    required this.viewportWidth,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;

  @override
  Widget build(BuildContext context) {
    final columns = viewportWidth > 980
        ? 3
        : viewportWidth > 720
            ? 2
            : 1;
    return _Section(
      heading: _SectionHeading(
        tag: 'Core expertise',
        title:
            'A multidisciplinary toolkit for building complete digital products.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: _FixedGrid(
        columns: columns,
        spacing: 18,
        children: skillGroups
            .map(
              (group) => _HoverLift(
                lift: 7,
                child: Container(
                  padding: const EdgeInsets.all(27),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    border: Border.all(color: palette.border),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.number,
                        style: const TextStyle(
                          color: PortfolioColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        group.title,
                        style: TextStyle(
                          color: palette.text,
                          fontSize: 19.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 9,
                        runSpacing: 9,
                        children: group.skills
                            .map(
                              (skill) => _Chip(
                                label: skill,
                                palette: palette,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({
    required this.palette,
    required this.viewportWidth,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;

  @override
  Widget build(BuildContext context) {
    final desktop = viewportWidth > 980;

    final summary = _Panel(
      palette: palette,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '5+',
            style: TextStyle(
              color: PortfolioColors.primary,
              fontSize: 48,
              height: 1,
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Years in software and mobile product development',
            style: TextStyle(
              color: palette.text,
              fontSize: 21.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Experienced across enterprise applications, commercial mobile products, AI solutions, reusable SDKs and hardware-integrated systems.',
            style: TextStyle(color: palette.muted, height: 1.65),
          ),
        ],
      ),
    );

    final timeline = _Timeline(
      items: experienceItems,
      palette: palette,
      compact: viewportWidth <= 470,
    );

    return _Section(
      heading: _SectionHeading(
        tag: 'Experience',
        title: 'Building software around real operational challenges.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 72, child: summary),
                const SizedBox(width: 24),
                Expanded(flex: 128, child: timeline),
              ],
            )
          : Column(
              children: [
                summary,
                const SizedBox(height: 24),
                timeline,
              ],
            ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.items,
    required this.palette,
    required this.compact,
  });

  final List<ExperienceItem> items;
  final PortfolioPalette palette;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final dotSize = compact ? 40.0 : 48.0;
    return Stack(
      children: [
        Positioned(
          left: compact ? 19 : 23,
          top: 30,
          bottom: 30,
          width: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PortfolioColors.primary,
                  PortfolioColors.secondary.withOpacity(.25),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: dotSize,
                    height: dotSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PortfolioColors.primary,
                      border: Border.all(
                        color: palette.background,
                        width: 5,
                      ),
                    ),
                    child: Text(
                      item.dot,
                      style: const TextStyle(
                        color: Color(0xFF04130D),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(width: compact ? 11 : 17),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: palette.surface,
                        border: Border.all(color: palette.border),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final narrow = constraints.maxWidth < 440;
                              final titleBlock = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      color: palette.text,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item.company,
                                    style: const TextStyle(
                                      color: PortfolioColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              );
                              final badge = _TagPill(
                                text: item.badge,
                                palette: palette,
                                secondary: true,
                              );
                              return narrow
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        titleBlock,
                                        const SizedBox(height: 10),
                                        badge,
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: titleBlock),
                                        const SizedBox(width: 15),
                                        badge,
                                      ],
                                    );
                            },
                          ),
                          const SizedBox(height: 13),
                          Text(
                            item.description,
                            style: TextStyle(
                              color: palette.muted,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({
    required this.palette,
    required this.viewportWidth,
    required this.onOpenUrl,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final columns = viewportWidth > 720 ? 2 : 1;
    return _Section(
      heading: _SectionHeading(
        tag: 'Remarkable projects',
        title:
            'Production applications and engineering projects with real-world impact.',
        description:
            'A focused selection of my enterprise, commercial mobile, artificial-intelligence, machine-learning and real-time communication projects.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: _FixedGrid(
        columns: columns,
        spacing: 20,
        children: projectItems
            .map(
              (project) => _ProjectCard(
                project: project,
                palette: palette,
                onOpenUrl: onOpenUrl,
                compact: viewportWidth <= 470,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.palette,
    required this.onOpenUrl,
    required this.compact,
  });

  final ProjectItem project;
  final PortfolioPalette palette;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      lift: 8,
      child: Container(
        constraints: const BoxConstraints(minHeight: 330),
        padding: EdgeInsets.all(compact ? 24 : 31),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PortfolioColors.primary.withOpacity(.055),
              palette.surface,
            ],
            stops: const [0, .52],
          ),
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 10,
              spacing: 10,
              children: [
                _TagPill(text: project.type, palette: palette),
                _StatusPill(text: project.status),
              ],
            ),
            const SizedBox(height: 19),
            Text(
              project.title,
              style: TextStyle(
                color: palette.text,
                fontSize: 29,
                height: 1.13,
                fontWeight: FontWeight.w900,
                letterSpacing: -.8,
              ),
            ),
            const SizedBox(height: 13),
            Text(
              project.description,
              style: TextStyle(
                color: palette.muted,
                fontSize: 14.5,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 5,
              children: [
                for (var i = 0; i < project.tech.length; i++) ...[
                  Text(
                    project.tech[i],
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (i != project.tech.length - 1)
                    Text(
                      '•',
                      style: TextStyle(color: palette.muted),
                    ),
                ],
              ],
            ),
            const SizedBox(height: 27),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: project.links
                  .map(
                    (link) => _ProjectLinkButton(
                      link: link,
                      palette: palette,
                      onTap: () => onOpenUrl(link.url),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackagesSection extends StatelessWidget {
  const _PackagesSection({
    required this.palette,
    required this.viewportWidth,
    required this.onOpenUrl,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final columns = viewportWidth > 980
        ? 3
        : viewportWidth > 720
            ? 2
            : 1;

    return _Section(
      heading: _SectionHeading(
        tag: 'Open source',
        title: 'Flutter packages created for practical developer needs.',
        description:
            'Click any package card to open its official pub.dev page directly.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: _FixedGrid(
        columns: columns,
        spacing: 17,
        children: packageItems
            .map(
              (pkg) => _HoverLift(
                lift: 6,
                onTap: () => onOpenUrl(pkg.url),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 235),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    border: Border.all(color: palette.border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: PortfolioColors.secondary.withOpacity(.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          pkg.icon,
                          style: const TextStyle(
                            color: PortfolioColors.secondary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pkg.title,
                        style: TextStyle(
                          color: palette.text,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pkg.description,
                        style: TextStyle(
                          color: palette.muted,
                          fontSize: 13.5,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 17),
                      Text(
                        pkg.url.replaceFirst('https://', '') + ' ↗',
                        style: const TextStyle(
                          color: PortfolioColors.primary,
                          fontSize: 12.5,
                          height: 1.45,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PublicationsSection extends StatelessWidget {
  const _PublicationsSection({
    required this.palette,
    required this.viewportWidth,
    required this.onOpenUrl,
  });

  final PortfolioPalette palette;
  final double viewportWidth;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final columns = viewportWidth > 720 ? 2 : 1;

    return _Section(
      heading: _SectionHeading(
        tag: 'Research',
        title: 'Published work in intelligent systems and computing.',
        palette: palette,
      ),
      viewportWidth: viewportWidth,
      child: _FixedGrid(
        columns: columns,
        spacing: 18,
        children: publicationItems
            .map(
              (publication) => Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: palette.surface,
                  border: Border.all(color: palette.border),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 430;
                    final year = Container(
                      width: narrow ? null : 60,
                      height: narrow ? null : 60,
                      padding: narrow
                          ? const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 8,
                            )
                          : EdgeInsets.zero,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PortfolioColors.primary.withOpacity(.09),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Text(
                        publication.year,
                        style: const TextStyle(
                          color: PortfolioColors.primary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );

                    final detail = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          publication.title,
                          style: TextStyle(
                            color: palette.text,
                            fontSize: 16.5,
                            height: 1.35,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          publication.description,
                          style: TextStyle(
                            color: palette.muted,
                            fontSize: 13.5,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SmallLinkButton(
                          label: publication.linkLabel,
                          palette: palette,
                          onTap: () => onOpenUrl(publication.url),
                        ),
                      ],
                    );

                    return narrow
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              year,
                              const SizedBox(height: 18),
                              detail,
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              year,
                              const SizedBox(width: 18),
                              Expanded(child: detail),
                            ],
                          );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    required this.palette,
    required this.viewportWidth,
    required this.onOpenUrl,
    super.key,
  });

  final PortfolioPalette palette;
  final double viewportWidth;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final desktop = viewportWidth > 980;
    final compact = viewportWidth <= 470;

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTag(label: 'Contact', palette: palette),
        const SizedBox(height: 14),
        Text(
          'Let’s build something meaningful.',
          style: TextStyle(
            color: palette.text,
            fontSize: viewportWidth > 980 ? 60 : 42,
            height: 1.02,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 17),
        Text(
          'I’m interested in challenging software engineering roles, enterprise mobile products, AI-powered applications and innovative IoT or automation projects.',
          style: TextStyle(color: palette.muted, height: 1.7),
        ),
        const SizedBox(height: 30),
        _ResponsiveActions(
          fullWidth: compact,
          children: [
            _ActionButton(
              label: 'Send an email',
              primary: true,
              palette: palette,
              onTap: () => onOpenUrl('mailto:recentnafimahmed@gmail.com'),
            ),
            _ActionButton(
              label: 'Download CV ↓',
              palette: palette,
              onTap: () => onOpenUrl(_cvUrl),
            ),
            _ActionButton(
              label: 'Connect on LinkedIn',
              palette: palette,
              onTap: () => onOpenUrl(
                'https://www.linkedin.com/in/nafim-ahmed-recent/',
              ),
            ),
          ],
        ),
      ],
    );

    final contacts = <_ContactData>[
      _ContactData(
        icon: '@',
        label: 'Email',
        value: 'recentnafimahmed@gmail.com',
        action: () => onOpenUrl('mailto:recentnafimahmed@gmail.com'),
      ),
      _ContactData(
        icon: 'WA',
        label: 'Cell and WhatsApp',
        value: '+880 1797-609439',
        action: () => onOpenUrl('https://wa.me/8801797609439'),
      ),
      _ContactData(
        icon: 'GH',
        label: 'GitHub',
        value: 'github.com/NafimAhmed',
        action: () => onOpenUrl('https://github.com/NafimAhmed'),
      ),
      _ContactData(
        icon: 'in',
        label: 'LinkedIn',
        value: 'nafim-ahmed-recent',
        action: () => onOpenUrl(
          'https://www.linkedin.com/in/nafim-ahmed-recent/',
        ),
      ),
      const _ContactData(
        icon: '⌖',
        label: 'Location',
        value: 'Dhaka, Bangladesh',
      ),
      _ContactData(
        icon: '</>',
        label: 'Code portfolio',
        value: 'Explore repositories',
        action: () => onOpenUrl(
          'https://github.com/NafimAhmed?tab=repositories',
        ),
      ),
    ];

    final contactList = LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = !desktop && constraints.maxWidth > 600;
        return _FixedGrid(
          columns: twoColumns ? 2 : 1,
          spacing: 12,
          children: contacts
              .map(
                (item) => _ContactItem(
                  data: item,
                  palette: palette,
                ),
              )
              .toList(),
        );
      },
    );

    return _ContentContainer(
      padding: EdgeInsets.symmetric(vertical: compact ? 82 : 105),
      child: Container(
        padding: EdgeInsets.all(compact ? 22 : (desktop ? 60 : 40)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PortfolioColors.primary.withOpacity(.13),
              palette.surface,
              PortfolioColors.secondary.withOpacity(.10),
            ],
            stops: const [0, .48, 1],
          ),
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(30),
          boxShadow: palette.shadow,
        ),
        child: desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 115, child: copy),
                  const SizedBox(width: 40),
                  Expanded(flex: 85, child: contactList),
                ],
              )
            : Column(
                children: [
                  copy,
                  const SizedBox(height: 40),
                  contactList,
                ],
              ),
      ),
    );
  }
}

class _ContactData {
  const _ContactData({
    required this.icon,
    required this.label,
    required this.value,
    this.action,
  });

  final String icon;
  final String label;
  final String value;
  final VoidCallback? action;
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.data,
    required this.palette,
  });

  final _ContactData data;
  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      lift: 0,
      horizontalShift: 5,
      onTap: data.action,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.035),
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PortfolioColors.primary.withOpacity(.09),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                data.icon,
                style: const TextStyle(
                  color: PortfolioColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.label.toUpperCase(),
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .7,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.value,
                    style: TextStyle(
                      color: palette.text,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.palette,
    required this.onScrollHome,
    required this.onOpenUrl,
  });

  final PortfolioPalette palette;
  final VoidCallback onScrollHome;
  final Future<void> Function(String, {bool sameTab}) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return _ContentContainer(
      padding: const EdgeInsets.only(top: 25, bottom: 38),
      child: Container(
        padding: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: palette.border),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth <= 720;
            final links = Wrap(
              alignment:
                  compact ? WrapAlignment.center : WrapAlignment.end,
              spacing: 15,
              runSpacing: 10,
              children: [
                _TextLink(
                  label: 'Back to home',
                  palette: palette,
                  onTap: onScrollHome,
                ),
                _TextLink(
                  label: 'Email',
                  palette: palette,
                  onTap: () => onOpenUrl('mailto:recentnafimahmed@gmail.com'),
                ),
                _TextLink(
                  label: 'Download CV',
                  palette: palette,
                  onTap: () => onOpenUrl(_cvUrl),
                ),
                _TextLink(
                  label: 'GitHub',
                  palette: palette,
                  onTap: () => onOpenUrl('https://github.com/NafimAhmed'),
                ),
                _TextLink(
                  label: 'LinkedIn',
                  palette: palette,
                  onTap: () => onOpenUrl(
                    'https://www.linkedin.com/in/nafim-ahmed-recent/',
                  ),
                ),
              ],
            );

            final copyright = Text(
              '© $year Nafim Ahmed. Designed and built with care.',
              textAlign: compact ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                color: palette.muted,
                fontSize: 13,
              ),
            );

            return compact
                ? Column(
                    children: [
                      copyright,
                      const SizedBox(height: 18),
                      links,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: copyright),
                      const SizedBox(width: 18),
                      Flexible(child: links),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _BackToTopButton extends StatefulWidget {
  const _BackToTopButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<_BackToTopButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: _hovered ? 1.05 : 1,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PortfolioColors.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: PortfolioColors.primary.withOpacity(.23),
                  blurRadius: 35,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: const Text(
              '↑',
              style: TextStyle(
                color: Color(0xFF04130D),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.heading,
    required this.viewportWidth,
    required this.child,
  });

  final Widget heading;
  final double viewportWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _ContentContainer(
      padding: EdgeInsets.symmetric(
        vertical: viewportWidth <= 470 ? 82 : 105,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading,
          const SizedBox(height: 45),
          child,
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.tag,
    required this.title,
    required this.palette,
    this.description,
  });

  final String tag;
  final String title;
  final String? description;
  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 730),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTag(label: tag, palette: palette),
          const SizedBox(height: 13),
          Builder(
            builder: (context) {
              final width = MediaQuery.sizeOf(context).width;
              final size = (width * .05).clamp(34.0, 60.0).toDouble();
              return Text(
                title,
                style: TextStyle(
                  color: palette.text,
                  fontSize: size,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.8,
                ),
              );
            },
          ),
          if (description != null) ...[
            const SizedBox(height: 15),
            Text(
              description!,
              style: TextStyle(
                color: palette.muted,
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTag extends StatelessWidget {
  const _SectionTag({
    required this.label,
    required this.palette,
  });

  final String label;
  final PortfolioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 2,
          decoration: BoxDecoration(
            color: PortfolioColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: PortfolioColors.primary,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.7,
          ),
        ),
      ],
    );
  }
}

class _ContentContainer extends StatelessWidget {
  const _ContentContainer({
    required this.child,
    required this.padding,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width <= 720 ? 14.0 : 20.0;

    return Padding(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontal),
            child: SizedBox(width: double.infinity, child: child),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.palette,
    required this.padding,
    required this.child,
  });

  final PortfolioPalette palette;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(22),
        boxShadow: palette.shadow,
      ),
      child: child,
    );
  }
}

class _FixedGrid extends StatelessWidget {
  const _FixedGrid({
    required this.columns,
    required this.spacing,
    required this.children,
  });

  final int columns;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map(
                (child) => SizedBox(
                  width: itemWidth,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ResponsiveActions extends StatelessWidget {
  const _ResponsiveActions({
    required this.children,
    this.centered = false,
    this.fullWidth = false,
  });

  final List<Widget> children;
  final bool centered;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    if (fullWidth) {
      final widgets = <Widget>[];
      for (var i = 0; i < children.length; i++) {
        widgets.add(SizedBox(width: double.infinity, child: children[i]));
        if (i != children.length - 1) {
          widgets.add(const SizedBox(height: 13));
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      );
    }

    return Wrap(
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 13,
      runSpacing: 13,
      children: children,
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.label,
    required this.palette,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final PortfolioPalette palette;
  final VoidCallback onTap;
  final bool primary;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 49),
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          decoration: BoxDecoration(
            gradient: widget.primary
                ? const LinearGradient(
                    colors: [
                      PortfolioColors.primary,
                      Color(0xFF72F1C5),
                    ],
                  )
                : null,
            color: widget.primary ? null : widget.palette.surface,
            border: Border.all(
              color: widget.primary
                  ? Colors.transparent
                  : widget.palette.border,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: widget.primary
                ? [
                    BoxShadow(
                      color: PortfolioColors.primary.withOpacity(.22),
                      blurRadius: 35,
                      offset: const Offset(0, 13),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.primary
                  ? const Color(0xFF04130D)
                  : widget.palette.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _TextLink extends StatefulWidget {
  const _TextLink({
    required this.label,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final PortfolioPalette palette;
  final VoidCallback onTap;

  @override
  State<_TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<_TextLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            color:
                _hovered ? PortfolioColors.primary : widget.palette.muted,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.palette,
    this.dense = false,
  });

  final String label;
  final PortfolioPalette palette;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 9 : 10,
        vertical: dense ? 6 : 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.025),
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: palette.muted,
          fontSize: dense ? 11.5 : 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.text,
    required this.palette,
    this.primary = false,
    this.secondary = false,
  });

  final String text;
  final PortfolioPalette palette;
  final bool primary;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    final color =
        secondary ? PortfolioColors.secondary : PortfolioColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: (primary || secondary)
            ? color.withOpacity(.065)
            : Colors.transparent,
        border: Border.all(
          color: (primary || secondary)
              ? color.withOpacity(.25)
              : palette.border,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: .8,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: PortfolioColors.secondary.withOpacity(.065),
        border: Border.all(
          color: PortfolioColors.secondary.withOpacity(.28),
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: PortfolioColors.secondary,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: PortfolioColors.secondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: .6,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallLinkButton extends StatefulWidget {
  const _SmallLinkButton({
    required this.label,
    required this.palette,
    required this.onTap,
    this.secondary = false,
  });

  final String label;
  final PortfolioPalette palette;
  final VoidCallback onTap;
  final bool secondary;

  @override
  State<_SmallLinkButton> createState() => _SmallLinkButtonState();
}

class _SmallLinkButtonState extends State<_SmallLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.secondary
        ? PortfolioColors.secondary
        : PortfolioColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          decoration: BoxDecoration(
            color: color.withOpacity(.065),
            border: Border.all(
              color: color.withOpacity(_hovered ? .58 : .28),
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectLinkButton extends StatefulWidget {
  const _ProjectLinkButton({
    required this.link,
    required this.palette,
    required this.onTap,
  });

  final ProjectLink link;
  final PortfolioPalette palette;
  final VoidCallback onTap;

  @override
  State<_ProjectLinkButton> createState() => _ProjectLinkButtonState();
}

class _ProjectLinkButtonState extends State<_ProjectLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    late Color foreground;
    late Color background;
    late Color border;

    switch (widget.link.kind) {
      case 'store':
        foreground = PortfolioColors.primary;
        background = PortfolioColors.primary.withOpacity(.055);
        border = PortfolioColors.primary.withOpacity(.24);
        break;
      case 'appStore':
        foreground = PortfolioColors.secondary;
        background = PortfolioColors.secondary.withOpacity(.055);
        border = PortfolioColors.secondary.withOpacity(.24);
        break;
      default:
        foreground = widget.palette.text;
        background = Colors.white.withOpacity(.025);
        border = widget.palette.border;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: _hovered
                  ? PortfolioColors.primary.withOpacity(.5)
                  : border,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            widget.link.label,
            style: TextStyle(
              color: foreground,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverLift extends StatefulWidget {
  const _HoverLift({
    required this.child,
    this.onTap,
    this.lift = 5,
    this.horizontalShift = 0,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double lift;
  final double horizontalShift;

  @override
  State<_HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<_HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor:
          widget.onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          transform: Matrix4.translationValues(
            _hovered ? widget.horizontalShift : 0,
            _hovered ? -widget.lift : 0,
            0,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
