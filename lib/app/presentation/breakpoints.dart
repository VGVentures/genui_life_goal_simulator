/// Breakpoint constants for responsive layout decisions.
abstract class Breakpoints {
  static const double mobile = 600;
  static const double desktop = 600;
  static bool isMobile(double width) => width < mobile;
  static bool isDesktop(double width) => width >= desktop;
}
