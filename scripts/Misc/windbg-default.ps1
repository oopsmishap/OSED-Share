$dbg_dir = "C:\Program Files\Windows Kits\10\Debuggers\x86"

echo "[+] deleting old pykd"
rm "$dbg_dir\winext\pykd.pyd"

copy "$dbg_dir\winext\pykd.pyd.default" "$dbg_dir\winext\pykd.pyd"
copy "$dbg_dir\winext\pykd.dll.default" "$dbg_dir\winext\pykd.dll"

function remove_path($var)
{
	$path = [System.Environment]::GetEnvironmentVariable(
		'PATH',
		[System.EnvironmentVariableTarget]::User
	)

	$path = ($path.Split(';') | Where-Object { $_ -ne "$var" }) -join ';'
	
	[System.Environment]::SetEnvironmentVariable(
		'PATH',
		$path,
		[System.EnvironmentVariableTarget]::User
	)
}

# Add an item to your path
echo "[+] removing python2.7 from PATH"
remove_path "C:\Python27"
remove_path "C:\Python27\Scripts"