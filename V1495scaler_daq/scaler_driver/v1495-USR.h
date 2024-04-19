struct v1495_usr_reg {
  volatile unsigned short csr;       /* current status, 0x1000 */
  volatile unsigned short rev;       /* firmware version, 0x1000 */

  volatile unsigned short dummy[2046];   /* place holder */

  volatile unsigned short ctrl;   /* control register, 0x2000 */
};

struct v1495_vme_reg {
  volatile unsigned short ctrlr;     /* $$ control register (0x8000)*/
  volatile unsigned short statusr;   /* $$ status register (0x8002)*/
  volatile unsigned short int_lv;    /* $$ interrupt Level (0x8004)*/
  volatile unsigned short int_ID;    /* $$ interrupt Lv ID (0x8006)*/
  volatile unsigned short geo_add;   /* $$ geo address register (0x8008)*/
  volatile unsigned short mreset;    /* module reset (0x800A)*/
  volatile unsigned short firmware;  /* $$ firmware revision (0x800C)*/
  volatile unsigned short svmefpga;  /* $$ select vme fpga (0x800E)*/
  volatile unsigned short vmefpga;   /* $$ vme fpga flash (0x8010)*/
  volatile unsigned short suserfpga; /* $$ select user fpga (0x8012)*/
  volatile unsigned short userfpga;  /* $$ user fpga flash (0x8014)*/
  volatile unsigned short fpgaconf;  /* user fpga configuration (0x8016)*/
  volatile unsigned short scratch16; /* scratch16 (0x8018)*/
  volatile unsigned int   scratch32; /* dcratch32 (0x8020)*/
};

#define v1495_MAX_BOARDS    9
#define v1495_VME_INT_LEVEL 5