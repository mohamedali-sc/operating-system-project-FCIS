
obj/user/tst_sharing_2slave2:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 b0 01 00 00       	call   8001e6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 80 22 80 00       	push   $0x802280
  80008c:	6a 13                	push   $0x13
  80008e:	68 9c 22 80 00       	push   $0x80229c
  800093:	e8 93 02 00 00       	call   80032b <_panic>
	}

	int32 parentenvID = sys_getparentenvid();
  800098:	e8 d2 19 00 00       	call   801a6f <sys_getparentenvid>
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a0:	e8 4c 1b 00 00       	call   801bf1 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000a5:	e8 77 1a 00 00       	call   801b21 <sys_calculate_free_frames>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 b7 22 80 00       	push   $0x8022b7
  8000b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b8:	e8 4a 18 00 00       	call   801907 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c3:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 bc 22 80 00       	push   $0x8022bc
  8000d4:	6a 1e                	push   $0x1e
  8000d6:	68 9c 22 80 00       	push   $0x80229c
  8000db:	e8 4b 02 00 00       	call   80032b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e3:	e8 39 1a 00 00       	call   801b21 <sys_calculate_free_frames>
  8000e8:	29 c3                	sub    %eax,%ebx
  8000ea:	89 d8                	mov    %ebx,%eax
  8000ec:	83 f8 01             	cmp    $0x1,%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 1c 23 80 00       	push   $0x80231c
  8000f9:	6a 1f                	push   $0x1f
  8000fb:	68 9c 22 80 00       	push   $0x80229c
  800100:	e8 26 02 00 00       	call   80032b <_panic>
	sys_enable_interrupt();
  800105:	e8 01 1b 00 00       	call   801c0b <sys_enable_interrupt>

	sys_disable_interrupt();
  80010a:	e8 e2 1a 00 00       	call   801bf1 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80010f:	e8 0d 1a 00 00       	call   801b21 <sys_calculate_free_frames>
  800114:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	68 ad 23 80 00       	push   $0x8023ad
  80011f:	ff 75 ec             	pushl  -0x14(%ebp)
  800122:	e8 e0 17 00 00       	call   801907 <sget>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012d:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 bc 22 80 00       	push   $0x8022bc
  80013e:	6a 25                	push   $0x25
  800140:	68 9c 22 80 00       	push   $0x80229c
  800145:	e8 e1 01 00 00       	call   80032b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80014a:	e8 d2 19 00 00       	call   801b21 <sys_calculate_free_frames>
  80014f:	89 c2                	mov    %eax,%edx
  800151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800154:	39 c2                	cmp    %eax,%edx
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 1c 23 80 00       	push   $0x80231c
  800160:	6a 26                	push   $0x26
  800162:	68 9c 22 80 00       	push   $0x80229c
  800167:	e8 bf 01 00 00       	call   80032b <_panic>
	sys_enable_interrupt();
  80016c:	e8 9a 1a 00 00       	call   801c0b <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	8b 00                	mov    (%eax),%eax
  800176:	83 f8 0a             	cmp    $0xa,%eax
  800179:	74 14                	je     80018f <_main+0x157>
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	68 b0 23 80 00       	push   $0x8023b0
  800183:	6a 29                	push   $0x29
  800185:	68 9c 22 80 00       	push   $0x80229c
  80018a:	e8 9c 01 00 00       	call   80032b <_panic>

	//Edit the writable object
	*z = 30;
  80018f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800192:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80019b:	8b 00                	mov    (%eax),%eax
  80019d:	83 f8 1e             	cmp    $0x1e,%eax
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 b0 23 80 00       	push   $0x8023b0
  8001aa:	6a 2d                	push   $0x2d
  8001ac:	68 9c 22 80 00       	push   $0x80229c
  8001b1:	e8 75 01 00 00       	call   80032b <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8001bc:	68 e8 23 80 00       	push   $0x8023e8
  8001c1:	e8 07 04 00 00       	call   8005cd <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cc:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	68 18 24 80 00       	push   $0x802418
  8001da:	6a 33                	push   $0x33
  8001dc:	68 9c 22 80 00       	push   $0x80229c
  8001e1:	e8 45 01 00 00       	call   80032b <_panic>

008001e6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ec:	e8 65 18 00 00       	call   801a56 <sys_getenvindex>
  8001f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001f7:	89 d0                	mov    %edx,%eax
  8001f9:	c1 e0 03             	shl    $0x3,%eax
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800205:	01 c8                	add    %ecx,%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	01 d0                	add    %edx,%eax
  80020b:	01 c0                	add    %eax,%eax
  80020d:	01 d0                	add    %edx,%eax
  80020f:	89 c2                	mov    %eax,%edx
  800211:	c1 e2 05             	shl    $0x5,%edx
  800214:	29 c2                	sub    %eax,%edx
  800216:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80021d:	89 c2                	mov    %eax,%edx
  80021f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800225:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800235:	84 c0                	test   %al,%al
  800237:	74 0f                	je     800248 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	05 40 3c 01 00       	add    $0x13c40,%eax
  800243:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024c:	7e 0a                	jle    800258 <libmain+0x72>
		binaryname = argv[0];
  80024e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800251:	8b 00                	mov    (%eax),%eax
  800253:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	ff 75 0c             	pushl  0xc(%ebp)
  80025e:	ff 75 08             	pushl  0x8(%ebp)
  800261:	e8 d2 fd ff ff       	call   800038 <_main>
  800266:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800269:	e8 83 19 00 00       	call   801bf1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	68 74 24 80 00       	push   $0x802474
  800276:	e8 52 03 00 00       	call   8005cd <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027e:	a1 20 30 80 00       	mov    0x803020,%eax
  800283:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800289:	a1 20 30 80 00       	mov    0x803020,%eax
  80028e:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	52                   	push   %edx
  800298:	50                   	push   %eax
  800299:	68 9c 24 80 00       	push   $0x80249c
  80029e:	e8 2a 03 00 00       	call   8005cd <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ab:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b6:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8002bc:	83 ec 04             	sub    $0x4,%esp
  8002bf:	52                   	push   %edx
  8002c0:	50                   	push   %eax
  8002c1:	68 c4 24 80 00       	push   $0x8024c4
  8002c6:	e8 02 03 00 00       	call   8005cd <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d3:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	50                   	push   %eax
  8002dd:	68 05 25 80 00       	push   $0x802505
  8002e2:	e8 e6 02 00 00       	call   8005cd <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	68 74 24 80 00       	push   $0x802474
  8002f2:	e8 d6 02 00 00       	call   8005cd <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002fa:	e8 0c 19 00 00       	call   801c0b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002ff:	e8 19 00 00 00       	call   80031d <exit>
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	6a 00                	push   $0x0
  800312:	e8 0b 17 00 00       	call   801a22 <sys_env_destroy>
  800317:	83 c4 10             	add    $0x10,%esp
}
  80031a:	90                   	nop
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <exit>:

void
exit(void)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800323:	e8 60 17 00 00       	call   801a88 <sys_env_exit>
}
  800328:	90                   	nop
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800331:	8d 45 10             	lea    0x10(%ebp),%eax
  800334:	83 c0 04             	add    $0x4,%eax
  800337:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80033a:	a1 18 31 80 00       	mov    0x803118,%eax
  80033f:	85 c0                	test   %eax,%eax
  800341:	74 16                	je     800359 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800343:	a1 18 31 80 00       	mov    0x803118,%eax
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	50                   	push   %eax
  80034c:	68 1c 25 80 00       	push   $0x80251c
  800351:	e8 77 02 00 00       	call   8005cd <cprintf>
  800356:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800359:	a1 00 30 80 00       	mov    0x803000,%eax
  80035e:	ff 75 0c             	pushl  0xc(%ebp)
  800361:	ff 75 08             	pushl  0x8(%ebp)
  800364:	50                   	push   %eax
  800365:	68 21 25 80 00       	push   $0x802521
  80036a:	e8 5e 02 00 00       	call   8005cd <cprintf>
  80036f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800372:	8b 45 10             	mov    0x10(%ebp),%eax
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	ff 75 f4             	pushl  -0xc(%ebp)
  80037b:	50                   	push   %eax
  80037c:	e8 e1 01 00 00       	call   800562 <vcprintf>
  800381:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	6a 00                	push   $0x0
  800389:	68 3d 25 80 00       	push   $0x80253d
  80038e:	e8 cf 01 00 00       	call   800562 <vcprintf>
  800393:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800396:	e8 82 ff ff ff       	call   80031d <exit>

	// should not return here
	while (1) ;
  80039b:	eb fe                	jmp    80039b <_panic+0x70>

0080039d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 50 74             	mov    0x74(%eax),%edx
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	39 c2                	cmp    %eax,%edx
  8003b0:	74 14                	je     8003c6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	68 40 25 80 00       	push   $0x802540
  8003ba:	6a 26                	push   $0x26
  8003bc:	68 8c 25 80 00       	push   $0x80258c
  8003c1:	e8 65 ff ff ff       	call   80032b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d4:	e9 b6 00 00 00       	jmp    80048f <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	75 08                	jne    8003f6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f1:	e9 96 00 00 00       	jmp    80048c <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800404:	eb 5d                	jmp    800463 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800406:	a1 20 30 80 00       	mov    0x803020,%eax
  80040b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800414:	c1 e2 04             	shl    $0x4,%edx
  800417:	01 d0                	add    %edx,%eax
  800419:	8a 40 04             	mov    0x4(%eax),%al
  80041c:	84 c0                	test   %al,%al
  80041e:	75 40                	jne    800460 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800420:	a1 20 30 80 00       	mov    0x803020,%eax
  800425:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80042b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042e:	c1 e2 04             	shl    $0x4,%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800438:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800440:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800453:	39 c2                	cmp    %eax,%edx
  800455:	75 09                	jne    800460 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800457:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80045e:	eb 12                	jmp    800472 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800460:	ff 45 e8             	incl   -0x18(%ebp)
  800463:	a1 20 30 80 00       	mov    0x803020,%eax
  800468:	8b 50 74             	mov    0x74(%eax),%edx
  80046b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	77 94                	ja     800406 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800472:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800476:	75 14                	jne    80048c <CheckWSWithoutLastIndex+0xef>
			panic(
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 98 25 80 00       	push   $0x802598
  800480:	6a 3a                	push   $0x3a
  800482:	68 8c 25 80 00       	push   $0x80258c
  800487:	e8 9f fe ff ff       	call   80032b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80048c:	ff 45 f0             	incl   -0x10(%ebp)
  80048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800492:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800495:	0f 8c 3e ff ff ff    	jl     8003d9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80049b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a9:	eb 20                	jmp    8004cb <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b9:	c1 e2 04             	shl    $0x4,%edx
  8004bc:	01 d0                	add    %edx,%eax
  8004be:	8a 40 04             	mov    0x4(%eax),%al
  8004c1:	3c 01                	cmp    $0x1,%al
  8004c3:	75 03                	jne    8004c8 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8004c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c8:	ff 45 e0             	incl   -0x20(%ebp)
  8004cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d0:	8b 50 74             	mov    0x74(%eax),%edx
  8004d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d6:	39 c2                	cmp    %eax,%edx
  8004d8:	77 d1                	ja     8004ab <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e0:	74 14                	je     8004f6 <CheckWSWithoutLastIndex+0x159>
		panic(
  8004e2:	83 ec 04             	sub    $0x4,%esp
  8004e5:	68 ec 25 80 00       	push   $0x8025ec
  8004ea:	6a 44                	push   $0x44
  8004ec:	68 8c 25 80 00       	push   $0x80258c
  8004f1:	e8 35 fe ff ff       	call   80032b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f6:	90                   	nop
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 48 01             	lea    0x1(%eax),%ecx
  800507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050a:	89 0a                	mov    %ecx,(%edx)
  80050c:	8b 55 08             	mov    0x8(%ebp),%edx
  80050f:	88 d1                	mov    %dl,%cl
  800511:	8b 55 0c             	mov    0xc(%ebp),%edx
  800514:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800522:	75 2c                	jne    800550 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800524:	a0 24 30 80 00       	mov    0x803024,%al
  800529:	0f b6 c0             	movzbl %al,%eax
  80052c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052f:	8b 12                	mov    (%edx),%edx
  800531:	89 d1                	mov    %edx,%ecx
  800533:	8b 55 0c             	mov    0xc(%ebp),%edx
  800536:	83 c2 08             	add    $0x8,%edx
  800539:	83 ec 04             	sub    $0x4,%esp
  80053c:	50                   	push   %eax
  80053d:	51                   	push   %ecx
  80053e:	52                   	push   %edx
  80053f:	e8 9c 14 00 00       	call   8019e0 <sys_cputs>
  800544:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 40 04             	mov    0x4(%eax),%eax
  800556:	8d 50 01             	lea    0x1(%eax),%edx
  800559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055f:	90                   	nop
  800560:	c9                   	leave  
  800561:	c3                   	ret    

00800562 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800572:	00 00 00 
	b.cnt = 0;
  800575:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80057c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058b:	50                   	push   %eax
  80058c:	68 f9 04 80 00       	push   $0x8004f9
  800591:	e8 11 02 00 00       	call   8007a7 <vprintfmt>
  800596:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800599:	a0 24 30 80 00       	mov    0x803024,%al
  80059e:	0f b6 c0             	movzbl %al,%eax
  8005a1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a7:	83 ec 04             	sub    $0x4,%esp
  8005aa:	50                   	push   %eax
  8005ab:	52                   	push   %edx
  8005ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b2:	83 c0 08             	add    $0x8,%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 25 14 00 00       	call   8019e0 <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005be:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cb:	c9                   	leave  
  8005cc:	c3                   	ret    

008005cd <cprintf>:

int cprintf(const char *fmt, ...) {
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
  8005d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	e8 73 ff ff ff       	call   800562 <vcprintf>
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800600:	e8 ec 15 00 00       	call   801bf1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800605:	8d 45 0c             	lea    0xc(%ebp),%eax
  800608:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 f4             	pushl  -0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	e8 48 ff ff ff       	call   800562 <vcprintf>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800620:	e8 e6 15 00 00       	call   801c0b <sys_enable_interrupt>
	return cnt;
  800625:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800628:	c9                   	leave  
  800629:	c3                   	ret    

0080062a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	53                   	push   %ebx
  80062e:	83 ec 14             	sub    $0x14,%esp
  800631:	8b 45 10             	mov    0x10(%ebp),%eax
  800634:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80063d:	8b 45 18             	mov    0x18(%ebp),%eax
  800640:	ba 00 00 00 00       	mov    $0x0,%edx
  800645:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800648:	77 55                	ja     80069f <printnum+0x75>
  80064a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064d:	72 05                	jb     800654 <printnum+0x2a>
  80064f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800652:	77 4b                	ja     80069f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800654:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800657:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80065a:	8b 45 18             	mov    0x18(%ebp),%eax
  80065d:	ba 00 00 00 00       	mov    $0x0,%edx
  800662:	52                   	push   %edx
  800663:	50                   	push   %eax
  800664:	ff 75 f4             	pushl  -0xc(%ebp)
  800667:	ff 75 f0             	pushl  -0x10(%ebp)
  80066a:	e8 a5 19 00 00       	call   802014 <__udivdi3>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	ff 75 20             	pushl  0x20(%ebp)
  800678:	53                   	push   %ebx
  800679:	ff 75 18             	pushl  0x18(%ebp)
  80067c:	52                   	push   %edx
  80067d:	50                   	push   %eax
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	ff 75 08             	pushl  0x8(%ebp)
  800684:	e8 a1 ff ff ff       	call   80062a <printnum>
  800689:	83 c4 20             	add    $0x20,%esp
  80068c:	eb 1a                	jmp    8006a8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	ff 75 20             	pushl  0x20(%ebp)
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	ff d0                	call   *%eax
  80069c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069f:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a6:	7f e6                	jg     80068e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b6:	53                   	push   %ebx
  8006b7:	51                   	push   %ecx
  8006b8:	52                   	push   %edx
  8006b9:	50                   	push   %eax
  8006ba:	e8 65 1a 00 00       	call   802124 <__umoddi3>
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	05 54 28 80 00       	add    $0x802854,%eax
  8006c7:	8a 00                	mov    (%eax),%al
  8006c9:	0f be c0             	movsbl %al,%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
  8006d8:	83 c4 10             	add    $0x10,%esp
}
  8006db:	90                   	nop
  8006dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 40                	jmp    800746 <getuint+0x65>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1e                	je     80072a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	eb 1c                	jmp    800746 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800746:	5d                   	pop    %ebp
  800747:	c3                   	ret    

00800748 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074f:	7e 1c                	jle    80076d <getint+0x25>
		return va_arg(*ap, long long);
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	8d 50 08             	lea    0x8(%eax),%edx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	89 10                	mov    %edx,(%eax)
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	83 e8 08             	sub    $0x8,%eax
  800766:	8b 50 04             	mov    0x4(%eax),%edx
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	eb 38                	jmp    8007a5 <getint+0x5d>
	else if (lflag)
  80076d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800771:	74 1a                	je     80078d <getint+0x45>
		return va_arg(*ap, long);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	8d 50 04             	lea    0x4(%eax),%edx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 10                	mov    %edx,(%eax)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	83 e8 04             	sub    $0x4,%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	99                   	cltd   
  80078b:	eb 18                	jmp    8007a5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 10                	mov    %edx,(%eax)
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	99                   	cltd   
}
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	56                   	push   %esi
  8007ab:	53                   	push   %ebx
  8007ac:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007af:	eb 17                	jmp    8007c8 <vprintfmt+0x21>
			if (ch == '\0')
  8007b1:	85 db                	test   %ebx,%ebx
  8007b3:	0f 84 af 03 00 00    	je     800b68 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	53                   	push   %ebx
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	ff d0                	call   *%eax
  8007c5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cb:	8d 50 01             	lea    0x1(%eax),%edx
  8007ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d1:	8a 00                	mov    (%eax),%al
  8007d3:	0f b6 d8             	movzbl %al,%ebx
  8007d6:	83 fb 25             	cmp    $0x25,%ebx
  8007d9:	75 d6                	jne    8007b1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007db:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fe:	8d 50 01             	lea    0x1(%eax),%edx
  800801:	89 55 10             	mov    %edx,0x10(%ebp)
  800804:	8a 00                	mov    (%eax),%al
  800806:	0f b6 d8             	movzbl %al,%ebx
  800809:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80080c:	83 f8 55             	cmp    $0x55,%eax
  80080f:	0f 87 2b 03 00 00    	ja     800b40 <vprintfmt+0x399>
  800815:	8b 04 85 78 28 80 00 	mov    0x802878(,%eax,4),%eax
  80081c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800822:	eb d7                	jmp    8007fb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800824:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800828:	eb d1                	jmp    8007fb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800831:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800834:	89 d0                	mov    %edx,%eax
  800836:	c1 e0 02             	shl    $0x2,%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	01 c0                	add    %eax,%eax
  80083d:	01 d8                	add    %ebx,%eax
  80083f:	83 e8 30             	sub    $0x30,%eax
  800842:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800845:	8b 45 10             	mov    0x10(%ebp),%eax
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80084d:	83 fb 2f             	cmp    $0x2f,%ebx
  800850:	7e 3e                	jle    800890 <vprintfmt+0xe9>
  800852:	83 fb 39             	cmp    $0x39,%ebx
  800855:	7f 39                	jg     800890 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800857:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80085a:	eb d5                	jmp    800831 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	83 c0 04             	add    $0x4,%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800870:	eb 1f                	jmp    800891 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800872:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800876:	79 83                	jns    8007fb <vprintfmt+0x54>
				width = 0;
  800878:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087f:	e9 77 ff ff ff       	jmp    8007fb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800884:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80088b:	e9 6b ff ff ff       	jmp    8007fb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800890:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800891:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800895:	0f 89 60 ff ff ff    	jns    8007fb <vprintfmt+0x54>
				width = precision, precision = -1;
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a8:	e9 4e ff ff ff       	jmp    8007fb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ad:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b0:	e9 46 ff ff ff       	jmp    8007fb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	83 c0 04             	add    $0x4,%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	83 e8 04             	sub    $0x4,%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	50                   	push   %eax
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	ff d0                	call   *%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
			break;
  8008d5:	e9 89 02 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 c0 04             	add    $0x4,%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 e8 04             	sub    $0x4,%eax
  8008e9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008eb:	85 db                	test   %ebx,%ebx
  8008ed:	79 02                	jns    8008f1 <vprintfmt+0x14a>
				err = -err;
  8008ef:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f1:	83 fb 64             	cmp    $0x64,%ebx
  8008f4:	7f 0b                	jg     800901 <vprintfmt+0x15a>
  8008f6:	8b 34 9d c0 26 80 00 	mov    0x8026c0(,%ebx,4),%esi
  8008fd:	85 f6                	test   %esi,%esi
  8008ff:	75 19                	jne    80091a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800901:	53                   	push   %ebx
  800902:	68 65 28 80 00       	push   $0x802865
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 5e 02 00 00       	call   800b70 <printfmt>
  800912:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800915:	e9 49 02 00 00       	jmp    800b63 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091a:	56                   	push   %esi
  80091b:	68 6e 28 80 00       	push   $0x80286e
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	ff 75 08             	pushl  0x8(%ebp)
  800926:	e8 45 02 00 00       	call   800b70 <printfmt>
  80092b:	83 c4 10             	add    $0x10,%esp
			break;
  80092e:	e9 30 02 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	83 c0 04             	add    $0x4,%eax
  800939:	89 45 14             	mov    %eax,0x14(%ebp)
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	83 e8 04             	sub    $0x4,%eax
  800942:	8b 30                	mov    (%eax),%esi
  800944:	85 f6                	test   %esi,%esi
  800946:	75 05                	jne    80094d <vprintfmt+0x1a6>
				p = "(null)";
  800948:	be 71 28 80 00       	mov    $0x802871,%esi
			if (width > 0 && padc != '-')
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	7e 6d                	jle    8009c0 <vprintfmt+0x219>
  800953:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800957:	74 67                	je     8009c0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	50                   	push   %eax
  800960:	56                   	push   %esi
  800961:	e8 0c 03 00 00       	call   800c72 <strnlen>
  800966:	83 c4 10             	add    $0x10,%esp
  800969:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80096c:	eb 16                	jmp    800984 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	50                   	push   %eax
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	ff d0                	call   *%eax
  80097e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800981:	ff 4d e4             	decl   -0x1c(%ebp)
  800984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800988:	7f e4                	jg     80096e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098a:	eb 34                	jmp    8009c0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80098c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800990:	74 1c                	je     8009ae <vprintfmt+0x207>
  800992:	83 fb 1f             	cmp    $0x1f,%ebx
  800995:	7e 05                	jle    80099c <vprintfmt+0x1f5>
  800997:	83 fb 7e             	cmp    $0x7e,%ebx
  80099a:	7e 12                	jle    8009ae <vprintfmt+0x207>
					putch('?', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	6a 3f                	push   $0x3f
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	eb 0f                	jmp    8009bd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009bd:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c0:	89 f0                	mov    %esi,%eax
  8009c2:	8d 70 01             	lea    0x1(%eax),%esi
  8009c5:	8a 00                	mov    (%eax),%al
  8009c7:	0f be d8             	movsbl %al,%ebx
  8009ca:	85 db                	test   %ebx,%ebx
  8009cc:	74 24                	je     8009f2 <vprintfmt+0x24b>
  8009ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d2:	78 b8                	js     80098c <vprintfmt+0x1e5>
  8009d4:	ff 4d e0             	decl   -0x20(%ebp)
  8009d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009db:	79 af                	jns    80098c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009dd:	eb 13                	jmp    8009f2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 20                	push   $0x20
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	7f e7                	jg     8009df <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f8:	e9 66 01 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 e8             	pushl  -0x18(%ebp)
  800a03:	8d 45 14             	lea    0x14(%ebp),%eax
  800a06:	50                   	push   %eax
  800a07:	e8 3c fd ff ff       	call   800748 <getint>
  800a0c:	83 c4 10             	add    $0x10,%esp
  800a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1b:	85 d2                	test   %edx,%edx
  800a1d:	79 23                	jns    800a42 <vprintfmt+0x29b>
				putch('-', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 2d                	push   $0x2d
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a35:	f7 d8                	neg    %eax
  800a37:	83 d2 00             	adc    $0x0,%edx
  800a3a:	f7 da                	neg    %edx
  800a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a42:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a49:	e9 bc 00 00 00       	jmp    800b0a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 84 fc ff ff       	call   8006e1 <getuint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a66:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6d:	e9 98 00 00 00       	jmp    800b0a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	6a 58                	push   $0x58
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 58                	push   $0x58
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	6a 58                	push   $0x58
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			break;
  800aa2:	e9 bc 00 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	6a 30                	push   $0x30
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 78                	push   $0x78
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 e8 04             	sub    $0x4,%eax
  800ad6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae9:	eb 1f                	jmp    800b0a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 e8             	pushl  -0x18(%ebp)
  800af1:	8d 45 14             	lea    0x14(%ebp),%eax
  800af4:	50                   	push   %eax
  800af5:	e8 e7 fb ff ff       	call   8006e1 <getuint>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b03:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b11:	83 ec 04             	sub    $0x4,%esp
  800b14:	52                   	push   %edx
  800b15:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b18:	50                   	push   %eax
  800b19:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1c:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 00 fb ff ff       	call   80062a <printnum>
  800b2a:	83 c4 20             	add    $0x20,%esp
			break;
  800b2d:	eb 34                	jmp    800b63 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	53                   	push   %ebx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			break;
  800b3e:	eb 23                	jmp    800b63 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	6a 25                	push   $0x25
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b50:	ff 4d 10             	decl   0x10(%ebp)
  800b53:	eb 03                	jmp    800b58 <vprintfmt+0x3b1>
  800b55:	ff 4d 10             	decl   0x10(%ebp)
  800b58:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5b:	48                   	dec    %eax
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	3c 25                	cmp    $0x25,%al
  800b60:	75 f3                	jne    800b55 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b62:	90                   	nop
		}
	}
  800b63:	e9 47 fc ff ff       	jmp    8007af <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b68:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b76:	8d 45 10             	lea    0x10(%ebp),%eax
  800b79:	83 c0 04             	add    $0x4,%eax
  800b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	ff 75 f4             	pushl  -0xc(%ebp)
  800b85:	50                   	push   %eax
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	ff 75 08             	pushl  0x8(%ebp)
  800b8c:	e8 16 fc ff ff       	call   8007a7 <vprintfmt>
  800b91:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b94:	90                   	nop
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8b 40 08             	mov    0x8(%eax),%eax
  800ba0:	8d 50 01             	lea    0x1(%eax),%edx
  800ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8b 10                	mov    (%eax),%edx
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	8b 40 04             	mov    0x4(%eax),%eax
  800bb4:	39 c2                	cmp    %eax,%edx
  800bb6:	73 12                	jae    800bca <sprintputch+0x33>
		*b->buf++ = ch;
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc3:	89 0a                	mov    %ecx,(%edx)
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	88 10                	mov    %dl,(%eax)
}
  800bca:	90                   	nop
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	01 d0                	add    %edx,%eax
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf2:	74 06                	je     800bfa <vsnprintf+0x2d>
  800bf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf8:	7f 07                	jg     800c01 <vsnprintf+0x34>
		return -E_INVAL;
  800bfa:	b8 03 00 00 00       	mov    $0x3,%eax
  800bff:	eb 20                	jmp    800c21 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c01:	ff 75 14             	pushl  0x14(%ebp)
  800c04:	ff 75 10             	pushl  0x10(%ebp)
  800c07:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c0a:	50                   	push   %eax
  800c0b:	68 97 0b 80 00       	push   $0x800b97
  800c10:	e8 92 fb ff ff       	call   8007a7 <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c29:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2c:	83 c0 04             	add    $0x4,%eax
  800c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	ff 75 f4             	pushl  -0xc(%ebp)
  800c38:	50                   	push   %eax
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	ff 75 08             	pushl  0x8(%ebp)
  800c3f:	e8 89 ff ff ff       	call   800bcd <vsnprintf>
  800c44:	83 c4 10             	add    $0x10,%esp
  800c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5c:	eb 06                	jmp    800c64 <strlen+0x15>
		n++;
  800c5e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c61:	ff 45 08             	incl   0x8(%ebp)
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	84 c0                	test   %al,%al
  800c6b:	75 f1                	jne    800c5e <strlen+0xf>
		n++;
	return n;
  800c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7f:	eb 09                	jmp    800c8a <strnlen+0x18>
		n++;
  800c81:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c84:	ff 45 08             	incl   0x8(%ebp)
  800c87:	ff 4d 0c             	decl   0xc(%ebp)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 09                	je     800c99 <strnlen+0x27>
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	75 e8                	jne    800c81 <strnlen+0xf>
		n++;
	return n;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800caa:	90                   	nop
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	75 e4                	jne    800cab <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdf:	eb 1f                	jmp    800d00 <strncpy+0x34>
		*dst++ = *src;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8d 50 01             	lea    0x1(%eax),%edx
  800ce7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ced:	8a 12                	mov    (%edx),%dl
  800cef:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	84 c0                	test   %al,%al
  800cf8:	74 03                	je     800cfd <strncpy+0x31>
			src++;
  800cfa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cfd:	ff 45 fc             	incl   -0x4(%ebp)
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d06:	72 d9                	jb     800ce1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	74 30                	je     800d4f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1f:	eb 16                	jmp    800d37 <strlcpy+0x2a>
			*dst++ = *src++;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d33:	8a 12                	mov    (%edx),%dl
  800d35:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d37:	ff 4d 10             	decl   0x10(%ebp)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 09                	je     800d49 <strlcpy+0x3c>
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	75 d8                	jne    800d21 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d55:	29 c2                	sub    %eax,%edx
  800d57:	89 d0                	mov    %edx,%eax
}
  800d59:	c9                   	leave  
  800d5a:	c3                   	ret    

00800d5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5e:	eb 06                	jmp    800d66 <strcmp+0xb>
		p++, q++;
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	84 c0                	test   %al,%al
  800d6d:	74 0e                	je     800d7d <strcmp+0x22>
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 10                	mov    (%eax),%dl
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	38 c2                	cmp    %al,%dl
  800d7b:	74 e3                	je     800d60 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	0f b6 d0             	movzbl %al,%edx
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 c0             	movzbl %al,%eax
  800d8d:	29 c2                	sub    %eax,%edx
  800d8f:	89 d0                	mov    %edx,%eax
}
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d96:	eb 09                	jmp    800da1 <strncmp+0xe>
		n--, p++, q++;
  800d98:	ff 4d 10             	decl   0x10(%ebp)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da5:	74 17                	je     800dbe <strncmp+0x2b>
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 0e                	je     800dbe <strncmp+0x2b>
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 10                	mov    (%eax),%dl
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	38 c2                	cmp    %al,%dl
  800dbc:	74 da                	je     800d98 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	75 07                	jne    800dcb <strncmp+0x38>
		return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc9:	eb 14                	jmp    800ddf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	0f b6 d0             	movzbl %al,%edx
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	0f b6 c0             	movzbl %al,%eax
  800ddb:	29 c2                	sub    %eax,%edx
  800ddd:	89 d0                	mov    %edx,%eax
}
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 12                	jmp    800e01 <strchr+0x20>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	75 05                	jne    800dfe <strchr+0x1d>
			return (char *) s;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	eb 11                	jmp    800e0f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfe:	ff 45 08             	incl   0x8(%ebp)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	84 c0                	test   %al,%al
  800e08:	75 e5                	jne    800def <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 04             	sub    $0x4,%esp
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e1d:	eb 0d                	jmp    800e2c <strfind+0x1b>
		if (*s == c)
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e27:	74 0e                	je     800e37 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	84 c0                	test   %al,%al
  800e33:	75 ea                	jne    800e1f <strfind+0xe>
  800e35:	eb 01                	jmp    800e38 <strfind+0x27>
		if (*s == c)
			break;
  800e37:	90                   	nop
	return (char *) s;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e49:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4f:	eb 0e                	jmp    800e5f <memset+0x22>
		*p++ = c;
  800e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5f:	ff 4d f8             	decl   -0x8(%ebp)
  800e62:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e66:	79 e9                	jns    800e51 <memset+0x14>
		*p++ = c;

	return v;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7f:	eb 16                	jmp    800e97 <memcpy+0x2a>
		*d++ = *s++;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e84:	8d 50 01             	lea    0x1(%eax),%edx
  800e87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e93:	8a 12                	mov    (%edx),%dl
  800e95:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	75 dd                	jne    800e81 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    

00800ea9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ec1:	73 50                	jae    800f13 <memmove+0x6a>
  800ec3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec9:	01 d0                	add    %edx,%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	76 43                	jbe    800f13 <memmove+0x6a>
		s += n;
  800ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800edc:	eb 10                	jmp    800eee <memmove+0x45>
			*--d = *--s;
  800ede:	ff 4d f8             	decl   -0x8(%ebp)
  800ee1:	ff 4d fc             	decl   -0x4(%ebp)
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 10                	mov    (%eax),%dl
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eec:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	75 e3                	jne    800ede <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800efb:	eb 23                	jmp    800f20 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f00:	8d 50 01             	lea    0x1(%eax),%edx
  800f03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0f:	8a 12                	mov    (%edx),%dl
  800f11:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f13:	8b 45 10             	mov    0x10(%ebp),%eax
  800f16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f19:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	75 dd                	jne    800efd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f37:	eb 2a                	jmp    800f63 <memcmp+0x3e>
		if (*s1 != *s2)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	38 c2                	cmp    %al,%dl
  800f45:	74 16                	je     800f5d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	0f b6 d0             	movzbl %al,%edx
  800f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	0f b6 c0             	movzbl %al,%eax
  800f57:	29 c2                	sub    %eax,%edx
  800f59:	89 d0                	mov    %edx,%eax
  800f5b:	eb 18                	jmp    800f75 <memcmp+0x50>
		s1++, s2++;
  800f5d:	ff 45 fc             	incl   -0x4(%ebp)
  800f60:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f63:	8b 45 10             	mov    0x10(%ebp),%eax
  800f66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f69:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	75 c9                	jne    800f39 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 45 10             	mov    0x10(%ebp),%eax
  800f83:	01 d0                	add    %edx,%eax
  800f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f88:	eb 15                	jmp    800f9f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	0f b6 d0             	movzbl %al,%edx
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	39 c2                	cmp    %eax,%edx
  800f9a:	74 0d                	je     800fa9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa5:	72 e3                	jb     800f8a <memfind+0x13>
  800fa7:	eb 01                	jmp    800faa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa9:	90                   	nop
	return (void *) s;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fbc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc3:	eb 03                	jmp    800fc8 <strtol+0x19>
		s++;
  800fc5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 20                	cmp    $0x20,%al
  800fcf:	74 f4                	je     800fc5 <strtol+0x16>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 09                	cmp    $0x9,%al
  800fd8:	74 eb                	je     800fc5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 2b                	cmp    $0x2b,%al
  800fe1:	75 05                	jne    800fe8 <strtol+0x39>
		s++;
  800fe3:	ff 45 08             	incl   0x8(%ebp)
  800fe6:	eb 13                	jmp    800ffb <strtol+0x4c>
	else if (*s == '-')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2d                	cmp    $0x2d,%al
  800fef:	75 0a                	jne    800ffb <strtol+0x4c>
		s++, neg = 1;
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fff:	74 06                	je     801007 <strtol+0x58>
  801001:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801005:	75 20                	jne    801027 <strtol+0x78>
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 30                	cmp    $0x30,%al
  80100e:	75 17                	jne    801027 <strtol+0x78>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	40                   	inc    %eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 78                	cmp    $0x78,%al
  801018:	75 0d                	jne    801027 <strtol+0x78>
		s += 2, base = 16;
  80101a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801025:	eb 28                	jmp    80104f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801027:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102b:	75 15                	jne    801042 <strtol+0x93>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 30                	cmp    $0x30,%al
  801034:	75 0c                	jne    801042 <strtol+0x93>
		s++, base = 8;
  801036:	ff 45 08             	incl   0x8(%ebp)
  801039:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801040:	eb 0d                	jmp    80104f <strtol+0xa0>
	else if (base == 0)
  801042:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801046:	75 07                	jne    80104f <strtol+0xa0>
		base = 10;
  801048:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	3c 2f                	cmp    $0x2f,%al
  801056:	7e 19                	jle    801071 <strtol+0xc2>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 39                	cmp    $0x39,%al
  80105f:	7f 10                	jg     801071 <strtol+0xc2>
			dig = *s - '0';
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f be c0             	movsbl %al,%eax
  801069:	83 e8 30             	sub    $0x30,%eax
  80106c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106f:	eb 42                	jmp    8010b3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	3c 60                	cmp    $0x60,%al
  801078:	7e 19                	jle    801093 <strtol+0xe4>
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 7a                	cmp    $0x7a,%al
  801081:	7f 10                	jg     801093 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f be c0             	movsbl %al,%eax
  80108b:	83 e8 57             	sub    $0x57,%eax
  80108e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801091:	eb 20                	jmp    8010b3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	3c 40                	cmp    $0x40,%al
  80109a:	7e 39                	jle    8010d5 <strtol+0x126>
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 5a                	cmp    $0x5a,%al
  8010a3:	7f 30                	jg     8010d5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	0f be c0             	movsbl %al,%eax
  8010ad:	83 e8 37             	sub    $0x37,%eax
  8010b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b9:	7d 19                	jge    8010d4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010bb:	ff 45 08             	incl   0x8(%ebp)
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c5:	89 c2                	mov    %eax,%edx
  8010c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ca:	01 d0                	add    %edx,%eax
  8010cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cf:	e9 7b ff ff ff       	jmp    80104f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d9:	74 08                	je     8010e3 <strtol+0x134>
		*endptr = (char *) s;
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e7:	74 07                	je     8010f0 <strtol+0x141>
  8010e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ec:	f7 d8                	neg    %eax
  8010ee:	eb 03                	jmp    8010f3 <strtol+0x144>
  8010f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801102:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110d:	79 13                	jns    801122 <ltostr+0x2d>
	{
		neg = 1;
  80110f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80111c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80112a:	99                   	cltd   
  80112b:	f7 f9                	idiv   %ecx
  80112d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801139:	89 c2                	mov    %eax,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	01 d0                	add    %edx,%eax
  801140:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801143:	83 c2 30             	add    $0x30,%edx
  801146:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801148:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80114b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801150:	f7 e9                	imul   %ecx
  801152:	c1 fa 02             	sar    $0x2,%edx
  801155:	89 c8                	mov    %ecx,%eax
  801157:	c1 f8 1f             	sar    $0x1f,%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
  80115e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801161:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801164:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801169:	f7 e9                	imul   %ecx
  80116b:	c1 fa 02             	sar    $0x2,%edx
  80116e:	89 c8                	mov    %ecx,%eax
  801170:	c1 f8 1f             	sar    $0x1f,%eax
  801173:	29 c2                	sub    %eax,%edx
  801175:	89 d0                	mov    %edx,%eax
  801177:	c1 e0 02             	shl    $0x2,%eax
  80117a:	01 d0                	add    %edx,%eax
  80117c:	01 c0                	add    %eax,%eax
  80117e:	29 c1                	sub    %eax,%ecx
  801180:	89 ca                	mov    %ecx,%edx
  801182:	85 d2                	test   %edx,%edx
  801184:	75 9c                	jne    801122 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	48                   	dec    %eax
  801191:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801194:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801198:	74 3d                	je     8011d7 <ltostr+0xe2>
		start = 1 ;
  80119a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a1:	eb 34                	jmp    8011d7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a9:	01 d0                	add    %edx,%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 c2                	add    %eax,%edx
  8011b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011be:	01 c8                	add    %ecx,%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c2                	add    %eax,%edx
  8011cc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cf:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dd:	7c c4                	jl     8011a3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011df:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e5:	01 d0                	add    %edx,%eax
  8011e7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ea:	90                   	nop
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f3:	ff 75 08             	pushl  0x8(%ebp)
  8011f6:	e8 54 fa ff ff       	call   800c4f <strlen>
  8011fb:	83 c4 04             	add    $0x4,%esp
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801201:	ff 75 0c             	pushl  0xc(%ebp)
  801204:	e8 46 fa ff ff       	call   800c4f <strlen>
  801209:	83 c4 04             	add    $0x4,%esp
  80120c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801216:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121d:	eb 17                	jmp    801236 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	01 c2                	add    %eax,%edx
  801227:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	01 c8                	add    %ecx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801233:	ff 45 fc             	incl   -0x4(%ebp)
  801236:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801239:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80123c:	7c e1                	jl     80121f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801245:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80124c:	eb 1f                	jmp    80126d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801251:	8d 50 01             	lea    0x1(%eax),%edx
  801254:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801257:	89 c2                	mov    %eax,%edx
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	01 c2                	add    %eax,%edx
  80125e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 c8                	add    %ecx,%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80126a:	ff 45 f8             	incl   -0x8(%ebp)
  80126d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801270:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801273:	7c d9                	jl     80124e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801275:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c6 00 00             	movb   $0x0,(%eax)
}
  801280:	90                   	nop
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128f:	8b 45 14             	mov    0x14(%ebp),%eax
  801292:	8b 00                	mov    (%eax),%eax
  801294:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129b:	8b 45 10             	mov    0x10(%ebp),%eax
  80129e:	01 d0                	add    %edx,%eax
  8012a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a6:	eb 0c                	jmp    8012b4 <strsplit+0x31>
			*string++ = 0;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8d 50 01             	lea    0x1(%eax),%edx
  8012ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	84 c0                	test   %al,%al
  8012bb:	74 18                	je     8012d5 <strsplit+0x52>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	0f be c0             	movsbl %al,%eax
  8012c5:	50                   	push   %eax
  8012c6:	ff 75 0c             	pushl  0xc(%ebp)
  8012c9:	e8 13 fb ff ff       	call   800de1 <strchr>
  8012ce:	83 c4 08             	add    $0x8,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	75 d3                	jne    8012a8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	84 c0                	test   %al,%al
  8012dc:	74 5a                	je     801338 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012de:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e1:	8b 00                	mov    (%eax),%eax
  8012e3:	83 f8 0f             	cmp    $0xf,%eax
  8012e6:	75 07                	jne    8012ef <strsplit+0x6c>
		{
			return 0;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	eb 66                	jmp    801355 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f2:	8b 00                	mov    (%eax),%eax
  8012f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012fa:	89 0a                	mov    %ecx,(%edx)
  8012fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 c2                	add    %eax,%edx
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130d:	eb 03                	jmp    801312 <strsplit+0x8f>
			string++;
  80130f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	74 8b                	je     8012a6 <strsplit+0x23>
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	0f be c0             	movsbl %al,%eax
  801323:	50                   	push   %eax
  801324:	ff 75 0c             	pushl  0xc(%ebp)
  801327:	e8 b5 fa ff ff       	call   800de1 <strchr>
  80132c:	83 c4 08             	add    $0x8,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	74 dc                	je     80130f <strsplit+0x8c>
			string++;
	}
  801333:	e9 6e ff ff ff       	jmp    8012a6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801338:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801339:	8b 45 14             	mov    0x14(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801350:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80135d:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801364:	8b 55 08             	mov    0x8(%ebp),%edx
  801367:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	48                   	dec    %eax
  80136d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801370:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801373:	ba 00 00 00 00       	mov    $0x0,%edx
  801378:	f7 75 ac             	divl   -0x54(%ebp)
  80137b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80137e:	29 d0                	sub    %edx,%eax
  801380:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  80138a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801391:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801398:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80139f:	eb 3f                	jmp    8013e0 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8013a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a4:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	50                   	push   %eax
  8013af:	ff 75 e8             	pushl  -0x18(%ebp)
  8013b2:	68 d0 29 80 00       	push   $0x8029d0
  8013b7:	e8 11 f2 ff ff       	call   8005cd <cprintf>
  8013bc:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8013bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c2:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8013c9:	83 ec 04             	sub    $0x4,%esp
  8013cc:	50                   	push   %eax
  8013cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8013d0:	68 e5 29 80 00       	push   $0x8029e5
  8013d5:	e8 f3 f1 ff ff       	call   8005cd <cprintf>
  8013da:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8013dd:	ff 45 e8             	incl   -0x18(%ebp)
  8013e0:	a1 28 30 80 00       	mov    0x803028,%eax
  8013e5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8013e8:	7c b7                	jl     8013a1 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8013ea:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8013f1:	e9 35 01 00 00       	jmp    80152b <malloc+0x1d4>
		int flag0=1;
  8013f6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8013fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801400:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801403:	eb 5e                	jmp    801463 <malloc+0x10c>
			for(int k=0;k<count;k++){
  801405:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80140c:	eb 35                	jmp    801443 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80140e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801411:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801418:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141b:	39 c2                	cmp    %eax,%edx
  80141d:	77 21                	ja     801440 <malloc+0xe9>
  80141f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801422:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801429:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142c:	39 c2                	cmp    %eax,%edx
  80142e:	76 10                	jbe    801440 <malloc+0xe9>
					ni=PAGE_SIZE;
  801430:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  801437:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  80143e:	eb 0d                	jmp    80144d <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801440:	ff 45 d8             	incl   -0x28(%ebp)
  801443:	a1 28 30 80 00       	mov    0x803028,%eax
  801448:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80144b:	7c c1                	jl     80140e <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  80144d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801451:	74 09                	je     80145c <malloc+0x105>
				flag0=0;
  801453:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  80145a:	eb 16                	jmp    801472 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80145c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801463:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	01 c2                	add    %eax,%edx
  80146b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146e:	39 c2                	cmp    %eax,%edx
  801470:	77 93                	ja     801405 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801472:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801476:	0f 84 a2 00 00 00    	je     80151e <malloc+0x1c7>

			int f=1;
  80147c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801486:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801489:	89 c8                	mov    %ecx,%eax
  80148b:	01 c0                	add    %eax,%eax
  80148d:	01 c8                	add    %ecx,%eax
  80148f:	c1 e0 02             	shl    $0x2,%eax
  801492:	05 20 31 80 00       	add    $0x803120,%eax
  801497:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801499:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a5:	89 d0                	mov    %edx,%eax
  8014a7:	01 c0                	add    %eax,%eax
  8014a9:	01 d0                	add    %edx,%eax
  8014ab:	c1 e0 02             	shl    $0x2,%eax
  8014ae:	05 24 31 80 00       	add    $0x803124,%eax
  8014b3:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8014b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b8:	89 d0                	mov    %edx,%eax
  8014ba:	01 c0                	add    %eax,%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	c1 e0 02             	shl    $0x2,%eax
  8014c1:	05 28 31 80 00       	add    $0x803128,%eax
  8014c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  8014cc:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  8014cf:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8014d6:	eb 36                	jmp    80150e <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  8014d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	01 c2                	add    %eax,%edx
  8014e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014e3:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8014ea:	39 c2                	cmp    %eax,%edx
  8014ec:	73 1d                	jae    80150b <malloc+0x1b4>
					ni=arr_add[l].end-i;
  8014ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014f1:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fb:	29 c2                	sub    %eax,%edx
  8014fd:	89 d0                	mov    %edx,%eax
  8014ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801502:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801509:	eb 0d                	jmp    801518 <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80150b:	ff 45 d0             	incl   -0x30(%ebp)
  80150e:	a1 28 30 80 00       	mov    0x803028,%eax
  801513:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801516:	7c c0                	jl     8014d8 <malloc+0x181>
					break;

				}
			}

			if(f){
  801518:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80151c:	75 1d                	jne    80153b <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  80151e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801528:	01 45 e4             	add    %eax,-0x1c(%ebp)
  80152b:	a1 04 30 80 00       	mov    0x803004,%eax
  801530:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801533:	0f 8c bd fe ff ff    	jl     8013f6 <malloc+0x9f>
  801539:	eb 01                	jmp    80153c <malloc+0x1e5>

				}
			}

			if(f){
				break;
  80153b:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  80153c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801540:	75 7a                	jne    8015bc <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801542:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	01 d0                	add    %edx,%eax
  80154d:	48                   	dec    %eax
  80154e:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801553:	7c 0a                	jl     80155f <malloc+0x208>
			return NULL;
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
  80155a:	e9 a4 02 00 00       	jmp    801803 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  80155f:	a1 04 30 80 00       	mov    0x803004,%eax
  801564:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801567:	a1 28 30 80 00       	mov    0x803028,%eax
  80156c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80156f:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	ff 75 08             	pushl  0x8(%ebp)
  80157c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80157f:	e8 04 06 00 00       	call   801b88 <sys_allocateMem>
  801584:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801587:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	01 d0                	add    %edx,%eax
  801592:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801597:	a1 28 30 80 00       	mov    0x803028,%eax
  80159c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015a2:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8015a9:	a1 28 30 80 00       	mov    0x803028,%eax
  8015ae:	40                   	inc    %eax
  8015af:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8015b4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8015b7:	e9 47 02 00 00       	jmp    801803 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  8015bc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8015c3:	e9 ac 00 00 00       	jmp    801674 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015cb:	89 d0                	mov    %edx,%eax
  8015cd:	01 c0                	add    %eax,%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	c1 e0 02             	shl    $0x2,%eax
  8015d4:	05 24 31 80 00       	add    $0x803124,%eax
  8015d9:	8b 00                	mov    (%eax),%eax
  8015db:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8015de:	eb 7e                	jmp    80165e <malloc+0x307>
			int flag=0;
  8015e0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8015e7:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8015ee:	eb 57                	jmp    801647 <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8015f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015f3:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8015fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015fd:	39 c2                	cmp    %eax,%edx
  8015ff:	77 1a                	ja     80161b <malloc+0x2c4>
  801601:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801604:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80160b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80160e:	39 c2                	cmp    %eax,%edx
  801610:	76 09                	jbe    80161b <malloc+0x2c4>
								flag=1;
  801612:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801619:	eb 36                	jmp    801651 <malloc+0x2fa>
			arr[i].space++;
  80161b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80161e:	89 d0                	mov    %edx,%eax
  801620:	01 c0                	add    %eax,%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	c1 e0 02             	shl    $0x2,%eax
  801627:	05 28 31 80 00       	add    $0x803128,%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 48 01             	lea    0x1(%eax),%ecx
  801631:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801634:	89 d0                	mov    %edx,%eax
  801636:	01 c0                	add    %eax,%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c1 e0 02             	shl    $0x2,%eax
  80163d:	05 28 31 80 00       	add    $0x803128,%eax
  801642:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801644:	ff 45 c0             	incl   -0x40(%ebp)
  801647:	a1 28 30 80 00       	mov    0x803028,%eax
  80164c:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80164f:	7c 9f                	jl     8015f0 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801651:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801655:	75 19                	jne    801670 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801657:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80165e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801661:	a1 04 30 80 00       	mov    0x803004,%eax
  801666:	39 c2                	cmp    %eax,%edx
  801668:	0f 82 72 ff ff ff    	jb     8015e0 <malloc+0x289>
  80166e:	eb 01                	jmp    801671 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801670:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801671:	ff 45 cc             	incl   -0x34(%ebp)
  801674:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801677:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167a:	0f 8c 48 ff ff ff    	jl     8015c8 <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801680:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801687:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  80168e:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801695:	eb 37                	jmp    8016ce <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801697:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80169a:	89 d0                	mov    %edx,%eax
  80169c:	01 c0                	add    %eax,%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	c1 e0 02             	shl    $0x2,%eax
  8016a3:	05 28 31 80 00       	add    $0x803128,%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8016ad:	7d 1c                	jge    8016cb <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8016af:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016b2:	89 d0                	mov    %edx,%eax
  8016b4:	01 c0                	add    %eax,%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	c1 e0 02             	shl    $0x2,%eax
  8016bb:	05 28 31 80 00       	add    $0x803128,%eax
  8016c0:	8b 00                	mov    (%eax),%eax
  8016c2:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  8016c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8016c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  8016cb:	ff 45 b4             	incl   -0x4c(%ebp)
  8016ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8016d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016d4:	7c c1                	jl     801697 <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  8016d6:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016dc:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8016df:	89 c8                	mov    %ecx,%eax
  8016e1:	01 c0                	add    %eax,%eax
  8016e3:	01 c8                	add    %ecx,%eax
  8016e5:	c1 e0 02             	shl    $0x2,%eax
  8016e8:	05 20 31 80 00       	add    $0x803120,%eax
  8016ed:	8b 00                	mov    (%eax),%eax
  8016ef:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  8016f6:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016fc:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8016ff:	89 c8                	mov    %ecx,%eax
  801701:	01 c0                	add    %eax,%eax
  801703:	01 c8                	add    %ecx,%eax
  801705:	c1 e0 02             	shl    $0x2,%eax
  801708:	05 24 31 80 00       	add    $0x803124,%eax
  80170d:	8b 00                	mov    (%eax),%eax
  80170f:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801716:	a1 28 30 80 00       	mov    0x803028,%eax
  80171b:	40                   	inc    %eax
  80171c:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801721:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801724:	89 d0                	mov    %edx,%eax
  801726:	01 c0                	add    %eax,%eax
  801728:	01 d0                	add    %edx,%eax
  80172a:	c1 e0 02             	shl    $0x2,%eax
  80172d:	05 20 31 80 00       	add    $0x803120,%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	ff 75 08             	pushl  0x8(%ebp)
  80173a:	50                   	push   %eax
  80173b:	e8 48 04 00 00       	call   801b88 <sys_allocateMem>
  801740:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801743:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  80174a:	eb 78                	jmp    8017c4 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  80174c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	01 c0                	add    %eax,%eax
  801753:	01 d0                	add    %edx,%eax
  801755:	c1 e0 02             	shl    $0x2,%eax
  801758:	05 20 31 80 00       	add    $0x803120,%eax
  80175d:	8b 00                	mov    (%eax),%eax
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	50                   	push   %eax
  801763:	ff 75 b0             	pushl  -0x50(%ebp)
  801766:	68 d0 29 80 00       	push   $0x8029d0
  80176b:	e8 5d ee ff ff       	call   8005cd <cprintf>
  801770:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801773:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801776:	89 d0                	mov    %edx,%eax
  801778:	01 c0                	add    %eax,%eax
  80177a:	01 d0                	add    %edx,%eax
  80177c:	c1 e0 02             	shl    $0x2,%eax
  80177f:	05 24 31 80 00       	add    $0x803124,%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	50                   	push   %eax
  80178a:	ff 75 b0             	pushl  -0x50(%ebp)
  80178d:	68 e5 29 80 00       	push   $0x8029e5
  801792:	e8 36 ee ff ff       	call   8005cd <cprintf>
  801797:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80179a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80179d:	89 d0                	mov    %edx,%eax
  80179f:	01 c0                	add    %eax,%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	c1 e0 02             	shl    $0x2,%eax
  8017a6:	05 28 31 80 00       	add    $0x803128,%eax
  8017ab:	8b 00                	mov    (%eax),%eax
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	50                   	push   %eax
  8017b1:	ff 75 b0             	pushl  -0x50(%ebp)
  8017b4:	68 f8 29 80 00       	push   $0x8029f8
  8017b9:	e8 0f ee ff ff       	call   8005cd <cprintf>
  8017be:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  8017c1:	ff 45 b0             	incl   -0x50(%ebp)
  8017c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8017c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ca:	7c 80                	jl     80174c <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  8017cc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017cf:	89 d0                	mov    %edx,%eax
  8017d1:	01 c0                	add    %eax,%eax
  8017d3:	01 d0                	add    %edx,%eax
  8017d5:	c1 e0 02             	shl    $0x2,%eax
  8017d8:	05 20 31 80 00       	add    $0x803120,%eax
  8017dd:	8b 00                	mov    (%eax),%eax
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	50                   	push   %eax
  8017e3:	68 0c 2a 80 00       	push   $0x802a0c
  8017e8:	e8 e0 ed ff ff       	call   8005cd <cprintf>
  8017ed:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8017f0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	01 c0                	add    %eax,%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	c1 e0 02             	shl    $0x2,%eax
  8017fc:	05 20 31 80 00       	add    $0x803120,%eax
  801801:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801811:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801818:	eb 4b                	jmp    801865 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80181a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801824:	89 c2                	mov    %eax,%edx
  801826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801829:	39 c2                	cmp    %eax,%edx
  80182b:	7f 35                	jg     801862 <free+0x5d>
  80182d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801830:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801837:	89 c2                	mov    %eax,%edx
  801839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183c:	39 c2                	cmp    %eax,%edx
  80183e:	7e 22                	jle    801862 <free+0x5d>
				start=arr_add[i].start;
  801840:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801843:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80184a:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  80184d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801850:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801857:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  80185a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801860:	eb 0d                	jmp    80186f <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801862:	ff 45 ec             	incl   -0x14(%ebp)
  801865:	a1 28 30 80 00       	mov    0x803028,%eax
  80186a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80186d:	7c ab                	jl     80181a <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  80186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801872:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801883:	29 c2                	sub    %eax,%edx
  801885:	89 d0                	mov    %edx,%eax
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	50                   	push   %eax
  80188b:	ff 75 f4             	pushl  -0xc(%ebp)
  80188e:	e8 d9 02 00 00       	call   801b6c <sys_freeMem>
  801893:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80189c:	eb 2d                	jmp    8018cb <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  80189e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a1:	40                   	inc    %eax
  8018a2:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8018a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ac:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8018b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b6:	40                   	inc    %eax
  8018b7:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c1:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  8018c8:	ff 45 e8             	incl   -0x18(%ebp)
  8018cb:	a1 28 30 80 00       	mov    0x803028,%eax
  8018d0:	48                   	dec    %eax
  8018d1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018d4:	7f c8                	jg     80189e <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  8018d6:	a1 28 30 80 00       	mov    0x803028,%eax
  8018db:	48                   	dec    %eax
  8018dc:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8018e1:	90                   	nop
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 18             	sub    $0x18,%esp
  8018ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ed:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	68 28 2a 80 00       	push   $0x802a28
  8018f8:	68 18 01 00 00       	push   $0x118
  8018fd:	68 4b 2a 80 00       	push   $0x802a4b
  801902:	e8 24 ea ff ff       	call   80032b <_panic>

00801907 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	68 28 2a 80 00       	push   $0x802a28
  801915:	68 1e 01 00 00       	push   $0x11e
  80191a:	68 4b 2a 80 00       	push   $0x802a4b
  80191f:	e8 07 ea ff ff       	call   80032b <_panic>

00801924 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80192a:	83 ec 04             	sub    $0x4,%esp
  80192d:	68 28 2a 80 00       	push   $0x802a28
  801932:	68 24 01 00 00       	push   $0x124
  801937:	68 4b 2a 80 00       	push   $0x802a4b
  80193c:	e8 ea e9 ff ff       	call   80032b <_panic>

00801941 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	68 28 2a 80 00       	push   $0x802a28
  80194f:	68 29 01 00 00       	push   $0x129
  801954:	68 4b 2a 80 00       	push   $0x802a4b
  801959:	e8 cd e9 ff ff       	call   80032b <_panic>

0080195e <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801964:	83 ec 04             	sub    $0x4,%esp
  801967:	68 28 2a 80 00       	push   $0x802a28
  80196c:	68 2f 01 00 00       	push   $0x12f
  801971:	68 4b 2a 80 00       	push   $0x802a4b
  801976:	e8 b0 e9 ff ff       	call   80032b <_panic>

0080197b <shrink>:
}
void shrink(uint32 newSize)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801981:	83 ec 04             	sub    $0x4,%esp
  801984:	68 28 2a 80 00       	push   $0x802a28
  801989:	68 33 01 00 00       	push   $0x133
  80198e:	68 4b 2a 80 00       	push   $0x802a4b
  801993:	e8 93 e9 ff ff       	call   80032b <_panic>

00801998 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	68 28 2a 80 00       	push   $0x802a28
  8019a6:	68 38 01 00 00       	push   $0x138
  8019ab:	68 4b 2a 80 00       	push   $0x802a4b
  8019b0:	e8 76 e9 ff ff       	call   80032b <_panic>

008019b5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	57                   	push   %edi
  8019b9:	56                   	push   %esi
  8019ba:	53                   	push   %ebx
  8019bb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ca:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019cd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019d0:	cd 30                	int    $0x30
  8019d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5f                   	pop    %edi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	52                   	push   %edx
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	50                   	push   %eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	e8 b2 ff ff ff       	call   8019b5 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	90                   	nop
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 01                	push   $0x1
  801a18:	e8 98 ff ff ff       	call   8019b5 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	50                   	push   %eax
  801a31:	6a 05                	push   $0x5
  801a33:	e8 7d ff ff ff       	call   8019b5 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 02                	push   $0x2
  801a4c:	e8 64 ff ff ff       	call   8019b5 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 03                	push   $0x3
  801a65:	e8 4b ff ff ff       	call   8019b5 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 04                	push   $0x4
  801a7e:	e8 32 ff ff ff       	call   8019b5 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_env_exit>:


void sys_env_exit(void)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 06                	push   $0x6
  801a97:	e8 19 ff ff ff       	call   8019b5 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	90                   	nop
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	52                   	push   %edx
  801ab2:	50                   	push   %eax
  801ab3:	6a 07                	push   $0x7
  801ab5:	e8 fb fe ff ff       	call   8019b5 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ac4:	8b 75 18             	mov    0x18(%ebp),%esi
  801ac7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	56                   	push   %esi
  801ad4:	53                   	push   %ebx
  801ad5:	51                   	push   %ecx
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 08                	push   $0x8
  801ada:	e8 d6 fe ff ff       	call   8019b5 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	6a 09                	push   $0x9
  801afc:	e8 b4 fe ff ff       	call   8019b5 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	ff 75 08             	pushl  0x8(%ebp)
  801b15:	6a 0a                	push   $0xa
  801b17:	e8 99 fe ff ff       	call   8019b5 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 0b                	push   $0xb
  801b30:	e8 80 fe ff ff       	call   8019b5 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 0c                	push   $0xc
  801b49:	e8 67 fe ff ff       	call   8019b5 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 0d                	push   $0xd
  801b62:	e8 4e fe ff ff       	call   8019b5 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 11                	push   $0x11
  801b7d:	e8 33 fe ff ff       	call   8019b5 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	ff 75 08             	pushl  0x8(%ebp)
  801b97:	6a 12                	push   $0x12
  801b99:	e8 17 fe ff ff       	call   8019b5 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 0e                	push   $0xe
  801bb3:	e8 fd fd ff ff       	call   8019b5 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	6a 0f                	push   $0xf
  801bcd:	e8 e3 fd ff ff       	call   8019b5 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 10                	push   $0x10
  801be6:	e8 ca fd ff ff       	call   8019b5 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 14                	push   $0x14
  801c00:	e8 b0 fd ff ff       	call   8019b5 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 15                	push   $0x15
  801c1a:	e8 96 fd ff ff       	call   8019b5 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	90                   	nop
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c31:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	50                   	push   %eax
  801c3e:	6a 16                	push   $0x16
  801c40:	e8 70 fd ff ff       	call   8019b5 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	90                   	nop
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 17                	push   $0x17
  801c5a:	e8 56 fd ff ff       	call   8019b5 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	90                   	nop
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	50                   	push   %eax
  801c75:	6a 18                	push   $0x18
  801c77:	e8 39 fd ff ff       	call   8019b5 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	52                   	push   %edx
  801c91:	50                   	push   %eax
  801c92:	6a 1b                	push   $0x1b
  801c94:	e8 1c fd ff ff       	call   8019b5 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	52                   	push   %edx
  801cae:	50                   	push   %eax
  801caf:	6a 19                	push   $0x19
  801cb1:	e8 ff fc ff ff       	call   8019b5 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	90                   	nop
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	6a 1a                	push   $0x1a
  801ccf:	e8 e1 fc ff ff       	call   8019b5 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ce6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	51                   	push   %ecx
  801cf3:	52                   	push   %edx
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	50                   	push   %eax
  801cf8:	6a 1c                	push   $0x1c
  801cfa:	e8 b6 fc ff ff       	call   8019b5 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 1d                	push   $0x1d
  801d17:	e8 99 fc ff ff       	call   8019b5 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	51                   	push   %ecx
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	6a 1e                	push   $0x1e
  801d36:	e8 7a fc ff ff       	call   8019b5 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	6a 1f                	push   $0x1f
  801d53:	e8 5d fc ff ff       	call   8019b5 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 20                	push   $0x20
  801d6c:	e8 44 fc ff ff       	call   8019b5 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	6a 00                	push   $0x0
  801d7e:	ff 75 14             	pushl  0x14(%ebp)
  801d81:	ff 75 10             	pushl  0x10(%ebp)
  801d84:	ff 75 0c             	pushl  0xc(%ebp)
  801d87:	50                   	push   %eax
  801d88:	6a 21                	push   $0x21
  801d8a:	e8 26 fc ff ff       	call   8019b5 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	50                   	push   %eax
  801da3:	6a 22                	push   $0x22
  801da5:	e8 0b fc ff ff       	call   8019b5 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	90                   	nop
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	50                   	push   %eax
  801dbf:	6a 23                	push   $0x23
  801dc1:	e8 ef fb ff ff       	call   8019b5 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	90                   	nop
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dd2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd5:	8d 50 04             	lea    0x4(%eax),%edx
  801dd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	52                   	push   %edx
  801de2:	50                   	push   %eax
  801de3:	6a 24                	push   $0x24
  801de5:	e8 cb fb ff ff       	call   8019b5 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return result;
  801ded:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801df6:	89 01                	mov    %eax,(%ecx)
  801df8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	c9                   	leave  
  801dff:	c2 04 00             	ret    $0x4

00801e02 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	ff 75 10             	pushl  0x10(%ebp)
  801e0c:	ff 75 0c             	pushl  0xc(%ebp)
  801e0f:	ff 75 08             	pushl  0x8(%ebp)
  801e12:	6a 13                	push   $0x13
  801e14:	e8 9c fb ff ff       	call   8019b5 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1c:	90                   	nop
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_rcr2>:
uint32 sys_rcr2()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 25                	push   $0x25
  801e2e:	e8 82 fb ff ff       	call   8019b5 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e44:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	50                   	push   %eax
  801e51:	6a 26                	push   $0x26
  801e53:	e8 5d fb ff ff       	call   8019b5 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5b:	90                   	nop
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <rsttst>:
void rsttst()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 28                	push   $0x28
  801e6d:	e8 43 fb ff ff       	call   8019b5 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
	return ;
  801e75:	90                   	nop
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e84:	8b 55 18             	mov    0x18(%ebp),%edx
  801e87:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e8b:	52                   	push   %edx
  801e8c:	50                   	push   %eax
  801e8d:	ff 75 10             	pushl  0x10(%ebp)
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	6a 27                	push   $0x27
  801e98:	e8 18 fb ff ff       	call   8019b5 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea0:	90                   	nop
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <chktst>:
void chktst(uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	ff 75 08             	pushl  0x8(%ebp)
  801eb1:	6a 29                	push   $0x29
  801eb3:	e8 fd fa ff ff       	call   8019b5 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebb:	90                   	nop
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <inctst>:

void inctst()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 2a                	push   $0x2a
  801ecd:	e8 e3 fa ff ff       	call   8019b5 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <gettst>:
uint32 gettst()
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 2b                	push   $0x2b
  801ee7:	e8 c9 fa ff ff       	call   8019b5 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 2c                	push   $0x2c
  801f03:	e8 ad fa ff ff       	call   8019b5 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
  801f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f0e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f12:	75 07                	jne    801f1b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f14:	b8 01 00 00 00       	mov    $0x1,%eax
  801f19:	eb 05                	jmp    801f20 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 2c                	push   $0x2c
  801f34:	e8 7c fa ff ff       	call   8019b5 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
  801f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f3f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f43:	75 07                	jne    801f4c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f45:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4a:	eb 05                	jmp    801f51 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 2c                	push   $0x2c
  801f65:	e8 4b fa ff ff       	call   8019b5 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
  801f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f70:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f74:	75 07                	jne    801f7d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f76:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7b:	eb 05                	jmp    801f82 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 2c                	push   $0x2c
  801f96:	e8 1a fa ff ff       	call   8019b5 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
  801f9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fa1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fa5:	75 07                	jne    801fae <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fac:	eb 05                	jmp    801fb3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	ff 75 08             	pushl  0x8(%ebp)
  801fc3:	6a 2d                	push   $0x2d
  801fc5:	e8 eb f9 ff ff       	call   8019b5 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcd:	90                   	nop
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fd4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	53                   	push   %ebx
  801fe3:	51                   	push   %ecx
  801fe4:	52                   	push   %edx
  801fe5:	50                   	push   %eax
  801fe6:	6a 2e                	push   $0x2e
  801fe8:	e8 c8 f9 ff ff       	call   8019b5 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 2f                	push   $0x2f
  802008:	e8 a8 f9 ff ff       	call   8019b5 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    
  802012:	66 90                	xchg   %ax,%ax

00802014 <__udivdi3>:
  802014:	55                   	push   %ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	83 ec 1c             	sub    $0x1c,%esp
  80201b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80201f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802023:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802027:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80202b:	89 ca                	mov    %ecx,%edx
  80202d:	89 f8                	mov    %edi,%eax
  80202f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802033:	85 f6                	test   %esi,%esi
  802035:	75 2d                	jne    802064 <__udivdi3+0x50>
  802037:	39 cf                	cmp    %ecx,%edi
  802039:	77 65                	ja     8020a0 <__udivdi3+0x8c>
  80203b:	89 fd                	mov    %edi,%ebp
  80203d:	85 ff                	test   %edi,%edi
  80203f:	75 0b                	jne    80204c <__udivdi3+0x38>
  802041:	b8 01 00 00 00       	mov    $0x1,%eax
  802046:	31 d2                	xor    %edx,%edx
  802048:	f7 f7                	div    %edi
  80204a:	89 c5                	mov    %eax,%ebp
  80204c:	31 d2                	xor    %edx,%edx
  80204e:	89 c8                	mov    %ecx,%eax
  802050:	f7 f5                	div    %ebp
  802052:	89 c1                	mov    %eax,%ecx
  802054:	89 d8                	mov    %ebx,%eax
  802056:	f7 f5                	div    %ebp
  802058:	89 cf                	mov    %ecx,%edi
  80205a:	89 fa                	mov    %edi,%edx
  80205c:	83 c4 1c             	add    $0x1c,%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    
  802064:	39 ce                	cmp    %ecx,%esi
  802066:	77 28                	ja     802090 <__udivdi3+0x7c>
  802068:	0f bd fe             	bsr    %esi,%edi
  80206b:	83 f7 1f             	xor    $0x1f,%edi
  80206e:	75 40                	jne    8020b0 <__udivdi3+0x9c>
  802070:	39 ce                	cmp    %ecx,%esi
  802072:	72 0a                	jb     80207e <__udivdi3+0x6a>
  802074:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802078:	0f 87 9e 00 00 00    	ja     80211c <__udivdi3+0x108>
  80207e:	b8 01 00 00 00       	mov    $0x1,%eax
  802083:	89 fa                	mov    %edi,%edx
  802085:	83 c4 1c             	add    $0x1c,%esp
  802088:	5b                   	pop    %ebx
  802089:	5e                   	pop    %esi
  80208a:	5f                   	pop    %edi
  80208b:	5d                   	pop    %ebp
  80208c:	c3                   	ret    
  80208d:	8d 76 00             	lea    0x0(%esi),%esi
  802090:	31 ff                	xor    %edi,%edi
  802092:	31 c0                	xor    %eax,%eax
  802094:	89 fa                	mov    %edi,%edx
  802096:	83 c4 1c             	add    $0x1c,%esp
  802099:	5b                   	pop    %ebx
  80209a:	5e                   	pop    %esi
  80209b:	5f                   	pop    %edi
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    
  80209e:	66 90                	xchg   %ax,%ax
  8020a0:	89 d8                	mov    %ebx,%eax
  8020a2:	f7 f7                	div    %edi
  8020a4:	31 ff                	xor    %edi,%edi
  8020a6:	89 fa                	mov    %edi,%edx
  8020a8:	83 c4 1c             	add    $0x1c,%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5e                   	pop    %esi
  8020ad:	5f                   	pop    %edi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    
  8020b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020b5:	89 eb                	mov    %ebp,%ebx
  8020b7:	29 fb                	sub    %edi,%ebx
  8020b9:	89 f9                	mov    %edi,%ecx
  8020bb:	d3 e6                	shl    %cl,%esi
  8020bd:	89 c5                	mov    %eax,%ebp
  8020bf:	88 d9                	mov    %bl,%cl
  8020c1:	d3 ed                	shr    %cl,%ebp
  8020c3:	89 e9                	mov    %ebp,%ecx
  8020c5:	09 f1                	or     %esi,%ecx
  8020c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020cb:	89 f9                	mov    %edi,%ecx
  8020cd:	d3 e0                	shl    %cl,%eax
  8020cf:	89 c5                	mov    %eax,%ebp
  8020d1:	89 d6                	mov    %edx,%esi
  8020d3:	88 d9                	mov    %bl,%cl
  8020d5:	d3 ee                	shr    %cl,%esi
  8020d7:	89 f9                	mov    %edi,%ecx
  8020d9:	d3 e2                	shl    %cl,%edx
  8020db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020df:	88 d9                	mov    %bl,%cl
  8020e1:	d3 e8                	shr    %cl,%eax
  8020e3:	09 c2                	or     %eax,%edx
  8020e5:	89 d0                	mov    %edx,%eax
  8020e7:	89 f2                	mov    %esi,%edx
  8020e9:	f7 74 24 0c          	divl   0xc(%esp)
  8020ed:	89 d6                	mov    %edx,%esi
  8020ef:	89 c3                	mov    %eax,%ebx
  8020f1:	f7 e5                	mul    %ebp
  8020f3:	39 d6                	cmp    %edx,%esi
  8020f5:	72 19                	jb     802110 <__udivdi3+0xfc>
  8020f7:	74 0b                	je     802104 <__udivdi3+0xf0>
  8020f9:	89 d8                	mov    %ebx,%eax
  8020fb:	31 ff                	xor    %edi,%edi
  8020fd:	e9 58 ff ff ff       	jmp    80205a <__udivdi3+0x46>
  802102:	66 90                	xchg   %ax,%ax
  802104:	8b 54 24 08          	mov    0x8(%esp),%edx
  802108:	89 f9                	mov    %edi,%ecx
  80210a:	d3 e2                	shl    %cl,%edx
  80210c:	39 c2                	cmp    %eax,%edx
  80210e:	73 e9                	jae    8020f9 <__udivdi3+0xe5>
  802110:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802113:	31 ff                	xor    %edi,%edi
  802115:	e9 40 ff ff ff       	jmp    80205a <__udivdi3+0x46>
  80211a:	66 90                	xchg   %ax,%ax
  80211c:	31 c0                	xor    %eax,%eax
  80211e:	e9 37 ff ff ff       	jmp    80205a <__udivdi3+0x46>
  802123:	90                   	nop

00802124 <__umoddi3>:
  802124:	55                   	push   %ebp
  802125:	57                   	push   %edi
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	83 ec 1c             	sub    $0x1c,%esp
  80212b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80212f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802137:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80213b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80213f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802143:	89 f3                	mov    %esi,%ebx
  802145:	89 fa                	mov    %edi,%edx
  802147:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80214b:	89 34 24             	mov    %esi,(%esp)
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 1a                	jne    80216c <__umoddi3+0x48>
  802152:	39 f7                	cmp    %esi,%edi
  802154:	0f 86 a2 00 00 00    	jbe    8021fc <__umoddi3+0xd8>
  80215a:	89 c8                	mov    %ecx,%eax
  80215c:	89 f2                	mov    %esi,%edx
  80215e:	f7 f7                	div    %edi
  802160:	89 d0                	mov    %edx,%eax
  802162:	31 d2                	xor    %edx,%edx
  802164:	83 c4 1c             	add    $0x1c,%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
  80216c:	39 f0                	cmp    %esi,%eax
  80216e:	0f 87 ac 00 00 00    	ja     802220 <__umoddi3+0xfc>
  802174:	0f bd e8             	bsr    %eax,%ebp
  802177:	83 f5 1f             	xor    $0x1f,%ebp
  80217a:	0f 84 ac 00 00 00    	je     80222c <__umoddi3+0x108>
  802180:	bf 20 00 00 00       	mov    $0x20,%edi
  802185:	29 ef                	sub    %ebp,%edi
  802187:	89 fe                	mov    %edi,%esi
  802189:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80218d:	89 e9                	mov    %ebp,%ecx
  80218f:	d3 e0                	shl    %cl,%eax
  802191:	89 d7                	mov    %edx,%edi
  802193:	89 f1                	mov    %esi,%ecx
  802195:	d3 ef                	shr    %cl,%edi
  802197:	09 c7                	or     %eax,%edi
  802199:	89 e9                	mov    %ebp,%ecx
  80219b:	d3 e2                	shl    %cl,%edx
  80219d:	89 14 24             	mov    %edx,(%esp)
  8021a0:	89 d8                	mov    %ebx,%eax
  8021a2:	d3 e0                	shl    %cl,%eax
  8021a4:	89 c2                	mov    %eax,%edx
  8021a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021aa:	d3 e0                	shl    %cl,%eax
  8021ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021b4:	89 f1                	mov    %esi,%ecx
  8021b6:	d3 e8                	shr    %cl,%eax
  8021b8:	09 d0                	or     %edx,%eax
  8021ba:	d3 eb                	shr    %cl,%ebx
  8021bc:	89 da                	mov    %ebx,%edx
  8021be:	f7 f7                	div    %edi
  8021c0:	89 d3                	mov    %edx,%ebx
  8021c2:	f7 24 24             	mull   (%esp)
  8021c5:	89 c6                	mov    %eax,%esi
  8021c7:	89 d1                	mov    %edx,%ecx
  8021c9:	39 d3                	cmp    %edx,%ebx
  8021cb:	0f 82 87 00 00 00    	jb     802258 <__umoddi3+0x134>
  8021d1:	0f 84 91 00 00 00    	je     802268 <__umoddi3+0x144>
  8021d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021db:	29 f2                	sub    %esi,%edx
  8021dd:	19 cb                	sbb    %ecx,%ebx
  8021df:	89 d8                	mov    %ebx,%eax
  8021e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8021e5:	d3 e0                	shl    %cl,%eax
  8021e7:	89 e9                	mov    %ebp,%ecx
  8021e9:	d3 ea                	shr    %cl,%edx
  8021eb:	09 d0                	or     %edx,%eax
  8021ed:	89 e9                	mov    %ebp,%ecx
  8021ef:	d3 eb                	shr    %cl,%ebx
  8021f1:	89 da                	mov    %ebx,%edx
  8021f3:	83 c4 1c             	add    $0x1c,%esp
  8021f6:	5b                   	pop    %ebx
  8021f7:	5e                   	pop    %esi
  8021f8:	5f                   	pop    %edi
  8021f9:	5d                   	pop    %ebp
  8021fa:	c3                   	ret    
  8021fb:	90                   	nop
  8021fc:	89 fd                	mov    %edi,%ebp
  8021fe:	85 ff                	test   %edi,%edi
  802200:	75 0b                	jne    80220d <__umoddi3+0xe9>
  802202:	b8 01 00 00 00       	mov    $0x1,%eax
  802207:	31 d2                	xor    %edx,%edx
  802209:	f7 f7                	div    %edi
  80220b:	89 c5                	mov    %eax,%ebp
  80220d:	89 f0                	mov    %esi,%eax
  80220f:	31 d2                	xor    %edx,%edx
  802211:	f7 f5                	div    %ebp
  802213:	89 c8                	mov    %ecx,%eax
  802215:	f7 f5                	div    %ebp
  802217:	89 d0                	mov    %edx,%eax
  802219:	e9 44 ff ff ff       	jmp    802162 <__umoddi3+0x3e>
  80221e:	66 90                	xchg   %ax,%ax
  802220:	89 c8                	mov    %ecx,%eax
  802222:	89 f2                	mov    %esi,%edx
  802224:	83 c4 1c             	add    $0x1c,%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5f                   	pop    %edi
  80222a:	5d                   	pop    %ebp
  80222b:	c3                   	ret    
  80222c:	3b 04 24             	cmp    (%esp),%eax
  80222f:	72 06                	jb     802237 <__umoddi3+0x113>
  802231:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802235:	77 0f                	ja     802246 <__umoddi3+0x122>
  802237:	89 f2                	mov    %esi,%edx
  802239:	29 f9                	sub    %edi,%ecx
  80223b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80223f:	89 14 24             	mov    %edx,(%esp)
  802242:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802246:	8b 44 24 04          	mov    0x4(%esp),%eax
  80224a:	8b 14 24             	mov    (%esp),%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	2b 04 24             	sub    (%esp),%eax
  80225b:	19 fa                	sbb    %edi,%edx
  80225d:	89 d1                	mov    %edx,%ecx
  80225f:	89 c6                	mov    %eax,%esi
  802261:	e9 71 ff ff ff       	jmp    8021d7 <__umoddi3+0xb3>
  802266:	66 90                	xchg   %ax,%ax
  802268:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80226c:	72 ea                	jb     802258 <__umoddi3+0x134>
  80226e:	89 d9                	mov    %ebx,%ecx
  802270:	e9 62 ff ff ff       	jmp    8021d7 <__umoddi3+0xb3>
