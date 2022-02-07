
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 08 16 00 00       	call   80163e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 01 00 00    	sub    $0x140,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
//				fullWS = 0;
//				break;
//			}
//		}

		cprintf("PWS size = %d\n",LIST_SIZE(&(myEnv->PageWorkingSetList)) );
  800047:	a1 20 40 80 00       	mov    0x804020,%eax
  80004c:	8b 80 9c 3c 01 00    	mov    0x13c9c(%eax),%eax
  800052:	83 ec 08             	sub    $0x8,%esp
  800055:	50                   	push   %eax
  800056:	68 e0 36 80 00       	push   $0x8036e0
  80005b:	e8 c5 19 00 00       	call   801a25 <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
		if (LIST_SIZE(&(myEnv->PageWorkingSetList)) > 0)
  800063:	a1 20 40 80 00       	mov    0x804020,%eax
  800068:	8b 80 9c 3c 01 00    	mov    0x13c9c(%eax),%eax
  80006e:	85 c0                	test   %eax,%eax
  800070:	74 04                	je     800076 <_main+0x3e>
		{
			fullWS = 0;
  800072:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		}
		if (fullWS) panic("Please increase the WS size");
  800076:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80007a:	74 14                	je     800090 <_main+0x58>
  80007c:	83 ec 04             	sub    $0x4,%esp
  80007f:	68 ef 36 80 00       	push   $0x8036ef
  800084:	6a 20                	push   $0x20
  800086:	68 0b 37 80 00       	push   $0x80370b
  80008b:	e8 f3 16 00 00       	call   801783 <_panic>
	}



	int Mega = 1024*1024;
  800090:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  800097:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  80009e:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  8000a2:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  8000a6:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  8000ac:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  8000b2:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000b9:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	char *byteArr, *byteArr2 , *byteArr3;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000c0:	e8 b4 2e 00 00       	call   802f79 <sys_calculate_free_frames>
  8000c5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	int toAccess = 800 - LIST_SIZE(&myEnv->ActiveList) - 8;
  8000c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8000cd:	8b 80 ac 3c 01 00    	mov    0x13cac(%eax),%eax
  8000d3:	ba 18 03 00 00       	mov    $0x318,%edx
  8000d8:	29 c2                	sub    %eax,%edx
  8000da:	89 d0                	mov    %edx,%eax
  8000dc:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	void* ptr_allocations[20] = {0};
  8000df:	8d 95 c8 fe ff ff    	lea    -0x138(%ebp),%edx
  8000e5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	89 d7                	mov    %edx,%edi
  8000f1:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000f3:	e8 04 2f 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8000f8:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000fe:	01 c0                	add    %eax,%eax
  800100:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	50                   	push   %eax
  800107:	e8 a3 26 00 00       	call   8027af <malloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800115:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  80011b:	85 c0                	test   %eax,%eax
  80011d:	79 0d                	jns    80012c <_main+0xf4>
  80011f:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800125:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  80012a:	76 14                	jbe    800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 20 37 80 00       	push   $0x803720
  800134:	6a 3b                	push   $0x3b
  800136:	68 0b 37 80 00       	push   $0x80370b
  80013b:	e8 43 16 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800140:	e8 b7 2e 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800145:	2b 45 c0             	sub    -0x40(%ebp),%eax
  800148:	3d 00 02 00 00       	cmp    $0x200,%eax
  80014d:	74 14                	je     800163 <_main+0x12b>
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	68 88 37 80 00       	push   $0x803788
  800157:	6a 3c                	push   $0x3c
  800159:	68 0b 37 80 00       	push   $0x80370b
  80015e:	e8 20 16 00 00       	call   801783 <_panic>
		int freeFrames = sys_calculate_free_frames() ;
  800163:	e8 11 2e 00 00       	call   802f79 <sys_calculate_free_frames>
  800168:	89 45 bc             	mov    %eax,-0x44(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016e:	01 c0                	add    %eax,%eax
  800170:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800173:	48                   	dec    %eax
  800174:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr = (char *) ptr_allocations[0];
  800177:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  80017d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		byteArr[0] = minByte ;
  800180:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800183:	8a 55 db             	mov    -0x25(%ebp),%dl
  800186:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800188:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80018b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80018e:	01 c2                	add    %eax,%edx
  800190:	8a 45 da             	mov    -0x26(%ebp),%al
  800193:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800195:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800198:	e8 dc 2d 00 00       	call   802f79 <sys_calculate_free_frames>
  80019d:	29 c3                	sub    %eax,%ebx
  80019f:	89 d8                	mov    %ebx,%eax
  8001a1:	83 f8 03             	cmp    $0x3,%eax
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 b8 37 80 00       	push   $0x8037b8
  8001ae:	6a 42                	push   $0x42
  8001b0:	68 0b 37 80 00       	push   $0x80370b
  8001b5:	e8 c9 15 00 00       	call   801783 <_panic>
		int var;
		int found = 0;
  8001ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001c8:	eb 76                	jmp    800240 <_main+0x208>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001d8:	c1 e2 04             	shl    $0x4,%edx
  8001db:	01 d0                	add    %edx,%eax
  8001dd:	8b 00                	mov    (%eax),%eax
  8001df:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ea:	89 c2                	mov    %eax,%edx
  8001ec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001ef:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001f2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	75 03                	jne    800201 <_main+0x1c9>
				found++;
  8001fe:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800201:	a1 20 40 80 00       	mov    0x804020,%eax
  800206:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80020c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80020f:	c1 e2 04             	shl    $0x4,%edx
  800212:	01 d0                	add    %edx,%eax
  800214:	8b 00                	mov    (%eax),%eax
  800216:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800219:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80021c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800221:	89 c1                	mov    %eax,%ecx
  800223:	8b 55 b8             	mov    -0x48(%ebp),%edx
  800226:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800229:	01 d0                	add    %edx,%eax
  80022b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80022e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800231:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800236:	39 c1                	cmp    %eax,%ecx
  800238:	75 03                	jne    80023d <_main+0x205>
				found++;
  80023a:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;

		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80023d:	ff 45 ec             	incl   -0x14(%ebp)
  800240:	a1 20 40 80 00       	mov    0x804020,%eax
  800245:	8b 50 74             	mov    0x74(%eax),%edx
  800248:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80024b:	39 c2                	cmp    %eax,%edx
  80024d:	0f 87 77 ff ff ff    	ja     8001ca <_main+0x192>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800253:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800257:	74 14                	je     80026d <_main+0x235>
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	68 fc 37 80 00       	push   $0x8037fc
  800261:	6a 4d                	push   $0x4d
  800263:	68 0b 37 80 00       	push   $0x80370b
  800268:	e8 16 15 00 00       	call   801783 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80026d:	e8 8a 2d 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800272:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800275:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800278:	01 c0                	add    %eax,%eax
  80027a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	50                   	push   %eax
  800281:	e8 29 25 00 00       	call   8027af <malloc>
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80028f:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80029a:	01 c0                	add    %eax,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c2                	cmp    %eax,%edx
  8002a3:	72 16                	jb     8002bb <_main+0x283>
  8002a5:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8002ab:	89 c2                	mov    %eax,%edx
  8002ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b0:	01 c0                	add    %eax,%eax
  8002b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002b7:	39 c2                	cmp    %eax,%edx
  8002b9:	76 14                	jbe    8002cf <_main+0x297>
  8002bb:	83 ec 04             	sub    $0x4,%esp
  8002be:	68 20 37 80 00       	push   $0x803720
  8002c3:	6a 52                	push   $0x52
  8002c5:	68 0b 37 80 00       	push   $0x80370b
  8002ca:	e8 b4 14 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8002cf:	e8 28 2d 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8002d4:	2b 45 c0             	sub    -0x40(%ebp),%eax
  8002d7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002dc:	74 14                	je     8002f2 <_main+0x2ba>
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	68 88 37 80 00       	push   $0x803788
  8002e6:	6a 53                	push   $0x53
  8002e8:	68 0b 37 80 00       	push   $0x80370b
  8002ed:	e8 91 14 00 00       	call   801783 <_panic>
		freeFrames = sys_calculate_free_frames() ;
  8002f2:	e8 82 2c 00 00       	call   802f79 <sys_calculate_free_frames>
  8002f7:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr = (short *) ptr_allocations[1];
  8002fa:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800300:	89 45 a0             	mov    %eax,-0x60(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800306:	01 c0                	add    %eax,%eax
  800308:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80030b:	d1 e8                	shr    %eax
  80030d:	48                   	dec    %eax
  80030e:	89 45 9c             	mov    %eax,-0x64(%ebp)
		shortArr[0] = minShort;
  800311:	8b 55 a0             	mov    -0x60(%ebp),%edx
  800314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800317:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  80031a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80031d:	01 c0                	add    %eax,%eax
  80031f:	89 c2                	mov    %eax,%edx
  800321:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800324:	01 c2                	add    %eax,%edx
  800326:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  80032a:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80032d:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800330:	e8 44 2c 00 00       	call   802f79 <sys_calculate_free_frames>
  800335:	29 c3                	sub    %eax,%ebx
  800337:	89 d8                	mov    %ebx,%eax
  800339:	83 f8 02             	cmp    $0x2,%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 b8 37 80 00       	push   $0x8037b8
  800346:	6a 59                	push   $0x59
  800348:	68 0b 37 80 00       	push   $0x80370b
  80034d:	e8 31 14 00 00       	call   801783 <_panic>
		found = 0;
  800352:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800359:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800360:	eb 7a                	jmp    8003dc <_main+0x3a4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800362:	a1 20 40 80 00       	mov    0x804020,%eax
  800367:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80036d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800370:	c1 e2 04             	shl    $0x4,%edx
  800373:	01 d0                	add    %edx,%eax
  800375:	8b 00                	mov    (%eax),%eax
  800377:	89 45 98             	mov    %eax,-0x68(%ebp)
  80037a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80037d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800387:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80038a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	39 c2                	cmp    %eax,%edx
  800394:	75 03                	jne    800399 <_main+0x361>
				found++;
  800396:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800399:	a1 20 40 80 00       	mov    0x804020,%eax
  80039e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a7:	c1 e2 04             	shl    $0x4,%edx
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b9:	89 c2                	mov    %eax,%edx
  8003bb:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003be:	01 c0                	add    %eax,%eax
  8003c0:	89 c1                	mov    %eax,%ecx
  8003c2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8003ca:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d2:	39 c2                	cmp    %eax,%edx
  8003d4:	75 03                	jne    8003d9 <_main+0x3a1>
				found++;
  8003d6:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003d9:	ff 45 ec             	incl   -0x14(%ebp)
  8003dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e1:	8b 50 74             	mov    0x74(%eax),%edx
  8003e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e7:	39 c2                	cmp    %eax,%edx
  8003e9:	0f 87 73 ff ff ff    	ja     800362 <_main+0x32a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8003ef:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8003f3:	74 14                	je     800409 <_main+0x3d1>
  8003f5:	83 ec 04             	sub    $0x4,%esp
  8003f8:	68 fc 37 80 00       	push   $0x8037fc
  8003fd:	6a 62                	push   $0x62
  8003ff:	68 0b 37 80 00       	push   $0x80370b
  800404:	e8 7a 13 00 00       	call   801783 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800409:	e8 ee 2b 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  80040e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800411:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800414:	89 c2                	mov    %eax,%edx
  800416:	01 d2                	add    %edx,%edx
  800418:	01 d0                	add    %edx,%eax
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	50                   	push   %eax
  80041e:	e8 8c 23 00 00       	call   8027af <malloc>
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80042c:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800437:	c1 e0 02             	shl    $0x2,%eax
  80043a:	05 00 00 00 80       	add    $0x80000000,%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	72 17                	jb     80045a <_main+0x422>
  800443:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  800449:	89 c2                	mov    %eax,%edx
  80044b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044e:	c1 e0 02             	shl    $0x2,%eax
  800451:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800456:	39 c2                	cmp    %eax,%edx
  800458:	76 14                	jbe    80046e <_main+0x436>
  80045a:	83 ec 04             	sub    $0x4,%esp
  80045d:	68 20 37 80 00       	push   $0x803720
  800462:	6a 67                	push   $0x67
  800464:	68 0b 37 80 00       	push   $0x80370b
  800469:	e8 15 13 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80046e:	e8 89 2b 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800473:	2b 45 c0             	sub    -0x40(%ebp),%eax
  800476:	83 f8 01             	cmp    $0x1,%eax
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 88 37 80 00       	push   $0x803788
  800483:	6a 68                	push   $0x68
  800485:	68 0b 37 80 00       	push   $0x80370b
  80048a:	e8 f4 12 00 00       	call   801783 <_panic>
		freeFrames = sys_calculate_free_frames() ;
  80048f:	e8 e5 2a 00 00       	call   802f79 <sys_calculate_free_frames>
  800494:	89 45 bc             	mov    %eax,-0x44(%ebp)
		intArr = (int *) ptr_allocations[2];
  800497:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80049d:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfInt = (3*kilo)/sizeof(int) - 1;
  8004a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a3:	89 c2                	mov    %eax,%edx
  8004a5:	01 d2                	add    %edx,%edx
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	c1 e8 02             	shr    $0x2,%eax
  8004ac:	48                   	dec    %eax
  8004ad:	89 45 84             	mov    %eax,-0x7c(%ebp)
		intArr[0] = minInt;
  8004b0:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004b3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004b6:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004b8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8004bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c2:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004c5:	01 c2                	add    %eax,%edx
  8004c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ca:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004cc:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8004cf:	e8 a5 2a 00 00       	call   802f79 <sys_calculate_free_frames>
  8004d4:	29 c3                	sub    %eax,%ebx
  8004d6:	89 d8                	mov    %ebx,%eax
  8004d8:	83 f8 02             	cmp    $0x2,%eax
  8004db:	74 14                	je     8004f1 <_main+0x4b9>
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	68 b8 37 80 00       	push   $0x8037b8
  8004e5:	6a 6e                	push   $0x6e
  8004e7:	68 0b 37 80 00       	push   $0x80370b
  8004ec:	e8 92 12 00 00       	call   801783 <_panic>
		found = 0;
  8004f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8004f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8004ff:	e9 8f 00 00 00       	jmp    800593 <_main+0x55b>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80050f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800512:	c1 e2 04             	shl    $0x4,%edx
  800515:	01 d0                	add    %edx,%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	89 45 80             	mov    %eax,-0x80(%ebp)
  80051c:	8b 45 80             	mov    -0x80(%ebp),%eax
  80051f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800524:	89 c2                	mov    %eax,%edx
  800526:	8b 45 88             	mov    -0x78(%ebp),%eax
  800529:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80052f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800535:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053a:	39 c2                	cmp    %eax,%edx
  80053c:	75 03                	jne    800541 <_main+0x509>
				found++;
  80053e:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800541:	a1 20 40 80 00       	mov    0x804020,%eax
  800546:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80054c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80054f:	c1 e2 04             	shl    $0x4,%edx
  800552:	01 d0                	add    %edx,%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  80055c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800562:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800567:	89 c2                	mov    %eax,%edx
  800569:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80056c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800573:	8b 45 88             	mov    -0x78(%ebp),%eax
  800576:	01 c8                	add    %ecx,%eax
  800578:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80057e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800584:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800589:	39 c2                	cmp    %eax,%edx
  80058b:	75 03                	jne    800590 <_main+0x558>
				found++;
  80058d:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (3*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800590:	ff 45 ec             	incl   -0x14(%ebp)
  800593:	a1 20 40 80 00       	mov    0x804020,%eax
  800598:	8b 50 74             	mov    0x74(%eax),%edx
  80059b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	0f 87 5e ff ff ff    	ja     800504 <_main+0x4cc>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005a6:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 fc 37 80 00       	push   $0x8037fc
  8005b4:	6a 77                	push   $0x77
  8005b6:	68 0b 37 80 00       	push   $0x80370b
  8005bb:	e8 c3 11 00 00       	call   801783 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005c0:	e8 b4 29 00 00       	call   802f79 <sys_calculate_free_frames>
  8005c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005c8:	e8 2f 2a 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8005cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d3:	89 c2                	mov    %eax,%edx
  8005d5:	01 d2                	add    %edx,%edx
  8005d7:	01 d0                	add    %edx,%eax
  8005d9:	83 ec 0c             	sub    $0xc,%esp
  8005dc:	50                   	push   %eax
  8005dd:	e8 cd 21 00 00       	call   8027af <malloc>
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005eb:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8005f1:	89 c2                	mov    %eax,%edx
  8005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f6:	c1 e0 02             	shl    $0x2,%eax
  8005f9:	89 c1                	mov    %eax,%ecx
  8005fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005fe:	c1 e0 02             	shl    $0x2,%eax
  800601:	01 c8                	add    %ecx,%eax
  800603:	05 00 00 00 80       	add    $0x80000000,%eax
  800608:	39 c2                	cmp    %eax,%edx
  80060a:	72 21                	jb     80062d <_main+0x5f5>
  80060c:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	c1 e0 02             	shl    $0x2,%eax
  80061a:	89 c1                	mov    %eax,%ecx
  80061c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061f:	c1 e0 02             	shl    $0x2,%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800629:	39 c2                	cmp    %eax,%edx
  80062b:	76 14                	jbe    800641 <_main+0x609>
  80062d:	83 ec 04             	sub    $0x4,%esp
  800630:	68 20 37 80 00       	push   $0x803720
  800635:	6a 7d                	push   $0x7d
  800637:	68 0b 37 80 00       	push   $0x80370b
  80063c:	e8 42 11 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800641:	e8 b6 29 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800646:	2b 45 c0             	sub    -0x40(%ebp),%eax
  800649:	83 f8 01             	cmp    $0x1,%eax
  80064c:	74 14                	je     800662 <_main+0x62a>
  80064e:	83 ec 04             	sub    $0x4,%esp
  800651:	68 88 37 80 00       	push   $0x803788
  800656:	6a 7e                	push   $0x7e
  800658:	68 0b 37 80 00       	push   $0x80370b
  80065d:	e8 21 11 00 00       	call   801783 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800662:	e8 95 29 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800667:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80066a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	50                   	push   %eax
  80067b:	e8 2f 21 00 00       	call   8027af <malloc>
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800689:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  80068f:	89 c2                	mov    %eax,%edx
  800691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800694:	c1 e0 02             	shl    $0x2,%eax
  800697:	89 c1                	mov    %eax,%ecx
  800699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80069c:	c1 e0 03             	shl    $0x3,%eax
  80069f:	01 c8                	add    %ecx,%eax
  8006a1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	72 21                	jb     8006cb <_main+0x693>
  8006aa:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8006b0:	89 c2                	mov    %eax,%edx
  8006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b5:	c1 e0 02             	shl    $0x2,%eax
  8006b8:	89 c1                	mov    %eax,%ecx
  8006ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006bd:	c1 e0 03             	shl    $0x3,%eax
  8006c0:	01 c8                	add    %ecx,%eax
  8006c2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006c7:	39 c2                	cmp    %eax,%edx
  8006c9:	76 17                	jbe    8006e2 <_main+0x6aa>
  8006cb:	83 ec 04             	sub    $0x4,%esp
  8006ce:	68 20 37 80 00       	push   $0x803720
  8006d3:	68 84 00 00 00       	push   $0x84
  8006d8:	68 0b 37 80 00       	push   $0x80370b
  8006dd:	e8 a1 10 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8006e2:	e8 15 29 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8006e7:	2b 45 c0             	sub    -0x40(%ebp),%eax
  8006ea:	83 f8 02             	cmp    $0x2,%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 88 37 80 00       	push   $0x803788
  8006f7:	68 85 00 00 00       	push   $0x85
  8006fc:	68 0b 37 80 00       	push   $0x80370b
  800701:	e8 7d 10 00 00       	call   801783 <_panic>
		freeFrames = sys_calculate_free_frames() ;
  800706:	e8 6e 28 00 00       	call   802f79 <sys_calculate_free_frames>
  80070b:	89 45 bc             	mov    %eax,-0x44(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80070e:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800714:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  80071a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80071d:	89 d0                	mov    %edx,%eax
  80071f:	01 c0                	add    %eax,%eax
  800721:	01 d0                	add    %edx,%eax
  800723:	01 c0                	add    %eax,%eax
  800725:	01 d0                	add    %edx,%eax
  800727:	c1 e8 03             	shr    $0x3,%eax
  80072a:	48                   	dec    %eax
  80072b:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800731:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800737:	8a 55 db             	mov    -0x25(%ebp),%dl
  80073a:	88 10                	mov    %dl,(%eax)
  80073c:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  800742:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800745:	66 89 42 02          	mov    %ax,0x2(%edx)
  800749:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80074f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800752:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800755:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80075b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800762:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800768:	01 c2                	add    %eax,%edx
  80076a:	8a 45 da             	mov    -0x26(%ebp),%al
  80076d:	88 02                	mov    %al,(%edx)
  80076f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800775:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80077c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800782:	01 c2                	add    %eax,%edx
  800784:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800788:	66 89 42 02          	mov    %ax,0x2(%edx)
  80078c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800792:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800799:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80079f:	01 c2                	add    %eax,%edx
  8007a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007a4:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007a7:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8007aa:	e8 ca 27 00 00       	call   802f79 <sys_calculate_free_frames>
  8007af:	29 c3                	sub    %eax,%ebx
  8007b1:	89 d8                	mov    %ebx,%eax
  8007b3:	83 f8 02             	cmp    $0x2,%eax
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 b8 37 80 00       	push   $0x8037b8
  8007c0:	68 8b 00 00 00       	push   $0x8b
  8007c5:	68 0b 37 80 00       	push   $0x80370b
  8007ca:	e8 b4 0f 00 00       	call   801783 <_panic>
		found = 0;
  8007cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007dd:	e9 9e 00 00 00       	jmp    800880 <_main+0x848>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8007e7:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007f0:	c1 e2 04             	shl    $0x4,%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  8007fd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800803:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800808:	89 c2                	mov    %eax,%edx
  80080a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800810:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800816:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80081c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800821:	39 c2                	cmp    %eax,%edx
  800823:	75 03                	jne    800828 <_main+0x7f0>
				found++;
  800825:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  800828:	a1 20 40 80 00       	mov    0x804020,%eax
  80082d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800833:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800836:	c1 e2 04             	shl    $0x4,%edx
  800839:	01 d0                	add    %edx,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800843:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800849:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80084e:	89 c2                	mov    %eax,%edx
  800850:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800856:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80085d:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800863:	01 c8                	add    %ecx,%eax
  800865:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  80086b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800871:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	75 03                	jne    80087d <_main+0x845>
				found++;
  80087a:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80087d:	ff 45 ec             	incl   -0x14(%ebp)
  800880:	a1 20 40 80 00       	mov    0x804020,%eax
  800885:	8b 50 74             	mov    0x74(%eax),%edx
  800888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088b:	39 c2                	cmp    %eax,%edx
  80088d:	0f 87 4f ff ff ff    	ja     8007e2 <_main+0x7aa>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800893:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x878>
  800899:	83 ec 04             	sub    $0x4,%esp
  80089c:	68 fc 37 80 00       	push   $0x8037fc
  8008a1:	68 94 00 00 00       	push   $0x94
  8008a6:	68 0b 37 80 00       	push   $0x80370b
  8008ab:	e8 d3 0e 00 00       	call   801783 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 c4 26 00 00       	call   802f79 <sys_calculate_free_frames>
  8008b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 3f 27 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8008bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c3:	89 c2                	mov    %eax,%edx
  8008c5:	01 d2                	add    %edx,%edx
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	50                   	push   %eax
  8008d0:	e8 da 1e 00 00       	call   8027af <malloc>
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008de:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8008e4:	89 c2                	mov    %eax,%edx
  8008e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e9:	c1 e0 02             	shl    $0x2,%eax
  8008ec:	89 c1                	mov    %eax,%ecx
  8008ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008f1:	c1 e0 04             	shl    $0x4,%eax
  8008f4:	01 c8                	add    %ecx,%eax
  8008f6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	72 21                	jb     800920 <_main+0x8e8>
  8008ff:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800905:	89 c2                	mov    %eax,%edx
  800907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090a:	c1 e0 02             	shl    $0x2,%eax
  80090d:	89 c1                	mov    %eax,%ecx
  80090f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800912:	c1 e0 04             	shl    $0x4,%eax
  800915:	01 c8                	add    %ecx,%eax
  800917:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80091c:	39 c2                	cmp    %eax,%edx
  80091e:	76 17                	jbe    800937 <_main+0x8ff>
  800920:	83 ec 04             	sub    $0x4,%esp
  800923:	68 20 37 80 00       	push   $0x803720
  800928:	68 9a 00 00 00       	push   $0x9a
  80092d:	68 0b 37 80 00       	push   $0x80370b
  800932:	e8 4c 0e 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800937:	e8 c0 26 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  80093c:	2b 45 c0             	sub    -0x40(%ebp),%eax
  80093f:	89 c2                	mov    %eax,%edx
  800941:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800944:	89 c1                	mov    %eax,%ecx
  800946:	01 c9                	add    %ecx,%ecx
  800948:	01 c8                	add    %ecx,%eax
  80094a:	85 c0                	test   %eax,%eax
  80094c:	79 05                	jns    800953 <_main+0x91b>
  80094e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800953:	c1 f8 0c             	sar    $0xc,%eax
  800956:	39 c2                	cmp    %eax,%edx
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 88 37 80 00       	push   $0x803788
  800962:	68 9b 00 00 00       	push   $0x9b
  800967:	68 0b 37 80 00       	push   $0x80370b
  80096c:	e8 12 0e 00 00       	call   801783 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
		byteArr3 = (char*)ptr_allocations[5];
  800971:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800977:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for(int i = 0; i < toAccess; i++)
  80097a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800981:	eb 10                	jmp    800993 <_main+0x95b>
		{
			*byteArr3 = '@';
  800983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800986:	c6 00 40             	movb   $0x40,(%eax)
			byteArr3 += PAGE_SIZE;
  800989:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
		byteArr3 = (char*)ptr_allocations[5];
		for(int i = 0; i < toAccess; i++)
  800990:	ff 45 e4             	incl   -0x1c(%ebp)
  800993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800996:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800999:	7c e8                	jl     800983 <_main+0x94b>
		{
			*byteArr3 = '@';
			byteArr3 += PAGE_SIZE;
		}
		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80099b:	e8 5c 26 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8009a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  8009a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8009b1:	83 ec 0c             	sub    $0xc,%esp
  8009b4:	50                   	push   %eax
  8009b5:	e8 f5 1d 00 00       	call   8027af <malloc>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8009c3:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	05 00 00 00 80       	add    $0x80000000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	72 28                	jb     800a13 <_main+0x9db>
  8009eb:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8009f1:	89 c1                	mov    %eax,%ecx
  8009f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f6:	89 d0                	mov    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d0                	add    %edx,%eax
  8009fc:	01 c0                	add    %eax,%eax
  8009fe:	01 d0                	add    %edx,%eax
  800a00:	89 c2                	mov    %eax,%edx
  800a02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a05:	c1 e0 04             	shl    $0x4,%eax
  800a08:	01 d0                	add    %edx,%eax
  800a0a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800a0f:	39 c1                	cmp    %eax,%ecx
  800a11:	76 17                	jbe    800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 20 37 80 00       	push   $0x803720
  800a1b:	68 a6 00 00 00       	push   $0xa6
  800a20:	68 0b 37 80 00       	push   $0x80370b
  800a25:	e8 59 0d 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800a2a:	e8 cd 25 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800a2f:	2b 45 c0             	sub    -0x40(%ebp),%eax
  800a32:	89 c1                	mov    %eax,%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	01 c0                	add    %eax,%eax
  800a3f:	85 c0                	test   %eax,%eax
  800a41:	79 05                	jns    800a48 <_main+0xa10>
  800a43:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a48:	c1 f8 0c             	sar    $0xc,%eax
  800a4b:	39 c1                	cmp    %eax,%ecx
  800a4d:	74 17                	je     800a66 <_main+0xa2e>
  800a4f:	83 ec 04             	sub    $0x4,%esp
  800a52:	68 88 37 80 00       	push   $0x803788
  800a57:	68 a7 00 00 00       	push   $0xa7
  800a5c:	68 0b 37 80 00       	push   $0x80370b
  800a61:	e8 1d 0d 00 00       	call   801783 <_panic>
		freeFrames = sys_calculate_free_frames() ;
  800a66:	e8 0e 25 00 00       	call   802f79 <sys_calculate_free_frames>
  800a6b:	89 45 bc             	mov    %eax,-0x44(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a7c:	48                   	dec    %eax
  800a7d:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a83:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800a89:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		byteArr2[0] = minByte ;
  800a8f:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800a95:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a98:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a9a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aa0:	89 c2                	mov    %eax,%edx
  800aa2:	c1 ea 1f             	shr    $0x1f,%edx
  800aa5:	01 d0                	add    %edx,%eax
  800aa7:	d1 f8                	sar    %eax
  800aa9:	89 c2                	mov    %eax,%edx
  800aab:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800ab1:	01 c2                	add    %eax,%edx
  800ab3:	8a 45 da             	mov    -0x26(%ebp),%al
  800ab6:	88 c1                	mov    %al,%cl
  800ab8:	c0 e9 07             	shr    $0x7,%cl
  800abb:	01 c8                	add    %ecx,%eax
  800abd:	d0 f8                	sar    %al
  800abf:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800ac1:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  800ac7:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800acd:	01 c2                	add    %eax,%edx
  800acf:	8a 45 da             	mov    -0x26(%ebp),%al
  800ad2:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800ad4:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800ad7:	e8 9d 24 00 00       	call   802f79 <sys_calculate_free_frames>
  800adc:	29 c3                	sub    %eax,%ebx
  800ade:	89 d8                	mov    %ebx,%eax
  800ae0:	83 f8 05             	cmp    $0x5,%eax
  800ae3:	74 17                	je     800afc <_main+0xac4>
  800ae5:	83 ec 04             	sub    $0x4,%esp
  800ae8:	68 b8 37 80 00       	push   $0x8037b8
  800aed:	68 ae 00 00 00       	push   $0xae
  800af2:	68 0b 37 80 00       	push   $0x80370b
  800af7:	e8 87 0c 00 00       	call   801783 <_panic>
		found = 0;
  800afc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b03:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800b0a:	e9 f0 00 00 00       	jmp    800bff <_main+0xbc7>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800b0f:	a1 20 40 80 00       	mov    0x804020,%eax
  800b14:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b1d:	c1 e2 04             	shl    $0x4,%edx
  800b20:	01 d0                	add    %edx,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b2a:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b3d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b43:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b4e:	39 c2                	cmp    %eax,%edx
  800b50:	75 03                	jne    800b55 <_main+0xb1d>
				found++;
  800b52:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b55:	a1 20 40 80 00       	mov    0x804020,%eax
  800b5a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b63:	c1 e2 04             	shl    $0x4,%edx
  800b66:	01 d0                	add    %edx,%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b70:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b7b:	89 c2                	mov    %eax,%edx
  800b7d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b83:	89 c1                	mov    %eax,%ecx
  800b85:	c1 e9 1f             	shr    $0x1f,%ecx
  800b88:	01 c8                	add    %ecx,%eax
  800b8a:	d1 f8                	sar    %eax
  800b8c:	89 c1                	mov    %eax,%ecx
  800b8e:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b94:	01 c8                	add    %ecx,%eax
  800b96:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b9c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800ba2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba7:	39 c2                	cmp    %eax,%edx
  800ba9:	75 03                	jne    800bae <_main+0xb76>
				found++;
  800bab:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800bae:	a1 20 40 80 00       	mov    0x804020,%eax
  800bb3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800bb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bbc:	c1 e2 04             	shl    $0x4,%edx
  800bbf:	01 d0                	add    %edx,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bc9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800bcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd4:	89 c1                	mov    %eax,%ecx
  800bd6:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  800bdc:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800be2:	01 d0                	add    %edx,%eax
  800be4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800bea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800bf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bf5:	39 c1                	cmp    %eax,%ecx
  800bf7:	75 03                	jne    800bfc <_main+0xbc4>
				found++;
  800bf9:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bfc:	ff 45 ec             	incl   -0x14(%ebp)
  800bff:	a1 20 40 80 00       	mov    0x804020,%eax
  800c04:	8b 50 74             	mov    0x74(%eax),%edx
  800c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c0a:	39 c2                	cmp    %eax,%edx
  800c0c:	0f 87 fd fe ff ff    	ja     800b0f <_main+0xad7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800c12:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800c16:	74 17                	je     800c2f <_main+0xbf7>
  800c18:	83 ec 04             	sub    $0x4,%esp
  800c1b:	68 fc 37 80 00       	push   $0x8037fc
  800c20:	68 b9 00 00 00       	push   $0xb9
  800c25:	68 0b 37 80 00       	push   $0x80370b
  800c2a:	e8 54 0b 00 00       	call   801783 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c2f:	e8 c8 23 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800c34:	89 45 c0             	mov    %eax,-0x40(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c3a:	89 d0                	mov    %edx,%eax
  800c3c:	01 c0                	add    %eax,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d0                	add    %edx,%eax
  800c44:	01 c0                	add    %eax,%eax
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	50                   	push   %eax
  800c4a:	e8 60 1b 00 00       	call   8027af <malloc>
  800c4f:	83 c4 10             	add    $0x10,%esp
  800c52:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c58:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800c5e:	89 c1                	mov    %eax,%ecx
  800c60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c63:	89 d0                	mov    %edx,%eax
  800c65:	01 c0                	add    %eax,%eax
  800c67:	01 d0                	add    %edx,%eax
  800c69:	c1 e0 02             	shl    $0x2,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	89 c2                	mov    %eax,%edx
  800c70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c73:	c1 e0 04             	shl    $0x4,%eax
  800c76:	01 d0                	add    %edx,%eax
  800c78:	05 00 00 00 80       	add    $0x80000000,%eax
  800c7d:	39 c1                	cmp    %eax,%ecx
  800c7f:	72 29                	jb     800caa <_main+0xc72>
  800c81:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800c87:	89 c1                	mov    %eax,%ecx
  800c89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c8c:	89 d0                	mov    %edx,%eax
  800c8e:	01 c0                	add    %eax,%eax
  800c90:	01 d0                	add    %edx,%eax
  800c92:	c1 e0 02             	shl    $0x2,%eax
  800c95:	01 d0                	add    %edx,%eax
  800c97:	89 c2                	mov    %eax,%edx
  800c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c9c:	c1 e0 04             	shl    $0x4,%eax
  800c9f:	01 d0                	add    %edx,%eax
  800ca1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800ca6:	39 c1                	cmp    %eax,%ecx
  800ca8:	76 17                	jbe    800cc1 <_main+0xc89>
  800caa:	83 ec 04             	sub    $0x4,%esp
  800cad:	68 20 37 80 00       	push   $0x803720
  800cb2:	68 be 00 00 00       	push   $0xbe
  800cb7:	68 0b 37 80 00       	push   $0x80370b
  800cbc:	e8 c2 0a 00 00       	call   801783 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800cc1:	e8 36 23 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800cc6:	2b 45 c0             	sub    -0x40(%ebp),%eax
  800cc9:	83 f8 04             	cmp    $0x4,%eax
  800ccc:	74 17                	je     800ce5 <_main+0xcad>
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	68 88 37 80 00       	push   $0x803788
  800cd6:	68 bf 00 00 00       	push   $0xbf
  800cdb:	68 0b 37 80 00       	push   $0x80370b
  800ce0:	e8 9e 0a 00 00       	call   801783 <_panic>
		freeFrames = sys_calculate_free_frames() ;
  800ce5:	e8 8f 22 00 00       	call   802f79 <sys_calculate_free_frames>
  800cea:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800ced:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800cf3:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cf9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800cfc:	89 d0                	mov    %edx,%eax
  800cfe:	01 c0                	add    %eax,%eax
  800d00:	01 d0                	add    %edx,%eax
  800d02:	01 c0                	add    %eax,%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	01 c0                	add    %eax,%eax
  800d08:	d1 e8                	shr    %eax
  800d0a:	48                   	dec    %eax
  800d0b:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
		shortArr2[0] = minShort;
  800d11:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800d17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d1a:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800d1d:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d23:	01 c0                	add    %eax,%eax
  800d25:	89 c2                	mov    %eax,%edx
  800d27:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d2d:	01 c2                	add    %eax,%edx
  800d2f:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800d33:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d36:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800d39:	e8 3b 22 00 00       	call   802f79 <sys_calculate_free_frames>
  800d3e:	29 c3                	sub    %eax,%ebx
  800d40:	89 d8                	mov    %ebx,%eax
  800d42:	83 f8 02             	cmp    $0x2,%eax
  800d45:	74 17                	je     800d5e <_main+0xd26>
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	68 b8 37 80 00       	push   $0x8037b8
  800d4f:	68 c5 00 00 00       	push   $0xc5
  800d54:	68 0b 37 80 00       	push   $0x80370b
  800d59:	e8 25 0a 00 00       	call   801783 <_panic>
		found = 0;
  800d5e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d6c:	e9 9b 00 00 00       	jmp    800e0c <_main+0xdd4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d71:	a1 20 40 80 00       	mov    0x804020,%eax
  800d76:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d7f:	c1 e2 04             	shl    $0x4,%edx
  800d82:	01 d0                	add    %edx,%eax
  800d84:	8b 00                	mov    (%eax),%eax
  800d86:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d8c:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d97:	89 c2                	mov    %eax,%edx
  800d99:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d9f:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800da5:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db0:	39 c2                	cmp    %eax,%edx
  800db2:	75 03                	jne    800db7 <_main+0xd7f>
				found++;
  800db4:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800db7:	a1 20 40 80 00       	mov    0x804020,%eax
  800dbc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800dc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dc5:	c1 e2 04             	shl    $0x4,%edx
  800dc8:	01 d0                	add    %edx,%eax
  800dca:	8b 00                	mov    (%eax),%eax
  800dcc:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800dd2:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800dd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ddd:	89 c2                	mov    %eax,%edx
  800ddf:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800de5:	01 c0                	add    %eax,%eax
  800de7:	89 c1                	mov    %eax,%ecx
  800de9:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800def:	01 c8                	add    %ecx,%eax
  800df1:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  800df7:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800dfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e02:	39 c2                	cmp    %eax,%edx
  800e04:	75 03                	jne    800e09 <_main+0xdd1>
				found++;
  800e06:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e09:	ff 45 ec             	incl   -0x14(%ebp)
  800e0c:	a1 20 40 80 00       	mov    0x804020,%eax
  800e11:	8b 50 74             	mov    0x74(%eax),%edx
  800e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e17:	39 c2                	cmp    %eax,%edx
  800e19:	0f 87 52 ff ff ff    	ja     800d71 <_main+0xd39>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800e1f:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800e23:	74 17                	je     800e3c <_main+0xe04>
  800e25:	83 ec 04             	sub    $0x4,%esp
  800e28:	68 fc 37 80 00       	push   $0x8037fc
  800e2d:	68 ce 00 00 00       	push   $0xce
  800e32:	68 0b 37 80 00       	push   $0x80370b
  800e37:	e8 47 09 00 00       	call   801783 <_panic>
	}

	{
		uint32 tmp_addresses[3] = {0};
  800e3c:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  800e42:	b9 03 00 00 00       	mov    $0x3,%ecx
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4c:	89 d7                	mov    %edx,%edi
  800e4e:	f3 ab                	rep stos %eax,%es:(%edi)

		//Free 6 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e50:	e8 24 21 00 00       	call   802f79 <sys_calculate_free_frames>
  800e55:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e5b:	e8 9c 21 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800e60:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[6]);
  800e66:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	50                   	push   %eax
  800e70:	e8 e8 1d 00 00       	call   802c5d <free>
  800e75:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 6*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e78:	e8 7f 21 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800e7d:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  800e83:	89 d1                	mov    %edx,%ecx
  800e85:	29 c1                	sub    %eax,%ecx
  800e87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e8a:	89 d0                	mov    %edx,%eax
  800e8c:	01 c0                	add    %eax,%eax
  800e8e:	01 d0                	add    %edx,%eax
  800e90:	01 c0                	add    %eax,%eax
  800e92:	85 c0                	test   %eax,%eax
  800e94:	79 05                	jns    800e9b <_main+0xe63>
  800e96:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e9b:	c1 f8 0c             	sar    $0xc,%eax
  800e9e:	39 c1                	cmp    %eax,%ecx
  800ea0:	74 17                	je     800eb9 <_main+0xe81>
  800ea2:	83 ec 04             	sub    $0x4,%esp
  800ea5:	68 1c 38 80 00       	push   $0x80381c
  800eaa:	68 d8 00 00 00       	push   $0xd8
  800eaf:	68 0b 37 80 00       	push   $0x80370b
  800eb4:	e8 ca 08 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800eb9:	e8 bb 20 00 00       	call   802f79 <sys_calculate_free_frames>
  800ebe:	89 c2                	mov    %eax,%edx
  800ec0:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800ec6:	29 c2                	sub    %eax,%edx
  800ec8:	89 d0                	mov    %edx,%eax
  800eca:	83 f8 04             	cmp    $0x4,%eax
  800ecd:	74 17                	je     800ee6 <_main+0xeae>
  800ecf:	83 ec 04             	sub    $0x4,%esp
  800ed2:	68 58 38 80 00       	push   $0x803858
  800ed7:	68 d9 00 00 00       	push   $0xd9
  800edc:	68 0b 37 80 00       	push   $0x80370b
  800ee1:	e8 9d 08 00 00       	call   801783 <_panic>
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//		}
		tmp_addresses[0] = (uint32)(&(byteArr2[0]));
  800ee6:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800eec:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
		tmp_addresses[1] = (uint32)(&(byteArr2[lastIndexOfByte2/2]));
  800ef2:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	c1 ea 1f             	shr    $0x1f,%edx
  800efd:	01 d0                	add    %edx,%eax
  800eff:	d1 f8                	sar    %eax
  800f01:	89 c2                	mov    %eax,%edx
  800f03:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800f09:	01 d0                	add    %edx,%eax
  800f0b:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
		tmp_addresses[2] = (uint32)(&(byteArr2[lastIndexOfByte2]));
  800f11:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  800f17:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800f1d:	01 d0                	add    %edx,%eax
  800f1f:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
		int check = sys_check_LRU_lists_free(tmp_addresses, 3);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	6a 03                	push   $0x3
  800f2a:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  800f30:	50                   	push   %eax
  800f31:	e8 17 25 00 00       	call   80344d <sys_check_LRU_lists_free>
  800f36:	83 c4 10             	add    $0x10,%esp
  800f39:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		if(check != 0)
  800f3f:	83 bd 18 ff ff ff 00 	cmpl   $0x0,-0xe8(%ebp)
  800f46:	74 17                	je     800f5f <_main+0xf27>
		{
				panic("free: page is not removed from LRU lists");
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 a4 38 80 00       	push   $0x8038a4
  800f50:	68 e9 00 00 00       	push   $0xe9
  800f55:	68 0b 37 80 00       	push   $0x80370b
  800f5a:	e8 24 08 00 00       	call   801783 <_panic>
		}

		if(LIST_SIZE(&myEnv->ActiveList) != 800 && LIST_SIZE(&myEnv->SecondList) != 1)
  800f5f:	a1 20 40 80 00       	mov    0x804020,%eax
  800f64:	8b 80 ac 3c 01 00    	mov    0x13cac(%eax),%eax
  800f6a:	3d 20 03 00 00       	cmp    $0x320,%eax
  800f6f:	74 27                	je     800f98 <_main+0xf60>
  800f71:	a1 20 40 80 00       	mov    0x804020,%eax
  800f76:	8b 80 bc 3c 01 00    	mov    0x13cbc(%eax),%eax
  800f7c:	83 f8 01             	cmp    $0x1,%eax
  800f7f:	74 17                	je     800f98 <_main+0xf60>
		{
			panic("LRU lists content is not correct");
  800f81:	83 ec 04             	sub    $0x4,%esp
  800f84:	68 d0 38 80 00       	push   $0x8038d0
  800f89:	68 ee 00 00 00       	push   $0xee
  800f8e:	68 0b 37 80 00       	push   $0x80370b
  800f93:	e8 eb 07 00 00       	call   801783 <_panic>
		}

		//Free 1st 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f98:	e8 dc 1f 00 00       	call   802f79 <sys_calculate_free_frames>
  800f9d:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa3:	e8 54 20 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800fa8:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[0]);
  800fae:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	50                   	push   %eax
  800fb8:	e8 a0 1c 00 00       	call   802c5d <free>
  800fbd:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fc0:	e8 37 20 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  800fc5:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  800fcb:	29 c2                	sub    %eax,%edx
  800fcd:	89 d0                	mov    %edx,%eax
  800fcf:	3d 00 02 00 00       	cmp    $0x200,%eax
  800fd4:	74 17                	je     800fed <_main+0xfb5>
  800fd6:	83 ec 04             	sub    $0x4,%esp
  800fd9:	68 1c 38 80 00       	push   $0x80381c
  800fde:	68 f5 00 00 00       	push   $0xf5
  800fe3:	68 0b 37 80 00       	push   $0x80370b
  800fe8:	e8 96 07 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fed:	e8 87 1f 00 00       	call   802f79 <sys_calculate_free_frames>
  800ff2:	89 c2                	mov    %eax,%edx
  800ff4:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800ffa:	29 c2                	sub    %eax,%edx
  800ffc:	89 d0                	mov    %edx,%eax
  800ffe:	83 f8 02             	cmp    $0x2,%eax
  801001:	74 17                	je     80101a <_main+0xfe2>
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 58 38 80 00       	push   $0x803858
  80100b:	68 f6 00 00 00       	push   $0xf6
  801010:	68 0b 37 80 00       	push   $0x80370b
  801015:	e8 69 07 00 00       	call   801783 <_panic>
//				panic("free: page is not removed from WS");
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//		}

		tmp_addresses[0] = (uint32)(&(byteArr[0]));
  80101a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80101d:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
		tmp_addresses[1] = (uint32)(&(byteArr[lastIndexOfByte]));
  801023:	8b 55 b8             	mov    -0x48(%ebp),%edx
  801026:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
		check = sys_check_LRU_lists_free(tmp_addresses, 2);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	6a 02                	push   $0x2
  801036:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  80103c:	50                   	push   %eax
  80103d:	e8 0b 24 00 00       	call   80344d <sys_check_LRU_lists_free>
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		if(check != 0)
  80104b:	83 bd 18 ff ff ff 00 	cmpl   $0x0,-0xe8(%ebp)
  801052:	74 17                	je     80106b <_main+0x1033>
		{
				panic("free: page is not removed from LRU lists");
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	68 a4 38 80 00       	push   $0x8038a4
  80105c:	68 05 01 00 00       	push   $0x105
  801061:	68 0b 37 80 00       	push   $0x80370b
  801066:	e8 18 07 00 00       	call   801783 <_panic>
		}

		if(LIST_SIZE(&myEnv->ActiveList) != 799 && LIST_SIZE(&myEnv->SecondList) != 0)
  80106b:	a1 20 40 80 00       	mov    0x804020,%eax
  801070:	8b 80 ac 3c 01 00    	mov    0x13cac(%eax),%eax
  801076:	3d 1f 03 00 00       	cmp    $0x31f,%eax
  80107b:	74 26                	je     8010a3 <_main+0x106b>
  80107d:	a1 20 40 80 00       	mov    0x804020,%eax
  801082:	8b 80 bc 3c 01 00    	mov    0x13cbc(%eax),%eax
  801088:	85 c0                	test   %eax,%eax
  80108a:	74 17                	je     8010a3 <_main+0x106b>
		{
			panic("LRU lists content is not correct");
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	68 d0 38 80 00       	push   $0x8038d0
  801094:	68 0a 01 00 00       	push   $0x10a
  801099:	68 0b 37 80 00       	push   $0x80370b
  80109e:	e8 e0 06 00 00       	call   801783 <_panic>
		}

		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8010a3:	e8 d1 1e 00 00       	call   802f79 <sys_calculate_free_frames>
  8010a8:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010ae:	e8 49 1f 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8010b3:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[1]);
  8010b9:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8010bf:	83 ec 0c             	sub    $0xc,%esp
  8010c2:	50                   	push   %eax
  8010c3:	e8 95 1b 00 00       	call   802c5d <free>
  8010c8:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010cb:	e8 2c 1f 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8010d0:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  8010d6:	29 c2                	sub    %eax,%edx
  8010d8:	89 d0                	mov    %edx,%eax
  8010da:	3d 00 02 00 00       	cmp    $0x200,%eax
  8010df:	74 17                	je     8010f8 <_main+0x10c0>
  8010e1:	83 ec 04             	sub    $0x4,%esp
  8010e4:	68 1c 38 80 00       	push   $0x80381c
  8010e9:	68 11 01 00 00       	push   $0x111
  8010ee:	68 0b 37 80 00       	push   $0x80370b
  8010f3:	e8 8b 06 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8010f8:	e8 7c 1e 00 00       	call   802f79 <sys_calculate_free_frames>
  8010fd:	89 c2                	mov    %eax,%edx
  8010ff:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801105:	29 c2                	sub    %eax,%edx
  801107:	89 d0                	mov    %edx,%eax
  801109:	83 f8 03             	cmp    $0x3,%eax
  80110c:	74 17                	je     801125 <_main+0x10ed>
  80110e:	83 ec 04             	sub    $0x4,%esp
  801111:	68 58 38 80 00       	push   $0x803858
  801116:	68 12 01 00 00       	push   $0x112
  80111b:	68 0b 37 80 00       	push   $0x80370b
  801120:	e8 5e 06 00 00       	call   801783 <_panic>
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//		}
		tmp_addresses[0] = (uint32)(&(shortArr[0]));
  801125:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801128:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
		tmp_addresses[1] = (uint32)(&(shortArr[lastIndexOfShort]));
  80112e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	89 c2                	mov    %eax,%edx
  801135:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801138:	01 d0                	add    %edx,%eax
  80113a:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
		check = sys_check_LRU_lists_free(tmp_addresses, 2);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	6a 02                	push   $0x2
  801145:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  80114b:	50                   	push   %eax
  80114c:	e8 fc 22 00 00       	call   80344d <sys_check_LRU_lists_free>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		if(check != 0)
  80115a:	83 bd 18 ff ff ff 00 	cmpl   $0x0,-0xe8(%ebp)
  801161:	74 17                	je     80117a <_main+0x1142>
		{
				panic("free: page is not removed from LRU lists");
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	68 a4 38 80 00       	push   $0x8038a4
  80116b:	68 1f 01 00 00       	push   $0x11f
  801170:	68 0b 37 80 00       	push   $0x80370b
  801175:	e8 09 06 00 00       	call   801783 <_panic>
		}

		if(LIST_SIZE(&myEnv->ActiveList) != 797 && LIST_SIZE(&myEnv->SecondList) != 0)
  80117a:	a1 20 40 80 00       	mov    0x804020,%eax
  80117f:	8b 80 ac 3c 01 00    	mov    0x13cac(%eax),%eax
  801185:	3d 1d 03 00 00       	cmp    $0x31d,%eax
  80118a:	74 26                	je     8011b2 <_main+0x117a>
  80118c:	a1 20 40 80 00       	mov    0x804020,%eax
  801191:	8b 80 bc 3c 01 00    	mov    0x13cbc(%eax),%eax
  801197:	85 c0                	test   %eax,%eax
  801199:	74 17                	je     8011b2 <_main+0x117a>
		{
			panic("LRU lists content is not correct");
  80119b:	83 ec 04             	sub    $0x4,%esp
  80119e:	68 d0 38 80 00       	push   $0x8038d0
  8011a3:	68 24 01 00 00       	push   $0x124
  8011a8:	68 0b 37 80 00       	push   $0x80370b
  8011ad:	e8 d1 05 00 00       	call   801783 <_panic>
		}


		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  8011b2:	e8 c2 1d 00 00       	call   802f79 <sys_calculate_free_frames>
  8011b7:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8011bd:	e8 3a 1e 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8011c2:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[4]);
  8011c8:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	50                   	push   %eax
  8011d2:	e8 86 1a 00 00       	call   802c5d <free>
  8011d7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  8011da:	e8 1d 1e 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8011df:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  8011e5:	29 c2                	sub    %eax,%edx
  8011e7:	89 d0                	mov    %edx,%eax
  8011e9:	83 f8 02             	cmp    $0x2,%eax
  8011ec:	74 17                	je     801205 <_main+0x11cd>
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	68 1c 38 80 00       	push   $0x80381c
  8011f6:	68 2c 01 00 00       	push   $0x12c
  8011fb:	68 0b 37 80 00       	push   $0x80370b
  801200:	e8 7e 05 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801205:	e8 6f 1d 00 00       	call   802f79 <sys_calculate_free_frames>
  80120a:	89 c2                	mov    %eax,%edx
  80120c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801212:	29 c2                	sub    %eax,%edx
  801214:	89 d0                	mov    %edx,%eax
  801216:	83 f8 02             	cmp    $0x2,%eax
  801219:	74 17                	je     801232 <_main+0x11fa>
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	68 58 38 80 00       	push   $0x803858
  801223:	68 2d 01 00 00       	push   $0x12d
  801228:	68 0b 37 80 00       	push   $0x80370b
  80122d:	e8 51 05 00 00       	call   801783 <_panic>
//				panic("free: page is not removed from WS");
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//		}

		tmp_addresses[0] = (uint32)(&(structArr[0]));
  801232:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801238:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
		tmp_addresses[1] = (uint32)(&(structArr[lastIndexOfStruct]));
  80123e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801244:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80124b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
		check = sys_check_LRU_lists_free(tmp_addresses, 2);
  801259:	83 ec 08             	sub    $0x8,%esp
  80125c:	6a 02                	push   $0x2
  80125e:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  801264:	50                   	push   %eax
  801265:	e8 e3 21 00 00       	call   80344d <sys_check_LRU_lists_free>
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		if(check != 0)
  801273:	83 bd 18 ff ff ff 00 	cmpl   $0x0,-0xe8(%ebp)
  80127a:	74 17                	je     801293 <_main+0x125b>
		{
				panic("free: page is not removed from LRU lists");
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	68 a4 38 80 00       	push   $0x8038a4
  801284:	68 3b 01 00 00       	push   $0x13b
  801289:	68 0b 37 80 00       	push   $0x80370b
  80128e:	e8 f0 04 00 00       	call   801783 <_panic>
		}

		if(LIST_SIZE(&myEnv->ActiveList) != 795 && LIST_SIZE(&myEnv->SecondList) != 0)
  801293:	a1 20 40 80 00       	mov    0x804020,%eax
  801298:	8b 80 ac 3c 01 00    	mov    0x13cac(%eax),%eax
  80129e:	3d 1b 03 00 00       	cmp    $0x31b,%eax
  8012a3:	74 26                	je     8012cb <_main+0x1293>
  8012a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8012aa:	8b 80 bc 3c 01 00    	mov    0x13cbc(%eax),%eax
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	74 17                	je     8012cb <_main+0x1293>
		{
			panic("LRU lists content is not correct");
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	68 d0 38 80 00       	push   $0x8038d0
  8012bc:	68 40 01 00 00       	push   $0x140
  8012c1:	68 0b 37 80 00       	push   $0x80370b
  8012c6:	e8 b8 04 00 00       	call   801783 <_panic>
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8012cb:	e8 a9 1c 00 00       	call   802f79 <sys_calculate_free_frames>
  8012d0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012d6:	e8 21 1d 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8012db:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[5]);
  8012e1:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	50                   	push   %eax
  8012eb:	e8 6d 19 00 00       	call   802c5d <free>
  8012f0:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012f3:	e8 04 1d 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8012f8:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  8012fe:	89 d1                	mov    %edx,%ecx
  801300:	29 c1                	sub    %eax,%ecx
  801302:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801305:	89 c2                	mov    %eax,%edx
  801307:	01 d2                	add    %edx,%edx
  801309:	01 d0                	add    %edx,%eax
  80130b:	85 c0                	test   %eax,%eax
  80130d:	79 05                	jns    801314 <_main+0x12dc>
  80130f:	05 ff 0f 00 00       	add    $0xfff,%eax
  801314:	c1 f8 0c             	sar    $0xc,%eax
  801317:	39 c1                	cmp    %eax,%ecx
  801319:	74 17                	je     801332 <_main+0x12fa>
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	68 1c 38 80 00       	push   $0x80381c
  801323:	68 47 01 00 00       	push   $0x147
  801328:	68 0b 37 80 00       	push   $0x80370b
  80132d:	e8 51 04 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != toAccess) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801332:	e8 42 1c 00 00       	call   802f79 <sys_calculate_free_frames>
  801337:	89 c2                	mov    %eax,%edx
  801339:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  80133f:	29 c2                	sub    %eax,%edx
  801341:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801344:	39 c2                	cmp    %eax,%edx
  801346:	74 17                	je     80135f <_main+0x1327>
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	68 58 38 80 00       	push   $0x803858
  801350:	68 48 01 00 00       	push   $0x148
  801355:	68 0b 37 80 00       	push   $0x80370b
  80135a:	e8 24 04 00 00       	call   801783 <_panic>

		//Free 1st 3 KB
		freeFrames = sys_calculate_free_frames() ;
  80135f:	e8 15 1c 00 00       	call   802f79 <sys_calculate_free_frames>
  801364:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80136a:	e8 8d 1c 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  80136f:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[2]);
  801375:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80137b:	83 ec 0c             	sub    $0xc,%esp
  80137e:	50                   	push   %eax
  80137f:	e8 d9 18 00 00       	call   802c5d <free>
  801384:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  801387:	e8 70 1c 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  80138c:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  801392:	29 c2                	sub    %eax,%edx
  801394:	89 d0                	mov    %edx,%eax
  801396:	83 f8 01             	cmp    $0x1,%eax
  801399:	74 17                	je     8013b2 <_main+0x137a>
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	68 1c 38 80 00       	push   $0x80381c
  8013a3:	68 4e 01 00 00       	push   $0x14e
  8013a8:	68 0b 37 80 00       	push   $0x80370b
  8013ad:	e8 d1 03 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8013b2:	e8 c2 1b 00 00       	call   802f79 <sys_calculate_free_frames>
  8013b7:	89 c2                	mov    %eax,%edx
  8013b9:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  8013bf:	29 c2                	sub    %eax,%edx
  8013c1:	89 d0                	mov    %edx,%eax
  8013c3:	83 f8 02             	cmp    $0x2,%eax
  8013c6:	74 17                	je     8013df <_main+0x13a7>
  8013c8:	83 ec 04             	sub    $0x4,%esp
  8013cb:	68 58 38 80 00       	push   $0x803858
  8013d0:	68 4f 01 00 00       	push   $0x14f
  8013d5:	68 0b 37 80 00       	push   $0x80370b
  8013da:	e8 a4 03 00 00       	call   801783 <_panic>
//				panic("free: page is not removed from WS");
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//		}

		tmp_addresses[0] = (uint32)(&(intArr[0]));
  8013df:	8b 45 88             	mov    -0x78(%ebp),%eax
  8013e2:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
		tmp_addresses[1] = (uint32)(&(intArr[lastIndexOfInt]));
  8013e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8013eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f2:	8b 45 88             	mov    -0x78(%ebp),%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
		check = sys_check_LRU_lists_free(tmp_addresses, 2);
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	6a 02                	push   $0x2
  801402:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  801408:	50                   	push   %eax
  801409:	e8 3f 20 00 00       	call   80344d <sys_check_LRU_lists_free>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		if(check != 0)
  801417:	83 bd 18 ff ff ff 00 	cmpl   $0x0,-0xe8(%ebp)
  80141e:	74 17                	je     801437 <_main+0x13ff>
		{
				panic("free: page is not removed from LRU lists");
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	68 a4 38 80 00       	push   $0x8038a4
  801428:	68 5d 01 00 00       	push   $0x15d
  80142d:	68 0b 37 80 00       	push   $0x80370b
  801432:	e8 4c 03 00 00       	call   801783 <_panic>
		}

		if(LIST_SIZE(&myEnv->ActiveList) != 794 && LIST_SIZE(&myEnv->SecondList) != 0)
  801437:	a1 20 40 80 00       	mov    0x804020,%eax
  80143c:	8b 80 ac 3c 01 00    	mov    0x13cac(%eax),%eax
  801442:	3d 1a 03 00 00       	cmp    $0x31a,%eax
  801447:	74 26                	je     80146f <_main+0x1437>
  801449:	a1 20 40 80 00       	mov    0x804020,%eax
  80144e:	8b 80 bc 3c 01 00    	mov    0x13cbc(%eax),%eax
  801454:	85 c0                	test   %eax,%eax
  801456:	74 17                	je     80146f <_main+0x1437>
		{
			panic("LRU lists content is not correct");
  801458:	83 ec 04             	sub    $0x4,%esp
  80145b:	68 d0 38 80 00       	push   $0x8038d0
  801460:	68 62 01 00 00       	push   $0x162
  801465:	68 0b 37 80 00       	push   $0x80370b
  80146a:	e8 14 03 00 00       	call   801783 <_panic>
		}

		//Free 2nd 3 KB
		freeFrames = sys_calculate_free_frames() ;
  80146f:	e8 05 1b 00 00       	call   802f79 <sys_calculate_free_frames>
  801474:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80147a:	e8 7d 1b 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  80147f:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[3]);
  801485:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  80148b:	83 ec 0c             	sub    $0xc,%esp
  80148e:	50                   	push   %eax
  80148f:	e8 c9 17 00 00       	call   802c5d <free>
  801494:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  801497:	e8 60 1b 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  80149c:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  8014a2:	29 c2                	sub    %eax,%edx
  8014a4:	89 d0                	mov    %edx,%eax
  8014a6:	83 f8 01             	cmp    $0x1,%eax
  8014a9:	74 17                	je     8014c2 <_main+0x148a>
  8014ab:	83 ec 04             	sub    $0x4,%esp
  8014ae:	68 1c 38 80 00       	push   $0x80381c
  8014b3:	68 69 01 00 00       	push   $0x169
  8014b8:	68 0b 37 80 00       	push   $0x80370b
  8014bd:	e8 c1 02 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014c2:	e8 b2 1a 00 00       	call   802f79 <sys_calculate_free_frames>
  8014c7:	89 c2                	mov    %eax,%edx
  8014c9:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  8014cf:	39 c2                	cmp    %eax,%edx
  8014d1:	74 17                	je     8014ea <_main+0x14b2>
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	68 58 38 80 00       	push   $0x803858
  8014db:	68 6a 01 00 00       	push   $0x16a
  8014e0:	68 0b 37 80 00       	push   $0x80370b
  8014e5:	e8 99 02 00 00       	call   801783 <_panic>

		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  8014ea:	e8 8a 1a 00 00       	call   802f79 <sys_calculate_free_frames>
  8014ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8014f5:	e8 02 1b 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  8014fa:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		free(ptr_allocations[7]);
  801500:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	50                   	push   %eax
  80150a:	e8 4e 17 00 00       	call   802c5d <free>
  80150f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 4) panic("Wrong free: Extra or less pages are removed from PageFile");
  801512:	e8 e5 1a 00 00       	call   802ffc <sys_pf_calculate_allocated_pages>
  801517:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
  80151d:	29 c2                	sub    %eax,%edx
  80151f:	89 d0                	mov    %edx,%eax
  801521:	83 f8 04             	cmp    $0x4,%eax
  801524:	74 17                	je     80153d <_main+0x1505>
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	68 1c 38 80 00       	push   $0x80381c
  80152e:	68 70 01 00 00       	push   $0x170
  801533:	68 0b 37 80 00       	push   $0x80370b
  801538:	e8 46 02 00 00       	call   801783 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80153d:	e8 37 1a 00 00       	call   802f79 <sys_calculate_free_frames>
  801542:	89 c2                	mov    %eax,%edx
  801544:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	83 f8 03             	cmp    $0x3,%eax
  801551:	74 17                	je     80156a <_main+0x1532>
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	68 58 38 80 00       	push   $0x803858
  80155b:	68 71 01 00 00       	push   $0x171
  801560:	68 0b 37 80 00       	push   $0x80370b
  801565:	e8 19 02 00 00       	call   801783 <_panic>
//				panic("free: page is not removed from WS");
//			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
//				panic("free: page is not removed from WS");
//		}

		tmp_addresses[0] = (uint32)(&(shortArr2[0]));
  80156a:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  801570:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
		tmp_addresses[1] = (uint32)(&(shortArr2[lastIndexOfShort2]));
  801576:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  80157c:	01 c0                	add    %eax,%eax
  80157e:	89 c2                	mov    %eax,%edx
  801580:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  801586:	01 d0                	add    %edx,%eax
  801588:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
		check = sys_check_LRU_lists_free(tmp_addresses, 2);
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	6a 02                	push   $0x2
  801593:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	e8 ae 1e 00 00       	call   80344d <sys_check_LRU_lists_free>
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		if(check != 0)
  8015a8:	83 bd 18 ff ff ff 00 	cmpl   $0x0,-0xe8(%ebp)
  8015af:	74 17                	je     8015c8 <_main+0x1590>
		{
				panic("free: page is not removed from LRU lists");
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	68 a4 38 80 00       	push   $0x8038a4
  8015b9:	68 7f 01 00 00       	push   $0x17f
  8015be:	68 0b 37 80 00       	push   $0x80370b
  8015c3:	e8 bb 01 00 00       	call   801783 <_panic>
		}

		if(LIST_SIZE(&myEnv->ActiveList) != 792 && LIST_SIZE(&myEnv->SecondList) != 0)
  8015c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8015cd:	8b 80 ac 3c 01 00    	mov    0x13cac(%eax),%eax
  8015d3:	3d 18 03 00 00       	cmp    $0x318,%eax
  8015d8:	74 26                	je     801600 <_main+0x15c8>
  8015da:	a1 20 40 80 00       	mov    0x804020,%eax
  8015df:	8b 80 bc 3c 01 00    	mov    0x13cbc(%eax),%eax
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	74 17                	je     801600 <_main+0x15c8>
		{
			panic("LRU lists content is not correct");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 d0 38 80 00       	push   $0x8038d0
  8015f1:	68 84 01 00 00       	push   $0x184
  8015f6:	68 0b 37 80 00       	push   $0x80370b
  8015fb:	e8 83 01 00 00       	call   801783 <_panic>
		}

			if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
  801600:	e8 74 19 00 00       	call   802f79 <sys_calculate_free_frames>
  801605:	8d 50 04             	lea    0x4(%eax),%edx
  801608:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80160b:	39 c2                	cmp    %eax,%edx
  80160d:	74 17                	je     801626 <_main+0x15ee>
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 f4 38 80 00       	push   $0x8038f4
  801617:	68 87 01 00 00       	push   $0x187
  80161c:	68 0b 37 80 00       	push   $0x80370b
  801621:	e8 5d 01 00 00       	call   801783 <_panic>
		}

		cprintf("Congratulations!! test free [1] completed successfully.\n");
  801626:	83 ec 0c             	sub    $0xc,%esp
  801629:	68 28 39 80 00       	push   $0x803928
  80162e:	e8 f2 03 00 00       	call   801a25 <cprintf>
  801633:	83 c4 10             	add    $0x10,%esp

	return;
  801636:	90                   	nop
}
  801637:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5f                   	pop    %edi
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801644:	e8 65 18 00 00       	call   802eae <sys_getenvindex>
  801649:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80164c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164f:	89 d0                	mov    %edx,%eax
  801651:	c1 e0 03             	shl    $0x3,%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80165d:	01 c8                	add    %ecx,%eax
  80165f:	01 c0                	add    %eax,%eax
  801661:	01 d0                	add    %edx,%eax
  801663:	01 c0                	add    %eax,%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	89 c2                	mov    %eax,%edx
  801669:	c1 e2 05             	shl    $0x5,%edx
  80166c:	29 c2                	sub    %eax,%edx
  80166e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  801675:	89 c2                	mov    %eax,%edx
  801677:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80167d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801682:	a1 20 40 80 00       	mov    0x804020,%eax
  801687:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80168d:	84 c0                	test   %al,%al
  80168f:	74 0f                	je     8016a0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  801691:	a1 20 40 80 00       	mov    0x804020,%eax
  801696:	05 40 3c 01 00       	add    $0x13c40,%eax
  80169b:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8016a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016a4:	7e 0a                	jle    8016b0 <libmain+0x72>
		binaryname = argv[0];
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	ff 75 0c             	pushl  0xc(%ebp)
  8016b6:	ff 75 08             	pushl  0x8(%ebp)
  8016b9:	e8 7a e9 ff ff       	call   800038 <_main>
  8016be:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8016c1:	e8 83 19 00 00       	call   803049 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	68 7c 39 80 00       	push   $0x80397c
  8016ce:	e8 52 03 00 00       	call   801a25 <cprintf>
  8016d3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8016d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8016db:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8016e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8016e6:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	52                   	push   %edx
  8016f0:	50                   	push   %eax
  8016f1:	68 a4 39 80 00       	push   $0x8039a4
  8016f6:	e8 2a 03 00 00       	call   801a25 <cprintf>
  8016fb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8016fe:	a1 20 40 80 00       	mov    0x804020,%eax
  801703:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  801709:	a1 20 40 80 00       	mov    0x804020,%eax
  80170e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	68 cc 39 80 00       	push   $0x8039cc
  80171e:	e8 02 03 00 00       	call   801a25 <cprintf>
  801723:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801726:	a1 20 40 80 00       	mov    0x804020,%eax
  80172b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	50                   	push   %eax
  801735:	68 0d 3a 80 00       	push   $0x803a0d
  80173a:	e8 e6 02 00 00       	call   801a25 <cprintf>
  80173f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801742:	83 ec 0c             	sub    $0xc,%esp
  801745:	68 7c 39 80 00       	push   $0x80397c
  80174a:	e8 d6 02 00 00       	call   801a25 <cprintf>
  80174f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801752:	e8 0c 19 00 00       	call   803063 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801757:	e8 19 00 00 00       	call   801775 <exit>
}
  80175c:	90                   	nop
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	6a 00                	push   $0x0
  80176a:	e8 0b 17 00 00       	call   802e7a <sys_env_destroy>
  80176f:	83 c4 10             	add    $0x10,%esp
}
  801772:	90                   	nop
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <exit>:

void
exit(void)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80177b:	e8 60 17 00 00       	call   802ee0 <sys_env_exit>
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801789:	8d 45 10             	lea    0x10(%ebp),%eax
  80178c:	83 c0 04             	add    $0x4,%eax
  80178f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801792:	a1 18 41 80 00       	mov    0x804118,%eax
  801797:	85 c0                	test   %eax,%eax
  801799:	74 16                	je     8017b1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80179b:	a1 18 41 80 00       	mov    0x804118,%eax
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	50                   	push   %eax
  8017a4:	68 24 3a 80 00       	push   $0x803a24
  8017a9:	e8 77 02 00 00       	call   801a25 <cprintf>
  8017ae:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8017b1:	a1 00 40 80 00       	mov    0x804000,%eax
  8017b6:	ff 75 0c             	pushl  0xc(%ebp)
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	50                   	push   %eax
  8017bd:	68 29 3a 80 00       	push   $0x803a29
  8017c2:	e8 5e 02 00 00       	call   801a25 <cprintf>
  8017c7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8017ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cd:	83 ec 08             	sub    $0x8,%esp
  8017d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	e8 e1 01 00 00       	call   8019ba <vcprintf>
  8017d9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	6a 00                	push   $0x0
  8017e1:	68 45 3a 80 00       	push   $0x803a45
  8017e6:	e8 cf 01 00 00       	call   8019ba <vcprintf>
  8017eb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017ee:	e8 82 ff ff ff       	call   801775 <exit>

	// should not return here
	while (1) ;
  8017f3:	eb fe                	jmp    8017f3 <_panic+0x70>

008017f5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017fb:	a1 20 40 80 00       	mov    0x804020,%eax
  801800:	8b 50 74             	mov    0x74(%eax),%edx
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	39 c2                	cmp    %eax,%edx
  801808:	74 14                	je     80181e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 48 3a 80 00       	push   $0x803a48
  801812:	6a 26                	push   $0x26
  801814:	68 94 3a 80 00       	push   $0x803a94
  801819:	e8 65 ff ff ff       	call   801783 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80181e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801825:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80182c:	e9 b6 00 00 00       	jmp    8018e7 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	01 d0                	add    %edx,%eax
  801840:	8b 00                	mov    (%eax),%eax
  801842:	85 c0                	test   %eax,%eax
  801844:	75 08                	jne    80184e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801846:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801849:	e9 96 00 00 00       	jmp    8018e4 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80184e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801855:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80185c:	eb 5d                	jmp    8018bb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80185e:	a1 20 40 80 00       	mov    0x804020,%eax
  801863:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801869:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80186c:	c1 e2 04             	shl    $0x4,%edx
  80186f:	01 d0                	add    %edx,%eax
  801871:	8a 40 04             	mov    0x4(%eax),%al
  801874:	84 c0                	test   %al,%al
  801876:	75 40                	jne    8018b8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801878:	a1 20 40 80 00       	mov    0x804020,%eax
  80187d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801883:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801886:	c1 e2 04             	shl    $0x4,%edx
  801889:	01 d0                	add    %edx,%eax
  80188b:	8b 00                	mov    (%eax),%eax
  80188d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801890:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801893:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801898:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	01 c8                	add    %ecx,%eax
  8018a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018ab:	39 c2                	cmp    %eax,%edx
  8018ad:	75 09                	jne    8018b8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8018af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018b6:	eb 12                	jmp    8018ca <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018b8:	ff 45 e8             	incl   -0x18(%ebp)
  8018bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8018c0:	8b 50 74             	mov    0x74(%eax),%edx
  8018c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c6:	39 c2                	cmp    %eax,%edx
  8018c8:	77 94                	ja     80185e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018ce:	75 14                	jne    8018e4 <CheckWSWithoutLastIndex+0xef>
			panic(
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	68 a0 3a 80 00       	push   $0x803aa0
  8018d8:	6a 3a                	push   $0x3a
  8018da:	68 94 3a 80 00       	push   $0x803a94
  8018df:	e8 9f fe ff ff       	call   801783 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018e4:	ff 45 f0             	incl   -0x10(%ebp)
  8018e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018ed:	0f 8c 3e ff ff ff    	jl     801831 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801901:	eb 20                	jmp    801923 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801903:	a1 20 40 80 00       	mov    0x804020,%eax
  801908:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80190e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801911:	c1 e2 04             	shl    $0x4,%edx
  801914:	01 d0                	add    %edx,%eax
  801916:	8a 40 04             	mov    0x4(%eax),%al
  801919:	3c 01                	cmp    $0x1,%al
  80191b:	75 03                	jne    801920 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80191d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801920:	ff 45 e0             	incl   -0x20(%ebp)
  801923:	a1 20 40 80 00       	mov    0x804020,%eax
  801928:	8b 50 74             	mov    0x74(%eax),%edx
  80192b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192e:	39 c2                	cmp    %eax,%edx
  801930:	77 d1                	ja     801903 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801935:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801938:	74 14                	je     80194e <CheckWSWithoutLastIndex+0x159>
		panic(
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	68 f4 3a 80 00       	push   $0x803af4
  801942:	6a 44                	push   $0x44
  801944:	68 94 3a 80 00       	push   $0x803a94
  801949:	e8 35 fe ff ff       	call   801783 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80194e:	90                   	nop
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	8b 00                	mov    (%eax),%eax
  80195c:	8d 48 01             	lea    0x1(%eax),%ecx
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	89 0a                	mov    %ecx,(%edx)
  801964:	8b 55 08             	mov    0x8(%ebp),%edx
  801967:	88 d1                	mov    %dl,%cl
  801969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	8b 00                	mov    (%eax),%eax
  801975:	3d ff 00 00 00       	cmp    $0xff,%eax
  80197a:	75 2c                	jne    8019a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80197c:	a0 24 40 80 00       	mov    0x804024,%al
  801981:	0f b6 c0             	movzbl %al,%eax
  801984:	8b 55 0c             	mov    0xc(%ebp),%edx
  801987:	8b 12                	mov    (%edx),%edx
  801989:	89 d1                	mov    %edx,%ecx
  80198b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198e:	83 c2 08             	add    $0x8,%edx
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	50                   	push   %eax
  801995:	51                   	push   %ecx
  801996:	52                   	push   %edx
  801997:	e8 9c 14 00 00       	call   802e38 <sys_cputs>
  80199c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80199f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8019a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ab:	8b 40 04             	mov    0x4(%eax),%eax
  8019ae:	8d 50 01             	lea    0x1(%eax),%edx
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8019b7:	90                   	nop
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8019c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019ca:	00 00 00 
	b.cnt = 0;
  8019cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8019d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8019e3:	50                   	push   %eax
  8019e4:	68 51 19 80 00       	push   $0x801951
  8019e9:	e8 11 02 00 00       	call   801bff <vprintfmt>
  8019ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8019f1:	a0 24 40 80 00       	mov    0x804024,%al
  8019f6:	0f b6 c0             	movzbl %al,%eax
  8019f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	50                   	push   %eax
  801a03:	52                   	push   %edx
  801a04:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a0a:	83 c0 08             	add    $0x8,%eax
  801a0d:	50                   	push   %eax
  801a0e:	e8 25 14 00 00       	call   802e38 <sys_cputs>
  801a13:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801a16:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  801a1d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <cprintf>:

int cprintf(const char *fmt, ...) {
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a2b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801a32:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	83 ec 08             	sub    $0x8,%esp
  801a3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a41:	50                   	push   %eax
  801a42:	e8 73 ff ff ff       	call   8019ba <vcprintf>
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a58:	e8 ec 15 00 00       	call   803049 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a5d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	83 ec 08             	sub    $0x8,%esp
  801a69:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	e8 48 ff ff ff       	call   8019ba <vcprintf>
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801a78:	e8 e6 15 00 00       	call   803063 <sys_enable_interrupt>
	return cnt;
  801a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	53                   	push   %ebx
  801a86:	83 ec 14             	sub    $0x14,%esp
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801a95:	8b 45 18             	mov    0x18(%ebp),%eax
  801a98:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801aa0:	77 55                	ja     801af7 <printnum+0x75>
  801aa2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801aa5:	72 05                	jb     801aac <printnum+0x2a>
  801aa7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801aaa:	77 4b                	ja     801af7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801aac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801aaf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801ab2:	8b 45 18             	mov    0x18(%ebp),%eax
  801ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	ff 75 f4             	pushl  -0xc(%ebp)
  801abf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac2:	e8 a5 19 00 00       	call   80346c <__udivdi3>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	ff 75 20             	pushl  0x20(%ebp)
  801ad0:	53                   	push   %ebx
  801ad1:	ff 75 18             	pushl  0x18(%ebp)
  801ad4:	52                   	push   %edx
  801ad5:	50                   	push   %eax
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	ff 75 08             	pushl  0x8(%ebp)
  801adc:	e8 a1 ff ff ff       	call   801a82 <printnum>
  801ae1:	83 c4 20             	add    $0x20,%esp
  801ae4:	eb 1a                	jmp    801b00 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801ae6:	83 ec 08             	sub    $0x8,%esp
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	ff 75 20             	pushl  0x20(%ebp)
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	ff d0                	call   *%eax
  801af4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801af7:	ff 4d 1c             	decl   0x1c(%ebp)
  801afa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801afe:	7f e6                	jg     801ae6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b00:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b03:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b0e:	53                   	push   %ebx
  801b0f:	51                   	push   %ecx
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	e8 65 1a 00 00       	call   80357c <__umoddi3>
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	05 54 3d 80 00       	add    $0x803d54,%eax
  801b1f:	8a 00                	mov    (%eax),%al
  801b21:	0f be c0             	movsbl %al,%eax
  801b24:	83 ec 08             	sub    $0x8,%esp
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	50                   	push   %eax
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	ff d0                	call   *%eax
  801b30:	83 c4 10             	add    $0x10,%esp
}
  801b33:	90                   	nop
  801b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b40:	7e 1c                	jle    801b5e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	8b 00                	mov    (%eax),%eax
  801b47:	8d 50 08             	lea    0x8(%eax),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	89 10                	mov    %edx,(%eax)
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	8b 00                	mov    (%eax),%eax
  801b54:	83 e8 08             	sub    $0x8,%eax
  801b57:	8b 50 04             	mov    0x4(%eax),%edx
  801b5a:	8b 00                	mov    (%eax),%eax
  801b5c:	eb 40                	jmp    801b9e <getuint+0x65>
	else if (lflag)
  801b5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b62:	74 1e                	je     801b82 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8b 00                	mov    (%eax),%eax
  801b69:	8d 50 04             	lea    0x4(%eax),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	89 10                	mov    %edx,(%eax)
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8b 00                	mov    (%eax),%eax
  801b76:	83 e8 04             	sub    $0x4,%eax
  801b79:	8b 00                	mov    (%eax),%eax
  801b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b80:	eb 1c                	jmp    801b9e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	8b 00                	mov    (%eax),%eax
  801b87:	8d 50 04             	lea    0x4(%eax),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	89 10                	mov    %edx,(%eax)
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	8b 00                	mov    (%eax),%eax
  801b94:	83 e8 04             	sub    $0x4,%eax
  801b97:	8b 00                	mov    (%eax),%eax
  801b99:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801ba3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801ba7:	7e 1c                	jle    801bc5 <getint+0x25>
		return va_arg(*ap, long long);
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	8b 00                	mov    (%eax),%eax
  801bae:	8d 50 08             	lea    0x8(%eax),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	89 10                	mov    %edx,(%eax)
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	8b 00                	mov    (%eax),%eax
  801bbb:	83 e8 08             	sub    $0x8,%eax
  801bbe:	8b 50 04             	mov    0x4(%eax),%edx
  801bc1:	8b 00                	mov    (%eax),%eax
  801bc3:	eb 38                	jmp    801bfd <getint+0x5d>
	else if (lflag)
  801bc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bc9:	74 1a                	je     801be5 <getint+0x45>
		return va_arg(*ap, long);
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	8b 00                	mov    (%eax),%eax
  801bd0:	8d 50 04             	lea    0x4(%eax),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	89 10                	mov    %edx,(%eax)
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	8b 00                	mov    (%eax),%eax
  801bdd:	83 e8 04             	sub    $0x4,%eax
  801be0:	8b 00                	mov    (%eax),%eax
  801be2:	99                   	cltd   
  801be3:	eb 18                	jmp    801bfd <getint+0x5d>
	else
		return va_arg(*ap, int);
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	8b 00                	mov    (%eax),%eax
  801bea:	8d 50 04             	lea    0x4(%eax),%edx
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	89 10                	mov    %edx,(%eax)
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	8b 00                	mov    (%eax),%eax
  801bf7:	83 e8 04             	sub    $0x4,%eax
  801bfa:	8b 00                	mov    (%eax),%eax
  801bfc:	99                   	cltd   
}
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    

00801bff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c07:	eb 17                	jmp    801c20 <vprintfmt+0x21>
			if (ch == '\0')
  801c09:	85 db                	test   %ebx,%ebx
  801c0b:	0f 84 af 03 00 00    	je     801fc0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	53                   	push   %ebx
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	ff d0                	call   *%eax
  801c1d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c20:	8b 45 10             	mov    0x10(%ebp),%eax
  801c23:	8d 50 01             	lea    0x1(%eax),%edx
  801c26:	89 55 10             	mov    %edx,0x10(%ebp)
  801c29:	8a 00                	mov    (%eax),%al
  801c2b:	0f b6 d8             	movzbl %al,%ebx
  801c2e:	83 fb 25             	cmp    $0x25,%ebx
  801c31:	75 d6                	jne    801c09 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801c33:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801c37:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801c3e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801c45:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801c4c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c53:	8b 45 10             	mov    0x10(%ebp),%eax
  801c56:	8d 50 01             	lea    0x1(%eax),%edx
  801c59:	89 55 10             	mov    %edx,0x10(%ebp)
  801c5c:	8a 00                	mov    (%eax),%al
  801c5e:	0f b6 d8             	movzbl %al,%ebx
  801c61:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801c64:	83 f8 55             	cmp    $0x55,%eax
  801c67:	0f 87 2b 03 00 00    	ja     801f98 <vprintfmt+0x399>
  801c6d:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  801c74:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801c76:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801c7a:	eb d7                	jmp    801c53 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801c7c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801c80:	eb d1                	jmp    801c53 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801c82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801c89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8c:	89 d0                	mov    %edx,%eax
  801c8e:	c1 e0 02             	shl    $0x2,%eax
  801c91:	01 d0                	add    %edx,%eax
  801c93:	01 c0                	add    %eax,%eax
  801c95:	01 d8                	add    %ebx,%eax
  801c97:	83 e8 30             	sub    $0x30,%eax
  801c9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca0:	8a 00                	mov    (%eax),%al
  801ca2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ca5:	83 fb 2f             	cmp    $0x2f,%ebx
  801ca8:	7e 3e                	jle    801ce8 <vprintfmt+0xe9>
  801caa:	83 fb 39             	cmp    $0x39,%ebx
  801cad:	7f 39                	jg     801ce8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801caf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801cb2:	eb d5                	jmp    801c89 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb7:	83 c0 04             	add    $0x4,%eax
  801cba:	89 45 14             	mov    %eax,0x14(%ebp)
  801cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc0:	83 e8 04             	sub    $0x4,%eax
  801cc3:	8b 00                	mov    (%eax),%eax
  801cc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801cc8:	eb 1f                	jmp    801ce9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801cca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cce:	79 83                	jns    801c53 <vprintfmt+0x54>
				width = 0;
  801cd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801cd7:	e9 77 ff ff ff       	jmp    801c53 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801cdc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801ce3:	e9 6b ff ff ff       	jmp    801c53 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ce8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ce9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ced:	0f 89 60 ff ff ff    	jns    801c53 <vprintfmt+0x54>
				width = precision, precision = -1;
  801cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cf9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d00:	e9 4e ff ff ff       	jmp    801c53 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d05:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801d08:	e9 46 ff ff ff       	jmp    801c53 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d10:	83 c0 04             	add    $0x4,%eax
  801d13:	89 45 14             	mov    %eax,0x14(%ebp)
  801d16:	8b 45 14             	mov    0x14(%ebp),%eax
  801d19:	83 e8 04             	sub    $0x4,%eax
  801d1c:	8b 00                	mov    (%eax),%eax
  801d1e:	83 ec 08             	sub    $0x8,%esp
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	50                   	push   %eax
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff d0                	call   *%eax
  801d2a:	83 c4 10             	add    $0x10,%esp
			break;
  801d2d:	e9 89 02 00 00       	jmp    801fbb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801d32:	8b 45 14             	mov    0x14(%ebp),%eax
  801d35:	83 c0 04             	add    $0x4,%eax
  801d38:	89 45 14             	mov    %eax,0x14(%ebp)
  801d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3e:	83 e8 04             	sub    $0x4,%eax
  801d41:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801d43:	85 db                	test   %ebx,%ebx
  801d45:	79 02                	jns    801d49 <vprintfmt+0x14a>
				err = -err;
  801d47:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801d49:	83 fb 64             	cmp    $0x64,%ebx
  801d4c:	7f 0b                	jg     801d59 <vprintfmt+0x15a>
  801d4e:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  801d55:	85 f6                	test   %esi,%esi
  801d57:	75 19                	jne    801d72 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801d59:	53                   	push   %ebx
  801d5a:	68 65 3d 80 00       	push   $0x803d65
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	e8 5e 02 00 00       	call   801fc8 <printfmt>
  801d6a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801d6d:	e9 49 02 00 00       	jmp    801fbb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801d72:	56                   	push   %esi
  801d73:	68 6e 3d 80 00       	push   $0x803d6e
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 45 02 00 00       	call   801fc8 <printfmt>
  801d83:	83 c4 10             	add    $0x10,%esp
			break;
  801d86:	e9 30 02 00 00       	jmp    801fbb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8e:	83 c0 04             	add    $0x4,%eax
  801d91:	89 45 14             	mov    %eax,0x14(%ebp)
  801d94:	8b 45 14             	mov    0x14(%ebp),%eax
  801d97:	83 e8 04             	sub    $0x4,%eax
  801d9a:	8b 30                	mov    (%eax),%esi
  801d9c:	85 f6                	test   %esi,%esi
  801d9e:	75 05                	jne    801da5 <vprintfmt+0x1a6>
				p = "(null)";
  801da0:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  801da5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801da9:	7e 6d                	jle    801e18 <vprintfmt+0x219>
  801dab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801daf:	74 67                	je     801e18 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801db1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db4:	83 ec 08             	sub    $0x8,%esp
  801db7:	50                   	push   %eax
  801db8:	56                   	push   %esi
  801db9:	e8 0c 03 00 00       	call   8020ca <strnlen>
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801dc4:	eb 16                	jmp    801ddc <vprintfmt+0x1dd>
					putch(padc, putdat);
  801dc6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	50                   	push   %eax
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	ff d0                	call   *%eax
  801dd6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801dd9:	ff 4d e4             	decl   -0x1c(%ebp)
  801ddc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801de0:	7f e4                	jg     801dc6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801de2:	eb 34                	jmp    801e18 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801de4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801de8:	74 1c                	je     801e06 <vprintfmt+0x207>
  801dea:	83 fb 1f             	cmp    $0x1f,%ebx
  801ded:	7e 05                	jle    801df4 <vprintfmt+0x1f5>
  801def:	83 fb 7e             	cmp    $0x7e,%ebx
  801df2:	7e 12                	jle    801e06 <vprintfmt+0x207>
					putch('?', putdat);
  801df4:	83 ec 08             	sub    $0x8,%esp
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	6a 3f                	push   $0x3f
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	ff d0                	call   *%eax
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	eb 0f                	jmp    801e15 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801e06:	83 ec 08             	sub    $0x8,%esp
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	53                   	push   %ebx
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	ff d0                	call   *%eax
  801e12:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e15:	ff 4d e4             	decl   -0x1c(%ebp)
  801e18:	89 f0                	mov    %esi,%eax
  801e1a:	8d 70 01             	lea    0x1(%eax),%esi
  801e1d:	8a 00                	mov    (%eax),%al
  801e1f:	0f be d8             	movsbl %al,%ebx
  801e22:	85 db                	test   %ebx,%ebx
  801e24:	74 24                	je     801e4a <vprintfmt+0x24b>
  801e26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e2a:	78 b8                	js     801de4 <vprintfmt+0x1e5>
  801e2c:	ff 4d e0             	decl   -0x20(%ebp)
  801e2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e33:	79 af                	jns    801de4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e35:	eb 13                	jmp    801e4a <vprintfmt+0x24b>
				putch(' ', putdat);
  801e37:	83 ec 08             	sub    $0x8,%esp
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	6a 20                	push   $0x20
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	ff d0                	call   *%eax
  801e44:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e47:	ff 4d e4             	decl   -0x1c(%ebp)
  801e4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e4e:	7f e7                	jg     801e37 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801e50:	e9 66 01 00 00       	jmp    801fbb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	ff 75 e8             	pushl  -0x18(%ebp)
  801e5b:	8d 45 14             	lea    0x14(%ebp),%eax
  801e5e:	50                   	push   %eax
  801e5f:	e8 3c fd ff ff       	call   801ba0 <getint>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e73:	85 d2                	test   %edx,%edx
  801e75:	79 23                	jns    801e9a <vprintfmt+0x29b>
				putch('-', putdat);
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	6a 2d                	push   $0x2d
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	ff d0                	call   *%eax
  801e84:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e8d:	f7 d8                	neg    %eax
  801e8f:	83 d2 00             	adc    $0x0,%edx
  801e92:	f7 da                	neg    %edx
  801e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801e9a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ea1:	e9 bc 00 00 00       	jmp    801f62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ea6:	83 ec 08             	sub    $0x8,%esp
  801ea9:	ff 75 e8             	pushl  -0x18(%ebp)
  801eac:	8d 45 14             	lea    0x14(%ebp),%eax
  801eaf:	50                   	push   %eax
  801eb0:	e8 84 fc ff ff       	call   801b39 <getuint>
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ebb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801ebe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ec5:	e9 98 00 00 00       	jmp    801f62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801eca:	83 ec 08             	sub    $0x8,%esp
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	6a 58                	push   $0x58
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	ff d0                	call   *%eax
  801ed7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801eda:	83 ec 08             	sub    $0x8,%esp
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	6a 58                	push   $0x58
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	ff d0                	call   *%eax
  801ee7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801eea:	83 ec 08             	sub    $0x8,%esp
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	6a 58                	push   $0x58
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	ff d0                	call   *%eax
  801ef7:	83 c4 10             	add    $0x10,%esp
			break;
  801efa:	e9 bc 00 00 00       	jmp    801fbb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801eff:	83 ec 08             	sub    $0x8,%esp
  801f02:	ff 75 0c             	pushl  0xc(%ebp)
  801f05:	6a 30                	push   $0x30
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	ff d0                	call   *%eax
  801f0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801f0f:	83 ec 08             	sub    $0x8,%esp
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	6a 78                	push   $0x78
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	ff d0                	call   *%eax
  801f1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801f1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801f22:	83 c0 04             	add    $0x4,%eax
  801f25:	89 45 14             	mov    %eax,0x14(%ebp)
  801f28:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2b:	83 e8 04             	sub    $0x4,%eax
  801f2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801f3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801f41:	eb 1f                	jmp    801f62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f43:	83 ec 08             	sub    $0x8,%esp
  801f46:	ff 75 e8             	pushl  -0x18(%ebp)
  801f49:	8d 45 14             	lea    0x14(%ebp),%eax
  801f4c:	50                   	push   %eax
  801f4d:	e8 e7 fb ff ff       	call   801b39 <getuint>
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801f5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801f62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	52                   	push   %edx
  801f6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f70:	50                   	push   %eax
  801f71:	ff 75 f4             	pushl  -0xc(%ebp)
  801f74:	ff 75 f0             	pushl  -0x10(%ebp)
  801f77:	ff 75 0c             	pushl  0xc(%ebp)
  801f7a:	ff 75 08             	pushl  0x8(%ebp)
  801f7d:	e8 00 fb ff ff       	call   801a82 <printnum>
  801f82:	83 c4 20             	add    $0x20,%esp
			break;
  801f85:	eb 34                	jmp    801fbb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801f87:	83 ec 08             	sub    $0x8,%esp
  801f8a:	ff 75 0c             	pushl  0xc(%ebp)
  801f8d:	53                   	push   %ebx
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	ff d0                	call   *%eax
  801f93:	83 c4 10             	add    $0x10,%esp
			break;
  801f96:	eb 23                	jmp    801fbb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	6a 25                	push   $0x25
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	ff d0                	call   *%eax
  801fa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801fa8:	ff 4d 10             	decl   0x10(%ebp)
  801fab:	eb 03                	jmp    801fb0 <vprintfmt+0x3b1>
  801fad:	ff 4d 10             	decl   0x10(%ebp)
  801fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb3:	48                   	dec    %eax
  801fb4:	8a 00                	mov    (%eax),%al
  801fb6:	3c 25                	cmp    $0x25,%al
  801fb8:	75 f3                	jne    801fad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801fba:	90                   	nop
		}
	}
  801fbb:	e9 47 fc ff ff       	jmp    801c07 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801fc0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801fc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    

00801fc8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801fce:	8d 45 10             	lea    0x10(%ebp),%eax
  801fd1:	83 c0 04             	add    $0x4,%eax
  801fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fda:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdd:	50                   	push   %eax
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	ff 75 08             	pushl  0x8(%ebp)
  801fe4:	e8 16 fc ff ff       	call   801bff <vprintfmt>
  801fe9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801fec:	90                   	nop
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff5:	8b 40 08             	mov    0x8(%eax),%eax
  801ff8:	8d 50 01             	lea    0x1(%eax),%edx
  801ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802001:	8b 45 0c             	mov    0xc(%ebp),%eax
  802004:	8b 10                	mov    (%eax),%edx
  802006:	8b 45 0c             	mov    0xc(%ebp),%eax
  802009:	8b 40 04             	mov    0x4(%eax),%eax
  80200c:	39 c2                	cmp    %eax,%edx
  80200e:	73 12                	jae    802022 <sprintputch+0x33>
		*b->buf++ = ch;
  802010:	8b 45 0c             	mov    0xc(%ebp),%eax
  802013:	8b 00                	mov    (%eax),%eax
  802015:	8d 48 01             	lea    0x1(%eax),%ecx
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	89 0a                	mov    %ecx,(%edx)
  80201d:	8b 55 08             	mov    0x8(%ebp),%edx
  802020:	88 10                	mov    %dl,(%eax)
}
  802022:	90                   	nop
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    

00802025 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	8d 50 ff             	lea    -0x1(%eax),%edx
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	01 d0                	add    %edx,%eax
  80203c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80203f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204a:	74 06                	je     802052 <vsnprintf+0x2d>
  80204c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802050:	7f 07                	jg     802059 <vsnprintf+0x34>
		return -E_INVAL;
  802052:	b8 03 00 00 00       	mov    $0x3,%eax
  802057:	eb 20                	jmp    802079 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802059:	ff 75 14             	pushl  0x14(%ebp)
  80205c:	ff 75 10             	pushl  0x10(%ebp)
  80205f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802062:	50                   	push   %eax
  802063:	68 ef 1f 80 00       	push   $0x801fef
  802068:	e8 92 fb ff ff       	call   801bff <vprintfmt>
  80206d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802073:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802081:	8d 45 10             	lea    0x10(%ebp),%eax
  802084:	83 c0 04             	add    $0x4,%eax
  802087:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80208a:	8b 45 10             	mov    0x10(%ebp),%eax
  80208d:	ff 75 f4             	pushl  -0xc(%ebp)
  802090:	50                   	push   %eax
  802091:	ff 75 0c             	pushl  0xc(%ebp)
  802094:	ff 75 08             	pushl  0x8(%ebp)
  802097:	e8 89 ff ff ff       	call   802025 <vsnprintf>
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8020a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8020ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8020b4:	eb 06                	jmp    8020bc <strlen+0x15>
		n++;
  8020b6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8020b9:	ff 45 08             	incl   0x8(%ebp)
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8a 00                	mov    (%eax),%al
  8020c1:	84 c0                	test   %al,%al
  8020c3:	75 f1                	jne    8020b6 <strlen+0xf>
		n++;
	return n;
  8020c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8020d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8020d7:	eb 09                	jmp    8020e2 <strnlen+0x18>
		n++;
  8020d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8020dc:	ff 45 08             	incl   0x8(%ebp)
  8020df:	ff 4d 0c             	decl   0xc(%ebp)
  8020e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020e6:	74 09                	je     8020f1 <strnlen+0x27>
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	8a 00                	mov    (%eax),%al
  8020ed:	84 c0                	test   %al,%al
  8020ef:	75 e8                	jne    8020d9 <strnlen+0xf>
		n++;
	return n;
  8020f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802102:	90                   	nop
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	8d 50 01             	lea    0x1(%eax),%edx
  802109:	89 55 08             	mov    %edx,0x8(%ebp)
  80210c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802112:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802115:	8a 12                	mov    (%edx),%dl
  802117:	88 10                	mov    %dl,(%eax)
  802119:	8a 00                	mov    (%eax),%al
  80211b:	84 c0                	test   %al,%al
  80211d:	75 e4                	jne    802103 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80211f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802130:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802137:	eb 1f                	jmp    802158 <strncpy+0x34>
		*dst++ = *src;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8d 50 01             	lea    0x1(%eax),%edx
  80213f:	89 55 08             	mov    %edx,0x8(%ebp)
  802142:	8b 55 0c             	mov    0xc(%ebp),%edx
  802145:	8a 12                	mov    (%edx),%dl
  802147:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214c:	8a 00                	mov    (%eax),%al
  80214e:	84 c0                	test   %al,%al
  802150:	74 03                	je     802155 <strncpy+0x31>
			src++;
  802152:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802155:	ff 45 fc             	incl   -0x4(%ebp)
  802158:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80215e:	72 d9                	jb     802139 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802160:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802171:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802175:	74 30                	je     8021a7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802177:	eb 16                	jmp    80218f <strlcpy+0x2a>
			*dst++ = *src++;
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8d 50 01             	lea    0x1(%eax),%edx
  80217f:	89 55 08             	mov    %edx,0x8(%ebp)
  802182:	8b 55 0c             	mov    0xc(%ebp),%edx
  802185:	8d 4a 01             	lea    0x1(%edx),%ecx
  802188:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80218b:	8a 12                	mov    (%edx),%dl
  80218d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80218f:	ff 4d 10             	decl   0x10(%ebp)
  802192:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802196:	74 09                	je     8021a1 <strlcpy+0x3c>
  802198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219b:	8a 00                	mov    (%eax),%al
  80219d:	84 c0                	test   %al,%al
  80219f:	75 d8                	jne    802179 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8021a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ad:	29 c2                	sub    %eax,%edx
  8021af:	89 d0                	mov    %edx,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8021b6:	eb 06                	jmp    8021be <strcmp+0xb>
		p++, q++;
  8021b8:	ff 45 08             	incl   0x8(%ebp)
  8021bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	8a 00                	mov    (%eax),%al
  8021c3:	84 c0                	test   %al,%al
  8021c5:	74 0e                	je     8021d5 <strcmp+0x22>
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	8a 10                	mov    (%eax),%dl
  8021cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cf:	8a 00                	mov    (%eax),%al
  8021d1:	38 c2                	cmp    %al,%dl
  8021d3:	74 e3                	je     8021b8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8a 00                	mov    (%eax),%al
  8021da:	0f b6 d0             	movzbl %al,%edx
  8021dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e0:	8a 00                	mov    (%eax),%al
  8021e2:	0f b6 c0             	movzbl %al,%eax
  8021e5:	29 c2                	sub    %eax,%edx
  8021e7:	89 d0                	mov    %edx,%eax
}
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    

008021eb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8021ee:	eb 09                	jmp    8021f9 <strncmp+0xe>
		n--, p++, q++;
  8021f0:	ff 4d 10             	decl   0x10(%ebp)
  8021f3:	ff 45 08             	incl   0x8(%ebp)
  8021f6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8021f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021fd:	74 17                	je     802216 <strncmp+0x2b>
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	8a 00                	mov    (%eax),%al
  802204:	84 c0                	test   %al,%al
  802206:	74 0e                	je     802216 <strncmp+0x2b>
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8a 10                	mov    (%eax),%dl
  80220d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802210:	8a 00                	mov    (%eax),%al
  802212:	38 c2                	cmp    %al,%dl
  802214:	74 da                	je     8021f0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80221a:	75 07                	jne    802223 <strncmp+0x38>
		return 0;
  80221c:	b8 00 00 00 00       	mov    $0x0,%eax
  802221:	eb 14                	jmp    802237 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	8a 00                	mov    (%eax),%al
  802228:	0f b6 d0             	movzbl %al,%edx
  80222b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222e:	8a 00                	mov    (%eax),%al
  802230:	0f b6 c0             	movzbl %al,%eax
  802233:	29 c2                	sub    %eax,%edx
  802235:	89 d0                	mov    %edx,%eax
}
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802242:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802245:	eb 12                	jmp    802259 <strchr+0x20>
		if (*s == c)
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80224f:	75 05                	jne    802256 <strchr+0x1d>
			return (char *) s;
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	eb 11                	jmp    802267 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802256:	ff 45 08             	incl   0x8(%ebp)
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8a 00                	mov    (%eax),%al
  80225e:	84 c0                	test   %al,%al
  802260:	75 e5                	jne    802247 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802262:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	83 ec 04             	sub    $0x4,%esp
  80226f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802272:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802275:	eb 0d                	jmp    802284 <strfind+0x1b>
		if (*s == c)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8a 00                	mov    (%eax),%al
  80227c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80227f:	74 0e                	je     80228f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802281:	ff 45 08             	incl   0x8(%ebp)
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8a 00                	mov    (%eax),%al
  802289:	84 c0                	test   %al,%al
  80228b:	75 ea                	jne    802277 <strfind+0xe>
  80228d:	eb 01                	jmp    802290 <strfind+0x27>
		if (*s == c)
			break;
  80228f:	90                   	nop
	return (char *) s;
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8022a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8022a7:	eb 0e                	jmp    8022b7 <memset+0x22>
		*p++ = c;
  8022a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ac:	8d 50 01             	lea    0x1(%eax),%edx
  8022af:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8022b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8022b7:	ff 4d f8             	decl   -0x8(%ebp)
  8022ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8022be:	79 e9                	jns    8022a9 <memset+0x14>
		*p++ = c;

	return v;
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8022d7:	eb 16                	jmp    8022ef <memcpy+0x2a>
		*d++ = *s++;
  8022d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022dc:	8d 50 01             	lea    0x1(%eax),%edx
  8022df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022e8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022eb:	8a 12                	mov    (%edx),%dl
  8022ed:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8022ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	75 dd                	jne    8022d9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802316:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802319:	73 50                	jae    80236b <memmove+0x6a>
  80231b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80231e:	8b 45 10             	mov    0x10(%ebp),%eax
  802321:	01 d0                	add    %edx,%eax
  802323:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802326:	76 43                	jbe    80236b <memmove+0x6a>
		s += n;
  802328:	8b 45 10             	mov    0x10(%ebp),%eax
  80232b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80232e:	8b 45 10             	mov    0x10(%ebp),%eax
  802331:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802334:	eb 10                	jmp    802346 <memmove+0x45>
			*--d = *--s;
  802336:	ff 4d f8             	decl   -0x8(%ebp)
  802339:	ff 4d fc             	decl   -0x4(%ebp)
  80233c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233f:	8a 10                	mov    (%eax),%dl
  802341:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802344:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802346:	8b 45 10             	mov    0x10(%ebp),%eax
  802349:	8d 50 ff             	lea    -0x1(%eax),%edx
  80234c:	89 55 10             	mov    %edx,0x10(%ebp)
  80234f:	85 c0                	test   %eax,%eax
  802351:	75 e3                	jne    802336 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802353:	eb 23                	jmp    802378 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802355:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802358:	8d 50 01             	lea    0x1(%eax),%edx
  80235b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80235e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802361:	8d 4a 01             	lea    0x1(%edx),%ecx
  802364:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802367:	8a 12                	mov    (%edx),%dl
  802369:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80236b:	8b 45 10             	mov    0x10(%ebp),%eax
  80236e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802371:	89 55 10             	mov    %edx,0x10(%ebp)
  802374:	85 c0                	test   %eax,%eax
  802376:	75 dd                	jne    802355 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
  802380:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80238f:	eb 2a                	jmp    8023bb <memcmp+0x3e>
		if (*s1 != *s2)
  802391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802394:	8a 10                	mov    (%eax),%dl
  802396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802399:	8a 00                	mov    (%eax),%al
  80239b:	38 c2                	cmp    %al,%dl
  80239d:	74 16                	je     8023b5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80239f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a2:	8a 00                	mov    (%eax),%al
  8023a4:	0f b6 d0             	movzbl %al,%edx
  8023a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023aa:	8a 00                	mov    (%eax),%al
  8023ac:	0f b6 c0             	movzbl %al,%eax
  8023af:	29 c2                	sub    %eax,%edx
  8023b1:	89 d0                	mov    %edx,%eax
  8023b3:	eb 18                	jmp    8023cd <memcmp+0x50>
		s1++, s2++;
  8023b5:	ff 45 fc             	incl   -0x4(%ebp)
  8023b8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8023bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8023be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	75 c9                	jne    802391 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8023d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023db:	01 d0                	add    %edx,%eax
  8023dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8023e0:	eb 15                	jmp    8023f7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	8a 00                	mov    (%eax),%al
  8023e7:	0f b6 d0             	movzbl %al,%edx
  8023ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ed:	0f b6 c0             	movzbl %al,%eax
  8023f0:	39 c2                	cmp    %eax,%edx
  8023f2:	74 0d                	je     802401 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8023f4:	ff 45 08             	incl   0x8(%ebp)
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8023fd:	72 e3                	jb     8023e2 <memfind+0x13>
  8023ff:	eb 01                	jmp    802402 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802401:	90                   	nop
	return (void *) s;
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80240d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802414:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80241b:	eb 03                	jmp    802420 <strtol+0x19>
		s++;
  80241d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	8a 00                	mov    (%eax),%al
  802425:	3c 20                	cmp    $0x20,%al
  802427:	74 f4                	je     80241d <strtol+0x16>
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	8a 00                	mov    (%eax),%al
  80242e:	3c 09                	cmp    $0x9,%al
  802430:	74 eb                	je     80241d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	8a 00                	mov    (%eax),%al
  802437:	3c 2b                	cmp    $0x2b,%al
  802439:	75 05                	jne    802440 <strtol+0x39>
		s++;
  80243b:	ff 45 08             	incl   0x8(%ebp)
  80243e:	eb 13                	jmp    802453 <strtol+0x4c>
	else if (*s == '-')
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	8a 00                	mov    (%eax),%al
  802445:	3c 2d                	cmp    $0x2d,%al
  802447:	75 0a                	jne    802453 <strtol+0x4c>
		s++, neg = 1;
  802449:	ff 45 08             	incl   0x8(%ebp)
  80244c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802453:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802457:	74 06                	je     80245f <strtol+0x58>
  802459:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80245d:	75 20                	jne    80247f <strtol+0x78>
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	8a 00                	mov    (%eax),%al
  802464:	3c 30                	cmp    $0x30,%al
  802466:	75 17                	jne    80247f <strtol+0x78>
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	40                   	inc    %eax
  80246c:	8a 00                	mov    (%eax),%al
  80246e:	3c 78                	cmp    $0x78,%al
  802470:	75 0d                	jne    80247f <strtol+0x78>
		s += 2, base = 16;
  802472:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802476:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80247d:	eb 28                	jmp    8024a7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80247f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802483:	75 15                	jne    80249a <strtol+0x93>
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8a 00                	mov    (%eax),%al
  80248a:	3c 30                	cmp    $0x30,%al
  80248c:	75 0c                	jne    80249a <strtol+0x93>
		s++, base = 8;
  80248e:	ff 45 08             	incl   0x8(%ebp)
  802491:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802498:	eb 0d                	jmp    8024a7 <strtol+0xa0>
	else if (base == 0)
  80249a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80249e:	75 07                	jne    8024a7 <strtol+0xa0>
		base = 10;
  8024a0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	8a 00                	mov    (%eax),%al
  8024ac:	3c 2f                	cmp    $0x2f,%al
  8024ae:	7e 19                	jle    8024c9 <strtol+0xc2>
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	8a 00                	mov    (%eax),%al
  8024b5:	3c 39                	cmp    $0x39,%al
  8024b7:	7f 10                	jg     8024c9 <strtol+0xc2>
			dig = *s - '0';
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8a 00                	mov    (%eax),%al
  8024be:	0f be c0             	movsbl %al,%eax
  8024c1:	83 e8 30             	sub    $0x30,%eax
  8024c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c7:	eb 42                	jmp    80250b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	8a 00                	mov    (%eax),%al
  8024ce:	3c 60                	cmp    $0x60,%al
  8024d0:	7e 19                	jle    8024eb <strtol+0xe4>
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	8a 00                	mov    (%eax),%al
  8024d7:	3c 7a                	cmp    $0x7a,%al
  8024d9:	7f 10                	jg     8024eb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	8a 00                	mov    (%eax),%al
  8024e0:	0f be c0             	movsbl %al,%eax
  8024e3:	83 e8 57             	sub    $0x57,%eax
  8024e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e9:	eb 20                	jmp    80250b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	8a 00                	mov    (%eax),%al
  8024f0:	3c 40                	cmp    $0x40,%al
  8024f2:	7e 39                	jle    80252d <strtol+0x126>
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	8a 00                	mov    (%eax),%al
  8024f9:	3c 5a                	cmp    $0x5a,%al
  8024fb:	7f 30                	jg     80252d <strtol+0x126>
			dig = *s - 'A' + 10;
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	8a 00                	mov    (%eax),%al
  802502:	0f be c0             	movsbl %al,%eax
  802505:	83 e8 37             	sub    $0x37,%eax
  802508:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	3b 45 10             	cmp    0x10(%ebp),%eax
  802511:	7d 19                	jge    80252c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802513:	ff 45 08             	incl   0x8(%ebp)
  802516:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802519:	0f af 45 10          	imul   0x10(%ebp),%eax
  80251d:	89 c2                	mov    %eax,%edx
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	01 d0                	add    %edx,%eax
  802524:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802527:	e9 7b ff ff ff       	jmp    8024a7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80252c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80252d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802531:	74 08                	je     80253b <strtol+0x134>
		*endptr = (char *) s;
  802533:	8b 45 0c             	mov    0xc(%ebp),%eax
  802536:	8b 55 08             	mov    0x8(%ebp),%edx
  802539:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80253b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80253f:	74 07                	je     802548 <strtol+0x141>
  802541:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802544:	f7 d8                	neg    %eax
  802546:	eb 03                	jmp    80254b <strtol+0x144>
  802548:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <ltostr>:

void
ltostr(long value, char *str)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802553:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80255a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802561:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802565:	79 13                	jns    80257a <ltostr+0x2d>
	{
		neg = 1;
  802567:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80256e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802571:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802574:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802577:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802582:	99                   	cltd   
  802583:	f7 f9                	idiv   %ecx
  802585:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802588:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80258b:	8d 50 01             	lea    0x1(%eax),%edx
  80258e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802591:	89 c2                	mov    %eax,%edx
  802593:	8b 45 0c             	mov    0xc(%ebp),%eax
  802596:	01 d0                	add    %edx,%eax
  802598:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259b:	83 c2 30             	add    $0x30,%edx
  80259e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8025a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8025a8:	f7 e9                	imul   %ecx
  8025aa:	c1 fa 02             	sar    $0x2,%edx
  8025ad:	89 c8                	mov    %ecx,%eax
  8025af:	c1 f8 1f             	sar    $0x1f,%eax
  8025b2:	29 c2                	sub    %eax,%edx
  8025b4:	89 d0                	mov    %edx,%eax
  8025b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8025b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8025c1:	f7 e9                	imul   %ecx
  8025c3:	c1 fa 02             	sar    $0x2,%edx
  8025c6:	89 c8                	mov    %ecx,%eax
  8025c8:	c1 f8 1f             	sar    $0x1f,%eax
  8025cb:	29 c2                	sub    %eax,%edx
  8025cd:	89 d0                	mov    %edx,%eax
  8025cf:	c1 e0 02             	shl    $0x2,%eax
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	01 c0                	add    %eax,%eax
  8025d6:	29 c1                	sub    %eax,%ecx
  8025d8:	89 ca                	mov    %ecx,%edx
  8025da:	85 d2                	test   %edx,%edx
  8025dc:	75 9c                	jne    80257a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8025de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8025e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025e8:	48                   	dec    %eax
  8025e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8025ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025f0:	74 3d                	je     80262f <ltostr+0xe2>
		start = 1 ;
  8025f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8025f9:	eb 34                	jmp    80262f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8025fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802601:	01 d0                	add    %edx,%eax
  802603:	8a 00                	mov    (%eax),%al
  802605:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260e:	01 c2                	add    %eax,%edx
  802610:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802613:	8b 45 0c             	mov    0xc(%ebp),%eax
  802616:	01 c8                	add    %ecx,%eax
  802618:	8a 00                	mov    (%eax),%al
  80261a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80261c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80261f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802622:	01 c2                	add    %eax,%edx
  802624:	8a 45 eb             	mov    -0x15(%ebp),%al
  802627:	88 02                	mov    %al,(%edx)
		start++ ;
  802629:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80262c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802635:	7c c4                	jl     8025fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802637:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80263a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263d:	01 d0                	add    %edx,%eax
  80263f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802642:	90                   	nop
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80264b:	ff 75 08             	pushl  0x8(%ebp)
  80264e:	e8 54 fa ff ff       	call   8020a7 <strlen>
  802653:	83 c4 04             	add    $0x4,%esp
  802656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802659:	ff 75 0c             	pushl  0xc(%ebp)
  80265c:	e8 46 fa ff ff       	call   8020a7 <strlen>
  802661:	83 c4 04             	add    $0x4,%esp
  802664:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802667:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80266e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802675:	eb 17                	jmp    80268e <strcconcat+0x49>
		final[s] = str1[s] ;
  802677:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80267a:	8b 45 10             	mov    0x10(%ebp),%eax
  80267d:	01 c2                	add    %eax,%edx
  80267f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	01 c8                	add    %ecx,%eax
  802687:	8a 00                	mov    (%eax),%al
  802689:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80268b:	ff 45 fc             	incl   -0x4(%ebp)
  80268e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802691:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802694:	7c e1                	jl     802677 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802696:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80269d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8026a4:	eb 1f                	jmp    8026c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8026a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026a9:	8d 50 01             	lea    0x1(%eax),%edx
  8026ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8026af:	89 c2                	mov    %eax,%edx
  8026b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b4:	01 c2                	add    %eax,%edx
  8026b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8026b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bc:	01 c8                	add    %ecx,%eax
  8026be:	8a 00                	mov    (%eax),%al
  8026c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8026c2:	ff 45 f8             	incl   -0x8(%ebp)
  8026c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026cb:	7c d9                	jl     8026a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8026cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d3:	01 d0                	add    %edx,%eax
  8026d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8026d8:	90                   	nop
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8026de:	8b 45 14             	mov    0x14(%ebp),%eax
  8026e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8026e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f6:	01 d0                	add    %edx,%eax
  8026f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8026fe:	eb 0c                	jmp    80270c <strsplit+0x31>
			*string++ = 0;
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	8d 50 01             	lea    0x1(%eax),%edx
  802706:	89 55 08             	mov    %edx,0x8(%ebp)
  802709:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	8a 00                	mov    (%eax),%al
  802711:	84 c0                	test   %al,%al
  802713:	74 18                	je     80272d <strsplit+0x52>
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	8a 00                	mov    (%eax),%al
  80271a:	0f be c0             	movsbl %al,%eax
  80271d:	50                   	push   %eax
  80271e:	ff 75 0c             	pushl  0xc(%ebp)
  802721:	e8 13 fb ff ff       	call   802239 <strchr>
  802726:	83 c4 08             	add    $0x8,%esp
  802729:	85 c0                	test   %eax,%eax
  80272b:	75 d3                	jne    802700 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	8a 00                	mov    (%eax),%al
  802732:	84 c0                	test   %al,%al
  802734:	74 5a                	je     802790 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802736:	8b 45 14             	mov    0x14(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	83 f8 0f             	cmp    $0xf,%eax
  80273e:	75 07                	jne    802747 <strsplit+0x6c>
		{
			return 0;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
  802745:	eb 66                	jmp    8027ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802747:	8b 45 14             	mov    0x14(%ebp),%eax
  80274a:	8b 00                	mov    (%eax),%eax
  80274c:	8d 48 01             	lea    0x1(%eax),%ecx
  80274f:	8b 55 14             	mov    0x14(%ebp),%edx
  802752:	89 0a                	mov    %ecx,(%edx)
  802754:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80275b:	8b 45 10             	mov    0x10(%ebp),%eax
  80275e:	01 c2                	add    %eax,%edx
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802765:	eb 03                	jmp    80276a <strsplit+0x8f>
			string++;
  802767:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	8a 00                	mov    (%eax),%al
  80276f:	84 c0                	test   %al,%al
  802771:	74 8b                	je     8026fe <strsplit+0x23>
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	8a 00                	mov    (%eax),%al
  802778:	0f be c0             	movsbl %al,%eax
  80277b:	50                   	push   %eax
  80277c:	ff 75 0c             	pushl  0xc(%ebp)
  80277f:	e8 b5 fa ff ff       	call   802239 <strchr>
  802784:	83 c4 08             	add    $0x8,%esp
  802787:	85 c0                	test   %eax,%eax
  802789:	74 dc                	je     802767 <strsplit+0x8c>
			string++;
	}
  80278b:	e9 6e ff ff ff       	jmp    8026fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802790:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802791:	8b 45 14             	mov    0x14(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80279d:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a0:	01 d0                	add    %edx,%eax
  8027a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8027a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8027b5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8027bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8027c2:	01 d0                	add    %edx,%eax
  8027c4:	48                   	dec    %eax
  8027c5:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8027c8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d0:	f7 75 ac             	divl   -0x54(%ebp)
  8027d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027d6:	29 d0                	sub    %edx,%eax
  8027d8:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8027db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8027e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8027e9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8027f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8027f7:	eb 3f                	jmp    802838 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8027f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fc:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	50                   	push   %eax
  802807:	ff 75 e8             	pushl  -0x18(%ebp)
  80280a:	68 d0 3e 80 00       	push   $0x803ed0
  80280f:	e8 11 f2 ff ff       	call   801a25 <cprintf>
  802814:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  802817:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281a:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  802821:	83 ec 04             	sub    $0x4,%esp
  802824:	50                   	push   %eax
  802825:	ff 75 e8             	pushl  -0x18(%ebp)
  802828:	68 e5 3e 80 00       	push   $0x803ee5
  80282d:	e8 f3 f1 ff ff       	call   801a25 <cprintf>
  802832:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  802835:	ff 45 e8             	incl   -0x18(%ebp)
  802838:	a1 28 40 80 00       	mov    0x804028,%eax
  80283d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  802840:	7c b7                	jl     8027f9 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  802842:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  802849:	e9 35 01 00 00       	jmp    802983 <malloc+0x1d4>
		int flag0=1;
  80284e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  802855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802858:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80285b:	eb 5e                	jmp    8028bb <malloc+0x10c>
			for(int k=0;k<count;k++){
  80285d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802864:	eb 35                	jmp    80289b <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  802866:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802869:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  802870:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802873:	39 c2                	cmp    %eax,%edx
  802875:	77 21                	ja     802898 <malloc+0xe9>
  802877:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80287a:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802881:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802884:	39 c2                	cmp    %eax,%edx
  802886:	76 10                	jbe    802898 <malloc+0xe9>
					ni=PAGE_SIZE;
  802888:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  80288f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  802896:	eb 0d                	jmp    8028a5 <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  802898:	ff 45 d8             	incl   -0x28(%ebp)
  80289b:	a1 28 40 80 00       	mov    0x804028,%eax
  8028a0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8028a3:	7c c1                	jl     802866 <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8028a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a9:	74 09                	je     8028b4 <malloc+0x105>
				flag0=0;
  8028ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8028b2:	eb 16                	jmp    8028ca <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8028b4:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8028bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	01 c2                	add    %eax,%edx
  8028c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c6:	39 c2                	cmp    %eax,%edx
  8028c8:	77 93                	ja     80285d <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8028ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028ce:	0f 84 a2 00 00 00    	je     802976 <malloc+0x1c7>

			int f=1;
  8028d4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8028db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028de:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028e1:	89 c8                	mov    %ecx,%eax
  8028e3:	01 c0                	add    %eax,%eax
  8028e5:	01 c8                	add    %ecx,%eax
  8028e7:	c1 e0 02             	shl    $0x2,%eax
  8028ea:	05 20 41 80 00       	add    $0x804120,%eax
  8028ef:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8028f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fd:	89 d0                	mov    %edx,%eax
  8028ff:	01 c0                	add    %eax,%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	c1 e0 02             	shl    $0x2,%eax
  802906:	05 24 41 80 00       	add    $0x804124,%eax
  80290b:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80290d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802910:	89 d0                	mov    %edx,%eax
  802912:	01 c0                	add    %eax,%eax
  802914:	01 d0                	add    %edx,%eax
  802916:	c1 e0 02             	shl    $0x2,%eax
  802919:	05 28 41 80 00       	add    $0x804128,%eax
  80291e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  802924:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  802927:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80292e:	eb 36                	jmp    802966 <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  802930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	01 c2                	add    %eax,%edx
  802938:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80293b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802942:	39 c2                	cmp    %eax,%edx
  802944:	73 1d                	jae    802963 <malloc+0x1b4>
					ni=arr_add[l].end-i;
  802946:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802949:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802953:	29 c2                	sub    %eax,%edx
  802955:	89 d0                	mov    %edx,%eax
  802957:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  80295a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  802961:	eb 0d                	jmp    802970 <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  802963:	ff 45 d0             	incl   -0x30(%ebp)
  802966:	a1 28 40 80 00       	mov    0x804028,%eax
  80296b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80296e:	7c c0                	jl     802930 <malloc+0x181>
					break;

				}
			}

			if(f){
  802970:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802974:	75 1d                	jne    802993 <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  802976:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80297d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802980:	01 45 e4             	add    %eax,-0x1c(%ebp)
  802983:	a1 04 40 80 00       	mov    0x804004,%eax
  802988:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80298b:	0f 8c bd fe ff ff    	jl     80284e <malloc+0x9f>
  802991:	eb 01                	jmp    802994 <malloc+0x1e5>

				}
			}

			if(f){
				break;
  802993:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  802994:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802998:	75 7a                	jne    802a14 <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  80299a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	01 d0                	add    %edx,%eax
  8029a5:	48                   	dec    %eax
  8029a6:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8029ab:	7c 0a                	jl     8029b7 <malloc+0x208>
			return NULL;
  8029ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b2:	e9 a4 02 00 00       	jmp    802c5b <malloc+0x4ac>
		else{
			uint32 s=base_add;
  8029b7:	a1 04 40 80 00       	mov    0x804004,%eax
  8029bc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8029bf:	a1 28 40 80 00       	mov    0x804028,%eax
  8029c4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8029c7:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  8029ce:	83 ec 08             	sub    $0x8,%esp
  8029d1:	ff 75 08             	pushl  0x8(%ebp)
  8029d4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029d7:	e8 04 06 00 00       	call   802fe0 <sys_allocateMem>
  8029dc:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8029df:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	01 d0                	add    %edx,%eax
  8029ea:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  8029ef:	a1 28 40 80 00       	mov    0x804028,%eax
  8029f4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8029fa:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  802a01:	a1 28 40 80 00       	mov    0x804028,%eax
  802a06:	40                   	inc    %eax
  802a07:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  802a0c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a0f:	e9 47 02 00 00       	jmp    802c5b <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  802a14:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802a1b:	e9 ac 00 00 00       	jmp    802acc <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  802a20:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	01 c0                	add    %eax,%eax
  802a27:	01 d0                	add    %edx,%eax
  802a29:	c1 e0 02             	shl    $0x2,%eax
  802a2c:	05 24 41 80 00       	add    $0x804124,%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802a36:	eb 7e                	jmp    802ab6 <malloc+0x307>
			int flag=0;
  802a38:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  802a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  802a46:	eb 57                	jmp    802a9f <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  802a48:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a4b:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  802a52:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a55:	39 c2                	cmp    %eax,%edx
  802a57:	77 1a                	ja     802a73 <malloc+0x2c4>
  802a59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a5c:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a66:	39 c2                	cmp    %eax,%edx
  802a68:	76 09                	jbe    802a73 <malloc+0x2c4>
								flag=1;
  802a6a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  802a71:	eb 36                	jmp    802aa9 <malloc+0x2fa>
			arr[i].space++;
  802a73:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a76:	89 d0                	mov    %edx,%eax
  802a78:	01 c0                	add    %eax,%eax
  802a7a:	01 d0                	add    %edx,%eax
  802a7c:	c1 e0 02             	shl    $0x2,%eax
  802a7f:	05 28 41 80 00       	add    $0x804128,%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	8d 48 01             	lea    0x1(%eax),%ecx
  802a89:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a8c:	89 d0                	mov    %edx,%eax
  802a8e:	01 c0                	add    %eax,%eax
  802a90:	01 d0                	add    %edx,%eax
  802a92:	c1 e0 02             	shl    $0x2,%eax
  802a95:	05 28 41 80 00       	add    $0x804128,%eax
  802a9a:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  802a9c:	ff 45 c0             	incl   -0x40(%ebp)
  802a9f:	a1 28 40 80 00       	mov    0x804028,%eax
  802aa4:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  802aa7:	7c 9f                	jl     802a48 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  802aa9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802aad:	75 19                	jne    802ac8 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  802aaf:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  802ab6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ab9:	a1 04 40 80 00       	mov    0x804004,%eax
  802abe:	39 c2                	cmp    %eax,%edx
  802ac0:	0f 82 72 ff ff ff    	jb     802a38 <malloc+0x289>
  802ac6:	eb 01                	jmp    802ac9 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  802ac8:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  802ac9:	ff 45 cc             	incl   -0x34(%ebp)
  802acc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ad2:	0f 8c 48 ff ff ff    	jl     802a20 <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  802ad8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  802adf:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  802ae6:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  802aed:	eb 37                	jmp    802b26 <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  802aef:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  802af2:	89 d0                	mov    %edx,%eax
  802af4:	01 c0                	add    %eax,%eax
  802af6:	01 d0                	add    %edx,%eax
  802af8:	c1 e0 02             	shl    $0x2,%eax
  802afb:	05 28 41 80 00       	add    $0x804128,%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b05:	7d 1c                	jge    802b23 <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  802b07:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  802b0a:	89 d0                	mov    %edx,%eax
  802b0c:	01 c0                	add    %eax,%eax
  802b0e:	01 d0                	add    %edx,%eax
  802b10:	c1 e0 02             	shl    $0x2,%eax
  802b13:	05 28 41 80 00       	add    $0x804128,%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  802b1d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b20:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  802b23:	ff 45 b4             	incl   -0x4c(%ebp)
  802b26:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b2c:	7c c1                	jl     802aef <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  802b2e:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802b34:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802b37:	89 c8                	mov    %ecx,%eax
  802b39:	01 c0                	add    %eax,%eax
  802b3b:	01 c8                	add    %ecx,%eax
  802b3d:	c1 e0 02             	shl    $0x2,%eax
  802b40:	05 20 41 80 00       	add    $0x804120,%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  802b4e:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802b54:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802b57:	89 c8                	mov    %ecx,%eax
  802b59:	01 c0                	add    %eax,%eax
  802b5b:	01 c8                	add    %ecx,%eax
  802b5d:	c1 e0 02             	shl    $0x2,%eax
  802b60:	05 24 41 80 00       	add    $0x804124,%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  802b6e:	a1 28 40 80 00       	mov    0x804028,%eax
  802b73:	40                   	inc    %eax
  802b74:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  802b79:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802b7c:	89 d0                	mov    %edx,%eax
  802b7e:	01 c0                	add    %eax,%eax
  802b80:	01 d0                	add    %edx,%eax
  802b82:	c1 e0 02             	shl    $0x2,%eax
  802b85:	05 20 41 80 00       	add    $0x804120,%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	83 ec 08             	sub    $0x8,%esp
  802b8f:	ff 75 08             	pushl  0x8(%ebp)
  802b92:	50                   	push   %eax
  802b93:	e8 48 04 00 00       	call   802fe0 <sys_allocateMem>
  802b98:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  802b9b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  802ba2:	eb 78                	jmp    802c1c <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  802ba4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ba7:	89 d0                	mov    %edx,%eax
  802ba9:	01 c0                	add    %eax,%eax
  802bab:	01 d0                	add    %edx,%eax
  802bad:	c1 e0 02             	shl    $0x2,%eax
  802bb0:	05 20 41 80 00       	add    $0x804120,%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	50                   	push   %eax
  802bbb:	ff 75 b0             	pushl  -0x50(%ebp)
  802bbe:	68 d0 3e 80 00       	push   $0x803ed0
  802bc3:	e8 5d ee ff ff       	call   801a25 <cprintf>
  802bc8:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  802bcb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bce:	89 d0                	mov    %edx,%eax
  802bd0:	01 c0                	add    %eax,%eax
  802bd2:	01 d0                	add    %edx,%eax
  802bd4:	c1 e0 02             	shl    $0x2,%eax
  802bd7:	05 24 41 80 00       	add    $0x804124,%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	50                   	push   %eax
  802be2:	ff 75 b0             	pushl  -0x50(%ebp)
  802be5:	68 e5 3e 80 00       	push   $0x803ee5
  802bea:	e8 36 ee ff ff       	call   801a25 <cprintf>
  802bef:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  802bf2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bf5:	89 d0                	mov    %edx,%eax
  802bf7:	01 c0                	add    %eax,%eax
  802bf9:	01 d0                	add    %edx,%eax
  802bfb:	c1 e0 02             	shl    $0x2,%eax
  802bfe:	05 28 41 80 00       	add    $0x804128,%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	83 ec 04             	sub    $0x4,%esp
  802c08:	50                   	push   %eax
  802c09:	ff 75 b0             	pushl  -0x50(%ebp)
  802c0c:	68 f8 3e 80 00       	push   $0x803ef8
  802c11:	e8 0f ee ff ff       	call   801a25 <cprintf>
  802c16:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  802c19:	ff 45 b0             	incl   -0x50(%ebp)
  802c1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c22:	7c 80                	jl     802ba4 <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  802c24:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802c27:	89 d0                	mov    %edx,%eax
  802c29:	01 c0                	add    %eax,%eax
  802c2b:	01 d0                	add    %edx,%eax
  802c2d:	c1 e0 02             	shl    $0x2,%eax
  802c30:	05 20 41 80 00       	add    $0x804120,%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	83 ec 08             	sub    $0x8,%esp
  802c3a:	50                   	push   %eax
  802c3b:	68 0c 3f 80 00       	push   $0x803f0c
  802c40:	e8 e0 ed ff ff       	call   801a25 <cprintf>
  802c45:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  802c48:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802c4b:	89 d0                	mov    %edx,%eax
  802c4d:	01 c0                	add    %eax,%eax
  802c4f:	01 d0                	add    %edx,%eax
  802c51:	c1 e0 02             	shl    $0x2,%eax
  802c54:	05 20 41 80 00       	add    $0x804120,%eax
  802c59:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  802c5b:	c9                   	leave  
  802c5c:	c3                   	ret    

00802c5d <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  802c5d:	55                   	push   %ebp
  802c5e:	89 e5                	mov    %esp,%ebp
  802c60:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  802c69:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c70:	eb 4b                	jmp    802cbd <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802c7c:	89 c2                	mov    %eax,%edx
  802c7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c81:	39 c2                	cmp    %eax,%edx
  802c83:	7f 35                	jg     802cba <free+0x5d>
  802c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c88:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  802c8f:	89 c2                	mov    %eax,%edx
  802c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c94:	39 c2                	cmp    %eax,%edx
  802c96:	7e 22                	jle    802cba <free+0x5d>
				start=arr_add[i].start;
  802c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  802ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca8:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  802caf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  802cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  802cb8:	eb 0d                	jmp    802cc7 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  802cba:	ff 45 ec             	incl   -0x14(%ebp)
  802cbd:	a1 28 40 80 00       	mov    0x804028,%eax
  802cc2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802cc5:	7c ab                	jl     802c72 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd4:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802cdb:	29 c2                	sub    %eax,%edx
  802cdd:	89 d0                	mov    %edx,%eax
  802cdf:	83 ec 08             	sub    $0x8,%esp
  802ce2:	50                   	push   %eax
  802ce3:	ff 75 f4             	pushl  -0xc(%ebp)
  802ce6:	e8 d9 02 00 00       	call   802fc4 <sys_freeMem>
  802ceb:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802cf4:	eb 2d                	jmp    802d23 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  802cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf9:	40                   	inc    %eax
  802cfa:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  802d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0e:	40                   	inc    %eax
  802d0f:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d19:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  802d20:	ff 45 e8             	incl   -0x18(%ebp)
  802d23:	a1 28 40 80 00       	mov    0x804028,%eax
  802d28:	48                   	dec    %eax
  802d29:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d2c:	7f c8                	jg     802cf6 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  802d2e:	a1 28 40 80 00       	mov    0x804028,%eax
  802d33:	48                   	dec    %eax
  802d34:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  802d39:	90                   	nop
  802d3a:	c9                   	leave  
  802d3b:	c3                   	ret    

00802d3c <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802d3c:	55                   	push   %ebp
  802d3d:	89 e5                	mov    %esp,%ebp
  802d3f:	83 ec 18             	sub    $0x18,%esp
  802d42:	8b 45 10             	mov    0x10(%ebp),%eax
  802d45:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802d48:	83 ec 04             	sub    $0x4,%esp
  802d4b:	68 28 3f 80 00       	push   $0x803f28
  802d50:	68 18 01 00 00       	push   $0x118
  802d55:	68 4b 3f 80 00       	push   $0x803f4b
  802d5a:	e8 24 ea ff ff       	call   801783 <_panic>

00802d5f <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d5f:	55                   	push   %ebp
  802d60:	89 e5                	mov    %esp,%ebp
  802d62:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	68 28 3f 80 00       	push   $0x803f28
  802d6d:	68 1e 01 00 00       	push   $0x11e
  802d72:	68 4b 3f 80 00       	push   $0x803f4b
  802d77:	e8 07 ea ff ff       	call   801783 <_panic>

00802d7c <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
  802d7f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802d82:	83 ec 04             	sub    $0x4,%esp
  802d85:	68 28 3f 80 00       	push   $0x803f28
  802d8a:	68 24 01 00 00       	push   $0x124
  802d8f:	68 4b 3f 80 00       	push   $0x803f4b
  802d94:	e8 ea e9 ff ff       	call   801783 <_panic>

00802d99 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
  802d9c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802d9f:	83 ec 04             	sub    $0x4,%esp
  802da2:	68 28 3f 80 00       	push   $0x803f28
  802da7:	68 29 01 00 00       	push   $0x129
  802dac:	68 4b 3f 80 00       	push   $0x803f4b
  802db1:	e8 cd e9 ff ff       	call   801783 <_panic>

00802db6 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
  802db9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 28 3f 80 00       	push   $0x803f28
  802dc4:	68 2f 01 00 00       	push   $0x12f
  802dc9:	68 4b 3f 80 00       	push   $0x803f4b
  802dce:	e8 b0 e9 ff ff       	call   801783 <_panic>

00802dd3 <shrink>:
}
void shrink(uint32 newSize)
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
  802dd6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 28 3f 80 00       	push   $0x803f28
  802de1:	68 33 01 00 00       	push   $0x133
  802de6:	68 4b 3f 80 00       	push   $0x803f4b
  802deb:	e8 93 e9 ff ff       	call   801783 <_panic>

00802df0 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 28 3f 80 00       	push   $0x803f28
  802dfe:	68 38 01 00 00       	push   $0x138
  802e03:	68 4b 3f 80 00       	push   $0x803f4b
  802e08:	e8 76 e9 ff ff       	call   801783 <_panic>

00802e0d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
  802e10:	57                   	push   %edi
  802e11:	56                   	push   %esi
  802e12:	53                   	push   %ebx
  802e13:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e22:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e25:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e28:	cd 30                	int    $0x30
  802e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e30:	83 c4 10             	add    $0x10,%esp
  802e33:	5b                   	pop    %ebx
  802e34:	5e                   	pop    %esi
  802e35:	5f                   	pop    %edi
  802e36:	5d                   	pop    %ebp
  802e37:	c3                   	ret    

00802e38 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802e38:	55                   	push   %ebp
  802e39:	89 e5                	mov    %esp,%ebp
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	8b 45 10             	mov    0x10(%ebp),%eax
  802e41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802e44:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 00                	push   $0x0
  802e4f:	52                   	push   %edx
  802e50:	ff 75 0c             	pushl  0xc(%ebp)
  802e53:	50                   	push   %eax
  802e54:	6a 00                	push   $0x0
  802e56:	e8 b2 ff ff ff       	call   802e0d <syscall>
  802e5b:	83 c4 18             	add    $0x18,%esp
}
  802e5e:	90                   	nop
  802e5f:	c9                   	leave  
  802e60:	c3                   	ret    

00802e61 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e61:	55                   	push   %ebp
  802e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	6a 00                	push   $0x0
  802e6a:	6a 00                	push   $0x0
  802e6c:	6a 00                	push   $0x0
  802e6e:	6a 01                	push   $0x1
  802e70:	e8 98 ff ff ff       	call   802e0d <syscall>
  802e75:	83 c4 18             	add    $0x18,%esp
}
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	6a 00                	push   $0x0
  802e88:	50                   	push   %eax
  802e89:	6a 05                	push   $0x5
  802e8b:	e8 7d ff ff ff       	call   802e0d <syscall>
  802e90:	83 c4 18             	add    $0x18,%esp
}
  802e93:	c9                   	leave  
  802e94:	c3                   	ret    

00802e95 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802e95:	55                   	push   %ebp
  802e96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 02                	push   $0x2
  802ea4:	e8 64 ff ff ff       	call   802e0d <syscall>
  802ea9:	83 c4 18             	add    $0x18,%esp
}
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802eb1:	6a 00                	push   $0x0
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 03                	push   $0x3
  802ebd:	e8 4b ff ff ff       	call   802e0d <syscall>
  802ec2:	83 c4 18             	add    $0x18,%esp
}
  802ec5:	c9                   	leave  
  802ec6:	c3                   	ret    

00802ec7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ec7:	55                   	push   %ebp
  802ec8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 04                	push   $0x4
  802ed6:	e8 32 ff ff ff       	call   802e0d <syscall>
  802edb:	83 c4 18             	add    $0x18,%esp
}
  802ede:	c9                   	leave  
  802edf:	c3                   	ret    

00802ee0 <sys_env_exit>:


void sys_env_exit(void)
{
  802ee0:	55                   	push   %ebp
  802ee1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 06                	push   $0x6
  802eef:	e8 19 ff ff ff       	call   802e0d <syscall>
  802ef4:	83 c4 18             	add    $0x18,%esp
}
  802ef7:	90                   	nop
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	52                   	push   %edx
  802f0a:	50                   	push   %eax
  802f0b:	6a 07                	push   $0x7
  802f0d:	e8 fb fe ff ff       	call   802e0d <syscall>
  802f12:	83 c4 18             	add    $0x18,%esp
}
  802f15:	c9                   	leave  
  802f16:	c3                   	ret    

00802f17 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f17:	55                   	push   %ebp
  802f18:	89 e5                	mov    %esp,%ebp
  802f1a:	56                   	push   %esi
  802f1b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f1c:	8b 75 18             	mov    0x18(%ebp),%esi
  802f1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	56                   	push   %esi
  802f2c:	53                   	push   %ebx
  802f2d:	51                   	push   %ecx
  802f2e:	52                   	push   %edx
  802f2f:	50                   	push   %eax
  802f30:	6a 08                	push   $0x8
  802f32:	e8 d6 fe ff ff       	call   802e0d <syscall>
  802f37:	83 c4 18             	add    $0x18,%esp
}
  802f3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f3d:	5b                   	pop    %ebx
  802f3e:	5e                   	pop    %esi
  802f3f:	5d                   	pop    %ebp
  802f40:	c3                   	ret    

00802f41 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f41:	55                   	push   %ebp
  802f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	52                   	push   %edx
  802f51:	50                   	push   %eax
  802f52:	6a 09                	push   $0x9
  802f54:	e8 b4 fe ff ff       	call   802e0d <syscall>
  802f59:	83 c4 18             	add    $0x18,%esp
}
  802f5c:	c9                   	leave  
  802f5d:	c3                   	ret    

00802f5e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f5e:	55                   	push   %ebp
  802f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f61:	6a 00                	push   $0x0
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	ff 75 0c             	pushl  0xc(%ebp)
  802f6a:	ff 75 08             	pushl  0x8(%ebp)
  802f6d:	6a 0a                	push   $0xa
  802f6f:	e8 99 fe ff ff       	call   802e0d <syscall>
  802f74:	83 c4 18             	add    $0x18,%esp
}
  802f77:	c9                   	leave  
  802f78:	c3                   	ret    

00802f79 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f79:	55                   	push   %ebp
  802f7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 00                	push   $0x0
  802f84:	6a 00                	push   $0x0
  802f86:	6a 0b                	push   $0xb
  802f88:	e8 80 fe ff ff       	call   802e0d <syscall>
  802f8d:	83 c4 18             	add    $0x18,%esp
}
  802f90:	c9                   	leave  
  802f91:	c3                   	ret    

00802f92 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f92:	55                   	push   %ebp
  802f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 0c                	push   $0xc
  802fa1:	e8 67 fe ff ff       	call   802e0d <syscall>
  802fa6:	83 c4 18             	add    $0x18,%esp
}
  802fa9:	c9                   	leave  
  802faa:	c3                   	ret    

00802fab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fab:	55                   	push   %ebp
  802fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 00                	push   $0x0
  802fb2:	6a 00                	push   $0x0
  802fb4:	6a 00                	push   $0x0
  802fb6:	6a 00                	push   $0x0
  802fb8:	6a 0d                	push   $0xd
  802fba:	e8 4e fe ff ff       	call   802e0d <syscall>
  802fbf:	83 c4 18             	add    $0x18,%esp
}
  802fc2:	c9                   	leave  
  802fc3:	c3                   	ret    

00802fc4 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802fc4:	55                   	push   %ebp
  802fc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	ff 75 0c             	pushl  0xc(%ebp)
  802fd0:	ff 75 08             	pushl  0x8(%ebp)
  802fd3:	6a 11                	push   $0x11
  802fd5:	e8 33 fe ff ff       	call   802e0d <syscall>
  802fda:	83 c4 18             	add    $0x18,%esp
	return;
  802fdd:	90                   	nop
}
  802fde:	c9                   	leave  
  802fdf:	c3                   	ret    

00802fe0 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802fe0:	55                   	push   %ebp
  802fe1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 00                	push   $0x0
  802fe9:	ff 75 0c             	pushl  0xc(%ebp)
  802fec:	ff 75 08             	pushl  0x8(%ebp)
  802fef:	6a 12                	push   $0x12
  802ff1:	e8 17 fe ff ff       	call   802e0d <syscall>
  802ff6:	83 c4 18             	add    $0x18,%esp
	return ;
  802ff9:	90                   	nop
}
  802ffa:	c9                   	leave  
  802ffb:	c3                   	ret    

00802ffc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ffc:	55                   	push   %ebp
  802ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802fff:	6a 00                	push   $0x0
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 0e                	push   $0xe
  80300b:	e8 fd fd ff ff       	call   802e0d <syscall>
  803010:	83 c4 18             	add    $0x18,%esp
}
  803013:	c9                   	leave  
  803014:	c3                   	ret    

00803015 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803015:	55                   	push   %ebp
  803016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803018:	6a 00                	push   $0x0
  80301a:	6a 00                	push   $0x0
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	ff 75 08             	pushl  0x8(%ebp)
  803023:	6a 0f                	push   $0xf
  803025:	e8 e3 fd ff ff       	call   802e0d <syscall>
  80302a:	83 c4 18             	add    $0x18,%esp
}
  80302d:	c9                   	leave  
  80302e:	c3                   	ret    

0080302f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80302f:	55                   	push   %ebp
  803030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 10                	push   $0x10
  80303e:	e8 ca fd ff ff       	call   802e0d <syscall>
  803043:	83 c4 18             	add    $0x18,%esp
}
  803046:	90                   	nop
  803047:	c9                   	leave  
  803048:	c3                   	ret    

00803049 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  803049:	55                   	push   %ebp
  80304a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 14                	push   $0x14
  803058:	e8 b0 fd ff ff       	call   802e0d <syscall>
  80305d:	83 c4 18             	add    $0x18,%esp
}
  803060:	90                   	nop
  803061:	c9                   	leave  
  803062:	c3                   	ret    

00803063 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  803063:	55                   	push   %ebp
  803064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	6a 00                	push   $0x0
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	6a 15                	push   $0x15
  803072:	e8 96 fd ff ff       	call   802e0d <syscall>
  803077:	83 c4 18             	add    $0x18,%esp
}
  80307a:	90                   	nop
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

0080307d <sys_cputc>:


void
sys_cputc(const char c)
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803089:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80308d:	6a 00                	push   $0x0
  80308f:	6a 00                	push   $0x0
  803091:	6a 00                	push   $0x0
  803093:	6a 00                	push   $0x0
  803095:	50                   	push   %eax
  803096:	6a 16                	push   $0x16
  803098:	e8 70 fd ff ff       	call   802e0d <syscall>
  80309d:	83 c4 18             	add    $0x18,%esp
}
  8030a0:	90                   	nop
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	6a 00                	push   $0x0
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 00                	push   $0x0
  8030b0:	6a 17                	push   $0x17
  8030b2:	e8 56 fd ff ff       	call   802e0d <syscall>
  8030b7:	83 c4 18             	add    $0x18,%esp
}
  8030ba:	90                   	nop
  8030bb:	c9                   	leave  
  8030bc:	c3                   	ret    

008030bd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8030bd:	55                   	push   %ebp
  8030be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	ff 75 0c             	pushl  0xc(%ebp)
  8030cc:	50                   	push   %eax
  8030cd:	6a 18                	push   $0x18
  8030cf:	e8 39 fd ff ff       	call   802e0d <syscall>
  8030d4:	83 c4 18             	add    $0x18,%esp
}
  8030d7:	c9                   	leave  
  8030d8:	c3                   	ret    

008030d9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8030d9:	55                   	push   %ebp
  8030da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8030dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	52                   	push   %edx
  8030e9:	50                   	push   %eax
  8030ea:	6a 1b                	push   $0x1b
  8030ec:	e8 1c fd ff ff       	call   802e0d <syscall>
  8030f1:	83 c4 18             	add    $0x18,%esp
}
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8030f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	6a 00                	push   $0x0
  803101:	6a 00                	push   $0x0
  803103:	6a 00                	push   $0x0
  803105:	52                   	push   %edx
  803106:	50                   	push   %eax
  803107:	6a 19                	push   $0x19
  803109:	e8 ff fc ff ff       	call   802e0d <syscall>
  80310e:	83 c4 18             	add    $0x18,%esp
}
  803111:	90                   	nop
  803112:	c9                   	leave  
  803113:	c3                   	ret    

00803114 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  803114:	55                   	push   %ebp
  803115:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803117:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	52                   	push   %edx
  803124:	50                   	push   %eax
  803125:	6a 1a                	push   $0x1a
  803127:	e8 e1 fc ff ff       	call   802e0d <syscall>
  80312c:	83 c4 18             	add    $0x18,%esp
}
  80312f:	90                   	nop
  803130:	c9                   	leave  
  803131:	c3                   	ret    

00803132 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803132:	55                   	push   %ebp
  803133:	89 e5                	mov    %esp,%ebp
  803135:	83 ec 04             	sub    $0x4,%esp
  803138:	8b 45 10             	mov    0x10(%ebp),%eax
  80313b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80313e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803141:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	6a 00                	push   $0x0
  80314a:	51                   	push   %ecx
  80314b:	52                   	push   %edx
  80314c:	ff 75 0c             	pushl  0xc(%ebp)
  80314f:	50                   	push   %eax
  803150:	6a 1c                	push   $0x1c
  803152:	e8 b6 fc ff ff       	call   802e0d <syscall>
  803157:	83 c4 18             	add    $0x18,%esp
}
  80315a:	c9                   	leave  
  80315b:	c3                   	ret    

0080315c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80315c:	55                   	push   %ebp
  80315d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80315f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	52                   	push   %edx
  80316c:	50                   	push   %eax
  80316d:	6a 1d                	push   $0x1d
  80316f:	e8 99 fc ff ff       	call   802e0d <syscall>
  803174:	83 c4 18             	add    $0x18,%esp
}
  803177:	c9                   	leave  
  803178:	c3                   	ret    

00803179 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  803179:	55                   	push   %ebp
  80317a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80317c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80317f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	51                   	push   %ecx
  80318a:	52                   	push   %edx
  80318b:	50                   	push   %eax
  80318c:	6a 1e                	push   $0x1e
  80318e:	e8 7a fc ff ff       	call   802e0d <syscall>
  803193:	83 c4 18             	add    $0x18,%esp
}
  803196:	c9                   	leave  
  803197:	c3                   	ret    

00803198 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  803198:	55                   	push   %ebp
  803199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80319b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	52                   	push   %edx
  8031a8:	50                   	push   %eax
  8031a9:	6a 1f                	push   $0x1f
  8031ab:	e8 5d fc ff ff       	call   802e0d <syscall>
  8031b0:	83 c4 18             	add    $0x18,%esp
}
  8031b3:	c9                   	leave  
  8031b4:	c3                   	ret    

008031b5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8031b5:	55                   	push   %ebp
  8031b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 00                	push   $0x0
  8031c2:	6a 20                	push   $0x20
  8031c4:	e8 44 fc ff ff       	call   802e0d <syscall>
  8031c9:	83 c4 18             	add    $0x18,%esp
}
  8031cc:	c9                   	leave  
  8031cd:	c3                   	ret    

008031ce <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031ce:	55                   	push   %ebp
  8031cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	6a 00                	push   $0x0
  8031d6:	ff 75 14             	pushl  0x14(%ebp)
  8031d9:	ff 75 10             	pushl  0x10(%ebp)
  8031dc:	ff 75 0c             	pushl  0xc(%ebp)
  8031df:	50                   	push   %eax
  8031e0:	6a 21                	push   $0x21
  8031e2:	e8 26 fc ff ff       	call   802e0d <syscall>
  8031e7:	83 c4 18             	add    $0x18,%esp
}
  8031ea:	c9                   	leave  
  8031eb:	c3                   	ret    

008031ec <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8031ec:	55                   	push   %ebp
  8031ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	6a 00                	push   $0x0
  8031f4:	6a 00                	push   $0x0
  8031f6:	6a 00                	push   $0x0
  8031f8:	6a 00                	push   $0x0
  8031fa:	50                   	push   %eax
  8031fb:	6a 22                	push   $0x22
  8031fd:	e8 0b fc ff ff       	call   802e0d <syscall>
  803202:	83 c4 18             	add    $0x18,%esp
}
  803205:	90                   	nop
  803206:	c9                   	leave  
  803207:	c3                   	ret    

00803208 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  803208:	55                   	push   %ebp
  803209:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	6a 00                	push   $0x0
  803210:	6a 00                	push   $0x0
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	50                   	push   %eax
  803217:	6a 23                	push   $0x23
  803219:	e8 ef fb ff ff       	call   802e0d <syscall>
  80321e:	83 c4 18             	add    $0x18,%esp
}
  803221:	90                   	nop
  803222:	c9                   	leave  
  803223:	c3                   	ret    

00803224 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  803224:	55                   	push   %ebp
  803225:	89 e5                	mov    %esp,%ebp
  803227:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80322a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80322d:	8d 50 04             	lea    0x4(%eax),%edx
  803230:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803233:	6a 00                	push   $0x0
  803235:	6a 00                	push   $0x0
  803237:	6a 00                	push   $0x0
  803239:	52                   	push   %edx
  80323a:	50                   	push   %eax
  80323b:	6a 24                	push   $0x24
  80323d:	e8 cb fb ff ff       	call   802e0d <syscall>
  803242:	83 c4 18             	add    $0x18,%esp
	return result;
  803245:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803248:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80324b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80324e:	89 01                	mov    %eax,(%ecx)
  803250:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	c9                   	leave  
  803257:	c2 04 00             	ret    $0x4

0080325a <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80325d:	6a 00                	push   $0x0
  80325f:	6a 00                	push   $0x0
  803261:	ff 75 10             	pushl  0x10(%ebp)
  803264:	ff 75 0c             	pushl  0xc(%ebp)
  803267:	ff 75 08             	pushl  0x8(%ebp)
  80326a:	6a 13                	push   $0x13
  80326c:	e8 9c fb ff ff       	call   802e0d <syscall>
  803271:	83 c4 18             	add    $0x18,%esp
	return ;
  803274:	90                   	nop
}
  803275:	c9                   	leave  
  803276:	c3                   	ret    

00803277 <sys_rcr2>:
uint32 sys_rcr2()
{
  803277:	55                   	push   %ebp
  803278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80327a:	6a 00                	push   $0x0
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 25                	push   $0x25
  803286:	e8 82 fb ff ff       	call   802e0d <syscall>
  80328b:	83 c4 18             	add    $0x18,%esp
}
  80328e:	c9                   	leave  
  80328f:	c3                   	ret    

00803290 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803290:	55                   	push   %ebp
  803291:	89 e5                	mov    %esp,%ebp
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80329c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8032a0:	6a 00                	push   $0x0
  8032a2:	6a 00                	push   $0x0
  8032a4:	6a 00                	push   $0x0
  8032a6:	6a 00                	push   $0x0
  8032a8:	50                   	push   %eax
  8032a9:	6a 26                	push   $0x26
  8032ab:	e8 5d fb ff ff       	call   802e0d <syscall>
  8032b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b3:	90                   	nop
}
  8032b4:	c9                   	leave  
  8032b5:	c3                   	ret    

008032b6 <rsttst>:
void rsttst()
{
  8032b6:	55                   	push   %ebp
  8032b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	6a 00                	push   $0x0
  8032bf:	6a 00                	push   $0x0
  8032c1:	6a 00                	push   $0x0
  8032c3:	6a 28                	push   $0x28
  8032c5:	e8 43 fb ff ff       	call   802e0d <syscall>
  8032ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8032cd:	90                   	nop
}
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8032d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8032dc:	8b 55 18             	mov    0x18(%ebp),%edx
  8032df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8032e3:	52                   	push   %edx
  8032e4:	50                   	push   %eax
  8032e5:	ff 75 10             	pushl  0x10(%ebp)
  8032e8:	ff 75 0c             	pushl  0xc(%ebp)
  8032eb:	ff 75 08             	pushl  0x8(%ebp)
  8032ee:	6a 27                	push   $0x27
  8032f0:	e8 18 fb ff ff       	call   802e0d <syscall>
  8032f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f8:	90                   	nop
}
  8032f9:	c9                   	leave  
  8032fa:	c3                   	ret    

008032fb <chktst>:
void chktst(uint32 n)
{
  8032fb:	55                   	push   %ebp
  8032fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	ff 75 08             	pushl  0x8(%ebp)
  803309:	6a 29                	push   $0x29
  80330b:	e8 fd fa ff ff       	call   802e0d <syscall>
  803310:	83 c4 18             	add    $0x18,%esp
	return ;
  803313:	90                   	nop
}
  803314:	c9                   	leave  
  803315:	c3                   	ret    

00803316 <inctst>:

void inctst()
{
  803316:	55                   	push   %ebp
  803317:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803319:	6a 00                	push   $0x0
  80331b:	6a 00                	push   $0x0
  80331d:	6a 00                	push   $0x0
  80331f:	6a 00                	push   $0x0
  803321:	6a 00                	push   $0x0
  803323:	6a 2a                	push   $0x2a
  803325:	e8 e3 fa ff ff       	call   802e0d <syscall>
  80332a:	83 c4 18             	add    $0x18,%esp
	return ;
  80332d:	90                   	nop
}
  80332e:	c9                   	leave  
  80332f:	c3                   	ret    

00803330 <gettst>:
uint32 gettst()
{
  803330:	55                   	push   %ebp
  803331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803333:	6a 00                	push   $0x0
  803335:	6a 00                	push   $0x0
  803337:	6a 00                	push   $0x0
  803339:	6a 00                	push   $0x0
  80333b:	6a 00                	push   $0x0
  80333d:	6a 2b                	push   $0x2b
  80333f:	e8 c9 fa ff ff       	call   802e0d <syscall>
  803344:	83 c4 18             	add    $0x18,%esp
}
  803347:	c9                   	leave  
  803348:	c3                   	ret    

00803349 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  803349:	55                   	push   %ebp
  80334a:	89 e5                	mov    %esp,%ebp
  80334c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80334f:	6a 00                	push   $0x0
  803351:	6a 00                	push   $0x0
  803353:	6a 00                	push   $0x0
  803355:	6a 00                	push   $0x0
  803357:	6a 00                	push   $0x0
  803359:	6a 2c                	push   $0x2c
  80335b:	e8 ad fa ff ff       	call   802e0d <syscall>
  803360:	83 c4 18             	add    $0x18,%esp
  803363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803366:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80336a:	75 07                	jne    803373 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80336c:	b8 01 00 00 00       	mov    $0x1,%eax
  803371:	eb 05                	jmp    803378 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803378:	c9                   	leave  
  803379:	c3                   	ret    

0080337a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80337a:	55                   	push   %ebp
  80337b:	89 e5                	mov    %esp,%ebp
  80337d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	6a 00                	push   $0x0
  80338a:	6a 2c                	push   $0x2c
  80338c:	e8 7c fa ff ff       	call   802e0d <syscall>
  803391:	83 c4 18             	add    $0x18,%esp
  803394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803397:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80339b:	75 07                	jne    8033a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80339d:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a2:	eb 05                	jmp    8033a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8033a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033a9:	c9                   	leave  
  8033aa:	c3                   	ret    

008033ab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8033ab:	55                   	push   %ebp
  8033ac:	89 e5                	mov    %esp,%ebp
  8033ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033b1:	6a 00                	push   $0x0
  8033b3:	6a 00                	push   $0x0
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 00                	push   $0x0
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 2c                	push   $0x2c
  8033bd:	e8 4b fa ff ff       	call   802e0d <syscall>
  8033c2:	83 c4 18             	add    $0x18,%esp
  8033c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8033c8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8033cc:	75 07                	jne    8033d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8033ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d3:	eb 05                	jmp    8033da <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033da:	c9                   	leave  
  8033db:	c3                   	ret    

008033dc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
  8033df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 00                	push   $0x0
  8033ec:	6a 2c                	push   $0x2c
  8033ee:	e8 1a fa ff ff       	call   802e0d <syscall>
  8033f3:	83 c4 18             	add    $0x18,%esp
  8033f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8033f9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8033fd:	75 07                	jne    803406 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8033ff:	b8 01 00 00 00       	mov    $0x1,%eax
  803404:	eb 05                	jmp    80340b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803406:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80340b:	c9                   	leave  
  80340c:	c3                   	ret    

0080340d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80340d:	55                   	push   %ebp
  80340e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803410:	6a 00                	push   $0x0
  803412:	6a 00                	push   $0x0
  803414:	6a 00                	push   $0x0
  803416:	6a 00                	push   $0x0
  803418:	ff 75 08             	pushl  0x8(%ebp)
  80341b:	6a 2d                	push   $0x2d
  80341d:	e8 eb f9 ff ff       	call   802e0d <syscall>
  803422:	83 c4 18             	add    $0x18,%esp
	return ;
  803425:	90                   	nop
}
  803426:	c9                   	leave  
  803427:	c3                   	ret    

00803428 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803428:	55                   	push   %ebp
  803429:	89 e5                	mov    %esp,%ebp
  80342b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80342c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80342f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803432:	8b 55 0c             	mov    0xc(%ebp),%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	6a 00                	push   $0x0
  80343a:	53                   	push   %ebx
  80343b:	51                   	push   %ecx
  80343c:	52                   	push   %edx
  80343d:	50                   	push   %eax
  80343e:	6a 2e                	push   $0x2e
  803440:	e8 c8 f9 ff ff       	call   802e0d <syscall>
  803445:	83 c4 18             	add    $0x18,%esp
}
  803448:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80344b:	c9                   	leave  
  80344c:	c3                   	ret    

0080344d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80344d:	55                   	push   %ebp
  80344e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803450:	8b 55 0c             	mov    0xc(%ebp),%edx
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	6a 00                	push   $0x0
  803458:	6a 00                	push   $0x0
  80345a:	6a 00                	push   $0x0
  80345c:	52                   	push   %edx
  80345d:	50                   	push   %eax
  80345e:	6a 2f                	push   $0x2f
  803460:	e8 a8 f9 ff ff       	call   802e0d <syscall>
  803465:	83 c4 18             	add    $0x18,%esp
}
  803468:	c9                   	leave  
  803469:	c3                   	ret    
  80346a:	66 90                	xchg   %ax,%ax

0080346c <__udivdi3>:
  80346c:	55                   	push   %ebp
  80346d:	57                   	push   %edi
  80346e:	56                   	push   %esi
  80346f:	53                   	push   %ebx
  803470:	83 ec 1c             	sub    $0x1c,%esp
  803473:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803477:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80347b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80347f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803483:	89 ca                	mov    %ecx,%edx
  803485:	89 f8                	mov    %edi,%eax
  803487:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80348b:	85 f6                	test   %esi,%esi
  80348d:	75 2d                	jne    8034bc <__udivdi3+0x50>
  80348f:	39 cf                	cmp    %ecx,%edi
  803491:	77 65                	ja     8034f8 <__udivdi3+0x8c>
  803493:	89 fd                	mov    %edi,%ebp
  803495:	85 ff                	test   %edi,%edi
  803497:	75 0b                	jne    8034a4 <__udivdi3+0x38>
  803499:	b8 01 00 00 00       	mov    $0x1,%eax
  80349e:	31 d2                	xor    %edx,%edx
  8034a0:	f7 f7                	div    %edi
  8034a2:	89 c5                	mov    %eax,%ebp
  8034a4:	31 d2                	xor    %edx,%edx
  8034a6:	89 c8                	mov    %ecx,%eax
  8034a8:	f7 f5                	div    %ebp
  8034aa:	89 c1                	mov    %eax,%ecx
  8034ac:	89 d8                	mov    %ebx,%eax
  8034ae:	f7 f5                	div    %ebp
  8034b0:	89 cf                	mov    %ecx,%edi
  8034b2:	89 fa                	mov    %edi,%edx
  8034b4:	83 c4 1c             	add    $0x1c,%esp
  8034b7:	5b                   	pop    %ebx
  8034b8:	5e                   	pop    %esi
  8034b9:	5f                   	pop    %edi
  8034ba:	5d                   	pop    %ebp
  8034bb:	c3                   	ret    
  8034bc:	39 ce                	cmp    %ecx,%esi
  8034be:	77 28                	ja     8034e8 <__udivdi3+0x7c>
  8034c0:	0f bd fe             	bsr    %esi,%edi
  8034c3:	83 f7 1f             	xor    $0x1f,%edi
  8034c6:	75 40                	jne    803508 <__udivdi3+0x9c>
  8034c8:	39 ce                	cmp    %ecx,%esi
  8034ca:	72 0a                	jb     8034d6 <__udivdi3+0x6a>
  8034cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034d0:	0f 87 9e 00 00 00    	ja     803574 <__udivdi3+0x108>
  8034d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034db:	89 fa                	mov    %edi,%edx
  8034dd:	83 c4 1c             	add    $0x1c,%esp
  8034e0:	5b                   	pop    %ebx
  8034e1:	5e                   	pop    %esi
  8034e2:	5f                   	pop    %edi
  8034e3:	5d                   	pop    %ebp
  8034e4:	c3                   	ret    
  8034e5:	8d 76 00             	lea    0x0(%esi),%esi
  8034e8:	31 ff                	xor    %edi,%edi
  8034ea:	31 c0                	xor    %eax,%eax
  8034ec:	89 fa                	mov    %edi,%edx
  8034ee:	83 c4 1c             	add    $0x1c,%esp
  8034f1:	5b                   	pop    %ebx
  8034f2:	5e                   	pop    %esi
  8034f3:	5f                   	pop    %edi
  8034f4:	5d                   	pop    %ebp
  8034f5:	c3                   	ret    
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	f7 f7                	div    %edi
  8034fc:	31 ff                	xor    %edi,%edi
  8034fe:	89 fa                	mov    %edi,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	bd 20 00 00 00       	mov    $0x20,%ebp
  80350d:	89 eb                	mov    %ebp,%ebx
  80350f:	29 fb                	sub    %edi,%ebx
  803511:	89 f9                	mov    %edi,%ecx
  803513:	d3 e6                	shl    %cl,%esi
  803515:	89 c5                	mov    %eax,%ebp
  803517:	88 d9                	mov    %bl,%cl
  803519:	d3 ed                	shr    %cl,%ebp
  80351b:	89 e9                	mov    %ebp,%ecx
  80351d:	09 f1                	or     %esi,%ecx
  80351f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803523:	89 f9                	mov    %edi,%ecx
  803525:	d3 e0                	shl    %cl,%eax
  803527:	89 c5                	mov    %eax,%ebp
  803529:	89 d6                	mov    %edx,%esi
  80352b:	88 d9                	mov    %bl,%cl
  80352d:	d3 ee                	shr    %cl,%esi
  80352f:	89 f9                	mov    %edi,%ecx
  803531:	d3 e2                	shl    %cl,%edx
  803533:	8b 44 24 08          	mov    0x8(%esp),%eax
  803537:	88 d9                	mov    %bl,%cl
  803539:	d3 e8                	shr    %cl,%eax
  80353b:	09 c2                	or     %eax,%edx
  80353d:	89 d0                	mov    %edx,%eax
  80353f:	89 f2                	mov    %esi,%edx
  803541:	f7 74 24 0c          	divl   0xc(%esp)
  803545:	89 d6                	mov    %edx,%esi
  803547:	89 c3                	mov    %eax,%ebx
  803549:	f7 e5                	mul    %ebp
  80354b:	39 d6                	cmp    %edx,%esi
  80354d:	72 19                	jb     803568 <__udivdi3+0xfc>
  80354f:	74 0b                	je     80355c <__udivdi3+0xf0>
  803551:	89 d8                	mov    %ebx,%eax
  803553:	31 ff                	xor    %edi,%edi
  803555:	e9 58 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803560:	89 f9                	mov    %edi,%ecx
  803562:	d3 e2                	shl    %cl,%edx
  803564:	39 c2                	cmp    %eax,%edx
  803566:	73 e9                	jae    803551 <__udivdi3+0xe5>
  803568:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80356b:	31 ff                	xor    %edi,%edi
  80356d:	e9 40 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  803572:	66 90                	xchg   %ax,%ax
  803574:	31 c0                	xor    %eax,%eax
  803576:	e9 37 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80357b:	90                   	nop

0080357c <__umoddi3>:
  80357c:	55                   	push   %ebp
  80357d:	57                   	push   %edi
  80357e:	56                   	push   %esi
  80357f:	53                   	push   %ebx
  803580:	83 ec 1c             	sub    $0x1c,%esp
  803583:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803587:	8b 74 24 34          	mov    0x34(%esp),%esi
  80358b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803593:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80359b:	89 f3                	mov    %esi,%ebx
  80359d:	89 fa                	mov    %edi,%edx
  80359f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a3:	89 34 24             	mov    %esi,(%esp)
  8035a6:	85 c0                	test   %eax,%eax
  8035a8:	75 1a                	jne    8035c4 <__umoddi3+0x48>
  8035aa:	39 f7                	cmp    %esi,%edi
  8035ac:	0f 86 a2 00 00 00    	jbe    803654 <__umoddi3+0xd8>
  8035b2:	89 c8                	mov    %ecx,%eax
  8035b4:	89 f2                	mov    %esi,%edx
  8035b6:	f7 f7                	div    %edi
  8035b8:	89 d0                	mov    %edx,%eax
  8035ba:	31 d2                	xor    %edx,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	39 f0                	cmp    %esi,%eax
  8035c6:	0f 87 ac 00 00 00    	ja     803678 <__umoddi3+0xfc>
  8035cc:	0f bd e8             	bsr    %eax,%ebp
  8035cf:	83 f5 1f             	xor    $0x1f,%ebp
  8035d2:	0f 84 ac 00 00 00    	je     803684 <__umoddi3+0x108>
  8035d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8035dd:	29 ef                	sub    %ebp,%edi
  8035df:	89 fe                	mov    %edi,%esi
  8035e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035e5:	89 e9                	mov    %ebp,%ecx
  8035e7:	d3 e0                	shl    %cl,%eax
  8035e9:	89 d7                	mov    %edx,%edi
  8035eb:	89 f1                	mov    %esi,%ecx
  8035ed:	d3 ef                	shr    %cl,%edi
  8035ef:	09 c7                	or     %eax,%edi
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 e2                	shl    %cl,%edx
  8035f5:	89 14 24             	mov    %edx,(%esp)
  8035f8:	89 d8                	mov    %ebx,%eax
  8035fa:	d3 e0                	shl    %cl,%eax
  8035fc:	89 c2                	mov    %eax,%edx
  8035fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803602:	d3 e0                	shl    %cl,%eax
  803604:	89 44 24 04          	mov    %eax,0x4(%esp)
  803608:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360c:	89 f1                	mov    %esi,%ecx
  80360e:	d3 e8                	shr    %cl,%eax
  803610:	09 d0                	or     %edx,%eax
  803612:	d3 eb                	shr    %cl,%ebx
  803614:	89 da                	mov    %ebx,%edx
  803616:	f7 f7                	div    %edi
  803618:	89 d3                	mov    %edx,%ebx
  80361a:	f7 24 24             	mull   (%esp)
  80361d:	89 c6                	mov    %eax,%esi
  80361f:	89 d1                	mov    %edx,%ecx
  803621:	39 d3                	cmp    %edx,%ebx
  803623:	0f 82 87 00 00 00    	jb     8036b0 <__umoddi3+0x134>
  803629:	0f 84 91 00 00 00    	je     8036c0 <__umoddi3+0x144>
  80362f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803633:	29 f2                	sub    %esi,%edx
  803635:	19 cb                	sbb    %ecx,%ebx
  803637:	89 d8                	mov    %ebx,%eax
  803639:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80363d:	d3 e0                	shl    %cl,%eax
  80363f:	89 e9                	mov    %ebp,%ecx
  803641:	d3 ea                	shr    %cl,%edx
  803643:	09 d0                	or     %edx,%eax
  803645:	89 e9                	mov    %ebp,%ecx
  803647:	d3 eb                	shr    %cl,%ebx
  803649:	89 da                	mov    %ebx,%edx
  80364b:	83 c4 1c             	add    $0x1c,%esp
  80364e:	5b                   	pop    %ebx
  80364f:	5e                   	pop    %esi
  803650:	5f                   	pop    %edi
  803651:	5d                   	pop    %ebp
  803652:	c3                   	ret    
  803653:	90                   	nop
  803654:	89 fd                	mov    %edi,%ebp
  803656:	85 ff                	test   %edi,%edi
  803658:	75 0b                	jne    803665 <__umoddi3+0xe9>
  80365a:	b8 01 00 00 00       	mov    $0x1,%eax
  80365f:	31 d2                	xor    %edx,%edx
  803661:	f7 f7                	div    %edi
  803663:	89 c5                	mov    %eax,%ebp
  803665:	89 f0                	mov    %esi,%eax
  803667:	31 d2                	xor    %edx,%edx
  803669:	f7 f5                	div    %ebp
  80366b:	89 c8                	mov    %ecx,%eax
  80366d:	f7 f5                	div    %ebp
  80366f:	89 d0                	mov    %edx,%eax
  803671:	e9 44 ff ff ff       	jmp    8035ba <__umoddi3+0x3e>
  803676:	66 90                	xchg   %ax,%ax
  803678:	89 c8                	mov    %ecx,%eax
  80367a:	89 f2                	mov    %esi,%edx
  80367c:	83 c4 1c             	add    $0x1c,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    
  803684:	3b 04 24             	cmp    (%esp),%eax
  803687:	72 06                	jb     80368f <__umoddi3+0x113>
  803689:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80368d:	77 0f                	ja     80369e <__umoddi3+0x122>
  80368f:	89 f2                	mov    %esi,%edx
  803691:	29 f9                	sub    %edi,%ecx
  803693:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803697:	89 14 24             	mov    %edx,(%esp)
  80369a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036a2:	8b 14 24             	mov    (%esp),%edx
  8036a5:	83 c4 1c             	add    $0x1c,%esp
  8036a8:	5b                   	pop    %ebx
  8036a9:	5e                   	pop    %esi
  8036aa:	5f                   	pop    %edi
  8036ab:	5d                   	pop    %ebp
  8036ac:	c3                   	ret    
  8036ad:	8d 76 00             	lea    0x0(%esi),%esi
  8036b0:	2b 04 24             	sub    (%esp),%eax
  8036b3:	19 fa                	sbb    %edi,%edx
  8036b5:	89 d1                	mov    %edx,%ecx
  8036b7:	89 c6                	mov    %eax,%esi
  8036b9:	e9 71 ff ff ff       	jmp    80362f <__umoddi3+0xb3>
  8036be:	66 90                	xchg   %ax,%ax
  8036c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036c4:	72 ea                	jb     8036b0 <__umoddi3+0x134>
  8036c6:	89 d9                	mov    %ebx,%ecx
  8036c8:	e9 62 ff ff ff       	jmp    80362f <__umoddi3+0xb3>
