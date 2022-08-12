//volatile struct v1495_control_reg* v1495_creg;
//volatile struct v1495_scaler_reg* v1495_screg;
//volatile struct v1495_vme_reg* v1495_vreg;

struct v1495_control_reg {
  volatile unsigned short scratch;
  volatile unsigned short revision; 
 // volatile unsigned short scaler_en_vme;
  volatile unsigned short scaler_en_spill;
 // volatile unsigned short scaler_res;
 // volatile unsigned short scal_control;
  volatile unsigned short d_idcode;
  volatile unsigned short e_idcode;
  //  volatile uint32_t amask;
  // volatile uint32_t bmask;
  // volatile uint32_t dmask;
  // volatile uint32_t emask;

  volatile unsigned short amask_h;
  volatile unsigned short amask_l;
  volatile unsigned short bmask_h;
  volatile unsigned short bmask_l;
  volatile unsigned short dmask_h;
  volatile unsigned short dmask_l;
  volatile unsigned short emask_h;
  volatile unsigned short emask_l;
  volatile unsigned short int_ctrl;
  volatile unsigned short int_count;

};

struct v1495_scaler_reg {
  volatile unsigned short ascal[64];
  volatile unsigned short bscal[64];
  volatile unsigned short dscal[64];
  volatile unsigned short escal[64];
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

#define v1495_VME_INT_LEVEL 5
