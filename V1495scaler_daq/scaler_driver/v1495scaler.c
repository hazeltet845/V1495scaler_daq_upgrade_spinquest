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
#include "v1495scaler.h"

/* Define external Functions */
IMPORT STATUS sysBusToLocalAdrs(int, char *, char **);
IMPORT STATUS intDisconnect(int);
IMPORT STATUS sysIntEnable (int);
IMPORT STATUS sysIntDisable (int);

/* Define global variables */
//volatile struct v1495_vme_reg* v1495_vreg;	
//volatile struct v1495_control_reg* v1495_creg;	
//volatile struct v1495_scaler_reg* v1495_screg;
volatile struct v1495_control_reg* v1495_creg;
volatile struct v1495_scaler_reg* v1495_screg;
volatile struct v1495_vme_reg* v1495_vreg;


//finding correct local address for each struct
STATUS v1495Init(UINT32 addr)
{
  int res_v, res_c, res_sc = 0;
  unsigned int addr_v;
  unsigned int addr_c;
  unsigned int addr_sc;

  addr_v = addr + 0x8000;
  addr_c = addr + 0x1000;
  addr_sc = addr + 0x2000;


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
  
  // Map the first board
  res_v = sysBusToLocalAdrs(0x39, (char*)addr_v, (char**)&v1495_vreg);
  if(res_v != 0)
  {
    printf("v1495Init: ERROR in sysBusToLocalAdrs(0x39, 0x%x, &laddr_v) return %d\n", addr_v, res_v);
    return(ERROR);
  }
  
  res_c = sysBusToLocalAdrs(0x39, (char*)addr_c, (char**)&v1495_creg);
  if(res_c != 0)
  {
    printf("v1495Init: ERROR in sysBusToLocalAdrs(0x39, 0x%x, &laddr_c) return %d\n", addr_c, res_c);
    return(ERROR);
  }

  res_sc = sysBusToLocalAdrs(0x39, (char*)addr_sc, (char**)&v1495_screg);
  if(res_sc != 0)
  {
    printf("v1495Init: ERROR in sysBusToLocalAdrs(0x39, 0x%x, &laddr_sc) return %d\n", addr_sc, res_sc);
    return(ERROR);
  }

  
  printf("Initialized v1495 VME registers at address 0x%08x \n", (UINT32)v1495_vreg);
  printf("Initialized v1495 control registers at address 0x%08x \n", (UINT32)v1495_creg);
  printf("Initialized v1495 scaler registers at address 0x%08x \n", (UINT32)v1495_screg);
}

/*
//reset counter values
void v1495reset()
{
  v1495_creg->scaler_res = 0xffff;
  return;
}

void v1495int_control(int mode){
  if(mode == 0){
   v1495_creg->int_ctrl = 0x0000;
  }else {
   v1495_creg->int_ctrl = 0xffff; 
  }

  return;
}

//select scaler mode
void v1495mode(int mode)
{
  if(mode == 0){
    v1495_creg->scal_control = 0x0000;
    printf("BOS/EOS control mode\n");
  }else if(mode == 1){
    v1495_creg->scal_control = 0xffff;
    printf("VME control mode\n");
  }else{
    printf("ERROR: not a valid mode. Arg must be 1 or 0\n");
  }
  return;
}

// write to enable 
void v1495enable()
{
  v1495_creg->scaler_en_vme = 0xffff;
  return;
}

void v1495disable()
{
  v1495_creg->scaler_en_vme = 0x0000;
  return;
}
*/

//read control registers
void v1495ScalerStatus()
{
  printf(" ------------------------------ V1495 Board Control ------------------------------\n");
  printf("0x%04x ",v1495_creg->scratch);
  printf("0x%04x ",v1495_creg->revision); 
  //printf("0x%04x ",v1495_creg->scaler_en_vme);
  printf("0x%04x ",v1495_creg->scaler_en_spill);
  //printf("0x%04x ",v1495_creg->scaler_res);
  //printf("0x%04x ",v1495_creg->scal_control);
  printf("0x%04x ",v1495_creg->d_idcode);
  printf("0x%04x\n",v1495_creg->e_idcode);

  printf("0x%04x",v1495_creg->amask_h);
  printf("%04x ",v1495_creg->amask_l);
  printf("0x%04x",v1495_creg->bmask_h);
  printf("%04x ",v1495_creg->bmask_l);
  printf("0x%04x",v1495_creg->dmask_h);
  printf("%04x ",v1495_creg->dmask_l);
  printf("0x%04x",v1495_creg->emask_h);
  printf("%04x \n",v1495_creg->emask_l);

  printf("0x%04x ", v1495_creg->int_ctrl);
  printf("0x%04x\n", v1495_creg->int_count);

  return;
}

int Loop_determine(){
  if(v1495_creg->scaler_en_spill == 0x0000){
    return 64;
  }else{
    return 16;
  }

}

unsigned short v1495IntCount(){
  return v1495_creg->int_count;
}

unsigned long v1495ScalerCodaRead(int port, int index){
  if(port == 1){
    return v1495_screg->ascal[index + 1] | ((v1495_screg->ascal[index] & 0xffffffff) << 16);
  }else if(port == 2){
    return v1495_screg->bscal[index + 1] | ((v1495_screg->bscal[index] & 0xffffffff) << 16);
  }else if(port == 3){
    return v1495_screg->dscal[index + 1] | ((v1495_screg->dscal[index] & 0xffffffff) << 16);
  }else{
    return v1495_screg->escal[index + 1] | ((v1495_screg->escal[index] & 0xffffffff) << 16);
  }
}

void v1495IntEnable(){
  v1495_vreg->int_lv = v1495_VME_INT_LEVEL;
  return;
}

void v1495IntDisable(){
  v1495_vreg->int_lv = 0;
  return;
}


//for loop to print an array(used for printing scaler data)
void LoopToPrint(volatile unsigned short array[64]){
 int i;
 for (i = 0; i < 64; i+=2)
  {
    if(i % 8 == 0){
      printf("\n");
    }
    printf("0x%04x",array[i]);
    printf("%04x ", array[i+1]);
  }

  printf("\n");

}

//read scaler registers
void v1495ScalerData(int port)
{
  printf(" ------------------------------ V1495 Board Scaler ------------------------------\n");
  if(port == 1) {
    printf("ascal");
    LoopToPrint(v1495_screg->ascal);
  }else if(port == 2){
    printf("bscal");
    LoopToPrint(v1495_screg->bscal);
  }else if(port == 3){
    printf("dscal");
    LoopToPrint(v1495_screg->dscal);
  }else if(port == 4){
    printf("escal");
    LoopToPrint(v1495_screg->escal);
  }else {
    printf("ERROR: Not a valid port. Must enter port A,B,D, or E");
  }
  return;
}








