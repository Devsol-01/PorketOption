# Add rules to handle Flutter accessibility reflection issues
-keep class io.flutter.view.AccessibilityViewEmbedder$ReflectionAccessors { *; }
-keepclassmembers class io.flutter.view.AccessibilityViewEmbedder$ReflectionAccessors { *; }

# Keep accessibility classes that Flutter might access via reflection
-keep class android.view.accessibility.AccessibilityNodeInfo { *; }
-keep class android.view.accessibility.AccessibilityRecord { *; }
-keep class android.util.LongArray { *; }

# Keep methods that Flutter accessibility might call via reflection
-keepclassmembers class android.view.accessibility.AccessibilityNodeInfo {
    public *** getSourceNodeId();
    public *** mChildNodeIds;
}

-keepclassmembers class android.view.accessibility.AccessibilityRecord {
    public *** getSourceNodeId();
}

-keepclassmembers class android.util.LongArray {
    public *** get(int);
}

# Keep Flutter engine classes
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.plugin.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# General Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }

# Keep annotation classes
-keep class androidx.annotation.Keep
-keep @androidx.annotation.Keep class * {*;}

# Keep all classes that have Keep annotation
-keep,allowobfuscation @interface androidx.annotation.Keep
-keep @androidx.annotation.Keep class *
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Don't warn about hidden API access (this is what's causing the crashes)
-dontwarn android.view.accessibility.**
-dontwarn android.util.LongArray
-dontwarn io.flutter.view.AccessibilityViewEmbedder$ReflectionAccessors

# General optimization rules
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
