#ifndef _fschecker_H_
#define _fschecker_H_

#define T_DIR       1   // Directory
#define T_FILE      2   // File
#define T_DEV       3   // Special device

/*

================= file system structure in xv6 ======================
|-------------|-------------|-------------|-------------|-------------|
|             |             |             |             |             |
|    unused   | superblock  |  inodetable |   bitmap    | data blocks |
|             |             |             |   (data)    |             |
|-------------|-------------|-------------|-------------|-------------|

Here block 0 is unused, block 1 is super block, inodes start at block 2.

*/

#define ROOTINODE 1  // inode number of root is 1
#define BSIZE 512  // block size is 512 bytes

//file system super block
struct superblock
{
	uint size;      // Size of file system image (blocks)
	uint nblocks;   // Number of data blocks
	uint ninodes;   // number of inodes
};

#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Bits per block
#define BPB           (BSIZE*8)

// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEV only)
  short minor;          // Minor device number (T_DEV only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+1];   // Data block addresses
};

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

#endif // for _fschecker_H_
