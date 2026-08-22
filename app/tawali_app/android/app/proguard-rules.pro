# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Modelle werden ueber JSON serialisiert
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Flutter verweist auf Play Core (Deferred Components), bindet die Bibliothek
# aber nicht ein. Ohne diese Regel bricht R8 ab:
#   Missing class com.google.android.play.core.splitinstall.SplitInstallException
# Tawali nutzt keine Deferred Components, deshalb genuegt -dontwarn.
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
