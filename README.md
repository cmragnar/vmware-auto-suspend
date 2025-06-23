# VMware Auto-Suspend Script

Automatically suspends VMware VMs on Windows shutdown using Group Policy.

## Quick Install

1. Save this script as `VMwareSuspend.bat`:

```batch
@echo off
SET VMWARE_PATH="C:\Program Files (x86)\VMware\VMware Player"
IF NOT EXIST %VMWARE_PATH%\vmrun.exe (
    SET VMWARE_PATH="C:\Program Files (x86)\VMware\VMware Workstation"
)
cd /d %VMWARE_PATH%
IF NOT EXIST vmrun.exe exit /b 1
for /f "skip=1 delims=" %%G in ('vmrun.exe list') DO vmrun.exe suspend "%%G"
timeout /t 5 /nobreak >nul
exit /b 0
```

2. Copy to: `C:\Windows\System32\GroupPolicy\Machine\Scripts\Shutdown\`

3. Run: `gpupdate /force`

## How It Works

- Finds VMware installation (Player or Workstation)
- Lists all running VMs using `vmrun list`
- Suspends each VM before Windows shuts down
- Waits 5 seconds for operations to complete

## Notes

- Requires Windows Pro/Enterprise (Group Policy)
- Only triggers on shutdown, not logoff
- Adjust `VMWARE_PATH` if VMware is installed elsewhere
