----Project 4A-------


About Project

<1> functions:

address_check()   -- Check if the address is valid
address_get()     -- Get the address, given inodes.
bitmap_compare()  -- Compare two bitmaps.
walk()            -- Walk through all the files and sub-directories

<2> ERROR Information

For blocks marked in-use in bitmap, actually is in-use in an inode or indirect block somewhere. 
If not --> "ERROR: bitmap marks block in use but it is not in use."

No extra links allowed for directories (each directory only appears in one other directory).
If not --> "ERROR: directory appears more than once in file system."

Reference counts (number of links) for regular files match the number of times file is referred to in directories (i.e., hard links work correctly).
If not --> "ERROR: bad reference count for file."
	
For inodes marked used in inode table, must be referred to in at least one directory.
If not --> "ERROR: inode marked use but not found in a directory."

Each inode is either unallocated or one of the valid types (T_FILE, T_DIR, T_DEV).
If not --> "ERROR: bad inode."

Root directory exists, and it is inode number 1.
If not --> "ERROR: root directory does not exist."

The image file is a file that contains the file system image. If the file system image does not exist, you should print the error
If not --> "ERROR: image not found."

Each .. entry in directory refers to the proper parent inode, and parent inode points back to it.
If not --> "ERROR: parent directory mismatch."

Each directory contains . and .. entries.
If not --> "ERROR: directory not properly formatted."

For in-use inodes, any address in use is only used once.
If not --> "ERROR: address used more than once."

For inode numbers referred to in a valid directory, actually marked in use in inode table.
If not --> "ERROR: inode referred to in directory but marked free."

For in-use inodes, each address in use is also marked in use in the bitmap.
If not --> "ERROR: address used by inode but marked free in bitmap."

For in-use inodes, each address that is used by inode is valid (points to a valid datablock address within the image). Note: must check indirect blocks too, when they are in use.
If not --> "ERROR: bad address in inode."

Check if the address is valid.
If not --> "ERROR: address is empty."
