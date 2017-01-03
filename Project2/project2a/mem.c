#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string.h>
#include "mem.h"
#include <time.h>
#include <stdlib.h>

typedef struct __node_t {
    int size;
    void * addr;
} node_t;


/* this structure serves as the header for each block */
/* the blocks are maintained as a linked list */
/* the blocks are ordered in the increasing order of addresses*/
/* size of the block is always a multiple of 8 */
/* LSB = 0 => free block */
/* LSB = 1 => allocated/busy block */
/* for free block, block size = size_status */
/* for an allocated block, block size = size_status -1*/
/* the size of the block stored here is not the real size of the block*/
/* the size stored here = (size of block) - (size of header) */

  typedef struct block_hd{
    struct block_hd* next;
    int size_status;
  }block_header;

  block_header* list_head = NULL;
  static int allocated_once = 0;

/************************
 *                      *
 *       Mem_Init       *
 *                      *
 ************************/

 /* Function used to initialize the memory allocator */
 /* Not intended to be called more than once by a program */
 /* Argument - sizeOfRegion: Specifies the size of the chunk which needs to be allocated */
 /* Returns 0 on success and -1 on failure */

  int Mem_Init(int sizeOfRegion)
  { 
    int pagesize;
    int padsize;
    int fd;
    int alloc_size;
    void* space_ptr;
    
    if( allocated_once!= 0)
    {
      fprintf(stderr,"Error:mem.c: Mem_Init has allocated space during a previous call (Mem_Init())\n");
      return -1;
    }

    if(sizeOfRegion <= 0)
    {
      fprintf(stderr,"Error:mem.c: Requested block size is not positive (Mem_Init())\n");
      return -1;
    }

    pagesize = getpagesize();

    padsize = sizeOfRegion % pagesize;
    padsize = (pagesize - padsize) % pagesize;

    alloc_size = sizeOfRegion + padsize;
    /* Or: alloc_size = ((sizeIfRegion-1)/pagesize+1)*pagesize;*/

    /* Using mmap to allocate memory*/
    fd = open("/dev/zero",O_RDWR);
    if(fd == -1)
    { 
      fprintf(stderr,"Error:mem.c: Cannot open /dev/zero (Mem_Init())\n");
      return -1;
    }

    space_ptr = mmap(NULL,alloc_size,PROT_READ | PROT_WRITE, MAP_PRIVATE , fd, 0);
    
    close(fd);
    
    if(space_ptr == MAP_FAILED)
    {
      m_err = ERR_BAD_ARGS;
      fprintf(stderr,"Error:mem.c: mmap cannot allocate space (Mem_Init())\n");
      allocated_once = 0;
      m_err = ERR_BAD_ARGS;
      return -1;
    }

    allocated_once = 0x01;
    printf("the initialization is complete!!!!!!!\n");    

 
    /* At start, there is only one big, free block */
    list_head = (block_header*)space_ptr;
    list_head->next = NULL;
    
    /* Remember that the 'size' stored in block size excludes the space for the header */
    list_head->size_status = alloc_size - (int)sizeof(block_header);

    return 0;

  }
 

  /**********************
  *                     *
  *     Mem_Alloc       *
  *                     *
  **********************/   

  /* Function for allocating 'size' bytes. */
  /* Return address of allocated block on success */
  /* Return NULL on failure */
  /* Here is what this function should accomplish */
  /* - Check for sanity of size - Return NULL when appropriate */
  /* - Round up size to a multiple of 8 */
  /*   To figure out whether return 8-byte aligned pointers, using */
  /*   printf("%p",ptr), the last digit should be a multiple of 8(i.e. 0 or 8)  */
  /* - Traverse the list of blocks and allocate the first free block which can accomodate the requested size */
  /* Tips: Be careful with pointer arithmetic */


  void* Mem_Alloc(int size)
  {
  // printf("allocated_once = %d\n",allocated_once);
   
    if(size < 1)
    {
      fprintf(stderr,"Error:mem.c: Requested allocation size is less than 1 (Mem_Alloc())\n");
      return NULL;	
    }

    /* Check if Mem_Init has not been called yet  */
    if(allocated_once != 1)
    {
      //printf("allocated_once = %d \n",allocated_once);
      fprintf(stderr,"Error:mem.c: The Mem_Init has not been called yet (Mem_Alloc())\n");
      m_err = ERR_MEM_UNINITIALIZED;
      return NULL;
    }

    /* To make sure that the Mem_Alloc() returns 8-byte aligned chunks of memory */
    size = ((size-1)/8+1)*8;

    if(list_head != NULL)
    {
      block_header* head_node = list_head;

      while(head_node != NULL)
      { 
        /* get current header size */
        int node_size = head_node->size_status;

        /* there is space to add */
        if(node_size %2 ==0 && (size+sizeof(block_header))<node_size)
        {
          block_header* temp_node = NULL;
          /* tips: since incrementing pointers doesn't go by bytes, the addresses are
                   calculated according to the type the pointer points to. So if we 
                   want to advance the pointer 'temp_node' with 'size+sizeof()block_header' bytes,
                   we should cast out pointers to char* before doing the pointer arithmetic(char
                   is one byte). */
          char *raw_tmp_node = ((char*)head_node) + sizeof(block_header) + size;
          temp_node = (block_header*) raw_tmp_node;
          temp_node->next  =head_node->next;
          temp_node->size_status = (head_node->size_status - sizeof(block_header) - size);
          /* To make sure that head_node->size_status%2 == 1, which means this block is busy now */
          head_node->size_status = size + 1;
          head_node->next = temp_node;
          //printf("the malloc mem head is %p\n",head_node);
          //printf("the size of head_node is %d\n",sizeof(block_header)); 
          return (block_header*)((char*)head_node + sizeof(block_header));
        }else
        {
          head_node = head_node->next;
        }
      }
      /*there is no enough contiguous free space within size allocated by Mem_Init to satisfy this request */
      m_err = ERR_OUT_OF_SPACE;
      fprintf(stderr, "Error:mem.c: There is no enough contiguous free space with the size allocated by Mem_Init to satisfy this request (Mem_Alloc())\n");
      return NULL;
    }

  return NULL;

  }    





  

  /**********************
  *                     *
  *     Mem_Free        *
  *                     *
  **********************/

  /* Function for freeing up a previously allocated block */
  /* Argument - ptr: Address of the block to be freed up  */
  /*            if the ptr is NULL, there is no operation */
  /* Returns 0 on success */
  /* Returns -1 on failure */
  /* On failure, set m_err to ERR_INVALID_PTR */
  /* Returns -1 if ptr is NULL */
  /* Returns -1 if ptr is not pointing to the first byte of a busy block */
  /* Mark the block as free */
  /* coalesce if one or both of the immediate neighbours are free */

  int Mem_Free(void *ptr)
  {
    if(ptr == NULL)
    {
      fprintf(stderr, "Error:mem.c: The ptr of the allocated block is NULL (Mem_Free())\n" );
      return -1;
    }

    if(list_head != NULL)
    {
      block_header* head_node = list_head;
      block_header* prev_node = NULL;
      /* points to where beginning of block should be */
      block_header* char_temp_ptr = ptr - sizeof(block_header);
      block_header* temp_ptr = (block_header*)char_temp_ptr;
	    /* what if the temp_ptr not point to the beginning of block? */
      //printf("the head_node is %p \n",head_node);
      //printf("the temp_ptr is %p \n",temp_ptr);

      while(head_node != NULL)
      {
        //printf("head_node != NULL\n");
        if(head_node == temp_ptr)
        {
          //printf("head_node == temp_ptr\n");
          /* check if the block is busy */
          if(head_node->size_status%2 == 1)
          {
            /* if this block is busy, set free*/
            head_node->size_status = head_node->size_status - 1;
            /* coalesce to right */
            if(head_node->next != NULL)
            {
              /* block not busy */
              if(head_node->next->size_status%2 == 0)
              {
                head_node->size_status = head_node->size_status + head_node->next->size_status + sizeof(block_header);
                head_node->next = head_node->next->next;
              }/* if the neighbor block is busy, do nothing for coalescing */

            }/* end coalesce to right */

            /* coalesce to left */
            if(prev_node != NULL)
            {
              /* block not busy */
              if(prev_node->size_status%2 == 0)
              {
                prev_node->size_status = prev_node->size_status + head_node->size_status + sizeof(block_header);
                prev_node->next = head_node->next;
              }/* if the left block busy, or there is no left block, do nothing */

            }/* end coalesce to left */

            return 0; /* successfully freed block */ 
          }/* end check if the block is busy */
          fprintf(stderr,"Error:mem.c: The block pointed has been already freed (Mem_Free())\n");
          return -1;
          /* get the ptr, but find the ptr has been already freed */
        }/* end if(head_node == temp_ptr) so the head_node is not the ptr wo want to free ==> keep searching */

        prev_node = head_node;
        head_node = head_node->next;
        //printf("the next head_node is %p\n",head_node);
        //printf("the head-temp is %d\n",(int)(head_node-temp_ptr));
      }/* end while loop, seaching finished, did not find the ptr*/
        //printf("the invalid ptr is %p\n",head_node); 
        fprintf(stderr, "Error:mem.c: Did not find the ptr in the allocated block (Mem_Free())\n" );
        return -1;
    }/* end if(list_head != NULL), list_head is NULL */
    fprintf(stderr,"Error:mem.c: list_head is NULL (Mem_Free())");
    return -1;

  }


  /**********************
  *                     *
  *     Mem_Dump        *
  *                     *
  **********************/

  /* Function to be used for debug */
  /* Prints out a list of all the blocks along with the following information for each block */
  /* counter : Serial number of the block*/
  /* Status  : free/busy */
  /* Begin   : Address of the first useful byte in the block */
  /* End     : Address of the last byte in the block */
  /* size    : Size of the block (excluding the header) */
  /* t_Size  : Size of the block (including the header) */
  /* t_Begin : Address of the first byte in the block (this is where the header starts) */

  void Mem_Dump()
  {
    int counter; 
    block_header* current = NULL;
    char* t_Begin = NULL;
    char* Begin = NULL;
    int size = 0;
    int t_Size = 0;
    char* End = NULL;
    int free_size = 0;
    int busy_size = 0;
    int total_size = 0;
    char status[5];
    block_header* begin_struct = NULL;

    begin_struct++;
    begin_struct = NULL;

    current = list_head;
    counter = 1;
    fprintf(stdout,"************************************Block list***********************************\n");
    fprintf(stdout,"No.\tStatus\tBegin\t\tEnd\t\tSize\tt_Size\tt_Begin\n");
    fprintf(stdout,"---------------------------------------------------------------------------------\n");

    while(current != NULL)
    {
      t_Begin = (char*)current;
      Begin = t_Begin + sizeof(block_header);
      begin_struct = (block_header*)Begin;
      // What if "Begin = t_Begin + sizeof(block_header);" ??????????????????
      size = current->size_status;
      strcpy(status,"Free");
      if(size%2 == 1) /* LSB = 1 ==> Busy block*/
      {
        strcpy(status,"Busy");
        size = size -1; /* Minus one for ignoring status value in busy block */
        t_Size = size + (int)sizeof(block_header);
        busy_size = busy_size + t_Size;
      }
      else
      {
        t_Size = size + (int)sizeof(block_header);
        free_size = free_size + t_Size;
      } 
      End = Begin + size;
      //fprintf(stdout,"%d\t%s\t0x%08lx\t0x%08lx\t%d\t%d\t0x%08lx\n",counter,status,(unsigned long int)Begin,(unsigned long int)End,size,t_Size,(unsigned long int)t_Begin);
      fprintf(stdout,"%d\t%s\t%p\t0x%08lx\t%d\t%d\t0x%08lx\n",counter,status,(block_header*)Begin,(unsigned long int)End,size,t_Size,(unsigned long int)t_Begin);
      total_size = total_size + t_Size;
      current = current->next;
      counter = counter + 1;
    }
  fprintf(stdout,"---------------------------------------------------------------------------------\n");
  fprintf(stdout,"*********************************************************************************\n");

  fprintf(stdout,"Total busy size = %d\n",busy_size);
  fprintf(stdout,"Total free size = %d\n",free_size);
  fprintf(stdout,"Total size = %d\n",busy_size+free_size);
  fprintf(stdout,"*********************************************************************************\n");
  fflush(stdout);
  return;

  }

