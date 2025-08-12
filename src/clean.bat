@echo off
setlocal enabledelayedexpansion

echo %1 | findstr /C:"all" > nul
if %errorlevel% equ 0 (goto all)

echo %1 | findstr /C:"recovered" > nul
if %errorlevel% equ 0 (goto rec) else (goto noargs)

:all
  for %%F in (*) do (
    if /I not "%%~xF"==".cfg" ( :: configuration file
      if /I not "%%~xF"==".obj" ( :: modules
        if /I not "%%~xF"==".bat" ( :: scripts
            if /I not "%%~xF"==".asm" ( :: source code
                del "%%F"
            )
        )
      )
    )  
  )
  exit /b

:rec
  set allowed_ext=.obj .bat .asm .txt .png .jpg .jpeg .svg .gif .webp .bmp .ico .mp3 .wav .ogg .flac .mp4 .mkv .mov .avi .html .htm .css .js .ts .json .xml .yml .yaml .yaml0 .py .pyc .pyi .java .c .cpp .h .cs .go .rb .php .rs .swift .kt .lua .sh .md .ini .cfg .log .doc .docx .xls .xlsx .ppt .pptx .pdf .zip .rar .7z .tar .gz .db .sqlite .exe .dll .o .conf .pth .gitignore .idea .olprofile

  for %%F in (*) do (
      set "ext=%%~xF"
      set "ext=!ext:~0,4!" 
      set "keep=false"
      for %%E in (%allowed_ext%) do (
          if /I "!ext!"=="%%E" set "keep=true"
      )
      if "!keep!"=="false" (
          del "%%F"
      )
  )
  endlocal
  exit /b

:noargs
  echo Err: No arguments were issued, try again...
  exit /b
