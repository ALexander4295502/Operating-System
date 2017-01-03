----Project 3A-------

To use the file fetcher, run:

./file_tester pagea


  NAME            WUSTL Key(ID)
Zheng Yuan        yuanzheng(452091)
Bowen Wang        bowenwang(443953)


About Project
<1> Downloader queue functions
    d_init() : initialize the download queue
    d_fill() : fill the content to the download queue
    d_get()  : to get the content from the download queue
<2> Parser queue functions
    p_init() : initialize the parse queue
    p_add()  : add the content to the parse queue
    p_get()  : get the content from the parse queue
    checkif_link() : check if the content fetched from the file is a link
    parse()  : push new link from the page to the download queue
<3> Other functions
    pthread_initialize()  : initialize the lock
    check_visited()       : check if the link exits in the linked_list(which means that the link has already been visited) 
