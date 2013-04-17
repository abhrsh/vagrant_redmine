@pushd %~dp0

if not exist "%~dp0¥.vagrant" (
  call vagrant up
  if not exist "%USERPROFILE%\.ssh" mkdir %USERPROFILE%\.ssh\config
  call vagrant ssh-config --host base >> "%USERPROFILE%\.ssh\config"
)

@popd
pause
