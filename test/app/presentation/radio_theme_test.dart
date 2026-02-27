import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/app_theme.dart';
import 'package:finance_app/app/presentation/radio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RadioThemeData', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme(LightThemeColors()).themeData;
    });

    test('has radio theme configured', () {
      expect(theme.radioTheme, isNotNull);
    });

    group('fillColor', () {
      test('returns primary color when enabled', () {
        final fillColor = theme.radioTheme.fillColor!;
        final color = fillColor.resolve(<WidgetState>{});

        expect(color, RadioColors.primary);
      });

      test('returns disabled color when disabled', () {
        final fillColor = theme.radioTheme.fillColor!;
        final color = fillColor.resolve({WidgetState.disabled});

        expect(color, RadioColors.disabled);
      });

      test('returns error color when error state', () {
        final fillColor = theme.radioTheme.fillColor!;
        final color = fillColor.resolve({WidgetState.error});

        expect(color, RadioColors.error);
      });

      test('disabled takes precedence over error', () {
        final fillColor = theme.radioTheme.fillColor!;
        final color = fillColor.resolve({
          WidgetState.disabled,
          WidgetState.error,
        });

        expect(color, RadioColors.disabled);
      });
    });

    group('overlayColor', () {
      test('returns transparent when no interaction state', () {
        final overlayColor = theme.radioTheme.overlayColor!;
        final color = overlayColor.resolve(<WidgetState>{});

        expect(color, Colors.transparent);
      });

      test('returns primary hovered color on hover', () {
        final overlayColor = theme.radioTheme.overlayColor!;
        final color = overlayColor.resolve({WidgetState.hovered});

        expect(color, RadioColors.primaryHovered);
      });

      test('returns primary focused color on focus', () {
        final overlayColor = theme.radioTheme.overlayColor!;
        final color = overlayColor.resolve({WidgetState.focused});

        expect(color, RadioColors.primaryFocused);
      });

      test('returns primary pressed color on press', () {
        final overlayColor = theme.radioTheme.overlayColor!;
        final color = overlayColor.resolve({WidgetState.pressed});

        expect(color, RadioColors.primaryPressed);
      });

      test('returns error hovered color on hover with error', () {
        final overlayColor = theme.radioTheme.overlayColor!;
        final color = overlayColor.resolve({
          WidgetState.hovered,
          WidgetState.error,
        });

        expect(color, RadioColors.errorHovered);
      });

      test('returns error focused color on focus with error', () {
        final overlayColor = theme.radioTheme.overlayColor!;
        final color = overlayColor.resolve({
          WidgetState.focused,
          WidgetState.error,
        });

        expect(color, RadioColors.errorFocused);
      });

      test('returns error pressed color on press with error', () {
        final overlayColor = theme.radioTheme.overlayColor!;
        final color = overlayColor.resolve({
          WidgetState.pressed,
          WidgetState.error,
        });

        expect(color, RadioColors.errorPressed);
      });
    });

    test('splash radius is 24', () {
      expect(theme.radioTheme.splashRadius, 24);
    });

    test('material tap target size is padded (48px)', () {
      expect(
        theme.radioTheme.materialTapTargetSize,
        MaterialTapTargetSize.padded,
      );
    });
  });

  group('RadioColors', () {
    test('primary color is #6d92f5', () {
      expect(RadioColors.primary, const Color(0xFF6D92F5));
    });

    test('error color is #BB1B1B', () {
      expect(RadioColors.error, const Color(0xFFBB1B1B));
    });

    test('disabled color is #aaabab', () {
      expect(RadioColors.disabled, const Color(0xFFAAABAB));
    });

    test('primaryHovered color is #f3f6ff', () {
      expect(RadioColors.primaryHovered, const Color(0xFFF3F6FF));
    });

    test('primaryFocused has 12% opacity', () {
      final alpha = (RadioColors.primaryFocused.a * 255.0).round();
      expect(alpha, closeTo(255 * 0.12, 1));
    });

    test('primaryPressed has 16% opacity', () {
      final alpha = (RadioColors.primaryPressed.a * 255.0).round();
      expect(alpha, closeTo(255 * 0.16, 1));
    });

    test('errorHovered has 8% opacity', () {
      final alpha = (RadioColors.errorHovered.a * 255.0).round();
      expect(alpha, closeTo(255 * 0.08, 1));
    });

    test('errorFocused has 12% opacity', () {
      final alpha = (RadioColors.errorFocused.a * 255.0).round();
      expect(alpha, closeTo(255 * 0.12, 1));
    });

    test('errorPressed has 16% opacity', () {
      final alpha = (RadioColors.errorPressed.a * 255.0).round();
      expect(alpha, closeTo(255 * 0.16, 1));
    });
  });
}
