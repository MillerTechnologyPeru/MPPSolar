//
//  CRC.c
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

#include <mppsolar.h>

// http://forums.aeva.asn.au/viewtopic.php?title=pip4048ms-inverter&p=53760&t=4332#p53760
uint16_t mppsolar_crc(const uint8_t *bytes, uint8_t len)
{
     uint16_t crc;
     uint8_t da;
     const uint8_t *ptr;
     uint8_t bCRCHign;
     uint8_t bCRCLow;
     uint16_t crc_ta[16]=
     {
          0x0000,0x1021,0x2042,0x3063,0x4084,0x50a5,0x60c6,0x70e7,
          0x8108,0x9129,0xa14a,0xb16b,0xc18c,0xd1ad,0xe1ce,0xf1ef
     };
     ptr=bytes;
     crc=0;
     while(len--!=0)
     {
          da=((uint8_t)(crc>>8))>>4;
          crc<<=4;
          crc^=crc_ta[da^(*ptr>>4)];
          da=((uint8_t)(crc>>8))>>4;
          crc<<=4;
          crc^=crc_ta[da^(*ptr&0x0f)];
          ptr++;
     }
     bCRCLow = crc;
    bCRCHign= (uint8_t)(crc>>8);
     if(bCRCLow==0x28||bCRCLow==0x0d||bCRCLow==0x0a)
    {
         bCRCLow++;
    }
    if(bCRCHign==0x28||bCRCHign==0x0d||bCRCHign==0x0a)
    {
          bCRCHign++;
    }
    crc = ((uint16_t)bCRCHign)<<8;
    crc += bCRCLow;
     return(crc);
}
