# win32_ntfs_recovery
NTFS data recovery implementation for __raw disk volumes__ (Tested on a Cruzer Glide 3.0 USB Flash Drive - 16GB)

## Usage:
Export GoDevTool and nasm, then run `build.bat` ... <br>
Run `main.exe` after providing the drive letter for your __raw disk volume__ in `config.cfg` in the format presented ... <br>
Clean dumped output to remove irrelevant files : `clean.bat recovered` ... <br>
Clean all except source files : `clean.bat all` ... <br>

## Error codes:
https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499- <br>

__Custom codes__: <br>
`1701` : Invalid file system ... <br>
`1702` : Drive is not a whole disk volume and was therefore not mounted as a raw volume ... <br>

__Common codes__: <br>
`6` : Drive was not found ... (Invalid handle: Connect drive) <br>
`1110` : The media in drive may have changed ... 

## Important:
Regrettably, `mft.asm` was lost to a crash and only the `mft.obj` module was successfully recovered, however if you really wish to view the code you can always dump it using `objdump` ... <br>
Code attempts recovery on 10,240 file records, meaning it attempts recovery on 10,240 files. This could mean a heavy file dump on some systems ...<br>

## Next steps:
Additional implementations for best effort recovery, away from the standard ...

