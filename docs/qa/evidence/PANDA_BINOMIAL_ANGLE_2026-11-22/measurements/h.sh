export MSYS_NO_PATHCONV=1
ADB="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
U="${UAT_DIR:?set UAT_DIR to the capture directory}"
PK=com.quantumlab.mathtutor.gb
fg() { "$ADB" shell dumpsys window | grep -m1 mCurrentFocus | sed 's/\r//'; }
guard() { fg | grep -q "$PK" || { echo "STOP: foreground is not $PK: $(fg)"; return 1; }; }
dump() { "$ADB" shell uiautomator dump /sdcard/uat_ui.xml >/dev/null 2>&1; "$ADB" exec-out cat /sdcard/uat_ui.xml > $U/ui.xml; }
nodes() { dump; py -I -c "
import re,sys
x=open(r'$(cygpath -w $U)\ui.xml',encoding='utf-8').read()
for m in re.finditer(r'<node [^>]*>', x):
    n=m.group(0); g=lambda p:(re.search(p,n) or [None,''])[1]; d=g(r'content-desc=\"([^\"]*)\"'); t=g(r' text=\"([^\"]*)\"'); b=re.search(r'bounds=\"([^\"]*)\"',n).group(1)
    if d or t: print(b, repr((t+' | '+d).strip(' |'))[:160])
"; }
tapxy() { guard && "$ADB" shell input tap $1 $2 && sleep ${3:-1.2}; }
tapdesc() { dump; local b=$(py -I -c "
import re
x=open(r'$(cygpath -w $U)\ui.xml',encoding='utf-8').read()
for m in re.finditer(r'<node [^>]*>', x):
    n=m.group(0)
    if re.search(r'(content-desc|text)=\"[^\"]*'+re.escape(r'''$1''')+r'[^\"]*\"', n):
        a,b,c,d=map(int,re.findall(r'\d+',re.search(r'bounds=\"([^\"]*)\"',n).group(1))); print((a+c)//2,(b+d)//2); break
"); [ -z "$b" ] && { echo "NOT FOUND: $1"; return 1; }; tapxy $b; }
shot() { guard && "$ADB" exec-out screencap -p > $U/shots/$1.png && echo "shot $1"; }
# hash of a screen region from a raw screencap: rawhash name x0 y0 x1 y1
rawhash() { guard || return 1; "$ADB" exec-out screencap > $U/raw_$1.bin; py -I -c "
import hashlib,struct,sys
b=open(r'$(cygpath -w $U)\raw_$1.bin','rb').read()
w,h,f=struct.unpack('<III',b[:12]); off=16 if len(b)>=16+w*h*4 else 12
x0,y0,x1,y1=$2,$3,$4,$5
rows=b''.join(b[off+(y*w+x0)*4: off+(y*w+x1)*4] for y in range(y0,y1))
print(hashlib.sha256(rows).hexdigest()[:16])
"; }
keys() { guard && "$ADB" shell input keyevent $(printf '%s ' $(for i in $(seq 1 $2); do echo $1; done)) && sleep 0.8; }
readout() { dump; grep -oE 'Your angle: [0-9.,]+ degrees|Target angle: [0-9]+ degrees' $U/ui.xml | tr '\n' ' '; echo; }
bounds() { dump; py -I -c "
import re
x=open(r'$(cygpath -w $U)\ui.xml',encoding='utf-8').read()
for m in re.finditer(r'<node [^>]*>', x):
    n=m.group(0)
    if re.search(r'(content-desc|text)=\"[^\"]*'+re.escape(r'''$1''')+r'[^\"]*\"', n):
        print(*re.findall(r'\d+',re.search(r'bounds=\"([^\"]*)\"',n).group(1))); break
"; }
scrollto() { for i in 1 2 3 4 5 6; do [ -n "$(bounds "$1")" ] && return 0; guard && "$ADB" shell input swipe $2 $3 $2 $4 300; sleep 0.8; done; echo "NOT REACHABLE: $1"; return 1; }
# cfgcheck NAME SWIPE_X SWIPE_FROM_Y SWIPE_TO_Y : pixel invariance across 4 targets at aims 0,29; then match 45
cfgcheck() {
  local name=$1 out=$U/logs/V6_$1.txt; : > $out
  for t in 30 45 60 90; do
    scrollto "$t degree target" $2 $3 $4 || return 1; tapdesc "$t degree target"
    read px0 py0 px1 py1 <<< "$(bounds 'Football pitch')"
    tapxy $((px0+50)) $((py0+50)); keys 22 1
    local r=$(readout); [[ "$r" == *"angle: 1 degrees"* ]] && keys 21 1   # undo if first key was not consumed
    r=$(readout); local h0=$(rawhash a $px0 $py0 $px1 $py1)
    keys 22 29; local r2=$(readout); local h29=$(rawhash b $px0 $py0 $px1 $py1)
    echo "t=$t pitch=[$px0,$py0,$px1,$py1] aim0=$h0 aim29=$h29 | $r | $r2" | tee -a $out
  done
  scrollto "45 degree target" $2 $3 $4; tapdesc "45 degree target"; read px0 py0 px1 py1 <<< "$(bounds 'Football pitch')"
  tapxy $((px0+50)) $((py0+50)); keys 22 1; r=$(readout); [[ "$r" == *"angle: 1 degrees"* ]] && keys 21 1
  keys 22 44; echo "pre-match: $(readout)" | tee -a $out
  scrollto "Check angle" $2 $3 $4; tapdesc "Check angle"; sleep 1
  echo "post-match: $(readout)" | tee -a $out; dump; grep -oE '(content-desc|text)="[^"]*(created|You created)[^"]*"' $U/ui.xml | head -2 | tee -a $out
  shot V6_${name}_matched
  echo "unique aim0 hashes: $(grep -oE 'aim0=[0-9a-f]+' $out | sort -u | wc -l), unique aim29 hashes: $(grep -oE 'aim29=[0-9a-f]+' $out | sort -u | wc -l)" | tee -a $out
}
gocta() {
  for i in 1 2 3 4 5; do [ -n "$(bounds 'Tab 1 of 5')" ] && break; guard && "$ADB" shell input keyevent 4; sleep 1.2; done
  tapdesc "Tab 1 of 5"; tapdesc "Math Studio&#10;" || return 1; tapdesc "Visual Maths. See" || return 1; tapdesc "Interactive Labs. Hands-on" || return 1
  for i in 1 2 3 4; do [ -n "$(bounds 'Applied Maths Studio. Interactive')" ] && break; "$ADB" shell input swipe 540 1800 540 700 400; sleep 1; done
  tapdesc "Applied Maths Studio. Interactive" || return 1; tapdesc "Create the Angle. Aim" || return 1; sleep 1; readout
}
gostudio() {
  for i in 1 2 3 4 5; do [ -n "$(bounds 'Tab 1 of 5')" ] && break; guard && "$ADB" shell input keyevent 4; sleep 1.2; done
  tapdesc "Tab 1 of 5"; tapdesc "Math Studio&#10;" || return 1; tapdesc "Visual Maths. See" || return 1; tapdesc "Interactive Labs. Hands-on" || return 1
  for i in 1 2 3 4; do [ -n "$(bounds 'Applied Maths Studio. Interactive')" ] && break; "$ADB" shell input swipe 540 1800 540 700 400; sleep 1; done
  tapdesc "Applied Maths Studio. Interactive" || return 1
}
goa11y() {
  for i in 1 2 3 4 5 6; do [ -n "$(bounds 'Tab 5 of 5')" ] && break; guard && "$ADB" shell input keyevent 4; sleep 1.2; done
  tapdesc "Tab 5 of 5"; sleep 0.8; tapdesc "Profile" || return 1; sleep 0.8; scrollto "Accessibility" 540 1900 1000 && tapdesc "Accessibility"; sleep 1
}
