###########################################################################################
#Lab 2
#Quan Nguyen
#Desc: you push button, it counts up or down, yay. Sponsored by ruined weekend
###########################################################################################


#this should really be a default instruction
.macro movi32 reg, addr
  movhi \reg, %hi(\addr)
  ori \reg, \reg, %lo(\addr)
.endm

# Subroutines MUST ONLY USE r2-r3 (return), r4-r7 (arguments), r8-r15 (caller-saved general)
# Main program MUST ONLY USE r16-r23 (callee-saved)


# Address of IO devices
    .equ KEY,      0x11010
    .equ HEX0,     0x11000
    .equ SW,       0x11020

.text


# * r4: value
set_hex0:
    #someone should have told us that movi doesn't add bits automatically
    movi32 r8, HEX0

    # First, get the address of seven_seg_values
    movia r9, seven_seg_values

    # a << 2 = a * 4
    # I'm shifting bits instead cause I watched somewhere that this makes code fast
    slli r4, r4, 2

    # Address of the number constant we need = r9 (starting add) + r4(count)*4
    add r9, r9, r4

    # store value of r9 in r10 then use that so store the value in r8
    ldw r10, 0(r9)
    stwio r10, 0(r8)

    ret

# Get the value of sw0, and store it in r2
# Return value: 0 if sw0 is low, 1 if sw0 is high.
get_sw0:

    #set_hex0 and get_sw0 doesn't run at the same time so reusing r8, r9
    movi32 r8, SW
    ldwio r9, 0(r8)

    #bit masking to get SW0 out of bank of switches into r2
    andi r2, r9, 0b00000001
    ret

# Get the value of key1, and store it in r2
# Return value: 1 if key1 is pressed, 0 if key1 is not pressed.
get_key1:

    #again, reusing r8, r9
    movi32 r8, KEY
    ldwio r9, 0(r8)

    #since the switch is active low, which is annoying, nor will flip the bit
    nor r9, r9, r9
    #bit masking to get key1
    andi r2, r9, 0b00000010
    #right shift to divide by 2, b10 to b01
    srli r2, r2, 1
    ret

    .global main
main: #r16 = counter, r17 = constant 9

    #resetting counter to 0
    xor r16, r16, r16

    # r17 = 9
    addi r17, r0, 9

    # Initial value is zero.
    mov r4, r16
    call set_hex0

loop:
    call get_key1
    # go back to loop if button is not pressed
    beq r2, r0, loop

    call get_sw0
    # if sw0 == 0, jump to decrement
    beq r2, r0, decrement

    # else increment
    addi r16, r16, 1
    # fix value in case it's more than 9
    bgt r16, r17, when_more_than_9
    # or wait for key release
    br wait_for_key_release

decrement:
    subi r16, r16, 1
    # fix value if it's less than 0
    blt r16, r0, when_less_than_0
    br wait_for_key_release

when_more_than_9:
    # reset r16 to 0
    mov r16, r0
    br wait_for_key_release

when_less_than_0:
    # reset r16 to 9
    addi r16, r0, 9
    br wait_for_key_release

# loops until key1 is released
wait_for_key_release:
    call get_key1
    # key1 == 0 => released, go to set new value in r4 and HEX0
    beq r2, r0, set_new_value
    br wait_for_key_release

set_new_value:
    # make value in r16 the count in r4
    mov r4, r16
    call set_hex0
    br loop

    .data
    # Array of values that should be given to HEX0 so it'd display values from 0..9
seven_seg_values:
.word       0b1000000, 0b1111001, 0b0100100, 0b0110000      # 0 to 3
.word       0b0011001, 0b0010010, 0b0000010, 0b1111000      # 4 to 7
.word       0b0000000, 0b0010000                            # 8 and 9

    .end
