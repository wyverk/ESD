//						PAIN AND REGRET
// Quan Nguyen ft friend who was the one that figured this out
// Lab 3 I guess




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

volatile uint32* TimerPtr    = (uint32*)TIMER_0_BASE;


volatile uint32* SW_ptr		= (uint32*)SWITCHES_BASE;
volatile uint32* PB_ptr		= (uint32*)PBS_BASE;
volatile uint32* LED_ptr    = (uint32*)LEDS_BASE;
volatile uint32* HEX_ptr	= (uint32*)HEX0_BASE;

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
	//clears the edge bits
	*(PB_ptr + 3) = 0;

	//reads value of all switches then bit mask to get SW0
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

	//updates HEX0
	*HEX_ptr = hex_const[count];

    return;
}


void timer_isr(void *context){
	*TimerPtr = 0;

	//XOR with 1 to invert
	*LED_ptr = *LED_ptr ^ 0xFF;

	return;
}

int main(void)
/*****************************************************************************/
/* Main Program                                                              */
/*   Enables interrupts then loops infinitely                                */
/*****************************************************************************/
{
    //turns on interrupt mask bits for all 4 buttons
	*(PB_ptr + 2) = 0xF;

	//enable PIO interrupts in software
	alt_ic_isr_register(PBS_IRQ_INTERRUPT_CONTROLLER_ID,PBS_IRQ,pb_isr,0,0);

	//enable timer interrupt
	alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ,timer_isr,0,0);

	*LED_ptr = 0x00;		//resets LEDs
	*HEX_ptr = hex_const[0];	//display 0 on hex0

    while(1);
    return 0;
}

