#include "vxWorks.h"
#include "stdio.h"
#include "string.h"
#include "logLib.h"
#include "taskLib.h"
#include "intLib.h"
#include "iv.h"
#include "semLib.h"
#include "vxLib.h"
#include "unistd.h"
#include "math.h"

#include "time.h"		/*for the purpose to using nanosleep */
#include "stdlib.h"		/*random */

/* Include definitions */
#include "v1495-USR.h"

/* Define external Functions */
IMPORT STATUS sysBusToLocalAdrs(int, char *, char **);
IMPORT STATUS intDisconnect(int);
IMPORT STATUS sysIntEnable (int);
IMPORT STATUS sysIntDisable (int);

/* Define global variables */
volatile struct v1495_vme_reg* v1495_vreg[v1495_MAX_BOARDS];	
volatile struct v1495_usr_reg* v1495_ureg[v1495_MAX_BOARDS];	


STATUS v1495Init(UINT32 addr, UINT32 addr_inc, int nmod)
{
  int ii, res_v, res_u, rdata, errFlag = 0;
  int nV1495 = 0;
  unsigned int addr_v, laddr_v;
  unsigned int addr_u, laddr_u;

  addr_v = addr + 0x8000;
  addr_u = addr + 0x1000;


  /* Check for valid address */
  if(addr == 0)
  {
    printf("v1495Init: ERROR: Must specify a Bus (VME-based A24/32) address for the v1495\n");
    return(ERROR);
  }
  else if(addr > 0xffffffff)
  {				
    /* more then A32 Addressing */
    printf("v1495Init: ERROR: Addressing not supported for this v1495\n");
    return(ERROR);
  }
  else if((nmod > 0) && (addr_inc == 0))
  {
    printf("v1495Init: ERROR: cannot initialize multiple boards at the same address\n");
    return(ERROR);
  }
  else if(nmod == 0)
  {
    printf("v1495Init: ERROR: cannot initialize ZERO boards\n");
    return(ERROR);
  }
  
  // Map the first board
  res_v = sysBusToLocalAdrs(0x39, (char*)addr_v, (char**)&laddr_v);
  if(res_v != 0)
  {
    printf("v1495Init: ERROR in sysBusToLocalAdrs(0x39, 0x%x, &laddr_v) return %d\n", addr_v, res_v);
    return(ERROR);
  }
  
  res_u = sysBusToLocalAdrs(0x39, (char*)addr_u, (char**)&laddr_u);
  if(res_u != 0)
  {
    printf("v1495Init: ERROR in sysBusToLocalAdrs(0x39, 0x%x, &laddr_u) return %d\n", addr_u, res_u);
    return(ERROR);
  }

  //Associate the rest of the addresses
  for(ii = 0; ii < nmod; ii++)
  {
    errFlag = 0;
    
    v1495_vreg[ii] = (struct v1495_vme_reg*)(laddr_v + ii*addr_inc);
    res_v = vxMemProbe((char*)&(v1495_vreg[ii]->firmware), VX_READ, 2, (char*)&rdata);
    if(res_v < 0)
    {
      printf("v1495: ERROR: No addressable board at addr=0x%x\n", (UINT32)v1495_vreg[ii]);
      v1495_vreg[ii] = NULL;
      errFlag = 1;
    }
    
    
    v1495_ureg[ii] = (struct v1495_usr_reg*)(laddr_u + ii*addr_inc);
    res_u = vxMemProbe((char*)&(v1495_ureg[ii]->csr), VX_READ, 2, (char*)&rdata);
    if(res_u < 0)
    {
      printf("v1495: ERROR: No addressable board at addr=0x%x\n", (UINT32)v1495_vreg[ii]);
      v1495_vreg[ii] = NULL;
      errFlag = 1;
    }

    if(errFlag == 0)
    {
      nV1495++;
      printf("Initialized v1495 ID %d VME registers at address 0x%08x \n", ii, (UINT32)v1495_vreg[ii]);
      printf("Initialized v1495 ID %d USR registers at address 0x%08x \n", ii, (UINT32)v1495_ureg[ii]);
    }
  }

  if(nV1495 == nmod)
  {
    printf("v1495Init: %d v1495 initialized successfully\n", nV1495);
    return(OK);
  }
  else
  {
    printf("v1495Init: ERROR: unable to initialize all modules\n");
    return(ERROR);
  }
}

void v1495SetControl(int id, short val)
{
  v1495_ureg[id]->ctrl = val;
  return;
}

int v1495GetCSR(int id)
{
  int tmp = v1495_ureg[id]->csr;
  return(tmp);
}

int v1495GetRevision(int id)
{
  int tmp = v1495_ureg[id]->rev;
  return(tmp);
}

int v1495GetControl(int id)
{
  int tmp = v1495_ureg[id]->ctrl;
  return(tmp);
}

void v1495ReadUsrAll(int id)
{
  int tmp; 

  printf(" ------------------------------ V1495 board %d ------------------------------\n", id);
  tmp = v1495_ureg[id]->csr;
  printf("  CSR: 0x%04x\n", tmp);

  tmp = v1495_ureg[id]->rev;
  printf("  REV: 0x%04x\n", tmp);

  tmp = v1495_ureg[id]->ctrl;
  printf("  CTRL: 0x%04x\n", tmp);
  
  return;
}

void dummydelay(int delay)
{
  int i = 0;
  int sum = 0;
  
  for(i = 0; i < delay; i++)
  {
    sum = sum + 1;
  }
  
  return;
}  


