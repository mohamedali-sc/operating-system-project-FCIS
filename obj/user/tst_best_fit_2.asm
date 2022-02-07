
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 9f 08 00 00       	call   8008d5 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 5a 26 00 00       	call   8026a4 <sys_set_uheap_strategy>
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
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800095:	68 80 29 80 00       	push   $0x802980
  80009a:	6a 1b                	push   $0x1b
  80009c:	68 9c 29 80 00       	push   $0x80299c
  8000a1:	e8 74 09 00 00       	call   800a1a <_panic>
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
  8000cd:	e8 74 19 00 00       	call   801a46 <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000d8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 b4 29 80 00       	push   $0x8029b4
  8000e7:	6a 25                	push   $0x25
  8000e9:	68 9c 29 80 00       	push   $0x80299c
  8000ee:	e8 27 09 00 00       	call   800a1a <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  8000f3:	e8 18 21 00 00       	call   802210 <sys_calculate_free_frames>
  8000f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000fb:	e8 93 21 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800100:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 32 19 00 00       	call   801a46 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80011a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80011d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 f8 29 80 00       	push   $0x8029f8
  80012c:	6a 2e                	push   $0x2e
  80012e:	68 9c 29 80 00       	push   $0x80299c
  800133:	e8 e2 08 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800138:	e8 56 21 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80013d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800140:	3d 00 02 00 00       	cmp    $0x200,%eax
  800145:	74 14                	je     80015b <_main+0x123>
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 28 2a 80 00       	push   $0x802a28
  80014f:	6a 30                	push   $0x30
  800151:	68 9c 29 80 00       	push   $0x80299c
  800156:	e8 bf 08 00 00       	call   800a1a <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80015b:	e8 b0 20 00 00       	call   802210 <sys_calculate_free_frames>
  800160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800163:	e8 2b 21 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800168:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	01 c0                	add    %eax,%eax
  800170:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	50                   	push   %eax
  800177:	e8 ca 18 00 00       	call   801a46 <malloc>
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
  800198:	68 f8 29 80 00       	push   $0x8029f8
  80019d:	6a 36                	push   $0x36
  80019f:	68 9c 29 80 00       	push   $0x80299c
  8001a4:	e8 71 08 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001a9:	e8 e5 20 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8001ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001b6:	74 14                	je     8001cc <_main+0x194>
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	68 28 2a 80 00       	push   $0x802a28
  8001c0:	6a 38                	push   $0x38
  8001c2:	68 9c 29 80 00       	push   $0x80299c
  8001c7:	e8 4e 08 00 00       	call   800a1a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001cc:	e8 3f 20 00 00       	call   802210 <sys_calculate_free_frames>
  8001d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001d4:	e8 ba 20 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	01 c0                	add    %eax,%eax
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	50                   	push   %eax
  8001e5:	e8 5c 18 00 00       	call   801a46 <malloc>
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001f0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001f3:	89 c2                	mov    %eax,%edx
  8001f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f8:	c1 e0 02             	shl    $0x2,%eax
  8001fb:	05 00 00 00 80       	add    $0x80000000,%eax
  800200:	39 c2                	cmp    %eax,%edx
  800202:	74 14                	je     800218 <_main+0x1e0>
  800204:	83 ec 04             	sub    $0x4,%esp
  800207:	68 f8 29 80 00       	push   $0x8029f8
  80020c:	6a 3e                	push   $0x3e
  80020e:	68 9c 29 80 00       	push   $0x80299c
  800213:	e8 02 08 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  800218:	e8 76 20 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80021d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800220:	83 f8 01             	cmp    $0x1,%eax
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 28 2a 80 00       	push   $0x802a28
  80022d:	6a 40                	push   $0x40
  80022f:	68 9c 29 80 00       	push   $0x80299c
  800234:	e8 e1 07 00 00       	call   800a1a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800239:	e8 d2 1f 00 00       	call   802210 <sys_calculate_free_frames>
  80023e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800241:	e8 4d 20 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800246:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024c:	01 c0                	add    %eax,%eax
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	50                   	push   %eax
  800252:	e8 ef 17 00 00       	call   801a46 <malloc>
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80025d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800265:	c1 e0 02             	shl    $0x2,%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80026d:	c1 e0 02             	shl    $0x2,%eax
  800270:	01 c8                	add    %ecx,%eax
  800272:	05 00 00 00 80       	add    $0x80000000,%eax
  800277:	39 c2                	cmp    %eax,%edx
  800279:	74 14                	je     80028f <_main+0x257>
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	68 f8 29 80 00       	push   $0x8029f8
  800283:	6a 46                	push   $0x46
  800285:	68 9c 29 80 00       	push   $0x80299c
  80028a:	e8 8b 07 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80028f:	e8 ff 1f 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800294:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800297:	83 f8 01             	cmp    $0x1,%eax
  80029a:	74 14                	je     8002b0 <_main+0x278>
  80029c:	83 ec 04             	sub    $0x4,%esp
  80029f:	68 28 2a 80 00       	push   $0x802a28
  8002a4:	6a 48                	push   $0x48
  8002a6:	68 9c 29 80 00       	push   $0x80299c
  8002ab:	e8 6a 07 00 00       	call   800a1a <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002b0:	e8 5b 1f 00 00       	call   802210 <sys_calculate_free_frames>
  8002b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002b8:	e8 d6 1f 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8002bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002c0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	50                   	push   %eax
  8002c7:	e8 28 1c 00 00       	call   801ef4 <free>
  8002cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002cf:	e8 bf 1f 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8002d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002d7:	29 c2                	sub    %eax,%edx
  8002d9:	89 d0                	mov    %edx,%eax
  8002db:	83 f8 01             	cmp    $0x1,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 45 2a 80 00       	push   $0x802a45
  8002e8:	6a 4f                	push   $0x4f
  8002ea:	68 9c 29 80 00       	push   $0x80299c
  8002ef:	e8 26 07 00 00       	call   800a1a <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f4:	e8 17 1f 00 00       	call   802210 <sys_calculate_free_frames>
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002fc:	e8 92 1f 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800301:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800304:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800307:	89 d0                	mov    %edx,%eax
  800309:	01 c0                	add    %eax,%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	50                   	push   %eax
  800315:	e8 2c 17 00 00       	call   801a46 <malloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800320:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800323:	89 c2                	mov    %eax,%edx
  800325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800328:	c1 e0 02             	shl    $0x2,%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800330:	c1 e0 03             	shl    $0x3,%eax
  800333:	01 c8                	add    %ecx,%eax
  800335:	05 00 00 00 80       	add    $0x80000000,%eax
  80033a:	39 c2                	cmp    %eax,%edx
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 f8 29 80 00       	push   $0x8029f8
  800346:	6a 55                	push   $0x55
  800348:	68 9c 29 80 00       	push   $0x80299c
  80034d:	e8 c8 06 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800352:	e8 3c 1f 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800357:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80035a:	83 f8 02             	cmp    $0x2,%eax
  80035d:	74 14                	je     800373 <_main+0x33b>
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	68 28 2a 80 00       	push   $0x802a28
  800367:	6a 57                	push   $0x57
  800369:	68 9c 29 80 00       	push   $0x80299c
  80036e:	e8 a7 06 00 00       	call   800a1a <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 98 1e 00 00       	call   802210 <sys_calculate_free_frames>
  800378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 13 1f 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800380:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800383:	8b 45 90             	mov    -0x70(%ebp),%eax
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	50                   	push   %eax
  80038a:	e8 65 1b 00 00       	call   801ef4 <free>
  80038f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800392:	e8 fc 1e 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800397:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80039a:	29 c2                	sub    %eax,%edx
  80039c:	89 d0                	mov    %edx,%eax
  80039e:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003a3:	74 14                	je     8003b9 <_main+0x381>
  8003a5:	83 ec 04             	sub    $0x4,%esp
  8003a8:	68 45 2a 80 00       	push   $0x802a45
  8003ad:	6a 5e                	push   $0x5e
  8003af:	68 9c 29 80 00       	push   $0x80299c
  8003b4:	e8 61 06 00 00       	call   800a1a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b9:	e8 52 1e 00 00       	call   802210 <sys_calculate_free_frames>
  8003be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c1:	e8 cd 1e 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8003c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003cc:	89 c2                	mov    %eax,%edx
  8003ce:	01 d2                	add    %edx,%edx
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003d5:	83 ec 0c             	sub    $0xc,%esp
  8003d8:	50                   	push   %eax
  8003d9:	e8 68 16 00 00       	call   801a46 <malloc>
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003e4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e7:	89 c2                	mov    %eax,%edx
  8003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ec:	c1 e0 02             	shl    $0x2,%eax
  8003ef:	89 c1                	mov    %eax,%ecx
  8003f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f4:	c1 e0 04             	shl    $0x4,%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	05 00 00 00 80       	add    $0x80000000,%eax
  8003fe:	39 c2                	cmp    %eax,%edx
  800400:	74 14                	je     800416 <_main+0x3de>
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	68 f8 29 80 00       	push   $0x8029f8
  80040a:	6a 64                	push   $0x64
  80040c:	68 9c 29 80 00       	push   $0x80299c
  800411:	e8 04 06 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800416:	e8 78 1e 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80041b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80041e:	89 c2                	mov    %eax,%edx
  800420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800423:	89 c1                	mov    %eax,%ecx
  800425:	01 c9                	add    %ecx,%ecx
  800427:	01 c8                	add    %ecx,%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	79 05                	jns    800432 <_main+0x3fa>
  80042d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800432:	c1 f8 0c             	sar    $0xc,%eax
  800435:	39 c2                	cmp    %eax,%edx
  800437:	74 14                	je     80044d <_main+0x415>
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 28 2a 80 00       	push   $0x802a28
  800441:	6a 66                	push   $0x66
  800443:	68 9c 29 80 00       	push   $0x80299c
  800448:	e8 cd 05 00 00       	call   800a1a <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80044d:	e8 be 1d 00 00       	call   802210 <sys_calculate_free_frames>
  800452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800455:	e8 39 1e 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80045a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80045d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800460:	89 c2                	mov    %eax,%edx
  800462:	01 d2                	add    %edx,%edx
  800464:	01 c2                	add    %eax,%edx
  800466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	01 c0                	add    %eax,%eax
  80046d:	83 ec 0c             	sub    $0xc,%esp
  800470:	50                   	push   %eax
  800471:	e8 d0 15 00 00       	call   801a46 <malloc>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80047c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047f:	89 c1                	mov    %eax,%ecx
  800481:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	01 d0                	add    %edx,%eax
  80048a:	01 c0                	add    %eax,%eax
  80048c:	01 d0                	add    %edx,%eax
  80048e:	89 c2                	mov    %eax,%edx
  800490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800493:	c1 e0 04             	shl    $0x4,%eax
  800496:	01 d0                	add    %edx,%eax
  800498:	05 00 00 00 80       	add    $0x80000000,%eax
  80049d:	39 c1                	cmp    %eax,%ecx
  80049f:	74 14                	je     8004b5 <_main+0x47d>
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 f8 29 80 00       	push   $0x8029f8
  8004a9:	6a 6c                	push   $0x6c
  8004ab:	68 9c 29 80 00       	push   $0x80299c
  8004b0:	e8 65 05 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004b5:	e8 d9 1d 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8004ba:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004bd:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004c2:	74 14                	je     8004d8 <_main+0x4a0>
  8004c4:	83 ec 04             	sub    $0x4,%esp
  8004c7:	68 28 2a 80 00       	push   $0x802a28
  8004cc:	6a 6e                	push   $0x6e
  8004ce:	68 9c 29 80 00       	push   $0x80299c
  8004d3:	e8 42 05 00 00       	call   800a1a <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 33 1d 00 00       	call   802210 <sys_calculate_free_frames>
  8004dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 ae 1d 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	c1 e0 02             	shl    $0x2,%eax
  8004f0:	01 d0                	add    %edx,%eax
  8004f2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004f5:	83 ec 0c             	sub    $0xc,%esp
  8004f8:	50                   	push   %eax
  8004f9:	e8 48 15 00 00       	call   801a46 <malloc>
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800504:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800507:	89 c1                	mov    %eax,%ecx
  800509:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	c1 e0 03             	shl    $0x3,%eax
  800511:	01 d0                	add    %edx,%eax
  800513:	89 c3                	mov    %eax,%ebx
  800515:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 d8                	add    %ebx,%eax
  800523:	05 00 00 00 80       	add    $0x80000000,%eax
  800528:	39 c1                	cmp    %eax,%ecx
  80052a:	74 14                	je     800540 <_main+0x508>
  80052c:	83 ec 04             	sub    $0x4,%esp
  80052f:	68 f8 29 80 00       	push   $0x8029f8
  800534:	6a 74                	push   $0x74
  800536:	68 9c 29 80 00       	push   $0x80299c
  80053b:	e8 da 04 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800540:	e8 4e 1d 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800545:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800548:	89 c1                	mov    %eax,%ecx
  80054a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80054d:	89 d0                	mov    %edx,%eax
  80054f:	c1 e0 02             	shl    $0x2,%eax
  800552:	01 d0                	add    %edx,%eax
  800554:	85 c0                	test   %eax,%eax
  800556:	79 05                	jns    80055d <_main+0x525>
  800558:	05 ff 0f 00 00       	add    $0xfff,%eax
  80055d:	c1 f8 0c             	sar    $0xc,%eax
  800560:	39 c1                	cmp    %eax,%ecx
  800562:	74 14                	je     800578 <_main+0x540>
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	68 28 2a 80 00       	push   $0x802a28
  80056c:	6a 76                	push   $0x76
  80056e:	68 9c 29 80 00       	push   $0x80299c
  800573:	e8 a2 04 00 00       	call   800a1a <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  800578:	e8 93 1c 00 00       	call   802210 <sys_calculate_free_frames>
  80057d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800580:	e8 0e 1d 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800585:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  800588:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058b:	83 ec 0c             	sub    $0xc,%esp
  80058e:	50                   	push   %eax
  80058f:	e8 60 19 00 00       	call   801ef4 <free>
  800594:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  800597:	e8 f7 1c 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80059c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80059f:	29 c2                	sub    %eax,%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005a8:	74 14                	je     8005be <_main+0x586>
  8005aa:	83 ec 04             	sub    $0x4,%esp
  8005ad:	68 45 2a 80 00       	push   $0x802a45
  8005b2:	6a 7d                	push   $0x7d
  8005b4:	68 9c 29 80 00       	push   $0x80299c
  8005b9:	e8 5c 04 00 00       	call   800a1a <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005be:	e8 4d 1c 00 00       	call   802210 <sys_calculate_free_frames>
  8005c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c6:	e8 c8 1c 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ce:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	50                   	push   %eax
  8005d5:	e8 1a 19 00 00       	call   801ef4 <free>
  8005da:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005dd:	e8 b1 1c 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8005e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e5:	29 c2                	sub    %eax,%edx
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8005ee:	74 17                	je     800607 <_main+0x5cf>
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 45 2a 80 00       	push   $0x802a45
  8005f8:	68 84 00 00 00       	push   $0x84
  8005fd:	68 9c 29 80 00       	push   $0x80299c
  800602:	e8 13 04 00 00       	call   800a1a <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800607:	e8 04 1c 00 00       	call   802210 <sys_calculate_free_frames>
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060f:	e8 7f 1c 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800614:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  800617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80061a:	01 c0                	add    %eax,%eax
  80061c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80061f:	83 ec 0c             	sub    $0xc,%esp
  800622:	50                   	push   %eax
  800623:	e8 1e 14 00 00       	call   801a46 <malloc>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80062e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800631:	89 c1                	mov    %eax,%ecx
  800633:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800636:	89 d0                	mov    %edx,%eax
  800638:	01 c0                	add    %eax,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c0                	add    %eax,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	89 c2                	mov    %eax,%edx
  800642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800645:	c1 e0 04             	shl    $0x4,%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	05 00 00 00 80       	add    $0x80000000,%eax
  80064f:	39 c1                	cmp    %eax,%ecx
  800651:	74 17                	je     80066a <_main+0x632>
  800653:	83 ec 04             	sub    $0x4,%esp
  800656:	68 f8 29 80 00       	push   $0x8029f8
  80065b:	68 8a 00 00 00       	push   $0x8a
  800660:	68 9c 29 80 00       	push   $0x80299c
  800665:	e8 b0 03 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80066a:	e8 24 1c 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80066f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800672:	3d 00 02 00 00       	cmp    $0x200,%eax
  800677:	74 17                	je     800690 <_main+0x658>
  800679:	83 ec 04             	sub    $0x4,%esp
  80067c:	68 28 2a 80 00       	push   $0x802a28
  800681:	68 8c 00 00 00       	push   $0x8c
  800686:	68 9c 29 80 00       	push   $0x80299c
  80068b:	e8 8a 03 00 00       	call   800a1a <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800690:	e8 7b 1b 00 00       	call   802210 <sys_calculate_free_frames>
  800695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800698:	e8 f6 1b 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80069d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006a3:	89 d0                	mov    %edx,%eax
  8006a5:	01 c0                	add    %eax,%eax
  8006a7:	01 d0                	add    %edx,%eax
  8006a9:	01 c0                	add    %eax,%eax
  8006ab:	83 ec 0c             	sub    $0xc,%esp
  8006ae:	50                   	push   %eax
  8006af:	e8 92 13 00 00       	call   801a46 <malloc>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006bd:	89 c1                	mov    %eax,%ecx
  8006bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c2:	89 d0                	mov    %edx,%eax
  8006c4:	c1 e0 03             	shl    $0x3,%eax
  8006c7:	01 d0                	add    %edx,%eax
  8006c9:	89 c2                	mov    %eax,%edx
  8006cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ce:	c1 e0 04             	shl    $0x4,%eax
  8006d1:	01 d0                	add    %edx,%eax
  8006d3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006d8:	39 c1                	cmp    %eax,%ecx
  8006da:	74 17                	je     8006f3 <_main+0x6bb>
  8006dc:	83 ec 04             	sub    $0x4,%esp
  8006df:	68 f8 29 80 00       	push   $0x8029f8
  8006e4:	68 92 00 00 00       	push   $0x92
  8006e9:	68 9c 29 80 00       	push   $0x80299c
  8006ee:	e8 27 03 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  8006f3:	e8 9b 1b 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8006f8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8006fb:	83 f8 02             	cmp    $0x2,%eax
  8006fe:	74 17                	je     800717 <_main+0x6df>
  800700:	83 ec 04             	sub    $0x4,%esp
  800703:	68 28 2a 80 00       	push   $0x802a28
  800708:	68 94 00 00 00       	push   $0x94
  80070d:	68 9c 29 80 00       	push   $0x80299c
  800712:	e8 03 03 00 00       	call   800a1a <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800717:	e8 f4 1a 00 00       	call   802210 <sys_calculate_free_frames>
  80071c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80071f:	e8 6f 1b 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800724:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  800727:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80072a:	83 ec 0c             	sub    $0xc,%esp
  80072d:	50                   	push   %eax
  80072e:	e8 c1 17 00 00       	call   801ef4 <free>
  800733:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800736:	e8 58 1b 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80073b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80073e:	29 c2                	sub    %eax,%edx
  800740:	89 d0                	mov    %edx,%eax
  800742:	3d 00 03 00 00       	cmp    $0x300,%eax
  800747:	74 17                	je     800760 <_main+0x728>
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	68 45 2a 80 00       	push   $0x802a45
  800751:	68 9b 00 00 00       	push   $0x9b
  800756:	68 9c 29 80 00       	push   $0x80299c
  80075b:	e8 ba 02 00 00       	call   800a1a <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800760:	e8 ab 1a 00 00       	call   802210 <sys_calculate_free_frames>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800768:	e8 26 1b 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  80076d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800773:	89 c2                	mov    %eax,%edx
  800775:	01 d2                	add    %edx,%edx
  800777:	01 d0                	add    %edx,%eax
  800779:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	50                   	push   %eax
  800780:	e8 c1 12 00 00       	call   801a46 <malloc>
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80078b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80078e:	89 c2                	mov    %eax,%edx
  800790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800793:	c1 e0 02             	shl    $0x2,%eax
  800796:	89 c1                	mov    %eax,%ecx
  800798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80079b:	c1 e0 04             	shl    $0x4,%eax
  80079e:	01 c8                	add    %ecx,%eax
  8007a0:	05 00 00 00 80       	add    $0x80000000,%eax
  8007a5:	39 c2                	cmp    %eax,%edx
  8007a7:	74 17                	je     8007c0 <_main+0x788>
  8007a9:	83 ec 04             	sub    $0x4,%esp
  8007ac:	68 f8 29 80 00       	push   $0x8029f8
  8007b1:	68 a1 00 00 00       	push   $0xa1
  8007b6:	68 9c 29 80 00       	push   $0x80299c
  8007bb:	e8 5a 02 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007c0:	e8 ce 1a 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  8007c5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007c8:	89 c2                	mov    %eax,%edx
  8007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cd:	89 c1                	mov    %eax,%ecx
  8007cf:	01 c9                	add    %ecx,%ecx
  8007d1:	01 c8                	add    %ecx,%eax
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	79 05                	jns    8007dc <_main+0x7a4>
  8007d7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007dc:	c1 f8 0c             	sar    $0xc,%eax
  8007df:	39 c2                	cmp    %eax,%edx
  8007e1:	74 17                	je     8007fa <_main+0x7c2>
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	68 28 2a 80 00       	push   $0x802a28
  8007eb:	68 a3 00 00 00       	push   $0xa3
  8007f0:	68 9c 29 80 00       	push   $0x80299c
  8007f5:	e8 20 02 00 00       	call   800a1a <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  8007fa:	e8 11 1a 00 00       	call   802210 <sys_calculate_free_frames>
  8007ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800802:	e8 8c 1a 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800807:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  80080a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080d:	c1 e0 02             	shl    $0x2,%eax
  800810:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800813:	83 ec 0c             	sub    $0xc,%esp
  800816:	50                   	push   %eax
  800817:	e8 2a 12 00 00       	call   801a46 <malloc>
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800822:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800825:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80082a:	74 17                	je     800843 <_main+0x80b>
  80082c:	83 ec 04             	sub    $0x4,%esp
  80082f:	68 f8 29 80 00       	push   $0x8029f8
  800834:	68 a9 00 00 00       	push   $0xa9
  800839:	68 9c 29 80 00       	push   $0x80299c
  80083e:	e8 d7 01 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800843:	e8 4b 1a 00 00       	call   802293 <sys_pf_calculate_allocated_pages>
  800848:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80084b:	89 c2                	mov    %eax,%edx
  80084d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800850:	c1 e0 02             	shl    $0x2,%eax
  800853:	85 c0                	test   %eax,%eax
  800855:	79 05                	jns    80085c <_main+0x824>
  800857:	05 ff 0f 00 00       	add    $0xfff,%eax
  80085c:	c1 f8 0c             	sar    $0xc,%eax
  80085f:	39 c2                	cmp    %eax,%edx
  800861:	74 17                	je     80087a <_main+0x842>
  800863:	83 ec 04             	sub    $0x4,%esp
  800866:	68 28 2a 80 00       	push   $0x802a28
  80086b:	68 ab 00 00 00       	push   $0xab
  800870:	68 9c 29 80 00       	push   $0x80299c
  800875:	e8 a0 01 00 00       	call   800a1a <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  80087a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80087d:	89 d0                	mov    %edx,%eax
  80087f:	01 c0                	add    %eax,%eax
  800881:	01 d0                	add    %edx,%eax
  800883:	01 c0                	add    %eax,%eax
  800885:	01 d0                	add    %edx,%eax
  800887:	01 c0                	add    %eax,%eax
  800889:	f7 d8                	neg    %eax
  80088b:	05 00 00 00 20       	add    $0x20000000,%eax
  800890:	83 ec 0c             	sub    $0xc,%esp
  800893:	50                   	push   %eax
  800894:	e8 ad 11 00 00       	call   801a46 <malloc>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80089f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	74 17                	je     8008bd <_main+0x885>
  8008a6:	83 ec 04             	sub    $0x4,%esp
  8008a9:	68 5c 2a 80 00       	push   $0x802a5c
  8008ae:	68 b4 00 00 00       	push   $0xb4
  8008b3:	68 9c 29 80 00       	push   $0x80299c
  8008b8:	e8 5d 01 00 00       	call   800a1a <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008bd:	83 ec 0c             	sub    $0xc,%esp
  8008c0:	68 c0 2a 80 00       	push   $0x802ac0
  8008c5:	e8 f2 03 00 00       	call   800cbc <cprintf>
  8008ca:	83 c4 10             	add    $0x10,%esp

		return;
  8008cd:	90                   	nop
	}
}
  8008ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d1:	5b                   	pop    %ebx
  8008d2:	5f                   	pop    %edi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008db:	e8 65 18 00 00       	call   802145 <sys_getenvindex>
  8008e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e6:	89 d0                	mov    %edx,%eax
  8008e8:	c1 e0 03             	shl    $0x3,%eax
  8008eb:	01 d0                	add    %edx,%eax
  8008ed:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8008f4:	01 c8                	add    %ecx,%eax
  8008f6:	01 c0                	add    %eax,%eax
  8008f8:	01 d0                	add    %edx,%eax
  8008fa:	01 c0                	add    %eax,%eax
  8008fc:	01 d0                	add    %edx,%eax
  8008fe:	89 c2                	mov    %eax,%edx
  800900:	c1 e2 05             	shl    $0x5,%edx
  800903:	29 c2                	sub    %eax,%edx
  800905:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80090c:	89 c2                	mov    %eax,%edx
  80090e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800914:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800919:	a1 20 40 80 00       	mov    0x804020,%eax
  80091e:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800924:	84 c0                	test   %al,%al
  800926:	74 0f                	je     800937 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800928:	a1 20 40 80 00       	mov    0x804020,%eax
  80092d:	05 40 3c 01 00       	add    $0x13c40,%eax
  800932:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800937:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093b:	7e 0a                	jle    800947 <libmain+0x72>
		binaryname = argv[0];
  80093d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 e3 f6 ff ff       	call   800038 <_main>
  800955:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800958:	e8 83 19 00 00       	call   8022e0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80095d:	83 ec 0c             	sub    $0xc,%esp
  800960:	68 20 2b 80 00       	push   $0x802b20
  800965:	e8 52 03 00 00       	call   800cbc <cprintf>
  80096a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80096d:	a1 20 40 80 00       	mov    0x804020,%eax
  800972:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800978:	a1 20 40 80 00       	mov    0x804020,%eax
  80097d:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800983:	83 ec 04             	sub    $0x4,%esp
  800986:	52                   	push   %edx
  800987:	50                   	push   %eax
  800988:	68 48 2b 80 00       	push   $0x802b48
  80098d:	e8 2a 03 00 00       	call   800cbc <cprintf>
  800992:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800995:	a1 20 40 80 00       	mov    0x804020,%eax
  80099a:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8009a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8009a5:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8009ab:	83 ec 04             	sub    $0x4,%esp
  8009ae:	52                   	push   %edx
  8009af:	50                   	push   %eax
  8009b0:	68 70 2b 80 00       	push   $0x802b70
  8009b5:	e8 02 03 00 00       	call   800cbc <cprintf>
  8009ba:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8009c2:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	50                   	push   %eax
  8009cc:	68 b1 2b 80 00       	push   $0x802bb1
  8009d1:	e8 e6 02 00 00       	call   800cbc <cprintf>
  8009d6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009d9:	83 ec 0c             	sub    $0xc,%esp
  8009dc:	68 20 2b 80 00       	push   $0x802b20
  8009e1:	e8 d6 02 00 00       	call   800cbc <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009e9:	e8 0c 19 00 00       	call   8022fa <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009ee:	e8 19 00 00 00       	call   800a0c <exit>
}
  8009f3:	90                   	nop
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8009fc:	83 ec 0c             	sub    $0xc,%esp
  8009ff:	6a 00                	push   $0x0
  800a01:	e8 0b 17 00 00       	call   802111 <sys_env_destroy>
  800a06:	83 c4 10             	add    $0x10,%esp
}
  800a09:	90                   	nop
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <exit>:

void
exit(void)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a12:	e8 60 17 00 00       	call   802177 <sys_env_exit>
}
  800a17:	90                   	nop
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a20:	8d 45 10             	lea    0x10(%ebp),%eax
  800a23:	83 c0 04             	add    $0x4,%eax
  800a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a29:	a1 18 41 80 00       	mov    0x804118,%eax
  800a2e:	85 c0                	test   %eax,%eax
  800a30:	74 16                	je     800a48 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a32:	a1 18 41 80 00       	mov    0x804118,%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	68 c8 2b 80 00       	push   $0x802bc8
  800a40:	e8 77 02 00 00       	call   800cbc <cprintf>
  800a45:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a48:	a1 00 40 80 00       	mov    0x804000,%eax
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	ff 75 08             	pushl  0x8(%ebp)
  800a53:	50                   	push   %eax
  800a54:	68 cd 2b 80 00       	push   $0x802bcd
  800a59:	e8 5e 02 00 00       	call   800cbc <cprintf>
  800a5e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a61:	8b 45 10             	mov    0x10(%ebp),%eax
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6a:	50                   	push   %eax
  800a6b:	e8 e1 01 00 00       	call   800c51 <vcprintf>
  800a70:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	6a 00                	push   $0x0
  800a78:	68 e9 2b 80 00       	push   $0x802be9
  800a7d:	e8 cf 01 00 00       	call   800c51 <vcprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a85:	e8 82 ff ff ff       	call   800a0c <exit>

	// should not return here
	while (1) ;
  800a8a:	eb fe                	jmp    800a8a <_panic+0x70>

00800a8c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a92:	a1 20 40 80 00       	mov    0x804020,%eax
  800a97:	8b 50 74             	mov    0x74(%eax),%edx
  800a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9d:	39 c2                	cmp    %eax,%edx
  800a9f:	74 14                	je     800ab5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aa1:	83 ec 04             	sub    $0x4,%esp
  800aa4:	68 ec 2b 80 00       	push   $0x802bec
  800aa9:	6a 26                	push   $0x26
  800aab:	68 38 2c 80 00       	push   $0x802c38
  800ab0:	e8 65 ff ff ff       	call   800a1a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800abc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ac3:	e9 b6 00 00 00       	jmp    800b7e <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800acb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	85 c0                	test   %eax,%eax
  800adb:	75 08                	jne    800ae5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800add:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800ae0:	e9 96 00 00 00       	jmp    800b7b <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800ae5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800af3:	eb 5d                	jmp    800b52 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800af5:	a1 20 40 80 00       	mov    0x804020,%eax
  800afa:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b03:	c1 e2 04             	shl    $0x4,%edx
  800b06:	01 d0                	add    %edx,%eax
  800b08:	8a 40 04             	mov    0x4(%eax),%al
  800b0b:	84 c0                	test   %al,%al
  800b0d:	75 40                	jne    800b4f <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b0f:	a1 20 40 80 00       	mov    0x804020,%eax
  800b14:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b1d:	c1 e2 04             	shl    $0x4,%edx
  800b20:	01 d0                	add    %edx,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b2f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b34:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	01 c8                	add    %ecx,%eax
  800b40:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b42:	39 c2                	cmp    %eax,%edx
  800b44:	75 09                	jne    800b4f <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800b46:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b4d:	eb 12                	jmp    800b61 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b4f:	ff 45 e8             	incl   -0x18(%ebp)
  800b52:	a1 20 40 80 00       	mov    0x804020,%eax
  800b57:	8b 50 74             	mov    0x74(%eax),%edx
  800b5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b5d:	39 c2                	cmp    %eax,%edx
  800b5f:	77 94                	ja     800af5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b65:	75 14                	jne    800b7b <CheckWSWithoutLastIndex+0xef>
			panic(
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 44 2c 80 00       	push   $0x802c44
  800b6f:	6a 3a                	push   $0x3a
  800b71:	68 38 2c 80 00       	push   $0x802c38
  800b76:	e8 9f fe ff ff       	call   800a1a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b7b:	ff 45 f0             	incl   -0x10(%ebp)
  800b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b84:	0f 8c 3e ff ff ff    	jl     800ac8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b98:	eb 20                	jmp    800bba <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b9a:	a1 20 40 80 00       	mov    0x804020,%eax
  800b9f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800ba5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ba8:	c1 e2 04             	shl    $0x4,%edx
  800bab:	01 d0                	add    %edx,%eax
  800bad:	8a 40 04             	mov    0x4(%eax),%al
  800bb0:	3c 01                	cmp    $0x1,%al
  800bb2:	75 03                	jne    800bb7 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800bb4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bb7:	ff 45 e0             	incl   -0x20(%ebp)
  800bba:	a1 20 40 80 00       	mov    0x804020,%eax
  800bbf:	8b 50 74             	mov    0x74(%eax),%edx
  800bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bc5:	39 c2                	cmp    %eax,%edx
  800bc7:	77 d1                	ja     800b9a <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bcc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bcf:	74 14                	je     800be5 <CheckWSWithoutLastIndex+0x159>
		panic(
  800bd1:	83 ec 04             	sub    $0x4,%esp
  800bd4:	68 98 2c 80 00       	push   $0x802c98
  800bd9:	6a 44                	push   $0x44
  800bdb:	68 38 2c 80 00       	push   $0x802c38
  800be0:	e8 35 fe ff ff       	call   800a1a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	8b 00                	mov    (%eax),%eax
  800bf3:	8d 48 01             	lea    0x1(%eax),%ecx
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	89 0a                	mov    %ecx,(%edx)
  800bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfe:	88 d1                	mov    %dl,%cl
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c11:	75 2c                	jne    800c3f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c13:	a0 24 40 80 00       	mov    0x804024,%al
  800c18:	0f b6 c0             	movzbl %al,%eax
  800c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1e:	8b 12                	mov    (%edx),%edx
  800c20:	89 d1                	mov    %edx,%ecx
  800c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c25:	83 c2 08             	add    $0x8,%edx
  800c28:	83 ec 04             	sub    $0x4,%esp
  800c2b:	50                   	push   %eax
  800c2c:	51                   	push   %ecx
  800c2d:	52                   	push   %edx
  800c2e:	e8 9c 14 00 00       	call   8020cf <sys_cputs>
  800c33:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	8b 40 04             	mov    0x4(%eax),%eax
  800c45:	8d 50 01             	lea    0x1(%eax),%edx
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c4e:	90                   	nop
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c5a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c61:	00 00 00 
	b.cnt = 0;
  800c64:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c6b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c7a:	50                   	push   %eax
  800c7b:	68 e8 0b 80 00       	push   $0x800be8
  800c80:	e8 11 02 00 00       	call   800e96 <vprintfmt>
  800c85:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c88:	a0 24 40 80 00       	mov    0x804024,%al
  800c8d:	0f b6 c0             	movzbl %al,%eax
  800c90:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	50                   	push   %eax
  800c9a:	52                   	push   %edx
  800c9b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ca1:	83 c0 08             	add    $0x8,%eax
  800ca4:	50                   	push   %eax
  800ca5:	e8 25 14 00 00       	call   8020cf <sys_cputs>
  800caa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800cad:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800cb4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <cprintf>:

int cprintf(const char *fmt, ...) {
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cc2:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800cc9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	83 ec 08             	sub    $0x8,%esp
  800cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd8:	50                   	push   %eax
  800cd9:	e8 73 ff ff ff       	call   800c51 <vcprintf>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800cef:	e8 ec 15 00 00       	call   8022e0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800cf4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 f4             	pushl  -0xc(%ebp)
  800d03:	50                   	push   %eax
  800d04:	e8 48 ff ff ff       	call   800c51 <vcprintf>
  800d09:	83 c4 10             	add    $0x10,%esp
  800d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d0f:	e8 e6 15 00 00       	call   8022fa <sys_enable_interrupt>
	return cnt;
  800d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 14             	sub    $0x14,%esp
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d26:	8b 45 14             	mov    0x14(%ebp),%eax
  800d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d2c:	8b 45 18             	mov    0x18(%ebp),%eax
  800d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d34:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d37:	77 55                	ja     800d8e <printnum+0x75>
  800d39:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d3c:	72 05                	jb     800d43 <printnum+0x2a>
  800d3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d41:	77 4b                	ja     800d8e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d43:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d46:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d49:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d51:	52                   	push   %edx
  800d52:	50                   	push   %eax
  800d53:	ff 75 f4             	pushl  -0xc(%ebp)
  800d56:	ff 75 f0             	pushl  -0x10(%ebp)
  800d59:	e8 a6 19 00 00       	call   802704 <__udivdi3>
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	ff 75 20             	pushl  0x20(%ebp)
  800d67:	53                   	push   %ebx
  800d68:	ff 75 18             	pushl  0x18(%ebp)
  800d6b:	52                   	push   %edx
  800d6c:	50                   	push   %eax
  800d6d:	ff 75 0c             	pushl  0xc(%ebp)
  800d70:	ff 75 08             	pushl  0x8(%ebp)
  800d73:	e8 a1 ff ff ff       	call   800d19 <printnum>
  800d78:	83 c4 20             	add    $0x20,%esp
  800d7b:	eb 1a                	jmp    800d97 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d7d:	83 ec 08             	sub    $0x8,%esp
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d8e:	ff 4d 1c             	decl   0x1c(%ebp)
  800d91:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d95:	7f e6                	jg     800d7d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d97:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da5:	53                   	push   %ebx
  800da6:	51                   	push   %ecx
  800da7:	52                   	push   %edx
  800da8:	50                   	push   %eax
  800da9:	e8 66 1a 00 00       	call   802814 <__umoddi3>
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	05 14 2f 80 00       	add    $0x802f14,%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	0f be c0             	movsbl %al,%eax
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	50                   	push   %eax
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
}
  800dca:	90                   	nop
  800dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd7:	7e 1c                	jle    800df5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	8d 50 08             	lea    0x8(%eax),%edx
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	89 10                	mov    %edx,(%eax)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8b 00                	mov    (%eax),%eax
  800deb:	83 e8 08             	sub    $0x8,%eax
  800dee:	8b 50 04             	mov    0x4(%eax),%edx
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	eb 40                	jmp    800e35 <getuint+0x65>
	else if (lflag)
  800df5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df9:	74 1e                	je     800e19 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 00                	mov    (%eax),%eax
  800e00:	8d 50 04             	lea    0x4(%eax),%edx
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	89 10                	mov    %edx,(%eax)
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8b 00                	mov    (%eax),%eax
  800e0d:	83 e8 04             	sub    $0x4,%eax
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	ba 00 00 00 00       	mov    $0x0,%edx
  800e17:	eb 1c                	jmp    800e35 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8b 00                	mov    (%eax),%eax
  800e1e:	8d 50 04             	lea    0x4(%eax),%edx
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	89 10                	mov    %edx,(%eax)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	83 e8 04             	sub    $0x4,%eax
  800e2e:	8b 00                	mov    (%eax),%eax
  800e30:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e3a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e3e:	7e 1c                	jle    800e5c <getint+0x25>
		return va_arg(*ap, long long);
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8b 00                	mov    (%eax),%eax
  800e45:	8d 50 08             	lea    0x8(%eax),%edx
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	89 10                	mov    %edx,(%eax)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8b 00                	mov    (%eax),%eax
  800e52:	83 e8 08             	sub    $0x8,%eax
  800e55:	8b 50 04             	mov    0x4(%eax),%edx
  800e58:	8b 00                	mov    (%eax),%eax
  800e5a:	eb 38                	jmp    800e94 <getint+0x5d>
	else if (lflag)
  800e5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e60:	74 1a                	je     800e7c <getint+0x45>
		return va_arg(*ap, long);
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8b 00                	mov    (%eax),%eax
  800e67:	8d 50 04             	lea    0x4(%eax),%edx
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 10                	mov    %edx,(%eax)
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8b 00                	mov    (%eax),%eax
  800e74:	83 e8 04             	sub    $0x4,%eax
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	99                   	cltd   
  800e7a:	eb 18                	jmp    800e94 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8b 00                	mov    (%eax),%eax
  800e81:	8d 50 04             	lea    0x4(%eax),%edx
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 10                	mov    %edx,(%eax)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	83 e8 04             	sub    $0x4,%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	99                   	cltd   
}
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e9e:	eb 17                	jmp    800eb7 <vprintfmt+0x21>
			if (ch == '\0')
  800ea0:	85 db                	test   %ebx,%ebx
  800ea2:	0f 84 af 03 00 00    	je     801257 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	53                   	push   %ebx
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	ff d0                	call   *%eax
  800eb4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 01             	lea    0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d8             	movzbl %al,%ebx
  800ec5:	83 fb 25             	cmp    $0x25,%ebx
  800ec8:	75 d6                	jne    800ea0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800eca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ece:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ed5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800edc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ee3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 01             	lea    0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d8             	movzbl %al,%ebx
  800ef8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800efb:	83 f8 55             	cmp    $0x55,%eax
  800efe:	0f 87 2b 03 00 00    	ja     80122f <vprintfmt+0x399>
  800f04:	8b 04 85 38 2f 80 00 	mov    0x802f38(,%eax,4),%eax
  800f0b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f0d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f11:	eb d7                	jmp    800eea <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f13:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f17:	eb d1                	jmp    800eea <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f19:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	01 d8                	add    %ebx,%eax
  800f2e:	83 e8 30             	sub    $0x30,%eax
  800f31:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f3c:	83 fb 2f             	cmp    $0x2f,%ebx
  800f3f:	7e 3e                	jle    800f7f <vprintfmt+0xe9>
  800f41:	83 fb 39             	cmp    $0x39,%ebx
  800f44:	7f 39                	jg     800f7f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f46:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f49:	eb d5                	jmp    800f20 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4e:	83 c0 04             	add    $0x4,%eax
  800f51:	89 45 14             	mov    %eax,0x14(%ebp)
  800f54:	8b 45 14             	mov    0x14(%ebp),%eax
  800f57:	83 e8 04             	sub    $0x4,%eax
  800f5a:	8b 00                	mov    (%eax),%eax
  800f5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f5f:	eb 1f                	jmp    800f80 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f65:	79 83                	jns    800eea <vprintfmt+0x54>
				width = 0;
  800f67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f6e:	e9 77 ff ff ff       	jmp    800eea <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f73:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f7a:	e9 6b ff ff ff       	jmp    800eea <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f7f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	0f 89 60 ff ff ff    	jns    800eea <vprintfmt+0x54>
				width = precision, precision = -1;
  800f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f90:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f97:	e9 4e ff ff ff       	jmp    800eea <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f9c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f9f:	e9 46 ff ff ff       	jmp    800eea <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa7:	83 c0 04             	add    $0x4,%eax
  800faa:	89 45 14             	mov    %eax,0x14(%ebp)
  800fad:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb0:	83 e8 04             	sub    $0x4,%eax
  800fb3:	8b 00                	mov    (%eax),%eax
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	ff d0                	call   *%eax
  800fc1:	83 c4 10             	add    $0x10,%esp
			break;
  800fc4:	e9 89 02 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd5:	83 e8 04             	sub    $0x4,%eax
  800fd8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800fda:	85 db                	test   %ebx,%ebx
  800fdc:	79 02                	jns    800fe0 <vprintfmt+0x14a>
				err = -err;
  800fde:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fe0:	83 fb 64             	cmp    $0x64,%ebx
  800fe3:	7f 0b                	jg     800ff0 <vprintfmt+0x15a>
  800fe5:	8b 34 9d 80 2d 80 00 	mov    0x802d80(,%ebx,4),%esi
  800fec:	85 f6                	test   %esi,%esi
  800fee:	75 19                	jne    801009 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ff0:	53                   	push   %ebx
  800ff1:	68 25 2f 80 00       	push   $0x802f25
  800ff6:	ff 75 0c             	pushl  0xc(%ebp)
  800ff9:	ff 75 08             	pushl  0x8(%ebp)
  800ffc:	e8 5e 02 00 00       	call   80125f <printfmt>
  801001:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801004:	e9 49 02 00 00       	jmp    801252 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801009:	56                   	push   %esi
  80100a:	68 2e 2f 80 00       	push   $0x802f2e
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 45 02 00 00       	call   80125f <printfmt>
  80101a:	83 c4 10             	add    $0x10,%esp
			break;
  80101d:	e9 30 02 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801022:	8b 45 14             	mov    0x14(%ebp),%eax
  801025:	83 c0 04             	add    $0x4,%eax
  801028:	89 45 14             	mov    %eax,0x14(%ebp)
  80102b:	8b 45 14             	mov    0x14(%ebp),%eax
  80102e:	83 e8 04             	sub    $0x4,%eax
  801031:	8b 30                	mov    (%eax),%esi
  801033:	85 f6                	test   %esi,%esi
  801035:	75 05                	jne    80103c <vprintfmt+0x1a6>
				p = "(null)";
  801037:	be 31 2f 80 00       	mov    $0x802f31,%esi
			if (width > 0 && padc != '-')
  80103c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801040:	7e 6d                	jle    8010af <vprintfmt+0x219>
  801042:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801046:	74 67                	je     8010af <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	50                   	push   %eax
  80104f:	56                   	push   %esi
  801050:	e8 0c 03 00 00       	call   801361 <strnlen>
  801055:	83 c4 10             	add    $0x10,%esp
  801058:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80105b:	eb 16                	jmp    801073 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80105d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	ff 75 0c             	pushl  0xc(%ebp)
  801067:	50                   	push   %eax
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	ff d0                	call   *%eax
  80106d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801070:	ff 4d e4             	decl   -0x1c(%ebp)
  801073:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801077:	7f e4                	jg     80105d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801079:	eb 34                	jmp    8010af <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80107b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80107f:	74 1c                	je     80109d <vprintfmt+0x207>
  801081:	83 fb 1f             	cmp    $0x1f,%ebx
  801084:	7e 05                	jle    80108b <vprintfmt+0x1f5>
  801086:	83 fb 7e             	cmp    $0x7e,%ebx
  801089:	7e 12                	jle    80109d <vprintfmt+0x207>
					putch('?', putdat);
  80108b:	83 ec 08             	sub    $0x8,%esp
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	6a 3f                	push   $0x3f
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	ff d0                	call   *%eax
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	eb 0f                	jmp    8010ac <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	53                   	push   %ebx
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	ff d0                	call   *%eax
  8010a9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8010af:	89 f0                	mov    %esi,%eax
  8010b1:	8d 70 01             	lea    0x1(%eax),%esi
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	0f be d8             	movsbl %al,%ebx
  8010b9:	85 db                	test   %ebx,%ebx
  8010bb:	74 24                	je     8010e1 <vprintfmt+0x24b>
  8010bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010c1:	78 b8                	js     80107b <vprintfmt+0x1e5>
  8010c3:	ff 4d e0             	decl   -0x20(%ebp)
  8010c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010ca:	79 af                	jns    80107b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010cc:	eb 13                	jmp    8010e1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	6a 20                	push   $0x20
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	ff d0                	call   *%eax
  8010db:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010de:	ff 4d e4             	decl   -0x1c(%ebp)
  8010e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010e5:	7f e7                	jg     8010ce <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8010e7:	e9 66 01 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8010f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8010f5:	50                   	push   %eax
  8010f6:	e8 3c fd ff ff       	call   800e37 <getint>
  8010fb:	83 c4 10             	add    $0x10,%esp
  8010fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801101:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110a:	85 d2                	test   %edx,%edx
  80110c:	79 23                	jns    801131 <vprintfmt+0x29b>
				putch('-', putdat);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	6a 2d                	push   $0x2d
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	ff d0                	call   *%eax
  80111b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80111e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801124:	f7 d8                	neg    %eax
  801126:	83 d2 00             	adc    $0x0,%edx
  801129:	f7 da                	neg    %edx
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801131:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801138:	e9 bc 00 00 00       	jmp    8011f9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	ff 75 e8             	pushl  -0x18(%ebp)
  801143:	8d 45 14             	lea    0x14(%ebp),%eax
  801146:	50                   	push   %eax
  801147:	e8 84 fc ff ff       	call   800dd0 <getuint>
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801152:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801155:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80115c:	e9 98 00 00 00       	jmp    8011f9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	6a 58                	push   $0x58
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	ff d0                	call   *%eax
  80116e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	ff 75 0c             	pushl  0xc(%ebp)
  801177:	6a 58                	push   $0x58
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	ff d0                	call   *%eax
  80117e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801181:	83 ec 08             	sub    $0x8,%esp
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	6a 58                	push   $0x58
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	ff d0                	call   *%eax
  80118e:	83 c4 10             	add    $0x10,%esp
			break;
  801191:	e9 bc 00 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801196:	83 ec 08             	sub    $0x8,%esp
  801199:	ff 75 0c             	pushl  0xc(%ebp)
  80119c:	6a 30                	push   $0x30
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	ff d0                	call   *%eax
  8011a3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	6a 78                	push   $0x78
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	ff d0                	call   *%eax
  8011b3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b9:	83 c0 04             	add    $0x4,%eax
  8011bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8011bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c2:	83 e8 04             	sub    $0x4,%eax
  8011c5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011d1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011d8:	eb 1f                	jmp    8011f9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011da:	83 ec 08             	sub    $0x8,%esp
  8011dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011e3:	50                   	push   %eax
  8011e4:	e8 e7 fb ff ff       	call   800dd0 <getuint>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8011f2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011f9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8011fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	52                   	push   %edx
  801204:	ff 75 e4             	pushl  -0x1c(%ebp)
  801207:	50                   	push   %eax
  801208:	ff 75 f4             	pushl  -0xc(%ebp)
  80120b:	ff 75 f0             	pushl  -0x10(%ebp)
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	ff 75 08             	pushl  0x8(%ebp)
  801214:	e8 00 fb ff ff       	call   800d19 <printnum>
  801219:	83 c4 20             	add    $0x20,%esp
			break;
  80121c:	eb 34                	jmp    801252 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	53                   	push   %ebx
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	ff d0                	call   *%eax
  80122a:	83 c4 10             	add    $0x10,%esp
			break;
  80122d:	eb 23                	jmp    801252 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80122f:	83 ec 08             	sub    $0x8,%esp
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	6a 25                	push   $0x25
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	ff d0                	call   *%eax
  80123c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80123f:	ff 4d 10             	decl   0x10(%ebp)
  801242:	eb 03                	jmp    801247 <vprintfmt+0x3b1>
  801244:	ff 4d 10             	decl   0x10(%ebp)
  801247:	8b 45 10             	mov    0x10(%ebp),%eax
  80124a:	48                   	dec    %eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 25                	cmp    $0x25,%al
  80124f:	75 f3                	jne    801244 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801251:	90                   	nop
		}
	}
  801252:	e9 47 fc ff ff       	jmp    800e9e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801257:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801258:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801265:	8d 45 10             	lea    0x10(%ebp),%eax
  801268:	83 c0 04             	add    $0x4,%eax
  80126b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	ff 75 f4             	pushl  -0xc(%ebp)
  801274:	50                   	push   %eax
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 16 fc ff ff       	call   800e96 <vprintfmt>
  801280:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	8b 40 08             	mov    0x8(%eax),%eax
  80128f:	8d 50 01             	lea    0x1(%eax),%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 10                	mov    (%eax),%edx
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	8b 40 04             	mov    0x4(%eax),%eax
  8012a3:	39 c2                	cmp    %eax,%edx
  8012a5:	73 12                	jae    8012b9 <sprintputch+0x33>
		*b->buf++ = ch;
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b7:	88 10                	mov    %dl,(%eax)
}
  8012b9:	90                   	nop
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	01 d0                	add    %edx,%eax
  8012d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e1:	74 06                	je     8012e9 <vsnprintf+0x2d>
  8012e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e7:	7f 07                	jg     8012f0 <vsnprintf+0x34>
		return -E_INVAL;
  8012e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8012ee:	eb 20                	jmp    801310 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012f0:	ff 75 14             	pushl  0x14(%ebp)
  8012f3:	ff 75 10             	pushl  0x10(%ebp)
  8012f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012f9:	50                   	push   %eax
  8012fa:	68 86 12 80 00       	push   $0x801286
  8012ff:	e8 92 fb ff ff       	call   800e96 <vprintfmt>
  801304:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80130a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801318:	8d 45 10             	lea    0x10(%ebp),%eax
  80131b:	83 c0 04             	add    $0x4,%eax
  80131e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801321:	8b 45 10             	mov    0x10(%ebp),%eax
  801324:	ff 75 f4             	pushl  -0xc(%ebp)
  801327:	50                   	push   %eax
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	ff 75 08             	pushl  0x8(%ebp)
  80132e:	e8 89 ff ff ff       	call   8012bc <vsnprintf>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801339:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134b:	eb 06                	jmp    801353 <strlen+0x15>
		n++;
  80134d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801350:	ff 45 08             	incl   0x8(%ebp)
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 f1                	jne    80134d <strlen+0xf>
		n++;
	return n;
  80135c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801367:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136e:	eb 09                	jmp    801379 <strnlen+0x18>
		n++;
  801370:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 4d 0c             	decl   0xc(%ebp)
  801379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137d:	74 09                	je     801388 <strnlen+0x27>
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	75 e8                	jne    801370 <strnlen+0xf>
		n++;
	return n;
  801388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801399:	90                   	nop
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ac:	8a 12                	mov    (%edx),%dl
  8013ae:	88 10                	mov    %dl,(%eax)
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 e4                	jne    80139a <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ce:	eb 1f                	jmp    8013ef <strncpy+0x34>
		*dst++ = *src;
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8d 50 01             	lea    0x1(%eax),%edx
  8013d6:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dc:	8a 12                	mov    (%edx),%dl
  8013de:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	84 c0                	test   %al,%al
  8013e7:	74 03                	je     8013ec <strncpy+0x31>
			src++;
  8013e9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ec:	ff 45 fc             	incl   -0x4(%ebp)
  8013ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013f5:	72 d9                	jb     8013d0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801408:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140c:	74 30                	je     80143e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80140e:	eb 16                	jmp    801426 <strlcpy+0x2a>
			*dst++ = *src++;
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8d 50 01             	lea    0x1(%eax),%edx
  801416:	89 55 08             	mov    %edx,0x8(%ebp)
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80141f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801422:	8a 12                	mov    (%edx),%dl
  801424:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801426:	ff 4d 10             	decl   0x10(%ebp)
  801429:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142d:	74 09                	je     801438 <strlcpy+0x3c>
  80142f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	84 c0                	test   %al,%al
  801436:	75 d8                	jne    801410 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80143e:	8b 55 08             	mov    0x8(%ebp),%edx
  801441:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801444:	29 c2                	sub    %eax,%edx
  801446:	89 d0                	mov    %edx,%eax
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80144d:	eb 06                	jmp    801455 <strcmp+0xb>
		p++, q++;
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 0e                	je     80146c <strcmp+0x22>
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 10                	mov    (%eax),%dl
  801463:	8b 45 0c             	mov    0xc(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	38 c2                	cmp    %al,%dl
  80146a:	74 e3                	je     80144f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	0f b6 d0             	movzbl %al,%edx
  801474:	8b 45 0c             	mov    0xc(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	0f b6 c0             	movzbl %al,%eax
  80147c:	29 c2                	sub    %eax,%edx
  80147e:	89 d0                	mov    %edx,%eax
}
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801485:	eb 09                	jmp    801490 <strncmp+0xe>
		n--, p++, q++;
  801487:	ff 4d 10             	decl   0x10(%ebp)
  80148a:	ff 45 08             	incl   0x8(%ebp)
  80148d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801490:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801494:	74 17                	je     8014ad <strncmp+0x2b>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	84 c0                	test   %al,%al
  80149d:	74 0e                	je     8014ad <strncmp+0x2b>
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 10                	mov    (%eax),%dl
  8014a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	38 c2                	cmp    %al,%dl
  8014ab:	74 da                	je     801487 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b1:	75 07                	jne    8014ba <strncmp+0x38>
		return 0;
  8014b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b8:	eb 14                	jmp    8014ce <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	0f b6 d0             	movzbl %al,%edx
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	0f b6 c0             	movzbl %al,%eax
  8014ca:	29 c2                	sub    %eax,%edx
  8014cc:	89 d0                	mov    %edx,%eax
}
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    

008014d0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014dc:	eb 12                	jmp    8014f0 <strchr+0x20>
		if (*s == c)
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014e6:	75 05                	jne    8014ed <strchr+0x1d>
			return (char *) s;
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	eb 11                	jmp    8014fe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014ed:	ff 45 08             	incl   0x8(%ebp)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	75 e5                	jne    8014de <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80150c:	eb 0d                	jmp    80151b <strfind+0x1b>
		if (*s == c)
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	8a 00                	mov    (%eax),%al
  801513:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801516:	74 0e                	je     801526 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801518:	ff 45 08             	incl   0x8(%ebp)
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 ea                	jne    80150e <strfind+0xe>
  801524:	eb 01                	jmp    801527 <strfind+0x27>
		if (*s == c)
			break;
  801526:	90                   	nop
	return (char *) s;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801538:	8b 45 10             	mov    0x10(%ebp),%eax
  80153b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80153e:	eb 0e                	jmp    80154e <memset+0x22>
		*p++ = c;
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	8d 50 01             	lea    0x1(%eax),%edx
  801546:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801549:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80154e:	ff 4d f8             	decl   -0x8(%ebp)
  801551:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801555:	79 e9                	jns    801540 <memset+0x14>
		*p++ = c;

	return v;
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80156e:	eb 16                	jmp    801586 <memcpy+0x2a>
		*d++ = *s++;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80157f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801582:	8a 12                	mov    (%edx),%dl
  801584:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	8d 50 ff             	lea    -0x1(%eax),%edx
  80158c:	89 55 10             	mov    %edx,0x10(%ebp)
  80158f:	85 c0                	test   %eax,%eax
  801591:	75 dd                	jne    801570 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015b0:	73 50                	jae    801602 <memmove+0x6a>
  8015b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	01 d0                	add    %edx,%eax
  8015ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015bd:	76 43                	jbe    801602 <memmove+0x6a>
		s += n;
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015cb:	eb 10                	jmp    8015dd <memmove+0x45>
			*--d = *--s;
  8015cd:	ff 4d f8             	decl   -0x8(%ebp)
  8015d0:	ff 4d fc             	decl   -0x4(%ebp)
  8015d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d6:	8a 10                	mov    (%eax),%dl
  8015d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015db:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	75 e3                	jne    8015cd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015ea:	eb 23                	jmp    80160f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ef:	8d 50 01             	lea    0x1(%eax),%edx
  8015f2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015fb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015fe:	8a 12                	mov    (%edx),%dl
  801600:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801602:	8b 45 10             	mov    0x10(%ebp),%eax
  801605:	8d 50 ff             	lea    -0x1(%eax),%edx
  801608:	89 55 10             	mov    %edx,0x10(%ebp)
  80160b:	85 c0                	test   %eax,%eax
  80160d:	75 dd                	jne    8015ec <memmove+0x54>
			*d++ = *s++;

	return dst;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801626:	eb 2a                	jmp    801652 <memcmp+0x3e>
		if (*s1 != *s2)
  801628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162b:	8a 10                	mov    (%eax),%dl
  80162d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801630:	8a 00                	mov    (%eax),%al
  801632:	38 c2                	cmp    %al,%dl
  801634:	74 16                	je     80164c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	0f b6 d0             	movzbl %al,%edx
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	0f b6 c0             	movzbl %al,%eax
  801646:	29 c2                	sub    %eax,%edx
  801648:	89 d0                	mov    %edx,%eax
  80164a:	eb 18                	jmp    801664 <memcmp+0x50>
		s1++, s2++;
  80164c:	ff 45 fc             	incl   -0x4(%ebp)
  80164f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801652:	8b 45 10             	mov    0x10(%ebp),%eax
  801655:	8d 50 ff             	lea    -0x1(%eax),%edx
  801658:	89 55 10             	mov    %edx,0x10(%ebp)
  80165b:	85 c0                	test   %eax,%eax
  80165d:	75 c9                	jne    801628 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80166c:	8b 55 08             	mov    0x8(%ebp),%edx
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	01 d0                	add    %edx,%eax
  801674:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801677:	eb 15                	jmp    80168e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	8a 00                	mov    (%eax),%al
  80167e:	0f b6 d0             	movzbl %al,%edx
  801681:	8b 45 0c             	mov    0xc(%ebp),%eax
  801684:	0f b6 c0             	movzbl %al,%eax
  801687:	39 c2                	cmp    %eax,%edx
  801689:	74 0d                	je     801698 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801694:	72 e3                	jb     801679 <memfind+0x13>
  801696:	eb 01                	jmp    801699 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801698:	90                   	nop
	return (void *) s;
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016b2:	eb 03                	jmp    8016b7 <strtol+0x19>
		s++;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	3c 20                	cmp    $0x20,%al
  8016be:	74 f4                	je     8016b4 <strtol+0x16>
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	3c 09                	cmp    $0x9,%al
  8016c7:	74 eb                	je     8016b4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	3c 2b                	cmp    $0x2b,%al
  8016d0:	75 05                	jne    8016d7 <strtol+0x39>
		s++;
  8016d2:	ff 45 08             	incl   0x8(%ebp)
  8016d5:	eb 13                	jmp    8016ea <strtol+0x4c>
	else if (*s == '-')
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	3c 2d                	cmp    $0x2d,%al
  8016de:	75 0a                	jne    8016ea <strtol+0x4c>
		s++, neg = 1;
  8016e0:	ff 45 08             	incl   0x8(%ebp)
  8016e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ee:	74 06                	je     8016f6 <strtol+0x58>
  8016f0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016f4:	75 20                	jne    801716 <strtol+0x78>
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 30                	cmp    $0x30,%al
  8016fd:	75 17                	jne    801716 <strtol+0x78>
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	40                   	inc    %eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 78                	cmp    $0x78,%al
  801707:	75 0d                	jne    801716 <strtol+0x78>
		s += 2, base = 16;
  801709:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80170d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801714:	eb 28                	jmp    80173e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801716:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171a:	75 15                	jne    801731 <strtol+0x93>
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8a 00                	mov    (%eax),%al
  801721:	3c 30                	cmp    $0x30,%al
  801723:	75 0c                	jne    801731 <strtol+0x93>
		s++, base = 8;
  801725:	ff 45 08             	incl   0x8(%ebp)
  801728:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80172f:	eb 0d                	jmp    80173e <strtol+0xa0>
	else if (base == 0)
  801731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801735:	75 07                	jne    80173e <strtol+0xa0>
		base = 10;
  801737:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	3c 2f                	cmp    $0x2f,%al
  801745:	7e 19                	jle    801760 <strtol+0xc2>
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	3c 39                	cmp    $0x39,%al
  80174e:	7f 10                	jg     801760 <strtol+0xc2>
			dig = *s - '0';
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	0f be c0             	movsbl %al,%eax
  801758:	83 e8 30             	sub    $0x30,%eax
  80175b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80175e:	eb 42                	jmp    8017a2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	3c 60                	cmp    $0x60,%al
  801767:	7e 19                	jle    801782 <strtol+0xe4>
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8a 00                	mov    (%eax),%al
  80176e:	3c 7a                	cmp    $0x7a,%al
  801770:	7f 10                	jg     801782 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	0f be c0             	movsbl %al,%eax
  80177a:	83 e8 57             	sub    $0x57,%eax
  80177d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801780:	eb 20                	jmp    8017a2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	3c 40                	cmp    $0x40,%al
  801789:	7e 39                	jle    8017c4 <strtol+0x126>
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	3c 5a                	cmp    $0x5a,%al
  801792:	7f 30                	jg     8017c4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f be c0             	movsbl %al,%eax
  80179c:	83 e8 37             	sub    $0x37,%eax
  80179f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017a8:	7d 19                	jge    8017c3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017b4:	89 c2                	mov    %eax,%edx
  8017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b9:	01 d0                	add    %edx,%eax
  8017bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017be:	e9 7b ff ff ff       	jmp    80173e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017c3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017c8:	74 08                	je     8017d2 <strtol+0x134>
		*endptr = (char *) s;
  8017ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017d6:	74 07                	je     8017df <strtol+0x141>
  8017d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017db:	f7 d8                	neg    %eax
  8017dd:	eb 03                	jmp    8017e2 <strtol+0x144>
  8017df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <ltostr>:

void
ltostr(long value, char *str)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017fc:	79 13                	jns    801811 <ltostr+0x2d>
	{
		neg = 1;
  8017fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801805:	8b 45 0c             	mov    0xc(%ebp),%eax
  801808:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80180b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80180e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801819:	99                   	cltd   
  80181a:	f7 f9                	idiv   %ecx
  80181c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80181f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801822:	8d 50 01             	lea    0x1(%eax),%edx
  801825:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801828:	89 c2                	mov    %eax,%edx
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801832:	83 c2 30             	add    $0x30,%edx
  801835:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80183a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80183f:	f7 e9                	imul   %ecx
  801841:	c1 fa 02             	sar    $0x2,%edx
  801844:	89 c8                	mov    %ecx,%eax
  801846:	c1 f8 1f             	sar    $0x1f,%eax
  801849:	29 c2                	sub    %eax,%edx
  80184b:	89 d0                	mov    %edx,%eax
  80184d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801850:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801853:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801858:	f7 e9                	imul   %ecx
  80185a:	c1 fa 02             	sar    $0x2,%edx
  80185d:	89 c8                	mov    %ecx,%eax
  80185f:	c1 f8 1f             	sar    $0x1f,%eax
  801862:	29 c2                	sub    %eax,%edx
  801864:	89 d0                	mov    %edx,%eax
  801866:	c1 e0 02             	shl    $0x2,%eax
  801869:	01 d0                	add    %edx,%eax
  80186b:	01 c0                	add    %eax,%eax
  80186d:	29 c1                	sub    %eax,%ecx
  80186f:	89 ca                	mov    %ecx,%edx
  801871:	85 d2                	test   %edx,%edx
  801873:	75 9c                	jne    801811 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801875:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80187c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187f:	48                   	dec    %eax
  801880:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801883:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801887:	74 3d                	je     8018c6 <ltostr+0xe2>
		start = 1 ;
  801889:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801890:	eb 34                	jmp    8018c6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801895:	8b 45 0c             	mov    0xc(%ebp),%eax
  801898:	01 d0                	add    %edx,%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80189f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	01 c2                	add    %eax,%edx
  8018a7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	01 c8                	add    %ecx,%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b9:	01 c2                	add    %eax,%edx
  8018bb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018be:	88 02                	mov    %al,(%edx)
		start++ ;
  8018c0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018c3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018cc:	7c c4                	jl     801892 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018d9:	90                   	nop
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	e8 54 fa ff ff       	call   80133e <strlen>
  8018ea:	83 c4 04             	add    $0x4,%esp
  8018ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	e8 46 fa ff ff       	call   80133e <strlen>
  8018f8:	83 c4 04             	add    $0x4,%esp
  8018fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801905:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80190c:	eb 17                	jmp    801925 <strcconcat+0x49>
		final[s] = str1[s] ;
  80190e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 c2                	add    %eax,%edx
  801916:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	01 c8                	add    %ecx,%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801922:	ff 45 fc             	incl   -0x4(%ebp)
  801925:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801928:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80192b:	7c e1                	jl     80190e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80192d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801934:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80193b:	eb 1f                	jmp    80195c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801940:	8d 50 01             	lea    0x1(%eax),%edx
  801943:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801946:	89 c2                	mov    %eax,%edx
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	01 c2                	add    %eax,%edx
  80194d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	01 c8                	add    %ecx,%eax
  801955:	8a 00                	mov    (%eax),%al
  801957:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801959:	ff 45 f8             	incl   -0x8(%ebp)
  80195c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801962:	7c d9                	jl     80193d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 d0                	add    %edx,%eax
  80196c:	c6 00 00             	movb   $0x0,(%eax)
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80197e:	8b 45 14             	mov    0x14(%ebp),%eax
  801981:	8b 00                	mov    (%eax),%eax
  801983:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198a:	8b 45 10             	mov    0x10(%ebp),%eax
  80198d:	01 d0                	add    %edx,%eax
  80198f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801995:	eb 0c                	jmp    8019a3 <strsplit+0x31>
			*string++ = 0;
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	8d 50 01             	lea    0x1(%eax),%edx
  80199d:	89 55 08             	mov    %edx,0x8(%ebp)
  8019a0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	8a 00                	mov    (%eax),%al
  8019a8:	84 c0                	test   %al,%al
  8019aa:	74 18                	je     8019c4 <strsplit+0x52>
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	0f be c0             	movsbl %al,%eax
  8019b4:	50                   	push   %eax
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	e8 13 fb ff ff       	call   8014d0 <strchr>
  8019bd:	83 c4 08             	add    $0x8,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	75 d3                	jne    801997 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	8a 00                	mov    (%eax),%al
  8019c9:	84 c0                	test   %al,%al
  8019cb:	74 5a                	je     801a27 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	83 f8 0f             	cmp    $0xf,%eax
  8019d5:	75 07                	jne    8019de <strsplit+0x6c>
		{
			return 0;
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dc:	eb 66                	jmp    801a44 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019de:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e1:	8b 00                	mov    (%eax),%eax
  8019e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8019e6:	8b 55 14             	mov    0x14(%ebp),%edx
  8019e9:	89 0a                	mov    %ecx,(%edx)
  8019eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	01 c2                	add    %eax,%edx
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019fc:	eb 03                	jmp    801a01 <strsplit+0x8f>
			string++;
  8019fe:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	84 c0                	test   %al,%al
  801a08:	74 8b                	je     801995 <strsplit+0x23>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	0f be c0             	movsbl %al,%eax
  801a12:	50                   	push   %eax
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	e8 b5 fa ff ff       	call   8014d0 <strchr>
  801a1b:	83 c4 08             	add    $0x8,%esp
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	74 dc                	je     8019fe <strsplit+0x8c>
			string++;
	}
  801a22:	e9 6e ff ff ff       	jmp    801995 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a27:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a28:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a34:	8b 45 10             	mov    0x10(%ebp),%eax
  801a37:	01 d0                	add    %edx,%eax
  801a39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a3f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801a4c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801a53:	8b 55 08             	mov    0x8(%ebp),%edx
  801a56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801a59:	01 d0                	add    %edx,%eax
  801a5b:	48                   	dec    %eax
  801a5c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801a5f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	f7 75 ac             	divl   -0x54(%ebp)
  801a6a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801a6d:	29 d0                	sub    %edx,%eax
  801a6f:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801a79:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801a80:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801a87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a8e:	eb 3f                	jmp    801acf <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a93:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	50                   	push   %eax
  801a9e:	ff 75 e8             	pushl  -0x18(%ebp)
  801aa1:	68 90 30 80 00       	push   $0x803090
  801aa6:	e8 11 f2 ff ff       	call   800cbc <cprintf>
  801aab:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801aae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab1:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	50                   	push   %eax
  801abc:	ff 75 e8             	pushl  -0x18(%ebp)
  801abf:	68 a5 30 80 00       	push   $0x8030a5
  801ac4:	e8 f3 f1 ff ff       	call   800cbc <cprintf>
  801ac9:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801acc:	ff 45 e8             	incl   -0x18(%ebp)
  801acf:	a1 28 40 80 00       	mov    0x804028,%eax
  801ad4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801ad7:	7c b7                	jl     801a90 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801ad9:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801ae0:	e9 35 01 00 00       	jmp    801c1a <malloc+0x1d4>
		int flag0=1;
  801ae5:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801aec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801af2:	eb 5e                	jmp    801b52 <malloc+0x10c>
			for(int k=0;k<count;k++){
  801af4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801afb:	eb 35                	jmp    801b32 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801afd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b00:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0a:	39 c2                	cmp    %eax,%edx
  801b0c:	77 21                	ja     801b2f <malloc+0xe9>
  801b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b11:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b1b:	39 c2                	cmp    %eax,%edx
  801b1d:	76 10                	jbe    801b2f <malloc+0xe9>
					ni=PAGE_SIZE;
  801b1f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  801b26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801b2d:	eb 0d                	jmp    801b3c <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801b2f:	ff 45 d8             	incl   -0x28(%ebp)
  801b32:	a1 28 40 80 00       	mov    0x804028,%eax
  801b37:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b3a:	7c c1                	jl     801afd <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801b3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b40:	74 09                	je     801b4b <malloc+0x105>
				flag0=0;
  801b42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801b49:	eb 16                	jmp    801b61 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801b4b:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801b52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c2                	add    %eax,%edx
  801b5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b5d:	39 c2                	cmp    %eax,%edx
  801b5f:	77 93                	ja     801af4 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801b61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b65:	0f 84 a2 00 00 00    	je     801c0d <malloc+0x1c7>

			int f=1;
  801b6b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801b72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b75:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801b78:	89 c8                	mov    %ecx,%eax
  801b7a:	01 c0                	add    %eax,%eax
  801b7c:	01 c8                	add    %ecx,%eax
  801b7e:	c1 e0 02             	shl    $0x2,%eax
  801b81:	05 20 41 80 00       	add    $0x804120,%eax
  801b86:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801b88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b94:	89 d0                	mov    %edx,%eax
  801b96:	01 c0                	add    %eax,%eax
  801b98:	01 d0                	add    %edx,%eax
  801b9a:	c1 e0 02             	shl    $0x2,%eax
  801b9d:	05 24 41 80 00       	add    $0x804124,%eax
  801ba2:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	01 c0                	add    %eax,%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c1 e0 02             	shl    $0x2,%eax
  801bb0:	05 28 41 80 00       	add    $0x804128,%eax
  801bb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801bbb:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801bbe:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801bc5:	eb 36                	jmp    801bfd <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  801bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	01 c2                	add    %eax,%edx
  801bcf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bd2:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801bd9:	39 c2                	cmp    %eax,%edx
  801bdb:	73 1d                	jae    801bfa <malloc+0x1b4>
					ni=arr_add[l].end-i;
  801bdd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801be0:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801be7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bea:	29 c2                	sub    %eax,%edx
  801bec:	89 d0                	mov    %edx,%eax
  801bee:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801bf1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801bf8:	eb 0d                	jmp    801c07 <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801bfa:	ff 45 d0             	incl   -0x30(%ebp)
  801bfd:	a1 28 40 80 00       	mov    0x804028,%eax
  801c02:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801c05:	7c c0                	jl     801bc7 <malloc+0x181>
					break;

				}
			}

			if(f){
  801c07:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801c0b:	75 1d                	jne    801c2a <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  801c0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c17:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801c1a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c22:	0f 8c bd fe ff ff    	jl     801ae5 <malloc+0x9f>
  801c28:	eb 01                	jmp    801c2b <malloc+0x1e5>

				}
			}

			if(f){
				break;
  801c2a:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c2f:	75 7a                	jne    801cab <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801c31:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	01 d0                	add    %edx,%eax
  801c3c:	48                   	dec    %eax
  801c3d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801c42:	7c 0a                	jl     801c4e <malloc+0x208>
			return NULL;
  801c44:	b8 00 00 00 00       	mov    $0x0,%eax
  801c49:	e9 a4 02 00 00       	jmp    801ef2 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  801c4e:	a1 04 40 80 00       	mov    0x804004,%eax
  801c53:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801c56:	a1 28 40 80 00       	mov    0x804028,%eax
  801c5b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801c5e:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801c65:	83 ec 08             	sub    $0x8,%esp
  801c68:	ff 75 08             	pushl  0x8(%ebp)
  801c6b:	ff 75 a4             	pushl  -0x5c(%ebp)
  801c6e:	e8 04 06 00 00       	call   802277 <sys_allocateMem>
  801c73:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801c76:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	01 d0                	add    %edx,%eax
  801c81:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801c86:	a1 28 40 80 00       	mov    0x804028,%eax
  801c8b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c91:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801c98:	a1 28 40 80 00       	mov    0x804028,%eax
  801c9d:	40                   	inc    %eax
  801c9e:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801ca3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ca6:	e9 47 02 00 00       	jmp    801ef2 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  801cab:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801cb2:	e9 ac 00 00 00       	jmp    801d63 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801cb7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801cba:	89 d0                	mov    %edx,%eax
  801cbc:	01 c0                	add    %eax,%eax
  801cbe:	01 d0                	add    %edx,%eax
  801cc0:	c1 e0 02             	shl    $0x2,%eax
  801cc3:	05 24 41 80 00       	add    $0x804124,%eax
  801cc8:	8b 00                	mov    (%eax),%eax
  801cca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801ccd:	eb 7e                	jmp    801d4d <malloc+0x307>
			int flag=0;
  801ccf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801cd6:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801cdd:	eb 57                	jmp    801d36 <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801cdf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ce2:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801ce9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801cec:	39 c2                	cmp    %eax,%edx
  801cee:	77 1a                	ja     801d0a <malloc+0x2c4>
  801cf0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cf3:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801cfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801cfd:	39 c2                	cmp    %eax,%edx
  801cff:	76 09                	jbe    801d0a <malloc+0x2c4>
								flag=1;
  801d01:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801d08:	eb 36                	jmp    801d40 <malloc+0x2fa>
			arr[i].space++;
  801d0a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801d0d:	89 d0                	mov    %edx,%eax
  801d0f:	01 c0                	add    %eax,%eax
  801d11:	01 d0                	add    %edx,%eax
  801d13:	c1 e0 02             	shl    $0x2,%eax
  801d16:	05 28 41 80 00       	add    $0x804128,%eax
  801d1b:	8b 00                	mov    (%eax),%eax
  801d1d:	8d 48 01             	lea    0x1(%eax),%ecx
  801d20:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	c1 e0 02             	shl    $0x2,%eax
  801d2c:	05 28 41 80 00       	add    $0x804128,%eax
  801d31:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801d33:	ff 45 c0             	incl   -0x40(%ebp)
  801d36:	a1 28 40 80 00       	mov    0x804028,%eax
  801d3b:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801d3e:	7c 9f                	jl     801cdf <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801d40:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801d44:	75 19                	jne    801d5f <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801d46:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801d4d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801d50:	a1 04 40 80 00       	mov    0x804004,%eax
  801d55:	39 c2                	cmp    %eax,%edx
  801d57:	0f 82 72 ff ff ff    	jb     801ccf <malloc+0x289>
  801d5d:	eb 01                	jmp    801d60 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801d5f:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801d60:	ff 45 cc             	incl   -0x34(%ebp)
  801d63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d66:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d69:	0f 8c 48 ff ff ff    	jl     801cb7 <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801d6f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801d76:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801d7d:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801d84:	eb 37                	jmp    801dbd <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801d86:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	01 c0                	add    %eax,%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	c1 e0 02             	shl    $0x2,%eax
  801d92:	05 28 41 80 00       	add    $0x804128,%eax
  801d97:	8b 00                	mov    (%eax),%eax
  801d99:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801d9c:	7d 1c                	jge    801dba <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801d9e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801da1:	89 d0                	mov    %edx,%eax
  801da3:	01 c0                	add    %eax,%eax
  801da5:	01 d0                	add    %edx,%eax
  801da7:	c1 e0 02             	shl    $0x2,%eax
  801daa:	05 28 41 80 00       	add    $0x804128,%eax
  801daf:	8b 00                	mov    (%eax),%eax
  801db1:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801db4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801db7:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801dba:	ff 45 b4             	incl   -0x4c(%ebp)
  801dbd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801dc0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801dc3:	7c c1                	jl     801d86 <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801dc5:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801dcb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801dce:	89 c8                	mov    %ecx,%eax
  801dd0:	01 c0                	add    %eax,%eax
  801dd2:	01 c8                	add    %ecx,%eax
  801dd4:	c1 e0 02             	shl    $0x2,%eax
  801dd7:	05 20 41 80 00       	add    $0x804120,%eax
  801ddc:	8b 00                	mov    (%eax),%eax
  801dde:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801de5:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801deb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801dee:	89 c8                	mov    %ecx,%eax
  801df0:	01 c0                	add    %eax,%eax
  801df2:	01 c8                	add    %ecx,%eax
  801df4:	c1 e0 02             	shl    $0x2,%eax
  801df7:	05 24 41 80 00       	add    $0x804124,%eax
  801dfc:	8b 00                	mov    (%eax),%eax
  801dfe:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801e05:	a1 28 40 80 00       	mov    0x804028,%eax
  801e0a:	40                   	inc    %eax
  801e0b:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  801e10:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e13:	89 d0                	mov    %edx,%eax
  801e15:	01 c0                	add    %eax,%eax
  801e17:	01 d0                	add    %edx,%eax
  801e19:	c1 e0 02             	shl    $0x2,%eax
  801e1c:	05 20 41 80 00       	add    $0x804120,%eax
  801e21:	8b 00                	mov    (%eax),%eax
  801e23:	83 ec 08             	sub    $0x8,%esp
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	50                   	push   %eax
  801e2a:	e8 48 04 00 00       	call   802277 <sys_allocateMem>
  801e2f:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801e32:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801e39:	eb 78                	jmp    801eb3 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801e3b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e3e:	89 d0                	mov    %edx,%eax
  801e40:	01 c0                	add    %eax,%eax
  801e42:	01 d0                	add    %edx,%eax
  801e44:	c1 e0 02             	shl    $0x2,%eax
  801e47:	05 20 41 80 00       	add    $0x804120,%eax
  801e4c:	8b 00                	mov    (%eax),%eax
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	50                   	push   %eax
  801e52:	ff 75 b0             	pushl  -0x50(%ebp)
  801e55:	68 90 30 80 00       	push   $0x803090
  801e5a:	e8 5d ee ff ff       	call   800cbc <cprintf>
  801e5f:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801e62:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e65:	89 d0                	mov    %edx,%eax
  801e67:	01 c0                	add    %eax,%eax
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	c1 e0 02             	shl    $0x2,%eax
  801e6e:	05 24 41 80 00       	add    $0x804124,%eax
  801e73:	8b 00                	mov    (%eax),%eax
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	50                   	push   %eax
  801e79:	ff 75 b0             	pushl  -0x50(%ebp)
  801e7c:	68 a5 30 80 00       	push   $0x8030a5
  801e81:	e8 36 ee ff ff       	call   800cbc <cprintf>
  801e86:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801e89:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e8c:	89 d0                	mov    %edx,%eax
  801e8e:	01 c0                	add    %eax,%eax
  801e90:	01 d0                	add    %edx,%eax
  801e92:	c1 e0 02             	shl    $0x2,%eax
  801e95:	05 28 41 80 00       	add    $0x804128,%eax
  801e9a:	8b 00                	mov    (%eax),%eax
  801e9c:	83 ec 04             	sub    $0x4,%esp
  801e9f:	50                   	push   %eax
  801ea0:	ff 75 b0             	pushl  -0x50(%ebp)
  801ea3:	68 b8 30 80 00       	push   $0x8030b8
  801ea8:	e8 0f ee ff ff       	call   800cbc <cprintf>
  801ead:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801eb0:	ff 45 b0             	incl   -0x50(%ebp)
  801eb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801eb6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801eb9:	7c 80                	jl     801e3b <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801ebb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801ebe:	89 d0                	mov    %edx,%eax
  801ec0:	01 c0                	add    %eax,%eax
  801ec2:	01 d0                	add    %edx,%eax
  801ec4:	c1 e0 02             	shl    $0x2,%eax
  801ec7:	05 20 41 80 00       	add    $0x804120,%eax
  801ecc:	8b 00                	mov    (%eax),%eax
  801ece:	83 ec 08             	sub    $0x8,%esp
  801ed1:	50                   	push   %eax
  801ed2:	68 cc 30 80 00       	push   $0x8030cc
  801ed7:	e8 e0 ed ff ff       	call   800cbc <cprintf>
  801edc:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801edf:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801ee2:	89 d0                	mov    %edx,%eax
  801ee4:	01 c0                	add    %eax,%eax
  801ee6:	01 d0                	add    %edx,%eax
  801ee8:	c1 e0 02             	shl    $0x2,%eax
  801eeb:	05 20 41 80 00       	add    $0x804120,%eax
  801ef0:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801f00:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f07:	eb 4b                	jmp    801f54 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0c:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f13:	89 c2                	mov    %eax,%edx
  801f15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f18:	39 c2                	cmp    %eax,%edx
  801f1a:	7f 35                	jg     801f51 <free+0x5d>
  801f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1f:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801f26:	89 c2                	mov    %eax,%edx
  801f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f2b:	39 c2                	cmp    %eax,%edx
  801f2d:	7e 22                	jle    801f51 <free+0x5d>
				start=arr_add[i].start;
  801f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f32:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801f4f:	eb 0d                	jmp    801f5e <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801f51:	ff 45 ec             	incl   -0x14(%ebp)
  801f54:	a1 28 40 80 00       	mov    0x804028,%eax
  801f59:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f5c:	7c ab                	jl     801f09 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f61:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f72:	29 c2                	sub    %eax,%edx
  801f74:	89 d0                	mov    %edx,%eax
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	50                   	push   %eax
  801f7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7d:	e8 d9 02 00 00       	call   80225b <sys_freeMem>
  801f82:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f8b:	eb 2d                	jmp    801fba <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f90:	40                   	inc    %eax
  801f91:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9b:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa5:	40                   	inc    %eax
  801fa6:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb0:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801fb7:	ff 45 e8             	incl   -0x18(%ebp)
  801fba:	a1 28 40 80 00       	mov    0x804028,%eax
  801fbf:	48                   	dec    %eax
  801fc0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fc3:	7f c8                	jg     801f8d <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801fc5:	a1 28 40 80 00       	mov    0x804028,%eax
  801fca:	48                   	dec    %eax
  801fcb:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801fd0:	90                   	nop
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 18             	sub    $0x18,%esp
  801fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdc:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	68 e8 30 80 00       	push   $0x8030e8
  801fe7:	68 18 01 00 00       	push   $0x118
  801fec:	68 0b 31 80 00       	push   $0x80310b
  801ff1:	e8 24 ea ff ff       	call   800a1a <_panic>

00801ff6 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ffc:	83 ec 04             	sub    $0x4,%esp
  801fff:	68 e8 30 80 00       	push   $0x8030e8
  802004:	68 1e 01 00 00       	push   $0x11e
  802009:	68 0b 31 80 00       	push   $0x80310b
  80200e:	e8 07 ea ff ff       	call   800a1a <_panic>

00802013 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	68 e8 30 80 00       	push   $0x8030e8
  802021:	68 24 01 00 00       	push   $0x124
  802026:	68 0b 31 80 00       	push   $0x80310b
  80202b:	e8 ea e9 ff ff       	call   800a1a <_panic>

00802030 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	68 e8 30 80 00       	push   $0x8030e8
  80203e:	68 29 01 00 00       	push   $0x129
  802043:	68 0b 31 80 00       	push   $0x80310b
  802048:	e8 cd e9 ff ff       	call   800a1a <_panic>

0080204d <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	68 e8 30 80 00       	push   $0x8030e8
  80205b:	68 2f 01 00 00       	push   $0x12f
  802060:	68 0b 31 80 00       	push   $0x80310b
  802065:	e8 b0 e9 ff ff       	call   800a1a <_panic>

0080206a <shrink>:
}
void shrink(uint32 newSize)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	68 e8 30 80 00       	push   $0x8030e8
  802078:	68 33 01 00 00       	push   $0x133
  80207d:	68 0b 31 80 00       	push   $0x80310b
  802082:	e8 93 e9 ff ff       	call   800a1a <_panic>

00802087 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	68 e8 30 80 00       	push   $0x8030e8
  802095:	68 38 01 00 00       	push   $0x138
  80209a:	68 0b 31 80 00       	push   $0x80310b
  80209f:	e8 76 e9 ff ff       	call   800a1a <_panic>

008020a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	57                   	push   %edi
  8020a8:	56                   	push   %esi
  8020a9:	53                   	push   %ebx
  8020aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020bf:	cd 30                	int    $0x30
  8020c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020c7:	83 c4 10             	add    $0x10,%esp
  8020ca:	5b                   	pop    %ebx
  8020cb:	5e                   	pop    %esi
  8020cc:	5f                   	pop    %edi
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    

008020cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	52                   	push   %edx
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	50                   	push   %eax
  8020eb:	6a 00                	push   $0x0
  8020ed:	e8 b2 ff ff ff       	call   8020a4 <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
}
  8020f5:	90                   	nop
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 01                	push   $0x1
  802107:	e8 98 ff ff ff       	call   8020a4 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	50                   	push   %eax
  802120:	6a 05                	push   $0x5
  802122:	e8 7d ff ff ff       	call   8020a4 <syscall>
  802127:	83 c4 18             	add    $0x18,%esp
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 02                	push   $0x2
  80213b:	e8 64 ff ff ff       	call   8020a4 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 03                	push   $0x3
  802154:	e8 4b ff ff ff       	call   8020a4 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 04                	push   $0x4
  80216d:	e8 32 ff ff ff       	call   8020a4 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_env_exit>:


void sys_env_exit(void)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 06                	push   $0x6
  802186:	e8 19 ff ff ff       	call   8020a4 <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
}
  80218e:	90                   	nop
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802194:	8b 55 0c             	mov    0xc(%ebp),%edx
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	52                   	push   %edx
  8021a1:	50                   	push   %eax
  8021a2:	6a 07                	push   $0x7
  8021a4:	e8 fb fe ff ff       	call   8020a4 <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	56                   	push   %esi
  8021b2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8021b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	51                   	push   %ecx
  8021c5:	52                   	push   %edx
  8021c6:	50                   	push   %eax
  8021c7:	6a 08                	push   $0x8
  8021c9:	e8 d6 fe ff ff       	call   8020a4 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
}
  8021d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d4:	5b                   	pop    %ebx
  8021d5:	5e                   	pop    %esi
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    

008021d8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	52                   	push   %edx
  8021e8:	50                   	push   %eax
  8021e9:	6a 09                	push   $0x9
  8021eb:	e8 b4 fe ff ff       	call   8020a4 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	ff 75 0c             	pushl  0xc(%ebp)
  802201:	ff 75 08             	pushl  0x8(%ebp)
  802204:	6a 0a                	push   $0xa
  802206:	e8 99 fe ff ff       	call   8020a4 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 0b                	push   $0xb
  80221f:	e8 80 fe ff ff       	call   8020a4 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 0c                	push   $0xc
  802238:	e8 67 fe ff ff       	call   8020a4 <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 0d                	push   $0xd
  802251:	e8 4e fe ff ff       	call   8020a4 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	ff 75 0c             	pushl  0xc(%ebp)
  802267:	ff 75 08             	pushl  0x8(%ebp)
  80226a:	6a 11                	push   $0x11
  80226c:	e8 33 fe ff ff       	call   8020a4 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
	return;
  802274:	90                   	nop
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	ff 75 08             	pushl  0x8(%ebp)
  802286:	6a 12                	push   $0x12
  802288:	e8 17 fe ff ff       	call   8020a4 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
	return ;
  802290:	90                   	nop
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 0e                	push   $0xe
  8022a2:	e8 fd fd ff ff       	call   8020a4 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	ff 75 08             	pushl  0x8(%ebp)
  8022ba:	6a 0f                	push   $0xf
  8022bc:	e8 e3 fd ff ff       	call   8020a4 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 10                	push   $0x10
  8022d5:	e8 ca fd ff ff       	call   8020a4 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	90                   	nop
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 14                	push   $0x14
  8022ef:	e8 b0 fd ff ff       	call   8020a4 <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	90                   	nop
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 15                	push   $0x15
  802309:	e8 96 fd ff ff       	call   8020a4 <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
}
  802311:	90                   	nop
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <sys_cputc>:


void
sys_cputc(const char c)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802320:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	50                   	push   %eax
  80232d:	6a 16                	push   $0x16
  80232f:	e8 70 fd ff ff       	call   8020a4 <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	90                   	nop
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 17                	push   $0x17
  802349:	e8 56 fd ff ff       	call   8020a4 <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
}
  802351:	90                   	nop
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	ff 75 0c             	pushl  0xc(%ebp)
  802363:	50                   	push   %eax
  802364:	6a 18                	push   $0x18
  802366:	e8 39 fd ff ff       	call   8020a4 <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802373:	8b 55 0c             	mov    0xc(%ebp),%edx
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	52                   	push   %edx
  802380:	50                   	push   %eax
  802381:	6a 1b                	push   $0x1b
  802383:	e8 1c fd ff ff       	call   8020a4 <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
}
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802390:	8b 55 0c             	mov    0xc(%ebp),%edx
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	52                   	push   %edx
  80239d:	50                   	push   %eax
  80239e:	6a 19                	push   $0x19
  8023a0:	e8 ff fc ff ff       	call   8020a4 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	90                   	nop
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	52                   	push   %edx
  8023bb:	50                   	push   %eax
  8023bc:	6a 1a                	push   $0x1a
  8023be:	e8 e1 fc ff ff       	call   8020a4 <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	90                   	nop
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 04             	sub    $0x4,%esp
  8023cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	6a 00                	push   $0x0
  8023e1:	51                   	push   %ecx
  8023e2:	52                   	push   %edx
  8023e3:	ff 75 0c             	pushl  0xc(%ebp)
  8023e6:	50                   	push   %eax
  8023e7:	6a 1c                	push   $0x1c
  8023e9:	e8 b6 fc ff ff       	call   8020a4 <syscall>
  8023ee:	83 c4 18             	add    $0x18,%esp
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	52                   	push   %edx
  802403:	50                   	push   %eax
  802404:	6a 1d                	push   $0x1d
  802406:	e8 99 fc ff ff       	call   8020a4 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802413:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802416:	8b 55 0c             	mov    0xc(%ebp),%edx
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	51                   	push   %ecx
  802421:	52                   	push   %edx
  802422:	50                   	push   %eax
  802423:	6a 1e                	push   $0x1e
  802425:	e8 7a fc ff ff       	call   8020a4 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802432:	8b 55 0c             	mov    0xc(%ebp),%edx
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	52                   	push   %edx
  80243f:	50                   	push   %eax
  802440:	6a 1f                	push   $0x1f
  802442:	e8 5d fc ff ff       	call   8020a4 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 20                	push   $0x20
  80245b:	e8 44 fc ff ff       	call   8020a4 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	6a 00                	push   $0x0
  80246d:	ff 75 14             	pushl  0x14(%ebp)
  802470:	ff 75 10             	pushl  0x10(%ebp)
  802473:	ff 75 0c             	pushl  0xc(%ebp)
  802476:	50                   	push   %eax
  802477:	6a 21                	push   $0x21
  802479:	e8 26 fc ff ff       	call   8020a4 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	50                   	push   %eax
  802492:	6a 22                	push   $0x22
  802494:	e8 0b fc ff ff       	call   8020a4 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	90                   	nop
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	50                   	push   %eax
  8024ae:	6a 23                	push   $0x23
  8024b0:	e8 ef fb ff ff       	call   8020a4 <syscall>
  8024b5:	83 c4 18             	add    $0x18,%esp
}
  8024b8:	90                   	nop
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024c1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024c4:	8d 50 04             	lea    0x4(%eax),%edx
  8024c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	52                   	push   %edx
  8024d1:	50                   	push   %eax
  8024d2:	6a 24                	push   $0x24
  8024d4:	e8 cb fb ff ff       	call   8020a4 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
	return result;
  8024dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024e5:	89 01                	mov    %eax,(%ecx)
  8024e7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	c9                   	leave  
  8024ee:	c2 04 00             	ret    $0x4

008024f1 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	ff 75 10             	pushl  0x10(%ebp)
  8024fb:	ff 75 0c             	pushl  0xc(%ebp)
  8024fe:	ff 75 08             	pushl  0x8(%ebp)
  802501:	6a 13                	push   $0x13
  802503:	e8 9c fb ff ff       	call   8020a4 <syscall>
  802508:	83 c4 18             	add    $0x18,%esp
	return ;
  80250b:	90                   	nop
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <sys_rcr2>:
uint32 sys_rcr2()
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 25                	push   $0x25
  80251d:	e8 82 fb ff ff       	call   8020a4 <syscall>
  802522:	83 c4 18             	add    $0x18,%esp
}
  802525:	c9                   	leave  
  802526:	c3                   	ret    

00802527 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 04             	sub    $0x4,%esp
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802533:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	50                   	push   %eax
  802540:	6a 26                	push   $0x26
  802542:	e8 5d fb ff ff       	call   8020a4 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
	return ;
  80254a:	90                   	nop
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <rsttst>:
void rsttst()
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 28                	push   $0x28
  80255c:	e8 43 fb ff ff       	call   8020a4 <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
	return ;
  802564:	90                   	nop
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 04             	sub    $0x4,%esp
  80256d:	8b 45 14             	mov    0x14(%ebp),%eax
  802570:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802573:	8b 55 18             	mov    0x18(%ebp),%edx
  802576:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80257a:	52                   	push   %edx
  80257b:	50                   	push   %eax
  80257c:	ff 75 10             	pushl  0x10(%ebp)
  80257f:	ff 75 0c             	pushl  0xc(%ebp)
  802582:	ff 75 08             	pushl  0x8(%ebp)
  802585:	6a 27                	push   $0x27
  802587:	e8 18 fb ff ff       	call   8020a4 <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp
	return ;
  80258f:	90                   	nop
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <chktst>:
void chktst(uint32 n)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	6a 29                	push   $0x29
  8025a2:	e8 fd fa ff ff       	call   8020a4 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025aa:	90                   	nop
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <inctst>:

void inctst()
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 2a                	push   $0x2a
  8025bc:	e8 e3 fa ff ff       	call   8020a4 <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c4:	90                   	nop
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <gettst>:
uint32 gettst()
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 2b                	push   $0x2b
  8025d6:	e8 c9 fa ff ff       	call   8020a4 <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 2c                	push   $0x2c
  8025f2:	e8 ad fa ff ff       	call   8020a4 <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
  8025fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025fd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802601:	75 07                	jne    80260a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802603:	b8 01 00 00 00       	mov    $0x1,%eax
  802608:	eb 05                	jmp    80260f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 2c                	push   $0x2c
  802623:	e8 7c fa ff ff       	call   8020a4 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
  80262b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80262e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802632:	75 07                	jne    80263b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802634:	b8 01 00 00 00       	mov    $0x1,%eax
  802639:	eb 05                	jmp    802640 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 2c                	push   $0x2c
  802654:	e8 4b fa ff ff       	call   8020a4 <syscall>
  802659:	83 c4 18             	add    $0x18,%esp
  80265c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80265f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802663:	75 07                	jne    80266c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802665:	b8 01 00 00 00       	mov    $0x1,%eax
  80266a:	eb 05                	jmp    802671 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 2c                	push   $0x2c
  802685:	e8 1a fa ff ff       	call   8020a4 <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
  80268d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802690:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802694:	75 07                	jne    80269d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802696:	b8 01 00 00 00       	mov    $0x1,%eax
  80269b:	eb 05                	jmp    8026a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	ff 75 08             	pushl  0x8(%ebp)
  8026b2:	6a 2d                	push   $0x2d
  8026b4:	e8 eb f9 ff ff       	call   8020a4 <syscall>
  8026b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026bc:	90                   	nop
}
  8026bd:	c9                   	leave  
  8026be:	c3                   	ret    

008026bf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
  8026c2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cf:	6a 00                	push   $0x0
  8026d1:	53                   	push   %ebx
  8026d2:	51                   	push   %ecx
  8026d3:	52                   	push   %edx
  8026d4:	50                   	push   %eax
  8026d5:	6a 2e                	push   $0x2e
  8026d7:	e8 c8 f9 ff ff       	call   8020a4 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	52                   	push   %edx
  8026f4:	50                   	push   %eax
  8026f5:	6a 2f                	push   $0x2f
  8026f7:	e8 a8 f9 ff ff       	call   8020a4 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    
  802701:	66 90                	xchg   %ax,%ax
  802703:	90                   	nop

00802704 <__udivdi3>:
  802704:	55                   	push   %ebp
  802705:	57                   	push   %edi
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	83 ec 1c             	sub    $0x1c,%esp
  80270b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80270f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802717:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80271b:	89 ca                	mov    %ecx,%edx
  80271d:	89 f8                	mov    %edi,%eax
  80271f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802723:	85 f6                	test   %esi,%esi
  802725:	75 2d                	jne    802754 <__udivdi3+0x50>
  802727:	39 cf                	cmp    %ecx,%edi
  802729:	77 65                	ja     802790 <__udivdi3+0x8c>
  80272b:	89 fd                	mov    %edi,%ebp
  80272d:	85 ff                	test   %edi,%edi
  80272f:	75 0b                	jne    80273c <__udivdi3+0x38>
  802731:	b8 01 00 00 00       	mov    $0x1,%eax
  802736:	31 d2                	xor    %edx,%edx
  802738:	f7 f7                	div    %edi
  80273a:	89 c5                	mov    %eax,%ebp
  80273c:	31 d2                	xor    %edx,%edx
  80273e:	89 c8                	mov    %ecx,%eax
  802740:	f7 f5                	div    %ebp
  802742:	89 c1                	mov    %eax,%ecx
  802744:	89 d8                	mov    %ebx,%eax
  802746:	f7 f5                	div    %ebp
  802748:	89 cf                	mov    %ecx,%edi
  80274a:	89 fa                	mov    %edi,%edx
  80274c:	83 c4 1c             	add    $0x1c,%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    
  802754:	39 ce                	cmp    %ecx,%esi
  802756:	77 28                	ja     802780 <__udivdi3+0x7c>
  802758:	0f bd fe             	bsr    %esi,%edi
  80275b:	83 f7 1f             	xor    $0x1f,%edi
  80275e:	75 40                	jne    8027a0 <__udivdi3+0x9c>
  802760:	39 ce                	cmp    %ecx,%esi
  802762:	72 0a                	jb     80276e <__udivdi3+0x6a>
  802764:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802768:	0f 87 9e 00 00 00    	ja     80280c <__udivdi3+0x108>
  80276e:	b8 01 00 00 00       	mov    $0x1,%eax
  802773:	89 fa                	mov    %edi,%edx
  802775:	83 c4 1c             	add    $0x1c,%esp
  802778:	5b                   	pop    %ebx
  802779:	5e                   	pop    %esi
  80277a:	5f                   	pop    %edi
  80277b:	5d                   	pop    %ebp
  80277c:	c3                   	ret    
  80277d:	8d 76 00             	lea    0x0(%esi),%esi
  802780:	31 ff                	xor    %edi,%edi
  802782:	31 c0                	xor    %eax,%eax
  802784:	89 fa                	mov    %edi,%edx
  802786:	83 c4 1c             	add    $0x1c,%esp
  802789:	5b                   	pop    %ebx
  80278a:	5e                   	pop    %esi
  80278b:	5f                   	pop    %edi
  80278c:	5d                   	pop    %ebp
  80278d:	c3                   	ret    
  80278e:	66 90                	xchg   %ax,%ax
  802790:	89 d8                	mov    %ebx,%eax
  802792:	f7 f7                	div    %edi
  802794:	31 ff                	xor    %edi,%edi
  802796:	89 fa                	mov    %edi,%edx
  802798:	83 c4 1c             	add    $0x1c,%esp
  80279b:	5b                   	pop    %ebx
  80279c:	5e                   	pop    %esi
  80279d:	5f                   	pop    %edi
  80279e:	5d                   	pop    %ebp
  80279f:	c3                   	ret    
  8027a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027a5:	89 eb                	mov    %ebp,%ebx
  8027a7:	29 fb                	sub    %edi,%ebx
  8027a9:	89 f9                	mov    %edi,%ecx
  8027ab:	d3 e6                	shl    %cl,%esi
  8027ad:	89 c5                	mov    %eax,%ebp
  8027af:	88 d9                	mov    %bl,%cl
  8027b1:	d3 ed                	shr    %cl,%ebp
  8027b3:	89 e9                	mov    %ebp,%ecx
  8027b5:	09 f1                	or     %esi,%ecx
  8027b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027bb:	89 f9                	mov    %edi,%ecx
  8027bd:	d3 e0                	shl    %cl,%eax
  8027bf:	89 c5                	mov    %eax,%ebp
  8027c1:	89 d6                	mov    %edx,%esi
  8027c3:	88 d9                	mov    %bl,%cl
  8027c5:	d3 ee                	shr    %cl,%esi
  8027c7:	89 f9                	mov    %edi,%ecx
  8027c9:	d3 e2                	shl    %cl,%edx
  8027cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027cf:	88 d9                	mov    %bl,%cl
  8027d1:	d3 e8                	shr    %cl,%eax
  8027d3:	09 c2                	or     %eax,%edx
  8027d5:	89 d0                	mov    %edx,%eax
  8027d7:	89 f2                	mov    %esi,%edx
  8027d9:	f7 74 24 0c          	divl   0xc(%esp)
  8027dd:	89 d6                	mov    %edx,%esi
  8027df:	89 c3                	mov    %eax,%ebx
  8027e1:	f7 e5                	mul    %ebp
  8027e3:	39 d6                	cmp    %edx,%esi
  8027e5:	72 19                	jb     802800 <__udivdi3+0xfc>
  8027e7:	74 0b                	je     8027f4 <__udivdi3+0xf0>
  8027e9:	89 d8                	mov    %ebx,%eax
  8027eb:	31 ff                	xor    %edi,%edi
  8027ed:	e9 58 ff ff ff       	jmp    80274a <__udivdi3+0x46>
  8027f2:	66 90                	xchg   %ax,%ax
  8027f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8027f8:	89 f9                	mov    %edi,%ecx
  8027fa:	d3 e2                	shl    %cl,%edx
  8027fc:	39 c2                	cmp    %eax,%edx
  8027fe:	73 e9                	jae    8027e9 <__udivdi3+0xe5>
  802800:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802803:	31 ff                	xor    %edi,%edi
  802805:	e9 40 ff ff ff       	jmp    80274a <__udivdi3+0x46>
  80280a:	66 90                	xchg   %ax,%ax
  80280c:	31 c0                	xor    %eax,%eax
  80280e:	e9 37 ff ff ff       	jmp    80274a <__udivdi3+0x46>
  802813:	90                   	nop

00802814 <__umoddi3>:
  802814:	55                   	push   %ebp
  802815:	57                   	push   %edi
  802816:	56                   	push   %esi
  802817:	53                   	push   %ebx
  802818:	83 ec 1c             	sub    $0x1c,%esp
  80281b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80281f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802827:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80282b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80282f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802833:	89 f3                	mov    %esi,%ebx
  802835:	89 fa                	mov    %edi,%edx
  802837:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80283b:	89 34 24             	mov    %esi,(%esp)
  80283e:	85 c0                	test   %eax,%eax
  802840:	75 1a                	jne    80285c <__umoddi3+0x48>
  802842:	39 f7                	cmp    %esi,%edi
  802844:	0f 86 a2 00 00 00    	jbe    8028ec <__umoddi3+0xd8>
  80284a:	89 c8                	mov    %ecx,%eax
  80284c:	89 f2                	mov    %esi,%edx
  80284e:	f7 f7                	div    %edi
  802850:	89 d0                	mov    %edx,%eax
  802852:	31 d2                	xor    %edx,%edx
  802854:	83 c4 1c             	add    $0x1c,%esp
  802857:	5b                   	pop    %ebx
  802858:	5e                   	pop    %esi
  802859:	5f                   	pop    %edi
  80285a:	5d                   	pop    %ebp
  80285b:	c3                   	ret    
  80285c:	39 f0                	cmp    %esi,%eax
  80285e:	0f 87 ac 00 00 00    	ja     802910 <__umoddi3+0xfc>
  802864:	0f bd e8             	bsr    %eax,%ebp
  802867:	83 f5 1f             	xor    $0x1f,%ebp
  80286a:	0f 84 ac 00 00 00    	je     80291c <__umoddi3+0x108>
  802870:	bf 20 00 00 00       	mov    $0x20,%edi
  802875:	29 ef                	sub    %ebp,%edi
  802877:	89 fe                	mov    %edi,%esi
  802879:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80287d:	89 e9                	mov    %ebp,%ecx
  80287f:	d3 e0                	shl    %cl,%eax
  802881:	89 d7                	mov    %edx,%edi
  802883:	89 f1                	mov    %esi,%ecx
  802885:	d3 ef                	shr    %cl,%edi
  802887:	09 c7                	or     %eax,%edi
  802889:	89 e9                	mov    %ebp,%ecx
  80288b:	d3 e2                	shl    %cl,%edx
  80288d:	89 14 24             	mov    %edx,(%esp)
  802890:	89 d8                	mov    %ebx,%eax
  802892:	d3 e0                	shl    %cl,%eax
  802894:	89 c2                	mov    %eax,%edx
  802896:	8b 44 24 08          	mov    0x8(%esp),%eax
  80289a:	d3 e0                	shl    %cl,%eax
  80289c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028a4:	89 f1                	mov    %esi,%ecx
  8028a6:	d3 e8                	shr    %cl,%eax
  8028a8:	09 d0                	or     %edx,%eax
  8028aa:	d3 eb                	shr    %cl,%ebx
  8028ac:	89 da                	mov    %ebx,%edx
  8028ae:	f7 f7                	div    %edi
  8028b0:	89 d3                	mov    %edx,%ebx
  8028b2:	f7 24 24             	mull   (%esp)
  8028b5:	89 c6                	mov    %eax,%esi
  8028b7:	89 d1                	mov    %edx,%ecx
  8028b9:	39 d3                	cmp    %edx,%ebx
  8028bb:	0f 82 87 00 00 00    	jb     802948 <__umoddi3+0x134>
  8028c1:	0f 84 91 00 00 00    	je     802958 <__umoddi3+0x144>
  8028c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028cb:	29 f2                	sub    %esi,%edx
  8028cd:	19 cb                	sbb    %ecx,%ebx
  8028cf:	89 d8                	mov    %ebx,%eax
  8028d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028d5:	d3 e0                	shl    %cl,%eax
  8028d7:	89 e9                	mov    %ebp,%ecx
  8028d9:	d3 ea                	shr    %cl,%edx
  8028db:	09 d0                	or     %edx,%eax
  8028dd:	89 e9                	mov    %ebp,%ecx
  8028df:	d3 eb                	shr    %cl,%ebx
  8028e1:	89 da                	mov    %ebx,%edx
  8028e3:	83 c4 1c             	add    $0x1c,%esp
  8028e6:	5b                   	pop    %ebx
  8028e7:	5e                   	pop    %esi
  8028e8:	5f                   	pop    %edi
  8028e9:	5d                   	pop    %ebp
  8028ea:	c3                   	ret    
  8028eb:	90                   	nop
  8028ec:	89 fd                	mov    %edi,%ebp
  8028ee:	85 ff                	test   %edi,%edi
  8028f0:	75 0b                	jne    8028fd <__umoddi3+0xe9>
  8028f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f7:	31 d2                	xor    %edx,%edx
  8028f9:	f7 f7                	div    %edi
  8028fb:	89 c5                	mov    %eax,%ebp
  8028fd:	89 f0                	mov    %esi,%eax
  8028ff:	31 d2                	xor    %edx,%edx
  802901:	f7 f5                	div    %ebp
  802903:	89 c8                	mov    %ecx,%eax
  802905:	f7 f5                	div    %ebp
  802907:	89 d0                	mov    %edx,%eax
  802909:	e9 44 ff ff ff       	jmp    802852 <__umoddi3+0x3e>
  80290e:	66 90                	xchg   %ax,%ax
  802910:	89 c8                	mov    %ecx,%eax
  802912:	89 f2                	mov    %esi,%edx
  802914:	83 c4 1c             	add    $0x1c,%esp
  802917:	5b                   	pop    %ebx
  802918:	5e                   	pop    %esi
  802919:	5f                   	pop    %edi
  80291a:	5d                   	pop    %ebp
  80291b:	c3                   	ret    
  80291c:	3b 04 24             	cmp    (%esp),%eax
  80291f:	72 06                	jb     802927 <__umoddi3+0x113>
  802921:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802925:	77 0f                	ja     802936 <__umoddi3+0x122>
  802927:	89 f2                	mov    %esi,%edx
  802929:	29 f9                	sub    %edi,%ecx
  80292b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80292f:	89 14 24             	mov    %edx,(%esp)
  802932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802936:	8b 44 24 04          	mov    0x4(%esp),%eax
  80293a:	8b 14 24             	mov    (%esp),%edx
  80293d:	83 c4 1c             	add    $0x1c,%esp
  802940:	5b                   	pop    %ebx
  802941:	5e                   	pop    %esi
  802942:	5f                   	pop    %edi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	2b 04 24             	sub    (%esp),%eax
  80294b:	19 fa                	sbb    %edi,%edx
  80294d:	89 d1                	mov    %edx,%ecx
  80294f:	89 c6                	mov    %eax,%esi
  802951:	e9 71 ff ff ff       	jmp    8028c7 <__umoddi3+0xb3>
  802956:	66 90                	xchg   %ax,%ax
  802958:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80295c:	72 ea                	jb     802948 <__umoddi3+0x134>
  80295e:	89 d9                	mov    %ebx,%ecx
  802960:	e9 62 ff ff ff       	jmp    8028c7 <__umoddi3+0xb3>
