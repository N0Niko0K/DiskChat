@echo off
chcp 65001 >nul
title Отправка сообщений
setlocal enabledelayedexpansion

if not exist "%appdata%\local\DiskChat" mkdir "%appdata%\local\DiskChat"
set usersfile="%appdata%\local\DiskChat\Users.txt"

if exist %usersfile% (
    echo Обнаружены сохраненные имена:
    echo.
    
    set count=0
    for /f "usebackq delims=" %%a in (%usersfile%) do (
        set /a count+=1
        set "user!count!=%%a"
        if !count! equ 10 goto display_users
    )
    
    :display_users
    for /l %%i in (1,1,!count!) do (
        echo %%i. !user%%i!
    )
    echo 0. Ввести новое имя
    echo.
    
    :select_user
    set /p "choice=Выберите вариант (0-!count!): "
    if "!choice!"=="0" goto new_user
    
    set /a choice=!choice!
    if !choice! gtr 0 if !choice! leq !count! (
        for /f "tokens=1-2 delims==" %%a in ('set user!choice!') do set user=%%b
        goto user_selected
    )
    echo Неверный выбор, попробуйте снова.
    goto select_user
) else (
    goto new_user
)

:new_user
set "user="
cls
set /p "user=Введите имя: "
    if "!user!"=="" (
	cls
	goto new_user
	)
if exist %usersfile% (
    echo !user!>%usersfile%.tmp
    set keep=9
    for /f "usebackq delims=" %%a in (%usersfile%) do (
        if !keep! gtr 0 (
            echo %%a>>%usersfile%.tmp
            set /a keep-=1
        )
    )
    move /y %usersfile%.tmp %usersfile% >nul
) else (
    echo !user!>%usersfile%
)

:user_selected
cls
if not exist log (
    md log
)
cd log
start Read.bat

echo [90m[SYSTEM]][0m [%time%] !user! присоединяется к чату!] >> Чат-%date%.txt

:start
cls
set "message="
set /p "message=Ваше сообщение: "
if "!message!"=="" (
    echo Error: Сообщение не может быть пустым!
    echo.
    goto start
	timeout /t 1 /nobreak >nul
) else (
    echo [%time%][!user!]: !message! >> Чат-%date%.txt
    echo Отправлено!
    timeout /t 1 /nobreak >nul
    goto start
)