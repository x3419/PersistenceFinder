## This is a simple registry persistence enumerator meant to quickly triage during incident response scenarios.

### Currently it enumerates the following keys (if they are not empty)

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\
HKEY_LOCAL_MACHINE\CurrentControlSet\Control\hivelist\
HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Session\
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices\
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs\

### If you want to have it print out KnownDLLs so you can check for hijacking, set INCLUDE_KNOWN_DLLS in the main class to true.