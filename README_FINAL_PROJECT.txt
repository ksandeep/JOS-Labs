Steps to set up and tests:

1.	The project directory is handed in under the usual lab 7 “lab” directory and named final_project_highmem

2.	Navigate to this directory, all the further steps will be performed from here

3.	Open kern/pmap.h, make sure that the following line is present and NOT commented out
#define HIGHMEM 0xFF000000
(This controls the high-memory feature, which can be turned off by commenting the line.)

4.	Open kern/init.c and make sure that user_leakpages is the first user environment to be created
// Touch all you want.
          ENV_CREATE(user_leakpages);

5.	Schedule any of the following tests after the above by putting an ENV_CREATE call: 
user/hello.c
user/buggyhello.c
user/evilhello.c
user/yield.c
user/dumbfork.c
user/faultread.c
user/faultdie.c
user/faultalloc.c
user/faultallocbad.c
user/pingpong.c
user/testsimplefork.c


6.	Run make qemu-nox. 
	a.	The first process i.e. user_leakpages will leak out the pages in the low memory and can take 3-5 minutes for 65536 – 131072 pages. Wait for this much amount of time after which the expected output of the test should show up.
	b.	Note the physical address of the last page that was leaked by user_leakpages. This should be sufficiently high depending upon the number of pages that were leaked.
