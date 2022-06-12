$share_path = "\\tsclient\_mnt_e_share\" # change to your share path

$install_dir = "C:\Users\Offsec\Desktop\MonaFiles"
$dbg_dir = "C:\Program Files\Windows Kits\10\Debuggers\x86"
$desktop_dir = "C:\Users\Offsec\Desktop"

echo "[+] Mounting share to drive Z:"
net use Z: "$share_path" | Out-Null

echo "[+] creating installation directory: $install_dir"
mkdir $install_dir | Out-Null

# install v80 c++ runtime
echo "[+] installing v80 c++ runtime"
copy "Z:\MonaFiles\vcredist_x86_80.exe" $install_dir
cd $install_dir
.\vcredist_x86_80.exe /Q
start-sleep 10

echo "[+] backing up default pykd files"
move "$dbg_dir\winext\pykd.pyd" "$dbg_dir\winext\pykd.pyd.default"
move "$dbg_dir\winext\pykd.dll" "$dbg_dir\winext\pykd.dll.default"

# copy mona files
echo "[+] bringing over mona files and fresh pykd"
copy "Z:\MonaFiles\windbglib.py" $dbg_dir
copy "Z:\MonaFiles\mona.py" $dbg_dir
copy "Z:\MonaFiles\pykd.pyd" "$dbg_dir\winext"
copy "$dbg_dir\winext\pykd.pyd" "$dbg_dir\winext\pykd.pyd.mona"

# install python2.7
echo "[+] installing python2.7"
copy "Z:\MonaFiles\python-2.7.17.msi" $install_dir
msiexec.exe /i $install_dir\python-2.7.17.msi /qn
start-sleep 10

# register Python2.7 binaries in path before Python3
echo "[+] adding python2.7 to the PATH"
$p = [System.Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('Path',"C:\Python27;C:\Python27\Scripts;"+$p,[System.EnvironmentVariableTarget]::User)

# set WinDbg Theme
echo "[+] bringing over WinDbg theme"
copy "Z:\WinDbg\theme.wew" "C:\"

# copy over WinDbg scripts
echo "[+] bringing over WinDbg scripts"
copy "Z:\scripts\WinDbg\find-bad-chars.py" $dbg_dir
copy "Z:\scripts\WinDbg\find-ppr.py" $dbg_dir
copy "Z:\scripts\WinDbg\search.py" $dbg_dir

# copy over other scripts 
echo "[+] bringing over Misc scripts to desktop"
copy "Z:\scripts\Misc\attach-process.ps1" $desktop_dir
copy "Z:\scripts\Misc\windbg-default.ps1" $desktop_dir
copy "Z:\scripts\Misc\windbg-mona.ps1" $desktop_dir

start-sleep 1

#create shortcut for powershell
$WshShell = New-Object -comObject WScript.Shell
echo "[+] creating shortcut for powershell admin"
$PSShortcut = $WshShell.CreateShortcut("$desktop_dir\Admin-Desktop.lnk")
$PSShortcut.TargetPath = "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe"
$PSShortcut.Arguments = '-noexit -command "cd ' + $desktop_dir + '"'
$PSShortcut.Save()
# set to run as admin
$bytes = [System.IO.File]::ReadAllBytes("$desktop_dir\Admin-Desktop.lnk")
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes("$desktop_dir\Admin-Desktop.lnk", $bytes)

# set to UK keyboard layout
echo "[+] setting keyboard locale to en-GB"
Set-WinUserLanguageList -LanguageList en-GB -Force

# last step to ensure it's installed
# register runtime debug dll
echo "[+] registering runtime debug dll"
cd "C:\Program Files\Common Files\Microsoft Shared\VC"
regsvr32 "C:\Program Files\Common Files\microsoft shared\VC\msdia90.dll"

cd $desktop_dir