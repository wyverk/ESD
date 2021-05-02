/*
 * part4.c
 *
 *  Created on: Mar 24, 2021
 *      Author: hoang
 */




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
volatile uint32* KEY_ptr = (uint32*)KEY_BASE;
volatile uint32* LED_ptr = (uint32*)LEDS_BASE;
uint32* INFR_RAM_ptr = (uint32*)RAM_COMPONENT_BE_0_BASE;

void Ram_test_8bit(uint8* start, int num_write, uint8 data){
	for(uint8* i = start; i < start + num_write; i++){
		*i = data;
	}

	int not_match = 0;

	for(uint8* i = start; i < start + num_write; i++){
		if(*i != data){
			not_match = 1;

			printf("ERROR: Address: 0x0000_%04X Read: 0x0000_%04X Expected: 0x0000_%04X \n", (unsigned int) i, *i, data);
		}
	}

	if(not_match){
		*LED_ptr = 0xFF;
	}
}


void Ram_test_16bit(uint16* start, int num_write, uint16 data){
	if(num_write % 2 != 0){
		num_write += 2 - (num_write % 2);
	}

	for(uint16* i = start; i < start + num_write/2; i++){
		*i = data;
	}

	int not_match = 0;

	for(uint16* i = start; i < start + num_write/2; i++){
		if(*i != data){
			not_match = 1;

			printf("ERROR: Address: 0x0000_%04X Read: 0x0000_%04X Expected: 0x0000_%04X \n", (unsigned int) i, *i, data);
		}
	}

	if(not_match){
		*LED_ptr = 0xFF;
	}
}

void Print_32bit(uint32* addr, uint32 data){
	unsigned int addr_hw_high = ((unsigned int) addr >> 16) & 0x0000FFFF;
	unsigned int addr_hw_low  = ((unsigned int) addr)  & 0x0000FFFF;

	unsigned int ram_hw_high = (*addr >> 16) & 0x0000FFFF;
	unsigned int ram_hw_low  = *addr & 0x0000FFFF;

	unsigned int data_hw_high = (data >> 16) & 0x0000FFFF;
	unsigned int data_hw_low  = data & 0x0000FFFF;

	printf("ERROR: Address: 0x%04X_%04X Read: 0x%04X_%04X Expected: 0x%04X_%04X \n", addr_hw_high, addr_hw_low, ram_hw_high, ram_hw_low, data_hw_high, data_hw_low);
}

void Ram_test_32bit(uint32* start, int num_write, uint32 data){
	if(num_write % 4 != 0){
		num_write += 4 - (num_write % 4);
	}

	for(uint32* i = start; i < start + num_write/4; i++){
		*i = data;
	}


	int not_match = 0;

	for(uint32* i = start; i < start + num_write/4; i++){
		if(*i != data){
			not_match = 1;

			Print_32bit(i, data);
		}
	}

	if(not_match){
		*LED_ptr = 0xFF;
	}
}


int main(void)
/*****************************************************************************/
/* Main Program                                                              */
/*                                                                           */
/*****************************************************************************/
{
	int run = 1;
	int mem_size = 4096*4;

	*LED_ptr = 0x00;
	Ram_test_32bit(INFR_RAM_ptr, 4096*4, 0x00000000);

	while(run){
		Ram_test_8bit((uint8*) INFR_RAM_ptr, mem_size, 0x00);
		Ram_test_16bit((uint16*) INFR_RAM_ptr, mem_size, 0x1234);
		Ram_test_32bit(INFR_RAM_ptr, mem_size, 0xABCDEF90);
		Ram_test_32bit(INFR_RAM_ptr, mem_size, 0x12345678);

		run = *KEY_ptr;
	}

	*LED_ptr = 0xAA;
	printf("RAM TEST DONE \n");

    return 0;
}





