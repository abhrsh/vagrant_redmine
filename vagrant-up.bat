@pushd %~dp0

call vagrant up
call vagrant ssh-config --host base >> "%USERPROFILE%\.ssh\config"

@popd
pause
