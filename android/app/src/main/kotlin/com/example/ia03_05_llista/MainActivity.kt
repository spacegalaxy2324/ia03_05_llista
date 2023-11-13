package com.example.ia03_05_llista

import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onPostResume() {
       super.onPostResume() 
       WindowCompat.setDecorFitsSystemWindows(window, false) 
    }
}
