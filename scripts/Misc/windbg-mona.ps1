$dbg_dir = "C:\Program Files\Windows Kits\10\Debuggers\x86"

echo "[+] deleting old pykd"
rm "$dbg_dir\winext\pykd.pyd"
rm "$dbg_dir\winext\pykd.dll"

copy "$dbg_dir\winext\pykd.pyd.mona" "$dbg_dir\winext\pykd.pyd"

function add_path($var)
{
	$path = [System.Environment]::GetEnvironmentVariable(
		'PATH',
		[System.EnvironmentVariableTarget]::User
	)

	$path = "$var;$path"
	
	[System.Environment]::SetEnvironmentVariable(
		'PATH',
		$path,
		[System.EnvironmentVariableTarget]::User
	)
}

# Add an item to your path
echo "[+] adding python2.7 back to PATH"
add_path "C:\Python27\Scripts"
add_path "C:\Python27"
