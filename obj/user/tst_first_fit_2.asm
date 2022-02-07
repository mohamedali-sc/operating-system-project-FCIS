
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 bd 06 00 00       	call   8006f3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 78 24 00 00       	call   8024c2 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 23                	jmp    80007d <_main+0x45>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 30 80 00       	mov    0x803020,%eax
  80005f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	c1 e2 04             	shl    $0x4,%edx
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8a 40 04             	mov    0x4(%eax),%al
  800070:	84 c0                	test   %al,%al
  800072:	74 06                	je     80007a <_main+0x42>
			{
				fullWS = 0;
  800074:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800078:	eb 12                	jmp    80008c <_main+0x54>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 30 80 00       	mov    0x803020,%eax
  800082:	8b 50 74             	mov    0x74(%eax),%edx
  800085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800088:	39 c2                	cmp    %eax,%edx
  80008a:	77 ce                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80008c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800090:	74 14                	je     8000a6 <_main+0x6e>
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	68 a0 27 80 00       	push   $0x8027a0
  80009a:	6a 1b                	push   $0x1b
  80009c:	68 bc 27 80 00       	push   $0x8027bc
  8000a1:	e8 92 07 00 00       	call   800838 <_panic>
	}


	int Mega = 1024*1024;
  8000a6:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000ad:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000b4:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000b7:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	89 d7                	mov    %edx,%edi
  8000c3:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000c5:	83 ec 0c             	sub    $0xc,%esp
  8000c8:	68 01 00 00 20       	push   $0x20000001
  8000cd:	e8 92 17 00 00       	call   801864 <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000d8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 d4 27 80 00       	push   $0x8027d4
  8000e7:	6a 26                	push   $0x26
  8000e9:	68 bc 27 80 00       	push   $0x8027bc
  8000ee:	e8 45 07 00 00       	call   800838 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  8000f3:	e8 36 1f 00 00       	call   80202e <sys_calculate_free_frames>
  8000f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000fb:	e8 b1 1f 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800100:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 50 17 00 00       	call   801864 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80011a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80011d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 18 28 80 00       	push   $0x802818
  80012c:	6a 2f                	push   $0x2f
  80012e:	68 bc 27 80 00       	push   $0x8027bc
  800133:	e8 00 07 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800138:	e8 74 1f 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  80013d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800140:	3d 00 02 00 00       	cmp    $0x200,%eax
  800145:	74 14                	je     80015b <_main+0x123>
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 48 28 80 00       	push   $0x802848
  80014f:	6a 31                	push   $0x31
  800151:	68 bc 27 80 00       	push   $0x8027bc
  800156:	e8 dd 06 00 00       	call   800838 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80015b:	e8 ce 1e 00 00       	call   80202e <sys_calculate_free_frames>
  800160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800163:	e8 49 1f 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800168:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	01 c0                	add    %eax,%eax
  800170:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	50                   	push   %eax
  800177:	e8 e8 16 00 00       	call   801864 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800182:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800185:	89 c2                	mov    %eax,%edx
  800187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018a:	01 c0                	add    %eax,%eax
  80018c:	05 00 00 00 80       	add    $0x80000000,%eax
  800191:	39 c2                	cmp    %eax,%edx
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 18 28 80 00       	push   $0x802818
  80019d:	6a 37                	push   $0x37
  80019f:	68 bc 27 80 00       	push   $0x8027bc
  8001a4:	e8 8f 06 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001a9:	e8 03 1f 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8001ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001b6:	74 14                	je     8001cc <_main+0x194>
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	68 48 28 80 00       	push   $0x802848
  8001c0:	6a 39                	push   $0x39
  8001c2:	68 bc 27 80 00       	push   $0x8027bc
  8001c7:	e8 6c 06 00 00       	call   800838 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001cc:	e8 5d 1e 00 00       	call   80202e <sys_calculate_free_frames>
  8001d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001d4:	e8 d8 1e 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	89 c2                	mov    %eax,%edx
  8001e1:	01 d2                	add    %edx,%edx
  8001e3:	01 d0                	add    %edx,%eax
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	50                   	push   %eax
  8001e9:	e8 76 16 00 00       	call   801864 <malloc>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001f4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001f7:	89 c2                	mov    %eax,%edx
  8001f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001fc:	c1 e0 02             	shl    $0x2,%eax
  8001ff:	05 00 00 00 80       	add    $0x80000000,%eax
  800204:	39 c2                	cmp    %eax,%edx
  800206:	74 14                	je     80021c <_main+0x1e4>
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	68 18 28 80 00       	push   $0x802818
  800210:	6a 3f                	push   $0x3f
  800212:	68 bc 27 80 00       	push   $0x8027bc
  800217:	e8 1c 06 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80021c:	e8 90 1e 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800221:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800224:	83 f8 01             	cmp    $0x1,%eax
  800227:	74 14                	je     80023d <_main+0x205>
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	68 48 28 80 00       	push   $0x802848
  800231:	6a 41                	push   $0x41
  800233:	68 bc 27 80 00       	push   $0x8027bc
  800238:	e8 fb 05 00 00       	call   800838 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  80023d:	e8 ec 1d 00 00       	call   80202e <sys_calculate_free_frames>
  800242:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800245:	e8 67 1e 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  80024a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  80024d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800250:	89 c2                	mov    %eax,%edx
  800252:	01 d2                	add    %edx,%edx
  800254:	01 d0                	add    %edx,%eax
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	e8 05 16 00 00       	call   801864 <malloc>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800265:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800268:	89 c2                	mov    %eax,%edx
  80026a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026d:	c1 e0 02             	shl    $0x2,%eax
  800270:	89 c1                	mov    %eax,%ecx
  800272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800275:	c1 e0 02             	shl    $0x2,%eax
  800278:	01 c8                	add    %ecx,%eax
  80027a:	05 00 00 00 80       	add    $0x80000000,%eax
  80027f:	39 c2                	cmp    %eax,%edx
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 18 28 80 00       	push   $0x802818
  80028b:	6a 47                	push   $0x47
  80028d:	68 bc 27 80 00       	push   $0x8027bc
  800292:	e8 a1 05 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  800297:	e8 15 1e 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  80029c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80029f:	83 f8 01             	cmp    $0x1,%eax
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 48 28 80 00       	push   $0x802848
  8002ac:	6a 49                	push   $0x49
  8002ae:	68 bc 27 80 00       	push   $0x8027bc
  8002b3:	e8 80 05 00 00       	call   800838 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002b8:	e8 71 1d 00 00       	call   80202e <sys_calculate_free_frames>
  8002bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c0:	e8 ec 1d 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8002c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002c8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	e8 3e 1a 00 00       	call   801d12 <free>
  8002d4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002d7:	e8 d5 1d 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8002dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002df:	29 c2                	sub    %eax,%edx
  8002e1:	89 d0                	mov    %edx,%eax
  8002e3:	83 f8 01             	cmp    $0x1,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 65 28 80 00       	push   $0x802865
  8002f0:	6a 50                	push   $0x50
  8002f2:	68 bc 27 80 00       	push   $0x8027bc
  8002f7:	e8 3c 05 00 00       	call   800838 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002fc:	e8 2d 1d 00 00       	call   80202e <sys_calculate_free_frames>
  800301:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800304:	e8 a8 1d 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800309:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80030c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030f:	89 d0                	mov    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	01 c0                	add    %eax,%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	50                   	push   %eax
  80031d:	e8 42 15 00 00       	call   801864 <malloc>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800328:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032b:	89 c2                	mov    %eax,%edx
  80032d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800330:	c1 e0 02             	shl    $0x2,%eax
  800333:	89 c1                	mov    %eax,%ecx
  800335:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800338:	c1 e0 03             	shl    $0x3,%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	05 00 00 00 80       	add    $0x80000000,%eax
  800342:	39 c2                	cmp    %eax,%edx
  800344:	74 14                	je     80035a <_main+0x322>
  800346:	83 ec 04             	sub    $0x4,%esp
  800349:	68 18 28 80 00       	push   $0x802818
  80034e:	6a 56                	push   $0x56
  800350:	68 bc 27 80 00       	push   $0x8027bc
  800355:	e8 de 04 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  80035a:	e8 52 1d 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  80035f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800362:	83 f8 02             	cmp    $0x2,%eax
  800365:	74 14                	je     80037b <_main+0x343>
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	68 48 28 80 00       	push   $0x802848
  80036f:	6a 58                	push   $0x58
  800371:	68 bc 27 80 00       	push   $0x8027bc
  800376:	e8 bd 04 00 00       	call   800838 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80037b:	e8 ae 1c 00 00       	call   80202e <sys_calculate_free_frames>
  800380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800383:	e8 29 1d 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800388:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  80038b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	50                   	push   %eax
  800392:	e8 7b 19 00 00       	call   801d12 <free>
  800397:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  80039a:	e8 12 1d 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  80039f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a2:	29 c2                	sub    %eax,%edx
  8003a4:	89 d0                	mov    %edx,%eax
  8003a6:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003ab:	74 14                	je     8003c1 <_main+0x389>
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 65 28 80 00       	push   $0x802865
  8003b5:	6a 5f                	push   $0x5f
  8003b7:	68 bc 27 80 00       	push   $0x8027bc
  8003bc:	e8 77 04 00 00       	call   800838 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003c1:	e8 68 1c 00 00       	call   80202e <sys_calculate_free_frames>
  8003c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c9:	e8 e3 1c 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8003ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	01 d2                	add    %edx,%edx
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003dd:	83 ec 0c             	sub    $0xc,%esp
  8003e0:	50                   	push   %eax
  8003e1:	e8 7e 14 00 00       	call   801864 <malloc>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003ec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003ef:	89 c2                	mov    %eax,%edx
  8003f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003f4:	c1 e0 02             	shl    $0x2,%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003fc:	c1 e0 04             	shl    $0x4,%eax
  8003ff:	01 c8                	add    %ecx,%eax
  800401:	05 00 00 00 80       	add    $0x80000000,%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 18 28 80 00       	push   $0x802818
  800412:	6a 65                	push   $0x65
  800414:	68 bc 27 80 00       	push   $0x8027bc
  800419:	e8 1a 04 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80041e:	e8 8e 1c 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800423:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800426:	89 c2                	mov    %eax,%edx
  800428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80042b:	89 c1                	mov    %eax,%ecx
  80042d:	01 c9                	add    %ecx,%ecx
  80042f:	01 c8                	add    %ecx,%eax
  800431:	85 c0                	test   %eax,%eax
  800433:	79 05                	jns    80043a <_main+0x402>
  800435:	05 ff 0f 00 00       	add    $0xfff,%eax
  80043a:	c1 f8 0c             	sar    $0xc,%eax
  80043d:	39 c2                	cmp    %eax,%edx
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 48 28 80 00       	push   $0x802848
  800449:	6a 67                	push   $0x67
  80044b:	68 bc 27 80 00       	push   $0x8027bc
  800450:	e8 e3 03 00 00       	call   800838 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800455:	e8 d4 1b 00 00       	call   80202e <sys_calculate_free_frames>
  80045a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80045d:	e8 4f 1c 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800462:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	89 c2                	mov    %eax,%edx
  80046a:	01 d2                	add    %edx,%edx
  80046c:	01 c2                	add    %eax,%edx
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 d0                	add    %edx,%eax
  800473:	01 c0                	add    %eax,%eax
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	50                   	push   %eax
  800479:	e8 e6 13 00 00       	call   801864 <malloc>
  80047e:	83 c4 10             	add    $0x10,%esp
  800481:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800484:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800487:	89 c1                	mov    %eax,%ecx
  800489:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80048c:	89 d0                	mov    %edx,%eax
  80048e:	01 c0                	add    %eax,%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	01 c0                	add    %eax,%eax
  800494:	01 d0                	add    %edx,%eax
  800496:	89 c2                	mov    %eax,%edx
  800498:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049b:	c1 e0 04             	shl    $0x4,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a5:	39 c1                	cmp    %eax,%ecx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 18 28 80 00       	push   $0x802818
  8004b1:	6a 6d                	push   $0x6d
  8004b3:	68 bc 27 80 00       	push   $0x8027bc
  8004b8:	e8 7b 03 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004bd:	e8 ef 1b 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8004c2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c5:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004ca:	74 14                	je     8004e0 <_main+0x4a8>
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	68 48 28 80 00       	push   $0x802848
  8004d4:	6a 6f                	push   $0x6f
  8004d6:	68 bc 27 80 00       	push   $0x8027bc
  8004db:	e8 58 03 00 00       	call   800838 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004e0:	e8 49 1b 00 00       	call   80202e <sys_calculate_free_frames>
  8004e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e8:	e8 c4 1b 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8004ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	50                   	push   %eax
  8004f7:	e8 16 18 00 00       	call   801d12 <free>
  8004fc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  8004ff:	e8 ad 1b 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800504:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800507:	29 c2                	sub    %eax,%edx
  800509:	89 d0                	mov    %edx,%eax
  80050b:	3d 00 03 00 00       	cmp    $0x300,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 65 28 80 00       	push   $0x802865
  80051a:	6a 76                	push   $0x76
  80051c:	68 bc 27 80 00       	push   $0x8027bc
  800521:	e8 12 03 00 00       	call   800838 <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 03 1b 00 00       	call   80202e <sys_calculate_free_frames>
  80052b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80052e:	e8 7e 1b 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 d0 17 00 00       	call   801d12 <free>
  800542:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800545:	e8 67 1b 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	3d 00 02 00 00       	cmp    $0x200,%eax
  800556:	74 14                	je     80056c <_main+0x534>
  800558:	83 ec 04             	sub    $0x4,%esp
  80055b:	68 65 28 80 00       	push   $0x802865
  800560:	6a 7d                	push   $0x7d
  800562:	68 bc 27 80 00       	push   $0x8027bc
  800567:	e8 cc 02 00 00       	call   800838 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80056c:	e8 bd 1a 00 00       	call   80202e <sys_calculate_free_frames>
  800571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800574:	e8 38 1b 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800579:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80057c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	c1 e0 02             	shl    $0x2,%eax
  800584:	01 d0                	add    %edx,%eax
  800586:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	50                   	push   %eax
  80058d:	e8 d2 12 00 00       	call   801864 <malloc>
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800598:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80059b:	89 c1                	mov    %eax,%ecx
  80059d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005a0:	89 d0                	mov    %edx,%eax
  8005a2:	c1 e0 03             	shl    $0x3,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	89 c3                	mov    %eax,%ebx
  8005a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ac:	89 d0                	mov    %edx,%eax
  8005ae:	01 c0                	add    %eax,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	c1 e0 03             	shl    $0x3,%eax
  8005b5:	01 d8                	add    %ebx,%eax
  8005b7:	05 00 00 00 80       	add    $0x80000000,%eax
  8005bc:	39 c1                	cmp    %eax,%ecx
  8005be:	74 17                	je     8005d7 <_main+0x59f>
  8005c0:	83 ec 04             	sub    $0x4,%esp
  8005c3:	68 18 28 80 00       	push   $0x802818
  8005c8:	68 83 00 00 00       	push   $0x83
  8005cd:	68 bc 27 80 00       	push   $0x8027bc
  8005d2:	e8 61 02 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  8005d7:	e8 d5 1a 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  8005dc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005df:	89 c1                	mov    %eax,%ecx
  8005e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e4:	89 d0                	mov    %edx,%eax
  8005e6:	c1 e0 02             	shl    $0x2,%eax
  8005e9:	01 d0                	add    %edx,%eax
  8005eb:	85 c0                	test   %eax,%eax
  8005ed:	79 05                	jns    8005f4 <_main+0x5bc>
  8005ef:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005f4:	c1 f8 0c             	sar    $0xc,%eax
  8005f7:	39 c1                	cmp    %eax,%ecx
  8005f9:	74 17                	je     800612 <_main+0x5da>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 48 28 80 00       	push   $0x802848
  800603:	68 85 00 00 00       	push   $0x85
  800608:	68 bc 27 80 00       	push   $0x8027bc
  80060d:	e8 26 02 00 00       	call   800838 <_panic>
//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800612:	e8 17 1a 00 00       	call   80202e <sys_calculate_free_frames>
  800617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80061a:	e8 92 1a 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  80061f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  800622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	01 d2                	add    %edx,%edx
  800629:	01 d0                	add    %edx,%eax
  80062b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80062e:	83 ec 0c             	sub    $0xc,%esp
  800631:	50                   	push   %eax
  800632:	e8 2d 12 00 00       	call   801864 <malloc>
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80063d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800640:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800645:	74 17                	je     80065e <_main+0x626>
  800647:	83 ec 04             	sub    $0x4,%esp
  80064a:	68 18 28 80 00       	push   $0x802818
  80064f:	68 93 00 00 00       	push   $0x93
  800654:	68 bc 27 80 00       	push   $0x8027bc
  800659:	e8 da 01 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80065e:	e8 4e 1a 00 00       	call   8020b1 <sys_pf_calculate_allocated_pages>
  800663:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80066b:	89 c1                	mov    %eax,%ecx
  80066d:	01 c9                	add    %ecx,%ecx
  80066f:	01 c8                	add    %ecx,%eax
  800671:	85 c0                	test   %eax,%eax
  800673:	79 05                	jns    80067a <_main+0x642>
  800675:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067a:	c1 f8 0c             	sar    $0xc,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x660>
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	68 48 28 80 00       	push   $0x802848
  800689:	68 95 00 00 00       	push   $0x95
  80068e:	68 bc 27 80 00       	push   $0x8027bc
  800693:	e8 a0 01 00 00       	call   800838 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800698:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80069b:	89 d0                	mov    %edx,%eax
  80069d:	01 c0                	add    %eax,%eax
  80069f:	01 d0                	add    %edx,%eax
  8006a1:	01 c0                	add    %eax,%eax
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	01 c0                	add    %eax,%eax
  8006a7:	f7 d8                	neg    %eax
  8006a9:	05 00 00 00 20       	add    $0x20000000,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 ad 11 00 00       	call   801864 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8006bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	74 17                	je     8006db <_main+0x6a3>
  8006c4:	83 ec 04             	sub    $0x4,%esp
  8006c7:	68 7c 28 80 00       	push   $0x80287c
  8006cc:	68 9e 00 00 00       	push   $0x9e
  8006d1:	68 bc 27 80 00       	push   $0x8027bc
  8006d6:	e8 5d 01 00 00       	call   800838 <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  8006db:	83 ec 0c             	sub    $0xc,%esp
  8006de:	68 e0 28 80 00       	push   $0x8028e0
  8006e3:	e8 f2 03 00 00       	call   800ada <cprintf>
  8006e8:	83 c4 10             	add    $0x10,%esp

		return;
  8006eb:	90                   	nop
	}
}
  8006ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006ef:	5b                   	pop    %ebx
  8006f0:	5f                   	pop    %edi
  8006f1:	5d                   	pop    %ebp
  8006f2:	c3                   	ret    

008006f3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8006f9:	e8 65 18 00 00       	call   801f63 <sys_getenvindex>
  8006fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800704:	89 d0                	mov    %edx,%eax
  800706:	c1 e0 03             	shl    $0x3,%eax
  800709:	01 d0                	add    %edx,%eax
  80070b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800712:	01 c8                	add    %ecx,%eax
  800714:	01 c0                	add    %eax,%eax
  800716:	01 d0                	add    %edx,%eax
  800718:	01 c0                	add    %eax,%eax
  80071a:	01 d0                	add    %edx,%eax
  80071c:	89 c2                	mov    %eax,%edx
  80071e:	c1 e2 05             	shl    $0x5,%edx
  800721:	29 c2                	sub    %eax,%edx
  800723:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800732:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800737:	a1 20 30 80 00       	mov    0x803020,%eax
  80073c:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800742:	84 c0                	test   %al,%al
  800744:	74 0f                	je     800755 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800746:	a1 20 30 80 00       	mov    0x803020,%eax
  80074b:	05 40 3c 01 00       	add    $0x13c40,%eax
  800750:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800755:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800759:	7e 0a                	jle    800765 <libmain+0x72>
		binaryname = argv[0];
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	ff 75 08             	pushl  0x8(%ebp)
  80076e:	e8 c5 f8 ff ff       	call   800038 <_main>
  800773:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800776:	e8 83 19 00 00       	call   8020fe <sys_disable_interrupt>
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 44 29 80 00       	push   $0x802944
  800783:	e8 52 03 00 00       	call   800ada <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80078b:	a1 20 30 80 00       	mov    0x803020,%eax
  800790:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800796:	a1 20 30 80 00       	mov    0x803020,%eax
  80079b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8007a1:	83 ec 04             	sub    $0x4,%esp
  8007a4:	52                   	push   %edx
  8007a5:	50                   	push   %eax
  8007a6:	68 6c 29 80 00       	push   $0x80296c
  8007ab:	e8 2a 03 00 00       	call   800ada <cprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8007b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b8:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8007be:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c3:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	52                   	push   %edx
  8007cd:	50                   	push   %eax
  8007ce:	68 94 29 80 00       	push   $0x802994
  8007d3:	e8 02 03 00 00       	call   800ada <cprintf>
  8007d8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007db:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e0:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	50                   	push   %eax
  8007ea:	68 d5 29 80 00       	push   $0x8029d5
  8007ef:	e8 e6 02 00 00       	call   800ada <cprintf>
  8007f4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8007f7:	83 ec 0c             	sub    $0xc,%esp
  8007fa:	68 44 29 80 00       	push   $0x802944
  8007ff:	e8 d6 02 00 00       	call   800ada <cprintf>
  800804:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800807:	e8 0c 19 00 00       	call   802118 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80080c:	e8 19 00 00 00       	call   80082a <exit>
}
  800811:	90                   	nop
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80081a:	83 ec 0c             	sub    $0xc,%esp
  80081d:	6a 00                	push   $0x0
  80081f:	e8 0b 17 00 00       	call   801f2f <sys_env_destroy>
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	90                   	nop
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <exit>:

void
exit(void)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800830:	e8 60 17 00 00       	call   801f95 <sys_env_exit>
}
  800835:	90                   	nop
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80083e:	8d 45 10             	lea    0x10(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800847:	a1 18 31 80 00       	mov    0x803118,%eax
  80084c:	85 c0                	test   %eax,%eax
  80084e:	74 16                	je     800866 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800850:	a1 18 31 80 00       	mov    0x803118,%eax
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	50                   	push   %eax
  800859:	68 ec 29 80 00       	push   $0x8029ec
  80085e:	e8 77 02 00 00       	call   800ada <cprintf>
  800863:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800866:	a1 00 30 80 00       	mov    0x803000,%eax
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	50                   	push   %eax
  800872:	68 f1 29 80 00       	push   $0x8029f1
  800877:	e8 5e 02 00 00       	call   800ada <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 f4             	pushl  -0xc(%ebp)
  800888:	50                   	push   %eax
  800889:	e8 e1 01 00 00       	call   800a6f <vcprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	6a 00                	push   $0x0
  800896:	68 0d 2a 80 00       	push   $0x802a0d
  80089b:	e8 cf 01 00 00       	call   800a6f <vcprintf>
  8008a0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a3:	e8 82 ff ff ff       	call   80082a <exit>

	// should not return here
	while (1) ;
  8008a8:	eb fe                	jmp    8008a8 <_panic+0x70>

008008aa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	74 14                	je     8008d3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	68 10 2a 80 00       	push   $0x802a10
  8008c7:	6a 26                	push   $0x26
  8008c9:	68 5c 2a 80 00       	push   $0x802a5c
  8008ce:	e8 65 ff ff ff       	call   800838 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008e1:	e9 b6 00 00 00       	jmp    80099c <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8008e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	01 d0                	add    %edx,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	75 08                	jne    800903 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8008fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008fe:	e9 96 00 00 00       	jmp    800999 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800903:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800911:	eb 5d                	jmp    800970 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800913:	a1 20 30 80 00       	mov    0x803020,%eax
  800918:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80091e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800921:	c1 e2 04             	shl    $0x4,%edx
  800924:	01 d0                	add    %edx,%eax
  800926:	8a 40 04             	mov    0x4(%eax),%al
  800929:	84 c0                	test   %al,%al
  80092b:	75 40                	jne    80096d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80092d:	a1 20 30 80 00       	mov    0x803020,%eax
  800932:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800938:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093b:	c1 e2 04             	shl    $0x4,%edx
  80093e:	01 d0                	add    %edx,%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800945:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80094d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80094f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800952:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	01 c8                	add    %ecx,%eax
  80095e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800960:	39 c2                	cmp    %eax,%edx
  800962:	75 09                	jne    80096d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800964:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80096b:	eb 12                	jmp    80097f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096d:	ff 45 e8             	incl   -0x18(%ebp)
  800970:	a1 20 30 80 00       	mov    0x803020,%eax
  800975:	8b 50 74             	mov    0x74(%eax),%edx
  800978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	77 94                	ja     800913 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80097f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800983:	75 14                	jne    800999 <CheckWSWithoutLastIndex+0xef>
			panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 68 2a 80 00       	push   $0x802a68
  80098d:	6a 3a                	push   $0x3a
  80098f:	68 5c 2a 80 00       	push   $0x802a5c
  800994:	e8 9f fe ff ff       	call   800838 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800999:	ff 45 f0             	incl   -0x10(%ebp)
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009a2:	0f 8c 3e ff ff ff    	jl     8008e6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b6:	eb 20                	jmp    8009d8 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8009bd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c6:	c1 e2 04             	shl    $0x4,%edx
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	3c 01                	cmp    $0x1,%al
  8009d0:	75 03                	jne    8009d5 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8009d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d5:	ff 45 e0             	incl   -0x20(%ebp)
  8009d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8009dd:	8b 50 74             	mov    0x74(%eax),%edx
  8009e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e3:	39 c2                	cmp    %eax,%edx
  8009e5:	77 d1                	ja     8009b8 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009ed:	74 14                	je     800a03 <CheckWSWithoutLastIndex+0x159>
		panic(
  8009ef:	83 ec 04             	sub    $0x4,%esp
  8009f2:	68 bc 2a 80 00       	push   $0x802abc
  8009f7:	6a 44                	push   $0x44
  8009f9:	68 5c 2a 80 00       	push   $0x802a5c
  8009fe:	e8 35 fe ff ff       	call   800838 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a03:	90                   	nop
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	8d 48 01             	lea    0x1(%eax),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a17:	89 0a                	mov    %ecx,(%edx)
  800a19:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1c:	88 d1                	mov    %dl,%cl
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a21:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a2f:	75 2c                	jne    800a5d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a31:	a0 24 30 80 00       	mov    0x803024,%al
  800a36:	0f b6 c0             	movzbl %al,%eax
  800a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3c:	8b 12                	mov    (%edx),%edx
  800a3e:	89 d1                	mov    %edx,%ecx
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	83 c2 08             	add    $0x8,%edx
  800a46:	83 ec 04             	sub    $0x4,%esp
  800a49:	50                   	push   %eax
  800a4a:	51                   	push   %ecx
  800a4b:	52                   	push   %edx
  800a4c:	e8 9c 14 00 00       	call   801eed <sys_cputs>
  800a51:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	8b 40 04             	mov    0x4(%eax),%eax
  800a63:	8d 50 01             	lea    0x1(%eax),%edx
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a6c:	90                   	nop
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a78:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a7f:	00 00 00 
	b.cnt = 0;
  800a82:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a89:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	ff 75 08             	pushl  0x8(%ebp)
  800a92:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	68 06 0a 80 00       	push   $0x800a06
  800a9e:	e8 11 02 00 00       	call   800cb4 <vprintfmt>
  800aa3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800aa6:	a0 24 30 80 00       	mov    0x803024,%al
  800aab:	0f b6 c0             	movzbl %al,%eax
  800aae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	50                   	push   %eax
  800ab8:	52                   	push   %edx
  800ab9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800abf:	83 c0 08             	add    $0x8,%eax
  800ac2:	50                   	push   %eax
  800ac3:	e8 25 14 00 00       	call   801eed <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800acb:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800ad2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <cprintf>:

int cprintf(const char *fmt, ...) {
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ae0:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800ae7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 f4             	pushl  -0xc(%ebp)
  800af6:	50                   	push   %eax
  800af7:	e8 73 ff ff ff       	call   800a6f <vcprintf>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b0d:	e8 ec 15 00 00       	call   8020fe <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b21:	50                   	push   %eax
  800b22:	e8 48 ff ff ff       	call   800a6f <vcprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b2d:	e8 e6 15 00 00       	call   802118 <sys_enable_interrupt>
	return cnt;
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	53                   	push   %ebx
  800b3b:	83 ec 14             	sub    $0x14,%esp
  800b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b55:	77 55                	ja     800bac <printnum+0x75>
  800b57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b5a:	72 05                	jb     800b61 <printnum+0x2a>
  800b5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b5f:	77 4b                	ja     800bac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b67:	8b 45 18             	mov    0x18(%ebp),%eax
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	52                   	push   %edx
  800b70:	50                   	push   %eax
  800b71:	ff 75 f4             	pushl  -0xc(%ebp)
  800b74:	ff 75 f0             	pushl  -0x10(%ebp)
  800b77:	e8 a4 19 00 00       	call   802520 <__udivdi3>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	ff 75 20             	pushl  0x20(%ebp)
  800b85:	53                   	push   %ebx
  800b86:	ff 75 18             	pushl  0x18(%ebp)
  800b89:	52                   	push   %edx
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 a1 ff ff ff       	call   800b37 <printnum>
  800b96:	83 c4 20             	add    $0x20,%esp
  800b99:	eb 1a                	jmp    800bb5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	ff 75 20             	pushl  0x20(%ebp)
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bac:	ff 4d 1c             	decl   0x1c(%ebp)
  800baf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bb3:	7f e6                	jg     800b9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bb5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	53                   	push   %ebx
  800bc4:	51                   	push   %ecx
  800bc5:	52                   	push   %edx
  800bc6:	50                   	push   %eax
  800bc7:	e8 64 1a 00 00       	call   802630 <__umoddi3>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	05 34 2d 80 00       	add    $0x802d34,%eax
  800bd4:	8a 00                	mov    (%eax),%al
  800bd6:	0f be c0             	movsbl %al,%eax
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	50                   	push   %eax
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
}
  800be8:	90                   	nop
  800be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf5:	7e 1c                	jle    800c13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	8d 50 08             	lea    0x8(%eax),%edx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 10                	mov    %edx,(%eax)
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	83 e8 08             	sub    $0x8,%eax
  800c0c:	8b 50 04             	mov    0x4(%eax),%edx
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	eb 40                	jmp    800c53 <getuint+0x65>
	else if (lflag)
  800c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c17:	74 1e                	je     800c37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	8d 50 04             	lea    0x4(%eax),%edx
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	89 10                	mov    %edx,(%eax)
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	83 e8 04             	sub    $0x4,%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	ba 00 00 00 00       	mov    $0x0,%edx
  800c35:	eb 1c                	jmp    800c53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	8d 50 04             	lea    0x4(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 10                	mov    %edx,(%eax)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	83 e8 04             	sub    $0x4,%eax
  800c4c:	8b 00                	mov    (%eax),%eax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c5c:	7e 1c                	jle    800c7a <getint+0x25>
		return va_arg(*ap, long long);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	8d 50 08             	lea    0x8(%eax),%edx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 10                	mov    %edx,(%eax)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	83 e8 08             	sub    $0x8,%eax
  800c73:	8b 50 04             	mov    0x4(%eax),%edx
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	eb 38                	jmp    800cb2 <getint+0x5d>
	else if (lflag)
  800c7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7e:	74 1a                	je     800c9a <getint+0x45>
		return va_arg(*ap, long);
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	8d 50 04             	lea    0x4(%eax),%edx
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	89 10                	mov    %edx,(%eax)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8b 00                	mov    (%eax),%eax
  800c92:	83 e8 04             	sub    $0x4,%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	99                   	cltd   
  800c98:	eb 18                	jmp    800cb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 10                	mov    %edx,(%eax)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax
  800cb1:	99                   	cltd   
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbc:	eb 17                	jmp    800cd5 <vprintfmt+0x21>
			if (ch == '\0')
  800cbe:	85 db                	test   %ebx,%ebx
  800cc0:	0f 84 af 03 00 00    	je     801075 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800cc6:	83 ec 08             	sub    $0x8,%esp
  800cc9:	ff 75 0c             	pushl  0xc(%ebp)
  800ccc:	53                   	push   %ebx
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd8:	8d 50 01             	lea    0x1(%eax),%edx
  800cdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d8             	movzbl %al,%ebx
  800ce3:	83 fb 25             	cmp    $0x25,%ebx
  800ce6:	75 d6                	jne    800cbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ce8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	8d 50 01             	lea    0x1(%eax),%edx
  800d0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 d8             	movzbl %al,%ebx
  800d16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d19:	83 f8 55             	cmp    $0x55,%eax
  800d1c:	0f 87 2b 03 00 00    	ja     80104d <vprintfmt+0x399>
  800d22:	8b 04 85 58 2d 80 00 	mov    0x802d58(,%eax,4),%eax
  800d29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d2f:	eb d7                	jmp    800d08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d35:	eb d1                	jmp    800d08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d41:	89 d0                	mov    %edx,%eax
  800d43:	c1 e0 02             	shl    $0x2,%eax
  800d46:	01 d0                	add    %edx,%eax
  800d48:	01 c0                	add    %eax,%eax
  800d4a:	01 d8                	add    %ebx,%eax
  800d4c:	83 e8 30             	sub    $0x30,%eax
  800d4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800d5d:	7e 3e                	jle    800d9d <vprintfmt+0xe9>
  800d5f:	83 fb 39             	cmp    $0x39,%ebx
  800d62:	7f 39                	jg     800d9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d67:	eb d5                	jmp    800d3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	83 c0 04             	add    $0x4,%eax
  800d6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d72:	8b 45 14             	mov    0x14(%ebp),%eax
  800d75:	83 e8 04             	sub    $0x4,%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d7d:	eb 1f                	jmp    800d9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d83:	79 83                	jns    800d08 <vprintfmt+0x54>
				width = 0;
  800d85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d8c:	e9 77 ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d98:	e9 6b ff ff ff       	jmp    800d08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da2:	0f 89 60 ff ff ff    	jns    800d08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800db5:	e9 4e ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dbd:	e9 46 ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc5:	83 c0 04             	add    $0x4,%eax
  800dc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	83 e8 04             	sub    $0x4,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	83 ec 08             	sub    $0x8,%esp
  800dd6:	ff 75 0c             	pushl  0xc(%ebp)
  800dd9:	50                   	push   %eax
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	ff d0                	call   *%eax
  800ddf:	83 c4 10             	add    $0x10,%esp
			break;
  800de2:	e9 89 02 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800de7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dea:	83 c0 04             	add    $0x4,%eax
  800ded:	89 45 14             	mov    %eax,0x14(%ebp)
  800df0:	8b 45 14             	mov    0x14(%ebp),%eax
  800df3:	83 e8 04             	sub    $0x4,%eax
  800df6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800df8:	85 db                	test   %ebx,%ebx
  800dfa:	79 02                	jns    800dfe <vprintfmt+0x14a>
				err = -err;
  800dfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dfe:	83 fb 64             	cmp    $0x64,%ebx
  800e01:	7f 0b                	jg     800e0e <vprintfmt+0x15a>
  800e03:	8b 34 9d a0 2b 80 00 	mov    0x802ba0(,%ebx,4),%esi
  800e0a:	85 f6                	test   %esi,%esi
  800e0c:	75 19                	jne    800e27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e0e:	53                   	push   %ebx
  800e0f:	68 45 2d 80 00       	push   $0x802d45
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	ff 75 08             	pushl  0x8(%ebp)
  800e1a:	e8 5e 02 00 00       	call   80107d <printfmt>
  800e1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e22:	e9 49 02 00 00       	jmp    801070 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e27:	56                   	push   %esi
  800e28:	68 4e 2d 80 00       	push   $0x802d4e
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 45 02 00 00       	call   80107d <printfmt>
  800e38:	83 c4 10             	add    $0x10,%esp
			break;
  800e3b:	e9 30 02 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e40:	8b 45 14             	mov    0x14(%ebp),%eax
  800e43:	83 c0 04             	add    $0x4,%eax
  800e46:	89 45 14             	mov    %eax,0x14(%ebp)
  800e49:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4c:	83 e8 04             	sub    $0x4,%eax
  800e4f:	8b 30                	mov    (%eax),%esi
  800e51:	85 f6                	test   %esi,%esi
  800e53:	75 05                	jne    800e5a <vprintfmt+0x1a6>
				p = "(null)";
  800e55:	be 51 2d 80 00       	mov    $0x802d51,%esi
			if (width > 0 && padc != '-')
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	7e 6d                	jle    800ecd <vprintfmt+0x219>
  800e60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e64:	74 67                	je     800ecd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	50                   	push   %eax
  800e6d:	56                   	push   %esi
  800e6e:	e8 0c 03 00 00       	call   80117f <strnlen>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e79:	eb 16                	jmp    800e91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	50                   	push   %eax
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	ff d0                	call   *%eax
  800e8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800e91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e95:	7f e4                	jg     800e7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e97:	eb 34                	jmp    800ecd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e9d:	74 1c                	je     800ebb <vprintfmt+0x207>
  800e9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800ea2:	7e 05                	jle    800ea9 <vprintfmt+0x1f5>
  800ea4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ea7:	7e 12                	jle    800ebb <vprintfmt+0x207>
					putch('?', putdat);
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	6a 3f                	push   $0x3f
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	eb 0f                	jmp    800eca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	53                   	push   %ebx
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	ff d0                	call   *%eax
  800ec7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eca:	ff 4d e4             	decl   -0x1c(%ebp)
  800ecd:	89 f0                	mov    %esi,%eax
  800ecf:	8d 70 01             	lea    0x1(%eax),%esi
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f be d8             	movsbl %al,%ebx
  800ed7:	85 db                	test   %ebx,%ebx
  800ed9:	74 24                	je     800eff <vprintfmt+0x24b>
  800edb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edf:	78 b8                	js     800e99 <vprintfmt+0x1e5>
  800ee1:	ff 4d e0             	decl   -0x20(%ebp)
  800ee4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee8:	79 af                	jns    800e99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eea:	eb 13                	jmp    800eff <vprintfmt+0x24b>
				putch(' ', putdat);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	6a 20                	push   $0x20
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	ff d0                	call   *%eax
  800ef9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800efc:	ff 4d e4             	decl   -0x1c(%ebp)
  800eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f03:	7f e7                	jg     800eec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f05:	e9 66 01 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800f10:	8d 45 14             	lea    0x14(%ebp),%eax
  800f13:	50                   	push   %eax
  800f14:	e8 3c fd ff ff       	call   800c55 <getint>
  800f19:	83 c4 10             	add    $0x10,%esp
  800f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f28:	85 d2                	test   %edx,%edx
  800f2a:	79 23                	jns    800f4f <vprintfmt+0x29b>
				putch('-', putdat);
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	ff 75 0c             	pushl  0xc(%ebp)
  800f32:	6a 2d                	push   $0x2d
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	ff d0                	call   *%eax
  800f39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f42:	f7 d8                	neg    %eax
  800f44:	83 d2 00             	adc    $0x0,%edx
  800f47:	f7 da                	neg    %edx
  800f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f56:	e9 bc 00 00 00       	jmp    801017 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f61:	8d 45 14             	lea    0x14(%ebp),%eax
  800f64:	50                   	push   %eax
  800f65:	e8 84 fc ff ff       	call   800bee <getuint>
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f7a:	e9 98 00 00 00       	jmp    801017 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	6a 58                	push   $0x58
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff d0                	call   *%eax
  800f8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 58                	push   $0x58
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 0c             	pushl  0xc(%ebp)
  800fa5:	6a 58                	push   $0x58
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	ff d0                	call   *%eax
  800fac:	83 c4 10             	add    $0x10,%esp
			break;
  800faf:	e9 bc 00 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	6a 30                	push   $0x30
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	ff d0                	call   *%eax
  800fc1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fc4:	83 ec 08             	sub    $0x8,%esp
  800fc7:	ff 75 0c             	pushl  0xc(%ebp)
  800fca:	6a 78                	push   $0x78
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	ff d0                	call   *%eax
  800fd1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	83 c0 04             	add    $0x4,%eax
  800fda:	89 45 14             	mov    %eax,0x14(%ebp)
  800fdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe0:	83 e8 04             	sub    $0x4,%eax
  800fe3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ff6:	eb 1f                	jmp    801017 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ffe:	8d 45 14             	lea    0x14(%ebp),%eax
  801001:	50                   	push   %eax
  801002:	e8 e7 fb ff ff       	call   800bee <getuint>
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801010:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801017:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80101b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	52                   	push   %edx
  801022:	ff 75 e4             	pushl  -0x1c(%ebp)
  801025:	50                   	push   %eax
  801026:	ff 75 f4             	pushl  -0xc(%ebp)
  801029:	ff 75 f0             	pushl  -0x10(%ebp)
  80102c:	ff 75 0c             	pushl  0xc(%ebp)
  80102f:	ff 75 08             	pushl  0x8(%ebp)
  801032:	e8 00 fb ff ff       	call   800b37 <printnum>
  801037:	83 c4 20             	add    $0x20,%esp
			break;
  80103a:	eb 34                	jmp    801070 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80103c:	83 ec 08             	sub    $0x8,%esp
  80103f:	ff 75 0c             	pushl  0xc(%ebp)
  801042:	53                   	push   %ebx
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			break;
  80104b:	eb 23                	jmp    801070 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	6a 25                	push   $0x25
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	ff d0                	call   *%eax
  80105a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105d:	ff 4d 10             	decl   0x10(%ebp)
  801060:	eb 03                	jmp    801065 <vprintfmt+0x3b1>
  801062:	ff 4d 10             	decl   0x10(%ebp)
  801065:	8b 45 10             	mov    0x10(%ebp),%eax
  801068:	48                   	dec    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 25                	cmp    $0x25,%al
  80106d:	75 f3                	jne    801062 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80106f:	90                   	nop
		}
	}
  801070:	e9 47 fc ff ff       	jmp    800cbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801075:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801076:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801083:	8d 45 10             	lea    0x10(%ebp),%eax
  801086:	83 c0 04             	add    $0x4,%eax
  801089:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	ff 75 f4             	pushl  -0xc(%ebp)
  801092:	50                   	push   %eax
  801093:	ff 75 0c             	pushl  0xc(%ebp)
  801096:	ff 75 08             	pushl  0x8(%ebp)
  801099:	e8 16 fc ff ff       	call   800cb4 <vprintfmt>
  80109e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a1:	90                   	nop
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    

008010a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8b 40 08             	mov    0x8(%eax),%eax
  8010ad:	8d 50 01             	lea    0x1(%eax),%edx
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	8b 10                	mov    (%eax),%edx
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	8b 40 04             	mov    0x4(%eax),%eax
  8010c1:	39 c2                	cmp    %eax,%edx
  8010c3:	73 12                	jae    8010d7 <sprintputch+0x33>
		*b->buf++ = ch;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8010cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d0:	89 0a                	mov    %ecx,(%edx)
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	88 10                	mov    %dl,(%eax)
}
  8010d7:	90                   	nop
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	01 d0                	add    %edx,%eax
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ff:	74 06                	je     801107 <vsnprintf+0x2d>
  801101:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801105:	7f 07                	jg     80110e <vsnprintf+0x34>
		return -E_INVAL;
  801107:	b8 03 00 00 00       	mov    $0x3,%eax
  80110c:	eb 20                	jmp    80112e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80110e:	ff 75 14             	pushl  0x14(%ebp)
  801111:	ff 75 10             	pushl  0x10(%ebp)
  801114:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801117:	50                   	push   %eax
  801118:	68 a4 10 80 00       	push   $0x8010a4
  80111d:	e8 92 fb ff ff       	call   800cb4 <vprintfmt>
  801122:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801128:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80112b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801136:	8d 45 10             	lea    0x10(%ebp),%eax
  801139:	83 c0 04             	add    $0x4,%eax
  80113c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80113f:	8b 45 10             	mov    0x10(%ebp),%eax
  801142:	ff 75 f4             	pushl  -0xc(%ebp)
  801145:	50                   	push   %eax
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	ff 75 08             	pushl  0x8(%ebp)
  80114c:	e8 89 ff ff ff       	call   8010da <vsnprintf>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801157:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801169:	eb 06                	jmp    801171 <strlen+0x15>
		n++;
  80116b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80116e:	ff 45 08             	incl   0x8(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	84 c0                	test   %al,%al
  801178:	75 f1                	jne    80116b <strlen+0xf>
		n++;
	return n;
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80118c:	eb 09                	jmp    801197 <strnlen+0x18>
		n++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801191:	ff 45 08             	incl   0x8(%ebp)
  801194:	ff 4d 0c             	decl   0xc(%ebp)
  801197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119b:	74 09                	je     8011a6 <strnlen+0x27>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	84 c0                	test   %al,%al
  8011a4:	75 e8                	jne    80118e <strnlen+0xf>
		n++;
	return n;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011b7:	90                   	nop
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8d 50 01             	lea    0x1(%eax),%edx
  8011be:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011ca:	8a 12                	mov    (%edx),%dl
  8011cc:	88 10                	mov    %dl,(%eax)
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	84 c0                	test   %al,%al
  8011d2:	75 e4                	jne    8011b8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ec:	eb 1f                	jmp    80120d <strncpy+0x34>
		*dst++ = *src;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8d 50 01             	lea    0x1(%eax),%edx
  8011f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fa:	8a 12                	mov    (%edx),%dl
  8011fc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	84 c0                	test   %al,%al
  801205:	74 03                	je     80120a <strncpy+0x31>
			src++;
  801207:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80120a:	ff 45 fc             	incl   -0x4(%ebp)
  80120d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801210:	3b 45 10             	cmp    0x10(%ebp),%eax
  801213:	72 d9                	jb     8011ee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801215:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122a:	74 30                	je     80125c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80122c:	eb 16                	jmp    801244 <strlcpy+0x2a>
			*dst++ = *src++;
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8d 50 01             	lea    0x1(%eax),%edx
  801234:	89 55 08             	mov    %edx,0x8(%ebp)
  801237:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80123d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801240:	8a 12                	mov    (%edx),%dl
  801242:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801244:	ff 4d 10             	decl   0x10(%ebp)
  801247:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124b:	74 09                	je     801256 <strlcpy+0x3c>
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	75 d8                	jne    80122e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80125c:	8b 55 08             	mov    0x8(%ebp),%edx
  80125f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801262:	29 c2                	sub    %eax,%edx
  801264:	89 d0                	mov    %edx,%eax
}
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80126b:	eb 06                	jmp    801273 <strcmp+0xb>
		p++, q++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
  801270:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	84 c0                	test   %al,%al
  80127a:	74 0e                	je     80128a <strcmp+0x22>
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8a 10                	mov    (%eax),%dl
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	38 c2                	cmp    %al,%dl
  801288:	74 e3                	je     80126d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	0f b6 d0             	movzbl %al,%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f b6 c0             	movzbl %al,%eax
  80129a:	29 c2                	sub    %eax,%edx
  80129c:	89 d0                	mov    %edx,%eax
}
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012a3:	eb 09                	jmp    8012ae <strncmp+0xe>
		n--, p++, q++;
  8012a5:	ff 4d 10             	decl   0x10(%ebp)
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b2:	74 17                	je     8012cb <strncmp+0x2b>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	84 c0                	test   %al,%al
  8012bb:	74 0e                	je     8012cb <strncmp+0x2b>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 10                	mov    (%eax),%dl
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	38 c2                	cmp    %al,%dl
  8012c9:	74 da                	je     8012a5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	75 07                	jne    8012d8 <strncmp+0x38>
		return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d6:	eb 14                	jmp    8012ec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	0f b6 d0             	movzbl %al,%edx
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	0f b6 c0             	movzbl %al,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
}
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012fa:	eb 12                	jmp    80130e <strchr+0x20>
		if (*s == c)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801304:	75 05                	jne    80130b <strchr+0x1d>
			return (char *) s;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	eb 11                	jmp    80131c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80130b:	ff 45 08             	incl   0x8(%ebp)
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e5                	jne    8012fc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80132a:	eb 0d                	jmp    801339 <strfind+0x1b>
		if (*s == c)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801334:	74 0e                	je     801344 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	84 c0                	test   %al,%al
  801340:	75 ea                	jne    80132c <strfind+0xe>
  801342:	eb 01                	jmp    801345 <strfind+0x27>
		if (*s == c)
			break;
  801344:	90                   	nop
	return (char *) s;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80135c:	eb 0e                	jmp    80136c <memset+0x22>
		*p++ = c;
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80136c:	ff 4d f8             	decl   -0x8(%ebp)
  80136f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801373:	79 e9                	jns    80135e <memset+0x14>
		*p++ = c;

	return v;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80138c:	eb 16                	jmp    8013a4 <memcpy+0x2a>
		*d++ = *s++;
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801397:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	75 dd                	jne    80138e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ce:	73 50                	jae    801420 <memmove+0x6a>
  8013d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013db:	76 43                	jbe    801420 <memmove+0x6a>
		s += n;
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013e9:	eb 10                	jmp    8013fb <memmove+0x45>
			*--d = *--s;
  8013eb:	ff 4d f8             	decl   -0x8(%ebp)
  8013ee:	ff 4d fc             	decl   -0x4(%ebp)
  8013f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f4:	8a 10                	mov    (%eax),%dl
  8013f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801401:	89 55 10             	mov    %edx,0x10(%ebp)
  801404:	85 c0                	test   %eax,%eax
  801406:	75 e3                	jne    8013eb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801408:	eb 23                	jmp    80142d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80140a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140d:	8d 50 01             	lea    0x1(%eax),%edx
  801410:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801413:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801416:	8d 4a 01             	lea    0x1(%edx),%ecx
  801419:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80141c:	8a 12                	mov    (%edx),%dl
  80141e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	8d 50 ff             	lea    -0x1(%eax),%edx
  801426:	89 55 10             	mov    %edx,0x10(%ebp)
  801429:	85 c0                	test   %eax,%eax
  80142b:	75 dd                	jne    80140a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801444:	eb 2a                	jmp    801470 <memcmp+0x3e>
		if (*s1 != *s2)
  801446:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801449:	8a 10                	mov    (%eax),%dl
  80144b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	38 c2                	cmp    %al,%dl
  801452:	74 16                	je     80146a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801454:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	0f b6 d0             	movzbl %al,%edx
  80145c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	0f b6 c0             	movzbl %al,%eax
  801464:	29 c2                	sub    %eax,%edx
  801466:	89 d0                	mov    %edx,%eax
  801468:	eb 18                	jmp    801482 <memcmp+0x50>
		s1++, s2++;
  80146a:	ff 45 fc             	incl   -0x4(%ebp)
  80146d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	8d 50 ff             	lea    -0x1(%eax),%edx
  801476:	89 55 10             	mov    %edx,0x10(%ebp)
  801479:	85 c0                	test   %eax,%eax
  80147b:	75 c9                	jne    801446 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80148a:	8b 55 08             	mov    0x8(%ebp),%edx
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	01 d0                	add    %edx,%eax
  801492:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801495:	eb 15                	jmp    8014ac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	0f b6 d0             	movzbl %al,%edx
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	0f b6 c0             	movzbl %al,%eax
  8014a5:	39 c2                	cmp    %eax,%edx
  8014a7:	74 0d                	je     8014b6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b2:	72 e3                	jb     801497 <memfind+0x13>
  8014b4:	eb 01                	jmp    8014b7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014b6:	90                   	nop
	return (void *) s;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d0:	eb 03                	jmp    8014d5 <strtol+0x19>
		s++;
  8014d2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 20                	cmp    $0x20,%al
  8014dc:	74 f4                	je     8014d2 <strtol+0x16>
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3c 09                	cmp    $0x9,%al
  8014e5:	74 eb                	je     8014d2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	3c 2b                	cmp    $0x2b,%al
  8014ee:	75 05                	jne    8014f5 <strtol+0x39>
		s++;
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	eb 13                	jmp    801508 <strtol+0x4c>
	else if (*s == '-')
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	3c 2d                	cmp    $0x2d,%al
  8014fc:	75 0a                	jne    801508 <strtol+0x4c>
		s++, neg = 1;
  8014fe:	ff 45 08             	incl   0x8(%ebp)
  801501:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801508:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150c:	74 06                	je     801514 <strtol+0x58>
  80150e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801512:	75 20                	jne    801534 <strtol+0x78>
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 30                	cmp    $0x30,%al
  80151b:	75 17                	jne    801534 <strtol+0x78>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	40                   	inc    %eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 78                	cmp    $0x78,%al
  801525:	75 0d                	jne    801534 <strtol+0x78>
		s += 2, base = 16;
  801527:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80152b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801532:	eb 28                	jmp    80155c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801534:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801538:	75 15                	jne    80154f <strtol+0x93>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	3c 30                	cmp    $0x30,%al
  801541:	75 0c                	jne    80154f <strtol+0x93>
		s++, base = 8;
  801543:	ff 45 08             	incl   0x8(%ebp)
  801546:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80154d:	eb 0d                	jmp    80155c <strtol+0xa0>
	else if (base == 0)
  80154f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801553:	75 07                	jne    80155c <strtol+0xa0>
		base = 10;
  801555:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	3c 2f                	cmp    $0x2f,%al
  801563:	7e 19                	jle    80157e <strtol+0xc2>
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	3c 39                	cmp    $0x39,%al
  80156c:	7f 10                	jg     80157e <strtol+0xc2>
			dig = *s - '0';
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	0f be c0             	movsbl %al,%eax
  801576:	83 e8 30             	sub    $0x30,%eax
  801579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157c:	eb 42                	jmp    8015c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	3c 60                	cmp    $0x60,%al
  801585:	7e 19                	jle    8015a0 <strtol+0xe4>
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	3c 7a                	cmp    $0x7a,%al
  80158e:	7f 10                	jg     8015a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f be c0             	movsbl %al,%eax
  801598:	83 e8 57             	sub    $0x57,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159e:	eb 20                	jmp    8015c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3c 40                	cmp    $0x40,%al
  8015a7:	7e 39                	jle    8015e2 <strtol+0x126>
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3c 5a                	cmp    $0x5a,%al
  8015b0:	7f 30                	jg     8015e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	0f be c0             	movsbl %al,%eax
  8015ba:	83 e8 37             	sub    $0x37,%eax
  8015bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015c6:	7d 19                	jge    8015e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015c8:	ff 45 08             	incl   0x8(%ebp)
  8015cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015dc:	e9 7b ff ff ff       	jmp    80155c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e6:	74 08                	je     8015f0 <strtol+0x134>
		*endptr = (char *) s;
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015f4:	74 07                	je     8015fd <strtol+0x141>
  8015f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f9:	f7 d8                	neg    %eax
  8015fb:	eb 03                	jmp    801600 <strtol+0x144>
  8015fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <ltostr>:

void
ltostr(long value, char *str)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801608:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80160f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80161a:	79 13                	jns    80162f <ltostr+0x2d>
	{
		neg = 1;
  80161c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801629:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80162c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801637:	99                   	cltd   
  801638:	f7 f9                	idiv   %ecx
  80163a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80163d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801640:	8d 50 01             	lea    0x1(%eax),%edx
  801643:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801646:	89 c2                	mov    %eax,%edx
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	01 d0                	add    %edx,%eax
  80164d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801650:	83 c2 30             	add    $0x30,%edx
  801653:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801655:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801658:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80165d:	f7 e9                	imul   %ecx
  80165f:	c1 fa 02             	sar    $0x2,%edx
  801662:	89 c8                	mov    %ecx,%eax
  801664:	c1 f8 1f             	sar    $0x1f,%eax
  801667:	29 c2                	sub    %eax,%edx
  801669:	89 d0                	mov    %edx,%eax
  80166b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80166e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801671:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801676:	f7 e9                	imul   %ecx
  801678:	c1 fa 02             	sar    $0x2,%edx
  80167b:	89 c8                	mov    %ecx,%eax
  80167d:	c1 f8 1f             	sar    $0x1f,%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
  801684:	c1 e0 02             	shl    $0x2,%eax
  801687:	01 d0                	add    %edx,%eax
  801689:	01 c0                	add    %eax,%eax
  80168b:	29 c1                	sub    %eax,%ecx
  80168d:	89 ca                	mov    %ecx,%edx
  80168f:	85 d2                	test   %edx,%edx
  801691:	75 9c                	jne    80162f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80169a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169d:	48                   	dec    %eax
  80169e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016a5:	74 3d                	je     8016e4 <ltostr+0xe2>
		start = 1 ;
  8016a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016ae:	eb 34                	jmp    8016e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	01 c2                	add    %eax,%edx
  8016c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	01 c8                	add    %ecx,%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d7:	01 c2                	add    %eax,%edx
  8016d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8016de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ea:	7c c4                	jl     8016b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	01 d0                	add    %edx,%eax
  8016f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801700:	ff 75 08             	pushl  0x8(%ebp)
  801703:	e8 54 fa ff ff       	call   80115c <strlen>
  801708:	83 c4 04             	add    $0x4,%esp
  80170b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	e8 46 fa ff ff       	call   80115c <strlen>
  801716:	83 c4 04             	add    $0x4,%esp
  801719:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80171c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801723:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80172a:	eb 17                	jmp    801743 <strcconcat+0x49>
		final[s] = str1[s] ;
  80172c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	01 c2                	add    %eax,%edx
  801734:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	01 c8                	add    %ecx,%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801740:	ff 45 fc             	incl   -0x4(%ebp)
  801743:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801746:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801749:	7c e1                	jl     80172c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80174b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801752:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801759:	eb 1f                	jmp    80177a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80175b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80175e:	8d 50 01             	lea    0x1(%eax),%edx
  801761:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801764:	89 c2                	mov    %eax,%edx
  801766:	8b 45 10             	mov    0x10(%ebp),%eax
  801769:	01 c2                	add    %eax,%edx
  80176b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	01 c8                	add    %ecx,%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801777:	ff 45 f8             	incl   -0x8(%ebp)
  80177a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801780:	7c d9                	jl     80175b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801782:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c6 00 00             	movb   $0x0,(%eax)
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801793:	8b 45 14             	mov    0x14(%ebp),%eax
  801796:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80179c:	8b 45 14             	mov    0x14(%ebp),%eax
  80179f:	8b 00                	mov    (%eax),%eax
  8017a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017b3:	eb 0c                	jmp    8017c1 <strsplit+0x31>
			*string++ = 0;
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8d 50 01             	lea    0x1(%eax),%edx
  8017bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8017be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	84 c0                	test   %al,%al
  8017c8:	74 18                	je     8017e2 <strsplit+0x52>
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	8a 00                	mov    (%eax),%al
  8017cf:	0f be c0             	movsbl %al,%eax
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	e8 13 fb ff ff       	call   8012ee <strchr>
  8017db:	83 c4 08             	add    $0x8,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	75 d3                	jne    8017b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	84 c0                	test   %al,%al
  8017e9:	74 5a                	je     801845 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ee:	8b 00                	mov    (%eax),%eax
  8017f0:	83 f8 0f             	cmp    $0xf,%eax
  8017f3:	75 07                	jne    8017fc <strsplit+0x6c>
		{
			return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	eb 66                	jmp    801862 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ff:	8b 00                	mov    (%eax),%eax
  801801:	8d 48 01             	lea    0x1(%eax),%ecx
  801804:	8b 55 14             	mov    0x14(%ebp),%edx
  801807:	89 0a                	mov    %ecx,(%edx)
  801809:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801810:	8b 45 10             	mov    0x10(%ebp),%eax
  801813:	01 c2                	add    %eax,%edx
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80181a:	eb 03                	jmp    80181f <strsplit+0x8f>
			string++;
  80181c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	84 c0                	test   %al,%al
  801826:	74 8b                	je     8017b3 <strsplit+0x23>
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	0f be c0             	movsbl %al,%eax
  801830:	50                   	push   %eax
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	e8 b5 fa ff ff       	call   8012ee <strchr>
  801839:	83 c4 08             	add    $0x8,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	74 dc                	je     80181c <strsplit+0x8c>
			string++;
	}
  801840:	e9 6e ff ff ff       	jmp    8017b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801845:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	8b 00                	mov    (%eax),%eax
  80184b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80185d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80186a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801871:	8b 55 08             	mov    0x8(%ebp),%edx
  801874:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801877:	01 d0                	add    %edx,%eax
  801879:	48                   	dec    %eax
  80187a:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80187d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801880:	ba 00 00 00 00       	mov    $0x0,%edx
  801885:	f7 75 ac             	divl   -0x54(%ebp)
  801888:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80188b:	29 d0                	sub    %edx,%eax
  80188d:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801897:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80189e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8018a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018ac:	eb 3f                	jmp    8018ed <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8018ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b1:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	50                   	push   %eax
  8018bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8018bf:	68 b0 2e 80 00       	push   $0x802eb0
  8018c4:	e8 11 f2 ff ff       	call   800ada <cprintf>
  8018c9:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8018cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018cf:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	50                   	push   %eax
  8018da:	ff 75 e8             	pushl  -0x18(%ebp)
  8018dd:	68 c5 2e 80 00       	push   $0x802ec5
  8018e2:	e8 f3 f1 ff ff       	call   800ada <cprintf>
  8018e7:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8018ea:	ff 45 e8             	incl   -0x18(%ebp)
  8018ed:	a1 28 30 80 00       	mov    0x803028,%eax
  8018f2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8018f5:	7c b7                	jl     8018ae <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8018f7:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8018fe:	e9 35 01 00 00       	jmp    801a38 <malloc+0x1d4>
		int flag0=1;
  801903:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80190a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801910:	eb 5e                	jmp    801970 <malloc+0x10c>
			for(int k=0;k<count;k++){
  801912:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801919:	eb 35                	jmp    801950 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80191b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80191e:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801925:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801928:	39 c2                	cmp    %eax,%edx
  80192a:	77 21                	ja     80194d <malloc+0xe9>
  80192c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80192f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801936:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801939:	39 c2                	cmp    %eax,%edx
  80193b:	76 10                	jbe    80194d <malloc+0xe9>
					ni=PAGE_SIZE;
  80193d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  801944:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  80194b:	eb 0d                	jmp    80195a <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  80194d:	ff 45 d8             	incl   -0x28(%ebp)
  801950:	a1 28 30 80 00       	mov    0x803028,%eax
  801955:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801958:	7c c1                	jl     80191b <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  80195a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80195e:	74 09                	je     801969 <malloc+0x105>
				flag0=0;
  801960:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801967:	eb 16                	jmp    80197f <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801969:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801970:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	01 c2                	add    %eax,%edx
  801978:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80197b:	39 c2                	cmp    %eax,%edx
  80197d:	77 93                	ja     801912 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  80197f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801983:	0f 84 a2 00 00 00    	je     801a2b <malloc+0x1c7>

			int f=1;
  801989:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801993:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801996:	89 c8                	mov    %ecx,%eax
  801998:	01 c0                	add    %eax,%eax
  80199a:	01 c8                	add    %ecx,%eax
  80199c:	c1 e0 02             	shl    $0x2,%eax
  80199f:	05 20 31 80 00       	add    $0x803120,%eax
  8019a4:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8019a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8019af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b2:	89 d0                	mov    %edx,%eax
  8019b4:	01 c0                	add    %eax,%eax
  8019b6:	01 d0                	add    %edx,%eax
  8019b8:	c1 e0 02             	shl    $0x2,%eax
  8019bb:	05 24 31 80 00       	add    $0x803124,%eax
  8019c0:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8019c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c5:	89 d0                	mov    %edx,%eax
  8019c7:	01 c0                	add    %eax,%eax
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	c1 e0 02             	shl    $0x2,%eax
  8019ce:	05 28 31 80 00       	add    $0x803128,%eax
  8019d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  8019d9:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  8019dc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8019e3:	eb 36                	jmp    801a1b <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  8019e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	01 c2                	add    %eax,%edx
  8019ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019f0:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019f7:	39 c2                	cmp    %eax,%edx
  8019f9:	73 1d                	jae    801a18 <malloc+0x1b4>
					ni=arr_add[l].end-i;
  8019fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019fe:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a08:	29 c2                	sub    %eax,%edx
  801a0a:	89 d0                	mov    %edx,%eax
  801a0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801a0f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801a16:	eb 0d                	jmp    801a25 <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801a18:	ff 45 d0             	incl   -0x30(%ebp)
  801a1b:	a1 28 30 80 00       	mov    0x803028,%eax
  801a20:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a23:	7c c0                	jl     8019e5 <malloc+0x181>
					break;

				}
			}

			if(f){
  801a25:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a29:	75 1d                	jne    801a48 <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  801a2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a35:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801a38:	a1 04 30 80 00       	mov    0x803004,%eax
  801a3d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a40:	0f 8c bd fe ff ff    	jl     801903 <malloc+0x9f>
  801a46:	eb 01                	jmp    801a49 <malloc+0x1e5>

				}
			}

			if(f){
				break;
  801a48:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a4d:	75 7a                	jne    801ac9 <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801a4f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	01 d0                	add    %edx,%eax
  801a5a:	48                   	dec    %eax
  801a5b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801a60:	7c 0a                	jl     801a6c <malloc+0x208>
			return NULL;
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	e9 a4 02 00 00       	jmp    801d10 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  801a6c:	a1 04 30 80 00       	mov    0x803004,%eax
  801a71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801a74:	a1 28 30 80 00       	mov    0x803028,%eax
  801a79:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801a7c:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801a83:	83 ec 08             	sub    $0x8,%esp
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	ff 75 a4             	pushl  -0x5c(%ebp)
  801a8c:	e8 04 06 00 00       	call   802095 <sys_allocateMem>
  801a91:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801a94:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	01 d0                	add    %edx,%eax
  801a9f:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801aa4:	a1 28 30 80 00       	mov    0x803028,%eax
  801aa9:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801aaf:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801ab6:	a1 28 30 80 00       	mov    0x803028,%eax
  801abb:	40                   	inc    %eax
  801abc:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801ac1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ac4:	e9 47 02 00 00       	jmp    801d10 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  801ac9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801ad0:	e9 ac 00 00 00       	jmp    801b81 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801ad5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801ad8:	89 d0                	mov    %edx,%eax
  801ada:	01 c0                	add    %eax,%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	c1 e0 02             	shl    $0x2,%eax
  801ae1:	05 24 31 80 00       	add    $0x803124,%eax
  801ae6:	8b 00                	mov    (%eax),%eax
  801ae8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801aeb:	eb 7e                	jmp    801b6b <malloc+0x307>
			int flag=0;
  801aed:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801af4:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801afb:	eb 57                	jmp    801b54 <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b00:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801b07:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b0a:	39 c2                	cmp    %eax,%edx
  801b0c:	77 1a                	ja     801b28 <malloc+0x2c4>
  801b0e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b11:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801b18:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b1b:	39 c2                	cmp    %eax,%edx
  801b1d:	76 09                	jbe    801b28 <malloc+0x2c4>
								flag=1;
  801b1f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801b26:	eb 36                	jmp    801b5e <malloc+0x2fa>
			arr[i].space++;
  801b28:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b2b:	89 d0                	mov    %edx,%eax
  801b2d:	01 c0                	add    %eax,%eax
  801b2f:	01 d0                	add    %edx,%eax
  801b31:	c1 e0 02             	shl    $0x2,%eax
  801b34:	05 28 31 80 00       	add    $0x803128,%eax
  801b39:	8b 00                	mov    (%eax),%eax
  801b3b:	8d 48 01             	lea    0x1(%eax),%ecx
  801b3e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	01 c0                	add    %eax,%eax
  801b45:	01 d0                	add    %edx,%eax
  801b47:	c1 e0 02             	shl    $0x2,%eax
  801b4a:	05 28 31 80 00       	add    $0x803128,%eax
  801b4f:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801b51:	ff 45 c0             	incl   -0x40(%ebp)
  801b54:	a1 28 30 80 00       	mov    0x803028,%eax
  801b59:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801b5c:	7c 9f                	jl     801afd <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801b5e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801b62:	75 19                	jne    801b7d <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801b64:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801b6b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b6e:	a1 04 30 80 00       	mov    0x803004,%eax
  801b73:	39 c2                	cmp    %eax,%edx
  801b75:	0f 82 72 ff ff ff    	jb     801aed <malloc+0x289>
  801b7b:	eb 01                	jmp    801b7e <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801b7d:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801b7e:	ff 45 cc             	incl   -0x34(%ebp)
  801b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b84:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b87:	0f 8c 48 ff ff ff    	jl     801ad5 <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801b8d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801b94:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801b9b:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801ba2:	eb 37                	jmp    801bdb <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801ba4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	01 c0                	add    %eax,%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c1 e0 02             	shl    $0x2,%eax
  801bb0:	05 28 31 80 00       	add    $0x803128,%eax
  801bb5:	8b 00                	mov    (%eax),%eax
  801bb7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801bba:	7d 1c                	jge    801bd8 <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801bbc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801bbf:	89 d0                	mov    %edx,%eax
  801bc1:	01 c0                	add    %eax,%eax
  801bc3:	01 d0                	add    %edx,%eax
  801bc5:	c1 e0 02             	shl    $0x2,%eax
  801bc8:	05 28 31 80 00       	add    $0x803128,%eax
  801bcd:	8b 00                	mov    (%eax),%eax
  801bcf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801bd2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801bd5:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801bd8:	ff 45 b4             	incl   -0x4c(%ebp)
  801bdb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801bde:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801be1:	7c c1                	jl     801ba4 <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801be3:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801be9:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801bec:	89 c8                	mov    %ecx,%eax
  801bee:	01 c0                	add    %eax,%eax
  801bf0:	01 c8                	add    %ecx,%eax
  801bf2:	c1 e0 02             	shl    $0x2,%eax
  801bf5:	05 20 31 80 00       	add    $0x803120,%eax
  801bfa:	8b 00                	mov    (%eax),%eax
  801bfc:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801c03:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801c09:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801c0c:	89 c8                	mov    %ecx,%eax
  801c0e:	01 c0                	add    %eax,%eax
  801c10:	01 c8                	add    %ecx,%eax
  801c12:	c1 e0 02             	shl    $0x2,%eax
  801c15:	05 24 31 80 00       	add    $0x803124,%eax
  801c1a:	8b 00                	mov    (%eax),%eax
  801c1c:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801c23:	a1 28 30 80 00       	mov    0x803028,%eax
  801c28:	40                   	inc    %eax
  801c29:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801c2e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801c31:	89 d0                	mov    %edx,%eax
  801c33:	01 c0                	add    %eax,%eax
  801c35:	01 d0                	add    %edx,%eax
  801c37:	c1 e0 02             	shl    $0x2,%eax
  801c3a:	05 20 31 80 00       	add    $0x803120,%eax
  801c3f:	8b 00                	mov    (%eax),%eax
  801c41:	83 ec 08             	sub    $0x8,%esp
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	50                   	push   %eax
  801c48:	e8 48 04 00 00       	call   802095 <sys_allocateMem>
  801c4d:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801c50:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801c57:	eb 78                	jmp    801cd1 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801c59:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801c5c:	89 d0                	mov    %edx,%eax
  801c5e:	01 c0                	add    %eax,%eax
  801c60:	01 d0                	add    %edx,%eax
  801c62:	c1 e0 02             	shl    $0x2,%eax
  801c65:	05 20 31 80 00       	add    $0x803120,%eax
  801c6a:	8b 00                	mov    (%eax),%eax
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	50                   	push   %eax
  801c70:	ff 75 b0             	pushl  -0x50(%ebp)
  801c73:	68 b0 2e 80 00       	push   $0x802eb0
  801c78:	e8 5d ee ff ff       	call   800ada <cprintf>
  801c7d:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801c80:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801c83:	89 d0                	mov    %edx,%eax
  801c85:	01 c0                	add    %eax,%eax
  801c87:	01 d0                	add    %edx,%eax
  801c89:	c1 e0 02             	shl    $0x2,%eax
  801c8c:	05 24 31 80 00       	add    $0x803124,%eax
  801c91:	8b 00                	mov    (%eax),%eax
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	50                   	push   %eax
  801c97:	ff 75 b0             	pushl  -0x50(%ebp)
  801c9a:	68 c5 2e 80 00       	push   $0x802ec5
  801c9f:	e8 36 ee ff ff       	call   800ada <cprintf>
  801ca4:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801ca7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801caa:	89 d0                	mov    %edx,%eax
  801cac:	01 c0                	add    %eax,%eax
  801cae:	01 d0                	add    %edx,%eax
  801cb0:	c1 e0 02             	shl    $0x2,%eax
  801cb3:	05 28 31 80 00       	add    $0x803128,%eax
  801cb8:	8b 00                	mov    (%eax),%eax
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	50                   	push   %eax
  801cbe:	ff 75 b0             	pushl  -0x50(%ebp)
  801cc1:	68 d8 2e 80 00       	push   $0x802ed8
  801cc6:	e8 0f ee ff ff       	call   800ada <cprintf>
  801ccb:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801cce:	ff 45 b0             	incl   -0x50(%ebp)
  801cd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801cd4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cd7:	7c 80                	jl     801c59 <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801cd9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801cdc:	89 d0                	mov    %edx,%eax
  801cde:	01 c0                	add    %eax,%eax
  801ce0:	01 d0                	add    %edx,%eax
  801ce2:	c1 e0 02             	shl    $0x2,%eax
  801ce5:	05 20 31 80 00       	add    $0x803120,%eax
  801cea:	8b 00                	mov    (%eax),%eax
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	50                   	push   %eax
  801cf0:	68 ec 2e 80 00       	push   $0x802eec
  801cf5:	e8 e0 ed ff ff       	call   800ada <cprintf>
  801cfa:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801cfd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d00:	89 d0                	mov    %edx,%eax
  801d02:	01 c0                	add    %eax,%eax
  801d04:	01 d0                	add    %edx,%eax
  801d06:	c1 e0 02             	shl    $0x2,%eax
  801d09:	05 20 31 80 00       	add    $0x803120,%eax
  801d0e:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801d1e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d25:	eb 4b                	jmp    801d72 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801d27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2a:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d36:	39 c2                	cmp    %eax,%edx
  801d38:	7f 35                	jg     801d6f <free+0x5d>
  801d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3d:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801d44:	89 c2                	mov    %eax,%edx
  801d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d49:	39 c2                	cmp    %eax,%edx
  801d4b:	7e 22                	jle    801d6f <free+0x5d>
				start=arr_add[i].start;
  801d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d50:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5d:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801d64:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801d6d:	eb 0d                	jmp    801d7c <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801d6f:	ff 45 ec             	incl   -0x14(%ebp)
  801d72:	a1 28 30 80 00       	mov    0x803028,%eax
  801d77:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801d7a:	7c ab                	jl     801d27 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d89:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d90:	29 c2                	sub    %eax,%edx
  801d92:	89 d0                	mov    %edx,%eax
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	50                   	push   %eax
  801d98:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9b:	e8 d9 02 00 00       	call   802079 <sys_freeMem>
  801da0:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801da9:	eb 2d                	jmp    801dd8 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dae:	40                   	inc    %eax
  801daf:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db9:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc3:	40                   	inc    %eax
  801dc4:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dce:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801dd5:	ff 45 e8             	incl   -0x18(%ebp)
  801dd8:	a1 28 30 80 00       	mov    0x803028,%eax
  801ddd:	48                   	dec    %eax
  801dde:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801de1:	7f c8                	jg     801dab <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801de3:	a1 28 30 80 00       	mov    0x803028,%eax
  801de8:	48                   	dec    %eax
  801de9:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801dee:	90                   	nop
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 18             	sub    $0x18,%esp
  801df7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfa:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	68 08 2f 80 00       	push   $0x802f08
  801e05:	68 18 01 00 00       	push   $0x118
  801e0a:	68 2b 2f 80 00       	push   $0x802f2b
  801e0f:	e8 24 ea ff ff       	call   800838 <_panic>

00801e14 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	68 08 2f 80 00       	push   $0x802f08
  801e22:	68 1e 01 00 00       	push   $0x11e
  801e27:	68 2b 2f 80 00       	push   $0x802f2b
  801e2c:	e8 07 ea ff ff       	call   800838 <_panic>

00801e31 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 08 2f 80 00       	push   $0x802f08
  801e3f:	68 24 01 00 00       	push   $0x124
  801e44:	68 2b 2f 80 00       	push   $0x802f2b
  801e49:	e8 ea e9 ff ff       	call   800838 <_panic>

00801e4e <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	68 08 2f 80 00       	push   $0x802f08
  801e5c:	68 29 01 00 00       	push   $0x129
  801e61:	68 2b 2f 80 00       	push   $0x802f2b
  801e66:	e8 cd e9 ff ff       	call   800838 <_panic>

00801e6b <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	68 08 2f 80 00       	push   $0x802f08
  801e79:	68 2f 01 00 00       	push   $0x12f
  801e7e:	68 2b 2f 80 00       	push   $0x802f2b
  801e83:	e8 b0 e9 ff ff       	call   800838 <_panic>

00801e88 <shrink>:
}
void shrink(uint32 newSize)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	68 08 2f 80 00       	push   $0x802f08
  801e96:	68 33 01 00 00       	push   $0x133
  801e9b:	68 2b 2f 80 00       	push   $0x802f2b
  801ea0:	e8 93 e9 ff ff       	call   800838 <_panic>

00801ea5 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	68 08 2f 80 00       	push   $0x802f08
  801eb3:	68 38 01 00 00       	push   $0x138
  801eb8:	68 2b 2f 80 00       	push   $0x802f2b
  801ebd:	e8 76 e9 ff ff       	call   800838 <_panic>

00801ec2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801eda:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801edd:	cd 30                	int    $0x30
  801edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	5b                   	pop    %ebx
  801ee9:	5e                   	pop    %esi
  801eea:	5f                   	pop    %edi
  801eeb:	5d                   	pop    %ebp
  801eec:	c3                   	ret    

00801eed <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ef9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	52                   	push   %edx
  801f05:	ff 75 0c             	pushl  0xc(%ebp)
  801f08:	50                   	push   %eax
  801f09:	6a 00                	push   $0x0
  801f0b:	e8 b2 ff ff ff       	call   801ec2 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	90                   	nop
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 01                	push   $0x1
  801f25:	e8 98 ff ff ff       	call   801ec2 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	50                   	push   %eax
  801f3e:	6a 05                	push   $0x5
  801f40:	e8 7d ff ff ff       	call   801ec2 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 02                	push   $0x2
  801f59:	e8 64 ff ff ff       	call   801ec2 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 03                	push   $0x3
  801f72:	e8 4b ff ff ff       	call   801ec2 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 04                	push   $0x4
  801f8b:	e8 32 ff ff ff       	call   801ec2 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_env_exit>:


void sys_env_exit(void)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 06                	push   $0x6
  801fa4:	e8 19 ff ff ff       	call   801ec2 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	90                   	nop
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	6a 07                	push   $0x7
  801fc2:	e8 fb fe ff ff       	call   801ec2 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	56                   	push   %esi
  801fd0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fd1:	8b 75 18             	mov    0x18(%ebp),%esi
  801fd4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
  801fe2:	51                   	push   %ecx
  801fe3:	52                   	push   %edx
  801fe4:	50                   	push   %eax
  801fe5:	6a 08                	push   $0x8
  801fe7:	e8 d6 fe ff ff       	call   801ec2 <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
}
  801fef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff2:	5b                   	pop    %ebx
  801ff3:	5e                   	pop    %esi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    

00801ff6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ff9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	52                   	push   %edx
  802006:	50                   	push   %eax
  802007:	6a 09                	push   $0x9
  802009:	e8 b4 fe ff ff       	call   801ec2 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	ff 75 0c             	pushl  0xc(%ebp)
  80201f:	ff 75 08             	pushl  0x8(%ebp)
  802022:	6a 0a                	push   $0xa
  802024:	e8 99 fe ff ff       	call   801ec2 <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 0b                	push   $0xb
  80203d:	e8 80 fe ff ff       	call   801ec2 <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 0c                	push   $0xc
  802056:	e8 67 fe ff ff       	call   801ec2 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 0d                	push   $0xd
  80206f:	e8 4e fe ff ff       	call   801ec2 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	ff 75 0c             	pushl  0xc(%ebp)
  802085:	ff 75 08             	pushl  0x8(%ebp)
  802088:	6a 11                	push   $0x11
  80208a:	e8 33 fe ff ff       	call   801ec2 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
	return;
  802092:	90                   	nop
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	ff 75 08             	pushl  0x8(%ebp)
  8020a4:	6a 12                	push   $0x12
  8020a6:	e8 17 fe ff ff       	call   801ec2 <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ae:	90                   	nop
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 0e                	push   $0xe
  8020c0:	e8 fd fd ff ff       	call   801ec2 <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	ff 75 08             	pushl  0x8(%ebp)
  8020d8:	6a 0f                	push   $0xf
  8020da:	e8 e3 fd ff ff       	call   801ec2 <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 10                	push   $0x10
  8020f3:	e8 ca fd ff ff       	call   801ec2 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	90                   	nop
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 14                	push   $0x14
  80210d:	e8 b0 fd ff ff       	call   801ec2 <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
}
  802115:	90                   	nop
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 15                	push   $0x15
  802127:	e8 96 fd ff ff       	call   801ec2 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	90                   	nop
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <sys_cputc>:


void
sys_cputc(const char c)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80213e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	50                   	push   %eax
  80214b:	6a 16                	push   $0x16
  80214d:	e8 70 fd ff ff       	call   801ec2 <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	90                   	nop
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 17                	push   $0x17
  802167:	e8 56 fd ff ff       	call   801ec2 <syscall>
  80216c:	83 c4 18             	add    $0x18,%esp
}
  80216f:	90                   	nop
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	ff 75 0c             	pushl  0xc(%ebp)
  802181:	50                   	push   %eax
  802182:	6a 18                	push   $0x18
  802184:	e8 39 fd ff ff       	call   801ec2 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802191:	8b 55 0c             	mov    0xc(%ebp),%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	6a 1b                	push   $0x1b
  8021a1:	e8 1c fd ff ff       	call   801ec2 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 19                	push   $0x19
  8021be:	e8 ff fc ff ff       	call   801ec2 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	90                   	nop
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	52                   	push   %edx
  8021d9:	50                   	push   %eax
  8021da:	6a 1a                	push   $0x1a
  8021dc:	e8 e1 fc ff ff       	call   801ec2 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	90                   	nop
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	51                   	push   %ecx
  802200:	52                   	push   %edx
  802201:	ff 75 0c             	pushl  0xc(%ebp)
  802204:	50                   	push   %eax
  802205:	6a 1c                	push   $0x1c
  802207:	e8 b6 fc ff ff       	call   801ec2 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802214:	8b 55 0c             	mov    0xc(%ebp),%edx
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	52                   	push   %edx
  802221:	50                   	push   %eax
  802222:	6a 1d                	push   $0x1d
  802224:	e8 99 fc ff ff       	call   801ec2 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802231:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802234:	8b 55 0c             	mov    0xc(%ebp),%edx
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	51                   	push   %ecx
  80223f:	52                   	push   %edx
  802240:	50                   	push   %eax
  802241:	6a 1e                	push   $0x1e
  802243:	e8 7a fc ff ff       	call   801ec2 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802250:	8b 55 0c             	mov    0xc(%ebp),%edx
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	52                   	push   %edx
  80225d:	50                   	push   %eax
  80225e:	6a 1f                	push   $0x1f
  802260:	e8 5d fc ff ff       	call   801ec2 <syscall>
  802265:	83 c4 18             	add    $0x18,%esp
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 20                	push   $0x20
  802279:	e8 44 fc ff ff       	call   801ec2 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	ff 75 14             	pushl  0x14(%ebp)
  80228e:	ff 75 10             	pushl  0x10(%ebp)
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	50                   	push   %eax
  802295:	6a 21                	push   $0x21
  802297:	e8 26 fc ff ff       	call   801ec2 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	50                   	push   %eax
  8022b0:	6a 22                	push   $0x22
  8022b2:	e8 0b fc ff ff       	call   801ec2 <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	90                   	nop
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	50                   	push   %eax
  8022cc:	6a 23                	push   $0x23
  8022ce:	e8 ef fb ff ff       	call   801ec2 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	90                   	nop
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e2:	8d 50 04             	lea    0x4(%eax),%edx
  8022e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	52                   	push   %edx
  8022ef:	50                   	push   %eax
  8022f0:	6a 24                	push   $0x24
  8022f2:	e8 cb fb ff ff       	call   801ec2 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
	return result;
  8022fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802300:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802303:	89 01                	mov    %eax,(%ecx)
  802305:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	c9                   	leave  
  80230c:	c2 04 00             	ret    $0x4

0080230f <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	ff 75 10             	pushl  0x10(%ebp)
  802319:	ff 75 0c             	pushl  0xc(%ebp)
  80231c:	ff 75 08             	pushl  0x8(%ebp)
  80231f:	6a 13                	push   $0x13
  802321:	e8 9c fb ff ff       	call   801ec2 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
	return ;
  802329:	90                   	nop
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_rcr2>:
uint32 sys_rcr2()
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 25                	push   $0x25
  80233b:	e8 82 fb ff ff       	call   801ec2 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 04             	sub    $0x4,%esp
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802351:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	50                   	push   %eax
  80235e:	6a 26                	push   $0x26
  802360:	e8 5d fb ff ff       	call   801ec2 <syscall>
  802365:	83 c4 18             	add    $0x18,%esp
	return ;
  802368:	90                   	nop
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <rsttst>:
void rsttst()
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 28                	push   $0x28
  80237a:	e8 43 fb ff ff       	call   801ec2 <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
	return ;
  802382:	90                   	nop
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 04             	sub    $0x4,%esp
  80238b:	8b 45 14             	mov    0x14(%ebp),%eax
  80238e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802391:	8b 55 18             	mov    0x18(%ebp),%edx
  802394:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802398:	52                   	push   %edx
  802399:	50                   	push   %eax
  80239a:	ff 75 10             	pushl  0x10(%ebp)
  80239d:	ff 75 0c             	pushl  0xc(%ebp)
  8023a0:	ff 75 08             	pushl  0x8(%ebp)
  8023a3:	6a 27                	push   $0x27
  8023a5:	e8 18 fb ff ff       	call   801ec2 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ad:	90                   	nop
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <chktst>:
void chktst(uint32 n)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	ff 75 08             	pushl  0x8(%ebp)
  8023be:	6a 29                	push   $0x29
  8023c0:	e8 fd fa ff ff       	call   801ec2 <syscall>
  8023c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c8:	90                   	nop
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <inctst>:

void inctst()
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 2a                	push   $0x2a
  8023da:	e8 e3 fa ff ff       	call   801ec2 <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e2:	90                   	nop
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <gettst>:
uint32 gettst()
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 2b                	push   $0x2b
  8023f4:	e8 c9 fa ff ff       	call   801ec2 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 2c                	push   $0x2c
  802410:	e8 ad fa ff ff       	call   801ec2 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
  802418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80241b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80241f:	75 07                	jne    802428 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802421:	b8 01 00 00 00       	mov    $0x1,%eax
  802426:	eb 05                	jmp    80242d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 2c                	push   $0x2c
  802441:	e8 7c fa ff ff       	call   801ec2 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
  802449:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80244c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802450:	75 07                	jne    802459 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802452:	b8 01 00 00 00       	mov    $0x1,%eax
  802457:	eb 05                	jmp    80245e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 2c                	push   $0x2c
  802472:	e8 4b fa ff ff       	call   801ec2 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
  80247a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80247d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802481:	75 07                	jne    80248a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802483:	b8 01 00 00 00       	mov    $0x1,%eax
  802488:	eb 05                	jmp    80248f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 2c                	push   $0x2c
  8024a3:	e8 1a fa ff ff       	call   801ec2 <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
  8024ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024ae:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024b2:	75 07                	jne    8024bb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b9:	eb 05                	jmp    8024c0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	ff 75 08             	pushl  0x8(%ebp)
  8024d0:	6a 2d                	push   $0x2d
  8024d2:	e8 eb f9 ff ff       	call   801ec2 <syscall>
  8024d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024da:	90                   	nop
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	6a 00                	push   $0x0
  8024ef:	53                   	push   %ebx
  8024f0:	51                   	push   %ecx
  8024f1:	52                   	push   %edx
  8024f2:	50                   	push   %eax
  8024f3:	6a 2e                	push   $0x2e
  8024f5:	e8 c8 f9 ff ff       	call   801ec2 <syscall>
  8024fa:	83 c4 18             	add    $0x18,%esp
}
  8024fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802505:	8b 55 0c             	mov    0xc(%ebp),%edx
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	52                   	push   %edx
  802512:	50                   	push   %eax
  802513:	6a 2f                	push   $0x2f
  802515:	e8 a8 f9 ff ff       	call   801ec2 <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
}
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    
  80251f:	90                   	nop

00802520 <__udivdi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	53                   	push   %ebx
  802524:	83 ec 1c             	sub    $0x1c,%esp
  802527:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80252b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80252f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802533:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802537:	89 ca                	mov    %ecx,%edx
  802539:	89 f8                	mov    %edi,%eax
  80253b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80253f:	85 f6                	test   %esi,%esi
  802541:	75 2d                	jne    802570 <__udivdi3+0x50>
  802543:	39 cf                	cmp    %ecx,%edi
  802545:	77 65                	ja     8025ac <__udivdi3+0x8c>
  802547:	89 fd                	mov    %edi,%ebp
  802549:	85 ff                	test   %edi,%edi
  80254b:	75 0b                	jne    802558 <__udivdi3+0x38>
  80254d:	b8 01 00 00 00       	mov    $0x1,%eax
  802552:	31 d2                	xor    %edx,%edx
  802554:	f7 f7                	div    %edi
  802556:	89 c5                	mov    %eax,%ebp
  802558:	31 d2                	xor    %edx,%edx
  80255a:	89 c8                	mov    %ecx,%eax
  80255c:	f7 f5                	div    %ebp
  80255e:	89 c1                	mov    %eax,%ecx
  802560:	89 d8                	mov    %ebx,%eax
  802562:	f7 f5                	div    %ebp
  802564:	89 cf                	mov    %ecx,%edi
  802566:	89 fa                	mov    %edi,%edx
  802568:	83 c4 1c             	add    $0x1c,%esp
  80256b:	5b                   	pop    %ebx
  80256c:	5e                   	pop    %esi
  80256d:	5f                   	pop    %edi
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    
  802570:	39 ce                	cmp    %ecx,%esi
  802572:	77 28                	ja     80259c <__udivdi3+0x7c>
  802574:	0f bd fe             	bsr    %esi,%edi
  802577:	83 f7 1f             	xor    $0x1f,%edi
  80257a:	75 40                	jne    8025bc <__udivdi3+0x9c>
  80257c:	39 ce                	cmp    %ecx,%esi
  80257e:	72 0a                	jb     80258a <__udivdi3+0x6a>
  802580:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802584:	0f 87 9e 00 00 00    	ja     802628 <__udivdi3+0x108>
  80258a:	b8 01 00 00 00       	mov    $0x1,%eax
  80258f:	89 fa                	mov    %edi,%edx
  802591:	83 c4 1c             	add    $0x1c,%esp
  802594:	5b                   	pop    %ebx
  802595:	5e                   	pop    %esi
  802596:	5f                   	pop    %edi
  802597:	5d                   	pop    %ebp
  802598:	c3                   	ret    
  802599:	8d 76 00             	lea    0x0(%esi),%esi
  80259c:	31 ff                	xor    %edi,%edi
  80259e:	31 c0                	xor    %eax,%eax
  8025a0:	89 fa                	mov    %edi,%edx
  8025a2:	83 c4 1c             	add    $0x1c,%esp
  8025a5:	5b                   	pop    %ebx
  8025a6:	5e                   	pop    %esi
  8025a7:	5f                   	pop    %edi
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    
  8025aa:	66 90                	xchg   %ax,%ax
  8025ac:	89 d8                	mov    %ebx,%eax
  8025ae:	f7 f7                	div    %edi
  8025b0:	31 ff                	xor    %edi,%edi
  8025b2:	89 fa                	mov    %edi,%edx
  8025b4:	83 c4 1c             	add    $0x1c,%esp
  8025b7:	5b                   	pop    %ebx
  8025b8:	5e                   	pop    %esi
  8025b9:	5f                   	pop    %edi
  8025ba:	5d                   	pop    %ebp
  8025bb:	c3                   	ret    
  8025bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025c1:	89 eb                	mov    %ebp,%ebx
  8025c3:	29 fb                	sub    %edi,%ebx
  8025c5:	89 f9                	mov    %edi,%ecx
  8025c7:	d3 e6                	shl    %cl,%esi
  8025c9:	89 c5                	mov    %eax,%ebp
  8025cb:	88 d9                	mov    %bl,%cl
  8025cd:	d3 ed                	shr    %cl,%ebp
  8025cf:	89 e9                	mov    %ebp,%ecx
  8025d1:	09 f1                	or     %esi,%ecx
  8025d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025d7:	89 f9                	mov    %edi,%ecx
  8025d9:	d3 e0                	shl    %cl,%eax
  8025db:	89 c5                	mov    %eax,%ebp
  8025dd:	89 d6                	mov    %edx,%esi
  8025df:	88 d9                	mov    %bl,%cl
  8025e1:	d3 ee                	shr    %cl,%esi
  8025e3:	89 f9                	mov    %edi,%ecx
  8025e5:	d3 e2                	shl    %cl,%edx
  8025e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025eb:	88 d9                	mov    %bl,%cl
  8025ed:	d3 e8                	shr    %cl,%eax
  8025ef:	09 c2                	or     %eax,%edx
  8025f1:	89 d0                	mov    %edx,%eax
  8025f3:	89 f2                	mov    %esi,%edx
  8025f5:	f7 74 24 0c          	divl   0xc(%esp)
  8025f9:	89 d6                	mov    %edx,%esi
  8025fb:	89 c3                	mov    %eax,%ebx
  8025fd:	f7 e5                	mul    %ebp
  8025ff:	39 d6                	cmp    %edx,%esi
  802601:	72 19                	jb     80261c <__udivdi3+0xfc>
  802603:	74 0b                	je     802610 <__udivdi3+0xf0>
  802605:	89 d8                	mov    %ebx,%eax
  802607:	31 ff                	xor    %edi,%edi
  802609:	e9 58 ff ff ff       	jmp    802566 <__udivdi3+0x46>
  80260e:	66 90                	xchg   %ax,%ax
  802610:	8b 54 24 08          	mov    0x8(%esp),%edx
  802614:	89 f9                	mov    %edi,%ecx
  802616:	d3 e2                	shl    %cl,%edx
  802618:	39 c2                	cmp    %eax,%edx
  80261a:	73 e9                	jae    802605 <__udivdi3+0xe5>
  80261c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80261f:	31 ff                	xor    %edi,%edi
  802621:	e9 40 ff ff ff       	jmp    802566 <__udivdi3+0x46>
  802626:	66 90                	xchg   %ax,%ax
  802628:	31 c0                	xor    %eax,%eax
  80262a:	e9 37 ff ff ff       	jmp    802566 <__udivdi3+0x46>
  80262f:	90                   	nop

00802630 <__umoddi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	53                   	push   %ebx
  802634:	83 ec 1c             	sub    $0x1c,%esp
  802637:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80263b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80263f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802643:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802647:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80264b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80264f:	89 f3                	mov    %esi,%ebx
  802651:	89 fa                	mov    %edi,%edx
  802653:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802657:	89 34 24             	mov    %esi,(%esp)
  80265a:	85 c0                	test   %eax,%eax
  80265c:	75 1a                	jne    802678 <__umoddi3+0x48>
  80265e:	39 f7                	cmp    %esi,%edi
  802660:	0f 86 a2 00 00 00    	jbe    802708 <__umoddi3+0xd8>
  802666:	89 c8                	mov    %ecx,%eax
  802668:	89 f2                	mov    %esi,%edx
  80266a:	f7 f7                	div    %edi
  80266c:	89 d0                	mov    %edx,%eax
  80266e:	31 d2                	xor    %edx,%edx
  802670:	83 c4 1c             	add    $0x1c,%esp
  802673:	5b                   	pop    %ebx
  802674:	5e                   	pop    %esi
  802675:	5f                   	pop    %edi
  802676:	5d                   	pop    %ebp
  802677:	c3                   	ret    
  802678:	39 f0                	cmp    %esi,%eax
  80267a:	0f 87 ac 00 00 00    	ja     80272c <__umoddi3+0xfc>
  802680:	0f bd e8             	bsr    %eax,%ebp
  802683:	83 f5 1f             	xor    $0x1f,%ebp
  802686:	0f 84 ac 00 00 00    	je     802738 <__umoddi3+0x108>
  80268c:	bf 20 00 00 00       	mov    $0x20,%edi
  802691:	29 ef                	sub    %ebp,%edi
  802693:	89 fe                	mov    %edi,%esi
  802695:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802699:	89 e9                	mov    %ebp,%ecx
  80269b:	d3 e0                	shl    %cl,%eax
  80269d:	89 d7                	mov    %edx,%edi
  80269f:	89 f1                	mov    %esi,%ecx
  8026a1:	d3 ef                	shr    %cl,%edi
  8026a3:	09 c7                	or     %eax,%edi
  8026a5:	89 e9                	mov    %ebp,%ecx
  8026a7:	d3 e2                	shl    %cl,%edx
  8026a9:	89 14 24             	mov    %edx,(%esp)
  8026ac:	89 d8                	mov    %ebx,%eax
  8026ae:	d3 e0                	shl    %cl,%eax
  8026b0:	89 c2                	mov    %eax,%edx
  8026b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b6:	d3 e0                	shl    %cl,%eax
  8026b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026c0:	89 f1                	mov    %esi,%ecx
  8026c2:	d3 e8                	shr    %cl,%eax
  8026c4:	09 d0                	or     %edx,%eax
  8026c6:	d3 eb                	shr    %cl,%ebx
  8026c8:	89 da                	mov    %ebx,%edx
  8026ca:	f7 f7                	div    %edi
  8026cc:	89 d3                	mov    %edx,%ebx
  8026ce:	f7 24 24             	mull   (%esp)
  8026d1:	89 c6                	mov    %eax,%esi
  8026d3:	89 d1                	mov    %edx,%ecx
  8026d5:	39 d3                	cmp    %edx,%ebx
  8026d7:	0f 82 87 00 00 00    	jb     802764 <__umoddi3+0x134>
  8026dd:	0f 84 91 00 00 00    	je     802774 <__umoddi3+0x144>
  8026e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026e7:	29 f2                	sub    %esi,%edx
  8026e9:	19 cb                	sbb    %ecx,%ebx
  8026eb:	89 d8                	mov    %ebx,%eax
  8026ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026f1:	d3 e0                	shl    %cl,%eax
  8026f3:	89 e9                	mov    %ebp,%ecx
  8026f5:	d3 ea                	shr    %cl,%edx
  8026f7:	09 d0                	or     %edx,%eax
  8026f9:	89 e9                	mov    %ebp,%ecx
  8026fb:	d3 eb                	shr    %cl,%ebx
  8026fd:	89 da                	mov    %ebx,%edx
  8026ff:	83 c4 1c             	add    $0x1c,%esp
  802702:	5b                   	pop    %ebx
  802703:	5e                   	pop    %esi
  802704:	5f                   	pop    %edi
  802705:	5d                   	pop    %ebp
  802706:	c3                   	ret    
  802707:	90                   	nop
  802708:	89 fd                	mov    %edi,%ebp
  80270a:	85 ff                	test   %edi,%edi
  80270c:	75 0b                	jne    802719 <__umoddi3+0xe9>
  80270e:	b8 01 00 00 00       	mov    $0x1,%eax
  802713:	31 d2                	xor    %edx,%edx
  802715:	f7 f7                	div    %edi
  802717:	89 c5                	mov    %eax,%ebp
  802719:	89 f0                	mov    %esi,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f5                	div    %ebp
  80271f:	89 c8                	mov    %ecx,%eax
  802721:	f7 f5                	div    %ebp
  802723:	89 d0                	mov    %edx,%eax
  802725:	e9 44 ff ff ff       	jmp    80266e <__umoddi3+0x3e>
  80272a:	66 90                	xchg   %ax,%ax
  80272c:	89 c8                	mov    %ecx,%eax
  80272e:	89 f2                	mov    %esi,%edx
  802730:	83 c4 1c             	add    $0x1c,%esp
  802733:	5b                   	pop    %ebx
  802734:	5e                   	pop    %esi
  802735:	5f                   	pop    %edi
  802736:	5d                   	pop    %ebp
  802737:	c3                   	ret    
  802738:	3b 04 24             	cmp    (%esp),%eax
  80273b:	72 06                	jb     802743 <__umoddi3+0x113>
  80273d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802741:	77 0f                	ja     802752 <__umoddi3+0x122>
  802743:	89 f2                	mov    %esi,%edx
  802745:	29 f9                	sub    %edi,%ecx
  802747:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80274b:	89 14 24             	mov    %edx,(%esp)
  80274e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802752:	8b 44 24 04          	mov    0x4(%esp),%eax
  802756:	8b 14 24             	mov    (%esp),%edx
  802759:	83 c4 1c             	add    $0x1c,%esp
  80275c:	5b                   	pop    %ebx
  80275d:	5e                   	pop    %esi
  80275e:	5f                   	pop    %edi
  80275f:	5d                   	pop    %ebp
  802760:	c3                   	ret    
  802761:	8d 76 00             	lea    0x0(%esi),%esi
  802764:	2b 04 24             	sub    (%esp),%eax
  802767:	19 fa                	sbb    %edi,%edx
  802769:	89 d1                	mov    %edx,%ecx
  80276b:	89 c6                	mov    %eax,%esi
  80276d:	e9 71 ff ff ff       	jmp    8026e3 <__umoddi3+0xb3>
  802772:	66 90                	xchg   %ax,%ax
  802774:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802778:	72 ea                	jb     802764 <__umoddi3+0x134>
  80277a:	89 d9                	mov    %ebx,%ecx
  80277c:	e9 62 ff ff ff       	jmp    8026e3 <__umoddi3+0xb3>
