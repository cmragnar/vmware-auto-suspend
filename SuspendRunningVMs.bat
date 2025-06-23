@echo off
REM VMware Auto-Suspend - Handles multiple VMs properly

SET VMWARE_PATH="C:\Program Files (x86)\VMware\VMware Player"
IF NOT EXIST %VMWARE_PATH%\vmrun.exe (
    SET VMWARE_PATH="C:\Program Files (x86)\VMware\VMware Workstation"
)
cd /d %VMWARE_PATH%
IF NOT EXIST vmrun.exe exit /b 1

REM Count running VMs
for /f "tokens=4" %%G in ('vmrun.exe list ^| find "Total running"') DO SET VM_COUNT=%%G
echo Found %VM_COUNT% running VMs

REM Suspend all VMs in parallel (faster for multiple VMs)
for /f "skip=1 delims=" %%G in ('vmrun.exe list') DO (
    echo Suspending: %%G
    START "" /B vmrun.exe suspend "%%G"
)

REM Wait for all VMs to suspend (10 seconds per VM max)
SET /A WAIT_TIME=%VM_COUNT%*10
IF %WAIT_TIME% GTR 60 SET WAIT_TIME=60
echo Waiting up to %WAIT_TIME% seconds for VMs to suspend...
timeout /t %WAIT_TIME% /nobreak >nul

REM Verify all VMs are suspended
vmrun.exe list | find "Total running VMs: 0"
IF ERRORLEVEL 1 (
    echo Warning: Some VMs may still be running!
    REM Force suspend any remaining VMs
    for /f "skip=1 delims=" %%G in ('vmrun.exe list') DO vmrun.exe suspend "%%G" hard
)

exit /b 0
