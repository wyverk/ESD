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

//set up pointers to peripherals

uint32* TimerPtr    = (uint32*)TIMER_0_BASE;


unsigned char* SW_ptr		= (unsigned char*)SWITCHES_BASE;
uint32*			 PB_ptr		= (uint32*)PBS_BASE;
unsigned char* LED_ptr      = (unsigned char*)LEDS_BASE;
unsigned char* HEX_ptr	   	= (unsigned char*)HEX0_BASE;

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

volatile int count = 0;

void pb_isr(void *context)
/*****************************************************************************/
/* Interrupt Service Routine                                                 */
/*   Determines what caused the interrupt and calls the appropriate          */
/*  subroutine.                                                              */
/*                                                                           */
/*****************************************************************************/
{
	//uint8 KEY1 = (*PB_ptr & 0x02) >> 1;
	*PB_ptr = 0;
	uint8 SW0  = *SW_ptr & 0x01;

	if(SW0 == 1){
		count++;
	}else if(SW0 == 0){
		count--;
	}

	if(count > 9){
		count = 0;
	}else if(count < 0){
		count = 9;
	}


	*HEX_ptr = hex_const[count];

    return;
}


void timer_isr(void *context){
	*TimerPtr = 0;

	//bit_x XOR 1 = !bit_x
	*LED_ptr = *LED_ptr ^ 0xFF;

	return;
}

int main(void)
/*****************************************************************************/
/* Main Program                                                              */
/*   Enables interrupts then loops infinitely                                */
/*****************************************************************************/
{
    /* this enables the NIOS II to accept a TIMER interrupt
     * and indicates the name of the interrupt handler */
	alt_ic_isr_register(PBS_IRQ_INTERRUPT_CONTROLLER_ID,PBS_IRQ,pb_isr,0,0);
	alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ,timer_isr,0,0);

	*LED_ptr = 0x00;
	*HEX_ptr = hex_const[0];

    while(1);

    return 0;
}

