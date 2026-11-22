snap () 
{ 
    for s in "system font_scale" "secure display_density_forced" "global window_animation_scale" "global transition_animation_scale" "global animator_duration_scale" "secure high_text_contrast_enabled" "secure ui_night_mode" "secure enabled_accessibility_services" "secure accessibility_enabled" "system accelerometer_rotation" "system user_rotation" "secure touch_exploration_enabled" "system screen_off_timeout" "global stay_on_while_plugged_in";
    do
        echo "$s=$("$ADB" shell settings get $s | tr -d '\r')";
    done;
    echo "wm_density=$("$ADB" shell wm density | tr -d '\r')";
    echo "wm_size=$("$ADB" shell wm size | tr -d '\r')";
    "$ADB" shell cmd uimode night | tr -d '\r';
    "$ADB" shell cmd locale get-app-locales $PK | tr -d '\r';
    echo "sys_locale=$("$ADB" shell getprop persist.sys.locale | tr -d '\r')"
}
