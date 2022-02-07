
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 43 02 00 00       	call   800279 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 23                	jmp    80006e <_main+0x36>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	c1 e2 04             	shl    $0x4,%edx
  80005c:	01 d0                	add    %edx,%eax
  80005e:	8a 40 04             	mov    0x4(%eax),%al
  800061:	84 c0                	test   %al,%al
  800063:	74 06                	je     80006b <_main+0x33>
			{
				fullWS = 0;
  800065:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800069:	eb 12                	jmp    80007d <_main+0x45>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006b:	ff 45 f0             	incl   -0x10(%ebp)
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 50 74             	mov    0x74(%eax),%edx
  800076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800079:	39 c2                	cmp    %eax,%edx
  80007b:	77 ce                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800081:	74 14                	je     800097 <_main+0x5f>
  800083:	83 ec 04             	sub    $0x4,%esp
  800086:	68 20 23 80 00       	push   $0x802320
  80008b:	6a 12                	push   $0x12
  80008d:	68 3c 23 80 00       	push   $0x80233c
  800092:	e8 27 03 00 00       	call   8003be <_panic>
	}
	cprintf("************************************************\n");
  800097:	83 ec 0c             	sub    $0xc,%esp
  80009a:	68 54 23 80 00       	push   $0x802354
  80009f:	e8 bc 05 00 00       	call   800660 <cprintf>
  8000a4:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 88 23 80 00       	push   $0x802388
  8000af:	e8 ac 05 00 00       	call   800660 <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 e4 23 80 00       	push   $0x8023e4
  8000bf:	e8 9c 05 00 00       	call   800660 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 18 24 80 00       	push   $0x802418
  8000cf:	e8 8c 05 00 00       	call   800660 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000d7:	83 ec 04             	sub    $0x4,%esp
  8000da:	6a 01                	push   $0x1
  8000dc:	68 00 10 00 00       	push   $0x1000
  8000e1:	68 60 24 80 00       	push   $0x802460
  8000e6:	e8 8c 18 00 00       	call   801977 <smalloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000f1:	e8 be 1a 00 00       	call   801bb4 <sys_calculate_free_frames>
  8000f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	6a 01                	push   $0x1
  8000fe:	68 00 10 00 00       	push   $0x1000
  800103:	68 60 24 80 00       	push   $0x802460
  800108:	e8 6a 18 00 00       	call   801977 <smalloc>
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800113:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 64 24 80 00       	push   $0x802464
  800121:	6a 20                	push   $0x20
  800123:	68 3c 23 80 00       	push   $0x80233c
  800128:	e8 91 02 00 00       	call   8003be <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  80012d:	e8 82 1a 00 00       	call   801bb4 <sys_calculate_free_frames>
  800132:	89 c2                	mov    %eax,%edx
  800134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800137:	39 c2                	cmp    %eax,%edx
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 b8 24 80 00       	push   $0x8024b8
  800143:	6a 21                	push   $0x21
  800145:	68 3c 23 80 00       	push   $0x80233c
  80014a:	e8 6f 02 00 00       	call   8003be <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 14 25 80 00       	push   $0x802514
  800157:	e8 04 05 00 00       	call   800660 <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  80015f:	e8 50 1a 00 00       	call   801bb4 <sys_calculate_free_frames>
  800164:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  800167:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	6a 01                	push   $0x1
  800173:	ff 75 dc             	pushl  -0x24(%ebp)
  800176:	68 6c 25 80 00       	push   $0x80256c
  80017b:	e8 f7 17 00 00       	call   801977 <smalloc>
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800186:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 70 25 80 00       	push   $0x802570
  800194:	6a 29                	push   $0x29
  800196:	68 3c 23 80 00       	push   $0x80233c
  80019b:	e8 1e 02 00 00       	call   8003be <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001a0:	e8 0f 1a 00 00       	call   801bb4 <sys_calculate_free_frames>
  8001a5:	89 c2                	mov    %eax,%edx
  8001a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001aa:	39 c2                	cmp    %eax,%edx
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 e4 25 80 00       	push   $0x8025e4
  8001b6:	6a 2a                	push   $0x2a
  8001b8:	68 3c 23 80 00       	push   $0x80233c
  8001bd:	e8 fc 01 00 00       	call   8003be <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 58 26 80 00       	push   $0x802658
  8001ca:	e8 91 04 00 00       	call   800660 <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001d2:	e8 19 1c 00 00       	call   801df0 <sys_getMaxShares>
  8001d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001e1:	eb 45                	jmp    800228 <_main+0x1f0>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ed:	e8 96 0f 00 00       	call   801188 <ltostr>
  8001f2:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 01                	push   $0x1
  8001fa:	6a 01                	push   $0x1
  8001fc:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  8001ff:	50                   	push   %eax
  800200:	e8 72 17 00 00       	call   801977 <smalloc>
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80020b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020f:	75 14                	jne    800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 cc 26 80 00       	push   $0x8026cc
  800219:	6a 36                	push   $0x36
  80021b:	68 3c 23 80 00       	push   $0x80233c
  800220:	e8 99 01 00 00       	call   8003be <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800225:	ff 45 ec             	incl   -0x14(%ebp)
  800228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80022e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800231:	39 c2                	cmp    %eax,%edx
  800233:	77 ae                	ja     8001e3 <_main+0x1ab>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	6a 01                	push   $0x1
  80023a:	6a 01                	push   $0x1
  80023c:	68 fc 26 80 00       	push   $0x8026fc
  800241:	e8 31 17 00 00       	call   801977 <smalloc>
  800246:	83 c4 10             	add    $0x10,%esp
  800249:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (z != NULL) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  80024c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800250:	74 14                	je     800266 <_main+0x22e>
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	68 08 27 80 00       	push   $0x802708
  80025a:	6a 39                	push   $0x39
  80025c:	68 3c 23 80 00       	push   $0x80233c
  800261:	e8 58 01 00 00       	call   8003be <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 84 27 80 00       	push   $0x802784
  80026e:	e8 ed 03 00 00       	call   800660 <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp

	return;
  800276:	90                   	nop
}
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80027f:	e8 65 18 00 00       	call   801ae9 <sys_getenvindex>
  800284:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80028a:	89 d0                	mov    %edx,%eax
  80028c:	c1 e0 03             	shl    $0x3,%eax
  80028f:	01 d0                	add    %edx,%eax
  800291:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800298:	01 c8                	add    %ecx,%eax
  80029a:	01 c0                	add    %eax,%eax
  80029c:	01 d0                	add    %edx,%eax
  80029e:	01 c0                	add    %eax,%eax
  8002a0:	01 d0                	add    %edx,%eax
  8002a2:	89 c2                	mov    %eax,%edx
  8002a4:	c1 e2 05             	shl    $0x5,%edx
  8002a7:	29 c2                	sub    %eax,%edx
  8002a9:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8002b0:	89 c2                	mov    %eax,%edx
  8002b2:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002b8:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c2:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8002c8:	84 c0                	test   %al,%al
  8002ca:	74 0f                	je     8002db <libmain+0x62>
		binaryname = myEnv->prog_name;
  8002cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d1:	05 40 3c 01 00       	add    $0x13c40,%eax
  8002d6:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002df:	7e 0a                	jle    8002eb <libmain+0x72>
		binaryname = argv[0];
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e4:	8b 00                	mov    (%eax),%eax
  8002e6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	ff 75 0c             	pushl  0xc(%ebp)
  8002f1:	ff 75 08             	pushl  0x8(%ebp)
  8002f4:	e8 3f fd ff ff       	call   800038 <_main>
  8002f9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002fc:	e8 83 19 00 00       	call   801c84 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800301:	83 ec 0c             	sub    $0xc,%esp
  800304:	68 fc 27 80 00       	push   $0x8027fc
  800309:	e8 52 03 00 00       	call   800660 <cprintf>
  80030e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800311:	a1 20 30 80 00       	mov    0x803020,%eax
  800316:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80031c:	a1 20 30 80 00       	mov    0x803020,%eax
  800321:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800327:	83 ec 04             	sub    $0x4,%esp
  80032a:	52                   	push   %edx
  80032b:	50                   	push   %eax
  80032c:	68 24 28 80 00       	push   $0x802824
  800331:	e8 2a 03 00 00       	call   800660 <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800339:	a1 20 30 80 00       	mov    0x803020,%eax
  80033e:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800344:	a1 20 30 80 00       	mov    0x803020,%eax
  800349:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	52                   	push   %edx
  800353:	50                   	push   %eax
  800354:	68 4c 28 80 00       	push   $0x80284c
  800359:	e8 02 03 00 00       	call   800660 <cprintf>
  80035e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800361:	a1 20 30 80 00       	mov    0x803020,%eax
  800366:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	50                   	push   %eax
  800370:	68 8d 28 80 00       	push   $0x80288d
  800375:	e8 e6 02 00 00       	call   800660 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 fc 27 80 00       	push   $0x8027fc
  800385:	e8 d6 02 00 00       	call   800660 <cprintf>
  80038a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80038d:	e8 0c 19 00 00       	call   801c9e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800392:	e8 19 00 00 00       	call   8003b0 <exit>
}
  800397:	90                   	nop
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	6a 00                	push   $0x0
  8003a5:	e8 0b 17 00 00       	call   801ab5 <sys_env_destroy>
  8003aa:	83 c4 10             	add    $0x10,%esp
}
  8003ad:	90                   	nop
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <exit>:

void
exit(void)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8003b6:	e8 60 17 00 00       	call   801b1b <sys_env_exit>
}
  8003bb:	90                   	nop
  8003bc:	c9                   	leave  
  8003bd:	c3                   	ret    

008003be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003c4:	8d 45 10             	lea    0x10(%ebp),%eax
  8003c7:	83 c0 04             	add    $0x4,%eax
  8003ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003cd:	a1 18 31 80 00       	mov    0x803118,%eax
  8003d2:	85 c0                	test   %eax,%eax
  8003d4:	74 16                	je     8003ec <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003d6:	a1 18 31 80 00       	mov    0x803118,%eax
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	50                   	push   %eax
  8003df:	68 a4 28 80 00       	push   $0x8028a4
  8003e4:	e8 77 02 00 00       	call   800660 <cprintf>
  8003e9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ec:	a1 00 30 80 00       	mov    0x803000,%eax
  8003f1:	ff 75 0c             	pushl  0xc(%ebp)
  8003f4:	ff 75 08             	pushl  0x8(%ebp)
  8003f7:	50                   	push   %eax
  8003f8:	68 a9 28 80 00       	push   $0x8028a9
  8003fd:	e8 5e 02 00 00       	call   800660 <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800405:	8b 45 10             	mov    0x10(%ebp),%eax
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	ff 75 f4             	pushl  -0xc(%ebp)
  80040e:	50                   	push   %eax
  80040f:	e8 e1 01 00 00       	call   8005f5 <vcprintf>
  800414:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	6a 00                	push   $0x0
  80041c:	68 c5 28 80 00       	push   $0x8028c5
  800421:	e8 cf 01 00 00       	call   8005f5 <vcprintf>
  800426:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800429:	e8 82 ff ff ff       	call   8003b0 <exit>

	// should not return here
	while (1) ;
  80042e:	eb fe                	jmp    80042e <_panic+0x70>

00800430 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800436:	a1 20 30 80 00       	mov    0x803020,%eax
  80043b:	8b 50 74             	mov    0x74(%eax),%edx
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	39 c2                	cmp    %eax,%edx
  800443:	74 14                	je     800459 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800445:	83 ec 04             	sub    $0x4,%esp
  800448:	68 c8 28 80 00       	push   $0x8028c8
  80044d:	6a 26                	push   $0x26
  80044f:	68 14 29 80 00       	push   $0x802914
  800454:	e8 65 ff ff ff       	call   8003be <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800460:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800467:	e9 b6 00 00 00       	jmp    800522 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80046c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	01 d0                	add    %edx,%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	85 c0                	test   %eax,%eax
  80047f:	75 08                	jne    800489 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800481:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800484:	e9 96 00 00 00       	jmp    80051f <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800489:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800490:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800497:	eb 5d                	jmp    8004f6 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800499:	a1 20 30 80 00       	mov    0x803020,%eax
  80049e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a7:	c1 e2 04             	shl    $0x4,%edx
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	8a 40 04             	mov    0x4(%eax),%al
  8004af:	84 c0                	test   %al,%al
  8004b1:	75 40                	jne    8004f3 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004c1:	c1 e2 04             	shl    $0x4,%edx
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004d3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 c8                	add    %ecx,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e6:	39 c2                	cmp    %eax,%edx
  8004e8:	75 09                	jne    8004f3 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8004ea:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004f1:	eb 12                	jmp    800505 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004f3:	ff 45 e8             	incl   -0x18(%ebp)
  8004f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004fb:	8b 50 74             	mov    0x74(%eax),%edx
  8004fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800501:	39 c2                	cmp    %eax,%edx
  800503:	77 94                	ja     800499 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800505:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800509:	75 14                	jne    80051f <CheckWSWithoutLastIndex+0xef>
			panic(
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 20 29 80 00       	push   $0x802920
  800513:	6a 3a                	push   $0x3a
  800515:	68 14 29 80 00       	push   $0x802914
  80051a:	e8 9f fe ff ff       	call   8003be <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80051f:	ff 45 f0             	incl   -0x10(%ebp)
  800522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800525:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800528:	0f 8c 3e ff ff ff    	jl     80046c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80052e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053c:	eb 20                	jmp    80055e <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80053e:	a1 20 30 80 00       	mov    0x803020,%eax
  800543:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	c1 e2 04             	shl    $0x4,%edx
  80054f:	01 d0                	add    %edx,%eax
  800551:	8a 40 04             	mov    0x4(%eax),%al
  800554:	3c 01                	cmp    $0x1,%al
  800556:	75 03                	jne    80055b <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800558:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055b:	ff 45 e0             	incl   -0x20(%ebp)
  80055e:	a1 20 30 80 00       	mov    0x803020,%eax
  800563:	8b 50 74             	mov    0x74(%eax),%edx
  800566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800569:	39 c2                	cmp    %eax,%edx
  80056b:	77 d1                	ja     80053e <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80056d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800570:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800573:	74 14                	je     800589 <CheckWSWithoutLastIndex+0x159>
		panic(
  800575:	83 ec 04             	sub    $0x4,%esp
  800578:	68 74 29 80 00       	push   $0x802974
  80057d:	6a 44                	push   $0x44
  80057f:	68 14 29 80 00       	push   $0x802914
  800584:	e8 35 fe ff ff       	call   8003be <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800589:	90                   	nop
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800592:	8b 45 0c             	mov    0xc(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	8d 48 01             	lea    0x1(%eax),%ecx
  80059a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059d:	89 0a                	mov    %ecx,(%edx)
  80059f:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a2:	88 d1                	mov    %dl,%cl
  8005a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005b5:	75 2c                	jne    8005e3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005b7:	a0 24 30 80 00       	mov    0x803024,%al
  8005bc:	0f b6 c0             	movzbl %al,%eax
  8005bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c2:	8b 12                	mov    (%edx),%edx
  8005c4:	89 d1                	mov    %edx,%ecx
  8005c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c9:	83 c2 08             	add    $0x8,%edx
  8005cc:	83 ec 04             	sub    $0x4,%esp
  8005cf:	50                   	push   %eax
  8005d0:	51                   	push   %ecx
  8005d1:	52                   	push   %edx
  8005d2:	e8 9c 14 00 00       	call   801a73 <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e6:	8b 40 04             	mov    0x4(%eax),%eax
  8005e9:	8d 50 01             	lea    0x1(%eax),%edx
  8005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ef:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005f2:	90                   	nop
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

008005f5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800605:	00 00 00 
	b.cnt = 0;
  800608:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80060f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	ff 75 08             	pushl  0x8(%ebp)
  800618:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80061e:	50                   	push   %eax
  80061f:	68 8c 05 80 00       	push   $0x80058c
  800624:	e8 11 02 00 00       	call   80083a <vprintfmt>
  800629:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80062c:	a0 24 30 80 00       	mov    0x803024,%al
  800631:	0f b6 c0             	movzbl %al,%eax
  800634:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	50                   	push   %eax
  80063e:	52                   	push   %edx
  80063f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800645:	83 c0 08             	add    $0x8,%eax
  800648:	50                   	push   %eax
  800649:	e8 25 14 00 00       	call   801a73 <sys_cputs>
  80064e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800651:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800658:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80065e:	c9                   	leave  
  80065f:	c3                   	ret    

00800660 <cprintf>:

int cprintf(const char *fmt, ...) {
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800666:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80066d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800670:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 f4             	pushl  -0xc(%ebp)
  80067c:	50                   	push   %eax
  80067d:	e8 73 ff ff ff       	call   8005f5 <vcprintf>
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800688:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068b:	c9                   	leave  
  80068c:	c3                   	ret    

0080068d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800693:	e8 ec 15 00 00       	call   801c84 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800698:	8d 45 0c             	lea    0xc(%ebp),%eax
  80069b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a7:	50                   	push   %eax
  8006a8:	e8 48 ff ff ff       	call   8005f5 <vcprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
  8006b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006b3:	e8 e6 15 00 00       	call   801c9e <sys_enable_interrupt>
	return cnt;
  8006b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	53                   	push   %ebx
  8006c1:	83 ec 14             	sub    $0x14,%esp
  8006c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006db:	77 55                	ja     800732 <printnum+0x75>
  8006dd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006e0:	72 05                	jb     8006e7 <printnum+0x2a>
  8006e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006e5:	77 4b                	ja     800732 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	52                   	push   %edx
  8006f6:	50                   	push   %eax
  8006f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8006fd:	e8 a6 19 00 00       	call   8020a8 <__udivdi3>
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	ff 75 20             	pushl  0x20(%ebp)
  80070b:	53                   	push   %ebx
  80070c:	ff 75 18             	pushl  0x18(%ebp)
  80070f:	52                   	push   %edx
  800710:	50                   	push   %eax
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	ff 75 08             	pushl  0x8(%ebp)
  800717:	e8 a1 ff ff ff       	call   8006bd <printnum>
  80071c:	83 c4 20             	add    $0x20,%esp
  80071f:	eb 1a                	jmp    80073b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	ff 75 20             	pushl  0x20(%ebp)
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	ff d0                	call   *%eax
  80072f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800732:	ff 4d 1c             	decl   0x1c(%ebp)
  800735:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800739:	7f e6                	jg     800721 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80073b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80073e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800749:	53                   	push   %ebx
  80074a:	51                   	push   %ecx
  80074b:	52                   	push   %edx
  80074c:	50                   	push   %eax
  80074d:	e8 66 1a 00 00       	call   8021b8 <__umoddi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	05 d4 2b 80 00       	add    $0x802bd4,%eax
  80075a:	8a 00                	mov    (%eax),%al
  80075c:	0f be c0             	movsbl %al,%eax
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	50                   	push   %eax
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	ff d0                	call   *%eax
  80076b:	83 c4 10             	add    $0x10,%esp
}
  80076e:	90                   	nop
  80076f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800777:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077b:	7e 1c                	jle    800799 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	8d 50 08             	lea    0x8(%eax),%edx
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	89 10                	mov    %edx,(%eax)
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	83 e8 08             	sub    $0x8,%eax
  800792:	8b 50 04             	mov    0x4(%eax),%edx
  800795:	8b 00                	mov    (%eax),%eax
  800797:	eb 40                	jmp    8007d9 <getuint+0x65>
	else if (lflag)
  800799:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079d:	74 1e                	je     8007bd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	8d 50 04             	lea    0x4(%eax),%edx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	89 10                	mov    %edx,(%eax)
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	83 e8 04             	sub    $0x4,%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bb:	eb 1c                	jmp    8007d9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	8d 50 04             	lea    0x4(%eax),%edx
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	89 10                	mov    %edx,(%eax)
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	83 e8 04             	sub    $0x4,%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007de:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007e2:	7e 1c                	jle    800800 <getint+0x25>
		return va_arg(*ap, long long);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	8d 50 08             	lea    0x8(%eax),%edx
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	89 10                	mov    %edx,(%eax)
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	83 e8 08             	sub    $0x8,%eax
  8007f9:	8b 50 04             	mov    0x4(%eax),%edx
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	eb 38                	jmp    800838 <getint+0x5d>
	else if (lflag)
  800800:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800804:	74 1a                	je     800820 <getint+0x45>
		return va_arg(*ap, long);
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	8d 50 04             	lea    0x4(%eax),%edx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	89 10                	mov    %edx,(%eax)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	83 e8 04             	sub    $0x4,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	99                   	cltd   
  80081e:	eb 18                	jmp    800838 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	8d 50 04             	lea    0x4(%eax),%edx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	89 10                	mov    %edx,(%eax)
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	83 e8 04             	sub    $0x4,%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	99                   	cltd   
}
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	56                   	push   %esi
  80083e:	53                   	push   %ebx
  80083f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800842:	eb 17                	jmp    80085b <vprintfmt+0x21>
			if (ch == '\0')
  800844:	85 db                	test   %ebx,%ebx
  800846:	0f 84 af 03 00 00    	je     800bfb <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	53                   	push   %ebx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085b:	8b 45 10             	mov    0x10(%ebp),%eax
  80085e:	8d 50 01             	lea    0x1(%eax),%edx
  800861:	89 55 10             	mov    %edx,0x10(%ebp)
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f b6 d8             	movzbl %al,%ebx
  800869:	83 fb 25             	cmp    $0x25,%ebx
  80086c:	75 d6                	jne    800844 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80086e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800872:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800879:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800880:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800887:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088e:	8b 45 10             	mov    0x10(%ebp),%eax
  800891:	8d 50 01             	lea    0x1(%eax),%edx
  800894:	89 55 10             	mov    %edx,0x10(%ebp)
  800897:	8a 00                	mov    (%eax),%al
  800899:	0f b6 d8             	movzbl %al,%ebx
  80089c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80089f:	83 f8 55             	cmp    $0x55,%eax
  8008a2:	0f 87 2b 03 00 00    	ja     800bd3 <vprintfmt+0x399>
  8008a8:	8b 04 85 f8 2b 80 00 	mov    0x802bf8(,%eax,4),%eax
  8008af:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008b1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008b5:	eb d7                	jmp    80088e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008b7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008bb:	eb d1                	jmp    80088e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c7:	89 d0                	mov    %edx,%eax
  8008c9:	c1 e0 02             	shl    $0x2,%eax
  8008cc:	01 d0                	add    %edx,%eax
  8008ce:	01 c0                	add    %eax,%eax
  8008d0:	01 d8                	add    %ebx,%eax
  8008d2:	83 e8 30             	sub    $0x30,%eax
  8008d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008db:	8a 00                	mov    (%eax),%al
  8008dd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008e0:	83 fb 2f             	cmp    $0x2f,%ebx
  8008e3:	7e 3e                	jle    800923 <vprintfmt+0xe9>
  8008e5:	83 fb 39             	cmp    $0x39,%ebx
  8008e8:	7f 39                	jg     800923 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ea:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ed:	eb d5                	jmp    8008c4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	83 c0 04             	add    $0x4,%eax
  8008f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800903:	eb 1f                	jmp    800924 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	79 83                	jns    80088e <vprintfmt+0x54>
				width = 0;
  80090b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800912:	e9 77 ff ff ff       	jmp    80088e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800917:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80091e:	e9 6b ff ff ff       	jmp    80088e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800923:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800928:	0f 89 60 ff ff ff    	jns    80088e <vprintfmt+0x54>
				width = precision, precision = -1;
  80092e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800931:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800934:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80093b:	e9 4e ff ff ff       	jmp    80088e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800940:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800943:	e9 46 ff ff ff       	jmp    80088e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 c0 04             	add    $0x4,%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	50                   	push   %eax
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	ff d0                	call   *%eax
  800965:	83 c4 10             	add    $0x10,%esp
			break;
  800968:	e9 89 02 00 00       	jmp    800bf6 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	83 c0 04             	add    $0x4,%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80097e:	85 db                	test   %ebx,%ebx
  800980:	79 02                	jns    800984 <vprintfmt+0x14a>
				err = -err;
  800982:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800984:	83 fb 64             	cmp    $0x64,%ebx
  800987:	7f 0b                	jg     800994 <vprintfmt+0x15a>
  800989:	8b 34 9d 40 2a 80 00 	mov    0x802a40(,%ebx,4),%esi
  800990:	85 f6                	test   %esi,%esi
  800992:	75 19                	jne    8009ad <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800994:	53                   	push   %ebx
  800995:	68 e5 2b 80 00       	push   $0x802be5
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	ff 75 08             	pushl  0x8(%ebp)
  8009a0:	e8 5e 02 00 00       	call   800c03 <printfmt>
  8009a5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009a8:	e9 49 02 00 00       	jmp    800bf6 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ad:	56                   	push   %esi
  8009ae:	68 ee 2b 80 00       	push   $0x802bee
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	ff 75 08             	pushl  0x8(%ebp)
  8009b9:	e8 45 02 00 00       	call   800c03 <printfmt>
  8009be:	83 c4 10             	add    $0x10,%esp
			break;
  8009c1:	e9 30 02 00 00       	jmp    800bf6 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 c0 04             	add    $0x4,%eax
  8009cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 30                	mov    (%eax),%esi
  8009d7:	85 f6                	test   %esi,%esi
  8009d9:	75 05                	jne    8009e0 <vprintfmt+0x1a6>
				p = "(null)";
  8009db:	be f1 2b 80 00       	mov    $0x802bf1,%esi
			if (width > 0 && padc != '-')
  8009e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e4:	7e 6d                	jle    800a53 <vprintfmt+0x219>
  8009e6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ea:	74 67                	je     800a53 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	50                   	push   %eax
  8009f3:	56                   	push   %esi
  8009f4:	e8 0c 03 00 00       	call   800d05 <strnlen>
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009ff:	eb 16                	jmp    800a17 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a01:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	50                   	push   %eax
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a14:	ff 4d e4             	decl   -0x1c(%ebp)
  800a17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1b:	7f e4                	jg     800a01 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a1d:	eb 34                	jmp    800a53 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a23:	74 1c                	je     800a41 <vprintfmt+0x207>
  800a25:	83 fb 1f             	cmp    $0x1f,%ebx
  800a28:	7e 05                	jle    800a2f <vprintfmt+0x1f5>
  800a2a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a2d:	7e 12                	jle    800a41 <vprintfmt+0x207>
					putch('?', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 3f                	push   $0x3f
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	eb 0f                	jmp    800a50 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	53                   	push   %ebx
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a50:	ff 4d e4             	decl   -0x1c(%ebp)
  800a53:	89 f0                	mov    %esi,%eax
  800a55:	8d 70 01             	lea    0x1(%eax),%esi
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	0f be d8             	movsbl %al,%ebx
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	74 24                	je     800a85 <vprintfmt+0x24b>
  800a61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a65:	78 b8                	js     800a1f <vprintfmt+0x1e5>
  800a67:	ff 4d e0             	decl   -0x20(%ebp)
  800a6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a6e:	79 af                	jns    800a1f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a70:	eb 13                	jmp    800a85 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	6a 20                	push   $0x20
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a82:	ff 4d e4             	decl   -0x1c(%ebp)
  800a85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a89:	7f e7                	jg     800a72 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a8b:	e9 66 01 00 00       	jmp    800bf6 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 e8             	pushl  -0x18(%ebp)
  800a96:	8d 45 14             	lea    0x14(%ebp),%eax
  800a99:	50                   	push   %eax
  800a9a:	e8 3c fd ff ff       	call   8007db <getint>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aae:	85 d2                	test   %edx,%edx
  800ab0:	79 23                	jns    800ad5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	6a 2d                	push   $0x2d
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	ff d0                	call   *%eax
  800abf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac8:	f7 d8                	neg    %eax
  800aca:	83 d2 00             	adc    $0x0,%edx
  800acd:	f7 da                	neg    %edx
  800acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ad5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800adc:	e9 bc 00 00 00       	jmp    800b9d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae7:	8d 45 14             	lea    0x14(%ebp),%eax
  800aea:	50                   	push   %eax
  800aeb:	e8 84 fc ff ff       	call   800774 <getuint>
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800af9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b00:	e9 98 00 00 00       	jmp    800b9d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	6a 58                	push   $0x58
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	ff d0                	call   *%eax
  800b12:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	6a 58                	push   $0x58
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 0c             	pushl  0xc(%ebp)
  800b2b:	6a 58                	push   $0x58
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	ff d0                	call   *%eax
  800b32:	83 c4 10             	add    $0x10,%esp
			break;
  800b35:	e9 bc 00 00 00       	jmp    800bf6 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	6a 30                	push   $0x30
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	ff d0                	call   *%eax
  800b47:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	6a 78                	push   $0x78
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5d:	83 c0 04             	add    $0x4,%eax
  800b60:	89 45 14             	mov    %eax,0x14(%ebp)
  800b63:	8b 45 14             	mov    0x14(%ebp),%eax
  800b66:	83 e8 04             	sub    $0x4,%eax
  800b69:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b7c:	eb 1f                	jmp    800b9d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 e8             	pushl  -0x18(%ebp)
  800b84:	8d 45 14             	lea    0x14(%ebp),%eax
  800b87:	50                   	push   %eax
  800b88:	e8 e7 fb ff ff       	call   800774 <getuint>
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b93:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b9d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bab:	50                   	push   %eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	ff 75 f0             	pushl  -0x10(%ebp)
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 00 fb ff ff       	call   8006bd <printnum>
  800bbd:	83 c4 20             	add    $0x20,%esp
			break;
  800bc0:	eb 34                	jmp    800bf6 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	53                   	push   %ebx
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			break;
  800bd1:	eb 23                	jmp    800bf6 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 25                	push   $0x25
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be3:	ff 4d 10             	decl   0x10(%ebp)
  800be6:	eb 03                	jmp    800beb <vprintfmt+0x3b1>
  800be8:	ff 4d 10             	decl   0x10(%ebp)
  800beb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bee:	48                   	dec    %eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	3c 25                	cmp    $0x25,%al
  800bf3:	75 f3                	jne    800be8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bf5:	90                   	nop
		}
	}
  800bf6:	e9 47 fc ff ff       	jmp    800842 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bfb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c09:	8d 45 10             	lea    0x10(%ebp),%eax
  800c0c:	83 c0 04             	add    $0x4,%eax
  800c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	ff 75 f4             	pushl  -0xc(%ebp)
  800c18:	50                   	push   %eax
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	ff 75 08             	pushl  0x8(%ebp)
  800c1f:	e8 16 fc ff ff       	call   80083a <vprintfmt>
  800c24:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c27:	90                   	nop
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 40 08             	mov    0x8(%eax),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 10                	mov    (%eax),%edx
  800c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c44:	8b 40 04             	mov    0x4(%eax),%eax
  800c47:	39 c2                	cmp    %eax,%edx
  800c49:	73 12                	jae    800c5d <sprintputch+0x33>
		*b->buf++ = ch;
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	8d 48 01             	lea    0x1(%eax),%ecx
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	89 0a                	mov    %ecx,(%edx)
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	88 10                	mov    %dl,(%eax)
}
  800c5d:	90                   	nop
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

00800c60 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	01 d0                	add    %edx,%eax
  800c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c85:	74 06                	je     800c8d <vsnprintf+0x2d>
  800c87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8b:	7f 07                	jg     800c94 <vsnprintf+0x34>
		return -E_INVAL;
  800c8d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c92:	eb 20                	jmp    800cb4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c94:	ff 75 14             	pushl  0x14(%ebp)
  800c97:	ff 75 10             	pushl  0x10(%ebp)
  800c9a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c9d:	50                   	push   %eax
  800c9e:	68 2a 0c 80 00       	push   $0x800c2a
  800ca3:	e8 92 fb ff ff       	call   80083a <vprintfmt>
  800ca8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cbc:	8d 45 10             	lea    0x10(%ebp),%eax
  800cbf:	83 c0 04             	add    $0x4,%eax
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccb:	50                   	push   %eax
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	ff 75 08             	pushl  0x8(%ebp)
  800cd2:	e8 89 ff ff ff       	call   800c60 <vsnprintf>
  800cd7:	83 c4 10             	add    $0x10,%esp
  800cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cef:	eb 06                	jmp    800cf7 <strlen+0x15>
		n++;
  800cf1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf4:	ff 45 08             	incl   0x8(%ebp)
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	84 c0                	test   %al,%al
  800cfe:	75 f1                	jne    800cf1 <strlen+0xf>
		n++;
	return n;
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 09                	jmp    800d1d <strnlen+0x18>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	ff 4d 0c             	decl   0xc(%ebp)
  800d1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d21:	74 09                	je     800d2c <strnlen+0x27>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e8                	jne    800d14 <strnlen+0xf>
		n++;
	return n;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d3d:	90                   	nop
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8d 50 01             	lea    0x1(%eax),%edx
  800d44:	89 55 08             	mov    %edx,0x8(%ebp)
  800d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d50:	8a 12                	mov    (%edx),%dl
  800d52:	88 10                	mov    %dl,(%eax)
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	84 c0                	test   %al,%al
  800d58:	75 e4                	jne    800d3e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d72:	eb 1f                	jmp    800d93 <strncpy+0x34>
		*dst++ = *src;
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8d 50 01             	lea    0x1(%eax),%edx
  800d7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	8a 12                	mov    (%edx),%dl
  800d82:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	74 03                	je     800d90 <strncpy+0x31>
			src++;
  800d8d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d90:	ff 45 fc             	incl   -0x4(%ebp)
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d99:	72 d9                	jb     800d74 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db0:	74 30                	je     800de2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db2:	eb 16                	jmp    800dca <strlcpy+0x2a>
			*dst++ = *src++;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 08             	mov    %edx,0x8(%ebp)
  800dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dc6:	8a 12                	mov    (%edx),%dl
  800dc8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dca:	ff 4d 10             	decl   0x10(%ebp)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	74 09                	je     800ddc <strlcpy+0x3c>
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	84 c0                	test   %al,%al
  800dda:	75 d8                	jne    800db4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df1:	eb 06                	jmp    800df9 <strcmp+0xb>
		p++, q++;
  800df3:	ff 45 08             	incl   0x8(%ebp)
  800df6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8a 00                	mov    (%eax),%al
  800dfe:	84 c0                	test   %al,%al
  800e00:	74 0e                	je     800e10 <strcmp+0x22>
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 10                	mov    (%eax),%dl
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	38 c2                	cmp    %al,%dl
  800e0e:	74 e3                	je     800df3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f b6 d0             	movzbl %al,%edx
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	0f b6 c0             	movzbl %al,%eax
  800e20:	29 c2                	sub    %eax,%edx
  800e22:	89 d0                	mov    %edx,%eax
}
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e29:	eb 09                	jmp    800e34 <strncmp+0xe>
		n--, p++, q++;
  800e2b:	ff 4d 10             	decl   0x10(%ebp)
  800e2e:	ff 45 08             	incl   0x8(%ebp)
  800e31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e38:	74 17                	je     800e51 <strncmp+0x2b>
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	84 c0                	test   %al,%al
  800e41:	74 0e                	je     800e51 <strncmp+0x2b>
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8a 10                	mov    (%eax),%dl
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	38 c2                	cmp    %al,%dl
  800e4f:	74 da                	je     800e2b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e55:	75 07                	jne    800e5e <strncmp+0x38>
		return 0;
  800e57:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5c:	eb 14                	jmp    800e72 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	0f b6 d0             	movzbl %al,%edx
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	0f b6 c0             	movzbl %al,%eax
  800e6e:	29 c2                	sub    %eax,%edx
  800e70:	89 d0                	mov    %edx,%eax
}
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 04             	sub    $0x4,%esp
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e80:	eb 12                	jmp    800e94 <strchr+0x20>
		if (*s == c)
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8a:	75 05                	jne    800e91 <strchr+0x1d>
			return (char *) s;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	eb 11                	jmp    800ea2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e91:	ff 45 08             	incl   0x8(%ebp)
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	84 c0                	test   %al,%al
  800e9b:	75 e5                	jne    800e82 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb0:	eb 0d                	jmp    800ebf <strfind+0x1b>
		if (*s == c)
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eba:	74 0e                	je     800eca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ebc:	ff 45 08             	incl   0x8(%ebp)
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	84 c0                	test   %al,%al
  800ec6:	75 ea                	jne    800eb2 <strfind+0xe>
  800ec8:	eb 01                	jmp    800ecb <strfind+0x27>
		if (*s == c)
			break;
  800eca:	90                   	nop
	return (char *) s;
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800edc:	8b 45 10             	mov    0x10(%ebp),%eax
  800edf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ee2:	eb 0e                	jmp    800ef2 <memset+0x22>
		*p++ = c;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ef2:	ff 4d f8             	decl   -0x8(%ebp)
  800ef5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ef9:	79 e9                	jns    800ee4 <memset+0x14>
		*p++ = c;

	return v;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f12:	eb 16                	jmp    800f2a <memcpy+0x2a>
		*d++ = *s++;
  800f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f17:	8d 50 01             	lea    0x1(%eax),%edx
  800f1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f23:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f26:	8a 12                	mov    (%edx),%dl
  800f28:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f30:	89 55 10             	mov    %edx,0x10(%ebp)
  800f33:	85 c0                	test   %eax,%eax
  800f35:	75 dd                	jne    800f14 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f54:	73 50                	jae    800fa6 <memmove+0x6a>
  800f56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f59:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5c:	01 d0                	add    %edx,%eax
  800f5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f61:	76 43                	jbe    800fa6 <memmove+0x6a>
		s += n;
  800f63:	8b 45 10             	mov    0x10(%ebp),%eax
  800f66:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f69:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f6f:	eb 10                	jmp    800f81 <memmove+0x45>
			*--d = *--s;
  800f71:	ff 4d f8             	decl   -0x8(%ebp)
  800f74:	ff 4d fc             	decl   -0x4(%ebp)
  800f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7a:	8a 10                	mov    (%eax),%dl
  800f7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f87:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	75 e3                	jne    800f71 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f8e:	eb 23                	jmp    800fb3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f93:	8d 50 01             	lea    0x1(%eax),%edx
  800f96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa2:	8a 12                	mov    (%edx),%dl
  800fa4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fac:	89 55 10             	mov    %edx,0x10(%ebp)
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	75 dd                	jne    800f90 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fca:	eb 2a                	jmp    800ff6 <memcmp+0x3e>
		if (*s1 != *s2)
  800fcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcf:	8a 10                	mov    (%eax),%dl
  800fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	38 c2                	cmp    %al,%dl
  800fd8:	74 16                	je     800ff0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	0f b6 d0             	movzbl %al,%edx
  800fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	0f b6 c0             	movzbl %al,%eax
  800fea:	29 c2                	sub    %eax,%edx
  800fec:	89 d0                	mov    %edx,%eax
  800fee:	eb 18                	jmp    801008 <memcmp+0x50>
		s1++, s2++;
  800ff0:	ff 45 fc             	incl   -0x4(%ebp)
  800ff3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 c9                	jne    800fcc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801008:	c9                   	leave  
  801009:	c3                   	ret    

0080100a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801010:	8b 55 08             	mov    0x8(%ebp),%edx
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80101b:	eb 15                	jmp    801032 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f b6 d0             	movzbl %al,%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	0f b6 c0             	movzbl %al,%eax
  80102b:	39 c2                	cmp    %eax,%edx
  80102d:	74 0d                	je     80103c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801038:	72 e3                	jb     80101d <memfind+0x13>
  80103a:	eb 01                	jmp    80103d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80103c:	90                   	nop
	return (void *) s;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801048:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80104f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801056:	eb 03                	jmp    80105b <strtol+0x19>
		s++;
  801058:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	3c 20                	cmp    $0x20,%al
  801062:	74 f4                	je     801058 <strtol+0x16>
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3c 09                	cmp    $0x9,%al
  80106b:	74 eb                	je     801058 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 2b                	cmp    $0x2b,%al
  801074:	75 05                	jne    80107b <strtol+0x39>
		s++;
  801076:	ff 45 08             	incl   0x8(%ebp)
  801079:	eb 13                	jmp    80108e <strtol+0x4c>
	else if (*s == '-')
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	3c 2d                	cmp    $0x2d,%al
  801082:	75 0a                	jne    80108e <strtol+0x4c>
		s++, neg = 1;
  801084:	ff 45 08             	incl   0x8(%ebp)
  801087:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80108e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801092:	74 06                	je     80109a <strtol+0x58>
  801094:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801098:	75 20                	jne    8010ba <strtol+0x78>
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3c 30                	cmp    $0x30,%al
  8010a1:	75 17                	jne    8010ba <strtol+0x78>
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	40                   	inc    %eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 78                	cmp    $0x78,%al
  8010ab:	75 0d                	jne    8010ba <strtol+0x78>
		s += 2, base = 16;
  8010ad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010b8:	eb 28                	jmp    8010e2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010be:	75 15                	jne    8010d5 <strtol+0x93>
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 30                	cmp    $0x30,%al
  8010c7:	75 0c                	jne    8010d5 <strtol+0x93>
		s++, base = 8;
  8010c9:	ff 45 08             	incl   0x8(%ebp)
  8010cc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010d3:	eb 0d                	jmp    8010e2 <strtol+0xa0>
	else if (base == 0)
  8010d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d9:	75 07                	jne    8010e2 <strtol+0xa0>
		base = 10;
  8010db:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 2f                	cmp    $0x2f,%al
  8010e9:	7e 19                	jle    801104 <strtol+0xc2>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	3c 39                	cmp    $0x39,%al
  8010f2:	7f 10                	jg     801104 <strtol+0xc2>
			dig = *s - '0';
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f be c0             	movsbl %al,%eax
  8010fc:	83 e8 30             	sub    $0x30,%eax
  8010ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801102:	eb 42                	jmp    801146 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 60                	cmp    $0x60,%al
  80110b:	7e 19                	jle    801126 <strtol+0xe4>
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 7a                	cmp    $0x7a,%al
  801114:	7f 10                	jg     801126 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	0f be c0             	movsbl %al,%eax
  80111e:	83 e8 57             	sub    $0x57,%eax
  801121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801124:	eb 20                	jmp    801146 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 40                	cmp    $0x40,%al
  80112d:	7e 39                	jle    801168 <strtol+0x126>
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	3c 5a                	cmp    $0x5a,%al
  801136:	7f 30                	jg     801168 <strtol+0x126>
			dig = *s - 'A' + 10;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	0f be c0             	movsbl %al,%eax
  801140:	83 e8 37             	sub    $0x37,%eax
  801143:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801149:	3b 45 10             	cmp    0x10(%ebp),%eax
  80114c:	7d 19                	jge    801167 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80114e:	ff 45 08             	incl   0x8(%ebp)
  801151:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801154:	0f af 45 10          	imul   0x10(%ebp),%eax
  801158:	89 c2                	mov    %eax,%edx
  80115a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801162:	e9 7b ff ff ff       	jmp    8010e2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801167:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801168:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116c:	74 08                	je     801176 <strtol+0x134>
		*endptr = (char *) s;
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8b 55 08             	mov    0x8(%ebp),%edx
  801174:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801176:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117a:	74 07                	je     801183 <strtol+0x141>
  80117c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117f:	f7 d8                	neg    %eax
  801181:	eb 03                	jmp    801186 <strtol+0x144>
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <ltostr>:

void
ltostr(long value, char *str)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80119c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a0:	79 13                	jns    8011b5 <ltostr+0x2d>
	{
		neg = 1;
  8011a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011af:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011bd:	99                   	cltd   
  8011be:	f7 f9                	idiv   %ecx
  8011c0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c6:	8d 50 01             	lea    0x1(%eax),%edx
  8011c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011cc:	89 c2                	mov    %eax,%edx
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011d6:	83 c2 30             	add    $0x30,%edx
  8011d9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011de:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e3:	f7 e9                	imul   %ecx
  8011e5:	c1 fa 02             	sar    $0x2,%edx
  8011e8:	89 c8                	mov    %ecx,%eax
  8011ea:	c1 f8 1f             	sar    $0x1f,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011fc:	f7 e9                	imul   %ecx
  8011fe:	c1 fa 02             	sar    $0x2,%edx
  801201:	89 c8                	mov    %ecx,%eax
  801203:	c1 f8 1f             	sar    $0x1f,%eax
  801206:	29 c2                	sub    %eax,%edx
  801208:	89 d0                	mov    %edx,%eax
  80120a:	c1 e0 02             	shl    $0x2,%eax
  80120d:	01 d0                	add    %edx,%eax
  80120f:	01 c0                	add    %eax,%eax
  801211:	29 c1                	sub    %eax,%ecx
  801213:	89 ca                	mov    %ecx,%edx
  801215:	85 d2                	test   %edx,%edx
  801217:	75 9c                	jne    8011b5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801219:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801220:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801223:	48                   	dec    %eax
  801224:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801227:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122b:	74 3d                	je     80126a <ltostr+0xe2>
		start = 1 ;
  80122d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801234:	eb 34                	jmp    80126a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801236:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	01 d0                	add    %edx,%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801243:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	01 c2                	add    %eax,%edx
  80124b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 c8                	add    %ecx,%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801257:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	01 c2                	add    %eax,%edx
  80125f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801262:	88 02                	mov    %al,(%edx)
		start++ ;
  801264:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801267:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801270:	7c c4                	jl     801236 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801272:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80127d:	90                   	nop
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801286:	ff 75 08             	pushl  0x8(%ebp)
  801289:	e8 54 fa ff ff       	call   800ce2 <strlen>
  80128e:	83 c4 04             	add    $0x4,%esp
  801291:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	e8 46 fa ff ff       	call   800ce2 <strlen>
  80129c:	83 c4 04             	add    $0x4,%esp
  80129f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b0:	eb 17                	jmp    8012c9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	01 c2                	add    %eax,%edx
  8012ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	01 c8                	add    %ecx,%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c6:	ff 45 fc             	incl   -0x4(%ebp)
  8012c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012cf:	7c e1                	jl     8012b2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012df:	eb 1f                	jmp    801300 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8d 50 01             	lea    0x1(%eax),%edx
  8012e7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ea:	89 c2                	mov    %eax,%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 c2                	add    %eax,%edx
  8012f1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	01 c8                	add    %ecx,%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012fd:	ff 45 f8             	incl   -0x8(%ebp)
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801303:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801306:	7c d9                	jl     8012e1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801308:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130b:	8b 45 10             	mov    0x10(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	c6 00 00             	movb   $0x0,(%eax)
}
  801313:	90                   	nop
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801319:	8b 45 14             	mov    0x14(%ebp),%eax
  80131c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801322:	8b 45 14             	mov    0x14(%ebp),%eax
  801325:	8b 00                	mov    (%eax),%eax
  801327:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801339:	eb 0c                	jmp    801347 <strsplit+0x31>
			*string++ = 0;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8d 50 01             	lea    0x1(%eax),%edx
  801341:	89 55 08             	mov    %edx,0x8(%ebp)
  801344:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8a 00                	mov    (%eax),%al
  80134c:	84 c0                	test   %al,%al
  80134e:	74 18                	je     801368 <strsplit+0x52>
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	0f be c0             	movsbl %al,%eax
  801358:	50                   	push   %eax
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	e8 13 fb ff ff       	call   800e74 <strchr>
  801361:	83 c4 08             	add    $0x8,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	75 d3                	jne    80133b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	84 c0                	test   %al,%al
  80136f:	74 5a                	je     8013cb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801371:	8b 45 14             	mov    0x14(%ebp),%eax
  801374:	8b 00                	mov    (%eax),%eax
  801376:	83 f8 0f             	cmp    $0xf,%eax
  801379:	75 07                	jne    801382 <strsplit+0x6c>
		{
			return 0;
  80137b:	b8 00 00 00 00       	mov    $0x0,%eax
  801380:	eb 66                	jmp    8013e8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801382:	8b 45 14             	mov    0x14(%ebp),%eax
  801385:	8b 00                	mov    (%eax),%eax
  801387:	8d 48 01             	lea    0x1(%eax),%ecx
  80138a:	8b 55 14             	mov    0x14(%ebp),%edx
  80138d:	89 0a                	mov    %ecx,(%edx)
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 c2                	add    %eax,%edx
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a0:	eb 03                	jmp    8013a5 <strsplit+0x8f>
			string++;
  8013a2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 8b                	je     801339 <strsplit+0x23>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	0f be c0             	movsbl %al,%eax
  8013b6:	50                   	push   %eax
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	e8 b5 fa ff ff       	call   800e74 <strchr>
  8013bf:	83 c4 08             	add    $0x8,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	74 dc                	je     8013a2 <strsplit+0x8c>
			string++;
	}
  8013c6:	e9 6e ff ff ff       	jmp    801339 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013cb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cf:	8b 00                	mov    (%eax),%eax
  8013d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013db:	01 d0                	add    %edx,%eax
  8013dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8013f0:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8013f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	48                   	dec    %eax
  801400:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801403:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801406:	ba 00 00 00 00       	mov    $0x0,%edx
  80140b:	f7 75 ac             	divl   -0x54(%ebp)
  80140e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801411:	29 d0                	sub    %edx,%eax
  801413:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  80141d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801424:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80142b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801432:	eb 3f                	jmp    801473 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801437:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	50                   	push   %eax
  801442:	ff 75 e8             	pushl  -0x18(%ebp)
  801445:	68 50 2d 80 00       	push   $0x802d50
  80144a:	e8 11 f2 ff ff       	call   800660 <cprintf>
  80144f:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801455:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80145c:	83 ec 04             	sub    $0x4,%esp
  80145f:	50                   	push   %eax
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	68 65 2d 80 00       	push   $0x802d65
  801468:	e8 f3 f1 ff ff       	call   800660 <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801470:	ff 45 e8             	incl   -0x18(%ebp)
  801473:	a1 28 30 80 00       	mov    0x803028,%eax
  801478:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80147b:	7c b7                	jl     801434 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80147d:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801484:	e9 35 01 00 00       	jmp    8015be <malloc+0x1d4>
		int flag0=1;
  801489:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801493:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801496:	eb 5e                	jmp    8014f6 <malloc+0x10c>
			for(int k=0;k<count;k++){
  801498:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80149f:	eb 35                	jmp    8014d6 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8014a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a4:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8014ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ae:	39 c2                	cmp    %eax,%edx
  8014b0:	77 21                	ja     8014d3 <malloc+0xe9>
  8014b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b5:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bf:	39 c2                	cmp    %eax,%edx
  8014c1:	76 10                	jbe    8014d3 <malloc+0xe9>
					ni=PAGE_SIZE;
  8014c3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  8014ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8014d1:	eb 0d                	jmp    8014e0 <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8014d3:	ff 45 d8             	incl   -0x28(%ebp)
  8014d6:	a1 28 30 80 00       	mov    0x803028,%eax
  8014db:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8014de:	7c c1                	jl     8014a1 <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8014e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014e4:	74 09                	je     8014ef <malloc+0x105>
				flag0=0;
  8014e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8014ed:	eb 16                	jmp    801505 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8014ef:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8014f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	01 c2                	add    %eax,%edx
  8014fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801501:	39 c2                	cmp    %eax,%edx
  801503:	77 93                	ja     801498 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801505:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801509:	0f 84 a2 00 00 00    	je     8015b1 <malloc+0x1c7>

			int f=1;
  80150f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801516:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801519:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80151c:	89 c8                	mov    %ecx,%eax
  80151e:	01 c0                	add    %eax,%eax
  801520:	01 c8                	add    %ecx,%eax
  801522:	c1 e0 02             	shl    $0x2,%eax
  801525:	05 20 31 80 00       	add    $0x803120,%eax
  80152a:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80152c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801538:	89 d0                	mov    %edx,%eax
  80153a:	01 c0                	add    %eax,%eax
  80153c:	01 d0                	add    %edx,%eax
  80153e:	c1 e0 02             	shl    $0x2,%eax
  801541:	05 24 31 80 00       	add    $0x803124,%eax
  801546:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154b:	89 d0                	mov    %edx,%eax
  80154d:	01 c0                	add    %eax,%eax
  80154f:	01 d0                	add    %edx,%eax
  801551:	c1 e0 02             	shl    $0x2,%eax
  801554:	05 28 31 80 00       	add    $0x803128,%eax
  801559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  80155f:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801562:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801569:	eb 36                	jmp    8015a1 <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  80156b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	01 c2                	add    %eax,%edx
  801573:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801576:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80157d:	39 c2                	cmp    %eax,%edx
  80157f:	73 1d                	jae    80159e <malloc+0x1b4>
					ni=arr_add[l].end-i;
  801581:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801584:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80158b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158e:	29 c2                	sub    %eax,%edx
  801590:	89 d0                	mov    %edx,%eax
  801592:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801595:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80159c:	eb 0d                	jmp    8015ab <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80159e:	ff 45 d0             	incl   -0x30(%ebp)
  8015a1:	a1 28 30 80 00       	mov    0x803028,%eax
  8015a6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8015a9:	7c c0                	jl     80156b <malloc+0x181>
					break;

				}
			}

			if(f){
  8015ab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8015af:	75 1d                	jne    8015ce <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  8015b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8015b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bb:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8015be:	a1 04 30 80 00       	mov    0x803004,%eax
  8015c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015c6:	0f 8c bd fe ff ff    	jl     801489 <malloc+0x9f>
  8015cc:	eb 01                	jmp    8015cf <malloc+0x1e5>

				}
			}

			if(f){
				break;
  8015ce:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8015cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015d3:	75 7a                	jne    80164f <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8015d5:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	48                   	dec    %eax
  8015e1:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8015e6:	7c 0a                	jl     8015f2 <malloc+0x208>
			return NULL;
  8015e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ed:	e9 a4 02 00 00       	jmp    801896 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  8015f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8015f7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8015fa:	a1 28 30 80 00       	mov    0x803028,%eax
  8015ff:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801602:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	ff 75 a4             	pushl  -0x5c(%ebp)
  801612:	e8 04 06 00 00       	call   801c1b <sys_allocateMem>
  801617:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80161a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	01 d0                	add    %edx,%eax
  801625:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80162a:	a1 28 30 80 00       	mov    0x803028,%eax
  80162f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801635:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80163c:	a1 28 30 80 00       	mov    0x803028,%eax
  801641:	40                   	inc    %eax
  801642:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801647:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80164a:	e9 47 02 00 00       	jmp    801896 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  80164f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801656:	e9 ac 00 00 00       	jmp    801707 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80165b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80165e:	89 d0                	mov    %edx,%eax
  801660:	01 c0                	add    %eax,%eax
  801662:	01 d0                	add    %edx,%eax
  801664:	c1 e0 02             	shl    $0x2,%eax
  801667:	05 24 31 80 00       	add    $0x803124,%eax
  80166c:	8b 00                	mov    (%eax),%eax
  80166e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801671:	eb 7e                	jmp    8016f1 <malloc+0x307>
			int flag=0;
  801673:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80167a:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801681:	eb 57                	jmp    8016da <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801683:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801686:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80168d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801690:	39 c2                	cmp    %eax,%edx
  801692:	77 1a                	ja     8016ae <malloc+0x2c4>
  801694:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801697:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80169e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016a1:	39 c2                	cmp    %eax,%edx
  8016a3:	76 09                	jbe    8016ae <malloc+0x2c4>
								flag=1;
  8016a5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8016ac:	eb 36                	jmp    8016e4 <malloc+0x2fa>
			arr[i].space++;
  8016ae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8016b1:	89 d0                	mov    %edx,%eax
  8016b3:	01 c0                	add    %eax,%eax
  8016b5:	01 d0                	add    %edx,%eax
  8016b7:	c1 e0 02             	shl    $0x2,%eax
  8016ba:	05 28 31 80 00       	add    $0x803128,%eax
  8016bf:	8b 00                	mov    (%eax),%eax
  8016c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8016c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8016c7:	89 d0                	mov    %edx,%eax
  8016c9:	01 c0                	add    %eax,%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	c1 e0 02             	shl    $0x2,%eax
  8016d0:	05 28 31 80 00       	add    $0x803128,%eax
  8016d5:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8016d7:	ff 45 c0             	incl   -0x40(%ebp)
  8016da:	a1 28 30 80 00       	mov    0x803028,%eax
  8016df:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8016e2:	7c 9f                	jl     801683 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8016e4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8016e8:	75 19                	jne    801703 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8016ea:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8016f1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8016f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8016f9:	39 c2                	cmp    %eax,%edx
  8016fb:	0f 82 72 ff ff ff    	jb     801673 <malloc+0x289>
  801701:	eb 01                	jmp    801704 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801703:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801704:	ff 45 cc             	incl   -0x34(%ebp)
  801707:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80170a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80170d:	0f 8c 48 ff ff ff    	jl     80165b <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801713:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80171a:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801721:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801728:	eb 37                	jmp    801761 <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80172a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80172d:	89 d0                	mov    %edx,%eax
  80172f:	01 c0                	add    %eax,%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	c1 e0 02             	shl    $0x2,%eax
  801736:	05 28 31 80 00       	add    $0x803128,%eax
  80173b:	8b 00                	mov    (%eax),%eax
  80173d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801740:	7d 1c                	jge    80175e <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801742:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801745:	89 d0                	mov    %edx,%eax
  801747:	01 c0                	add    %eax,%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	c1 e0 02             	shl    $0x2,%eax
  80174e:	05 28 31 80 00       	add    $0x803128,%eax
  801753:	8b 00                	mov    (%eax),%eax
  801755:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801758:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80175b:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  80175e:	ff 45 b4             	incl   -0x4c(%ebp)
  801761:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801764:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801767:	7c c1                	jl     80172a <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801769:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80176f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801772:	89 c8                	mov    %ecx,%eax
  801774:	01 c0                	add    %eax,%eax
  801776:	01 c8                	add    %ecx,%eax
  801778:	c1 e0 02             	shl    $0x2,%eax
  80177b:	05 20 31 80 00       	add    $0x803120,%eax
  801780:	8b 00                	mov    (%eax),%eax
  801782:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801789:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80178f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801792:	89 c8                	mov    %ecx,%eax
  801794:	01 c0                	add    %eax,%eax
  801796:	01 c8                	add    %ecx,%eax
  801798:	c1 e0 02             	shl    $0x2,%eax
  80179b:	05 24 31 80 00       	add    $0x803124,%eax
  8017a0:	8b 00                	mov    (%eax),%eax
  8017a2:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8017a9:	a1 28 30 80 00       	mov    0x803028,%eax
  8017ae:	40                   	inc    %eax
  8017af:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8017b4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017b7:	89 d0                	mov    %edx,%eax
  8017b9:	01 c0                	add    %eax,%eax
  8017bb:	01 d0                	add    %edx,%eax
  8017bd:	c1 e0 02             	shl    $0x2,%eax
  8017c0:	05 20 31 80 00       	add    $0x803120,%eax
  8017c5:	8b 00                	mov    (%eax),%eax
  8017c7:	83 ec 08             	sub    $0x8,%esp
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	50                   	push   %eax
  8017ce:	e8 48 04 00 00       	call   801c1b <sys_allocateMem>
  8017d3:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8017d6:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8017dd:	eb 78                	jmp    801857 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8017df:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	01 c0                	add    %eax,%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	c1 e0 02             	shl    $0x2,%eax
  8017eb:	05 20 31 80 00       	add    $0x803120,%eax
  8017f0:	8b 00                	mov    (%eax),%eax
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	50                   	push   %eax
  8017f6:	ff 75 b0             	pushl  -0x50(%ebp)
  8017f9:	68 50 2d 80 00       	push   $0x802d50
  8017fe:	e8 5d ee ff ff       	call   800660 <cprintf>
  801803:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801806:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801809:	89 d0                	mov    %edx,%eax
  80180b:	01 c0                	add    %eax,%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	c1 e0 02             	shl    $0x2,%eax
  801812:	05 24 31 80 00       	add    $0x803124,%eax
  801817:	8b 00                	mov    (%eax),%eax
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	50                   	push   %eax
  80181d:	ff 75 b0             	pushl  -0x50(%ebp)
  801820:	68 65 2d 80 00       	push   $0x802d65
  801825:	e8 36 ee ff ff       	call   800660 <cprintf>
  80182a:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80182d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801830:	89 d0                	mov    %edx,%eax
  801832:	01 c0                	add    %eax,%eax
  801834:	01 d0                	add    %edx,%eax
  801836:	c1 e0 02             	shl    $0x2,%eax
  801839:	05 28 31 80 00       	add    $0x803128,%eax
  80183e:	8b 00                	mov    (%eax),%eax
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	50                   	push   %eax
  801844:	ff 75 b0             	pushl  -0x50(%ebp)
  801847:	68 78 2d 80 00       	push   $0x802d78
  80184c:	e8 0f ee ff ff       	call   800660 <cprintf>
  801851:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801854:	ff 45 b0             	incl   -0x50(%ebp)
  801857:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80185a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80185d:	7c 80                	jl     8017df <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  80185f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801862:	89 d0                	mov    %edx,%eax
  801864:	01 c0                	add    %eax,%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	c1 e0 02             	shl    $0x2,%eax
  80186b:	05 20 31 80 00       	add    $0x803120,%eax
  801870:	8b 00                	mov    (%eax),%eax
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	50                   	push   %eax
  801876:	68 8c 2d 80 00       	push   $0x802d8c
  80187b:	e8 e0 ed ff ff       	call   800660 <cprintf>
  801880:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801883:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801886:	89 d0                	mov    %edx,%eax
  801888:	01 c0                	add    %eax,%eax
  80188a:	01 d0                	add    %edx,%eax
  80188c:	c1 e0 02             	shl    $0x2,%eax
  80188f:	05 20 31 80 00       	add    $0x803120,%eax
  801894:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8018a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8018ab:	eb 4b                	jmp    8018f8 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8018ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b0:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018b7:	89 c2                	mov    %eax,%edx
  8018b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018bc:	39 c2                	cmp    %eax,%edx
  8018be:	7f 35                	jg     8018f5 <free+0x5d>
  8018c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c3:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018ca:	89 c2                	mov    %eax,%edx
  8018cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018cf:	39 c2                	cmp    %eax,%edx
  8018d1:	7e 22                	jle    8018f5 <free+0x5d>
				start=arr_add[i].start;
  8018d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d6:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8018e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e3:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8018ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8018f3:	eb 0d                	jmp    801902 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8018f5:	ff 45 ec             	incl   -0x14(%ebp)
  8018f8:	a1 28 30 80 00       	mov    0x803028,%eax
  8018fd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801900:	7c ab                	jl     8018ad <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801905:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80190c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190f:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801916:	29 c2                	sub    %eax,%edx
  801918:	89 d0                	mov    %edx,%eax
  80191a:	83 ec 08             	sub    $0x8,%esp
  80191d:	50                   	push   %eax
  80191e:	ff 75 f4             	pushl  -0xc(%ebp)
  801921:	e8 d9 02 00 00       	call   801bff <sys_freeMem>
  801926:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80192f:	eb 2d                	jmp    80195e <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801934:	40                   	inc    %eax
  801935:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80193c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80193f:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801949:	40                   	inc    %eax
  80194a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801954:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80195b:	ff 45 e8             	incl   -0x18(%ebp)
  80195e:	a1 28 30 80 00       	mov    0x803028,%eax
  801963:	48                   	dec    %eax
  801964:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801967:	7f c8                	jg     801931 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801969:	a1 28 30 80 00       	mov    0x803028,%eax
  80196e:	48                   	dec    %eax
  80196f:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 18             	sub    $0x18,%esp
  80197d:	8b 45 10             	mov    0x10(%ebp),%eax
  801980:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 a8 2d 80 00       	push   $0x802da8
  80198b:	68 18 01 00 00       	push   $0x118
  801990:	68 cb 2d 80 00       	push   $0x802dcb
  801995:	e8 24 ea ff ff       	call   8003be <_panic>

0080199a <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	68 a8 2d 80 00       	push   $0x802da8
  8019a8:	68 1e 01 00 00       	push   $0x11e
  8019ad:	68 cb 2d 80 00       	push   $0x802dcb
  8019b2:	e8 07 ea ff ff       	call   8003be <_panic>

008019b7 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 a8 2d 80 00       	push   $0x802da8
  8019c5:	68 24 01 00 00       	push   $0x124
  8019ca:	68 cb 2d 80 00       	push   $0x802dcb
  8019cf:	e8 ea e9 ff ff       	call   8003be <_panic>

008019d4 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	68 a8 2d 80 00       	push   $0x802da8
  8019e2:	68 29 01 00 00       	push   $0x129
  8019e7:	68 cb 2d 80 00       	push   $0x802dcb
  8019ec:	e8 cd e9 ff ff       	call   8003be <_panic>

008019f1 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	68 a8 2d 80 00       	push   $0x802da8
  8019ff:	68 2f 01 00 00       	push   $0x12f
  801a04:	68 cb 2d 80 00       	push   $0x802dcb
  801a09:	e8 b0 e9 ff ff       	call   8003be <_panic>

00801a0e <shrink>:
}
void shrink(uint32 newSize)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	68 a8 2d 80 00       	push   $0x802da8
  801a1c:	68 33 01 00 00       	push   $0x133
  801a21:	68 cb 2d 80 00       	push   $0x802dcb
  801a26:	e8 93 e9 ff ff       	call   8003be <_panic>

00801a2b <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	68 a8 2d 80 00       	push   $0x802da8
  801a39:	68 38 01 00 00       	push   $0x138
  801a3e:	68 cb 2d 80 00       	push   $0x802dcb
  801a43:	e8 76 e9 ff ff       	call   8003be <_panic>

00801a48 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	57                   	push   %edi
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
  801a4e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a5d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a60:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a63:	cd 30                	int    $0x30
  801a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5e                   	pop    %esi
  801a70:	5f                   	pop    %edi
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    

00801a73 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a7f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	52                   	push   %edx
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	6a 00                	push   $0x0
  801a91:	e8 b2 ff ff ff       	call   801a48 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	90                   	nop
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_cgetc>:

int
sys_cgetc(void)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 01                	push   $0x1
  801aab:	e8 98 ff ff ff       	call   801a48 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 05                	push   $0x5
  801ac6:	e8 7d ff ff ff       	call   801a48 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 02                	push   $0x2
  801adf:	e8 64 ff ff ff       	call   801a48 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 03                	push   $0x3
  801af8:	e8 4b ff ff ff       	call   801a48 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 04                	push   $0x4
  801b11:	e8 32 ff ff ff       	call   801a48 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_env_exit>:


void sys_env_exit(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 06                	push   $0x6
  801b2a:	e8 19 ff ff ff       	call   801a48 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	6a 07                	push   $0x7
  801b48:	e8 fb fe ff ff       	call   801a48 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b57:	8b 75 18             	mov    0x18(%ebp),%esi
  801b5a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	51                   	push   %ecx
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 08                	push   $0x8
  801b6d:	e8 d6 fe ff ff       	call   801a48 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	52                   	push   %edx
  801b8c:	50                   	push   %eax
  801b8d:	6a 09                	push   $0x9
  801b8f:	e8 b4 fe ff ff       	call   801a48 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	ff 75 08             	pushl  0x8(%ebp)
  801ba8:	6a 0a                	push   $0xa
  801baa:	e8 99 fe ff ff       	call   801a48 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 0b                	push   $0xb
  801bc3:	e8 80 fe ff ff       	call   801a48 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 0c                	push   $0xc
  801bdc:	e8 67 fe ff ff       	call   801a48 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 0d                	push   $0xd
  801bf5:	e8 4e fe ff ff       	call   801a48 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 0c             	pushl  0xc(%ebp)
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	6a 11                	push   $0x11
  801c10:	e8 33 fe ff ff       	call   801a48 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	6a 12                	push   $0x12
  801c2c:	e8 17 fe ff ff       	call   801a48 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 0e                	push   $0xe
  801c46:	e8 fd fd ff ff       	call   801a48 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 0f                	push   $0xf
  801c60:	e8 e3 fd ff ff       	call   801a48 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 10                	push   $0x10
  801c79:	e8 ca fd ff ff       	call   801a48 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	90                   	nop
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 14                	push   $0x14
  801c93:	e8 b0 fd ff ff       	call   801a48 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 15                	push   $0x15
  801cad:	e8 96 fd ff ff       	call   801a48 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cc4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	50                   	push   %eax
  801cd1:	6a 16                	push   $0x16
  801cd3:	e8 70 fd ff ff       	call   801a48 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 17                	push   $0x17
  801ced:	e8 56 fd ff ff       	call   801a48 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	90                   	nop
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	50                   	push   %eax
  801d08:	6a 18                	push   $0x18
  801d0a:	e8 39 fd ff ff       	call   801a48 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 1b                	push   $0x1b
  801d27:	e8 1c fd ff ff       	call   801a48 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	6a 19                	push   $0x19
  801d44:	e8 ff fc ff ff       	call   801a48 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	90                   	nop
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	6a 1a                	push   $0x1a
  801d62:	e8 e1 fc ff ff       	call   801a48 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	90                   	nop
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	8b 45 10             	mov    0x10(%ebp),%eax
  801d76:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d7c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	51                   	push   %ecx
  801d86:	52                   	push   %edx
  801d87:	ff 75 0c             	pushl  0xc(%ebp)
  801d8a:	50                   	push   %eax
  801d8b:	6a 1c                	push   $0x1c
  801d8d:	e8 b6 fc ff ff       	call   801a48 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	52                   	push   %edx
  801da7:	50                   	push   %eax
  801da8:	6a 1d                	push   $0x1d
  801daa:	e8 99 fc ff ff       	call   801a48 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	51                   	push   %ecx
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	6a 1e                	push   $0x1e
  801dc9:	e8 7a fc ff ff       	call   801a48 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	6a 1f                	push   $0x1f
  801de6:	e8 5d fc ff ff       	call   801a48 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 20                	push   $0x20
  801dff:	e8 44 fc ff ff       	call   801a48 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	ff 75 14             	pushl  0x14(%ebp)
  801e14:	ff 75 10             	pushl  0x10(%ebp)
  801e17:	ff 75 0c             	pushl  0xc(%ebp)
  801e1a:	50                   	push   %eax
  801e1b:	6a 21                	push   $0x21
  801e1d:	e8 26 fc ff ff       	call   801a48 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	50                   	push   %eax
  801e36:	6a 22                	push   $0x22
  801e38:	e8 0b fc ff ff       	call   801a48 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	90                   	nop
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	50                   	push   %eax
  801e52:	6a 23                	push   $0x23
  801e54:	e8 ef fb ff ff       	call   801a48 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
}
  801e5c:	90                   	nop
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e68:	8d 50 04             	lea    0x4(%eax),%edx
  801e6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	52                   	push   %edx
  801e75:	50                   	push   %eax
  801e76:	6a 24                	push   $0x24
  801e78:	e8 cb fb ff ff       	call   801a48 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
	return result;
  801e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e89:	89 01                	mov    %eax,(%ecx)
  801e8b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	c9                   	leave  
  801e92:	c2 04 00             	ret    $0x4

00801e95 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	ff 75 10             	pushl  0x10(%ebp)
  801e9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	6a 13                	push   $0x13
  801ea7:	e8 9c fb ff ff       	call   801a48 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
	return ;
  801eaf:	90                   	nop
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 25                	push   $0x25
  801ec1:	e8 82 fb ff ff       	call   801a48 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ed7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	50                   	push   %eax
  801ee4:	6a 26                	push   $0x26
  801ee6:	e8 5d fb ff ff       	call   801a48 <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
	return ;
  801eee:	90                   	nop
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <rsttst>:
void rsttst()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 28                	push   $0x28
  801f00:	e8 43 fb ff ff       	call   801a48 <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
	return ;
  801f08:	90                   	nop
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 04             	sub    $0x4,%esp
  801f11:	8b 45 14             	mov    0x14(%ebp),%eax
  801f14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f17:	8b 55 18             	mov    0x18(%ebp),%edx
  801f1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f1e:	52                   	push   %edx
  801f1f:	50                   	push   %eax
  801f20:	ff 75 10             	pushl  0x10(%ebp)
  801f23:	ff 75 0c             	pushl  0xc(%ebp)
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	6a 27                	push   $0x27
  801f2b:	e8 18 fb ff ff       	call   801a48 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
	return ;
  801f33:	90                   	nop
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <chktst>:
void chktst(uint32 n)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	ff 75 08             	pushl  0x8(%ebp)
  801f44:	6a 29                	push   $0x29
  801f46:	e8 fd fa ff ff       	call   801a48 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4e:	90                   	nop
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <inctst>:

void inctst()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 2a                	push   $0x2a
  801f60:	e8 e3 fa ff ff       	call   801a48 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
	return ;
  801f68:	90                   	nop
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <gettst>:
uint32 gettst()
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 2b                	push   $0x2b
  801f7a:	e8 c9 fa ff ff       	call   801a48 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801f96:	e8 ad fa ff ff       	call   801a48 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
  801f9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fa1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fa5:	75 07                	jne    801fae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fac:	eb 05                	jmp    801fb3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 2c                	push   $0x2c
  801fc7:	e8 7c fa ff ff       	call   801a48 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
  801fcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fd2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fd6:	75 07                	jne    801fdf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdd:	eb 05                	jmp    801fe4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 2c                	push   $0x2c
  801ff8:	e8 4b fa ff ff       	call   801a48 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
  802000:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802003:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802007:	75 07                	jne    802010 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802009:	b8 01 00 00 00       	mov    $0x1,%eax
  80200e:	eb 05                	jmp    802015 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 2c                	push   $0x2c
  802029:	e8 1a fa ff ff       	call   801a48 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
  802031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802034:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802038:	75 07                	jne    802041 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80203a:	b8 01 00 00 00       	mov    $0x1,%eax
  80203f:	eb 05                	jmp    802046 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	ff 75 08             	pushl  0x8(%ebp)
  802056:	6a 2d                	push   $0x2d
  802058:	e8 eb f9 ff ff       	call   801a48 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
	return ;
  802060:	90                   	nop
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802067:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80206a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	53                   	push   %ebx
  802076:	51                   	push   %ecx
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	6a 2e                	push   $0x2e
  80207b:	e8 c8 f9 ff ff       	call   801a48 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80208b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	52                   	push   %edx
  802098:	50                   	push   %eax
  802099:	6a 2f                	push   $0x2f
  80209b:	e8 a8 f9 ff ff       	call   801a48 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    
  8020a5:	66 90                	xchg   %ax,%ax
  8020a7:	90                   	nop

008020a8 <__udivdi3>:
  8020a8:	55                   	push   %ebp
  8020a9:	57                   	push   %edi
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 1c             	sub    $0x1c,%esp
  8020af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020bf:	89 ca                	mov    %ecx,%edx
  8020c1:	89 f8                	mov    %edi,%eax
  8020c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020c7:	85 f6                	test   %esi,%esi
  8020c9:	75 2d                	jne    8020f8 <__udivdi3+0x50>
  8020cb:	39 cf                	cmp    %ecx,%edi
  8020cd:	77 65                	ja     802134 <__udivdi3+0x8c>
  8020cf:	89 fd                	mov    %edi,%ebp
  8020d1:	85 ff                	test   %edi,%edi
  8020d3:	75 0b                	jne    8020e0 <__udivdi3+0x38>
  8020d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020da:	31 d2                	xor    %edx,%edx
  8020dc:	f7 f7                	div    %edi
  8020de:	89 c5                	mov    %eax,%ebp
  8020e0:	31 d2                	xor    %edx,%edx
  8020e2:	89 c8                	mov    %ecx,%eax
  8020e4:	f7 f5                	div    %ebp
  8020e6:	89 c1                	mov    %eax,%ecx
  8020e8:	89 d8                	mov    %ebx,%eax
  8020ea:	f7 f5                	div    %ebp
  8020ec:	89 cf                	mov    %ecx,%edi
  8020ee:	89 fa                	mov    %edi,%edx
  8020f0:	83 c4 1c             	add    $0x1c,%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5f                   	pop    %edi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    
  8020f8:	39 ce                	cmp    %ecx,%esi
  8020fa:	77 28                	ja     802124 <__udivdi3+0x7c>
  8020fc:	0f bd fe             	bsr    %esi,%edi
  8020ff:	83 f7 1f             	xor    $0x1f,%edi
  802102:	75 40                	jne    802144 <__udivdi3+0x9c>
  802104:	39 ce                	cmp    %ecx,%esi
  802106:	72 0a                	jb     802112 <__udivdi3+0x6a>
  802108:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80210c:	0f 87 9e 00 00 00    	ja     8021b0 <__udivdi3+0x108>
  802112:	b8 01 00 00 00       	mov    $0x1,%eax
  802117:	89 fa                	mov    %edi,%edx
  802119:	83 c4 1c             	add    $0x1c,%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    
  802121:	8d 76 00             	lea    0x0(%esi),%esi
  802124:	31 ff                	xor    %edi,%edi
  802126:	31 c0                	xor    %eax,%eax
  802128:	89 fa                	mov    %edi,%edx
  80212a:	83 c4 1c             	add    $0x1c,%esp
  80212d:	5b                   	pop    %ebx
  80212e:	5e                   	pop    %esi
  80212f:	5f                   	pop    %edi
  802130:	5d                   	pop    %ebp
  802131:	c3                   	ret    
  802132:	66 90                	xchg   %ax,%ax
  802134:	89 d8                	mov    %ebx,%eax
  802136:	f7 f7                	div    %edi
  802138:	31 ff                	xor    %edi,%edi
  80213a:	89 fa                	mov    %edi,%edx
  80213c:	83 c4 1c             	add    $0x1c,%esp
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5f                   	pop    %edi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    
  802144:	bd 20 00 00 00       	mov    $0x20,%ebp
  802149:	89 eb                	mov    %ebp,%ebx
  80214b:	29 fb                	sub    %edi,%ebx
  80214d:	89 f9                	mov    %edi,%ecx
  80214f:	d3 e6                	shl    %cl,%esi
  802151:	89 c5                	mov    %eax,%ebp
  802153:	88 d9                	mov    %bl,%cl
  802155:	d3 ed                	shr    %cl,%ebp
  802157:	89 e9                	mov    %ebp,%ecx
  802159:	09 f1                	or     %esi,%ecx
  80215b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80215f:	89 f9                	mov    %edi,%ecx
  802161:	d3 e0                	shl    %cl,%eax
  802163:	89 c5                	mov    %eax,%ebp
  802165:	89 d6                	mov    %edx,%esi
  802167:	88 d9                	mov    %bl,%cl
  802169:	d3 ee                	shr    %cl,%esi
  80216b:	89 f9                	mov    %edi,%ecx
  80216d:	d3 e2                	shl    %cl,%edx
  80216f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802173:	88 d9                	mov    %bl,%cl
  802175:	d3 e8                	shr    %cl,%eax
  802177:	09 c2                	or     %eax,%edx
  802179:	89 d0                	mov    %edx,%eax
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	f7 74 24 0c          	divl   0xc(%esp)
  802181:	89 d6                	mov    %edx,%esi
  802183:	89 c3                	mov    %eax,%ebx
  802185:	f7 e5                	mul    %ebp
  802187:	39 d6                	cmp    %edx,%esi
  802189:	72 19                	jb     8021a4 <__udivdi3+0xfc>
  80218b:	74 0b                	je     802198 <__udivdi3+0xf0>
  80218d:	89 d8                	mov    %ebx,%eax
  80218f:	31 ff                	xor    %edi,%edi
  802191:	e9 58 ff ff ff       	jmp    8020ee <__udivdi3+0x46>
  802196:	66 90                	xchg   %ax,%ax
  802198:	8b 54 24 08          	mov    0x8(%esp),%edx
  80219c:	89 f9                	mov    %edi,%ecx
  80219e:	d3 e2                	shl    %cl,%edx
  8021a0:	39 c2                	cmp    %eax,%edx
  8021a2:	73 e9                	jae    80218d <__udivdi3+0xe5>
  8021a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021a7:	31 ff                	xor    %edi,%edi
  8021a9:	e9 40 ff ff ff       	jmp    8020ee <__udivdi3+0x46>
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	31 c0                	xor    %eax,%eax
  8021b2:	e9 37 ff ff ff       	jmp    8020ee <__udivdi3+0x46>
  8021b7:	90                   	nop

008021b8 <__umoddi3>:
  8021b8:	55                   	push   %ebp
  8021b9:	57                   	push   %edi
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
  8021bc:	83 ec 1c             	sub    $0x1c,%esp
  8021bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021d7:	89 f3                	mov    %esi,%ebx
  8021d9:	89 fa                	mov    %edi,%edx
  8021db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021df:	89 34 24             	mov    %esi,(%esp)
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 1a                	jne    802200 <__umoddi3+0x48>
  8021e6:	39 f7                	cmp    %esi,%edi
  8021e8:	0f 86 a2 00 00 00    	jbe    802290 <__umoddi3+0xd8>
  8021ee:	89 c8                	mov    %ecx,%eax
  8021f0:	89 f2                	mov    %esi,%edx
  8021f2:	f7 f7                	div    %edi
  8021f4:	89 d0                	mov    %edx,%eax
  8021f6:	31 d2                	xor    %edx,%edx
  8021f8:	83 c4 1c             	add    $0x1c,%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5e                   	pop    %esi
  8021fd:	5f                   	pop    %edi
  8021fe:	5d                   	pop    %ebp
  8021ff:	c3                   	ret    
  802200:	39 f0                	cmp    %esi,%eax
  802202:	0f 87 ac 00 00 00    	ja     8022b4 <__umoddi3+0xfc>
  802208:	0f bd e8             	bsr    %eax,%ebp
  80220b:	83 f5 1f             	xor    $0x1f,%ebp
  80220e:	0f 84 ac 00 00 00    	je     8022c0 <__umoddi3+0x108>
  802214:	bf 20 00 00 00       	mov    $0x20,%edi
  802219:	29 ef                	sub    %ebp,%edi
  80221b:	89 fe                	mov    %edi,%esi
  80221d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802221:	89 e9                	mov    %ebp,%ecx
  802223:	d3 e0                	shl    %cl,%eax
  802225:	89 d7                	mov    %edx,%edi
  802227:	89 f1                	mov    %esi,%ecx
  802229:	d3 ef                	shr    %cl,%edi
  80222b:	09 c7                	or     %eax,%edi
  80222d:	89 e9                	mov    %ebp,%ecx
  80222f:	d3 e2                	shl    %cl,%edx
  802231:	89 14 24             	mov    %edx,(%esp)
  802234:	89 d8                	mov    %ebx,%eax
  802236:	d3 e0                	shl    %cl,%eax
  802238:	89 c2                	mov    %eax,%edx
  80223a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80223e:	d3 e0                	shl    %cl,%eax
  802240:	89 44 24 04          	mov    %eax,0x4(%esp)
  802244:	8b 44 24 08          	mov    0x8(%esp),%eax
  802248:	89 f1                	mov    %esi,%ecx
  80224a:	d3 e8                	shr    %cl,%eax
  80224c:	09 d0                	or     %edx,%eax
  80224e:	d3 eb                	shr    %cl,%ebx
  802250:	89 da                	mov    %ebx,%edx
  802252:	f7 f7                	div    %edi
  802254:	89 d3                	mov    %edx,%ebx
  802256:	f7 24 24             	mull   (%esp)
  802259:	89 c6                	mov    %eax,%esi
  80225b:	89 d1                	mov    %edx,%ecx
  80225d:	39 d3                	cmp    %edx,%ebx
  80225f:	0f 82 87 00 00 00    	jb     8022ec <__umoddi3+0x134>
  802265:	0f 84 91 00 00 00    	je     8022fc <__umoddi3+0x144>
  80226b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80226f:	29 f2                	sub    %esi,%edx
  802271:	19 cb                	sbb    %ecx,%ebx
  802273:	89 d8                	mov    %ebx,%eax
  802275:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802279:	d3 e0                	shl    %cl,%eax
  80227b:	89 e9                	mov    %ebp,%ecx
  80227d:	d3 ea                	shr    %cl,%edx
  80227f:	09 d0                	or     %edx,%eax
  802281:	89 e9                	mov    %ebp,%ecx
  802283:	d3 eb                	shr    %cl,%ebx
  802285:	89 da                	mov    %ebx,%edx
  802287:	83 c4 1c             	add    $0x1c,%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5f                   	pop    %edi
  80228d:	5d                   	pop    %ebp
  80228e:	c3                   	ret    
  80228f:	90                   	nop
  802290:	89 fd                	mov    %edi,%ebp
  802292:	85 ff                	test   %edi,%edi
  802294:	75 0b                	jne    8022a1 <__umoddi3+0xe9>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f7                	div    %edi
  80229f:	89 c5                	mov    %eax,%ebp
  8022a1:	89 f0                	mov    %esi,%eax
  8022a3:	31 d2                	xor    %edx,%edx
  8022a5:	f7 f5                	div    %ebp
  8022a7:	89 c8                	mov    %ecx,%eax
  8022a9:	f7 f5                	div    %ebp
  8022ab:	89 d0                	mov    %edx,%eax
  8022ad:	e9 44 ff ff ff       	jmp    8021f6 <__umoddi3+0x3e>
  8022b2:	66 90                	xchg   %ax,%ax
  8022b4:	89 c8                	mov    %ecx,%eax
  8022b6:	89 f2                	mov    %esi,%edx
  8022b8:	83 c4 1c             	add    $0x1c,%esp
  8022bb:	5b                   	pop    %ebx
  8022bc:	5e                   	pop    %esi
  8022bd:	5f                   	pop    %edi
  8022be:	5d                   	pop    %ebp
  8022bf:	c3                   	ret    
  8022c0:	3b 04 24             	cmp    (%esp),%eax
  8022c3:	72 06                	jb     8022cb <__umoddi3+0x113>
  8022c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022c9:	77 0f                	ja     8022da <__umoddi3+0x122>
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	29 f9                	sub    %edi,%ecx
  8022cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8022d3:	89 14 24             	mov    %edx,(%esp)
  8022d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022de:	8b 14 24             	mov    (%esp),%edx
  8022e1:	83 c4 1c             	add    $0x1c,%esp
  8022e4:	5b                   	pop    %ebx
  8022e5:	5e                   	pop    %esi
  8022e6:	5f                   	pop    %edi
  8022e7:	5d                   	pop    %ebp
  8022e8:	c3                   	ret    
  8022e9:	8d 76 00             	lea    0x0(%esi),%esi
  8022ec:	2b 04 24             	sub    (%esp),%eax
  8022ef:	19 fa                	sbb    %edi,%edx
  8022f1:	89 d1                	mov    %edx,%ecx
  8022f3:	89 c6                	mov    %eax,%esi
  8022f5:	e9 71 ff ff ff       	jmp    80226b <__umoddi3+0xb3>
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802300:	72 ea                	jb     8022ec <__umoddi3+0x134>
  802302:	89 d9                	mov    %ebx,%ecx
  802304:	e9 62 ff ff ff       	jmp    80226b <__umoddi3+0xb3>
