
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 57 05 00 00       	call   80058d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80006f:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800087:	68 20 26 80 00       	push   $0x802620
  80008c:	6a 12                	push   $0x12
  80008e:	68 3c 26 80 00       	push   $0x80263c
  800093:	e8 3a 06 00 00       	call   8006d2 <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 54 26 80 00       	push   $0x802654
  8000a0:	e8 cf 08 00 00       	call   800974 <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 88 26 80 00       	push   $0x802688
  8000b0:	e8 bf 08 00 00       	call   800974 <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 e4 26 80 00       	push   $0x8026e4
  8000c0:	e8 af 08 00 00       	call   800974 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000c8:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000cf:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000d6:	e8 09 1d 00 00       	call   801de4 <sys_getenvid>
  8000db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	68 18 27 80 00       	push   $0x802718
  8000e6:	e8 89 08 00 00       	call   800974 <cprintf>
  8000eb:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000ee:	e8 d5 1d 00 00       	call   801ec8 <sys_calculate_free_frames>
  8000f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 01                	push   $0x1
  8000fb:	68 00 10 00 00       	push   $0x1000
  800100:	68 47 27 80 00       	push   $0x802747
  800105:	e8 81 1b 00 00       	call   801c8b <smalloc>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800110:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 4c 27 80 00       	push   $0x80274c
  800121:	6a 21                	push   $0x21
  800123:	68 3c 26 80 00       	push   $0x80263c
  800128:	e8 a5 05 00 00       	call   8006d2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80012d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800130:	e8 93 1d 00 00       	call   801ec8 <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	83 f8 04             	cmp    $0x4,%eax
  80013c:	74 14                	je     800152 <_main+0x11a>
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	68 b8 27 80 00       	push   $0x8027b8
  800146:	6a 22                	push   $0x22
  800148:	68 3c 26 80 00       	push   $0x80263c
  80014d:	e8 80 05 00 00       	call   8006d2 <_panic>

		sfree(x);
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	ff 75 dc             	pushl  -0x24(%ebp)
  800158:	e8 6e 1b 00 00       	call   801ccb <sfree>
  80015d:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800160:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800163:	e8 60 1d 00 00       	call   801ec8 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	89 d8                	mov    %ebx,%eax
  80016c:	83 f8 02             	cmp    $0x2,%eax
  80016f:	75 14                	jne    800185 <_main+0x14d>
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 38 28 80 00       	push   $0x802838
  800179:	6a 25                	push   $0x25
  80017b:	68 3c 26 80 00       	push   $0x80263c
  800180:	e8 4d 05 00 00       	call   8006d2 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800185:	e8 3e 1d 00 00       	call   801ec8 <sys_calculate_free_frames>
  80018a:	89 c2                	mov    %eax,%edx
  80018c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80018f:	39 c2                	cmp    %eax,%edx
  800191:	74 14                	je     8001a7 <_main+0x16f>
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	68 90 28 80 00       	push   $0x802890
  80019b:	6a 26                	push   $0x26
  80019d:	68 3c 26 80 00       	push   $0x80263c
  8001a2:	e8 2b 05 00 00       	call   8006d2 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 c0 28 80 00       	push   $0x8028c0
  8001af:	e8 c0 07 00 00       	call   800974 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 e4 28 80 00       	push   $0x8028e4
  8001bf:	e8 b0 07 00 00       	call   800974 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001c7:	e8 fc 1c 00 00       	call   801ec8 <sys_calculate_free_frames>
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 01                	push   $0x1
  8001d4:	68 00 10 00 00       	push   $0x1000
  8001d9:	68 14 29 80 00       	push   $0x802914
  8001de:	e8 a8 1a 00 00       	call   801c8b <smalloc>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	6a 01                	push   $0x1
  8001ee:	68 00 10 00 00       	push   $0x1000
  8001f3:	68 47 27 80 00       	push   $0x802747
  8001f8:	e8 8e 1a 00 00       	call   801c8b <smalloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800203:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 38 28 80 00       	push   $0x802838
  800211:	6a 32                	push   $0x32
  800213:	68 3c 26 80 00       	push   $0x80263c
  800218:	e8 b5 04 00 00       	call   8006d2 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  80021d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800220:	e8 a3 1c 00 00       	call   801ec8 <sys_calculate_free_frames>
  800225:	29 c3                	sub    %eax,%ebx
  800227:	89 d8                	mov    %ebx,%eax
  800229:	83 f8 07             	cmp    $0x7,%eax
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 18 29 80 00       	push   $0x802918
  800236:	6a 34                	push   $0x34
  800238:	68 3c 26 80 00       	push   $0x80263c
  80023d:	e8 90 04 00 00       	call   8006d2 <_panic>

		sfree(z);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	ff 75 d4             	pushl  -0x2c(%ebp)
  800248:	e8 7e 1a 00 00       	call   801ccb <sfree>
  80024d:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800250:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800253:	e8 70 1c 00 00       	call   801ec8 <sys_calculate_free_frames>
  800258:	29 c3                	sub    %eax,%ebx
  80025a:	89 d8                	mov    %ebx,%eax
  80025c:	83 f8 04             	cmp    $0x4,%eax
  80025f:	74 14                	je     800275 <_main+0x23d>
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	68 6d 29 80 00       	push   $0x80296d
  800269:	6a 37                	push   $0x37
  80026b:	68 3c 26 80 00       	push   $0x80263c
  800270:	e8 5d 04 00 00       	call   8006d2 <_panic>

		sfree(x);
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	ff 75 d0             	pushl  -0x30(%ebp)
  80027b:	e8 4b 1a 00 00       	call   801ccb <sfree>
  800280:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800283:	e8 40 1c 00 00       	call   801ec8 <sys_calculate_free_frames>
  800288:	89 c2                	mov    %eax,%edx
  80028a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80028d:	39 c2                	cmp    %eax,%edx
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 6d 29 80 00       	push   $0x80296d
  800299:	6a 3a                	push   $0x3a
  80029b:	68 3c 26 80 00       	push   $0x80263c
  8002a0:	e8 2d 04 00 00       	call   8006d2 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	68 8c 29 80 00       	push   $0x80298c
  8002ad:	e8 c2 06 00 00       	call   800974 <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	68 b0 29 80 00       	push   $0x8029b0
  8002bd:	e8 b2 06 00 00       	call   800974 <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 fe 1b 00 00       	call   801ec8 <sys_calculate_free_frames>
  8002ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	6a 01                	push   $0x1
  8002d2:	68 01 30 00 00       	push   $0x3001
  8002d7:	68 e0 29 80 00       	push   $0x8029e0
  8002dc:	e8 aa 19 00 00       	call   801c8b <smalloc>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	6a 01                	push   $0x1
  8002ec:	68 00 10 00 00       	push   $0x1000
  8002f1:	68 e2 29 80 00       	push   $0x8029e2
  8002f6:	e8 90 19 00 00       	call   801c8b <smalloc>
  8002fb:	83 c4 10             	add    $0x10,%esp
  8002fe:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800301:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800304:	e8 bf 1b 00 00       	call   801ec8 <sys_calculate_free_frames>
  800309:	29 c3                	sub    %eax,%ebx
  80030b:	89 d8                	mov    %ebx,%eax
  80030d:	83 f8 0a             	cmp    $0xa,%eax
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 b8 27 80 00       	push   $0x8027b8
  80031a:	6a 46                	push   $0x46
  80031c:	68 3c 26 80 00       	push   $0x80263c
  800321:	e8 ac 03 00 00       	call   8006d2 <_panic>

		sfree(w);
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	ff 75 c8             	pushl  -0x38(%ebp)
  80032c:	e8 9a 19 00 00       	call   801ccb <sfree>
  800331:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800334:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800337:	e8 8c 1b 00 00       	call   801ec8 <sys_calculate_free_frames>
  80033c:	29 c3                	sub    %eax,%ebx
  80033e:	89 d8                	mov    %ebx,%eax
  800340:	83 f8 04             	cmp    $0x4,%eax
  800343:	74 14                	je     800359 <_main+0x321>
  800345:	83 ec 04             	sub    $0x4,%esp
  800348:	68 6d 29 80 00       	push   $0x80296d
  80034d:	6a 49                	push   $0x49
  80034f:	68 3c 26 80 00       	push   $0x80263c
  800354:	e8 79 03 00 00       	call   8006d2 <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	6a 01                	push   $0x1
  80035e:	68 ff 1f 00 00       	push   $0x1fff
  800363:	68 e4 29 80 00       	push   $0x8029e4
  800368:	e8 1e 19 00 00       	call   801c8b <smalloc>
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800373:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800376:	e8 4d 1b 00 00       	call   801ec8 <sys_calculate_free_frames>
  80037b:	29 c3                	sub    %eax,%ebx
  80037d:	89 d8                	mov    %ebx,%eax
  80037f:	83 f8 08             	cmp    $0x8,%eax
  800382:	74 14                	je     800398 <_main+0x360>
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 b8 27 80 00       	push   $0x8027b8
  80038c:	6a 4e                	push   $0x4e
  80038e:	68 3c 26 80 00       	push   $0x80263c
  800393:	e8 3a 03 00 00       	call   8006d2 <_panic>

		sfree(o);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 28 19 00 00       	call   801ccb <sfree>
  8003a3:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003a6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003a9:	e8 1a 1b 00 00       	call   801ec8 <sys_calculate_free_frames>
  8003ae:	29 c3                	sub    %eax,%ebx
  8003b0:	89 d8                	mov    %ebx,%eax
  8003b2:	83 f8 04             	cmp    $0x4,%eax
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 6d 29 80 00       	push   $0x80296d
  8003bf:	6a 51                	push   $0x51
  8003c1:	68 3c 26 80 00       	push   $0x80263c
  8003c6:	e8 07 03 00 00       	call   8006d2 <_panic>

		sfree(u);
  8003cb:	83 ec 0c             	sub    $0xc,%esp
  8003ce:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d1:	e8 f5 18 00 00       	call   801ccb <sfree>
  8003d6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003d9:	e8 ea 1a 00 00       	call   801ec8 <sys_calculate_free_frames>
  8003de:	89 c2                	mov    %eax,%edx
  8003e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e3:	39 c2                	cmp    %eax,%edx
  8003e5:	74 14                	je     8003fb <_main+0x3c3>
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 6d 29 80 00       	push   $0x80296d
  8003ef:	6a 54                	push   $0x54
  8003f1:	68 3c 26 80 00       	push   $0x80263c
  8003f6:	e8 d7 02 00 00       	call   8006d2 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  8003fb:	e8 c8 1a 00 00       	call   801ec8 <sys_calculate_free_frames>
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800406:	89 c2                	mov    %eax,%edx
  800408:	01 d2                	add    %edx,%edx
  80040a:	01 d0                	add    %edx,%eax
  80040c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	6a 01                	push   $0x1
  800414:	50                   	push   %eax
  800415:	68 e0 29 80 00       	push   $0x8029e0
  80041a:	e8 6c 18 00 00       	call   801c8b <smalloc>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800428:	89 d0                	mov    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	6a 01                	push   $0x1
  80043a:	50                   	push   %eax
  80043b:	68 e2 29 80 00       	push   $0x8029e2
  800440:	e8 46 18 00 00       	call   801c8b <smalloc>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80044b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80044e:	01 c0                	add    %eax,%eax
  800450:	89 c2                	mov    %eax,%edx
  800452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800455:	01 d0                	add    %edx,%eax
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	6a 01                	push   $0x1
  80045c:	50                   	push   %eax
  80045d:	68 e4 29 80 00       	push   $0x8029e4
  800462:	e8 24 18 00 00       	call   801c8b <smalloc>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80046d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800470:	e8 53 1a 00 00       	call   801ec8 <sys_calculate_free_frames>
  800475:	29 c3                	sub    %eax,%ebx
  800477:	89 d8                	mov    %ebx,%eax
  800479:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 b8 27 80 00       	push   $0x8027b8
  800488:	6a 5d                	push   $0x5d
  80048a:	68 3c 26 80 00       	push   $0x80263c
  80048f:	e8 3e 02 00 00       	call   8006d2 <_panic>

		sfree(o);
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	ff 75 c0             	pushl  -0x40(%ebp)
  80049a:	e8 2c 18 00 00       	call   801ccb <sfree>
  80049f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004a5:	e8 1e 1a 00 00       	call   801ec8 <sys_calculate_free_frames>
  8004aa:	29 c3                	sub    %eax,%ebx
  8004ac:	89 d8                	mov    %ebx,%eax
  8004ae:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b3:	74 14                	je     8004c9 <_main+0x491>
  8004b5:	83 ec 04             	sub    $0x4,%esp
  8004b8:	68 6d 29 80 00       	push   $0x80296d
  8004bd:	6a 60                	push   $0x60
  8004bf:	68 3c 26 80 00       	push   $0x80263c
  8004c4:	e8 09 02 00 00       	call   8006d2 <_panic>

		sfree(w);
  8004c9:	83 ec 0c             	sub    $0xc,%esp
  8004cc:	ff 75 c8             	pushl  -0x38(%ebp)
  8004cf:	e8 f7 17 00 00       	call   801ccb <sfree>
  8004d4:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004d7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004da:	e8 e9 19 00 00       	call   801ec8 <sys_calculate_free_frames>
  8004df:	29 c3                	sub    %eax,%ebx
  8004e1:	89 d8                	mov    %ebx,%eax
  8004e3:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004e8:	74 14                	je     8004fe <_main+0x4c6>
  8004ea:	83 ec 04             	sub    $0x4,%esp
  8004ed:	68 6d 29 80 00       	push   $0x80296d
  8004f2:	6a 63                	push   $0x63
  8004f4:	68 3c 26 80 00       	push   $0x80263c
  8004f9:	e8 d4 01 00 00       	call   8006d2 <_panic>

		sfree(u);
  8004fe:	83 ec 0c             	sub    $0xc,%esp
  800501:	ff 75 c4             	pushl  -0x3c(%ebp)
  800504:	e8 c2 17 00 00       	call   801ccb <sfree>
  800509:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80050c:	e8 b7 19 00 00       	call   801ec8 <sys_calculate_free_frames>
  800511:	89 c2                	mov    %eax,%edx
  800513:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800516:	39 c2                	cmp    %eax,%edx
  800518:	74 14                	je     80052e <_main+0x4f6>
  80051a:	83 ec 04             	sub    $0x4,%esp
  80051d:	68 6d 29 80 00       	push   $0x80296d
  800522:	6a 66                	push   $0x66
  800524:	68 3c 26 80 00       	push   $0x80263c
  800529:	e8 a4 01 00 00       	call   8006d2 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	68 e8 29 80 00       	push   $0x8029e8
  800536:	e8 39 04 00 00       	call   800974 <cprintf>
  80053b:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  80053e:	83 ec 0c             	sub    $0xc,%esp
  800541:	68 0c 2a 80 00       	push   $0x802a0c
  800546:	e8 29 04 00 00       	call   800974 <cprintf>
  80054b:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80054e:	e8 c3 18 00 00       	call   801e16 <sys_getparentenvid>
  800553:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  800556:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  80055a:	7e 2b                	jle    800587 <_main+0x54f>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80055c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	68 58 2a 80 00       	push   $0x802a58
  80056b:	ff 75 bc             	pushl  -0x44(%ebp)
  80056e:	e8 3b 17 00 00       	call   801cae <sget>
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  800579:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	8d 50 01             	lea    0x1(%eax),%edx
  800581:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800584:	89 10                	mov    %edx,(%eax)
	}
	return;
  800586:	90                   	nop
  800587:	90                   	nop
}
  800588:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058b:	c9                   	leave  
  80058c:	c3                   	ret    

0080058d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80058d:	55                   	push   %ebp
  80058e:	89 e5                	mov    %esp,%ebp
  800590:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800593:	e8 65 18 00 00       	call   801dfd <sys_getenvindex>
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80059b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80059e:	89 d0                	mov    %edx,%eax
  8005a0:	c1 e0 03             	shl    $0x3,%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005ac:	01 c8                	add    %ecx,%eax
  8005ae:	01 c0                	add    %eax,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	c1 e2 05             	shl    $0x5,%edx
  8005bb:	29 c2                	sub    %eax,%edx
  8005bd:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8005c4:	89 c2                	mov    %eax,%edx
  8005c6:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8005cc:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d6:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8005dc:	84 c0                	test   %al,%al
  8005de:	74 0f                	je     8005ef <libmain+0x62>
		binaryname = myEnv->prog_name;
  8005e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e5:	05 40 3c 01 00       	add    $0x13c40,%eax
  8005ea:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f3:	7e 0a                	jle    8005ff <libmain+0x72>
		binaryname = argv[0];
  8005f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 2b fa ff ff       	call   800038 <_main>
  80060d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800610:	e8 83 19 00 00       	call   801f98 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800615:	83 ec 0c             	sub    $0xc,%esp
  800618:	68 80 2a 80 00       	push   $0x802a80
  80061d:	e8 52 03 00 00       	call   800974 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800625:	a1 20 40 80 00       	mov    0x804020,%eax
  80062a:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800630:	a1 20 40 80 00       	mov    0x804020,%eax
  800635:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80063b:	83 ec 04             	sub    $0x4,%esp
  80063e:	52                   	push   %edx
  80063f:	50                   	push   %eax
  800640:	68 a8 2a 80 00       	push   $0x802aa8
  800645:	e8 2a 03 00 00       	call   800974 <cprintf>
  80064a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80064d:	a1 20 40 80 00       	mov    0x804020,%eax
  800652:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800658:	a1 20 40 80 00       	mov    0x804020,%eax
  80065d:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800663:	83 ec 04             	sub    $0x4,%esp
  800666:	52                   	push   %edx
  800667:	50                   	push   %eax
  800668:	68 d0 2a 80 00       	push   $0x802ad0
  80066d:	e8 02 03 00 00       	call   800974 <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800675:	a1 20 40 80 00       	mov    0x804020,%eax
  80067a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	50                   	push   %eax
  800684:	68 11 2b 80 00       	push   $0x802b11
  800689:	e8 e6 02 00 00       	call   800974 <cprintf>
  80068e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	68 80 2a 80 00       	push   $0x802a80
  800699:	e8 d6 02 00 00       	call   800974 <cprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006a1:	e8 0c 19 00 00       	call   801fb2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a6:	e8 19 00 00 00       	call   8006c4 <exit>
}
  8006ab:	90                   	nop
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	6a 00                	push   $0x0
  8006b9:	e8 0b 17 00 00       	call   801dc9 <sys_env_destroy>
  8006be:	83 c4 10             	add    $0x10,%esp
}
  8006c1:	90                   	nop
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    

008006c4 <exit>:

void
exit(void)
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006ca:	e8 60 17 00 00       	call   801e2f <sys_env_exit>
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8006db:	83 c0 04             	add    $0x4,%eax
  8006de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006e1:	a1 18 41 80 00       	mov    0x804118,%eax
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	74 16                	je     800700 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006ea:	a1 18 41 80 00       	mov    0x804118,%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	50                   	push   %eax
  8006f3:	68 28 2b 80 00       	push   $0x802b28
  8006f8:	e8 77 02 00 00       	call   800974 <cprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800700:	a1 00 40 80 00       	mov    0x804000,%eax
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	ff 75 08             	pushl  0x8(%ebp)
  80070b:	50                   	push   %eax
  80070c:	68 2d 2b 80 00       	push   $0x802b2d
  800711:	e8 5e 02 00 00       	call   800974 <cprintf>
  800716:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800719:	8b 45 10             	mov    0x10(%ebp),%eax
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 f4             	pushl  -0xc(%ebp)
  800722:	50                   	push   %eax
  800723:	e8 e1 01 00 00       	call   800909 <vcprintf>
  800728:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	6a 00                	push   $0x0
  800730:	68 49 2b 80 00       	push   $0x802b49
  800735:	e8 cf 01 00 00       	call   800909 <vcprintf>
  80073a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073d:	e8 82 ff ff ff       	call   8006c4 <exit>

	// should not return here
	while (1) ;
  800742:	eb fe                	jmp    800742 <_panic+0x70>

00800744 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80074a:	a1 20 40 80 00       	mov    0x804020,%eax
  80074f:	8b 50 74             	mov    0x74(%eax),%edx
  800752:	8b 45 0c             	mov    0xc(%ebp),%eax
  800755:	39 c2                	cmp    %eax,%edx
  800757:	74 14                	je     80076d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800759:	83 ec 04             	sub    $0x4,%esp
  80075c:	68 4c 2b 80 00       	push   $0x802b4c
  800761:	6a 26                	push   $0x26
  800763:	68 98 2b 80 00       	push   $0x802b98
  800768:	e8 65 ff ff ff       	call   8006d2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800774:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80077b:	e9 b6 00 00 00       	jmp    800836 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800783:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	01 d0                	add    %edx,%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	85 c0                	test   %eax,%eax
  800793:	75 08                	jne    80079d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800795:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800798:	e9 96 00 00 00       	jmp    800833 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80079d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ab:	eb 5d                	jmp    80080a <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8007b2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bb:	c1 e2 04             	shl    $0x4,%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	8a 40 04             	mov    0x4(%eax),%al
  8007c3:	84 c0                	test   %al,%al
  8007c5:	75 40                	jne    800807 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8007cc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d5:	c1 e2 04             	shl    $0x4,%edx
  8007d8:	01 d0                	add    %edx,%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ec:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	01 c8                	add    %ecx,%eax
  8007f8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007fa:	39 c2                	cmp    %eax,%edx
  8007fc:	75 09                	jne    800807 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8007fe:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800805:	eb 12                	jmp    800819 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800807:	ff 45 e8             	incl   -0x18(%ebp)
  80080a:	a1 20 40 80 00       	mov    0x804020,%eax
  80080f:	8b 50 74             	mov    0x74(%eax),%edx
  800812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800815:	39 c2                	cmp    %eax,%edx
  800817:	77 94                	ja     8007ad <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800819:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80081d:	75 14                	jne    800833 <CheckWSWithoutLastIndex+0xef>
			panic(
  80081f:	83 ec 04             	sub    $0x4,%esp
  800822:	68 a4 2b 80 00       	push   $0x802ba4
  800827:	6a 3a                	push   $0x3a
  800829:	68 98 2b 80 00       	push   $0x802b98
  80082e:	e8 9f fe ff ff       	call   8006d2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800833:	ff 45 f0             	incl   -0x10(%ebp)
  800836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800839:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80083c:	0f 8c 3e ff ff ff    	jl     800780 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800842:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800849:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800850:	eb 20                	jmp    800872 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800852:	a1 20 40 80 00       	mov    0x804020,%eax
  800857:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80085d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800860:	c1 e2 04             	shl    $0x4,%edx
  800863:	01 d0                	add    %edx,%eax
  800865:	8a 40 04             	mov    0x4(%eax),%al
  800868:	3c 01                	cmp    $0x1,%al
  80086a:	75 03                	jne    80086f <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80086c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086f:	ff 45 e0             	incl   -0x20(%ebp)
  800872:	a1 20 40 80 00       	mov    0x804020,%eax
  800877:	8b 50 74             	mov    0x74(%eax),%edx
  80087a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80087d:	39 c2                	cmp    %eax,%edx
  80087f:	77 d1                	ja     800852 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800884:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800887:	74 14                	je     80089d <CheckWSWithoutLastIndex+0x159>
		panic(
  800889:	83 ec 04             	sub    $0x4,%esp
  80088c:	68 f8 2b 80 00       	push   $0x802bf8
  800891:	6a 44                	push   $0x44
  800893:	68 98 2b 80 00       	push   $0x802b98
  800898:	e8 35 fe ff ff       	call   8006d2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80089d:	90                   	nop
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b1:	89 0a                	mov    %ecx,(%edx)
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b6:	88 d1                	mov    %dl,%cl
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008c9:	75 2c                	jne    8008f7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008cb:	a0 24 40 80 00       	mov    0x804024,%al
  8008d0:	0f b6 c0             	movzbl %al,%eax
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d6:	8b 12                	mov    (%edx),%edx
  8008d8:	89 d1                	mov    %edx,%ecx
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dd:	83 c2 08             	add    $0x8,%edx
  8008e0:	83 ec 04             	sub    $0x4,%esp
  8008e3:	50                   	push   %eax
  8008e4:	51                   	push   %ecx
  8008e5:	52                   	push   %edx
  8008e6:	e8 9c 14 00 00       	call   801d87 <sys_cputs>
  8008eb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fa:	8b 40 04             	mov    0x4(%eax),%eax
  8008fd:	8d 50 01             	lea    0x1(%eax),%edx
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	89 50 04             	mov    %edx,0x4(%eax)
}
  800906:	90                   	nop
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800912:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800919:	00 00 00 
	b.cnt = 0;
  80091c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800923:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800932:	50                   	push   %eax
  800933:	68 a0 08 80 00       	push   $0x8008a0
  800938:	e8 11 02 00 00       	call   800b4e <vprintfmt>
  80093d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800940:	a0 24 40 80 00       	mov    0x804024,%al
  800945:	0f b6 c0             	movzbl %al,%eax
  800948:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80094e:	83 ec 04             	sub    $0x4,%esp
  800951:	50                   	push   %eax
  800952:	52                   	push   %edx
  800953:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800959:	83 c0 08             	add    $0x8,%eax
  80095c:	50                   	push   %eax
  80095d:	e8 25 14 00 00       	call   801d87 <sys_cputs>
  800962:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800965:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80096c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800972:	c9                   	leave  
  800973:	c3                   	ret    

00800974 <cprintf>:

int cprintf(const char *fmt, ...) {
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80097a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800981:	8d 45 0c             	lea    0xc(%ebp),%eax
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	ff 75 f4             	pushl  -0xc(%ebp)
  800990:	50                   	push   %eax
  800991:	e8 73 ff ff ff       	call   800909 <vcprintf>
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009a7:	e8 ec 15 00 00       	call   801f98 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	e8 48 ff ff ff       	call   800909 <vcprintf>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009c7:	e8 e6 15 00 00       	call   801fb2 <sys_enable_interrupt>
	return cnt;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	53                   	push   %ebx
  8009d5:	83 ec 14             	sub    $0x14,%esp
  8009d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009e4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009ef:	77 55                	ja     800a46 <printnum+0x75>
  8009f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009f4:	72 05                	jb     8009fb <printnum+0x2a>
  8009f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009f9:	77 4b                	ja     800a46 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009fb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009fe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a01:	8b 45 18             	mov    0x18(%ebp),%eax
  800a04:	ba 00 00 00 00       	mov    $0x0,%edx
  800a09:	52                   	push   %edx
  800a0a:	50                   	push   %eax
  800a0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a11:	e8 a6 19 00 00       	call   8023bc <__udivdi3>
  800a16:	83 c4 10             	add    $0x10,%esp
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	ff 75 20             	pushl  0x20(%ebp)
  800a1f:	53                   	push   %ebx
  800a20:	ff 75 18             	pushl  0x18(%ebp)
  800a23:	52                   	push   %edx
  800a24:	50                   	push   %eax
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	ff 75 08             	pushl  0x8(%ebp)
  800a2b:	e8 a1 ff ff ff       	call   8009d1 <printnum>
  800a30:	83 c4 20             	add    $0x20,%esp
  800a33:	eb 1a                	jmp    800a4f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	ff 75 20             	pushl  0x20(%ebp)
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a46:	ff 4d 1c             	decl   0x1c(%ebp)
  800a49:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a4d:	7f e6                	jg     800a35 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a4f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5d:	53                   	push   %ebx
  800a5e:	51                   	push   %ecx
  800a5f:	52                   	push   %edx
  800a60:	50                   	push   %eax
  800a61:	e8 66 1a 00 00       	call   8024cc <__umoddi3>
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	05 74 2e 80 00       	add    $0x802e74,%eax
  800a6e:	8a 00                	mov    (%eax),%al
  800a70:	0f be c0             	movsbl %al,%eax
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	50                   	push   %eax
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
}
  800a82:	90                   	nop
  800a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a8f:	7e 1c                	jle    800aad <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	8d 50 08             	lea    0x8(%eax),%edx
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	89 10                	mov    %edx,(%eax)
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	83 e8 08             	sub    $0x8,%eax
  800aa6:	8b 50 04             	mov    0x4(%eax),%edx
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	eb 40                	jmp    800aed <getuint+0x65>
	else if (lflag)
  800aad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab1:	74 1e                	je     800ad1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	8d 50 04             	lea    0x4(%eax),%edx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	89 10                	mov    %edx,(%eax)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	83 e8 04             	sub    $0x4,%eax
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	ba 00 00 00 00       	mov    $0x0,%edx
  800acf:	eb 1c                	jmp    800aed <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	8d 50 04             	lea    0x4(%eax),%edx
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	89 10                	mov    %edx,(%eax)
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	83 e8 04             	sub    $0x4,%eax
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af6:	7e 1c                	jle    800b14 <getint+0x25>
		return va_arg(*ap, long long);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	8d 50 08             	lea    0x8(%eax),%edx
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 10                	mov    %edx,(%eax)
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	83 e8 08             	sub    $0x8,%eax
  800b0d:	8b 50 04             	mov    0x4(%eax),%edx
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	eb 38                	jmp    800b4c <getint+0x5d>
	else if (lflag)
  800b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b18:	74 1a                	je     800b34 <getint+0x45>
		return va_arg(*ap, long);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	8d 50 04             	lea    0x4(%eax),%edx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	83 e8 04             	sub    $0x4,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	99                   	cltd   
  800b32:	eb 18                	jmp    800b4c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	8d 50 04             	lea    0x4(%eax),%edx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 10                	mov    %edx,(%eax)
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	83 e8 04             	sub    $0x4,%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	99                   	cltd   
}
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
  800b53:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b56:	eb 17                	jmp    800b6f <vprintfmt+0x21>
			if (ch == '\0')
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	0f 84 af 03 00 00    	je     800f0f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	53                   	push   %ebx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b72:	8d 50 01             	lea    0x1(%eax),%edx
  800b75:	89 55 10             	mov    %edx,0x10(%ebp)
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	0f b6 d8             	movzbl %al,%ebx
  800b7d:	83 fb 25             	cmp    $0x25,%ebx
  800b80:	75 d6                	jne    800b58 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b82:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b86:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b9b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	8d 50 01             	lea    0x1(%eax),%edx
  800ba8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bab:	8a 00                	mov    (%eax),%al
  800bad:	0f b6 d8             	movzbl %al,%ebx
  800bb0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bb3:	83 f8 55             	cmp    $0x55,%eax
  800bb6:	0f 87 2b 03 00 00    	ja     800ee7 <vprintfmt+0x399>
  800bbc:	8b 04 85 98 2e 80 00 	mov    0x802e98(,%eax,4),%eax
  800bc3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bc5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bc9:	eb d7                	jmp    800ba2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bcb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bcf:	eb d1                	jmp    800ba2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bdb:	89 d0                	mov    %edx,%eax
  800bdd:	c1 e0 02             	shl    $0x2,%eax
  800be0:	01 d0                	add    %edx,%eax
  800be2:	01 c0                	add    %eax,%eax
  800be4:	01 d8                	add    %ebx,%eax
  800be6:	83 e8 30             	sub    $0x30,%eax
  800be9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bec:	8b 45 10             	mov    0x10(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf4:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf7:	7e 3e                	jle    800c37 <vprintfmt+0xe9>
  800bf9:	83 fb 39             	cmp    $0x39,%ebx
  800bfc:	7f 39                	jg     800c37 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c01:	eb d5                	jmp    800bd8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c03:	8b 45 14             	mov    0x14(%ebp),%eax
  800c06:	83 c0 04             	add    $0x4,%eax
  800c09:	89 45 14             	mov    %eax,0x14(%ebp)
  800c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0f:	83 e8 04             	sub    $0x4,%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c17:	eb 1f                	jmp    800c38 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1d:	79 83                	jns    800ba2 <vprintfmt+0x54>
				width = 0;
  800c1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c26:	e9 77 ff ff ff       	jmp    800ba2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c2b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c32:	e9 6b ff ff ff       	jmp    800ba2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c37:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3c:	0f 89 60 ff ff ff    	jns    800ba2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c4f:	e9 4e ff ff ff       	jmp    800ba2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c54:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c57:	e9 46 ff ff ff       	jmp    800ba2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5f:	83 c0 04             	add    $0x4,%eax
  800c62:	89 45 14             	mov    %eax,0x14(%ebp)
  800c65:	8b 45 14             	mov    0x14(%ebp),%eax
  800c68:	83 e8 04             	sub    $0x4,%eax
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	50                   	push   %eax
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
			break;
  800c7c:	e9 89 02 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c81:	8b 45 14             	mov    0x14(%ebp),%eax
  800c84:	83 c0 04             	add    $0x4,%eax
  800c87:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8d:	83 e8 04             	sub    $0x4,%eax
  800c90:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c92:	85 db                	test   %ebx,%ebx
  800c94:	79 02                	jns    800c98 <vprintfmt+0x14a>
				err = -err;
  800c96:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c98:	83 fb 64             	cmp    $0x64,%ebx
  800c9b:	7f 0b                	jg     800ca8 <vprintfmt+0x15a>
  800c9d:	8b 34 9d e0 2c 80 00 	mov    0x802ce0(,%ebx,4),%esi
  800ca4:	85 f6                	test   %esi,%esi
  800ca6:	75 19                	jne    800cc1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ca8:	53                   	push   %ebx
  800ca9:	68 85 2e 80 00       	push   $0x802e85
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	ff 75 08             	pushl  0x8(%ebp)
  800cb4:	e8 5e 02 00 00       	call   800f17 <printfmt>
  800cb9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cbc:	e9 49 02 00 00       	jmp    800f0a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cc1:	56                   	push   %esi
  800cc2:	68 8e 2e 80 00       	push   $0x802e8e
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 45 02 00 00       	call   800f17 <printfmt>
  800cd2:	83 c4 10             	add    $0x10,%esp
			break;
  800cd5:	e9 30 02 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	83 c0 04             	add    $0x4,%eax
  800ce0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce6:	83 e8 04             	sub    $0x4,%eax
  800ce9:	8b 30                	mov    (%eax),%esi
  800ceb:	85 f6                	test   %esi,%esi
  800ced:	75 05                	jne    800cf4 <vprintfmt+0x1a6>
				p = "(null)";
  800cef:	be 91 2e 80 00       	mov    $0x802e91,%esi
			if (width > 0 && padc != '-')
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	7e 6d                	jle    800d67 <vprintfmt+0x219>
  800cfa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cfe:	74 67                	je     800d67 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	50                   	push   %eax
  800d07:	56                   	push   %esi
  800d08:	e8 0c 03 00 00       	call   801019 <strnlen>
  800d0d:	83 c4 10             	add    $0x10,%esp
  800d10:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d13:	eb 16                	jmp    800d2b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d15:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d28:	ff 4d e4             	decl   -0x1c(%ebp)
  800d2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2f:	7f e4                	jg     800d15 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d31:	eb 34                	jmp    800d67 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d33:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d37:	74 1c                	je     800d55 <vprintfmt+0x207>
  800d39:	83 fb 1f             	cmp    $0x1f,%ebx
  800d3c:	7e 05                	jle    800d43 <vprintfmt+0x1f5>
  800d3e:	83 fb 7e             	cmp    $0x7e,%ebx
  800d41:	7e 12                	jle    800d55 <vprintfmt+0x207>
					putch('?', putdat);
  800d43:	83 ec 08             	sub    $0x8,%esp
  800d46:	ff 75 0c             	pushl  0xc(%ebp)
  800d49:	6a 3f                	push   $0x3f
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	ff d0                	call   *%eax
  800d50:	83 c4 10             	add    $0x10,%esp
  800d53:	eb 0f                	jmp    800d64 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	53                   	push   %ebx
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d64:	ff 4d e4             	decl   -0x1c(%ebp)
  800d67:	89 f0                	mov    %esi,%eax
  800d69:	8d 70 01             	lea    0x1(%eax),%esi
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	0f be d8             	movsbl %al,%ebx
  800d71:	85 db                	test   %ebx,%ebx
  800d73:	74 24                	je     800d99 <vprintfmt+0x24b>
  800d75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d79:	78 b8                	js     800d33 <vprintfmt+0x1e5>
  800d7b:	ff 4d e0             	decl   -0x20(%ebp)
  800d7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d82:	79 af                	jns    800d33 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d84:	eb 13                	jmp    800d99 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	6a 20                	push   $0x20
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d96:	ff 4d e4             	decl   -0x1c(%ebp)
  800d99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9d:	7f e7                	jg     800d86 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d9f:	e9 66 01 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800da4:	83 ec 08             	sub    $0x8,%esp
  800da7:	ff 75 e8             	pushl  -0x18(%ebp)
  800daa:	8d 45 14             	lea    0x14(%ebp),%eax
  800dad:	50                   	push   %eax
  800dae:	e8 3c fd ff ff       	call   800aef <getint>
  800db3:	83 c4 10             	add    $0x10,%esp
  800db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc2:	85 d2                	test   %edx,%edx
  800dc4:	79 23                	jns    800de9 <vprintfmt+0x29b>
				putch('-', putdat);
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	ff 75 0c             	pushl  0xc(%ebp)
  800dcc:	6a 2d                	push   $0x2d
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	ff d0                	call   *%eax
  800dd3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ddc:	f7 d8                	neg    %eax
  800dde:	83 d2 00             	adc    $0x0,%edx
  800de1:	f7 da                	neg    %edx
  800de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800de9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800df0:	e9 bc 00 00 00       	jmp    800eb1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800df5:	83 ec 08             	sub    $0x8,%esp
  800df8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dfe:	50                   	push   %eax
  800dff:	e8 84 fc ff ff       	call   800a88 <getuint>
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e14:	e9 98 00 00 00       	jmp    800eb1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	6a 58                	push   $0x58
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	ff d0                	call   *%eax
  800e26:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	ff 75 0c             	pushl  0xc(%ebp)
  800e2f:	6a 58                	push   $0x58
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	ff d0                	call   *%eax
  800e36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	ff 75 0c             	pushl  0xc(%ebp)
  800e3f:	6a 58                	push   $0x58
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	ff d0                	call   *%eax
  800e46:	83 c4 10             	add    $0x10,%esp
			break;
  800e49:	e9 bc 00 00 00       	jmp    800f0a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	ff 75 0c             	pushl  0xc(%ebp)
  800e54:	6a 30                	push   $0x30
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	ff d0                	call   *%eax
  800e5b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e5e:	83 ec 08             	sub    $0x8,%esp
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	6a 78                	push   $0x78
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	ff d0                	call   *%eax
  800e6b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e71:	83 c0 04             	add    $0x4,%eax
  800e74:	89 45 14             	mov    %eax,0x14(%ebp)
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	83 e8 04             	sub    $0x4,%eax
  800e7d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e89:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e90:	eb 1f                	jmp    800eb1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	ff 75 e8             	pushl  -0x18(%ebp)
  800e98:	8d 45 14             	lea    0x14(%ebp),%eax
  800e9b:	50                   	push   %eax
  800e9c:	e8 e7 fb ff ff       	call   800a88 <getuint>
  800ea1:	83 c4 10             	add    $0x10,%esp
  800ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eb1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb8:	83 ec 04             	sub    $0x4,%esp
  800ebb:	52                   	push   %edx
  800ebc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ec3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec6:	ff 75 0c             	pushl  0xc(%ebp)
  800ec9:	ff 75 08             	pushl  0x8(%ebp)
  800ecc:	e8 00 fb ff ff       	call   8009d1 <printnum>
  800ed1:	83 c4 20             	add    $0x20,%esp
			break;
  800ed4:	eb 34                	jmp    800f0a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	ff 75 0c             	pushl  0xc(%ebp)
  800edc:	53                   	push   %ebx
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	ff d0                	call   *%eax
  800ee2:	83 c4 10             	add    $0x10,%esp
			break;
  800ee5:	eb 23                	jmp    800f0a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 25                	push   $0x25
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef7:	ff 4d 10             	decl   0x10(%ebp)
  800efa:	eb 03                	jmp    800eff <vprintfmt+0x3b1>
  800efc:	ff 4d 10             	decl   0x10(%ebp)
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	48                   	dec    %eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	3c 25                	cmp    $0x25,%al
  800f07:	75 f3                	jne    800efc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f09:	90                   	nop
		}
	}
  800f0a:	e9 47 fc ff ff       	jmp    800b56 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f0f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f13:	5b                   	pop    %ebx
  800f14:	5e                   	pop    %esi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f1d:	8d 45 10             	lea    0x10(%ebp),%eax
  800f20:	83 c0 04             	add    $0x4,%eax
  800f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f26:	8b 45 10             	mov    0x10(%ebp),%eax
  800f29:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2c:	50                   	push   %eax
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	ff 75 08             	pushl  0x8(%ebp)
  800f33:	e8 16 fc ff ff       	call   800b4e <vprintfmt>
  800f38:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f3b:	90                   	nop
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	8b 40 08             	mov    0x8(%eax),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 10                	mov    (%eax),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8b 40 04             	mov    0x4(%eax),%eax
  800f5b:	39 c2                	cmp    %eax,%edx
  800f5d:	73 12                	jae    800f71 <sprintputch+0x33>
		*b->buf++ = ch;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 00                	mov    (%eax),%eax
  800f64:	8d 48 01             	lea    0x1(%eax),%ecx
  800f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6a:	89 0a                	mov    %ecx,(%edx)
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	88 10                	mov    %dl,(%eax)
}
  800f71:	90                   	nop
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	01 d0                	add    %edx,%eax
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f99:	74 06                	je     800fa1 <vsnprintf+0x2d>
  800f9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f9f:	7f 07                	jg     800fa8 <vsnprintf+0x34>
		return -E_INVAL;
  800fa1:	b8 03 00 00 00       	mov    $0x3,%eax
  800fa6:	eb 20                	jmp    800fc8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fa8:	ff 75 14             	pushl  0x14(%ebp)
  800fab:	ff 75 10             	pushl  0x10(%ebp)
  800fae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fb1:	50                   	push   %eax
  800fb2:	68 3e 0f 80 00       	push   $0x800f3e
  800fb7:	e8 92 fb ff ff       	call   800b4e <vprintfmt>
  800fbc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fc2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    

00800fca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fd0:	8d 45 10             	lea    0x10(%ebp),%eax
  800fd3:	83 c0 04             	add    $0x4,%eax
  800fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	ff 75 08             	pushl  0x8(%ebp)
  800fe6:	e8 89 ff ff ff       	call   800f74 <vsnprintf>
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801003:	eb 06                	jmp    80100b <strlen+0x15>
		n++;
  801005:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	84 c0                	test   %al,%al
  801012:	75 f1                	jne    801005 <strlen+0xf>
		n++;
	return n;
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801026:	eb 09                	jmp    801031 <strnlen+0x18>
		n++;
  801028:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102b:	ff 45 08             	incl   0x8(%ebp)
  80102e:	ff 4d 0c             	decl   0xc(%ebp)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 09                	je     801040 <strnlen+0x27>
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	84 c0                	test   %al,%al
  80103e:	75 e8                	jne    801028 <strnlen+0xf>
		n++;
	return n;
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    

00801045 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801051:	90                   	nop
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8d 50 01             	lea    0x1(%eax),%edx
  801058:	89 55 08             	mov    %edx,0x8(%ebp)
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801061:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801064:	8a 12                	mov    (%edx),%dl
  801066:	88 10                	mov    %dl,(%eax)
  801068:	8a 00                	mov    (%eax),%al
  80106a:	84 c0                	test   %al,%al
  80106c:	75 e4                	jne    801052 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80106e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80107f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801086:	eb 1f                	jmp    8010a7 <strncpy+0x34>
		*dst++ = *src;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 08             	mov    %edx,0x8(%ebp)
  801091:	8b 55 0c             	mov    0xc(%ebp),%edx
  801094:	8a 12                	mov    (%edx),%dl
  801096:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	84 c0                	test   %al,%al
  80109f:	74 03                	je     8010a4 <strncpy+0x31>
			src++;
  8010a1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010a4:	ff 45 fc             	incl   -0x4(%ebp)
  8010a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ad:	72 d9                	jb     801088 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010b2:	c9                   	leave  
  8010b3:	c3                   	ret    

008010b4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c4:	74 30                	je     8010f6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010c6:	eb 16                	jmp    8010de <strlcpy+0x2a>
			*dst++ = *src++;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010da:	8a 12                	mov    (%edx),%dl
  8010dc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010de:	ff 4d 10             	decl   0x10(%ebp)
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 09                	je     8010f0 <strlcpy+0x3c>
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	84 c0                	test   %al,%al
  8010ee:	75 d8                	jne    8010c8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fc:	29 c2                	sub    %eax,%edx
  8010fe:	89 d0                	mov    %edx,%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801105:	eb 06                	jmp    80110d <strcmp+0xb>
		p++, q++;
  801107:	ff 45 08             	incl   0x8(%ebp)
  80110a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	84 c0                	test   %al,%al
  801114:	74 0e                	je     801124 <strcmp+0x22>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 10                	mov    (%eax),%dl
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	38 c2                	cmp    %al,%dl
  801122:	74 e3                	je     801107 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	0f b6 d0             	movzbl %al,%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 c0             	movzbl %al,%eax
  801134:	29 c2                	sub    %eax,%edx
  801136:	89 d0                	mov    %edx,%eax
}
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80113d:	eb 09                	jmp    801148 <strncmp+0xe>
		n--, p++, q++;
  80113f:	ff 4d 10             	decl   0x10(%ebp)
  801142:	ff 45 08             	incl   0x8(%ebp)
  801145:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	74 17                	je     801165 <strncmp+0x2b>
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	84 c0                	test   %al,%al
  801155:	74 0e                	je     801165 <strncmp+0x2b>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 10                	mov    (%eax),%dl
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	38 c2                	cmp    %al,%dl
  801163:	74 da                	je     80113f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801165:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801169:	75 07                	jne    801172 <strncmp+0x38>
		return 0;
  80116b:	b8 00 00 00 00       	mov    $0x0,%eax
  801170:	eb 14                	jmp    801186 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f b6 d0             	movzbl %al,%edx
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 c0             	movzbl %al,%eax
  801182:	29 c2                	sub    %eax,%edx
  801184:	89 d0                	mov    %edx,%eax
}
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 04             	sub    $0x4,%esp
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801194:	eb 12                	jmp    8011a8 <strchr+0x20>
		if (*s == c)
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80119e:	75 05                	jne    8011a5 <strchr+0x1d>
			return (char *) s;
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	eb 11                	jmp    8011b6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011a5:	ff 45 08             	incl   0x8(%ebp)
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	84 c0                	test   %al,%al
  8011af:	75 e5                	jne    801196 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011c4:	eb 0d                	jmp    8011d3 <strfind+0x1b>
		if (*s == c)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ce:	74 0e                	je     8011de <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011d0:	ff 45 08             	incl   0x8(%ebp)
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	84 c0                	test   %al,%al
  8011da:	75 ea                	jne    8011c6 <strfind+0xe>
  8011dc:	eb 01                	jmp    8011df <strfind+0x27>
		if (*s == c)
			break;
  8011de:	90                   	nop
	return (char *) s;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011f6:	eb 0e                	jmp    801206 <memset+0x22>
		*p++ = c;
  8011f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fb:	8d 50 01             	lea    0x1(%eax),%edx
  8011fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801201:	8b 55 0c             	mov    0xc(%ebp),%edx
  801204:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801206:	ff 4d f8             	decl   -0x8(%ebp)
  801209:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80120d:	79 e9                	jns    8011f8 <memset+0x14>
		*p++ = c;

	return v;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801226:	eb 16                	jmp    80123e <memcpy+0x2a>
		*d++ = *s++;
  801228:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122b:	8d 50 01             	lea    0x1(%eax),%edx
  80122e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801231:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801234:	8d 4a 01             	lea    0x1(%edx),%ecx
  801237:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80123a:	8a 12                	mov    (%edx),%dl
  80123c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	8d 50 ff             	lea    -0x1(%eax),%edx
  801244:	89 55 10             	mov    %edx,0x10(%ebp)
  801247:	85 c0                	test   %eax,%eax
  801249:	75 dd                	jne    801228 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801262:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	73 50                	jae    8012ba <memmove+0x6a>
  80126a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126d:	8b 45 10             	mov    0x10(%ebp),%eax
  801270:	01 d0                	add    %edx,%eax
  801272:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801275:	76 43                	jbe    8012ba <memmove+0x6a>
		s += n;
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801283:	eb 10                	jmp    801295 <memmove+0x45>
			*--d = *--s;
  801285:	ff 4d f8             	decl   -0x8(%ebp)
  801288:	ff 4d fc             	decl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8a 10                	mov    (%eax),%dl
  801290:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801293:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801295:	8b 45 10             	mov    0x10(%ebp),%eax
  801298:	8d 50 ff             	lea    -0x1(%eax),%edx
  80129b:	89 55 10             	mov    %edx,0x10(%ebp)
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	75 e3                	jne    801285 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012a2:	eb 23                	jmp    8012c7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012b3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012b6:	8a 12                	mov    (%edx),%dl
  8012b8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	75 dd                	jne    8012a4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012de:	eb 2a                	jmp    80130a <memcmp+0x3e>
		if (*s1 != *s2)
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e3:	8a 10                	mov    (%eax),%dl
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	38 c2                	cmp    %al,%dl
  8012ec:	74 16                	je     801304 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	0f b6 d0             	movzbl %al,%edx
  8012f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	0f b6 c0             	movzbl %al,%eax
  8012fe:	29 c2                	sub    %eax,%edx
  801300:	89 d0                	mov    %edx,%eax
  801302:	eb 18                	jmp    80131c <memcmp+0x50>
		s1++, s2++;
  801304:	ff 45 fc             	incl   -0x4(%ebp)
  801307:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80130a:	8b 45 10             	mov    0x10(%ebp),%eax
  80130d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801310:	89 55 10             	mov    %edx,0x10(%ebp)
  801313:	85 c0                	test   %eax,%eax
  801315:	75 c9                	jne    8012e0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801324:	8b 55 08             	mov    0x8(%ebp),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80132f:	eb 15                	jmp    801346 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f b6 d0             	movzbl %al,%edx
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	0f b6 c0             	movzbl %al,%eax
  80133f:	39 c2                	cmp    %eax,%edx
  801341:	74 0d                	je     801350 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801343:	ff 45 08             	incl   0x8(%ebp)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80134c:	72 e3                	jb     801331 <memfind+0x13>
  80134e:	eb 01                	jmp    801351 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801350:	90                   	nop
	return (void *) s;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80135c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801363:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136a:	eb 03                	jmp    80136f <strtol+0x19>
		s++;
  80136c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	3c 20                	cmp    $0x20,%al
  801376:	74 f4                	je     80136c <strtol+0x16>
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	3c 09                	cmp    $0x9,%al
  80137f:	74 eb                	je     80136c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	3c 2b                	cmp    $0x2b,%al
  801388:	75 05                	jne    80138f <strtol+0x39>
		s++;
  80138a:	ff 45 08             	incl   0x8(%ebp)
  80138d:	eb 13                	jmp    8013a2 <strtol+0x4c>
	else if (*s == '-')
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	3c 2d                	cmp    $0x2d,%al
  801396:	75 0a                	jne    8013a2 <strtol+0x4c>
		s++, neg = 1;
  801398:	ff 45 08             	incl   0x8(%ebp)
  80139b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a6:	74 06                	je     8013ae <strtol+0x58>
  8013a8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013ac:	75 20                	jne    8013ce <strtol+0x78>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	3c 30                	cmp    $0x30,%al
  8013b5:	75 17                	jne    8013ce <strtol+0x78>
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	40                   	inc    %eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	3c 78                	cmp    $0x78,%al
  8013bf:	75 0d                	jne    8013ce <strtol+0x78>
		s += 2, base = 16;
  8013c1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013c5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013cc:	eb 28                	jmp    8013f6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d2:	75 15                	jne    8013e9 <strtol+0x93>
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	3c 30                	cmp    $0x30,%al
  8013db:	75 0c                	jne    8013e9 <strtol+0x93>
		s++, base = 8;
  8013dd:	ff 45 08             	incl   0x8(%ebp)
  8013e0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013e7:	eb 0d                	jmp    8013f6 <strtol+0xa0>
	else if (base == 0)
  8013e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ed:	75 07                	jne    8013f6 <strtol+0xa0>
		base = 10;
  8013ef:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	3c 2f                	cmp    $0x2f,%al
  8013fd:	7e 19                	jle    801418 <strtol+0xc2>
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	3c 39                	cmp    $0x39,%al
  801406:	7f 10                	jg     801418 <strtol+0xc2>
			dig = *s - '0';
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	0f be c0             	movsbl %al,%eax
  801410:	83 e8 30             	sub    $0x30,%eax
  801413:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801416:	eb 42                	jmp    80145a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	3c 60                	cmp    $0x60,%al
  80141f:	7e 19                	jle    80143a <strtol+0xe4>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 7a                	cmp    $0x7a,%al
  801428:	7f 10                	jg     80143a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	0f be c0             	movsbl %al,%eax
  801432:	83 e8 57             	sub    $0x57,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801438:	eb 20                	jmp    80145a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	3c 40                	cmp    $0x40,%al
  801441:	7e 39                	jle    80147c <strtol+0x126>
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	3c 5a                	cmp    $0x5a,%al
  80144a:	7f 30                	jg     80147c <strtol+0x126>
			dig = *s - 'A' + 10;
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	0f be c0             	movsbl %al,%eax
  801454:	83 e8 37             	sub    $0x37,%eax
  801457:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80145a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801460:	7d 19                	jge    80147b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801462:	ff 45 08             	incl   0x8(%ebp)
  801465:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801468:	0f af 45 10          	imul   0x10(%ebp),%eax
  80146c:	89 c2                	mov    %eax,%edx
  80146e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801476:	e9 7b ff ff ff       	jmp    8013f6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80147b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80147c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801480:	74 08                	je     80148a <strtol+0x134>
		*endptr = (char *) s;
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8b 55 08             	mov    0x8(%ebp),%edx
  801488:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80148a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80148e:	74 07                	je     801497 <strtol+0x141>
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801493:	f7 d8                	neg    %eax
  801495:	eb 03                	jmp    80149a <strtol+0x144>
  801497:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <ltostr>:

void
ltostr(long value, char *str)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014b4:	79 13                	jns    8014c9 <ltostr+0x2d>
	{
		neg = 1;
  8014b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014c3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014c6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014d1:	99                   	cltd   
  8014d2:	f7 f9                	idiv   %ecx
  8014d4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	89 c2                	mov    %eax,%edx
  8014e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e5:	01 d0                	add    %edx,%eax
  8014e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014ea:	83 c2 30             	add    $0x30,%edx
  8014ed:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014f7:	f7 e9                	imul   %ecx
  8014f9:	c1 fa 02             	sar    $0x2,%edx
  8014fc:	89 c8                	mov    %ecx,%eax
  8014fe:	c1 f8 1f             	sar    $0x1f,%eax
  801501:	29 c2                	sub    %eax,%edx
  801503:	89 d0                	mov    %edx,%eax
  801505:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801508:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801510:	f7 e9                	imul   %ecx
  801512:	c1 fa 02             	sar    $0x2,%edx
  801515:	89 c8                	mov    %ecx,%eax
  801517:	c1 f8 1f             	sar    $0x1f,%eax
  80151a:	29 c2                	sub    %eax,%edx
  80151c:	89 d0                	mov    %edx,%eax
  80151e:	c1 e0 02             	shl    $0x2,%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	01 c0                	add    %eax,%eax
  801525:	29 c1                	sub    %eax,%ecx
  801527:	89 ca                	mov    %ecx,%edx
  801529:	85 d2                	test   %edx,%edx
  80152b:	75 9c                	jne    8014c9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80152d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801534:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801537:	48                   	dec    %eax
  801538:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80153b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153f:	74 3d                	je     80157e <ltostr+0xe2>
		start = 1 ;
  801541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801548:	eb 34                	jmp    80157e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155d:	01 c2                	add    %eax,%edx
  80155f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	01 c8                	add    %ecx,%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80156b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 c2                	add    %eax,%edx
  801573:	8a 45 eb             	mov    -0x15(%ebp),%al
  801576:	88 02                	mov    %al,(%edx)
		start++ ;
  801578:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80157b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80157e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801581:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801584:	7c c4                	jl     80154a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801586:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	01 d0                	add    %edx,%eax
  80158e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801591:	90                   	nop
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	e8 54 fa ff ff       	call   800ff6 <strlen>
  8015a2:	83 c4 04             	add    $0x4,%esp
  8015a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	e8 46 fa ff ff       	call   800ff6 <strlen>
  8015b0:	83 c4 04             	add    $0x4,%esp
  8015b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c4:	eb 17                	jmp    8015dd <strcconcat+0x49>
		final[s] = str1[s] ;
  8015c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cc:	01 c2                	add    %eax,%edx
  8015ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	01 c8                	add    %ecx,%eax
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015da:	ff 45 fc             	incl   -0x4(%ebp)
  8015dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e3:	7c e1                	jl     8015c6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015f3:	eb 1f                	jmp    801614 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f8:	8d 50 01             	lea    0x1(%eax),%edx
  8015fb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015fe:	89 c2                	mov    %eax,%edx
  801600:	8b 45 10             	mov    0x10(%ebp),%eax
  801603:	01 c2                	add    %eax,%edx
  801605:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	01 c8                	add    %ecx,%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801611:	ff 45 f8             	incl   -0x8(%ebp)
  801614:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801617:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161a:	7c d9                	jl     8015f5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80161c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	c6 00 00             	movb   $0x0,(%eax)
}
  801627:	90                   	nop
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80162d:	8b 45 14             	mov    0x14(%ebp),%eax
  801630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801636:	8b 45 14             	mov    0x14(%ebp),%eax
  801639:	8b 00                	mov    (%eax),%eax
  80163b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801642:	8b 45 10             	mov    0x10(%ebp),%eax
  801645:	01 d0                	add    %edx,%eax
  801647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164d:	eb 0c                	jmp    80165b <strsplit+0x31>
			*string++ = 0;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	8a 00                	mov    (%eax),%al
  801660:	84 c0                	test   %al,%al
  801662:	74 18                	je     80167c <strsplit+0x52>
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	0f be c0             	movsbl %al,%eax
  80166c:	50                   	push   %eax
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	e8 13 fb ff ff       	call   801188 <strchr>
  801675:	83 c4 08             	add    $0x8,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	75 d3                	jne    80164f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 5a                	je     8016df <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801685:	8b 45 14             	mov    0x14(%ebp),%eax
  801688:	8b 00                	mov    (%eax),%eax
  80168a:	83 f8 0f             	cmp    $0xf,%eax
  80168d:	75 07                	jne    801696 <strsplit+0x6c>
		{
			return 0;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
  801694:	eb 66                	jmp    8016fc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801696:	8b 45 14             	mov    0x14(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	8d 48 01             	lea    0x1(%eax),%ecx
  80169e:	8b 55 14             	mov    0x14(%ebp),%edx
  8016a1:	89 0a                	mov    %ecx,(%edx)
  8016a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ad:	01 c2                	add    %eax,%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b4:	eb 03                	jmp    8016b9 <strsplit+0x8f>
			string++;
  8016b6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 8b                	je     80164d <strsplit+0x23>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 b5 fa ff ff       	call   801188 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	74 dc                	je     8016b6 <strsplit+0x8c>
			string++;
	}
  8016da:	e9 6e ff ff ff       	jmp    80164d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016df:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e3:	8b 00                	mov    (%eax),%eax
  8016e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ef:	01 d0                	add    %edx,%eax
  8016f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801704:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  80170b:	8b 55 08             	mov    0x8(%ebp),%edx
  80170e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801711:	01 d0                	add    %edx,%eax
  801713:	48                   	dec    %eax
  801714:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801717:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	f7 75 ac             	divl   -0x54(%ebp)
  801722:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801725:	29 d0                	sub    %edx,%eax
  801727:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801731:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801738:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80173f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801746:	eb 3f                	jmp    801787 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	50                   	push   %eax
  801756:	ff 75 e8             	pushl  -0x18(%ebp)
  801759:	68 f0 2f 80 00       	push   $0x802ff0
  80175e:	e8 11 f2 ff ff       	call   800974 <cprintf>
  801763:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801769:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	50                   	push   %eax
  801774:	ff 75 e8             	pushl  -0x18(%ebp)
  801777:	68 05 30 80 00       	push   $0x803005
  80177c:	e8 f3 f1 ff ff       	call   800974 <cprintf>
  801781:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801784:	ff 45 e8             	incl   -0x18(%ebp)
  801787:	a1 28 40 80 00       	mov    0x804028,%eax
  80178c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80178f:	7c b7                	jl     801748 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801791:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801798:	e9 35 01 00 00       	jmp    8018d2 <malloc+0x1d4>
		int flag0=1;
  80179d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8017a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017aa:	eb 5e                	jmp    80180a <malloc+0x10c>
			for(int k=0;k<count;k++){
  8017ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8017b3:	eb 35                	jmp    8017ea <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8017b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017b8:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  8017bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017c2:	39 c2                	cmp    %eax,%edx
  8017c4:	77 21                	ja     8017e7 <malloc+0xe9>
  8017c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017c9:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8017d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d3:	39 c2                	cmp    %eax,%edx
  8017d5:	76 10                	jbe    8017e7 <malloc+0xe9>
					ni=PAGE_SIZE;
  8017d7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  8017de:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8017e5:	eb 0d                	jmp    8017f4 <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8017e7:	ff 45 d8             	incl   -0x28(%ebp)
  8017ea:	a1 28 40 80 00       	mov    0x804028,%eax
  8017ef:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8017f2:	7c c1                	jl     8017b5 <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8017f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f8:	74 09                	je     801803 <malloc+0x105>
				flag0=0;
  8017fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801801:	eb 16                	jmp    801819 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801803:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80180a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	01 c2                	add    %eax,%edx
  801812:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801815:	39 c2                	cmp    %eax,%edx
  801817:	77 93                	ja     8017ac <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801819:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80181d:	0f 84 a2 00 00 00    	je     8018c5 <malloc+0x1c7>

			int f=1;
  801823:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  80182a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80182d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801830:	89 c8                	mov    %ecx,%eax
  801832:	01 c0                	add    %eax,%eax
  801834:	01 c8                	add    %ecx,%eax
  801836:	c1 e0 02             	shl    $0x2,%eax
  801839:	05 20 41 80 00       	add    $0x804120,%eax
  80183e:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801840:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184c:	89 d0                	mov    %edx,%eax
  80184e:	01 c0                	add    %eax,%eax
  801850:	01 d0                	add    %edx,%eax
  801852:	c1 e0 02             	shl    $0x2,%eax
  801855:	05 24 41 80 00       	add    $0x804124,%eax
  80185a:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80185c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185f:	89 d0                	mov    %edx,%eax
  801861:	01 c0                	add    %eax,%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c1 e0 02             	shl    $0x2,%eax
  801868:	05 28 41 80 00       	add    $0x804128,%eax
  80186d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801873:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801876:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80187d:	eb 36                	jmp    8018b5 <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  80187f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	01 c2                	add    %eax,%edx
  801887:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80188a:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801891:	39 c2                	cmp    %eax,%edx
  801893:	73 1d                	jae    8018b2 <malloc+0x1b4>
					ni=arr_add[l].end-i;
  801895:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801898:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  80189f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a2:	29 c2                	sub    %eax,%edx
  8018a4:	89 d0                	mov    %edx,%eax
  8018a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8018a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8018b0:	eb 0d                	jmp    8018bf <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8018b2:	ff 45 d0             	incl   -0x30(%ebp)
  8018b5:	a1 28 40 80 00       	mov    0x804028,%eax
  8018ba:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8018bd:	7c c0                	jl     80187f <malloc+0x181>
					break;

				}
			}

			if(f){
  8018bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018c3:	75 1d                	jne    8018e2 <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  8018c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8018cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018cf:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8018d2:	a1 04 40 80 00       	mov    0x804004,%eax
  8018d7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018da:	0f 8c bd fe ff ff    	jl     80179d <malloc+0x9f>
  8018e0:	eb 01                	jmp    8018e3 <malloc+0x1e5>

				}
			}

			if(f){
				break;
  8018e2:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8018e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018e7:	75 7a                	jne    801963 <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8018e9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	48                   	dec    %eax
  8018f5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8018fa:	7c 0a                	jl     801906 <malloc+0x208>
			return NULL;
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801901:	e9 a4 02 00 00       	jmp    801baa <malloc+0x4ac>
		else{
			uint32 s=base_add;
  801906:	a1 04 40 80 00       	mov    0x804004,%eax
  80190b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  80190e:	a1 28 40 80 00       	mov    0x804028,%eax
  801913:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801916:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	ff 75 a4             	pushl  -0x5c(%ebp)
  801926:	e8 04 06 00 00       	call   801f2f <sys_allocateMem>
  80192b:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80192e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	01 d0                	add    %edx,%eax
  801939:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  80193e:	a1 28 40 80 00       	mov    0x804028,%eax
  801943:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801949:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801950:	a1 28 40 80 00       	mov    0x804028,%eax
  801955:	40                   	inc    %eax
  801956:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  80195b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80195e:	e9 47 02 00 00       	jmp    801baa <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  801963:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80196a:	e9 ac 00 00 00       	jmp    801a1b <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80196f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801972:	89 d0                	mov    %edx,%eax
  801974:	01 c0                	add    %eax,%eax
  801976:	01 d0                	add    %edx,%eax
  801978:	c1 e0 02             	shl    $0x2,%eax
  80197b:	05 24 41 80 00       	add    $0x804124,%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801985:	eb 7e                	jmp    801a05 <malloc+0x307>
			int flag=0;
  801987:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80198e:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801995:	eb 57                	jmp    8019ee <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80199a:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  8019a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019a4:	39 c2                	cmp    %eax,%edx
  8019a6:	77 1a                	ja     8019c2 <malloc+0x2c4>
  8019a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019ab:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8019b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019b5:	39 c2                	cmp    %eax,%edx
  8019b7:	76 09                	jbe    8019c2 <malloc+0x2c4>
								flag=1;
  8019b9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8019c0:	eb 36                	jmp    8019f8 <malloc+0x2fa>
			arr[i].space++;
  8019c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8019c5:	89 d0                	mov    %edx,%eax
  8019c7:	01 c0                	add    %eax,%eax
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	c1 e0 02             	shl    $0x2,%eax
  8019ce:	05 28 41 80 00       	add    $0x804128,%eax
  8019d3:	8b 00                	mov    (%eax),%eax
  8019d5:	8d 48 01             	lea    0x1(%eax),%ecx
  8019d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8019db:	89 d0                	mov    %edx,%eax
  8019dd:	01 c0                	add    %eax,%eax
  8019df:	01 d0                	add    %edx,%eax
  8019e1:	c1 e0 02             	shl    $0x2,%eax
  8019e4:	05 28 41 80 00       	add    $0x804128,%eax
  8019e9:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8019eb:	ff 45 c0             	incl   -0x40(%ebp)
  8019ee:	a1 28 40 80 00       	mov    0x804028,%eax
  8019f3:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8019f6:	7c 9f                	jl     801997 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8019f8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8019fc:	75 19                	jne    801a17 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8019fe:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801a05:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801a08:	a1 04 40 80 00       	mov    0x804004,%eax
  801a0d:	39 c2                	cmp    %eax,%edx
  801a0f:	0f 82 72 ff ff ff    	jb     801987 <malloc+0x289>
  801a15:	eb 01                	jmp    801a18 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801a17:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801a18:	ff 45 cc             	incl   -0x34(%ebp)
  801a1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a1e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a21:	0f 8c 48 ff ff ff    	jl     80196f <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801a27:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801a2e:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801a35:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801a3c:	eb 37                	jmp    801a75 <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801a3e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801a41:	89 d0                	mov    %edx,%eax
  801a43:	01 c0                	add    %eax,%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	c1 e0 02             	shl    $0x2,%eax
  801a4a:	05 28 41 80 00       	add    $0x804128,%eax
  801a4f:	8b 00                	mov    (%eax),%eax
  801a51:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801a54:	7d 1c                	jge    801a72 <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801a56:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801a59:	89 d0                	mov    %edx,%eax
  801a5b:	01 c0                	add    %eax,%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	c1 e0 02             	shl    $0x2,%eax
  801a62:	05 28 41 80 00       	add    $0x804128,%eax
  801a67:	8b 00                	mov    (%eax),%eax
  801a69:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801a6c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801a6f:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801a72:	ff 45 b4             	incl   -0x4c(%ebp)
  801a75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801a78:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a7b:	7c c1                	jl     801a3e <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801a7d:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801a83:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801a86:	89 c8                	mov    %ecx,%eax
  801a88:	01 c0                	add    %eax,%eax
  801a8a:	01 c8                	add    %ecx,%eax
  801a8c:	c1 e0 02             	shl    $0x2,%eax
  801a8f:	05 20 41 80 00       	add    $0x804120,%eax
  801a94:	8b 00                	mov    (%eax),%eax
  801a96:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801a9d:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801aa3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801aa6:	89 c8                	mov    %ecx,%eax
  801aa8:	01 c0                	add    %eax,%eax
  801aaa:	01 c8                	add    %ecx,%eax
  801aac:	c1 e0 02             	shl    $0x2,%eax
  801aaf:	05 24 41 80 00       	add    $0x804124,%eax
  801ab4:	8b 00                	mov    (%eax),%eax
  801ab6:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801abd:	a1 28 40 80 00       	mov    0x804028,%eax
  801ac2:	40                   	inc    %eax
  801ac3:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  801ac8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801acb:	89 d0                	mov    %edx,%eax
  801acd:	01 c0                	add    %eax,%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	c1 e0 02             	shl    $0x2,%eax
  801ad4:	05 20 41 80 00       	add    $0x804120,%eax
  801ad9:	8b 00                	mov    (%eax),%eax
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	50                   	push   %eax
  801ae2:	e8 48 04 00 00       	call   801f2f <sys_allocateMem>
  801ae7:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801aea:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801af1:	eb 78                	jmp    801b6b <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801af3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801af6:	89 d0                	mov    %edx,%eax
  801af8:	01 c0                	add    %eax,%eax
  801afa:	01 d0                	add    %edx,%eax
  801afc:	c1 e0 02             	shl    $0x2,%eax
  801aff:	05 20 41 80 00       	add    $0x804120,%eax
  801b04:	8b 00                	mov    (%eax),%eax
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	50                   	push   %eax
  801b0a:	ff 75 b0             	pushl  -0x50(%ebp)
  801b0d:	68 f0 2f 80 00       	push   $0x802ff0
  801b12:	e8 5d ee ff ff       	call   800974 <cprintf>
  801b17:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801b1a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	01 c0                	add    %eax,%eax
  801b21:	01 d0                	add    %edx,%eax
  801b23:	c1 e0 02             	shl    $0x2,%eax
  801b26:	05 24 41 80 00       	add    $0x804124,%eax
  801b2b:	8b 00                	mov    (%eax),%eax
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	50                   	push   %eax
  801b31:	ff 75 b0             	pushl  -0x50(%ebp)
  801b34:	68 05 30 80 00       	push   $0x803005
  801b39:	e8 36 ee ff ff       	call   800974 <cprintf>
  801b3e:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801b41:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b44:	89 d0                	mov    %edx,%eax
  801b46:	01 c0                	add    %eax,%eax
  801b48:	01 d0                	add    %edx,%eax
  801b4a:	c1 e0 02             	shl    $0x2,%eax
  801b4d:	05 28 41 80 00       	add    $0x804128,%eax
  801b52:	8b 00                	mov    (%eax),%eax
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	50                   	push   %eax
  801b58:	ff 75 b0             	pushl  -0x50(%ebp)
  801b5b:	68 18 30 80 00       	push   $0x803018
  801b60:	e8 0f ee ff ff       	call   800974 <cprintf>
  801b65:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801b68:	ff 45 b0             	incl   -0x50(%ebp)
  801b6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801b6e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b71:	7c 80                	jl     801af3 <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801b73:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801b76:	89 d0                	mov    %edx,%eax
  801b78:	01 c0                	add    %eax,%eax
  801b7a:	01 d0                	add    %edx,%eax
  801b7c:	c1 e0 02             	shl    $0x2,%eax
  801b7f:	05 20 41 80 00       	add    $0x804120,%eax
  801b84:	8b 00                	mov    (%eax),%eax
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	50                   	push   %eax
  801b8a:	68 2c 30 80 00       	push   $0x80302c
  801b8f:	e8 e0 ed ff ff       	call   800974 <cprintf>
  801b94:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801b97:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801b9a:	89 d0                	mov    %edx,%eax
  801b9c:	01 c0                	add    %eax,%eax
  801b9e:	01 d0                	add    %edx,%eax
  801ba0:	c1 e0 02             	shl    $0x2,%eax
  801ba3:	05 20 41 80 00       	add    $0x804120,%eax
  801ba8:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801bb8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801bbf:	eb 4b                	jmp    801c0c <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc4:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801bcb:	89 c2                	mov    %eax,%edx
  801bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd0:	39 c2                	cmp    %eax,%edx
  801bd2:	7f 35                	jg     801c09 <free+0x5d>
  801bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd7:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801bde:	89 c2                	mov    %eax,%edx
  801be0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be3:	39 c2                	cmp    %eax,%edx
  801be5:	7e 22                	jle    801c09 <free+0x5d>
				start=arr_add[i].start;
  801be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bea:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf7:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801bfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801c07:	eb 0d                	jmp    801c16 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801c09:	ff 45 ec             	incl   -0x14(%ebp)
  801c0c:	a1 28 40 80 00       	mov    0x804028,%eax
  801c11:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801c14:	7c ab                	jl     801bc1 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c19:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c23:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801c2a:	29 c2                	sub    %eax,%edx
  801c2c:	89 d0                	mov    %edx,%eax
  801c2e:	83 ec 08             	sub    $0x8,%esp
  801c31:	50                   	push   %eax
  801c32:	ff 75 f4             	pushl  -0xc(%ebp)
  801c35:	e8 d9 02 00 00       	call   801f13 <sys_freeMem>
  801c3a:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c43:	eb 2d                	jmp    801c72 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c48:	40                   	inc    %eax
  801c49:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c53:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c5d:	40                   	inc    %eax
  801c5e:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c68:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801c6f:	ff 45 e8             	incl   -0x18(%ebp)
  801c72:	a1 28 40 80 00       	mov    0x804028,%eax
  801c77:	48                   	dec    %eax
  801c78:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c7b:	7f c8                	jg     801c45 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801c7d:	a1 28 40 80 00       	mov    0x804028,%eax
  801c82:	48                   	dec    %eax
  801c83:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801c88:	90                   	nop
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 18             	sub    $0x18,%esp
  801c91:	8b 45 10             	mov    0x10(%ebp),%eax
  801c94:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	68 48 30 80 00       	push   $0x803048
  801c9f:	68 18 01 00 00       	push   $0x118
  801ca4:	68 6b 30 80 00       	push   $0x80306b
  801ca9:	e8 24 ea ff ff       	call   8006d2 <_panic>

00801cae <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	68 48 30 80 00       	push   $0x803048
  801cbc:	68 1e 01 00 00       	push   $0x11e
  801cc1:	68 6b 30 80 00       	push   $0x80306b
  801cc6:	e8 07 ea ff ff       	call   8006d2 <_panic>

00801ccb <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	68 48 30 80 00       	push   $0x803048
  801cd9:	68 24 01 00 00       	push   $0x124
  801cde:	68 6b 30 80 00       	push   $0x80306b
  801ce3:	e8 ea e9 ff ff       	call   8006d2 <_panic>

00801ce8 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	68 48 30 80 00       	push   $0x803048
  801cf6:	68 29 01 00 00       	push   $0x129
  801cfb:	68 6b 30 80 00       	push   $0x80306b
  801d00:	e8 cd e9 ff ff       	call   8006d2 <_panic>

00801d05 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d0b:	83 ec 04             	sub    $0x4,%esp
  801d0e:	68 48 30 80 00       	push   $0x803048
  801d13:	68 2f 01 00 00       	push   $0x12f
  801d18:	68 6b 30 80 00       	push   $0x80306b
  801d1d:	e8 b0 e9 ff ff       	call   8006d2 <_panic>

00801d22 <shrink>:
}
void shrink(uint32 newSize)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d28:	83 ec 04             	sub    $0x4,%esp
  801d2b:	68 48 30 80 00       	push   $0x803048
  801d30:	68 33 01 00 00       	push   $0x133
  801d35:	68 6b 30 80 00       	push   $0x80306b
  801d3a:	e8 93 e9 ff ff       	call   8006d2 <_panic>

00801d3f <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	68 48 30 80 00       	push   $0x803048
  801d4d:	68 38 01 00 00       	push   $0x138
  801d52:	68 6b 30 80 00       	push   $0x80306b
  801d57:	e8 76 e9 ff ff       	call   8006d2 <_panic>

00801d5c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	57                   	push   %edi
  801d60:	56                   	push   %esi
  801d61:	53                   	push   %ebx
  801d62:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d71:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d74:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d77:	cd 30                	int    $0x30
  801d79:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	5b                   	pop    %ebx
  801d83:	5e                   	pop    %esi
  801d84:	5f                   	pop    %edi
  801d85:	5d                   	pop    %ebp
  801d86:	c3                   	ret    

00801d87 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d90:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d93:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	52                   	push   %edx
  801d9f:	ff 75 0c             	pushl  0xc(%ebp)
  801da2:	50                   	push   %eax
  801da3:	6a 00                	push   $0x0
  801da5:	e8 b2 ff ff ff       	call   801d5c <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	90                   	nop
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 01                	push   $0x1
  801dbf:	e8 98 ff ff ff       	call   801d5c <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	50                   	push   %eax
  801dd8:	6a 05                	push   $0x5
  801dda:	e8 7d ff ff ff       	call   801d5c <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 02                	push   $0x2
  801df3:	e8 64 ff ff ff       	call   801d5c <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 03                	push   $0x3
  801e0c:	e8 4b ff ff ff       	call   801d5c <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 04                	push   $0x4
  801e25:	e8 32 ff ff ff       	call   801d5c <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_env_exit>:


void sys_env_exit(void)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 06                	push   $0x6
  801e3e:	e8 19 ff ff ff       	call   801d5c <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
}
  801e46:	90                   	nop
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	52                   	push   %edx
  801e59:	50                   	push   %eax
  801e5a:	6a 07                	push   $0x7
  801e5c:	e8 fb fe ff ff       	call   801d5c <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	56                   	push   %esi
  801e6a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e6b:	8b 75 18             	mov    0x18(%ebp),%esi
  801e6e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e71:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	56                   	push   %esi
  801e7b:	53                   	push   %ebx
  801e7c:	51                   	push   %ecx
  801e7d:	52                   	push   %edx
  801e7e:	50                   	push   %eax
  801e7f:	6a 08                	push   $0x8
  801e81:	e8 d6 fe ff ff       	call   801d5c <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8c:	5b                   	pop    %ebx
  801e8d:	5e                   	pop    %esi
  801e8e:	5d                   	pop    %ebp
  801e8f:	c3                   	ret    

00801e90 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	52                   	push   %edx
  801ea0:	50                   	push   %eax
  801ea1:	6a 09                	push   $0x9
  801ea3:	e8 b4 fe ff ff       	call   801d5c <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	ff 75 08             	pushl  0x8(%ebp)
  801ebc:	6a 0a                	push   $0xa
  801ebe:	e8 99 fe ff ff       	call   801d5c <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 0b                	push   $0xb
  801ed7:	e8 80 fe ff ff       	call   801d5c <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 0c                	push   $0xc
  801ef0:	e8 67 fe ff ff       	call   801d5c <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 0d                	push   $0xd
  801f09:	e8 4e fe ff ff       	call   801d5c <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	ff 75 08             	pushl  0x8(%ebp)
  801f22:	6a 11                	push   $0x11
  801f24:	e8 33 fe ff ff       	call   801d5c <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
	return;
  801f2c:	90                   	nop
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	ff 75 0c             	pushl  0xc(%ebp)
  801f3b:	ff 75 08             	pushl  0x8(%ebp)
  801f3e:	6a 12                	push   $0x12
  801f40:	e8 17 fe ff ff       	call   801d5c <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
	return ;
  801f48:	90                   	nop
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 0e                	push   $0xe
  801f5a:	e8 fd fd ff ff       	call   801d5c <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	6a 0f                	push   $0xf
  801f74:	e8 e3 fd ff ff       	call   801d5c <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 10                	push   $0x10
  801f8d:	e8 ca fd ff ff       	call   801d5c <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	90                   	nop
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 14                	push   $0x14
  801fa7:	e8 b0 fd ff ff       	call   801d5c <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	90                   	nop
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 15                	push   $0x15
  801fc1:	e8 96 fd ff ff       	call   801d5c <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	90                   	nop
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_cputc>:


void
sys_cputc(const char c)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fd8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	50                   	push   %eax
  801fe5:	6a 16                	push   $0x16
  801fe7:	e8 70 fd ff ff       	call   801d5c <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
}
  801fef:	90                   	nop
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 17                	push   $0x17
  802001:	e8 56 fd ff ff       	call   801d5c <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	90                   	nop
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	50                   	push   %eax
  80201c:	6a 18                	push   $0x18
  80201e:	e8 39 fd ff ff       	call   801d5c <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	52                   	push   %edx
  802038:	50                   	push   %eax
  802039:	6a 1b                	push   $0x1b
  80203b:	e8 1c fd ff ff       	call   801d5c <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802048:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	52                   	push   %edx
  802055:	50                   	push   %eax
  802056:	6a 19                	push   $0x19
  802058:	e8 ff fc ff ff       	call   801d5c <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	90                   	nop
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802066:	8b 55 0c             	mov    0xc(%ebp),%edx
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	52                   	push   %edx
  802073:	50                   	push   %eax
  802074:	6a 1a                	push   $0x1a
  802076:	e8 e1 fc ff ff       	call   801d5c <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	8b 45 10             	mov    0x10(%ebp),%eax
  80208a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80208d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802090:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	6a 00                	push   $0x0
  802099:	51                   	push   %ecx
  80209a:	52                   	push   %edx
  80209b:	ff 75 0c             	pushl  0xc(%ebp)
  80209e:	50                   	push   %eax
  80209f:	6a 1c                	push   $0x1c
  8020a1:	e8 b6 fc ff ff       	call   801d5c <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	52                   	push   %edx
  8020bb:	50                   	push   %eax
  8020bc:	6a 1d                	push   $0x1d
  8020be:	e8 99 fc ff ff       	call   801d5c <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	51                   	push   %ecx
  8020d9:	52                   	push   %edx
  8020da:	50                   	push   %eax
  8020db:	6a 1e                	push   $0x1e
  8020dd:	e8 7a fc ff ff       	call   801d5c <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	52                   	push   %edx
  8020f7:	50                   	push   %eax
  8020f8:	6a 1f                	push   $0x1f
  8020fa:	e8 5d fc ff ff       	call   801d5c <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 20                	push   $0x20
  802113:	e8 44 fc ff ff       	call   801d5c <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	ff 75 14             	pushl  0x14(%ebp)
  802128:	ff 75 10             	pushl  0x10(%ebp)
  80212b:	ff 75 0c             	pushl  0xc(%ebp)
  80212e:	50                   	push   %eax
  80212f:	6a 21                	push   $0x21
  802131:	e8 26 fc ff ff       	call   801d5c <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	50                   	push   %eax
  80214a:	6a 22                	push   $0x22
  80214c:	e8 0b fc ff ff       	call   801d5c <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	90                   	nop
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	50                   	push   %eax
  802166:	6a 23                	push   $0x23
  802168:	e8 ef fb ff ff       	call   801d5c <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	90                   	nop
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802179:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80217c:	8d 50 04             	lea    0x4(%eax),%edx
  80217f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	52                   	push   %edx
  802189:	50                   	push   %eax
  80218a:	6a 24                	push   $0x24
  80218c:	e8 cb fb ff ff       	call   801d5c <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
	return result;
  802194:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80219a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80219d:	89 01                	mov    %eax,(%ecx)
  80219f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	c9                   	leave  
  8021a6:	c2 04 00             	ret    $0x4

008021a9 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	ff 75 10             	pushl  0x10(%ebp)
  8021b3:	ff 75 0c             	pushl  0xc(%ebp)
  8021b6:	ff 75 08             	pushl  0x8(%ebp)
  8021b9:	6a 13                	push   $0x13
  8021bb:	e8 9c fb ff ff       	call   801d5c <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c3:	90                   	nop
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 25                	push   $0x25
  8021d5:	e8 82 fb ff ff       	call   801d5c <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021eb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	50                   	push   %eax
  8021f8:	6a 26                	push   $0x26
  8021fa:	e8 5d fb ff ff       	call   801d5c <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802202:	90                   	nop
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <rsttst>:
void rsttst()
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 28                	push   $0x28
  802214:	e8 43 fb ff ff       	call   801d5c <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
	return ;
  80221c:	90                   	nop
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	8b 45 14             	mov    0x14(%ebp),%eax
  802228:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80222b:	8b 55 18             	mov    0x18(%ebp),%edx
  80222e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802232:	52                   	push   %edx
  802233:	50                   	push   %eax
  802234:	ff 75 10             	pushl  0x10(%ebp)
  802237:	ff 75 0c             	pushl  0xc(%ebp)
  80223a:	ff 75 08             	pushl  0x8(%ebp)
  80223d:	6a 27                	push   $0x27
  80223f:	e8 18 fb ff ff       	call   801d5c <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
	return ;
  802247:	90                   	nop
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <chktst>:
void chktst(uint32 n)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	ff 75 08             	pushl  0x8(%ebp)
  802258:	6a 29                	push   $0x29
  80225a:	e8 fd fa ff ff       	call   801d5c <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
	return ;
  802262:	90                   	nop
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <inctst>:

void inctst()
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 2a                	push   $0x2a
  802274:	e8 e3 fa ff ff       	call   801d5c <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
	return ;
  80227c:	90                   	nop
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <gettst>:
uint32 gettst()
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 2b                	push   $0x2b
  80228e:	e8 c9 fa ff ff       	call   801d5c <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 2c                	push   $0x2c
  8022aa:	e8 ad fa ff ff       	call   801d5c <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
  8022b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022b5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022b9:	75 07                	jne    8022c2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c0:	eb 05                	jmp    8022c7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 2c                	push   $0x2c
  8022db:	e8 7c fa ff ff       	call   801d5c <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
  8022e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022e6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022ea:	75 07                	jne    8022f3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f1:	eb 05                	jmp    8022f8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 2c                	push   $0x2c
  80230c:	e8 4b fa ff ff       	call   801d5c <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
  802314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802317:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80231b:	75 07                	jne    802324 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80231d:	b8 01 00 00 00       	mov    $0x1,%eax
  802322:	eb 05                	jmp    802329 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802324:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 2c                	push   $0x2c
  80233d:	e8 1a fa ff ff       	call   801d5c <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
  802345:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802348:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80234c:	75 07                	jne    802355 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	eb 05                	jmp    80235a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	ff 75 08             	pushl  0x8(%ebp)
  80236a:	6a 2d                	push   $0x2d
  80236c:	e8 eb f9 ff ff       	call   801d5c <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
	return ;
  802374:	90                   	nop
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80237b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80237e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802381:	8b 55 0c             	mov    0xc(%ebp),%edx
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	6a 00                	push   $0x0
  802389:	53                   	push   %ebx
  80238a:	51                   	push   %ecx
  80238b:	52                   	push   %edx
  80238c:	50                   	push   %eax
  80238d:	6a 2e                	push   $0x2e
  80238f:	e8 c8 f9 ff ff       	call   801d5c <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80239f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	52                   	push   %edx
  8023ac:	50                   	push   %eax
  8023ad:	6a 2f                	push   $0x2f
  8023af:	e8 a8 f9 ff ff       	call   801d5c <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    
  8023b9:	66 90                	xchg   %ax,%ax
  8023bb:	90                   	nop

008023bc <__udivdi3>:
  8023bc:	55                   	push   %ebp
  8023bd:	57                   	push   %edi
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 1c             	sub    $0x1c,%esp
  8023c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8023c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8023cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d3:	89 ca                	mov    %ecx,%edx
  8023d5:	89 f8                	mov    %edi,%eax
  8023d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023db:	85 f6                	test   %esi,%esi
  8023dd:	75 2d                	jne    80240c <__udivdi3+0x50>
  8023df:	39 cf                	cmp    %ecx,%edi
  8023e1:	77 65                	ja     802448 <__udivdi3+0x8c>
  8023e3:	89 fd                	mov    %edi,%ebp
  8023e5:	85 ff                	test   %edi,%edi
  8023e7:	75 0b                	jne    8023f4 <__udivdi3+0x38>
  8023e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ee:	31 d2                	xor    %edx,%edx
  8023f0:	f7 f7                	div    %edi
  8023f2:	89 c5                	mov    %eax,%ebp
  8023f4:	31 d2                	xor    %edx,%edx
  8023f6:	89 c8                	mov    %ecx,%eax
  8023f8:	f7 f5                	div    %ebp
  8023fa:	89 c1                	mov    %eax,%ecx
  8023fc:	89 d8                	mov    %ebx,%eax
  8023fe:	f7 f5                	div    %ebp
  802400:	89 cf                	mov    %ecx,%edi
  802402:	89 fa                	mov    %edi,%edx
  802404:	83 c4 1c             	add    $0x1c,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    
  80240c:	39 ce                	cmp    %ecx,%esi
  80240e:	77 28                	ja     802438 <__udivdi3+0x7c>
  802410:	0f bd fe             	bsr    %esi,%edi
  802413:	83 f7 1f             	xor    $0x1f,%edi
  802416:	75 40                	jne    802458 <__udivdi3+0x9c>
  802418:	39 ce                	cmp    %ecx,%esi
  80241a:	72 0a                	jb     802426 <__udivdi3+0x6a>
  80241c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802420:	0f 87 9e 00 00 00    	ja     8024c4 <__udivdi3+0x108>
  802426:	b8 01 00 00 00       	mov    $0x1,%eax
  80242b:	89 fa                	mov    %edi,%edx
  80242d:	83 c4 1c             	add    $0x1c,%esp
  802430:	5b                   	pop    %ebx
  802431:	5e                   	pop    %esi
  802432:	5f                   	pop    %edi
  802433:	5d                   	pop    %ebp
  802434:	c3                   	ret    
  802435:	8d 76 00             	lea    0x0(%esi),%esi
  802438:	31 ff                	xor    %edi,%edi
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	89 fa                	mov    %edi,%edx
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	66 90                	xchg   %ax,%ax
  802448:	89 d8                	mov    %ebx,%eax
  80244a:	f7 f7                	div    %edi
  80244c:	31 ff                	xor    %edi,%edi
  80244e:	89 fa                	mov    %edi,%edx
  802450:	83 c4 1c             	add    $0x1c,%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5f                   	pop    %edi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    
  802458:	bd 20 00 00 00       	mov    $0x20,%ebp
  80245d:	89 eb                	mov    %ebp,%ebx
  80245f:	29 fb                	sub    %edi,%ebx
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e6                	shl    %cl,%esi
  802465:	89 c5                	mov    %eax,%ebp
  802467:	88 d9                	mov    %bl,%cl
  802469:	d3 ed                	shr    %cl,%ebp
  80246b:	89 e9                	mov    %ebp,%ecx
  80246d:	09 f1                	or     %esi,%ecx
  80246f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802473:	89 f9                	mov    %edi,%ecx
  802475:	d3 e0                	shl    %cl,%eax
  802477:	89 c5                	mov    %eax,%ebp
  802479:	89 d6                	mov    %edx,%esi
  80247b:	88 d9                	mov    %bl,%cl
  80247d:	d3 ee                	shr    %cl,%esi
  80247f:	89 f9                	mov    %edi,%ecx
  802481:	d3 e2                	shl    %cl,%edx
  802483:	8b 44 24 08          	mov    0x8(%esp),%eax
  802487:	88 d9                	mov    %bl,%cl
  802489:	d3 e8                	shr    %cl,%eax
  80248b:	09 c2                	or     %eax,%edx
  80248d:	89 d0                	mov    %edx,%eax
  80248f:	89 f2                	mov    %esi,%edx
  802491:	f7 74 24 0c          	divl   0xc(%esp)
  802495:	89 d6                	mov    %edx,%esi
  802497:	89 c3                	mov    %eax,%ebx
  802499:	f7 e5                	mul    %ebp
  80249b:	39 d6                	cmp    %edx,%esi
  80249d:	72 19                	jb     8024b8 <__udivdi3+0xfc>
  80249f:	74 0b                	je     8024ac <__udivdi3+0xf0>
  8024a1:	89 d8                	mov    %ebx,%eax
  8024a3:	31 ff                	xor    %edi,%edi
  8024a5:	e9 58 ff ff ff       	jmp    802402 <__udivdi3+0x46>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024b0:	89 f9                	mov    %edi,%ecx
  8024b2:	d3 e2                	shl    %cl,%edx
  8024b4:	39 c2                	cmp    %eax,%edx
  8024b6:	73 e9                	jae    8024a1 <__udivdi3+0xe5>
  8024b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024bb:	31 ff                	xor    %edi,%edi
  8024bd:	e9 40 ff ff ff       	jmp    802402 <__udivdi3+0x46>
  8024c2:	66 90                	xchg   %ax,%ax
  8024c4:	31 c0                	xor    %eax,%eax
  8024c6:	e9 37 ff ff ff       	jmp    802402 <__udivdi3+0x46>
  8024cb:	90                   	nop

008024cc <__umoddi3>:
  8024cc:	55                   	push   %ebp
  8024cd:	57                   	push   %edi
  8024ce:	56                   	push   %esi
  8024cf:	53                   	push   %ebx
  8024d0:	83 ec 1c             	sub    $0x1c,%esp
  8024d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024eb:	89 f3                	mov    %esi,%ebx
  8024ed:	89 fa                	mov    %edi,%edx
  8024ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024f3:	89 34 24             	mov    %esi,(%esp)
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	75 1a                	jne    802514 <__umoddi3+0x48>
  8024fa:	39 f7                	cmp    %esi,%edi
  8024fc:	0f 86 a2 00 00 00    	jbe    8025a4 <__umoddi3+0xd8>
  802502:	89 c8                	mov    %ecx,%eax
  802504:	89 f2                	mov    %esi,%edx
  802506:	f7 f7                	div    %edi
  802508:	89 d0                	mov    %edx,%eax
  80250a:	31 d2                	xor    %edx,%edx
  80250c:	83 c4 1c             	add    $0x1c,%esp
  80250f:	5b                   	pop    %ebx
  802510:	5e                   	pop    %esi
  802511:	5f                   	pop    %edi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    
  802514:	39 f0                	cmp    %esi,%eax
  802516:	0f 87 ac 00 00 00    	ja     8025c8 <__umoddi3+0xfc>
  80251c:	0f bd e8             	bsr    %eax,%ebp
  80251f:	83 f5 1f             	xor    $0x1f,%ebp
  802522:	0f 84 ac 00 00 00    	je     8025d4 <__umoddi3+0x108>
  802528:	bf 20 00 00 00       	mov    $0x20,%edi
  80252d:	29 ef                	sub    %ebp,%edi
  80252f:	89 fe                	mov    %edi,%esi
  802531:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802535:	89 e9                	mov    %ebp,%ecx
  802537:	d3 e0                	shl    %cl,%eax
  802539:	89 d7                	mov    %edx,%edi
  80253b:	89 f1                	mov    %esi,%ecx
  80253d:	d3 ef                	shr    %cl,%edi
  80253f:	09 c7                	or     %eax,%edi
  802541:	89 e9                	mov    %ebp,%ecx
  802543:	d3 e2                	shl    %cl,%edx
  802545:	89 14 24             	mov    %edx,(%esp)
  802548:	89 d8                	mov    %ebx,%eax
  80254a:	d3 e0                	shl    %cl,%eax
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802552:	d3 e0                	shl    %cl,%eax
  802554:	89 44 24 04          	mov    %eax,0x4(%esp)
  802558:	8b 44 24 08          	mov    0x8(%esp),%eax
  80255c:	89 f1                	mov    %esi,%ecx
  80255e:	d3 e8                	shr    %cl,%eax
  802560:	09 d0                	or     %edx,%eax
  802562:	d3 eb                	shr    %cl,%ebx
  802564:	89 da                	mov    %ebx,%edx
  802566:	f7 f7                	div    %edi
  802568:	89 d3                	mov    %edx,%ebx
  80256a:	f7 24 24             	mull   (%esp)
  80256d:	89 c6                	mov    %eax,%esi
  80256f:	89 d1                	mov    %edx,%ecx
  802571:	39 d3                	cmp    %edx,%ebx
  802573:	0f 82 87 00 00 00    	jb     802600 <__umoddi3+0x134>
  802579:	0f 84 91 00 00 00    	je     802610 <__umoddi3+0x144>
  80257f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802583:	29 f2                	sub    %esi,%edx
  802585:	19 cb                	sbb    %ecx,%ebx
  802587:	89 d8                	mov    %ebx,%eax
  802589:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80258d:	d3 e0                	shl    %cl,%eax
  80258f:	89 e9                	mov    %ebp,%ecx
  802591:	d3 ea                	shr    %cl,%edx
  802593:	09 d0                	or     %edx,%eax
  802595:	89 e9                	mov    %ebp,%ecx
  802597:	d3 eb                	shr    %cl,%ebx
  802599:	89 da                	mov    %ebx,%edx
  80259b:	83 c4 1c             	add    $0x1c,%esp
  80259e:	5b                   	pop    %ebx
  80259f:	5e                   	pop    %esi
  8025a0:	5f                   	pop    %edi
  8025a1:	5d                   	pop    %ebp
  8025a2:	c3                   	ret    
  8025a3:	90                   	nop
  8025a4:	89 fd                	mov    %edi,%ebp
  8025a6:	85 ff                	test   %edi,%edi
  8025a8:	75 0b                	jne    8025b5 <__umoddi3+0xe9>
  8025aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025af:	31 d2                	xor    %edx,%edx
  8025b1:	f7 f7                	div    %edi
  8025b3:	89 c5                	mov    %eax,%ebp
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	31 d2                	xor    %edx,%edx
  8025b9:	f7 f5                	div    %ebp
  8025bb:	89 c8                	mov    %ecx,%eax
  8025bd:	f7 f5                	div    %ebp
  8025bf:	89 d0                	mov    %edx,%eax
  8025c1:	e9 44 ff ff ff       	jmp    80250a <__umoddi3+0x3e>
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	89 c8                	mov    %ecx,%eax
  8025ca:	89 f2                	mov    %esi,%edx
  8025cc:	83 c4 1c             	add    $0x1c,%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    
  8025d4:	3b 04 24             	cmp    (%esp),%eax
  8025d7:	72 06                	jb     8025df <__umoddi3+0x113>
  8025d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025dd:	77 0f                	ja     8025ee <__umoddi3+0x122>
  8025df:	89 f2                	mov    %esi,%edx
  8025e1:	29 f9                	sub    %edi,%ecx
  8025e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025e7:	89 14 24             	mov    %edx,(%esp)
  8025ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025f2:	8b 14 24             	mov    (%esp),%edx
  8025f5:	83 c4 1c             	add    $0x1c,%esp
  8025f8:	5b                   	pop    %ebx
  8025f9:	5e                   	pop    %esi
  8025fa:	5f                   	pop    %edi
  8025fb:	5d                   	pop    %ebp
  8025fc:	c3                   	ret    
  8025fd:	8d 76 00             	lea    0x0(%esi),%esi
  802600:	2b 04 24             	sub    (%esp),%eax
  802603:	19 fa                	sbb    %edi,%edx
  802605:	89 d1                	mov    %edx,%ecx
  802607:	89 c6                	mov    %eax,%esi
  802609:	e9 71 ff ff ff       	jmp    80257f <__umoddi3+0xb3>
  80260e:	66 90                	xchg   %ax,%ax
  802610:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802614:	72 ea                	jb     802600 <__umoddi3+0x134>
  802616:	89 d9                	mov    %ebx,%ecx
  802618:	e9 62 ff ff ff       	jmp    80257f <__umoddi3+0xb3>
