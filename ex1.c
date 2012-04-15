//
// Simple inline assembly example
//
// For JOS lab 1 exercise 1
//

# include <stdio.h>

int
main (int argc, char **argv)
{
  int x = 1;
  printf("Hello x = %d \n", x);
  

  //
  // Put in-line assembly here to incerment
  // the value of x by 1 using in-line assembly
  //
  asm (
  "inc %%eax;" : "=a" (x) : "a" (x)
  );

  printf("Hello x = %d after increment\n", x);
  
  if(x == 2){
     printf("OK\n");
  }
  else{
     printf("ERROR\n");
  }
}
