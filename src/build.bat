@echo off
if exist main.exe (del main.exe)
nasm -f win32 main.asm
nasm -f win32 e_hd.asm
nasm -f win32 rchd.asm
nasm -f win32 rec.asm
nasm -f win32 rs.asm
nasm -f win32 nr.asm
nasm -f win32 nr1.asm
nasm -f win32 nrf.asm
@REM nasm -f win32 nr.asm
golink /console /entry main main.obj mft.obj e_hd.obj rchd.obj rec.obj rs.obj nr.obj nr1.obj nrf.obj kernel32.dll
if exist main.exe (del main.obj e_hd.obj rchd.obj rec.obj rs.obj nr.obj nr1.obj nrf.obj)
 