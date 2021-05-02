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
uint32* INFR_RAM_ptr = (uint32*)INFERRED_RAM_BASE;

void Ram_test_8bit(uint8* start, int num_write, uint8 data){
	for(uint8 i = 0; i < num_write; i++){
		*(start + i) = data;
	}

	int not_match = 0;
	*LED_ptr = 0x00;

	for(int i = 0; i < num_write; i++){
		if(data != *(start + i)){
			not_match = 1;
		}
	}

	if(not_match){
		*LED_ptr = 0xFF;
	}
}

void Ramp_test_8bit(uint32* start, int num_write, uint8 data){
	for(uint8 i = 0; i < num_write; i++){
		*(start + i) = data + i;
	}

	for(uint8 i = 0; i < num_write; i++){
		if(data + i != *(start + i)){
			*(LED_ptr) = 0xFF;
		}else{
			*(LED_ptr) = 0x00;
		}
	}
}

void Ram_test_16bit(uint16* start, int num_write, uint16 data){
	for(int i = 0; i < num_write/2; i++){
		*(start + i) = data;
	}

	int not_match = 0;
	*LED_ptr = 0x00;

	for(int i = 0; i < num_write/2; i++){
		if(data != *(start + i)){
			not_match = 1;
		}
	}

	if(not_match){
		*LED_ptr = 0xFF;
	}
}

void Ram_test_32bit(uint32* start, int num_write, uint data){
	for(int i = 0; i < num_write/4; i++){
		*(start + i) = data;
	}

	int not_match = 0;
	*LED_ptr = 0x00;

	for(int i = 0; i < num_write/4; i++){
		if(data != *(start + i)){
			not_match = 1;
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
	int num_write = 3;
	Ram_test_32bit(INFR_RAM_ptr, 4095, 0x0);


    //Ram_test_8bit((uint8*) INFR_RAM_ptr, num_write, 1);
    Ram_test_16bit((uint16*) INFR_RAM_ptr, num_write, 0x1234);
    //Ram_test_32bit(INFR_RAM_ptr, num_write, 0x12345678);

    return 0;
}





