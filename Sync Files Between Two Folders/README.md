

This script is a file comparison and synchronization script that creates and manages backup copies of all your important files. Instead of copying every file every time, it determines the differences between a source and a target folder and transfers only the minimum amount of data needed.

Steps it follows:

1. Get all the files in source and destination folders recursively.

2. Checks if the file exists on destination folder

2.1. If not it copies.

2.2. If yes, checks if the content of the files are same or not.

2.2.1. If there is difference, it replaces the file.

2.2.2. If no difference, does not do anything.

3. It asks you whether you want to delete the files which are in destination folder but not in source folder.
