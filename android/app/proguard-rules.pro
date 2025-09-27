# Razorpay required rules
-keep class com.razorpay.** { *; }
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Optional but helpful
-dontwarn com.razorpay.**
