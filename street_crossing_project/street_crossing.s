// street crossing code hardware

.equ INPUT, 0
.equ OUTPUT, 1

.equ LOW, 0     // light off
.equ HIGH, 1    // light on

.equ RED_PIN, 26        // wiringPi 26; BCM 12; physical pin 32
.equ GRN_PIN, 27        // wiringPi 27; BCM 16; physical pin 36
.equ YLLW_PIN, 28       // wiringPi 28; BCM 20; physical pin 38

.equ RGB_GRN, 25        // wiringPi 25; BCM 26; physical pin 37
.equ RGB_RED, 22        // wiringPi 22; BCM 6; physical pin 31

.equ BTN_PRESS, 29 // wiringPi 29; BCM 21; physical pin 40; button

.section .rodata

cross_msg_no: .asciz " X Do Not Cross! Traffic Light Is Green! X \n"
cross_msg_yes: .asciz " + You Can Cross Now! Traffic Light Is Red! + \n"
end_msg: .asciz "You Safely Crossed The Crosswalk! (Press Button Again To Cross)\n"
press_button: .asciz "Press The Button To Start!\n"
countdown: .asciz "%u...\n"

delay_sec: .word

.global main
.align 4
.text

main:
        push {lr}
        bl wiringPiSetup // initializes the wiringPi library

        ldr r0, =cross_msg_no
        bl printf

        mov r0, #RED_PIN        // turns off all LEDs
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RED_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #GRN_PIN
        mov r1, #OUTPUT

        mov r0, #GRN_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #YLLW_PIN
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #RGB_GRN
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #RGB_RED
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_RED
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1250
        bl delay

        mov r0, #GRN_PIN        // green "traffic" light on and red "don't cross" on
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #GRN_PIN
        mov r1, #HIGH
        bl digitalWrite

        mov r0, #RGB_RED
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_RED
        mov r1, #HIGH
        bl digitalWrite

traffic_and_cross:

        mov r0, #BTN_PRESS
        bl digitalRead
        cmp r0, #HIGH
        beq traffic_light_function      // if r0 == 1 (HIGH), then go to traffic_light_function

        bl traffic_and_cross

traffic_light_function:

        mov r0, #YLLW_CROSS // turn off all LEDs
        mov r1, #LOW
        bl digitalWrite

        mov r0, #RGB_RED
        mov r1, #LOW
        bl digitalWrite

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #RED_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #GRN_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        ldr r0, =cross_msg_yes
        bl printf

        mov r0, #RED_PIN        // turn on RED traffic light and GREEN cross light
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RED_PIN
        mov r1, #HIGH
        bl digitalWrite

        mov r0, #RGB_GRN
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =#10000         // delay for 10 sec
        bl delay

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#500
        bl delay

        mov r0, #RGB_GRN        // start on/off of RED "cross" LED
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

first_countdown:

        ldr r0, =countdown
        mov r1, #6      // countdown from 6
        bl printf

        ldr r0, =#1000 // delay by 1 sec; 1000/1000 = 1
        bl delay

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown
        mov r1, #5
        bl printf       // countdown at 5

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown      // countdown at 4
        mov r1, #4
        bl printf

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown
        mov r1, #3
        bl printf       // countdown at 3

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown
        mov r1, #2
        bl printf       // countdown at 2

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown
        mov r1, #1
        bl printf               // countdown at 1

        ldr r0, =#1000
        bl delay

        mov r0, #RGB_GRN        // turn off "cross" LEDs
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

stop_crossing:

        mov r0, #RGB_RED
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_RED        // turn on RED "do not cross" LED
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =#250
        bl delay

        mov r0, #RED_PIN        // turn off RED "stop traffic" LED
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#250
        bl delay

        mov r0, #GRN_PIN
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #GRN_PIN        // turn on GREEN "traffic" LED
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =cross_msg_no
        bl printf

        ldr r0, =#10000         // keep "traffic" LEDs on for 10 seconds
        bl delay

        mov r0, #GRN_PIN        // turn off GREEN "traffic" LED
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #YLLW_PIN       // make yellow LED flash for "slow down traffic"
        mov r1, #HIGH
        bl digitalWrite

second_countdown:

        ldr r0, =countdown      // start countdown at 6
        mov r1, #6
        bl printf

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown      // countdown at 5
        mov r1, #5
        bl printf

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown      // countdown at 4
        mov r1, #4
        bl printf

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown      // countdown at 3
        mov r1, #3
        bl printf

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown      // countdown at 2
        mov r1, #2
        bl printf

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =countdown      // countdown at 1
        mov r1, #1
        bl printf

        ldr r0, =#1000
        bl delay

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        ldr r0, =#1000
        bl delay

        mov r0, #RED_PIN
        mov r1, #HIGH
        bl digitalWrite

        mov r0, #RGB_GRN
        mov r1, #HIGH
        bl digitalWrite

        ldr r0, =cross_msg_yes   // last cross message
        bl printf

        ldr r0, =#10000
        bl delay

        mov r0, #RED_PIN        // turns off all LEDs
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RED_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #GRN_PIN
        mov r1, #OUTPUT

        mov r0, #GRN_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #YLLW_PIN
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #YLLW_PIN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #RGB_GRN
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_GRN
        mov r1, #LOW
        bl digitalWrite

        mov r0, #RGB_RED
        mov r1, #OUTPUT
        bl pinMode

        mov r0, #RGB_RED
        mov r1, #LOW
        bl digitalWrite

// exit program

        mov r0, #0
        pop {pc}
