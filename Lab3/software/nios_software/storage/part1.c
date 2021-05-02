/* This is a C program written for the timer interrupt demo.  The
 program assumes a nios_system with a periodic interrupt timer
 and an 8-bit output PIO named leds. */


/* alt_types.h and sys/alt_irq.h need to be included for the interrupt
  functions
  system.h is necessary for the system constants
  io.h has read and write functions */
#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values


uint32* SW_ptr		= (uint32*)SWITCHES_BASE;
uint32* PB_ptr		= (uint32*)PBS_BASE;
uint32* LED_ptr      = (uint32*)LEDS_BASE;
uint32* HEX_ptr	   	= (uint32*)HEX0_BASE;

const char hex_const[10] =
	{ 0x40, //0
	  0x79, //1
	  0x24, //2
	  0x30, //3
	  0x19, //4
	  0x12, //5
	  0x02, //6
	  0x78, //7
	  0x00, //8
	  0x10  //9
	};

int main(void)
/*****************************************************************************/
/* Main Program                                                              */
/*   Enables interrupts then loops infinitely                                */
/*****************************************************************************/
{
	*LED_ptr = 0x00;
	*HEX_ptr = hex_const[0];

	int count = 0;

    while(1){
    	uint8 KEY1 = (*PB_ptr & 0x02) >> 1;
    	uint8 SW0  = *SW_ptr & 0x01;

    	if(KEY1 == 0){ //enters when KEY1 is pressed
    		if(SW0 == 1){ //increments
    			count++;
    		}else if(SW0 == 0){ //decrements
    			count--;
    		}

    		if(count > 9){ //rollover handling
    			count = 0;
    		}else if(count < 0){
    			count = 9;
    		}

    		//poll for KEY1 in loop until it is released(reads a 1)
    		while(KEY1 == 0){
    			KEY1 = (*PB_ptr & 0x02) >> 1;
    		}

    		//update display
    		*HEX_ptr = hex_const[count];
    	}
    }

    return 0;
}

