#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>
#include <pthread.h>

#include <time.h>

//Global definitions for the Linked List of visted urls
typedef struct LinkNode_t{
	char *link;
	struct LinkNode_t *next;
}LinkNode;

LinkNode *LinkedList_head;

typedef struct Node_t{
	struct Node_t *next;
	char *parent_link;
	char *data;
}Node;

typedef struct Parse_queue_t{
	Node *head;
	Node *tail;
	int parseItems;
}Queue;

pthread_mutex_t p_lock;
pthread_mutex_t d_lock;
pthread_mutex_t w_lock;
pthread_mutex_t l_lock;  //used for check_visited()
pthread_cond_t dfull = PTHREAD_COND_INITIALIZER;
pthread_cond_t dempty = PTHREAD_COND_INITIALIZER;
pthread_cond_t pempty = PTHREAD_COND_INITIALIZER;
pthread_cond_t done = PTHREAD_COND_INITIALIZER;

char **buff_download;
int dfillptr = 0; 
int duserptr = 0;
int dq_size;  //the size of the download queue
int downldItems = 0; // the # of elements in download queue
int work = 0; //used to find if all the download_threads and parse_threads have finished in pair

Queue *buff_parse;

//global fetch function
char *(*_fetch_function)(char *);
//global edge function
void (*_edge_function)(char *, char *);


/*************************
*                        *
*  pthread_initialize()  *
*                        *
*************************/
void pthread_initialize(){
	pthread_mutex_init(&p_lock, NULL);
	pthread_mutex_init(&d_lock, NULL);
	pthread_mutex_init(&w_lock, NULL);
	pthread_mutex_init(&l_lock, NULL);
}

/*************************
*                        *
*     check_visited()    *
*                        *
*************************/
//returns 1 if link already exists in linked_list, 0 if link does not yet exist
//if does not exist, add to end 
int check_visited(char *link){
	pthread_mutex_lock(&l_lock);
	LinkNode *new_node = malloc(sizeof(LinkNode*));
	LinkNode *test_node = LinkedList_head;
	LinkNode *prev_node = NULL;
	char *tmp_link;
	while(test_node != NULL){
		tmp_link = test_node->link;
		if(tmp_link != NULL){
			if(strcmp(tmp_link, link) == 0){
				//matching link name
				free(new_node);
				pthread_mutex_unlock(&l_lock);
				return 1;
			}
		}
		prev_node = test_node;
		test_node = test_node->next;
	}
	//not find any matching link, add to last
	new_node->next = NULL;
	new_node->link = link;
	if(prev_node == NULL)
		//this linkedlist is empty
		LinkedList_head = new_node;
	else
		prev_node->next = new_node;
	pthread_mutex_unlock(&l_lock);
	return 0;
}

/*----------------------------------- Downloader queue functions --------------------------------*/

/*************************
*                        *
*         d_init()       *
*                        *
*************************/
//download queue init

void d_init(){
	if((buff_download = malloc(sizeof(char*)*dq_size)) == NULL){
		fprintf(stderr, "CANNOT ALLOCATE DOWNLOAD BUFFER");
	}
}

/*************************
*                        *
*         d_fill()       *
*                        *
*************************/
//download queue fill
void d_fill(char *content){
	buff_download[dfillptr] = content;
	dfillptr = (dfillptr + 1) % dq_size;
	downldItems++;
	pthread_mutex_lock(&w_lock);
	work++;
	pthread_mutex_unlock(&w_lock);
}

/*************************
*                        *
*         d_get()        *
*                        *
*************************/
//download queue get
char *d_get(){
	char *tmp = buff_download[duserptr];
	duserptr = (duserptr + 1) % dq_size; 
	downldItems--;
	return tmp;
}

/*----------------------------------- Parser queue functions --------------------------------*/

/*************************
*                        *
*         p_init()       *
*                        *
*************************/
//parse queue init
void p_init(){
	if((buff_parse = malloc(sizeof(Queue))) == NULL){
		fprintf(stderr, "ERROR ALLOCATING PARSE-BUFFER");
		exit(-1);
	}
	buff_parse->head = NULL;
	buff_parse->tail = NULL;
	buff_parse->parseItems = 0;
}

/*************************
*                        *
*         p_add()        *
*                        *
*************************/
//parse queue add
void p_add(char *prev_link, char *content){
	Node *tmp;
	if((tmp = malloc(sizeof(Node))) == NULL){
		fprintf(stderr, "ERROR ALLOCATING PARSE NODE");
		exit(-1);
	}
	tmp->next = NULL;
	tmp->data = content;
	tmp->parent_link = prev_link;

	//if queue is currently empty
	if(buff_parse->head == NULL){
		buff_parse->head = tmp;
		buff_parse->tail = tmp;
	}
	else{
		(buff_parse->tail)->next = tmp;
		buff_parse->tail = tmp;
	}
	buff_parse->parseItems++;

	pthread_mutex_lock(&w_lock);
	work++;
	pthread_mutex_unlock(&w_lock);
}

/*************************
*                        *
*         p_get()        *
*                        *
*************************/
//parse queue get
Node *p_get(){
	Node *tmp = buff_parse->head;
	buff_parse->head = tmp->next;
	buff_parse->parseItems--;
	return tmp;
}

/********************************
*                               *
*         checkif_link()        *
*                               *
********************************/
// returns 1 if it is a link, 0 if not
char *checkif_link(char *word){
	char *extra = NULL;
	if(word == NULL)
		return NULL;
	char *word_cpy = strdup(word);
	char *tmp = strtok_r(word_cpy, ":", &extra);
	if(tmp == NULL)
		return NULL;
	if(strcmp(tmp,"link") == 0){
		tmp = strtok_r(NULL, " \n",&extra);
		return tmp;
	}
	return NULL;
}

/*************************
*                        *
*         parse()        *
*                        *
*************************/
void parse(char* prev_link, char* page){
	char *tmp, *link;
	char *saveptr = NULL;
	tmp = strtok_r(page, " \n",&saveptr);
	while(tmp != NULL){
		if((link = checkif_link(tmp)) != NULL){
			pthread_mutex_lock(&d_lock);
			while(downldItems == dq_size)
			    //the download queue has been full, need download to pop the queue
				pthread_cond_wait(&dfull, &d_lock);
			if(!check_visited(link)){
				d_fill(link);
				pthread_cond_signal(&dempty);
			}
			pthread_mutex_unlock(&d_lock);
			_edge_function(prev_link, link);
		}
		tmp = strtok_r(NULL, " \n", &saveptr);
	}
	pthread_mutex_lock(&w_lock);
	work--;
	pthread_cond_signal(&done);
	pthread_mutex_unlock(&w_lock);
}

/********************************
*                               *
*         parse_thread()        *
*                               *
********************************/
//producer sequence
void *parse_thread(){
	Node *page_content;
	while(1){
		pthread_mutex_lock(&p_lock);
		//if parse queue is empty, wait until downloader gives something
		while(buff_parse->parseItems == 0){
			pthread_cond_wait(&pempty, &p_lock);
		}
		page_content = p_get();
		pthread_mutex_unlock(&p_lock);
		parse(page_content->parent_link, page_content->data);
	}
	return NULL;
}

/***********************************
*                                  *
*         download_thread()        *
*                                  *
***********************************/
//consumer sequence
void *download_thread(){
	while(1){
		pthread_mutex_lock(&d_lock);
		while(downldItems == 0){
			pthread_cond_wait(&dempty, &d_lock);
		}
		//pull link off download queue
		char *link = d_get();
		pthread_cond_signal(&dfull);
		pthread_mutex_unlock(&d_lock);
		char *page = _fetch_function(link);
		//add content to parse queue
		pthread_mutex_lock(&p_lock);
		p_add(link,page);
		pthread_mutex_lock(&w_lock);
		work--;
		pthread_cond_signal(&done);
		pthread_mutex_unlock(&w_lock);
		pthread_cond_signal(&pempty);
		pthread_mutex_unlock(&p_lock);
	}
	return NULL;
}

/*----------------------------------- Main functions --------------------------------*/
/*************************
*                        *
*         crawl()        *
*                        *
*************************/
int crawl(char *start_url,
	  int download_workers,
	  int parse_workers,
	  int queue_size,
	  char * (*_fetch_fn)(char *url),
	  void (*_edge_fn)(char *from, char *to)) {

	pthread_initialize();
	dq_size = queue_size;
	_fetch_function = _fetch_fn;
	_edge_function = _edge_fn;
	p_init();
	d_init();
	d_fill(start_url);
	check_visited(start_url);
	//create producer and consumer pthread
	pthread_t pid[download_workers],cid[parse_workers];
	int i;
	for(i = 0; i < download_workers; i++){
		pthread_create(&pid[i],NULL,download_thread,NULL);
	}
	for(i = 0; i < download_workers; i++){
		pthread_create(&cid[i],NULL,parse_thread,NULL);
	}
	pthread_mutex_lock(&w_lock);
	while(work > 0){
		pthread_cond_wait(&done, &w_lock);
	}
	pthread_mutex_unlock(&w_lock);
	return 0;
  return -1;
}

