//						Lab 5 I think
// Quan Nguyen




#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"


// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

//set up pointers to peripherals

volatile uint32* controller_ptr	= (uint32*)SERVO_CONTROLLER_0_BASE;

volatile uint32* SW_ptr		= (uint32*)SWITCHES_BASE;
volatile uint32* KEYS_ptr	= (uint32*)KEYS_BASE;

volatile uint32* HEX_ptr[6] = {(uint32*)HEX0_BASE,
							   (uint32*)HEX1_BASE,
							   (uint32*)HEX2_BASE,
							   (uint32*)HEX3_BASE,
							   (uint32*)HEX4_BASE,
							   (uint32*)HEX5_BASE
							   };

//volatile uint32* HEX0_ptr	= (uint32*)HEX0_BASE;
//volatile uint32* HEX1_ptr	= (uint32*)HEX1_BASE;
//volatile uint32* HEX2_ptr	= (uint32*)HEX2_BASE;
//volatile uint32* HEX3_ptr	= (uint32*)HEX3_BASE;
//volatile uint32* HEX4_ptr	= (uint32*)HEX4_BASE;
//volatile uint32* HEX5_ptr	= (uint32*)HEX5_BASE;

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

volatile int minAngle = 45;
volatile int maxAngle = 135;

int convertAngle(int angle){
	int count = (angle -45)*(50000.0/90.0) + 49999;

	return count;
}

void getDigits(int number, int digits[3]){
	digits[2] = number/100;
	digits[1] = (number%100)/10;
	digits[0] = number%10;
}

void keys_isr(void *context)
/*****************************************************************************/
/* Interrupt Service Routine                                                 */
/*   Determines what caused the interrupt and calls the appropriate          */
/*  subroutine.                                                              */
/*                                                                           */
/*****************************************************************************/
{
	int edge = *(KEYS_ptr + 3);

	if(*SW_ptr >= 45 && *SW_ptr <= 135){
		if(edge & 0x5){
			maxAngle = *(SW_ptr);
		}else if(edge & 0x8){
			minAngle = *(SW_ptr);
		}
	}

	if(minAngle > maxAngle){
		int temp = minAngle;
		minAngle = maxAngle;
		maxAngle = temp;
	}

	*(controller_ptr) = convertAngle(minAngle);
	*(controller_ptr + 1) = convertAngle(maxAngle);

	//clears the edge bits
	*(KEYS_ptr + 3) = 0;

    return;
}

int main(void)
/*****************************************************************************/
/* Main Program                                                              */
/*   Enables interrupts then loops infinitely                                */
/*****************************************************************************/
{
	int minDigits[3];
	int maxDigits[3];

    //turns on interrupt mask bits for all 4 buttons
	*(KEYS_ptr + 2) = 0xF;

	*(controller_ptr) = convertAngle(minAngle);
	*(controller_ptr + 1) = convertAngle(maxAngle);

	//enable PIO interrupts in software
	alt_ic_isr_register(KEYS_IRQ_INTERRUPT_CONTROLLER_ID,KEYS_IRQ,keys_isr,0,0);

    while(1){
    	getDigits(minAngle, minDigits);
    	getDigits(maxAngle, maxDigits);

    	for(int i = 0; i < 3; ++i){
    		*(HEX_ptr[i + 3]) = hex_const[minDigits[i]];
    	}

    	for(int i = 0; i < 3; ++i){
    		*(HEX_ptr[i]) = hex_const[maxDigits[i]];
    	}
    }
    return 0;
}

