#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>
#include <sys/mman.h>
#include <string.h>
#include <stdint.h>
#include "fschecker.h"

// The start point of each segment in the file system
void *img_ptr;
struct superblock *sb;
struct dinode *dinodepointer; // inode table
char *bitmap;
void *datablock;  //data block pointer 

// Check if the address is valid
void address_check(char *new_bitmap, uint addr) {
  if (addr == 0) {
    return;
  }
  // Address out of bound
  if (addr < (sb->ninodes/IPB + sb->nblocks/BPB + 4) || addr >= (sb->ninodes/IPB + sb->nblocks/BPB + 4 + sb->nblocks)) 
  {
    fprintf(stderr, "ERROR: bad address in inode.\n");
    exit(1);
  }
    // In use but marked free
  char byte = *(bitmap + addr / 8);
  if (!((byte >> (addr % 8)) & 0x01)) 
  {
    fprintf(stderr, "ERROR: address used by inode but marked free in bitmap.\n");
    exit(1);
  }
}

// Get the block number
uint address_get(uint off, struct dinode *current_dinodepointer, int indirect_flag) {
  if (off / BSIZE <= NDIRECT && !indirect_flag) 
  {
    return current_dinodepointer->addrs[off / BSIZE];
  } 
  else 
  {
    return *((uint*) (img_ptr + current_dinodepointer->addrs[NDIRECT] * BSIZE) + off / BSIZE - NDIRECT);
  }
}

// Compare two bitmaps. Return 1 when two bitmaps are different, 0 when they are the same
int bitmap_compare(char *bitmap1, char *bitmap2, int size) {
  int i;
  for (i = 0; i < size; ++i) 
  {
    if (*(bitmap1++) != *(bitmap2++)) 
    {
      return 1;
    }
  }

  return 0;
}

void walk(int *inode_ref, char* new_bitmap, int inum, int parent_inum) {
  struct dinode *current_dinodepointer = dinodepointer + inum;
    
  if (current_dinodepointer->type == 0) 
  {
    fprintf(stderr, "ERROR: inode referred to in directory but marked free.\n");
    exit(1);
  }
  
  // Empty dir without . and ..
  if (current_dinodepointer->type == T_DIR && current_dinodepointer->size == 0) 
  {
    fprintf(stderr, "ERROR: directory not properly formatted.\n");
    exit(1);
  }
  
  // Update current node's reference count
  inode_ref[inum]++;
  if (inode_ref[inum] > 1 && current_dinodepointer->type == T_DIR) 
  {
    fprintf(stderr, "ERROR: directory appears more than once in file system.\n");
    exit(1);
  }
  
  int off;
  // Mark if it is indirect block
  // Because the offset at NDIRECT will need two address check:
  // One for addrs[NDIRECT], and one for the first addr in indirect block
  int indirect_flag = 0;
  
  for (off = 0; off < current_dinodepointer->size; off += BSIZE) 
  {
    uint addr = address_get(off, current_dinodepointer, indirect_flag);
    address_check(new_bitmap, addr);

    if (off / BSIZE == NDIRECT && !indirect_flag) 
    {
      off -= BSIZE;
      indirect_flag = 1;
    }
    
    // Check duplicate and mark on new bitmap when the inode is first met
    if (inode_ref[inum] == 1) 
    {
      char byte = *(new_bitmap + addr / 8);
      if ((byte >> (addr % 8)) & 0x01) 
      {
        fprintf(stderr, "ERROR: address used more than once.\n");
        exit(1);
      } 
      else 
      {
        byte = byte | (0x01 << (addr % 8));
        *(new_bitmap + addr / 8) = byte;
      }
    }
    
    if (current_dinodepointer->type == T_DIR) 
    {
      struct dirent *directory_entry = (struct dirent *) (img_ptr + addr * BSIZE);

      // Check . and .. in DIR
      if (off == 0) 
      {
        if (strcmp(directory_entry->name, ".")) 
        {
          fprintf(stderr, "ERROR: directory not properly formatted.\n");          
          exit(1);
        }
        if (strcmp((directory_entry + 1)->name, "..")) 
        {
          fprintf(stderr, "ERROR: directory not properly formatted.\n");
          exit(1);
        }
        
        // check parent
        if ((directory_entry + 1)->inum != parent_inum) 
        {
          if (inum == ROOTINODE) 
          {
            fprintf(stderr, "ERROR: root directory does not exist.\n");
          } 
          else 
          {
            fprintf(stderr, "ERROR: parent directory mismatch.\n");
          }
          
          exit(1);
        }
        
        directory_entry += 2;
      }

      for (; directory_entry < (struct dirent *)(ulong)(img_ptr + (addr + 1) * BSIZE); directory_entry++) 
      {
        if (directory_entry->inum == 0) 
        {
          continue;
        }

        // walk through all the files and sub-directories
        walk(inode_ref, new_bitmap, directory_entry->inum, inum);
      }
    }
  }
}

int main(int argc, char** argv) 
{
   // open the fs.img
  int fd = open(argv[1], O_RDONLY);
  if (fd == -1) 
  {
    fprintf(stderr, "ERROR: image not found.\n");
    exit(1);
  }
  
  int rc;
  struct stat sbuf;
  rc = fstat(fd, &sbuf);  // get the info about the file system
  assert(rc == 0);
  
  // use mmap() to get the 
  img_ptr = mmap(NULL, sbuf.st_size, PROT_READ, MAP_PRIVATE, 
                       fd, 0);
  assert(img_ptr != MAP_FAILED);
  
  sb = (struct superblock *) ((void*)img_ptr + BSIZE); // super block starts at second block
  
  // inodes
  int i;
  dinodepointer = (struct dinode *) ((void*)img_ptr + 2 * BSIZE);  // inode table starts at third block
  bitmap = (char *) (img_ptr + (sb->ninodes / IPB + 3) * BSIZE);  // bitmap starts at fourth block
  datablock = (void *) (img_ptr + (sb->ninodes/IPB + sb->nblocks/BPB + 4) * BSIZE); // data block starts at fifth block
  
  int bitmap_size = (sb->nblocks + sb->ninodes/IPB + sb->nblocks/BPB + 4) / 8;
  int data_offset = sb->ninodes/IPB + sb->nblocks/BPB + 4;
  int inode_ref[sb->ninodes + 1];
  memset(inode_ref, 0, (sb->ninodes + 1) * sizeof(int));
  char new_bitmap[bitmap_size];
  // Initialize new bitmap
  memset(new_bitmap, 0, bitmap_size);
  memset(new_bitmap, 0xFF, data_offset / 8);
  char last = 0x00;
  for (i = 0; i < data_offset % 8; ++i) 
  {
    last = (last << 1) | 0x01;
  }
  new_bitmap[data_offset / 8] = last;
  
  // First: Check root directory
  if (!(dinodepointer + ROOTINODE) || (dinodepointer + ROOTINODE)->type != T_DIR) 
  {
    fprintf(stderr, "ERROR: root directory does not exist.\n");
    exit(1);
  }
  
  // Second: Walk through directories to check the file system
  walk(inode_ref, new_bitmap, ROOTINODE, ROOTINODE);
  
  struct dinode *current_dinodepointer = dinodepointer;
  
  for (i = 1; i < sb->ninodes; i++) 
  {
    current_dinodepointer++;
    // Third: Check inode
    // Inode unallocated
    if (current_dinodepointer->type == 0) 
    {
      continue;
    }
    
    // Inode invalid types
    if (current_dinodepointer->type != T_FILE && current_dinodepointer->type != T_DIR && current_dinodepointer->type != T_DEV) 
    {
      fprintf(stderr, "ERROR: bad inode.\n");
      exit(1);
    }
    
    // Inode in use but not in the directory
    if (inode_ref[i] == 0) 
    {
      fprintf(stderr, "ERROR: inode marked use but not found in a directory.\n");
      exit(1);
    }
    
    // Bad reference count
    if (inode_ref[i] != current_dinodepointer->nlink) 
    {
      fprintf(stderr, "ERROR: bad reference count for file.\n");
      exit(1);
    }
    
    // Extra links on directories
    if (current_dinodepointer->type == T_DIR && current_dinodepointer->nlink > 1) 
    {
      fprintf(stderr, "ERROR: directory appears more than once in file system.\n");
      exit(1);
    }
  }

  // Fourth: check bitmap
  // Not in use but marked in use
  if (bitmap_compare(bitmap, new_bitmap, bitmap_size)) {
    fprintf(stderr, "ERROR: bitmap marks block in use but it is not in use.\n");
    exit(1);
  }
  
  fprintf(stdout, "The file system checking is complete, and no error detected. \n");
  return 0;
}