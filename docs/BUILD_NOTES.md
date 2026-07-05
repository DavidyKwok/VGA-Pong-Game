# Build Notes

## Expected Toolchain

- Xilinx ISE Project Navigator
- Spartan-3E target device
- VHDL source flow
- VGA monitor connected to the board VGA output

## Source Compile Order

```text
debug/ipcore_dir/icon.vhd
src/VGA_Controller.vhd
src/Player_Control.vhd
debug/ipcore_dir/ila.vhd
src/Clock_Divider.vhd
src/Ball_Physics.vhd
src/Game.vhd
```

## Top Level

```text
Game
```

## Constraint File

```text
constraints/game.ucf
```

## Important Note About ChipScope

`Game.vhd` instantiates ICON and ILA debug cores. The repository includes the debug-core wrapper/configuration files under:

```text
debug/ipcore_dir/
```

The small `icon.ngc` and `ila.ngc` debug netlists are kept with the project because the top-level VHDL instantiates those cores. If ISE cannot locate or synthesize the debug cores, regenerate them through Xilinx CORE Generator or temporarily remove the ICON/ILA instances from `Game.vhd` for a non-debug build.

## Excluded Generated Files

The original ISE folder contained many generated files. They were intentionally excluded:

```text
*.bit
*.bgn
*.bld
*.cmd_log
*.drc
*.lso
*.ncd
*.ngc
*.ngd
*.ngr
*.pad
*.par
*.pcf
*.ptwx
*.stx
*.syr
*.twr
*.twx
*.unroutes
*.xrpt
*_map.*
_ngo/
_xmsgs/
iseconfig/
xlnx_auto_0_xdb/
xst/
```

The source files and constraints are the important parts for a GitHub portfolio repository.
