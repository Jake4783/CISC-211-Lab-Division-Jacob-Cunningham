/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

/* Tell the assembler that what follows is in data memory    */
.data
.align
/* Define the globals so that the C code can access them */
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Jacob Cunningham"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */
 
/* define a section for the lab variables at a fixed location.
 * This ensures the answers won't vary based on SW version or
 * other unrelated changes */
.section lab5data,data,address(0x20000800)

/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
    /*inputs to asm code:
r0:  dividend
r1:  divisor 

r0: store the address of quotient in r0 before returning to the C code.
     
dividend: output; memory location where you will store the value passed in via r0  
divisor:  output; memory location where you will store the value passed in via r1  
quotient: output; memory location used to store the result of dividend / divisor  
                  (integer division); or 0 if there's an error
mod:      output; memory location used to store the result of dividend % divisor  
                  (modulus or remainder); or 0 if there's an error

we_have_a_problem: output; store a 1 if there's an error, otherwise store 0.*/
    
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* Store the inputs */
    ldr r2, =dividend 
    str r0, [r2]
    
    ldr r2, =divisor
    str r1, [r2]
    
    /* Initialize quotient and mod to 0 */
    ldr r2, =quotient
    mov r3, 0
    str r3, [r2]
    
    ldr r2, =mod
    str r3, [r2]
    
    /* check for error */
    cmp r0, 0
    beq error_cases

    cmp r1, 0
    beq error_cases
    
    /* 99 Problems but this ain't one :D */
    ldr r2, =we_have_a_problem
    mov r3, 0
    str r3, [r2]
    
    /* setup registers doing operations */
    mov r4, r0        /* remainder */
    movs r5, 0       /*  quotient */
    
Division:
    cmp r4, r1
    blo Result_processing
    
    subs r4, r4, r1
    adds r5, r5, 1
    b Division
    
Result_processing:
    /* store final results */
    ldr r2, =quotient
    str r5, [r2]

    ldr r2, =mod
    str r4, [r2]

    /* return address of quotient */
    ldr r0, =quotient
    
    /* Branch to done */
    b done

error_cases:
    ldr r2, =we_have_a_problem
    movs r3, #1
    str r3, [r2]

    ldr r2, =quotient
    movs r3, #0
    str r3, [r2]

    ldr r2, =mod
    str r3, [r2]

    ldr r0, =quotient
    
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




