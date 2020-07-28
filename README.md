A script to auto install the Python version of Wrye Bash on Linux.

## Why?
The Python version of Wrye Bash routinely runs better and more stable.
It does require a bit of work in the terminal to get running, and the current guide available on the wiki is out of date.
So I decided to just make a script for it.

## Problems
* Currently doesn't work properly if a requirement can't be fulfilled.
This includes the link to the Python LOOT API, that can sometimes break.

* Currently can't use a WIP source to install Wrye Bash

## Use
Simply run the script in any directory and follow the directions.


## Todo
- [ ] Enable use of the nightly/WIP builds over dev builds
	- This includes being able to switch branches
- [ ] Clean up code to better handle exceptions (like dead LOOT API link)
