
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 40 23 80 00       	push   $0x802340
  80004a:	e8 99 18 00 00       	call   8018e8 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 42 23 80 00       	push   $0x802342
  80006e:	e8 75 18 00 00       	call   8018e8 <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 49 23 80 00       	push   $0x802349
  8000ab:	e8 b9 1b 00 00       	call   801c69 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 4b 23 80 00       	push   $0x80234b
  8000bf:	e8 24 18 00 00       	call   8018e8 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d8:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 59 23 80 00       	push   $0x802359
  8000f1:	e8 84 1c 00 00       	call   801d7a <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800101:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 30 80 00       	mov    0x803020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 63 23 80 00       	push   $0x802363
  80011a:	e8 5b 1c 00 00       	call   801d7a <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 6d 23 80 00       	push   $0x80236d
  800139:	6a 27                	push   $0x27
  80013b:	68 82 23 80 00       	push   $0x802382
  800140:	e8 ea 01 00 00       	call   80032f <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 48 1c 00 00       	call   801d98 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 b6 1e 00 00       	call   802016 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 2a 1c 00 00       	call   801d98 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 9d 23 80 00       	push   $0x80239d
  80018a:	e8 42 04 00 00       	call   8005d1 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 dc 18 00 00       	call   801a73 <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 4b 23 80 00       	push   $0x80234b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 54 17 00 00       	call   80190b <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_free_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 ec 1b 00 00       	call   801db4 <sys_free_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_free_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 de 1b 00 00       	call   801db4 <sys_free_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 65 18 00 00       	call   801a5a <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800209:	01 c8                	add    %ecx,%eax
  80020b:	01 c0                	add    %eax,%eax
  80020d:	01 d0                	add    %edx,%eax
  80020f:	01 c0                	add    %eax,%eax
  800211:	01 d0                	add    %edx,%eax
  800213:	89 c2                	mov    %eax,%edx
  800215:	c1 e2 05             	shl    $0x5,%edx
  800218:	29 c2                	sub    %eax,%edx
  80021a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800221:	89 c2                	mov    %eax,%edx
  800223:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800229:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800239:	84 c0                	test   %al,%al
  80023b:	74 0f                	je     80024c <libmain+0x62>
		binaryname = myEnv->prog_name;
  80023d:	a1 20 30 80 00       	mov    0x803020,%eax
  800242:	05 40 3c 01 00       	add    $0x13c40,%eax
  800247:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800250:	7e 0a                	jle    80025c <libmain+0x72>
		binaryname = argv[0];
  800252:	8b 45 0c             	mov    0xc(%ebp),%eax
  800255:	8b 00                	mov    (%eax),%eax
  800257:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	ff 75 0c             	pushl  0xc(%ebp)
  800262:	ff 75 08             	pushl  0x8(%ebp)
  800265:	e8 ce fd ff ff       	call   800038 <_main>
  80026a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026d:	e8 83 19 00 00       	call   801bf5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 cc 23 80 00       	push   $0x8023cc
  80027a:	e8 52 03 00 00       	call   8005d1 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800282:	a1 20 30 80 00       	mov    0x803020,%eax
  800287:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80028d:	a1 20 30 80 00       	mov    0x803020,%eax
  800292:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	52                   	push   %edx
  80029c:	50                   	push   %eax
  80029d:	68 f4 23 80 00       	push   $0x8023f4
  8002a2:	e8 2a 03 00 00       	call   8005d1 <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002af:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ba:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8002c0:	83 ec 04             	sub    $0x4,%esp
  8002c3:	52                   	push   %edx
  8002c4:	50                   	push   %eax
  8002c5:	68 1c 24 80 00       	push   $0x80241c
  8002ca:	e8 02 03 00 00       	call   8005d1 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d7:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 5d 24 80 00       	push   $0x80245d
  8002e6:	e8 e6 02 00 00       	call   8005d1 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 cc 23 80 00       	push   $0x8023cc
  8002f6:	e8 d6 02 00 00       	call   8005d1 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002fe:	e8 0c 19 00 00       	call   801c0f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800303:	e8 19 00 00 00       	call   800321 <exit>
}
  800308:	90                   	nop
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	6a 00                	push   $0x0
  800316:	e8 0b 17 00 00       	call   801a26 <sys_env_destroy>
  80031b:	83 c4 10             	add    $0x10,%esp
}
  80031e:	90                   	nop
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <exit>:

void
exit(void)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800327:	e8 60 17 00 00       	call   801a8c <sys_env_exit>
}
  80032c:	90                   	nop
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800335:	8d 45 10             	lea    0x10(%ebp),%eax
  800338:	83 c0 04             	add    $0x4,%eax
  80033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80033e:	a1 18 31 80 00       	mov    0x803118,%eax
  800343:	85 c0                	test   %eax,%eax
  800345:	74 16                	je     80035d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800347:	a1 18 31 80 00       	mov    0x803118,%eax
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	50                   	push   %eax
  800350:	68 74 24 80 00       	push   $0x802474
  800355:	e8 77 02 00 00       	call   8005d1 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80035d:	a1 00 30 80 00       	mov    0x803000,%eax
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	50                   	push   %eax
  800369:	68 79 24 80 00       	push   $0x802479
  80036e:	e8 5e 02 00 00       	call   8005d1 <cprintf>
  800373:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800376:	8b 45 10             	mov    0x10(%ebp),%eax
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	ff 75 f4             	pushl  -0xc(%ebp)
  80037f:	50                   	push   %eax
  800380:	e8 e1 01 00 00       	call   800566 <vcprintf>
  800385:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	6a 00                	push   $0x0
  80038d:	68 95 24 80 00       	push   $0x802495
  800392:	e8 cf 01 00 00       	call   800566 <vcprintf>
  800397:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80039a:	e8 82 ff ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  80039f:	eb fe                	jmp    80039f <_panic+0x70>

008003a1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ac:	8b 50 74             	mov    0x74(%eax),%edx
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	39 c2                	cmp    %eax,%edx
  8003b4:	74 14                	je     8003ca <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	68 98 24 80 00       	push   $0x802498
  8003be:	6a 26                	push   $0x26
  8003c0:	68 e4 24 80 00       	push   $0x8024e4
  8003c5:	e8 65 ff ff ff       	call   80032f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	e9 b6 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8003dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	01 d0                	add    %edx,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	75 08                	jne    8003fa <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f5:	e9 96 00 00 00       	jmp    800490 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800401:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800408:	eb 5d                	jmp    800467 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80040a:	a1 20 30 80 00       	mov    0x803020,%eax
  80040f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800415:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800418:	c1 e2 04             	shl    $0x4,%edx
  80041b:	01 d0                	add    %edx,%eax
  80041d:	8a 40 04             	mov    0x4(%eax),%al
  800420:	84 c0                	test   %al,%al
  800422:	75 40                	jne    800464 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80042f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800432:	c1 e2 04             	shl    $0x4,%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800444:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800449:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	01 c8                	add    %ecx,%eax
  800455:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800457:	39 c2                	cmp    %eax,%edx
  800459:	75 09                	jne    800464 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80045b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800462:	eb 12                	jmp    800476 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800464:	ff 45 e8             	incl   -0x18(%ebp)
  800467:	a1 20 30 80 00       	mov    0x803020,%eax
  80046c:	8b 50 74             	mov    0x74(%eax),%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	77 94                	ja     80040a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800476:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047a:	75 14                	jne    800490 <CheckWSWithoutLastIndex+0xef>
			panic(
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 f0 24 80 00       	push   $0x8024f0
  800484:	6a 3a                	push   $0x3a
  800486:	68 e4 24 80 00       	push   $0x8024e4
  80048b:	e8 9f fe ff ff       	call   80032f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800490:	ff 45 f0             	incl   -0x10(%ebp)
  800493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800496:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800499:	0f 8c 3e ff ff ff    	jl     8003dd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80049f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004ad:	eb 20                	jmp    8004cf <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004af:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004bd:	c1 e2 04             	shl    $0x4,%edx
  8004c0:	01 d0                	add    %edx,%eax
  8004c2:	8a 40 04             	mov    0x4(%eax),%al
  8004c5:	3c 01                	cmp    $0x1,%al
  8004c7:	75 03                	jne    8004cc <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8004c9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cc:	ff 45 e0             	incl   -0x20(%ebp)
  8004cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d4:	8b 50 74             	mov    0x74(%eax),%edx
  8004d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004da:	39 c2                	cmp    %eax,%edx
  8004dc:	77 d1                	ja     8004af <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e4:	74 14                	je     8004fa <CheckWSWithoutLastIndex+0x159>
		panic(
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 44 25 80 00       	push   $0x802544
  8004ee:	6a 44                	push   $0x44
  8004f0:	68 e4 24 80 00       	push   $0x8024e4
  8004f5:	e8 35 fe ff ff       	call   80032f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004fa:	90                   	nop
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 48 01             	lea    0x1(%eax),%ecx
  80050b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050e:	89 0a                	mov    %ecx,(%edx)
  800510:	8b 55 08             	mov    0x8(%ebp),%edx
  800513:	88 d1                	mov    %dl,%cl
  800515:	8b 55 0c             	mov    0xc(%ebp),%edx
  800518:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	3d ff 00 00 00       	cmp    $0xff,%eax
  800526:	75 2c                	jne    800554 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800528:	a0 24 30 80 00       	mov    0x803024,%al
  80052d:	0f b6 c0             	movzbl %al,%eax
  800530:	8b 55 0c             	mov    0xc(%ebp),%edx
  800533:	8b 12                	mov    (%edx),%edx
  800535:	89 d1                	mov    %edx,%ecx
  800537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053a:	83 c2 08             	add    $0x8,%edx
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	50                   	push   %eax
  800541:	51                   	push   %ecx
  800542:	52                   	push   %edx
  800543:	e8 9c 14 00 00       	call   8019e4 <sys_cputs>
  800548:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80054b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 40 04             	mov    0x4(%eax),%eax
  80055a:	8d 50 01             	lea    0x1(%eax),%edx
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	89 50 04             	mov    %edx,0x4(%eax)
}
  800563:	90                   	nop
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800576:	00 00 00 
	b.cnt = 0;
  800579:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800580:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	ff 75 08             	pushl  0x8(%ebp)
  800589:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058f:	50                   	push   %eax
  800590:	68 fd 04 80 00       	push   $0x8004fd
  800595:	e8 11 02 00 00       	call   8007ab <vprintfmt>
  80059a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80059d:	a0 24 30 80 00       	mov    0x803024,%al
  8005a2:	0f b6 c0             	movzbl %al,%eax
  8005a5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005ab:	83 ec 04             	sub    $0x4,%esp
  8005ae:	50                   	push   %eax
  8005af:	52                   	push   %edx
  8005b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b6:	83 c0 08             	add    $0x8,%eax
  8005b9:	50                   	push   %eax
  8005ba:	e8 25 14 00 00       	call   8019e4 <sys_cputs>
  8005bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c2:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cf:	c9                   	leave  
  8005d0:	c3                   	ret    

008005d1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d7:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	e8 73 ff ff ff       	call   800566 <vcprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800604:	e8 ec 15 00 00       	call   801bf5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800609:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	ff 75 f4             	pushl  -0xc(%ebp)
  800618:	50                   	push   %eax
  800619:	e8 48 ff ff ff       	call   800566 <vcprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800624:	e8 e6 15 00 00       	call   801c0f <sys_enable_interrupt>
	return cnt;
  800629:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80062c:	c9                   	leave  
  80062d:	c3                   	ret    

0080062e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
  800631:	53                   	push   %ebx
  800632:	83 ec 14             	sub    $0x14,%esp
  800635:	8b 45 10             	mov    0x10(%ebp),%eax
  800638:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800641:	8b 45 18             	mov    0x18(%ebp),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064c:	77 55                	ja     8006a3 <printnum+0x75>
  80064e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800651:	72 05                	jb     800658 <printnum+0x2a>
  800653:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800656:	77 4b                	ja     8006a3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800658:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80065e:	8b 45 18             	mov    0x18(%ebp),%eax
  800661:	ba 00 00 00 00       	mov    $0x0,%edx
  800666:	52                   	push   %edx
  800667:	50                   	push   %eax
  800668:	ff 75 f4             	pushl  -0xc(%ebp)
  80066b:	ff 75 f0             	pushl  -0x10(%ebp)
  80066e:	e8 59 1a 00 00       	call   8020cc <__udivdi3>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	83 ec 04             	sub    $0x4,%esp
  800679:	ff 75 20             	pushl  0x20(%ebp)
  80067c:	53                   	push   %ebx
  80067d:	ff 75 18             	pushl  0x18(%ebp)
  800680:	52                   	push   %edx
  800681:	50                   	push   %eax
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 a1 ff ff ff       	call   80062e <printnum>
  80068d:	83 c4 20             	add    $0x20,%esp
  800690:	eb 1a                	jmp    8006ac <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 20             	pushl  0x20(%ebp)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	ff d0                	call   *%eax
  8006a0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a3:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006aa:	7f e6                	jg     800692 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ac:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ba:	53                   	push   %ebx
  8006bb:	51                   	push   %ecx
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	e8 19 1b 00 00       	call   8021dc <__umoddi3>
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	05 b4 27 80 00       	add    $0x8027b4,%eax
  8006cb:	8a 00                	mov    (%eax),%al
  8006cd:	0f be c0             	movsbl %al,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	50                   	push   %eax
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	ff d0                	call   *%eax
  8006dc:	83 c4 10             	add    $0x10,%esp
}
  8006df:	90                   	nop
  8006e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 40                	jmp    80074a <getuint+0x65>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1e                	je     80072e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	eb 1c                	jmp    80074a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	8d 50 04             	lea    0x4(%eax),%edx
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	89 10                	mov    %edx,(%eax)
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80074a:	5d                   	pop    %ebp
  80074b:	c3                   	ret    

0080074c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800753:	7e 1c                	jle    800771 <getint+0x25>
		return va_arg(*ap, long long);
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	8d 50 08             	lea    0x8(%eax),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	89 10                	mov    %edx,(%eax)
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 e8 08             	sub    $0x8,%eax
  80076a:	8b 50 04             	mov    0x4(%eax),%edx
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	eb 38                	jmp    8007a9 <getint+0x5d>
	else if (lflag)
  800771:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800775:	74 1a                	je     800791 <getint+0x45>
		return va_arg(*ap, long);
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	8d 50 04             	lea    0x4(%eax),%edx
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	89 10                	mov    %edx,(%eax)
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	83 e8 04             	sub    $0x4,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	99                   	cltd   
  80078f:	eb 18                	jmp    8007a9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	8d 50 04             	lea    0x4(%eax),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	89 10                	mov    %edx,(%eax)
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	83 e8 04             	sub    $0x4,%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	99                   	cltd   
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	56                   	push   %esi
  8007af:	53                   	push   %ebx
  8007b0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b3:	eb 17                	jmp    8007cc <vprintfmt+0x21>
			if (ch == '\0')
  8007b5:	85 db                	test   %ebx,%ebx
  8007b7:	0f 84 af 03 00 00    	je     800b6c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	53                   	push   %ebx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cf:	8d 50 01             	lea    0x1(%eax),%edx
  8007d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d5:	8a 00                	mov    (%eax),%al
  8007d7:	0f b6 d8             	movzbl %al,%ebx
  8007da:	83 fb 25             	cmp    $0x25,%ebx
  8007dd:	75 d6                	jne    8007b5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007df:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800802:	8d 50 01             	lea    0x1(%eax),%edx
  800805:	89 55 10             	mov    %edx,0x10(%ebp)
  800808:	8a 00                	mov    (%eax),%al
  80080a:	0f b6 d8             	movzbl %al,%ebx
  80080d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800810:	83 f8 55             	cmp    $0x55,%eax
  800813:	0f 87 2b 03 00 00    	ja     800b44 <vprintfmt+0x399>
  800819:	8b 04 85 d8 27 80 00 	mov    0x8027d8(,%eax,4),%eax
  800820:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800822:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800826:	eb d7                	jmp    8007ff <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800828:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80082c:	eb d1                	jmp    8007ff <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800838:	89 d0                	mov    %edx,%eax
  80083a:	c1 e0 02             	shl    $0x2,%eax
  80083d:	01 d0                	add    %edx,%eax
  80083f:	01 c0                	add    %eax,%eax
  800841:	01 d8                	add    %ebx,%eax
  800843:	83 e8 30             	sub    $0x30,%eax
  800846:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	8a 00                	mov    (%eax),%al
  80084e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800851:	83 fb 2f             	cmp    $0x2f,%ebx
  800854:	7e 3e                	jle    800894 <vprintfmt+0xe9>
  800856:	83 fb 39             	cmp    $0x39,%ebx
  800859:	7f 39                	jg     800894 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80085e:	eb d5                	jmp    800835 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	83 c0 04             	add    $0x4,%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800874:	eb 1f                	jmp    800895 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800876:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087a:	79 83                	jns    8007ff <vprintfmt+0x54>
				width = 0;
  80087c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800883:	e9 77 ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800888:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80088f:	e9 6b ff ff ff       	jmp    8007ff <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800894:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800899:	0f 89 60 ff ff ff    	jns    8007ff <vprintfmt+0x54>
				width = precision, precision = -1;
  80089f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ac:	e9 4e ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b4:	e9 46 ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	83 c0 04             	add    $0x4,%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 e8 04             	sub    $0x4,%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
			break;
  8008d9:	e9 89 02 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	83 c0 04             	add    $0x4,%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	79 02                	jns    8008f5 <vprintfmt+0x14a>
				err = -err;
  8008f3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f5:	83 fb 64             	cmp    $0x64,%ebx
  8008f8:	7f 0b                	jg     800905 <vprintfmt+0x15a>
  8008fa:	8b 34 9d 20 26 80 00 	mov    0x802620(,%ebx,4),%esi
  800901:	85 f6                	test   %esi,%esi
  800903:	75 19                	jne    80091e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800905:	53                   	push   %ebx
  800906:	68 c5 27 80 00       	push   $0x8027c5
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 5e 02 00 00       	call   800b74 <printfmt>
  800916:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800919:	e9 49 02 00 00       	jmp    800b67 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091e:	56                   	push   %esi
  80091f:	68 ce 27 80 00       	push   $0x8027ce
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	ff 75 08             	pushl  0x8(%ebp)
  80092a:	e8 45 02 00 00       	call   800b74 <printfmt>
  80092f:	83 c4 10             	add    $0x10,%esp
			break;
  800932:	e9 30 02 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 30                	mov    (%eax),%esi
  800948:	85 f6                	test   %esi,%esi
  80094a:	75 05                	jne    800951 <vprintfmt+0x1a6>
				p = "(null)";
  80094c:	be d1 27 80 00       	mov    $0x8027d1,%esi
			if (width > 0 && padc != '-')
  800951:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800955:	7e 6d                	jle    8009c4 <vprintfmt+0x219>
  800957:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095b:	74 67                	je     8009c4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	50                   	push   %eax
  800964:	56                   	push   %esi
  800965:	e8 0c 03 00 00       	call   800c76 <strnlen>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800970:	eb 16                	jmp    800988 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800972:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	50                   	push   %eax
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800985:	ff 4d e4             	decl   -0x1c(%ebp)
  800988:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098c:	7f e4                	jg     800972 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098e:	eb 34                	jmp    8009c4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800990:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800994:	74 1c                	je     8009b2 <vprintfmt+0x207>
  800996:	83 fb 1f             	cmp    $0x1f,%ebx
  800999:	7e 05                	jle    8009a0 <vprintfmt+0x1f5>
  80099b:	83 fb 7e             	cmp    $0x7e,%ebx
  80099e:	7e 12                	jle    8009b2 <vprintfmt+0x207>
					putch('?', putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	6a 3f                	push   $0x3f
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
  8009b0:	eb 0f                	jmp    8009c1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	53                   	push   %ebx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	ff d0                	call   *%eax
  8009be:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c4:	89 f0                	mov    %esi,%eax
  8009c6:	8d 70 01             	lea    0x1(%eax),%esi
  8009c9:	8a 00                	mov    (%eax),%al
  8009cb:	0f be d8             	movsbl %al,%ebx
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	74 24                	je     8009f6 <vprintfmt+0x24b>
  8009d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d6:	78 b8                	js     800990 <vprintfmt+0x1e5>
  8009d8:	ff 4d e0             	decl   -0x20(%ebp)
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	79 af                	jns    800990 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e1:	eb 13                	jmp    8009f6 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	6a 20                	push   $0x20
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fa:	7f e7                	jg     8009e3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009fc:	e9 66 01 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 e8             	pushl  -0x18(%ebp)
  800a07:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0a:	50                   	push   %eax
  800a0b:	e8 3c fd ff ff       	call   80074c <getint>
  800a10:	83 c4 10             	add    $0x10,%esp
  800a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1f:	85 d2                	test   %edx,%edx
  800a21:	79 23                	jns    800a46 <vprintfmt+0x29b>
				putch('-', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 2d                	push   $0x2d
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a39:	f7 d8                	neg    %eax
  800a3b:	83 d2 00             	adc    $0x0,%edx
  800a3e:	f7 da                	neg    %edx
  800a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a4d:	e9 bc 00 00 00       	jmp    800b0e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 84 fc ff ff       	call   8006e5 <getuint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a71:	e9 98 00 00 00       	jmp    800b0e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	6a 58                	push   $0x58
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	ff d0                	call   *%eax
  800a83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	6a 58                	push   $0x58
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 58                	push   $0x58
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			break;
  800aa6:	e9 bc 00 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	6a 30                	push   $0x30
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 78                	push   $0x78
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	83 c0 04             	add    $0x4,%eax
  800ad1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 e8 04             	sub    $0x4,%eax
  800ada:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aed:	eb 1f                	jmp    800b0e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 e8             	pushl  -0x18(%ebp)
  800af5:	8d 45 14             	lea    0x14(%ebp),%eax
  800af8:	50                   	push   %eax
  800af9:	e8 e7 fb ff ff       	call   8006e5 <getuint>
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	52                   	push   %edx
  800b19:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b1c:	50                   	push   %eax
  800b1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b20:	ff 75 f0             	pushl  -0x10(%ebp)
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 00 fb ff ff       	call   80062e <printnum>
  800b2e:	83 c4 20             	add    $0x20,%esp
			break;
  800b31:	eb 34                	jmp    800b67 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	53                   	push   %ebx
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
			break;
  800b42:	eb 23                	jmp    800b67 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	6a 25                	push   $0x25
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b54:	ff 4d 10             	decl   0x10(%ebp)
  800b57:	eb 03                	jmp    800b5c <vprintfmt+0x3b1>
  800b59:	ff 4d 10             	decl   0x10(%ebp)
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	48                   	dec    %eax
  800b60:	8a 00                	mov    (%eax),%al
  800b62:	3c 25                	cmp    $0x25,%al
  800b64:	75 f3                	jne    800b59 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b66:	90                   	nop
		}
	}
  800b67:	e9 47 fc ff ff       	jmp    8007b3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b6c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7d:	83 c0 04             	add    $0x4,%eax
  800b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b83:	8b 45 10             	mov    0x10(%ebp),%eax
  800b86:	ff 75 f4             	pushl  -0xc(%ebp)
  800b89:	50                   	push   %eax
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	ff 75 08             	pushl  0x8(%ebp)
  800b90:	e8 16 fc ff ff       	call   8007ab <vprintfmt>
  800b95:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b98:	90                   	nop
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	8b 40 08             	mov    0x8(%eax),%eax
  800ba4:	8d 50 01             	lea    0x1(%eax),%edx
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb0:	8b 10                	mov    (%eax),%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8b 40 04             	mov    0x4(%eax),%eax
  800bb8:	39 c2                	cmp    %eax,%edx
  800bba:	73 12                	jae    800bce <sprintputch+0x33>
		*b->buf++ = ch;
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc7:	89 0a                	mov    %ecx,(%edx)
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	88 10                	mov    %dl,(%eax)
}
  800bce:	90                   	nop
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	01 d0                	add    %edx,%eax
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf6:	74 06                	je     800bfe <vsnprintf+0x2d>
  800bf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfc:	7f 07                	jg     800c05 <vsnprintf+0x34>
		return -E_INVAL;
  800bfe:	b8 03 00 00 00       	mov    $0x3,%eax
  800c03:	eb 20                	jmp    800c25 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c05:	ff 75 14             	pushl  0x14(%ebp)
  800c08:	ff 75 10             	pushl  0x10(%ebp)
  800c0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c0e:	50                   	push   %eax
  800c0f:	68 9b 0b 80 00       	push   $0x800b9b
  800c14:	e8 92 fb ff ff       	call   8007ab <vprintfmt>
  800c19:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c36:	8b 45 10             	mov    0x10(%ebp),%eax
  800c39:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3c:	50                   	push   %eax
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	ff 75 08             	pushl  0x8(%ebp)
  800c43:	e8 89 ff ff ff       	call   800bd1 <vsnprintf>
  800c48:	83 c4 10             	add    $0x10,%esp
  800c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c60:	eb 06                	jmp    800c68 <strlen+0x15>
		n++;
  800c62:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c65:	ff 45 08             	incl   0x8(%ebp)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	75 f1                	jne    800c62 <strlen+0xf>
		n++;
	return n;
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 09                	jmp    800c8e <strnlen+0x18>
		n++;
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c88:	ff 45 08             	incl   0x8(%ebp)
  800c8b:	ff 4d 0c             	decl   0xc(%ebp)
  800c8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c92:	74 09                	je     800c9d <strnlen+0x27>
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	75 e8                	jne    800c85 <strnlen+0xf>
		n++;
	return n;
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cae:	90                   	nop
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8d 50 01             	lea    0x1(%eax),%edx
  800cb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc1:	8a 12                	mov    (%edx),%dl
  800cc3:	88 10                	mov    %dl,(%eax)
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	84 c0                	test   %al,%al
  800cc9:	75 e4                	jne    800caf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce3:	eb 1f                	jmp    800d04 <strncpy+0x34>
		*dst++ = *src;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8d 50 01             	lea    0x1(%eax),%edx
  800ceb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf1:	8a 12                	mov    (%edx),%dl
  800cf3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	74 03                	je     800d01 <strncpy+0x31>
			src++;
  800cfe:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d01:	ff 45 fc             	incl   -0x4(%ebp)
  800d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d07:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d0a:	72 d9                	jb     800ce5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d0f:	c9                   	leave  
  800d10:	c3                   	ret    

00800d11 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d21:	74 30                	je     800d53 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d23:	eb 16                	jmp    800d3b <strlcpy+0x2a>
			*dst++ = *src++;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8d 50 01             	lea    0x1(%eax),%edx
  800d2b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d34:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d37:	8a 12                	mov    (%edx),%dl
  800d39:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d3b:	ff 4d 10             	decl   0x10(%ebp)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 09                	je     800d4d <strlcpy+0x3c>
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	75 d8                	jne    800d25 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d59:	29 c2                	sub    %eax,%edx
  800d5b:	89 d0                	mov    %edx,%eax
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d62:	eb 06                	jmp    800d6a <strcmp+0xb>
		p++, q++;
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	74 0e                	je     800d81 <strcmp+0x22>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 10                	mov    (%eax),%dl
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	38 c2                	cmp    %al,%dl
  800d7f:	74 e3                	je     800d64 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 d0             	movzbl %al,%edx
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	0f b6 c0             	movzbl %al,%eax
  800d91:	29 c2                	sub    %eax,%edx
  800d93:	89 d0                	mov    %edx,%eax
}
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9a:	eb 09                	jmp    800da5 <strncmp+0xe>
		n--, p++, q++;
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da9:	74 17                	je     800dc2 <strncmp+0x2b>
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	84 c0                	test   %al,%al
  800db2:	74 0e                	je     800dc2 <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 10                	mov    (%eax),%dl
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	38 c2                	cmp    %al,%dl
  800dc0:	74 da                	je     800d9c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc6:	75 07                	jne    800dcf <strncmp+0x38>
		return 0;
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	eb 14                	jmp    800de3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 d0             	movzbl %al,%edx
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	0f b6 c0             	movzbl %al,%eax
  800ddf:	29 c2                	sub    %eax,%edx
  800de1:	89 d0                	mov    %edx,%eax
}
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 04             	sub    $0x4,%esp
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df1:	eb 12                	jmp    800e05 <strchr+0x20>
		if (*s == c)
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dfb:	75 05                	jne    800e02 <strchr+0x1d>
			return (char *) s;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	eb 11                	jmp    800e13 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e02:	ff 45 08             	incl   0x8(%ebp)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	84 c0                	test   %al,%al
  800e0c:	75 e5                	jne    800df3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 04             	sub    $0x4,%esp
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e21:	eb 0d                	jmp    800e30 <strfind+0x1b>
		if (*s == c)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2b:	74 0e                	je     800e3b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e2d:	ff 45 08             	incl   0x8(%ebp)
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	84 c0                	test   %al,%al
  800e37:	75 ea                	jne    800e23 <strfind+0xe>
  800e39:	eb 01                	jmp    800e3c <strfind+0x27>
		if (*s == c)
			break;
  800e3b:	90                   	nop
	return (char *) s;
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    

00800e41 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e53:	eb 0e                	jmp    800e63 <memset+0x22>
		*p++ = c;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e63:	ff 4d f8             	decl   -0x8(%ebp)
  800e66:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e6a:	79 e9                	jns    800e55 <memset+0x14>
		*p++ = c;

	return v;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e83:	eb 16                	jmp    800e9b <memcpy+0x2a>
		*d++ = *s++;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 dd                	jne    800e85 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ec5:	73 50                	jae    800f17 <memmove+0x6a>
  800ec7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed2:	76 43                	jbe    800f17 <memmove+0x6a>
		s += n;
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee0:	eb 10                	jmp    800ef2 <memmove+0x45>
			*--d = *--s;
  800ee2:	ff 4d f8             	decl   -0x8(%ebp)
  800ee5:	ff 4d fc             	decl   -0x4(%ebp)
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	8a 10                	mov    (%eax),%dl
  800eed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef8:	89 55 10             	mov    %edx,0x10(%ebp)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	75 e3                	jne    800ee2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eff:	eb 23                	jmp    800f24 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f04:	8d 50 01             	lea    0x1(%eax),%edx
  800f07:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f10:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f13:	8a 12                	mov    (%edx),%dl
  800f15:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	75 dd                	jne    800f01 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f3b:	eb 2a                	jmp    800f67 <memcmp+0x3e>
		if (*s1 != *s2)
  800f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f40:	8a 10                	mov    (%eax),%dl
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	38 c2                	cmp    %al,%dl
  800f49:	74 16                	je     800f61 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
  800f5f:	eb 18                	jmp    800f79 <memcmp+0x50>
		s1++, s2++;
  800f61:	ff 45 fc             	incl   -0x4(%ebp)
  800f64:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	75 c9                	jne    800f3d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	01 d0                	add    %edx,%eax
  800f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f8c:	eb 15                	jmp    800fa3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	0f b6 d0             	movzbl %al,%edx
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	0f b6 c0             	movzbl %al,%eax
  800f9c:	39 c2                	cmp    %eax,%edx
  800f9e:	74 0d                	je     800fad <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa9:	72 e3                	jb     800f8e <memfind+0x13>
  800fab:	eb 01                	jmp    800fae <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fad:	90                   	nop
	return (void *) s;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc7:	eb 03                	jmp    800fcc <strtol+0x19>
		s++;
  800fc9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 20                	cmp    $0x20,%al
  800fd3:	74 f4                	je     800fc9 <strtol+0x16>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 09                	cmp    $0x9,%al
  800fdc:	74 eb                	je     800fc9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 2b                	cmp    $0x2b,%al
  800fe5:	75 05                	jne    800fec <strtol+0x39>
		s++;
  800fe7:	ff 45 08             	incl   0x8(%ebp)
  800fea:	eb 13                	jmp    800fff <strtol+0x4c>
	else if (*s == '-')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2d                	cmp    $0x2d,%al
  800ff3:	75 0a                	jne    800fff <strtol+0x4c>
		s++, neg = 1;
  800ff5:	ff 45 08             	incl   0x8(%ebp)
  800ff8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801003:	74 06                	je     80100b <strtol+0x58>
  801005:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801009:	75 20                	jne    80102b <strtol+0x78>
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 30                	cmp    $0x30,%al
  801012:	75 17                	jne    80102b <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	40                   	inc    %eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 78                	cmp    $0x78,%al
  80101c:	75 0d                	jne    80102b <strtol+0x78>
		s += 2, base = 16;
  80101e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801022:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801029:	eb 28                	jmp    801053 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80102b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102f:	75 15                	jne    801046 <strtol+0x93>
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 30                	cmp    $0x30,%al
  801038:	75 0c                	jne    801046 <strtol+0x93>
		s++, base = 8;
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801044:	eb 0d                	jmp    801053 <strtol+0xa0>
	else if (base == 0)
  801046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104a:	75 07                	jne    801053 <strtol+0xa0>
		base = 10;
  80104c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	3c 2f                	cmp    $0x2f,%al
  80105a:	7e 19                	jle    801075 <strtol+0xc2>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 39                	cmp    $0x39,%al
  801063:	7f 10                	jg     801075 <strtol+0xc2>
			dig = *s - '0';
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f be c0             	movsbl %al,%eax
  80106d:	83 e8 30             	sub    $0x30,%eax
  801070:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801073:	eb 42                	jmp    8010b7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	3c 60                	cmp    $0x60,%al
  80107c:	7e 19                	jle    801097 <strtol+0xe4>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 7a                	cmp    $0x7a,%al
  801085:	7f 10                	jg     801097 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	0f be c0             	movsbl %al,%eax
  80108f:	83 e8 57             	sub    $0x57,%eax
  801092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801095:	eb 20                	jmp    8010b7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	3c 40                	cmp    $0x40,%al
  80109e:	7e 39                	jle    8010d9 <strtol+0x126>
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 5a                	cmp    $0x5a,%al
  8010a7:	7f 30                	jg     8010d9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	0f be c0             	movsbl %al,%eax
  8010b1:	83 e8 37             	sub    $0x37,%eax
  8010b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ba:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bd:	7d 19                	jge    8010d8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c9:	89 c2                	mov    %eax,%edx
  8010cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ce:	01 d0                	add    %edx,%eax
  8010d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010d3:	e9 7b ff ff ff       	jmp    801053 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010dd:	74 08                	je     8010e7 <strtol+0x134>
		*endptr = (char *) s;
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010eb:	74 07                	je     8010f4 <strtol+0x141>
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	f7 d8                	neg    %eax
  8010f2:	eb 03                	jmp    8010f7 <strtol+0x144>
  8010f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801106:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80110d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801111:	79 13                	jns    801126 <ltostr+0x2d>
	{
		neg = 1;
  801113:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801120:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801123:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80112e:	99                   	cltd   
  80112f:	f7 f9                	idiv   %ecx
  801131:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801134:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801137:	8d 50 01             	lea    0x1(%eax),%edx
  80113a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80113d:	89 c2                	mov    %eax,%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801147:	83 c2 30             	add    $0x30,%edx
  80114a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80114c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80114f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801154:	f7 e9                	imul   %ecx
  801156:	c1 fa 02             	sar    $0x2,%edx
  801159:	89 c8                	mov    %ecx,%eax
  80115b:	c1 f8 1f             	sar    $0x1f,%eax
  80115e:	29 c2                	sub    %eax,%edx
  801160:	89 d0                	mov    %edx,%eax
  801162:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801165:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801168:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116d:	f7 e9                	imul   %ecx
  80116f:	c1 fa 02             	sar    $0x2,%edx
  801172:	89 c8                	mov    %ecx,%eax
  801174:	c1 f8 1f             	sar    $0x1f,%eax
  801177:	29 c2                	sub    %eax,%edx
  801179:	89 d0                	mov    %edx,%eax
  80117b:	c1 e0 02             	shl    $0x2,%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	01 c0                	add    %eax,%eax
  801182:	29 c1                	sub    %eax,%ecx
  801184:	89 ca                	mov    %ecx,%edx
  801186:	85 d2                	test   %edx,%edx
  801188:	75 9c                	jne    801126 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80118a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	48                   	dec    %eax
  801195:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801198:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119c:	74 3d                	je     8011db <ltostr+0xe2>
		start = 1 ;
  80119e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a5:	eb 34                	jmp    8011db <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	01 c2                	add    %eax,%edx
  8011d0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d3:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e1:	7c c4                	jl     8011a7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	01 d0                	add    %edx,%eax
  8011eb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ee:	90                   	nop
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	e8 54 fa ff ff       	call   800c53 <strlen>
  8011ff:	83 c4 04             	add    $0x4,%esp
  801202:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	e8 46 fa ff ff       	call   800c53 <strlen>
  80120d:	83 c4 04             	add    $0x4,%esp
  801210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801221:	eb 17                	jmp    80123a <strcconcat+0x49>
		final[s] = str1[s] ;
  801223:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 c2                	add    %eax,%edx
  80122b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	01 c8                	add    %ecx,%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801237:	ff 45 fc             	incl   -0x4(%ebp)
  80123a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801240:	7c e1                	jl     801223 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801242:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801249:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801250:	eb 1f                	jmp    801271 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	8d 50 01             	lea    0x1(%eax),%edx
  801258:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 c8                	add    %ecx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80126e:	ff 45 f8             	incl   -0x8(%ebp)
  801271:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801274:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801277:	7c d9                	jl     801252 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	c6 00 00             	movb   $0x0,(%eax)
}
  801284:	90                   	nop
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80128a:	8b 45 14             	mov    0x14(%ebp),%eax
  80128d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012aa:	eb 0c                	jmp    8012b8 <strsplit+0x31>
			*string++ = 0;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8d 50 01             	lea    0x1(%eax),%edx
  8012b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	84 c0                	test   %al,%al
  8012bf:	74 18                	je     8012d9 <strsplit+0x52>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f be c0             	movsbl %al,%eax
  8012c9:	50                   	push   %eax
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	e8 13 fb ff ff       	call   800de5 <strchr>
  8012d2:	83 c4 08             	add    $0x8,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	75 d3                	jne    8012ac <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	74 5a                	je     80133c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	83 f8 0f             	cmp    $0xf,%eax
  8012ea:	75 07                	jne    8012f3 <strsplit+0x6c>
		{
			return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	eb 66                	jmp    801359 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f6:	8b 00                	mov    (%eax),%eax
  8012f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8012fb:	8b 55 14             	mov    0x14(%ebp),%edx
  8012fe:	89 0a                	mov    %ecx,(%edx)
  801300:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 c2                	add    %eax,%edx
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801311:	eb 03                	jmp    801316 <strsplit+0x8f>
			string++;
  801313:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	74 8b                	je     8012aa <strsplit+0x23>
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be c0             	movsbl %al,%eax
  801327:	50                   	push   %eax
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 b5 fa ff ff       	call   800de5 <strchr>
  801330:	83 c4 08             	add    $0x8,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	74 dc                	je     801313 <strsplit+0x8c>
			string++;
	}
  801337:	e9 6e ff ff ff       	jmp    8012aa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80133c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801354:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801361:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801368:	8b 55 08             	mov    0x8(%ebp),%edx
  80136b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	48                   	dec    %eax
  801371:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801374:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801377:	ba 00 00 00 00       	mov    $0x0,%edx
  80137c:	f7 75 ac             	divl   -0x54(%ebp)
  80137f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801382:	29 d0                	sub    %edx,%eax
  801384:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  80138e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801395:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80139c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013a3:	eb 3f                	jmp    8013e4 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8013a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a8:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8013af:	83 ec 04             	sub    $0x4,%esp
  8013b2:	50                   	push   %eax
  8013b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8013b6:	68 30 29 80 00       	push   $0x802930
  8013bb:	e8 11 f2 ff ff       	call   8005d1 <cprintf>
  8013c0:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8013c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c6:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	50                   	push   %eax
  8013d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8013d4:	68 45 29 80 00       	push   $0x802945
  8013d9:	e8 f3 f1 ff ff       	call   8005d1 <cprintf>
  8013de:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8013e1:	ff 45 e8             	incl   -0x18(%ebp)
  8013e4:	a1 28 30 80 00       	mov    0x803028,%eax
  8013e9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8013ec:	7c b7                	jl     8013a5 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8013ee:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8013f5:	e9 35 01 00 00       	jmp    80152f <malloc+0x1d4>
		int flag0=1;
  8013fa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801404:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801407:	eb 5e                	jmp    801467 <malloc+0x10c>
			for(int k=0;k<count;k++){
  801409:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801410:	eb 35                	jmp    801447 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801412:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801415:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80141c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141f:	39 c2                	cmp    %eax,%edx
  801421:	77 21                	ja     801444 <malloc+0xe9>
  801423:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801426:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80142d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801430:	39 c2                	cmp    %eax,%edx
  801432:	76 10                	jbe    801444 <malloc+0xe9>
					ni=PAGE_SIZE;
  801434:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  80143b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801442:	eb 0d                	jmp    801451 <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801444:	ff 45 d8             	incl   -0x28(%ebp)
  801447:	a1 28 30 80 00       	mov    0x803028,%eax
  80144c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80144f:	7c c1                	jl     801412 <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 09                	je     801460 <malloc+0x105>
				flag0=0;
  801457:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  80145e:	eb 16                	jmp    801476 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801460:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	01 c2                	add    %eax,%edx
  80146f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801472:	39 c2                	cmp    %eax,%edx
  801474:	77 93                	ja     801409 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801476:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80147a:	0f 84 a2 00 00 00    	je     801522 <malloc+0x1c7>

			int f=1;
  801480:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801487:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80148a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80148d:	89 c8                	mov    %ecx,%eax
  80148f:	01 c0                	add    %eax,%eax
  801491:	01 c8                	add    %ecx,%eax
  801493:	c1 e0 02             	shl    $0x2,%eax
  801496:	05 20 31 80 00       	add    $0x803120,%eax
  80149b:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80149d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8014a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a9:	89 d0                	mov    %edx,%eax
  8014ab:	01 c0                	add    %eax,%eax
  8014ad:	01 d0                	add    %edx,%eax
  8014af:	c1 e0 02             	shl    $0x2,%eax
  8014b2:	05 24 31 80 00       	add    $0x803124,%eax
  8014b7:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8014b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bc:	89 d0                	mov    %edx,%eax
  8014be:	01 c0                	add    %eax,%eax
  8014c0:	01 d0                	add    %edx,%eax
  8014c2:	c1 e0 02             	shl    $0x2,%eax
  8014c5:	05 28 31 80 00       	add    $0x803128,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  8014d0:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  8014d3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8014da:	eb 36                	jmp    801512 <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  8014dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	01 c2                	add    %eax,%edx
  8014e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014e7:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8014ee:	39 c2                	cmp    %eax,%edx
  8014f0:	73 1d                	jae    80150f <malloc+0x1b4>
					ni=arr_add[l].end-i;
  8014f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014f5:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ff:	29 c2                	sub    %eax,%edx
  801501:	89 d0                	mov    %edx,%eax
  801503:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801506:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80150d:	eb 0d                	jmp    80151c <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80150f:	ff 45 d0             	incl   -0x30(%ebp)
  801512:	a1 28 30 80 00       	mov    0x803028,%eax
  801517:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80151a:	7c c0                	jl     8014dc <malloc+0x181>
					break;

				}
			}

			if(f){
  80151c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801520:	75 1d                	jne    80153f <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  801522:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152c:	01 45 e4             	add    %eax,-0x1c(%ebp)
  80152f:	a1 04 30 80 00       	mov    0x803004,%eax
  801534:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801537:	0f 8c bd fe ff ff    	jl     8013fa <malloc+0x9f>
  80153d:	eb 01                	jmp    801540 <malloc+0x1e5>

				}
			}

			if(f){
				break;
  80153f:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801544:	75 7a                	jne    8015c0 <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801546:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	01 d0                	add    %edx,%eax
  801551:	48                   	dec    %eax
  801552:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801557:	7c 0a                	jl     801563 <malloc+0x208>
			return NULL;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	e9 a4 02 00 00       	jmp    801807 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  801563:	a1 04 30 80 00       	mov    0x803004,%eax
  801568:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  80156b:	a1 28 30 80 00       	mov    0x803028,%eax
  801570:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801573:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	ff 75 a4             	pushl  -0x5c(%ebp)
  801583:	e8 04 06 00 00       	call   801b8c <sys_allocateMem>
  801588:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80158b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80159b:	a1 28 30 80 00       	mov    0x803028,%eax
  8015a0:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015a6:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8015ad:	a1 28 30 80 00       	mov    0x803028,%eax
  8015b2:	40                   	inc    %eax
  8015b3:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8015b8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8015bb:	e9 47 02 00 00       	jmp    801807 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  8015c0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8015c7:	e9 ac 00 00 00       	jmp    801678 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015cf:	89 d0                	mov    %edx,%eax
  8015d1:	01 c0                	add    %eax,%eax
  8015d3:	01 d0                	add    %edx,%eax
  8015d5:	c1 e0 02             	shl    $0x2,%eax
  8015d8:	05 24 31 80 00       	add    $0x803124,%eax
  8015dd:	8b 00                	mov    (%eax),%eax
  8015df:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8015e2:	eb 7e                	jmp    801662 <malloc+0x307>
			int flag=0;
  8015e4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8015eb:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8015f2:	eb 57                	jmp    80164b <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8015f4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015f7:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8015fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801601:	39 c2                	cmp    %eax,%edx
  801603:	77 1a                	ja     80161f <malloc+0x2c4>
  801605:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801608:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80160f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801612:	39 c2                	cmp    %eax,%edx
  801614:	76 09                	jbe    80161f <malloc+0x2c4>
								flag=1;
  801616:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  80161d:	eb 36                	jmp    801655 <malloc+0x2fa>
			arr[i].space++;
  80161f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801622:	89 d0                	mov    %edx,%eax
  801624:	01 c0                	add    %eax,%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	c1 e0 02             	shl    $0x2,%eax
  80162b:	05 28 31 80 00       	add    $0x803128,%eax
  801630:	8b 00                	mov    (%eax),%eax
  801632:	8d 48 01             	lea    0x1(%eax),%ecx
  801635:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801638:	89 d0                	mov    %edx,%eax
  80163a:	01 c0                	add    %eax,%eax
  80163c:	01 d0                	add    %edx,%eax
  80163e:	c1 e0 02             	shl    $0x2,%eax
  801641:	05 28 31 80 00       	add    $0x803128,%eax
  801646:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801648:	ff 45 c0             	incl   -0x40(%ebp)
  80164b:	a1 28 30 80 00       	mov    0x803028,%eax
  801650:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801653:	7c 9f                	jl     8015f4 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801655:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801659:	75 19                	jne    801674 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80165b:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801662:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801665:	a1 04 30 80 00       	mov    0x803004,%eax
  80166a:	39 c2                	cmp    %eax,%edx
  80166c:	0f 82 72 ff ff ff    	jb     8015e4 <malloc+0x289>
  801672:	eb 01                	jmp    801675 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801674:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801675:	ff 45 cc             	incl   -0x34(%ebp)
  801678:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80167b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167e:	0f 8c 48 ff ff ff    	jl     8015cc <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801684:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80168b:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801692:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801699:	eb 37                	jmp    8016d2 <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80169b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80169e:	89 d0                	mov    %edx,%eax
  8016a0:	01 c0                	add    %eax,%eax
  8016a2:	01 d0                	add    %edx,%eax
  8016a4:	c1 e0 02             	shl    $0x2,%eax
  8016a7:	05 28 31 80 00       	add    $0x803128,%eax
  8016ac:	8b 00                	mov    (%eax),%eax
  8016ae:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8016b1:	7d 1c                	jge    8016cf <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8016b3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	01 c0                	add    %eax,%eax
  8016ba:	01 d0                	add    %edx,%eax
  8016bc:	c1 e0 02             	shl    $0x2,%eax
  8016bf:	05 28 31 80 00       	add    $0x803128,%eax
  8016c4:	8b 00                	mov    (%eax),%eax
  8016c6:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  8016c9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8016cc:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  8016cf:	ff 45 b4             	incl   -0x4c(%ebp)
  8016d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8016d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016d8:	7c c1                	jl     80169b <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  8016da:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016e0:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8016e3:	89 c8                	mov    %ecx,%eax
  8016e5:	01 c0                	add    %eax,%eax
  8016e7:	01 c8                	add    %ecx,%eax
  8016e9:	c1 e0 02             	shl    $0x2,%eax
  8016ec:	05 20 31 80 00       	add    $0x803120,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  8016fa:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801700:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801703:	89 c8                	mov    %ecx,%eax
  801705:	01 c0                	add    %eax,%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	c1 e0 02             	shl    $0x2,%eax
  80170c:	05 24 31 80 00       	add    $0x803124,%eax
  801711:	8b 00                	mov    (%eax),%eax
  801713:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  80171a:	a1 28 30 80 00       	mov    0x803028,%eax
  80171f:	40                   	inc    %eax
  801720:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801725:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801728:	89 d0                	mov    %edx,%eax
  80172a:	01 c0                	add    %eax,%eax
  80172c:	01 d0                	add    %edx,%eax
  80172e:	c1 e0 02             	shl    $0x2,%eax
  801731:	05 20 31 80 00       	add    $0x803120,%eax
  801736:	8b 00                	mov    (%eax),%eax
  801738:	83 ec 08             	sub    $0x8,%esp
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	50                   	push   %eax
  80173f:	e8 48 04 00 00       	call   801b8c <sys_allocateMem>
  801744:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801747:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  80174e:	eb 78                	jmp    8017c8 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801750:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801753:	89 d0                	mov    %edx,%eax
  801755:	01 c0                	add    %eax,%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	c1 e0 02             	shl    $0x2,%eax
  80175c:	05 20 31 80 00       	add    $0x803120,%eax
  801761:	8b 00                	mov    (%eax),%eax
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	50                   	push   %eax
  801767:	ff 75 b0             	pushl  -0x50(%ebp)
  80176a:	68 30 29 80 00       	push   $0x802930
  80176f:	e8 5d ee ff ff       	call   8005d1 <cprintf>
  801774:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801777:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80177a:	89 d0                	mov    %edx,%eax
  80177c:	01 c0                	add    %eax,%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	c1 e0 02             	shl    $0x2,%eax
  801783:	05 24 31 80 00       	add    $0x803124,%eax
  801788:	8b 00                	mov    (%eax),%eax
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	50                   	push   %eax
  80178e:	ff 75 b0             	pushl  -0x50(%ebp)
  801791:	68 45 29 80 00       	push   $0x802945
  801796:	e8 36 ee ff ff       	call   8005d1 <cprintf>
  80179b:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80179e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017a1:	89 d0                	mov    %edx,%eax
  8017a3:	01 c0                	add    %eax,%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	c1 e0 02             	shl    $0x2,%eax
  8017aa:	05 28 31 80 00       	add    $0x803128,%eax
  8017af:	8b 00                	mov    (%eax),%eax
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	50                   	push   %eax
  8017b5:	ff 75 b0             	pushl  -0x50(%ebp)
  8017b8:	68 58 29 80 00       	push   $0x802958
  8017bd:	e8 0f ee ff ff       	call   8005d1 <cprintf>
  8017c2:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  8017c5:	ff 45 b0             	incl   -0x50(%ebp)
  8017c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8017cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ce:	7c 80                	jl     801750 <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  8017d0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017d3:	89 d0                	mov    %edx,%eax
  8017d5:	01 c0                	add    %eax,%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	c1 e0 02             	shl    $0x2,%eax
  8017dc:	05 20 31 80 00       	add    $0x803120,%eax
  8017e1:	8b 00                	mov    (%eax),%eax
  8017e3:	83 ec 08             	sub    $0x8,%esp
  8017e6:	50                   	push   %eax
  8017e7:	68 6c 29 80 00       	push   $0x80296c
  8017ec:	e8 e0 ed ff ff       	call   8005d1 <cprintf>
  8017f1:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8017f4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017f7:	89 d0                	mov    %edx,%eax
  8017f9:	01 c0                	add    %eax,%eax
  8017fb:	01 d0                	add    %edx,%eax
  8017fd:	c1 e0 02             	shl    $0x2,%eax
  801800:	05 20 31 80 00       	add    $0x803120,%eax
  801805:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801815:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80181c:	eb 4b                	jmp    801869 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80181e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801821:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801828:	89 c2                	mov    %eax,%edx
  80182a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80182d:	39 c2                	cmp    %eax,%edx
  80182f:	7f 35                	jg     801866 <free+0x5d>
  801831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801834:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80183b:	89 c2                	mov    %eax,%edx
  80183d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801840:	39 c2                	cmp    %eax,%edx
  801842:	7e 22                	jle    801866 <free+0x5d>
				start=arr_add[i].start;
  801844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801847:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80184e:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801854:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80185b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  80185e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801861:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801864:	eb 0d                	jmp    801873 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801866:	ff 45 ec             	incl   -0x14(%ebp)
  801869:	a1 28 30 80 00       	mov    0x803028,%eax
  80186e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801871:	7c ab                	jl     80181e <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801876:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80187d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801880:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801887:	29 c2                	sub    %eax,%edx
  801889:	89 d0                	mov    %edx,%eax
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	50                   	push   %eax
  80188f:	ff 75 f4             	pushl  -0xc(%ebp)
  801892:	e8 d9 02 00 00       	call   801b70 <sys_freeMem>
  801897:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018a0:	eb 2d                	jmp    8018cf <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8018a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a5:	40                   	inc    %eax
  8018a6:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8018ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b0:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8018b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ba:	40                   	inc    %eax
  8018bb:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c5:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  8018cc:	ff 45 e8             	incl   -0x18(%ebp)
  8018cf:	a1 28 30 80 00       	mov    0x803028,%eax
  8018d4:	48                   	dec    %eax
  8018d5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018d8:	7f c8                	jg     8018a2 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  8018da:	a1 28 30 80 00       	mov    0x803028,%eax
  8018df:	48                   	dec    %eax
  8018e0:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 18             	sub    $0x18,%esp
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	68 88 29 80 00       	push   $0x802988
  8018fc:	68 18 01 00 00       	push   $0x118
  801901:	68 ab 29 80 00       	push   $0x8029ab
  801906:	e8 24 ea ff ff       	call   80032f <_panic>

0080190b <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	68 88 29 80 00       	push   $0x802988
  801919:	68 1e 01 00 00       	push   $0x11e
  80191e:	68 ab 29 80 00       	push   $0x8029ab
  801923:	e8 07 ea ff ff       	call   80032f <_panic>

00801928 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	68 88 29 80 00       	push   $0x802988
  801936:	68 24 01 00 00       	push   $0x124
  80193b:	68 ab 29 80 00       	push   $0x8029ab
  801940:	e8 ea e9 ff ff       	call   80032f <_panic>

00801945 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80194b:	83 ec 04             	sub    $0x4,%esp
  80194e:	68 88 29 80 00       	push   $0x802988
  801953:	68 29 01 00 00       	push   $0x129
  801958:	68 ab 29 80 00       	push   $0x8029ab
  80195d:	e8 cd e9 ff ff       	call   80032f <_panic>

00801962 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	68 88 29 80 00       	push   $0x802988
  801970:	68 2f 01 00 00       	push   $0x12f
  801975:	68 ab 29 80 00       	push   $0x8029ab
  80197a:	e8 b0 e9 ff ff       	call   80032f <_panic>

0080197f <shrink>:
}
void shrink(uint32 newSize)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	68 88 29 80 00       	push   $0x802988
  80198d:	68 33 01 00 00       	push   $0x133
  801992:	68 ab 29 80 00       	push   $0x8029ab
  801997:	e8 93 e9 ff ff       	call   80032f <_panic>

0080199c <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	68 88 29 80 00       	push   $0x802988
  8019aa:	68 38 01 00 00       	push   $0x138
  8019af:	68 ab 29 80 00       	push   $0x8029ab
  8019b4:	e8 76 e9 ff ff       	call   80032f <_panic>

008019b9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	57                   	push   %edi
  8019bd:	56                   	push   %esi
  8019be:	53                   	push   %ebx
  8019bf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ce:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019d1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019d4:	cd 30                	int    $0x30
  8019d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	52                   	push   %edx
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	6a 00                	push   $0x0
  801a02:	e8 b2 ff ff ff       	call   8019b9 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 01                	push   $0x1
  801a1c:	e8 98 ff ff ff       	call   8019b9 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	50                   	push   %eax
  801a35:	6a 05                	push   $0x5
  801a37:	e8 7d ff ff ff       	call   8019b9 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 02                	push   $0x2
  801a50:	e8 64 ff ff ff       	call   8019b9 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 03                	push   $0x3
  801a69:	e8 4b ff ff ff       	call   8019b9 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 04                	push   $0x4
  801a82:	e8 32 ff ff ff       	call   8019b9 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_env_exit>:


void sys_env_exit(void)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 06                	push   $0x6
  801a9b:	e8 19 ff ff ff       	call   8019b9 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 07                	push   $0x7
  801ab9:	e8 fb fe ff ff       	call   8019b9 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ac8:	8b 75 18             	mov    0x18(%ebp),%esi
  801acb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ace:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	56                   	push   %esi
  801ad8:	53                   	push   %ebx
  801ad9:	51                   	push   %ecx
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	6a 08                	push   $0x8
  801ade:	e8 d6 fe ff ff       	call   8019b9 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5e                   	pop    %esi
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    

00801aed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	52                   	push   %edx
  801afd:	50                   	push   %eax
  801afe:	6a 09                	push   $0x9
  801b00:	e8 b4 fe ff ff       	call   8019b9 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	ff 75 08             	pushl  0x8(%ebp)
  801b19:	6a 0a                	push   $0xa
  801b1b:	e8 99 fe ff ff       	call   8019b9 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 0b                	push   $0xb
  801b34:	e8 80 fe ff ff       	call   8019b9 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 0c                	push   $0xc
  801b4d:	e8 67 fe ff ff       	call   8019b9 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 0d                	push   $0xd
  801b66:	e8 4e fe ff ff       	call   8019b9 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	6a 11                	push   $0x11
  801b81:	e8 33 fe ff ff       	call   8019b9 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	6a 12                	push   $0x12
  801b9d:	e8 17 fe ff ff       	call   8019b9 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba5:	90                   	nop
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 0e                	push   $0xe
  801bb7:	e8 fd fd ff ff       	call   8019b9 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 08             	pushl  0x8(%ebp)
  801bcf:	6a 0f                	push   $0xf
  801bd1:	e8 e3 fd ff ff       	call   8019b9 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 10                	push   $0x10
  801bea:	e8 ca fd ff ff       	call   8019b9 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	90                   	nop
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 14                	push   $0x14
  801c04:	e8 b0 fd ff ff       	call   8019b9 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	90                   	nop
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 15                	push   $0x15
  801c1e:	e8 96 fd ff ff       	call   8019b9 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	90                   	nop
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c35:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	50                   	push   %eax
  801c42:	6a 16                	push   $0x16
  801c44:	e8 70 fd ff ff       	call   8019b9 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	90                   	nop
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 17                	push   $0x17
  801c5e:	e8 56 fd ff ff       	call   8019b9 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	50                   	push   %eax
  801c79:	6a 18                	push   $0x18
  801c7b:	e8 39 fd ff ff       	call   8019b9 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	52                   	push   %edx
  801c95:	50                   	push   %eax
  801c96:	6a 1b                	push   $0x1b
  801c98:	e8 1c fd ff ff       	call   8019b9 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	52                   	push   %edx
  801cb2:	50                   	push   %eax
  801cb3:	6a 19                	push   $0x19
  801cb5:	e8 ff fc ff ff       	call   8019b9 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	90                   	nop
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 1a                	push   $0x1a
  801cd3:	e8 e1 fc ff ff       	call   8019b9 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 04             	sub    $0x4,%esp
  801ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ced:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	51                   	push   %ecx
  801cf7:	52                   	push   %edx
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	50                   	push   %eax
  801cfc:	6a 1c                	push   $0x1c
  801cfe:	e8 b6 fc ff ff       	call   8019b9 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	52                   	push   %edx
  801d18:	50                   	push   %eax
  801d19:	6a 1d                	push   $0x1d
  801d1b:	e8 99 fc ff ff       	call   8019b9 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	51                   	push   %ecx
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	6a 1e                	push   $0x1e
  801d3a:	e8 7a fc ff ff       	call   8019b9 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	52                   	push   %edx
  801d54:	50                   	push   %eax
  801d55:	6a 1f                	push   $0x1f
  801d57:	e8 5d fc ff ff       	call   8019b9 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 20                	push   $0x20
  801d70:	e8 44 fc ff ff       	call   8019b9 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	6a 00                	push   $0x0
  801d82:	ff 75 14             	pushl  0x14(%ebp)
  801d85:	ff 75 10             	pushl  0x10(%ebp)
  801d88:	ff 75 0c             	pushl  0xc(%ebp)
  801d8b:	50                   	push   %eax
  801d8c:	6a 21                	push   $0x21
  801d8e:	e8 26 fc ff ff       	call   8019b9 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	50                   	push   %eax
  801da7:	6a 22                	push   $0x22
  801da9:	e8 0b fc ff ff       	call   8019b9 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	90                   	nop
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	50                   	push   %eax
  801dc3:	6a 23                	push   $0x23
  801dc5:	e8 ef fb ff ff       	call   8019b9 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	90                   	nop
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dd6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd9:	8d 50 04             	lea    0x4(%eax),%edx
  801ddc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	52                   	push   %edx
  801de6:	50                   	push   %eax
  801de7:	6a 24                	push   $0x24
  801de9:	e8 cb fb ff ff       	call   8019b9 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return result;
  801df1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801df7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dfa:	89 01                	mov    %eax,(%ecx)
  801dfc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	c9                   	leave  
  801e03:	c2 04 00             	ret    $0x4

00801e06 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 10             	pushl  0x10(%ebp)
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	6a 13                	push   $0x13
  801e18:	e8 9c fb ff ff       	call   8019b9 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e20:	90                   	nop
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 25                	push   $0x25
  801e32:	e8 82 fb ff ff       	call   8019b9 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e48:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	50                   	push   %eax
  801e55:	6a 26                	push   $0x26
  801e57:	e8 5d fb ff ff       	call   8019b9 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <rsttst>:
void rsttst()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 28                	push   $0x28
  801e71:	e8 43 fb ff ff       	call   8019b9 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	8b 45 14             	mov    0x14(%ebp),%eax
  801e85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e88:	8b 55 18             	mov    0x18(%ebp),%edx
  801e8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e8f:	52                   	push   %edx
  801e90:	50                   	push   %eax
  801e91:	ff 75 10             	pushl  0x10(%ebp)
  801e94:	ff 75 0c             	pushl  0xc(%ebp)
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	6a 27                	push   $0x27
  801e9c:	e8 18 fb ff ff       	call   8019b9 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <chktst>:
void chktst(uint32 n)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	6a 29                	push   $0x29
  801eb7:	e8 fd fa ff ff       	call   8019b9 <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebf:	90                   	nop
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <inctst>:

void inctst()
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 2a                	push   $0x2a
  801ed1:	e8 e3 fa ff ff       	call   8019b9 <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed9:	90                   	nop
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <gettst>:
uint32 gettst()
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 2b                	push   $0x2b
  801eeb:	e8 c9 fa ff ff       	call   8019b9 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 2c                	push   $0x2c
  801f07:	e8 ad fa ff ff       	call   8019b9 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
  801f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f12:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f16:	75 07                	jne    801f1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f18:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1d:	eb 05                	jmp    801f24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 2c                	push   $0x2c
  801f38:	e8 7c fa ff ff       	call   8019b9 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
  801f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f43:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f47:	75 07                	jne    801f50 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f49:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4e:	eb 05                	jmp    801f55 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 2c                	push   $0x2c
  801f69:	e8 4b fa ff ff       	call   8019b9 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
  801f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f74:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f78:	75 07                	jne    801f81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	eb 05                	jmp    801f86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 2c                	push   $0x2c
  801f9a:	e8 1a fa ff ff       	call   8019b9 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
  801fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fa5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fa9:	75 07                	jne    801fb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fab:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb0:	eb 05                	jmp    801fb7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 08             	pushl  0x8(%ebp)
  801fc7:	6a 2d                	push   $0x2d
  801fc9:	e8 eb f9 ff ff       	call   8019b9 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd1:	90                   	nop
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fd8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	53                   	push   %ebx
  801fe7:	51                   	push   %ecx
  801fe8:	52                   	push   %edx
  801fe9:	50                   	push   %eax
  801fea:	6a 2e                	push   $0x2e
  801fec:	e8 c8 f9 ff ff       	call   8019b9 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	52                   	push   %edx
  802009:	50                   	push   %eax
  80200a:	6a 2f                	push   $0x2f
  80200c:	e8 a8 f9 ff ff       	call   8019b9 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80201c:	8b 55 08             	mov    0x8(%ebp),%edx
  80201f:	89 d0                	mov    %edx,%eax
  802021:	c1 e0 02             	shl    $0x2,%eax
  802024:	01 d0                	add    %edx,%eax
  802026:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80202d:	01 d0                	add    %edx,%eax
  80202f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802036:	01 d0                	add    %edx,%eax
  802038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80203f:	01 d0                	add    %edx,%eax
  802041:	c1 e0 04             	shl    $0x4,%eax
  802044:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80204e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	50                   	push   %eax
  802055:	e8 76 fd ff ff       	call   801dd0 <sys_get_virtual_time>
  80205a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80205d:	eb 41                	jmp    8020a0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80205f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	50                   	push   %eax
  802066:	e8 65 fd ff ff       	call   801dd0 <sys_get_virtual_time>
  80206b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80206e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802074:	29 c2                	sub    %eax,%edx
  802076:	89 d0                	mov    %edx,%eax
  802078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80207b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80207e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802081:	89 d1                	mov    %edx,%ecx
  802083:	29 c1                	sub    %eax,%ecx
  802085:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80208b:	39 c2                	cmp    %eax,%edx
  80208d:	0f 97 c0             	seta   %al
  802090:	0f b6 c0             	movzbl %al,%eax
  802093:	29 c1                	sub    %eax,%ecx
  802095:	89 c8                	mov    %ecx,%eax
  802097:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80209a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80209d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020a6:	72 b7                	jb     80205f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8020a8:	90                   	nop
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8020b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8020b8:	eb 03                	jmp    8020bd <busy_wait+0x12>
  8020ba:	ff 45 fc             	incl   -0x4(%ebp)
  8020bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c3:	72 f5                	jb     8020ba <busy_wait+0xf>
	return i;
  8020c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    
  8020ca:	66 90                	xchg   %ax,%ax

008020cc <__udivdi3>:
  8020cc:	55                   	push   %ebp
  8020cd:	57                   	push   %edi
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 1c             	sub    $0x1c,%esp
  8020d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020e3:	89 ca                	mov    %ecx,%edx
  8020e5:	89 f8                	mov    %edi,%eax
  8020e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020eb:	85 f6                	test   %esi,%esi
  8020ed:	75 2d                	jne    80211c <__udivdi3+0x50>
  8020ef:	39 cf                	cmp    %ecx,%edi
  8020f1:	77 65                	ja     802158 <__udivdi3+0x8c>
  8020f3:	89 fd                	mov    %edi,%ebp
  8020f5:	85 ff                	test   %edi,%edi
  8020f7:	75 0b                	jne    802104 <__udivdi3+0x38>
  8020f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fe:	31 d2                	xor    %edx,%edx
  802100:	f7 f7                	div    %edi
  802102:	89 c5                	mov    %eax,%ebp
  802104:	31 d2                	xor    %edx,%edx
  802106:	89 c8                	mov    %ecx,%eax
  802108:	f7 f5                	div    %ebp
  80210a:	89 c1                	mov    %eax,%ecx
  80210c:	89 d8                	mov    %ebx,%eax
  80210e:	f7 f5                	div    %ebp
  802110:	89 cf                	mov    %ecx,%edi
  802112:	89 fa                	mov    %edi,%edx
  802114:	83 c4 1c             	add    $0x1c,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    
  80211c:	39 ce                	cmp    %ecx,%esi
  80211e:	77 28                	ja     802148 <__udivdi3+0x7c>
  802120:	0f bd fe             	bsr    %esi,%edi
  802123:	83 f7 1f             	xor    $0x1f,%edi
  802126:	75 40                	jne    802168 <__udivdi3+0x9c>
  802128:	39 ce                	cmp    %ecx,%esi
  80212a:	72 0a                	jb     802136 <__udivdi3+0x6a>
  80212c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802130:	0f 87 9e 00 00 00    	ja     8021d4 <__udivdi3+0x108>
  802136:	b8 01 00 00 00       	mov    $0x1,%eax
  80213b:	89 fa                	mov    %edi,%edx
  80213d:	83 c4 1c             	add    $0x1c,%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5f                   	pop    %edi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    
  802145:	8d 76 00             	lea    0x0(%esi),%esi
  802148:	31 ff                	xor    %edi,%edi
  80214a:	31 c0                	xor    %eax,%eax
  80214c:	89 fa                	mov    %edi,%edx
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    
  802156:	66 90                	xchg   %ax,%ax
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	f7 f7                	div    %edi
  80215c:	31 ff                	xor    %edi,%edi
  80215e:	89 fa                	mov    %edi,%edx
  802160:	83 c4 1c             	add    $0x1c,%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5f                   	pop    %edi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    
  802168:	bd 20 00 00 00       	mov    $0x20,%ebp
  80216d:	89 eb                	mov    %ebp,%ebx
  80216f:	29 fb                	sub    %edi,%ebx
  802171:	89 f9                	mov    %edi,%ecx
  802173:	d3 e6                	shl    %cl,%esi
  802175:	89 c5                	mov    %eax,%ebp
  802177:	88 d9                	mov    %bl,%cl
  802179:	d3 ed                	shr    %cl,%ebp
  80217b:	89 e9                	mov    %ebp,%ecx
  80217d:	09 f1                	or     %esi,%ecx
  80217f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802183:	89 f9                	mov    %edi,%ecx
  802185:	d3 e0                	shl    %cl,%eax
  802187:	89 c5                	mov    %eax,%ebp
  802189:	89 d6                	mov    %edx,%esi
  80218b:	88 d9                	mov    %bl,%cl
  80218d:	d3 ee                	shr    %cl,%esi
  80218f:	89 f9                	mov    %edi,%ecx
  802191:	d3 e2                	shl    %cl,%edx
  802193:	8b 44 24 08          	mov    0x8(%esp),%eax
  802197:	88 d9                	mov    %bl,%cl
  802199:	d3 e8                	shr    %cl,%eax
  80219b:	09 c2                	or     %eax,%edx
  80219d:	89 d0                	mov    %edx,%eax
  80219f:	89 f2                	mov    %esi,%edx
  8021a1:	f7 74 24 0c          	divl   0xc(%esp)
  8021a5:	89 d6                	mov    %edx,%esi
  8021a7:	89 c3                	mov    %eax,%ebx
  8021a9:	f7 e5                	mul    %ebp
  8021ab:	39 d6                	cmp    %edx,%esi
  8021ad:	72 19                	jb     8021c8 <__udivdi3+0xfc>
  8021af:	74 0b                	je     8021bc <__udivdi3+0xf0>
  8021b1:	89 d8                	mov    %ebx,%eax
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	e9 58 ff ff ff       	jmp    802112 <__udivdi3+0x46>
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021c0:	89 f9                	mov    %edi,%ecx
  8021c2:	d3 e2                	shl    %cl,%edx
  8021c4:	39 c2                	cmp    %eax,%edx
  8021c6:	73 e9                	jae    8021b1 <__udivdi3+0xe5>
  8021c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021cb:	31 ff                	xor    %edi,%edi
  8021cd:	e9 40 ff ff ff       	jmp    802112 <__udivdi3+0x46>
  8021d2:	66 90                	xchg   %ax,%ax
  8021d4:	31 c0                	xor    %eax,%eax
  8021d6:	e9 37 ff ff ff       	jmp    802112 <__udivdi3+0x46>
  8021db:	90                   	nop

008021dc <__umoddi3>:
  8021dc:	55                   	push   %ebp
  8021dd:	57                   	push   %edi
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 1c             	sub    $0x1c,%esp
  8021e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021fb:	89 f3                	mov    %esi,%ebx
  8021fd:	89 fa                	mov    %edi,%edx
  8021ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802203:	89 34 24             	mov    %esi,(%esp)
  802206:	85 c0                	test   %eax,%eax
  802208:	75 1a                	jne    802224 <__umoddi3+0x48>
  80220a:	39 f7                	cmp    %esi,%edi
  80220c:	0f 86 a2 00 00 00    	jbe    8022b4 <__umoddi3+0xd8>
  802212:	89 c8                	mov    %ecx,%eax
  802214:	89 f2                	mov    %esi,%edx
  802216:	f7 f7                	div    %edi
  802218:	89 d0                	mov    %edx,%eax
  80221a:	31 d2                	xor    %edx,%edx
  80221c:	83 c4 1c             	add    $0x1c,%esp
  80221f:	5b                   	pop    %ebx
  802220:	5e                   	pop    %esi
  802221:	5f                   	pop    %edi
  802222:	5d                   	pop    %ebp
  802223:	c3                   	ret    
  802224:	39 f0                	cmp    %esi,%eax
  802226:	0f 87 ac 00 00 00    	ja     8022d8 <__umoddi3+0xfc>
  80222c:	0f bd e8             	bsr    %eax,%ebp
  80222f:	83 f5 1f             	xor    $0x1f,%ebp
  802232:	0f 84 ac 00 00 00    	je     8022e4 <__umoddi3+0x108>
  802238:	bf 20 00 00 00       	mov    $0x20,%edi
  80223d:	29 ef                	sub    %ebp,%edi
  80223f:	89 fe                	mov    %edi,%esi
  802241:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802245:	89 e9                	mov    %ebp,%ecx
  802247:	d3 e0                	shl    %cl,%eax
  802249:	89 d7                	mov    %edx,%edi
  80224b:	89 f1                	mov    %esi,%ecx
  80224d:	d3 ef                	shr    %cl,%edi
  80224f:	09 c7                	or     %eax,%edi
  802251:	89 e9                	mov    %ebp,%ecx
  802253:	d3 e2                	shl    %cl,%edx
  802255:	89 14 24             	mov    %edx,(%esp)
  802258:	89 d8                	mov    %ebx,%eax
  80225a:	d3 e0                	shl    %cl,%eax
  80225c:	89 c2                	mov    %eax,%edx
  80225e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802262:	d3 e0                	shl    %cl,%eax
  802264:	89 44 24 04          	mov    %eax,0x4(%esp)
  802268:	8b 44 24 08          	mov    0x8(%esp),%eax
  80226c:	89 f1                	mov    %esi,%ecx
  80226e:	d3 e8                	shr    %cl,%eax
  802270:	09 d0                	or     %edx,%eax
  802272:	d3 eb                	shr    %cl,%ebx
  802274:	89 da                	mov    %ebx,%edx
  802276:	f7 f7                	div    %edi
  802278:	89 d3                	mov    %edx,%ebx
  80227a:	f7 24 24             	mull   (%esp)
  80227d:	89 c6                	mov    %eax,%esi
  80227f:	89 d1                	mov    %edx,%ecx
  802281:	39 d3                	cmp    %edx,%ebx
  802283:	0f 82 87 00 00 00    	jb     802310 <__umoddi3+0x134>
  802289:	0f 84 91 00 00 00    	je     802320 <__umoddi3+0x144>
  80228f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802293:	29 f2                	sub    %esi,%edx
  802295:	19 cb                	sbb    %ecx,%ebx
  802297:	89 d8                	mov    %ebx,%eax
  802299:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80229d:	d3 e0                	shl    %cl,%eax
  80229f:	89 e9                	mov    %ebp,%ecx
  8022a1:	d3 ea                	shr    %cl,%edx
  8022a3:	09 d0                	or     %edx,%eax
  8022a5:	89 e9                	mov    %ebp,%ecx
  8022a7:	d3 eb                	shr    %cl,%ebx
  8022a9:	89 da                	mov    %ebx,%edx
  8022ab:	83 c4 1c             	add    $0x1c,%esp
  8022ae:	5b                   	pop    %ebx
  8022af:	5e                   	pop    %esi
  8022b0:	5f                   	pop    %edi
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    
  8022b3:	90                   	nop
  8022b4:	89 fd                	mov    %edi,%ebp
  8022b6:	85 ff                	test   %edi,%edi
  8022b8:	75 0b                	jne    8022c5 <__umoddi3+0xe9>
  8022ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bf:	31 d2                	xor    %edx,%edx
  8022c1:	f7 f7                	div    %edi
  8022c3:	89 c5                	mov    %eax,%ebp
  8022c5:	89 f0                	mov    %esi,%eax
  8022c7:	31 d2                	xor    %edx,%edx
  8022c9:	f7 f5                	div    %ebp
  8022cb:	89 c8                	mov    %ecx,%eax
  8022cd:	f7 f5                	div    %ebp
  8022cf:	89 d0                	mov    %edx,%eax
  8022d1:	e9 44 ff ff ff       	jmp    80221a <__umoddi3+0x3e>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	89 c8                	mov    %ecx,%eax
  8022da:	89 f2                	mov    %esi,%edx
  8022dc:	83 c4 1c             	add    $0x1c,%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    
  8022e4:	3b 04 24             	cmp    (%esp),%eax
  8022e7:	72 06                	jb     8022ef <__umoddi3+0x113>
  8022e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022ed:	77 0f                	ja     8022fe <__umoddi3+0x122>
  8022ef:	89 f2                	mov    %esi,%edx
  8022f1:	29 f9                	sub    %edi,%ecx
  8022f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8022f7:	89 14 24             	mov    %edx,(%esp)
  8022fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  802302:	8b 14 24             	mov    (%esp),%edx
  802305:	83 c4 1c             	add    $0x1c,%esp
  802308:	5b                   	pop    %ebx
  802309:	5e                   	pop    %esi
  80230a:	5f                   	pop    %edi
  80230b:	5d                   	pop    %ebp
  80230c:	c3                   	ret    
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	2b 04 24             	sub    (%esp),%eax
  802313:	19 fa                	sbb    %edi,%edx
  802315:	89 d1                	mov    %edx,%ecx
  802317:	89 c6                	mov    %eax,%esi
  802319:	e9 71 ff ff ff       	jmp    80228f <__umoddi3+0xb3>
  80231e:	66 90                	xchg   %ax,%ax
  802320:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802324:	72 ea                	jb     802310 <__umoddi3+0x134>
  802326:	89 d9                	mov    %ebx,%ecx
  802328:	e9 62 ff ff ff       	jmp    80228f <__umoddi3+0xb3>
