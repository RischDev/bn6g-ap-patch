REM Clear previous artifacts
del combined.gba
del patched-combined.gba

REM generate the ASM patched rom
armips.exe open_mode.asm 

REM apply the changed text banks
py patch-rom.py

PAUSE