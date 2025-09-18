@echo off
chcp 65001 >nul
title История чата
setlocal enabledelayedexpansion

:init
cls
cd log
set current_size=0

:loop
rem Проверяем размер файла
for %%F in ("Чат-%date%.txt") do set new_size=%%~zF

rem Если размер изменился, обновляем экран
if !new_size! neq !current_size! (
    cls
    if exist "Чат-%date%.txt" type "Чат-%date%.txt"
    set current_size=!new_size!
    echo.
    echo Чат обновлен: %time% [Автообновление]
)

rem Проверяем нажатие клавиши для выхода
timeout /t 2 /nobreak >nul
goto loop
