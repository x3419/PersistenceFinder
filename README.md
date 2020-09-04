## This is a simple registry persistence enumerator meant to quickly triage during incident response scenarios.

### Currently it enumerates the following keys (if they are not empty)

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\
HKEY_LOCAL_MACHINE\CurrentControlSet\Control\hivelist\
HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Session\
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\
	- Shell hijacking
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\
	- Shell hijacking
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\
	- Identifies the location of the Startup folder and then enumerates all files within that folder
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices\
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs\

### If you want to have it print out KnownDLLs so you can check for hijacking, set INCLUDE_KNOWN_DLLS in the main class to true.