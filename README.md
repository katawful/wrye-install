A script to auto install the Python version of Wrye Bash on Linux.

## Why?
The Python version of Wrye Bash routinely runs better and more stable.
It does require a bit of work in the terminal to get running, and the current guide available on the wiki is out of date.
So I decided to just make a script for it.

## Problems
* As this script doesn't run or compile a compiled version of Wrye Bash, the LOOT taglist support is missing.
This is a minor issue for Oblivion users, and a bigger one for newer game users like Skyrim or FNV.
If you need this feature, I recommend installing one of the WIP builds for now until I implement that into this script, if at all.

## Use
Simply run the script in any directory and follow the directions.


## Todo
- [x] Enable use of the nightly/WIP builds over dev builds
	- This includes being able to switch branches
- [/] Clean up code to better handle exceptions (like dead LOOT API link)
