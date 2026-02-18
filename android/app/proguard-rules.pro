# Flutter default ProGuard rules
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Suppress missing Play Core split-install classes referenced by Flutter
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
