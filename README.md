# Cappy
Cappy but in Super Mario World

Here's the full source code of the hacks used for Super Mario World Odyssey. There's almost no comments on the files, so have fun reading it. Hopefully the label names and the defines makes reading this less painful.

## Patching process
Requires:
- [Asar 1.60+](https://github.com/RPGHacker/asar/releases/latest)
- [Lunar Magic 2.53+](https://fusoya.eludevisibility.org/lm/program.html)

Steps: 
* Open a clean Super Mario Wolrd USA ROM in Lunar Magic
* Insert GFX and ExGFX with Lunar Magic, this will expand your ROM to 2MB and apply some other ASM hacks required for this to work.
* Patch `hat_engine.asm` to your ROM with Asar.
