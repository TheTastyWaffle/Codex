/* Place l'@ du Gpio dans r0 /
/ void* GetGpioAddress() */
.globl GetGpioAddress
GetGpioAddress:
	gpio .req r0
	ldr gpio,=0x20200000
	mov pc,lr
	.unreq gpio

/* Défini la fonction du Gpio passé en param d'après les 3 derniers bits de r1 /
/ void SetGpioFunction(u32 gpioRegister, u32 function) */
.globl SetGpioFunction
SetGpioFunction:
    pin .req r0
    pinFn .req r1

	cmp pin,#53					/* si pin valide */
	cmpls pinFn,#7
	movhi pc,lr					/* mov pc dans lr si pinFn <= 111 */

	push {lr}					/* push du code lr vers top de stack */
	mov r2,pin
	.unreq pin
	pin .req r2
	bl GetGpioAddress			/* bl déplace lr vers nv instru == branche */
	gpio .req r0

	functionLoop$:
		cmp pin,#9				/* si pin <= 10 */
		subhi pin,#10			/* pin - 10 */
		addhi gpio,#4			/* gpio(Fn) + 4 */
		bhi functionLoop$

	add pin, pin,lsl #1
	lsl pinFn,pin

	tmp .req r3
	mov tmp,#7					/* tmp <- r3 = 111 (#7) */
	lsl tmp,pin					/* ShiftLeft => r3 (..111..) à l'@ de fn de r1 */
	.unreq pin

	mvn tmp,tmp					/* inverse tmp => (..000..) à l'@ de la fn de r1 */
	prevFn .req r2
	ldr prevFn,[gpio]			/* r2 <- @ instrus prec */
	and prevFn,tmp
	.unreq tmp

	orr pinFn,prevFn			/* r3 <- pinFn or prevFn  */
	.unreq prevFn

	str pinFn,[gpio]			/* place gpio dans l'@ pinFn */
	.unreq pinFn
	.unreq gpio
	pop {pc}

/* Monte le gpio a l'@ de ro si r1 != 0; le descend sinon /
/ void SetGpio(u32 gpioRegister, u32 value) */
.globl SetGpio
SetGpio:
    pin .req r0
    pinVal .req r1

	cmp pin,#53
	movhi pc,lr
	push {lr}
	mov r2,pin
    .unreq pin
    pin .req r2
	bl GetGpioAddress
    gpio .req r0

	pinTmp .req r3
	lsr pinTmp,pin,#5			/* place ds pinTmp le ShiftRight5 de pin */
	lsl pinTmp,#2
	add gpio,pinTmp
	.unreq pinTmp

	and pin,#31					/* 31 = 11111 */
	setBit .req r3
	mov newVal,#1
	lsl newVal,pin
	.unreq pin

	teq pinVal,#0				/* si r1 == 0 */
	.unreq pinVal
	streq newVal,[gpio,#40]		/* vrai : déplace gpio vers +40 (val turn off)*/
	strne newVal,[gpio,#28]		/* faux : déplace gpio vers +28 (val turn on) */
	.unreq newVal
	.unreq gpio
	pop {pc}
