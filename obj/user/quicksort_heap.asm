
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 20 22 00 00       	call   802266 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 29 80 00       	push   $0x802900
  80004e:	e8 e9 09 00 00       	call   800a3c <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 29 80 00       	push   $0x802902
  80005e:	e8 d9 09 00 00       	call   800a3c <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 29 80 00       	push   $0x80291b
  80006e:	e8 c9 09 00 00       	call   800a3c <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 29 80 00       	push   $0x802902
  80007e:	e8 b9 09 00 00       	call   800a3c <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 29 80 00       	push   $0x802900
  80008e:	e8 a9 09 00 00       	call   800a3c <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 29 80 00       	push   $0x802934
  8000a5:	e8 14 10 00 00       	call   8010be <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 64 15 00 00       	call   801624 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 f7 18 00 00       	call   8019cc <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 54 29 80 00       	push   $0x802954
  8000e3:	e8 54 09 00 00       	call   800a3c <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 76 29 80 00       	push   $0x802976
  8000f3:	e8 44 09 00 00       	call   800a3c <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 84 29 80 00       	push   $0x802984
  800103:	e8 34 09 00 00       	call   800a3c <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 93 29 80 00       	push   $0x802993
  800113:	e8 24 09 00 00       	call   800a3c <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 a3 29 80 00       	push   $0x8029a3
  800123:	e8 14 09 00 00       	call   800a3c <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 19 21 00 00       	call   802280 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 8c 20 00 00       	call   802266 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 29 80 00       	push   $0x8029ac
  8001e2:	e8 55 08 00 00       	call   800a3c <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 91 20 00 00       	call   802280 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 e0 29 80 00       	push   $0x8029e0
  800211:	6a 48                	push   $0x48
  800213:	68 02 2a 80 00       	push   $0x802a02
  800218:	e8 7d 05 00 00       	call   80079a <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 44 20 00 00       	call   802266 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 18 2a 80 00       	push   $0x802a18
  80022a:	e8 0d 08 00 00       	call   800a3c <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 4c 2a 80 00       	push   $0x802a4c
  80023a:	e8 fd 07 00 00       	call   800a3c <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 80 2a 80 00       	push   $0x802a80
  80024a:	e8 ed 07 00 00       	call   800a3c <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 29 20 00 00       	call   802280 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 0a 20 00 00       	call   802266 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 b2 2a 80 00       	push   $0x802ab2
  80026a:	e8 cd 07 00 00       	call   800a3c <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 cb 1f 00 00       	call   802280 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 00 29 80 00       	push   $0x802900
  80055a:	e8 dd 04 00 00       	call   800a3c <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 d0 2a 80 00       	push   $0x802ad0
  80057c:	e8 bb 04 00 00       	call   800a3c <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 d5 2a 80 00       	push   $0x802ad5
  8005aa:	e8 8d 04 00 00       	call   800a3c <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 cc 1c 00 00       	call   80229a <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 87 1c 00 00       	call   802266 <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 a8 1c 00 00       	call   80229a <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 86 1c 00 00       	call   802280 <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 6d 1a 00 00       	call   80207e <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 3c 1c 00 00       	call   802266 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 46 1a 00 00       	call   80207e <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 3a 1c 00 00       	call   802280 <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 6b 1a 00 00       	call   8020cb <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800674:	01 c8                	add    %ecx,%eax
  800676:	01 c0                	add    %eax,%eax
  800678:	01 d0                	add    %edx,%eax
  80067a:	01 c0                	add    %eax,%eax
  80067c:	01 d0                	add    %edx,%eax
  80067e:	89 c2                	mov    %eax,%edx
  800680:	c1 e2 05             	shl    $0x5,%edx
  800683:	29 c2                	sub    %eax,%edx
  800685:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80068c:	89 c2                	mov    %eax,%edx
  80068e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800694:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800699:	a1 24 40 80 00       	mov    0x804024,%eax
  80069e:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8006a4:	84 c0                	test   %al,%al
  8006a6:	74 0f                	je     8006b7 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8006a8:	a1 24 40 80 00       	mov    0x804024,%eax
  8006ad:	05 40 3c 01 00       	add    $0x13c40,%eax
  8006b2:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006bb:	7e 0a                	jle    8006c7 <libmain+0x72>
		binaryname = argv[0];
  8006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	e8 63 f9 ff ff       	call   800038 <_main>
  8006d5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d8:	e8 89 1b 00 00       	call   802266 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 f4 2a 80 00       	push   $0x802af4
  8006e5:	e8 52 03 00 00       	call   800a3c <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ed:	a1 24 40 80 00       	mov    0x804024,%eax
  8006f2:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006f8:	a1 24 40 80 00       	mov    0x804024,%eax
  8006fd:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800703:	83 ec 04             	sub    $0x4,%esp
  800706:	52                   	push   %edx
  800707:	50                   	push   %eax
  800708:	68 1c 2b 80 00       	push   $0x802b1c
  80070d:	e8 2a 03 00 00       	call   800a3c <cprintf>
  800712:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800715:	a1 24 40 80 00       	mov    0x804024,%eax
  80071a:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800720:	a1 24 40 80 00       	mov    0x804024,%eax
  800725:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	52                   	push   %edx
  80072f:	50                   	push   %eax
  800730:	68 44 2b 80 00       	push   $0x802b44
  800735:	e8 02 03 00 00       	call   800a3c <cprintf>
  80073a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073d:	a1 24 40 80 00       	mov    0x804024,%eax
  800742:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	50                   	push   %eax
  80074c:	68 85 2b 80 00       	push   $0x802b85
  800751:	e8 e6 02 00 00       	call   800a3c <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	68 f4 2a 80 00       	push   $0x802af4
  800761:	e8 d6 02 00 00       	call   800a3c <cprintf>
  800766:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800769:	e8 12 1b 00 00       	call   802280 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076e:	e8 19 00 00 00       	call   80078c <exit>
}
  800773:	90                   	nop
  800774:	c9                   	leave  
  800775:	c3                   	ret    

00800776 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	6a 00                	push   $0x0
  800781:	e8 11 19 00 00       	call   802097 <sys_env_destroy>
  800786:	83 c4 10             	add    $0x10,%esp
}
  800789:	90                   	nop
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <exit>:

void
exit(void)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800792:	e8 66 19 00 00       	call   8020fd <sys_env_exit>
}
  800797:	90                   	nop
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a3:	83 c0 04             	add    $0x4,%eax
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a9:	a1 18 41 80 00       	mov    0x804118,%eax
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	74 16                	je     8007c8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b2:	a1 18 41 80 00       	mov    0x804118,%eax
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	50                   	push   %eax
  8007bb:	68 9c 2b 80 00       	push   $0x802b9c
  8007c0:	e8 77 02 00 00       	call   800a3c <cprintf>
  8007c5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c8:	a1 00 40 80 00       	mov    0x804000,%eax
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	ff 75 08             	pushl  0x8(%ebp)
  8007d3:	50                   	push   %eax
  8007d4:	68 a1 2b 80 00       	push   $0x802ba1
  8007d9:	e8 5e 02 00 00       	call   800a3c <cprintf>
  8007de:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ea:	50                   	push   %eax
  8007eb:	e8 e1 01 00 00       	call   8009d1 <vcprintf>
  8007f0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	6a 00                	push   $0x0
  8007f8:	68 bd 2b 80 00       	push   $0x802bbd
  8007fd:	e8 cf 01 00 00       	call   8009d1 <vcprintf>
  800802:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800805:	e8 82 ff ff ff       	call   80078c <exit>

	// should not return here
	while (1) ;
  80080a:	eb fe                	jmp    80080a <_panic+0x70>

0080080c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800812:	a1 24 40 80 00       	mov    0x804024,%eax
  800817:	8b 50 74             	mov    0x74(%eax),%edx
  80081a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081d:	39 c2                	cmp    %eax,%edx
  80081f:	74 14                	je     800835 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 c0 2b 80 00       	push   $0x802bc0
  800829:	6a 26                	push   $0x26
  80082b:	68 0c 2c 80 00       	push   $0x802c0c
  800830:	e8 65 ff ff ff       	call   80079a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800835:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800843:	e9 b6 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	85 c0                	test   %eax,%eax
  80085b:	75 08                	jne    800865 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800860:	e9 96 00 00 00       	jmp    8008fb <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800865:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800873:	eb 5d                	jmp    8008d2 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800875:	a1 24 40 80 00       	mov    0x804024,%eax
  80087a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800880:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800883:	c1 e2 04             	shl    $0x4,%edx
  800886:	01 d0                	add    %edx,%eax
  800888:	8a 40 04             	mov    0x4(%eax),%al
  80088b:	84 c0                	test   %al,%al
  80088d:	75 40                	jne    8008cf <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088f:	a1 24 40 80 00       	mov    0x804024,%eax
  800894:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80089a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089d:	c1 e2 04             	shl    $0x4,%edx
  8008a0:	01 d0                	add    %edx,%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008af:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	01 c8                	add    %ecx,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c2:	39 c2                	cmp    %eax,%edx
  8008c4:	75 09                	jne    8008cf <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8008c6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008cd:	eb 12                	jmp    8008e1 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cf:	ff 45 e8             	incl   -0x18(%ebp)
  8008d2:	a1 24 40 80 00       	mov    0x804024,%eax
  8008d7:	8b 50 74             	mov    0x74(%eax),%edx
  8008da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008dd:	39 c2                	cmp    %eax,%edx
  8008df:	77 94                	ja     800875 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e5:	75 14                	jne    8008fb <CheckWSWithoutLastIndex+0xef>
			panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 18 2c 80 00       	push   $0x802c18
  8008ef:	6a 3a                	push   $0x3a
  8008f1:	68 0c 2c 80 00       	push   $0x802c0c
  8008f6:	e8 9f fe ff ff       	call   80079a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fb:	ff 45 f0             	incl   -0x10(%ebp)
  8008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800901:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800904:	0f 8c 3e ff ff ff    	jl     800848 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800911:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800918:	eb 20                	jmp    80093a <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091a:	a1 24 40 80 00       	mov    0x804024,%eax
  80091f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800925:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800928:	c1 e2 04             	shl    $0x4,%edx
  80092b:	01 d0                	add    %edx,%eax
  80092d:	8a 40 04             	mov    0x4(%eax),%al
  800930:	3c 01                	cmp    $0x1,%al
  800932:	75 03                	jne    800937 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800934:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800937:	ff 45 e0             	incl   -0x20(%ebp)
  80093a:	a1 24 40 80 00       	mov    0x804024,%eax
  80093f:	8b 50 74             	mov    0x74(%eax),%edx
  800942:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800945:	39 c2                	cmp    %eax,%edx
  800947:	77 d1                	ja     80091a <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80094f:	74 14                	je     800965 <CheckWSWithoutLastIndex+0x159>
		panic(
  800951:	83 ec 04             	sub    $0x4,%esp
  800954:	68 6c 2c 80 00       	push   $0x802c6c
  800959:	6a 44                	push   $0x44
  80095b:	68 0c 2c 80 00       	push   $0x802c0c
  800960:	e8 35 fe ff ff       	call   80079a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800965:	90                   	nop
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80096e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	8d 48 01             	lea    0x1(%eax),%ecx
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
  800979:	89 0a                	mov    %ecx,(%edx)
  80097b:	8b 55 08             	mov    0x8(%ebp),%edx
  80097e:	88 d1                	mov    %dl,%cl
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
  800983:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800991:	75 2c                	jne    8009bf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800993:	a0 28 40 80 00       	mov    0x804028,%al
  800998:	0f b6 c0             	movzbl %al,%eax
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099e:	8b 12                	mov    (%edx),%edx
  8009a0:	89 d1                	mov    %edx,%ecx
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a5:	83 c2 08             	add    $0x8,%edx
  8009a8:	83 ec 04             	sub    $0x4,%esp
  8009ab:	50                   	push   %eax
  8009ac:	51                   	push   %ecx
  8009ad:	52                   	push   %edx
  8009ae:	e8 a2 16 00 00       	call   802055 <sys_cputs>
  8009b3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	8b 40 04             	mov    0x4(%eax),%eax
  8009c5:	8d 50 01             	lea    0x1(%eax),%edx
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009ce:	90                   	nop
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009e1:	00 00 00 
	b.cnt = 0;
  8009e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009eb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	ff 75 08             	pushl  0x8(%ebp)
  8009f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009fa:	50                   	push   %eax
  8009fb:	68 68 09 80 00       	push   $0x800968
  800a00:	e8 11 02 00 00       	call   800c16 <vprintfmt>
  800a05:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a08:	a0 28 40 80 00       	mov    0x804028,%al
  800a0d:	0f b6 c0             	movzbl %al,%eax
  800a10:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a16:	83 ec 04             	sub    $0x4,%esp
  800a19:	50                   	push   %eax
  800a1a:	52                   	push   %edx
  800a1b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a21:	83 c0 08             	add    $0x8,%eax
  800a24:	50                   	push   %eax
  800a25:	e8 2b 16 00 00       	call   802055 <sys_cputs>
  800a2a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a2d:	c6 05 28 40 80 00 00 	movb   $0x0,0x804028
	return b.cnt;
  800a34:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <cprintf>:

int cprintf(const char *fmt, ...) {
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a42:	c6 05 28 40 80 00 01 	movb   $0x1,0x804028
	va_start(ap, fmt);
  800a49:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 f4             	pushl  -0xc(%ebp)
  800a58:	50                   	push   %eax
  800a59:	e8 73 ff ff ff       	call   8009d1 <vcprintf>
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a6f:	e8 f2 17 00 00       	call   802266 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a74:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 f4             	pushl  -0xc(%ebp)
  800a83:	50                   	push   %eax
  800a84:	e8 48 ff ff ff       	call   8009d1 <vcprintf>
  800a89:	83 c4 10             	add    $0x10,%esp
  800a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a8f:	e8 ec 17 00 00       	call   802280 <sys_enable_interrupt>
	return cnt;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    

00800a99 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	53                   	push   %ebx
  800a9d:	83 ec 14             	sub    $0x14,%esp
  800aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aac:	8b 45 18             	mov    0x18(%ebp),%eax
  800aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab7:	77 55                	ja     800b0e <printnum+0x75>
  800ab9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800abc:	72 05                	jb     800ac3 <printnum+0x2a>
  800abe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ac1:	77 4b                	ja     800b0e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ac3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ac6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac9:	8b 45 18             	mov    0x18(%ebp),%eax
  800acc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad1:	52                   	push   %edx
  800ad2:	50                   	push   %eax
  800ad3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad9:	e8 aa 1b 00 00       	call   802688 <__udivdi3>
  800ade:	83 c4 10             	add    $0x10,%esp
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	ff 75 20             	pushl  0x20(%ebp)
  800ae7:	53                   	push   %ebx
  800ae8:	ff 75 18             	pushl  0x18(%ebp)
  800aeb:	52                   	push   %edx
  800aec:	50                   	push   %eax
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	ff 75 08             	pushl  0x8(%ebp)
  800af3:	e8 a1 ff ff ff       	call   800a99 <printnum>
  800af8:	83 c4 20             	add    $0x20,%esp
  800afb:	eb 1a                	jmp    800b17 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 20             	pushl  0x20(%ebp)
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b0e:	ff 4d 1c             	decl   0x1c(%ebp)
  800b11:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b15:	7f e6                	jg     800afd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b17:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b25:	53                   	push   %ebx
  800b26:	51                   	push   %ecx
  800b27:	52                   	push   %edx
  800b28:	50                   	push   %eax
  800b29:	e8 6a 1c 00 00       	call   802798 <__umoddi3>
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	05 d4 2e 80 00       	add    $0x802ed4,%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f be c0             	movsbl %al,%eax
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	50                   	push   %eax
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	ff d0                	call   *%eax
  800b47:	83 c4 10             	add    $0x10,%esp
}
  800b4a:	90                   	nop
  800b4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b53:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b57:	7e 1c                	jle    800b75 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	8d 50 08             	lea    0x8(%eax),%edx
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	89 10                	mov    %edx,(%eax)
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	83 e8 08             	sub    $0x8,%eax
  800b6e:	8b 50 04             	mov    0x4(%eax),%edx
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	eb 40                	jmp    800bb5 <getuint+0x65>
	else if (lflag)
  800b75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b79:	74 1e                	je     800b99 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	8b 00                	mov    (%eax),%eax
  800b80:	8d 50 04             	lea    0x4(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	89 10                	mov    %edx,(%eax)
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	83 e8 04             	sub    $0x4,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	eb 1c                	jmp    800bb5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 00                	mov    (%eax),%eax
  800b9e:	8d 50 04             	lea    0x4(%eax),%edx
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	89 10                	mov    %edx,(%eax)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	83 e8 04             	sub    $0x4,%eax
  800bae:	8b 00                	mov    (%eax),%eax
  800bb0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bbe:	7e 1c                	jle    800bdc <getint+0x25>
		return va_arg(*ap, long long);
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	8d 50 08             	lea    0x8(%eax),%edx
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	89 10                	mov    %edx,(%eax)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	83 e8 08             	sub    $0x8,%eax
  800bd5:	8b 50 04             	mov    0x4(%eax),%edx
  800bd8:	8b 00                	mov    (%eax),%eax
  800bda:	eb 38                	jmp    800c14 <getint+0x5d>
	else if (lflag)
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	74 1a                	je     800bfc <getint+0x45>
		return va_arg(*ap, long);
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	8d 50 04             	lea    0x4(%eax),%edx
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	89 10                	mov    %edx,(%eax)
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	83 e8 04             	sub    $0x4,%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	99                   	cltd   
  800bfa:	eb 18                	jmp    800c14 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	8d 50 04             	lea    0x4(%eax),%edx
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	89 10                	mov    %edx,(%eax)
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	83 e8 04             	sub    $0x4,%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	99                   	cltd   
}
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	56                   	push   %esi
  800c1a:	53                   	push   %ebx
  800c1b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c1e:	eb 17                	jmp    800c37 <vprintfmt+0x21>
			if (ch == '\0')
  800c20:	85 db                	test   %ebx,%ebx
  800c22:	0f 84 af 03 00 00    	je     800fd7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	53                   	push   %ebx
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	8d 50 01             	lea    0x1(%eax),%edx
  800c3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	0f b6 d8             	movzbl %al,%ebx
  800c45:	83 fb 25             	cmp    $0x25,%ebx
  800c48:	75 d6                	jne    800c20 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c4a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c4e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c5c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c63:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6d:	8d 50 01             	lea    0x1(%eax),%edx
  800c70:	89 55 10             	mov    %edx,0x10(%ebp)
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	0f b6 d8             	movzbl %al,%ebx
  800c78:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c7b:	83 f8 55             	cmp    $0x55,%eax
  800c7e:	0f 87 2b 03 00 00    	ja     800faf <vprintfmt+0x399>
  800c84:	8b 04 85 f8 2e 80 00 	mov    0x802ef8(,%eax,4),%eax
  800c8b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c8d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c91:	eb d7                	jmp    800c6a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c93:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c97:	eb d1                	jmp    800c6a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c99:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ca3:	89 d0                	mov    %edx,%eax
  800ca5:	c1 e0 02             	shl    $0x2,%eax
  800ca8:	01 d0                	add    %edx,%eax
  800caa:	01 c0                	add    %eax,%eax
  800cac:	01 d8                	add    %ebx,%eax
  800cae:	83 e8 30             	sub    $0x30,%eax
  800cb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cbc:	83 fb 2f             	cmp    $0x2f,%ebx
  800cbf:	7e 3e                	jle    800cff <vprintfmt+0xe9>
  800cc1:	83 fb 39             	cmp    $0x39,%ebx
  800cc4:	7f 39                	jg     800cff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc9:	eb d5                	jmp    800ca0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 c0 04             	add    $0x4,%eax
  800cd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 e8 04             	sub    $0x4,%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cdf:	eb 1f                	jmp    800d00 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ce1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ce5:	79 83                	jns    800c6a <vprintfmt+0x54>
				width = 0;
  800ce7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cee:	e9 77 ff ff ff       	jmp    800c6a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cf3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cfa:	e9 6b ff ff ff       	jmp    800c6a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d04:	0f 89 60 ff ff ff    	jns    800c6a <vprintfmt+0x54>
				width = precision, precision = -1;
  800d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d10:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d17:	e9 4e ff ff ff       	jmp    800c6a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d1c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d1f:	e9 46 ff ff ff       	jmp    800c6a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d24:	8b 45 14             	mov    0x14(%ebp),%eax
  800d27:	83 c0 04             	add    $0x4,%eax
  800d2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 e8 04             	sub    $0x4,%eax
  800d33:	8b 00                	mov    (%eax),%eax
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	50                   	push   %eax
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	ff d0                	call   *%eax
  800d41:	83 c4 10             	add    $0x10,%esp
			break;
  800d44:	e9 89 02 00 00       	jmp    800fd2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 c0 04             	add    $0x4,%eax
  800d4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 e8 04             	sub    $0x4,%eax
  800d58:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d5a:	85 db                	test   %ebx,%ebx
  800d5c:	79 02                	jns    800d60 <vprintfmt+0x14a>
				err = -err;
  800d5e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d60:	83 fb 64             	cmp    $0x64,%ebx
  800d63:	7f 0b                	jg     800d70 <vprintfmt+0x15a>
  800d65:	8b 34 9d 40 2d 80 00 	mov    0x802d40(,%ebx,4),%esi
  800d6c:	85 f6                	test   %esi,%esi
  800d6e:	75 19                	jne    800d89 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d70:	53                   	push   %ebx
  800d71:	68 e5 2e 80 00       	push   $0x802ee5
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	ff 75 08             	pushl  0x8(%ebp)
  800d7c:	e8 5e 02 00 00       	call   800fdf <printfmt>
  800d81:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d84:	e9 49 02 00 00       	jmp    800fd2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d89:	56                   	push   %esi
  800d8a:	68 ee 2e 80 00       	push   $0x802eee
  800d8f:	ff 75 0c             	pushl  0xc(%ebp)
  800d92:	ff 75 08             	pushl  0x8(%ebp)
  800d95:	e8 45 02 00 00       	call   800fdf <printfmt>
  800d9a:	83 c4 10             	add    $0x10,%esp
			break;
  800d9d:	e9 30 02 00 00       	jmp    800fd2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800da2:	8b 45 14             	mov    0x14(%ebp),%eax
  800da5:	83 c0 04             	add    $0x4,%eax
  800da8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 e8 04             	sub    $0x4,%eax
  800db1:	8b 30                	mov    (%eax),%esi
  800db3:	85 f6                	test   %esi,%esi
  800db5:	75 05                	jne    800dbc <vprintfmt+0x1a6>
				p = "(null)";
  800db7:	be f1 2e 80 00       	mov    $0x802ef1,%esi
			if (width > 0 && padc != '-')
  800dbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc0:	7e 6d                	jle    800e2f <vprintfmt+0x219>
  800dc2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dc6:	74 67                	je     800e2f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	50                   	push   %eax
  800dcf:	56                   	push   %esi
  800dd0:	e8 12 05 00 00       	call   8012e7 <strnlen>
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ddb:	eb 16                	jmp    800df3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ddd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	50                   	push   %eax
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	ff d0                	call   *%eax
  800ded:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df0:	ff 4d e4             	decl   -0x1c(%ebp)
  800df3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df7:	7f e4                	jg     800ddd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df9:	eb 34                	jmp    800e2f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dff:	74 1c                	je     800e1d <vprintfmt+0x207>
  800e01:	83 fb 1f             	cmp    $0x1f,%ebx
  800e04:	7e 05                	jle    800e0b <vprintfmt+0x1f5>
  800e06:	83 fb 7e             	cmp    $0x7e,%ebx
  800e09:	7e 12                	jle    800e1d <vprintfmt+0x207>
					putch('?', putdat);
  800e0b:	83 ec 08             	sub    $0x8,%esp
  800e0e:	ff 75 0c             	pushl  0xc(%ebp)
  800e11:	6a 3f                	push   $0x3f
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	ff d0                	call   *%eax
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	eb 0f                	jmp    800e2c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e1d:	83 ec 08             	sub    $0x8,%esp
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	53                   	push   %ebx
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e2f:	89 f0                	mov    %esi,%eax
  800e31:	8d 70 01             	lea    0x1(%eax),%esi
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be d8             	movsbl %al,%ebx
  800e39:	85 db                	test   %ebx,%ebx
  800e3b:	74 24                	je     800e61 <vprintfmt+0x24b>
  800e3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e41:	78 b8                	js     800dfb <vprintfmt+0x1e5>
  800e43:	ff 4d e0             	decl   -0x20(%ebp)
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	79 af                	jns    800dfb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4c:	eb 13                	jmp    800e61 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	ff 75 0c             	pushl  0xc(%ebp)
  800e54:	6a 20                	push   $0x20
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	ff d0                	call   *%eax
  800e5b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800e61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e65:	7f e7                	jg     800e4e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e67:	e9 66 01 00 00       	jmp    800fd2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e6c:	83 ec 08             	sub    $0x8,%esp
  800e6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800e72:	8d 45 14             	lea    0x14(%ebp),%eax
  800e75:	50                   	push   %eax
  800e76:	e8 3c fd ff ff       	call   800bb7 <getint>
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8a:	85 d2                	test   %edx,%edx
  800e8c:	79 23                	jns    800eb1 <vprintfmt+0x29b>
				putch('-', putdat);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 0c             	pushl  0xc(%ebp)
  800e94:	6a 2d                	push   $0x2d
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	ff d0                	call   *%eax
  800e9b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea4:	f7 d8                	neg    %eax
  800ea6:	83 d2 00             	adc    $0x0,%edx
  800ea9:	f7 da                	neg    %edx
  800eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eb1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb8:	e9 bc 00 00 00       	jmp    800f79 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ec3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ec6:	50                   	push   %eax
  800ec7:	e8 84 fc ff ff       	call   800b50 <getuint>
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ed5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800edc:	e9 98 00 00 00       	jmp    800f79 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ee1:	83 ec 08             	sub    $0x8,%esp
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	6a 58                	push   $0x58
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	ff d0                	call   *%eax
  800eee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	6a 58                	push   $0x58
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	ff d0                	call   *%eax
  800efe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f01:	83 ec 08             	sub    $0x8,%esp
  800f04:	ff 75 0c             	pushl  0xc(%ebp)
  800f07:	6a 58                	push   $0x58
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	ff d0                	call   *%eax
  800f0e:	83 c4 10             	add    $0x10,%esp
			break;
  800f11:	e9 bc 00 00 00       	jmp    800fd2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	ff 75 0c             	pushl  0xc(%ebp)
  800f1c:	6a 30                	push   $0x30
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	ff d0                	call   *%eax
  800f23:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 0c             	pushl  0xc(%ebp)
  800f2c:	6a 78                	push   $0x78
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	ff d0                	call   *%eax
  800f33:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f36:	8b 45 14             	mov    0x14(%ebp),%eax
  800f39:	83 c0 04             	add    $0x4,%eax
  800f3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 e8 04             	sub    $0x4,%eax
  800f45:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f58:	eb 1f                	jmp    800f79 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 e8             	pushl  -0x18(%ebp)
  800f60:	8d 45 14             	lea    0x14(%ebp),%eax
  800f63:	50                   	push   %eax
  800f64:	e8 e7 fb ff ff       	call   800b50 <getuint>
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f79:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f80:	83 ec 04             	sub    $0x4,%esp
  800f83:	52                   	push   %edx
  800f84:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f87:	50                   	push   %eax
  800f88:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8b:	ff 75 f0             	pushl  -0x10(%ebp)
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	e8 00 fb ff ff       	call   800a99 <printnum>
  800f99:	83 c4 20             	add    $0x20,%esp
			break;
  800f9c:	eb 34                	jmp    800fd2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	53                   	push   %ebx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			break;
  800fad:	eb 23                	jmp    800fd2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	ff 75 0c             	pushl  0xc(%ebp)
  800fb5:	6a 25                	push   $0x25
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	ff d0                	call   *%eax
  800fbc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fbf:	ff 4d 10             	decl   0x10(%ebp)
  800fc2:	eb 03                	jmp    800fc7 <vprintfmt+0x3b1>
  800fc4:	ff 4d 10             	decl   0x10(%ebp)
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	48                   	dec    %eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 25                	cmp    $0x25,%al
  800fcf:	75 f3                	jne    800fc4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fd1:	90                   	nop
		}
	}
  800fd2:	e9 47 fc ff ff       	jmp    800c1e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fd7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fe5:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe8:	83 c0 04             	add    $0x4,%eax
  800feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 0c             	pushl  0xc(%ebp)
  800ff8:	ff 75 08             	pushl  0x8(%ebp)
  800ffb:	e8 16 fc ff ff       	call   800c16 <vprintfmt>
  801000:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801003:	90                   	nop
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	8b 40 08             	mov    0x8(%eax),%eax
  80100f:	8d 50 01             	lea    0x1(%eax),%edx
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	8b 10                	mov    (%eax),%edx
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 40 04             	mov    0x4(%eax),%eax
  801023:	39 c2                	cmp    %eax,%edx
  801025:	73 12                	jae    801039 <sprintputch+0x33>
		*b->buf++ = ch;
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	8b 00                	mov    (%eax),%eax
  80102c:	8d 48 01             	lea    0x1(%eax),%ecx
  80102f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801032:	89 0a                	mov    %ecx,(%edx)
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	88 10                	mov    %dl,(%eax)
}
  801039:	90                   	nop
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	01 d0                	add    %edx,%eax
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80105d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801061:	74 06                	je     801069 <vsnprintf+0x2d>
  801063:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801067:	7f 07                	jg     801070 <vsnprintf+0x34>
		return -E_INVAL;
  801069:	b8 03 00 00 00       	mov    $0x3,%eax
  80106e:	eb 20                	jmp    801090 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801070:	ff 75 14             	pushl  0x14(%ebp)
  801073:	ff 75 10             	pushl  0x10(%ebp)
  801076:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801079:	50                   	push   %eax
  80107a:	68 06 10 80 00       	push   $0x801006
  80107f:	e8 92 fb ff ff       	call   800c16 <vprintfmt>
  801084:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801087:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80108a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80108d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801098:	8d 45 10             	lea    0x10(%ebp),%eax
  80109b:	83 c0 04             	add    $0x4,%eax
  80109e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a7:	50                   	push   %eax
  8010a8:	ff 75 0c             	pushl  0xc(%ebp)
  8010ab:	ff 75 08             	pushl  0x8(%ebp)
  8010ae:	e8 89 ff ff ff       	call   80103c <vsnprintf>
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c8:	74 13                	je     8010dd <readline+0x1f>
		cprintf("%s", prompt);
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	ff 75 08             	pushl  0x8(%ebp)
  8010d0:	68 50 30 80 00       	push   $0x803050
  8010d5:	e8 62 f9 ff ff       	call   800a3c <cprintf>
  8010da:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010e4:	83 ec 0c             	sub    $0xc,%esp
  8010e7:	6a 00                	push   $0x0
  8010e9:	e8 5d f5 ff ff       	call   80064b <iscons>
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010f4:	e8 04 f5 ff ff       	call   8005fd <getchar>
  8010f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801100:	79 22                	jns    801124 <readline+0x66>
			if (c != -E_EOF)
  801102:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801106:	0f 84 ad 00 00 00    	je     8011b9 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	ff 75 ec             	pushl  -0x14(%ebp)
  801112:	68 53 30 80 00       	push   $0x803053
  801117:	e8 20 f9 ff ff       	call   800a3c <cprintf>
  80111c:	83 c4 10             	add    $0x10,%esp
			return;
  80111f:	e9 95 00 00 00       	jmp    8011b9 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801124:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801128:	7e 34                	jle    80115e <readline+0xa0>
  80112a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801131:	7f 2b                	jg     80115e <readline+0xa0>
			if (echoing)
  801133:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801137:	74 0e                	je     801147 <readline+0x89>
				cputchar(c);
  801139:	83 ec 0c             	sub    $0xc,%esp
  80113c:	ff 75 ec             	pushl  -0x14(%ebp)
  80113f:	e8 71 f4 ff ff       	call   8005b5 <cputchar>
  801144:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114a:	8d 50 01             	lea    0x1(%eax),%edx
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801150:	89 c2                	mov    %eax,%edx
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	01 d0                	add    %edx,%eax
  801157:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115a:	88 10                	mov    %dl,(%eax)
  80115c:	eb 56                	jmp    8011b4 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80115e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801162:	75 1f                	jne    801183 <readline+0xc5>
  801164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801168:	7e 19                	jle    801183 <readline+0xc5>
			if (echoing)
  80116a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80116e:	74 0e                	je     80117e <readline+0xc0>
				cputchar(c);
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	ff 75 ec             	pushl  -0x14(%ebp)
  801176:	e8 3a f4 ff ff       	call   8005b5 <cputchar>
  80117b:	83 c4 10             	add    $0x10,%esp

			i--;
  80117e:	ff 4d f4             	decl   -0xc(%ebp)
  801181:	eb 31                	jmp    8011b4 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801183:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801187:	74 0a                	je     801193 <readline+0xd5>
  801189:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80118d:	0f 85 61 ff ff ff    	jne    8010f4 <readline+0x36>
			if (echoing)
  801193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801197:	74 0e                	je     8011a7 <readline+0xe9>
				cputchar(c);
  801199:	83 ec 0c             	sub    $0xc,%esp
  80119c:	ff 75 ec             	pushl  -0x14(%ebp)
  80119f:	e8 11 f4 ff ff       	call   8005b5 <cputchar>
  8011a4:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011b2:	eb 06                	jmp    8011ba <readline+0xfc>
		}
	}
  8011b4:	e9 3b ff ff ff       	jmp    8010f4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b9:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011c2:	e8 9f 10 00 00       	call   802266 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cb:	74 13                	je     8011e0 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	ff 75 08             	pushl  0x8(%ebp)
  8011d3:	68 50 30 80 00       	push   $0x803050
  8011d8:	e8 5f f8 ff ff       	call   800a3c <cprintf>
  8011dd:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011e7:	83 ec 0c             	sub    $0xc,%esp
  8011ea:	6a 00                	push   $0x0
  8011ec:	e8 5a f4 ff ff       	call   80064b <iscons>
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011f7:	e8 01 f4 ff ff       	call   8005fd <getchar>
  8011fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801203:	79 23                	jns    801228 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801205:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801209:	74 13                	je     80121e <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	ff 75 ec             	pushl  -0x14(%ebp)
  801211:	68 53 30 80 00       	push   $0x803053
  801216:	e8 21 f8 ff ff       	call   800a3c <cprintf>
  80121b:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80121e:	e8 5d 10 00 00       	call   802280 <sys_enable_interrupt>
			return;
  801223:	e9 9a 00 00 00       	jmp    8012c2 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801228:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80122c:	7e 34                	jle    801262 <atomic_readline+0xa6>
  80122e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801235:	7f 2b                	jg     801262 <atomic_readline+0xa6>
			if (echoing)
  801237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80123b:	74 0e                	je     80124b <atomic_readline+0x8f>
				cputchar(c);
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	ff 75 ec             	pushl  -0x14(%ebp)
  801243:	e8 6d f3 ff ff       	call   8005b5 <cputchar>
  801248:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80124b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124e:	8d 50 01             	lea    0x1(%eax),%edx
  801251:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801254:	89 c2                	mov    %eax,%edx
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	01 d0                	add    %edx,%eax
  80125b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80125e:	88 10                	mov    %dl,(%eax)
  801260:	eb 5b                	jmp    8012bd <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801262:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801266:	75 1f                	jne    801287 <atomic_readline+0xcb>
  801268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80126c:	7e 19                	jle    801287 <atomic_readline+0xcb>
			if (echoing)
  80126e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801272:	74 0e                	je     801282 <atomic_readline+0xc6>
				cputchar(c);
  801274:	83 ec 0c             	sub    $0xc,%esp
  801277:	ff 75 ec             	pushl  -0x14(%ebp)
  80127a:	e8 36 f3 ff ff       	call   8005b5 <cputchar>
  80127f:	83 c4 10             	add    $0x10,%esp
			i--;
  801282:	ff 4d f4             	decl   -0xc(%ebp)
  801285:	eb 36                	jmp    8012bd <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801287:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80128b:	74 0a                	je     801297 <atomic_readline+0xdb>
  80128d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801291:	0f 85 60 ff ff ff    	jne    8011f7 <atomic_readline+0x3b>
			if (echoing)
  801297:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80129b:	74 0e                	je     8012ab <atomic_readline+0xef>
				cputchar(c);
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a3:	e8 0d f3 ff ff       	call   8005b5 <cputchar>
  8012a8:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012b6:	e8 c5 0f 00 00       	call   802280 <sys_enable_interrupt>
			return;
  8012bb:	eb 05                	jmp    8012c2 <atomic_readline+0x106>
		}
	}
  8012bd:	e9 35 ff ff ff       	jmp    8011f7 <atomic_readline+0x3b>
}
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d1:	eb 06                	jmp    8012d9 <strlen+0x15>
		n++;
  8012d3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d6:	ff 45 08             	incl   0x8(%ebp)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	75 f1                	jne    8012d3 <strlen+0xf>
		n++;
	return n;
  8012e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f4:	eb 09                	jmp    8012ff <strnlen+0x18>
		n++;
  8012f6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f9:	ff 45 08             	incl   0x8(%ebp)
  8012fc:	ff 4d 0c             	decl   0xc(%ebp)
  8012ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801303:	74 09                	je     80130e <strnlen+0x27>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	75 e8                	jne    8012f6 <strnlen+0xf>
		n++;
	return n;
  80130e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80131f:	90                   	nop
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8d 50 01             	lea    0x1(%eax),%edx
  801326:	89 55 08             	mov    %edx,0x8(%ebp)
  801329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80132f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801332:	8a 12                	mov    (%edx),%dl
  801334:	88 10                	mov    %dl,(%eax)
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 e4                	jne    801320 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80134d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801354:	eb 1f                	jmp    801375 <strncpy+0x34>
		*dst++ = *src;
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8d 50 01             	lea    0x1(%eax),%edx
  80135c:	89 55 08             	mov    %edx,0x8(%ebp)
  80135f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801362:	8a 12                	mov    (%edx),%dl
  801364:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	8a 00                	mov    (%eax),%al
  80136b:	84 c0                	test   %al,%al
  80136d:	74 03                	je     801372 <strncpy+0x31>
			src++;
  80136f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801372:	ff 45 fc             	incl   -0x4(%ebp)
  801375:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801378:	3b 45 10             	cmp    0x10(%ebp),%eax
  80137b:	72 d9                	jb     801356 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80137d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80138e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801392:	74 30                	je     8013c4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801394:	eb 16                	jmp    8013ac <strlcpy+0x2a>
			*dst++ = *src++;
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8d 50 01             	lea    0x1(%eax),%edx
  80139c:	89 55 08             	mov    %edx,0x8(%ebp)
  80139f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a8:	8a 12                	mov    (%edx),%dl
  8013aa:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013ac:	ff 4d 10             	decl   0x10(%ebp)
  8013af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b3:	74 09                	je     8013be <strlcpy+0x3c>
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	8a 00                	mov    (%eax),%al
  8013ba:	84 c0                	test   %al,%al
  8013bc:	75 d8                	jne    801396 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ca:	29 c2                	sub    %eax,%edx
  8013cc:	89 d0                	mov    %edx,%eax
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013d3:	eb 06                	jmp    8013db <strcmp+0xb>
		p++, q++;
  8013d5:	ff 45 08             	incl   0x8(%ebp)
  8013d8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 0e                	je     8013f2 <strcmp+0x22>
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 10                	mov    (%eax),%dl
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	38 c2                	cmp    %al,%dl
  8013f0:	74 e3                	je     8013d5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 d0             	movzbl %al,%edx
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	0f b6 c0             	movzbl %al,%eax
  801402:	29 c2                	sub    %eax,%edx
  801404:	89 d0                	mov    %edx,%eax
}
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80140b:	eb 09                	jmp    801416 <strncmp+0xe>
		n--, p++, q++;
  80140d:	ff 4d 10             	decl   0x10(%ebp)
  801410:	ff 45 08             	incl   0x8(%ebp)
  801413:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801416:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141a:	74 17                	je     801433 <strncmp+0x2b>
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	84 c0                	test   %al,%al
  801423:	74 0e                	je     801433 <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 10                	mov    (%eax),%dl
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	38 c2                	cmp    %al,%dl
  801431:	74 da                	je     80140d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801433:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801437:	75 07                	jne    801440 <strncmp+0x38>
		return 0;
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
  80143e:	eb 14                	jmp    801454 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 d0             	movzbl %al,%edx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	0f b6 c0             	movzbl %al,%eax
  801450:	29 c2                	sub    %eax,%edx
  801452:	89 d0                	mov    %edx,%eax
}
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    

00801456 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801462:	eb 12                	jmp    801476 <strchr+0x20>
		if (*s == c)
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80146c:	75 05                	jne    801473 <strchr+0x1d>
			return (char *) s;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	eb 11                	jmp    801484 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	84 c0                	test   %al,%al
  80147d:	75 e5                	jne    801464 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80147f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801492:	eb 0d                	jmp    8014a1 <strfind+0x1b>
		if (*s == c)
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80149c:	74 0e                	je     8014ac <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80149e:	ff 45 08             	incl   0x8(%ebp)
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	84 c0                	test   %al,%al
  8014a8:	75 ea                	jne    801494 <strfind+0xe>
  8014aa:	eb 01                	jmp    8014ad <strfind+0x27>
		if (*s == c)
			break;
  8014ac:	90                   	nop
	return (char *) s;
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014c4:	eb 0e                	jmp    8014d4 <memset+0x22>
		*p++ = c;
  8014c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c9:	8d 50 01             	lea    0x1(%eax),%edx
  8014cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014d4:	ff 4d f8             	decl   -0x8(%ebp)
  8014d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014db:	79 e9                	jns    8014c6 <memset+0x14>
		*p++ = c;

	return v;
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014f4:	eb 16                	jmp    80150c <memcpy+0x2a>
		*d++ = *s++;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f9:	8d 50 01             	lea    0x1(%eax),%edx
  8014fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801502:	8d 4a 01             	lea    0x1(%edx),%ecx
  801505:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801508:	8a 12                	mov    (%edx),%dl
  80150a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801512:	89 55 10             	mov    %edx,0x10(%ebp)
  801515:	85 c0                	test   %eax,%eax
  801517:	75 dd                	jne    8014f6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801530:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801533:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801536:	73 50                	jae    801588 <memmove+0x6a>
  801538:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	01 d0                	add    %edx,%eax
  801540:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801543:	76 43                	jbe    801588 <memmove+0x6a>
		s += n;
  801545:	8b 45 10             	mov    0x10(%ebp),%eax
  801548:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80154b:	8b 45 10             	mov    0x10(%ebp),%eax
  80154e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801551:	eb 10                	jmp    801563 <memmove+0x45>
			*--d = *--s;
  801553:	ff 4d f8             	decl   -0x8(%ebp)
  801556:	ff 4d fc             	decl   -0x4(%ebp)
  801559:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155c:	8a 10                	mov    (%eax),%dl
  80155e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801561:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
  801566:	8d 50 ff             	lea    -0x1(%eax),%edx
  801569:	89 55 10             	mov    %edx,0x10(%ebp)
  80156c:	85 c0                	test   %eax,%eax
  80156e:	75 e3                	jne    801553 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801570:	eb 23                	jmp    801595 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801575:	8d 50 01             	lea    0x1(%eax),%edx
  801578:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80157b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801581:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801584:	8a 12                	mov    (%edx),%dl
  801586:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80158e:	89 55 10             	mov    %edx,0x10(%ebp)
  801591:	85 c0                	test   %eax,%eax
  801593:	75 dd                	jne    801572 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015ac:	eb 2a                	jmp    8015d8 <memcmp+0x3e>
		if (*s1 != *s2)
  8015ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b1:	8a 10                	mov    (%eax),%dl
  8015b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	38 c2                	cmp    %al,%dl
  8015ba:	74 16                	je     8015d2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 d0             	movzbl %al,%edx
  8015c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	0f b6 c0             	movzbl %al,%eax
  8015cc:	29 c2                	sub    %eax,%edx
  8015ce:	89 d0                	mov    %edx,%eax
  8015d0:	eb 18                	jmp    8015ea <memcmp+0x50>
		s1++, s2++;
  8015d2:	ff 45 fc             	incl   -0x4(%ebp)
  8015d5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015de:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	75 c9                	jne    8015ae <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f8:	01 d0                	add    %edx,%eax
  8015fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015fd:	eb 15                	jmp    801614 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	0f b6 d0             	movzbl %al,%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	0f b6 c0             	movzbl %al,%eax
  80160d:	39 c2                	cmp    %eax,%edx
  80160f:	74 0d                	je     80161e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801611:	ff 45 08             	incl   0x8(%ebp)
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80161a:	72 e3                	jb     8015ff <memfind+0x13>
  80161c:	eb 01                	jmp    80161f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80161e:	90                   	nop
	return (void *) s;
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80162a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801631:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801638:	eb 03                	jmp    80163d <strtol+0x19>
		s++;
  80163a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	3c 20                	cmp    $0x20,%al
  801644:	74 f4                	je     80163a <strtol+0x16>
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 09                	cmp    $0x9,%al
  80164d:	74 eb                	je     80163a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 2b                	cmp    $0x2b,%al
  801656:	75 05                	jne    80165d <strtol+0x39>
		s++;
  801658:	ff 45 08             	incl   0x8(%ebp)
  80165b:	eb 13                	jmp    801670 <strtol+0x4c>
	else if (*s == '-')
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	3c 2d                	cmp    $0x2d,%al
  801664:	75 0a                	jne    801670 <strtol+0x4c>
		s++, neg = 1;
  801666:	ff 45 08             	incl   0x8(%ebp)
  801669:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801670:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801674:	74 06                	je     80167c <strtol+0x58>
  801676:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80167a:	75 20                	jne    80169c <strtol+0x78>
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	3c 30                	cmp    $0x30,%al
  801683:	75 17                	jne    80169c <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	40                   	inc    %eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 78                	cmp    $0x78,%al
  80168d:	75 0d                	jne    80169c <strtol+0x78>
		s += 2, base = 16;
  80168f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801693:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80169a:	eb 28                	jmp    8016c4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80169c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a0:	75 15                	jne    8016b7 <strtol+0x93>
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	3c 30                	cmp    $0x30,%al
  8016a9:	75 0c                	jne    8016b7 <strtol+0x93>
		s++, base = 8;
  8016ab:	ff 45 08             	incl   0x8(%ebp)
  8016ae:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016b5:	eb 0d                	jmp    8016c4 <strtol+0xa0>
	else if (base == 0)
  8016b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016bb:	75 07                	jne    8016c4 <strtol+0xa0>
		base = 10;
  8016bd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	8a 00                	mov    (%eax),%al
  8016c9:	3c 2f                	cmp    $0x2f,%al
  8016cb:	7e 19                	jle    8016e6 <strtol+0xc2>
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 39                	cmp    $0x39,%al
  8016d4:	7f 10                	jg     8016e6 <strtol+0xc2>
			dig = *s - '0';
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	0f be c0             	movsbl %al,%eax
  8016de:	83 e8 30             	sub    $0x30,%eax
  8016e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e4:	eb 42                	jmp    801728 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	3c 60                	cmp    $0x60,%al
  8016ed:	7e 19                	jle    801708 <strtol+0xe4>
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 7a                	cmp    $0x7a,%al
  8016f6:	7f 10                	jg     801708 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	0f be c0             	movsbl %al,%eax
  801700:	83 e8 57             	sub    $0x57,%eax
  801703:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801706:	eb 20                	jmp    801728 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	8a 00                	mov    (%eax),%al
  80170d:	3c 40                	cmp    $0x40,%al
  80170f:	7e 39                	jle    80174a <strtol+0x126>
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 5a                	cmp    $0x5a,%al
  801718:	7f 30                	jg     80174a <strtol+0x126>
			dig = *s - 'A' + 10;
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	0f be c0             	movsbl %al,%eax
  801722:	83 e8 37             	sub    $0x37,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80172e:	7d 19                	jge    801749 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801730:	ff 45 08             	incl   0x8(%ebp)
  801733:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801736:	0f af 45 10          	imul   0x10(%ebp),%eax
  80173a:	89 c2                	mov    %eax,%edx
  80173c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173f:	01 d0                	add    %edx,%eax
  801741:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801744:	e9 7b ff ff ff       	jmp    8016c4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801749:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80174a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174e:	74 08                	je     801758 <strtol+0x134>
		*endptr = (char *) s;
  801750:	8b 45 0c             	mov    0xc(%ebp),%eax
  801753:	8b 55 08             	mov    0x8(%ebp),%edx
  801756:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801758:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80175c:	74 07                	je     801765 <strtol+0x141>
  80175e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801761:	f7 d8                	neg    %eax
  801763:	eb 03                	jmp    801768 <strtol+0x144>
  801765:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <ltostr>:

void
ltostr(long value, char *str)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801770:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801777:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80177e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801782:	79 13                	jns    801797 <ltostr+0x2d>
	{
		neg = 1;
  801784:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80178b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801791:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801794:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80179f:	99                   	cltd   
  8017a0:	f7 f9                	idiv   %ecx
  8017a2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a8:	8d 50 01             	lea    0x1(%eax),%edx
  8017ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ae:	89 c2                	mov    %eax,%edx
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b8:	83 c2 30             	add    $0x30,%edx
  8017bb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017c5:	f7 e9                	imul   %ecx
  8017c7:	c1 fa 02             	sar    $0x2,%edx
  8017ca:	89 c8                	mov    %ecx,%eax
  8017cc:	c1 f8 1f             	sar    $0x1f,%eax
  8017cf:	29 c2                	sub    %eax,%edx
  8017d1:	89 d0                	mov    %edx,%eax
  8017d3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017de:	f7 e9                	imul   %ecx
  8017e0:	c1 fa 02             	sar    $0x2,%edx
  8017e3:	89 c8                	mov    %ecx,%eax
  8017e5:	c1 f8 1f             	sar    $0x1f,%eax
  8017e8:	29 c2                	sub    %eax,%edx
  8017ea:	89 d0                	mov    %edx,%eax
  8017ec:	c1 e0 02             	shl    $0x2,%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	01 c0                	add    %eax,%eax
  8017f3:	29 c1                	sub    %eax,%ecx
  8017f5:	89 ca                	mov    %ecx,%edx
  8017f7:	85 d2                	test   %edx,%edx
  8017f9:	75 9c                	jne    801797 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801802:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801805:	48                   	dec    %eax
  801806:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801809:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80180d:	74 3d                	je     80184c <ltostr+0xe2>
		start = 1 ;
  80180f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801816:	eb 34                	jmp    80184c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181e:	01 d0                	add    %edx,%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c2                	add    %eax,%edx
  80182d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	01 c8                	add    %ecx,%eax
  801835:	8a 00                	mov    (%eax),%al
  801837:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801839:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80183c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183f:	01 c2                	add    %eax,%edx
  801841:	8a 45 eb             	mov    -0x15(%ebp),%al
  801844:	88 02                	mov    %al,(%edx)
		start++ ;
  801846:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801849:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801852:	7c c4                	jl     801818 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801854:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80185f:	90                   	nop
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	e8 54 fa ff ff       	call   8012c4 <strlen>
  801870:	83 c4 04             	add    $0x4,%esp
  801873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801876:	ff 75 0c             	pushl  0xc(%ebp)
  801879:	e8 46 fa ff ff       	call   8012c4 <strlen>
  80187e:	83 c4 04             	add    $0x4,%esp
  801881:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801884:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80188b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801892:	eb 17                	jmp    8018ab <strcconcat+0x49>
		final[s] = str1[s] ;
  801894:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801897:	8b 45 10             	mov    0x10(%ebp),%eax
  80189a:	01 c2                	add    %eax,%edx
  80189c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	01 c8                	add    %ecx,%eax
  8018a4:	8a 00                	mov    (%eax),%al
  8018a6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a8:	ff 45 fc             	incl   -0x4(%ebp)
  8018ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018b1:	7c e1                	jl     801894 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018c1:	eb 1f                	jmp    8018e2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c6:	8d 50 01             	lea    0x1(%eax),%edx
  8018c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018cc:	89 c2                	mov    %eax,%edx
  8018ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d1:	01 c2                	add    %eax,%edx
  8018d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d9:	01 c8                	add    %ecx,%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018df:	ff 45 f8             	incl   -0x8(%ebp)
  8018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e8:	7c d9                	jl     8018c3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f0:	01 d0                	add    %edx,%eax
  8018f2:	c6 00 00             	movb   $0x0,(%eax)
}
  8018f5:	90                   	nop
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	8b 00                	mov    (%eax),%eax
  801909:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801910:	8b 45 10             	mov    0x10(%ebp),%eax
  801913:	01 d0                	add    %edx,%eax
  801915:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80191b:	eb 0c                	jmp    801929 <strsplit+0x31>
			*string++ = 0;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8d 50 01             	lea    0x1(%eax),%edx
  801923:	89 55 08             	mov    %edx,0x8(%ebp)
  801926:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8a 00                	mov    (%eax),%al
  80192e:	84 c0                	test   %al,%al
  801930:	74 18                	je     80194a <strsplit+0x52>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	0f be c0             	movsbl %al,%eax
  80193a:	50                   	push   %eax
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	e8 13 fb ff ff       	call   801456 <strchr>
  801943:	83 c4 08             	add    $0x8,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	75 d3                	jne    80191d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	8a 00                	mov    (%eax),%al
  80194f:	84 c0                	test   %al,%al
  801951:	74 5a                	je     8019ad <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801953:	8b 45 14             	mov    0x14(%ebp),%eax
  801956:	8b 00                	mov    (%eax),%eax
  801958:	83 f8 0f             	cmp    $0xf,%eax
  80195b:	75 07                	jne    801964 <strsplit+0x6c>
		{
			return 0;
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	eb 66                	jmp    8019ca <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801964:	8b 45 14             	mov    0x14(%ebp),%eax
  801967:	8b 00                	mov    (%eax),%eax
  801969:	8d 48 01             	lea    0x1(%eax),%ecx
  80196c:	8b 55 14             	mov    0x14(%ebp),%edx
  80196f:	89 0a                	mov    %ecx,(%edx)
  801971:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801978:	8b 45 10             	mov    0x10(%ebp),%eax
  80197b:	01 c2                	add    %eax,%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801982:	eb 03                	jmp    801987 <strsplit+0x8f>
			string++;
  801984:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	8a 00                	mov    (%eax),%al
  80198c:	84 c0                	test   %al,%al
  80198e:	74 8b                	je     80191b <strsplit+0x23>
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	0f be c0             	movsbl %al,%eax
  801998:	50                   	push   %eax
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	e8 b5 fa ff ff       	call   801456 <strchr>
  8019a1:	83 c4 08             	add    $0x8,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	74 dc                	je     801984 <strsplit+0x8c>
			string++;
	}
  8019a8:	e9 6e ff ff ff       	jmp    80191b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019ad:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b1:	8b 00                	mov    (%eax),%eax
  8019b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bd:	01 d0                	add    %edx,%eax
  8019bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8019d2:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8019d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019dc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8019df:	01 d0                	add    %edx,%eax
  8019e1:	48                   	dec    %eax
  8019e2:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8019e5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ed:	f7 75 ac             	divl   -0x54(%ebp)
  8019f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019f3:	29 d0                	sub    %edx,%eax
  8019f5:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8019f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8019ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801a06:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a14:	eb 3f                	jmp    801a55 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a19:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	50                   	push   %eax
  801a24:	ff 75 e8             	pushl  -0x18(%ebp)
  801a27:	68 64 30 80 00       	push   $0x803064
  801a2c:	e8 0b f0 ff ff       	call   800a3c <cprintf>
  801a31:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a37:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	50                   	push   %eax
  801a42:	ff 75 e8             	pushl  -0x18(%ebp)
  801a45:	68 79 30 80 00       	push   $0x803079
  801a4a:	e8 ed ef ff ff       	call   800a3c <cprintf>
  801a4f:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801a52:	ff 45 e8             	incl   -0x18(%ebp)
  801a55:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a5a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801a5d:	7c b7                	jl     801a16 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a5f:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801a66:	e9 35 01 00 00       	jmp    801ba0 <malloc+0x1d4>
		int flag0=1;
  801a6b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a75:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a78:	eb 5e                	jmp    801ad8 <malloc+0x10c>
			for(int k=0;k<count;k++){
  801a7a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a81:	eb 35                	jmp    801ab8 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a86:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801a8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a90:	39 c2                	cmp    %eax,%edx
  801a92:	77 21                	ja     801ab5 <malloc+0xe9>
  801a94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a97:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801a9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa1:	39 c2                	cmp    %eax,%edx
  801aa3:	76 10                	jbe    801ab5 <malloc+0xe9>
					ni=PAGE_SIZE;
  801aa5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  801aac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801ab3:	eb 0d                	jmp    801ac2 <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801ab5:	ff 45 d8             	incl   -0x28(%ebp)
  801ab8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801abd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ac0:	7c c1                	jl     801a83 <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801ac2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ac6:	74 09                	je     801ad1 <malloc+0x105>
				flag0=0;
  801ac8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801acf:	eb 16                	jmp    801ae7 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801ad1:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801ad8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	01 c2                	add    %eax,%edx
  801ae0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ae3:	39 c2                	cmp    %eax,%edx
  801ae5:	77 93                	ja     801a7a <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	0f 84 a2 00 00 00    	je     801b93 <malloc+0x1c7>

			int f=1;
  801af1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801af8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801afb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801afe:	89 c8                	mov    %ecx,%eax
  801b00:	01 c0                	add    %eax,%eax
  801b02:	01 c8                	add    %ecx,%eax
  801b04:	c1 e0 02             	shl    $0x2,%eax
  801b07:	05 20 41 80 00       	add    $0x804120,%eax
  801b0c:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801b0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1a:	89 d0                	mov    %edx,%eax
  801b1c:	01 c0                	add    %eax,%eax
  801b1e:	01 d0                	add    %edx,%eax
  801b20:	c1 e0 02             	shl    $0x2,%eax
  801b23:	05 24 41 80 00       	add    $0x804124,%eax
  801b28:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2d:	89 d0                	mov    %edx,%eax
  801b2f:	01 c0                	add    %eax,%eax
  801b31:	01 d0                	add    %edx,%eax
  801b33:	c1 e0 02             	shl    $0x2,%eax
  801b36:	05 28 41 80 00       	add    $0x804128,%eax
  801b3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801b41:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801b44:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801b4b:	eb 36                	jmp    801b83 <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  801b4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	01 c2                	add    %eax,%edx
  801b55:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b58:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801b5f:	39 c2                	cmp    %eax,%edx
  801b61:	73 1d                	jae    801b80 <malloc+0x1b4>
					ni=arr_add[l].end-i;
  801b63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b66:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b70:	29 c2                	sub    %eax,%edx
  801b72:	89 d0                	mov    %edx,%eax
  801b74:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801b77:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801b7e:	eb 0d                	jmp    801b8d <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801b80:	ff 45 d0             	incl   -0x30(%ebp)
  801b83:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b88:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801b8b:	7c c0                	jl     801b4d <malloc+0x181>
					break;

				}
			}

			if(f){
  801b8d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801b91:	75 1d                	jne    801bb0 <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  801b93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9d:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801ba0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ba5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba8:	0f 8c bd fe ff ff    	jl     801a6b <malloc+0x9f>
  801bae:	eb 01                	jmp    801bb1 <malloc+0x1e5>

				}
			}

			if(f){
				break;
  801bb0:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801bb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb5:	75 7a                	jne    801c31 <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801bb7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	01 d0                	add    %edx,%eax
  801bc2:	48                   	dec    %eax
  801bc3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bc8:	7c 0a                	jl     801bd4 <malloc+0x208>
			return NULL;
  801bca:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcf:	e9 a4 02 00 00       	jmp    801e78 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  801bd4:	a1 04 40 80 00       	mov    0x804004,%eax
  801bd9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801bdc:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801be1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801be4:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801beb:	83 ec 08             	sub    $0x8,%esp
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	ff 75 a4             	pushl  -0x5c(%ebp)
  801bf4:	e8 04 06 00 00       	call   8021fd <sys_allocateMem>
  801bf9:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801bfc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	01 d0                	add    %edx,%eax
  801c07:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801c0c:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c11:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c17:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801c1e:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c23:	40                   	inc    %eax
  801c24:	a3 2c 40 80 00       	mov    %eax,0x80402c

			return (void*)s;
  801c29:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801c2c:	e9 47 02 00 00       	jmp    801e78 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  801c31:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801c38:	e9 ac 00 00 00       	jmp    801ce9 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801c3d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c40:	89 d0                	mov    %edx,%eax
  801c42:	01 c0                	add    %eax,%eax
  801c44:	01 d0                	add    %edx,%eax
  801c46:	c1 e0 02             	shl    $0x2,%eax
  801c49:	05 24 41 80 00       	add    $0x804124,%eax
  801c4e:	8b 00                	mov    (%eax),%eax
  801c50:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c53:	eb 7e                	jmp    801cd3 <malloc+0x307>
			int flag=0;
  801c55:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801c5c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801c63:	eb 57                	jmp    801cbc <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801c65:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c68:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c72:	39 c2                	cmp    %eax,%edx
  801c74:	77 1a                	ja     801c90 <malloc+0x2c4>
  801c76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c79:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c83:	39 c2                	cmp    %eax,%edx
  801c85:	76 09                	jbe    801c90 <malloc+0x2c4>
								flag=1;
  801c87:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801c8e:	eb 36                	jmp    801cc6 <malloc+0x2fa>
			arr[i].space++;
  801c90:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c93:	89 d0                	mov    %edx,%eax
  801c95:	01 c0                	add    %eax,%eax
  801c97:	01 d0                	add    %edx,%eax
  801c99:	c1 e0 02             	shl    $0x2,%eax
  801c9c:	05 28 41 80 00       	add    $0x804128,%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 48 01             	lea    0x1(%eax),%ecx
  801ca6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	01 c0                	add    %eax,%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c1 e0 02             	shl    $0x2,%eax
  801cb2:	05 28 41 80 00       	add    $0x804128,%eax
  801cb7:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801cb9:	ff 45 c0             	incl   -0x40(%ebp)
  801cbc:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801cc1:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801cc4:	7c 9f                	jl     801c65 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801cc6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801cca:	75 19                	jne    801ce5 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801ccc:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801cd3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801cd6:	a1 04 40 80 00       	mov    0x804004,%eax
  801cdb:	39 c2                	cmp    %eax,%edx
  801cdd:	0f 82 72 ff ff ff    	jb     801c55 <malloc+0x289>
  801ce3:	eb 01                	jmp    801ce6 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801ce5:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801ce6:	ff 45 cc             	incl   -0x34(%ebp)
  801ce9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cef:	0f 8c 48 ff ff ff    	jl     801c3d <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801cf5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801cfc:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801d03:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801d0a:	eb 37                	jmp    801d43 <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801d0c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	01 c0                	add    %eax,%eax
  801d13:	01 d0                	add    %edx,%eax
  801d15:	c1 e0 02             	shl    $0x2,%eax
  801d18:	05 28 41 80 00       	add    $0x804128,%eax
  801d1d:	8b 00                	mov    (%eax),%eax
  801d1f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801d22:	7d 1c                	jge    801d40 <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801d24:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d27:	89 d0                	mov    %edx,%eax
  801d29:	01 c0                	add    %eax,%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	c1 e0 02             	shl    $0x2,%eax
  801d30:	05 28 41 80 00       	add    $0x804128,%eax
  801d35:	8b 00                	mov    (%eax),%eax
  801d37:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801d3a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801d40:	ff 45 b4             	incl   -0x4c(%ebp)
  801d43:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d46:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d49:	7c c1                	jl     801d0c <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801d4b:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801d51:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d54:	89 c8                	mov    %ecx,%eax
  801d56:	01 c0                	add    %eax,%eax
  801d58:	01 c8                	add    %ecx,%eax
  801d5a:	c1 e0 02             	shl    $0x2,%eax
  801d5d:	05 20 41 80 00       	add    $0x804120,%eax
  801d62:	8b 00                	mov    (%eax),%eax
  801d64:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801d6b:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801d71:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d74:	89 c8                	mov    %ecx,%eax
  801d76:	01 c0                	add    %eax,%eax
  801d78:	01 c8                	add    %ecx,%eax
  801d7a:	c1 e0 02             	shl    $0x2,%eax
  801d7d:	05 24 41 80 00       	add    $0x804124,%eax
  801d82:	8b 00                	mov    (%eax),%eax
  801d84:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801d8b:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d90:	40                   	inc    %eax
  801d91:	a3 2c 40 80 00       	mov    %eax,0x80402c


		sys_allocateMem(arr[index].start,size);
  801d96:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d99:	89 d0                	mov    %edx,%eax
  801d9b:	01 c0                	add    %eax,%eax
  801d9d:	01 d0                	add    %edx,%eax
  801d9f:	c1 e0 02             	shl    $0x2,%eax
  801da2:	05 20 41 80 00       	add    $0x804120,%eax
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	83 ec 08             	sub    $0x8,%esp
  801dac:	ff 75 08             	pushl  0x8(%ebp)
  801daf:	50                   	push   %eax
  801db0:	e8 48 04 00 00       	call   8021fd <sys_allocateMem>
  801db5:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801db8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801dbf:	eb 78                	jmp    801e39 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801dc1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	01 c0                	add    %eax,%eax
  801dc8:	01 d0                	add    %edx,%eax
  801dca:	c1 e0 02             	shl    $0x2,%eax
  801dcd:	05 20 41 80 00       	add    $0x804120,%eax
  801dd2:	8b 00                	mov    (%eax),%eax
  801dd4:	83 ec 04             	sub    $0x4,%esp
  801dd7:	50                   	push   %eax
  801dd8:	ff 75 b0             	pushl  -0x50(%ebp)
  801ddb:	68 64 30 80 00       	push   $0x803064
  801de0:	e8 57 ec ff ff       	call   800a3c <cprintf>
  801de5:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801de8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	01 c0                	add    %eax,%eax
  801def:	01 d0                	add    %edx,%eax
  801df1:	c1 e0 02             	shl    $0x2,%eax
  801df4:	05 24 41 80 00       	add    $0x804124,%eax
  801df9:	8b 00                	mov    (%eax),%eax
  801dfb:	83 ec 04             	sub    $0x4,%esp
  801dfe:	50                   	push   %eax
  801dff:	ff 75 b0             	pushl  -0x50(%ebp)
  801e02:	68 79 30 80 00       	push   $0x803079
  801e07:	e8 30 ec ff ff       	call   800a3c <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801e0f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e12:	89 d0                	mov    %edx,%eax
  801e14:	01 c0                	add    %eax,%eax
  801e16:	01 d0                	add    %edx,%eax
  801e18:	c1 e0 02             	shl    $0x2,%eax
  801e1b:	05 28 41 80 00       	add    $0x804128,%eax
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	83 ec 04             	sub    $0x4,%esp
  801e25:	50                   	push   %eax
  801e26:	ff 75 b0             	pushl  -0x50(%ebp)
  801e29:	68 8c 30 80 00       	push   $0x80308c
  801e2e:	e8 09 ec ff ff       	call   800a3c <cprintf>
  801e33:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801e36:	ff 45 b0             	incl   -0x50(%ebp)
  801e39:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e3f:	7c 80                	jl     801dc1 <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801e41:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e44:	89 d0                	mov    %edx,%eax
  801e46:	01 c0                	add    %eax,%eax
  801e48:	01 d0                	add    %edx,%eax
  801e4a:	c1 e0 02             	shl    $0x2,%eax
  801e4d:	05 20 41 80 00       	add    $0x804120,%eax
  801e52:	8b 00                	mov    (%eax),%eax
  801e54:	83 ec 08             	sub    $0x8,%esp
  801e57:	50                   	push   %eax
  801e58:	68 a0 30 80 00       	push   $0x8030a0
  801e5d:	e8 da eb ff ff       	call   800a3c <cprintf>
  801e62:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801e65:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e68:	89 d0                	mov    %edx,%eax
  801e6a:	01 c0                	add    %eax,%eax
  801e6c:	01 d0                	add    %edx,%eax
  801e6e:	c1 e0 02             	shl    $0x2,%eax
  801e71:	05 20 41 80 00       	add    $0x804120,%eax
  801e76:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801e86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e8d:	eb 4b                	jmp    801eda <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e92:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e99:	89 c2                	mov    %eax,%edx
  801e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9e:	39 c2                	cmp    %eax,%edx
  801ea0:	7f 35                	jg     801ed7 <free+0x5d>
  801ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea5:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801eac:	89 c2                	mov    %eax,%edx
  801eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eb1:	39 c2                	cmp    %eax,%edx
  801eb3:	7e 22                	jle    801ed7 <free+0x5d>
				start=arr_add[i].start;
  801eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb8:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec5:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ecc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801ed5:	eb 0d                	jmp    801ee4 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801ed7:	ff 45 ec             	incl   -0x14(%ebp)
  801eda:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801edf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801ee2:	7c ab                	jl     801e8f <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef1:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ef8:	29 c2                	sub    %eax,%edx
  801efa:	89 d0                	mov    %edx,%eax
  801efc:	83 ec 08             	sub    $0x8,%esp
  801eff:	50                   	push   %eax
  801f00:	ff 75 f4             	pushl  -0xc(%ebp)
  801f03:	e8 d9 02 00 00       	call   8021e1 <sys_freeMem>
  801f08:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f11:	eb 2d                	jmp    801f40 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f16:	40                   	inc    %eax
  801f17:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f21:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801f28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f2b:	40                   	inc    %eax
  801f2c:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f36:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801f3d:	ff 45 e8             	incl   -0x18(%ebp)
  801f40:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801f45:	48                   	dec    %eax
  801f46:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f49:	7f c8                	jg     801f13 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801f4b:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801f50:	48                   	dec    %eax
  801f51:	a3 2c 40 80 00       	mov    %eax,0x80402c
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801f56:	90                   	nop
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 18             	sub    $0x18,%esp
  801f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f62:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f65:	83 ec 04             	sub    $0x4,%esp
  801f68:	68 bc 30 80 00       	push   $0x8030bc
  801f6d:	68 18 01 00 00       	push   $0x118
  801f72:	68 df 30 80 00       	push   $0x8030df
  801f77:	e8 1e e8 ff ff       	call   80079a <_panic>

00801f7c <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	68 bc 30 80 00       	push   $0x8030bc
  801f8a:	68 1e 01 00 00       	push   $0x11e
  801f8f:	68 df 30 80 00       	push   $0x8030df
  801f94:	e8 01 e8 ff ff       	call   80079a <_panic>

00801f99 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	68 bc 30 80 00       	push   $0x8030bc
  801fa7:	68 24 01 00 00       	push   $0x124
  801fac:	68 df 30 80 00       	push   $0x8030df
  801fb1:	e8 e4 e7 ff ff       	call   80079a <_panic>

00801fb6 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	68 bc 30 80 00       	push   $0x8030bc
  801fc4:	68 29 01 00 00       	push   $0x129
  801fc9:	68 df 30 80 00       	push   $0x8030df
  801fce:	e8 c7 e7 ff ff       	call   80079a <_panic>

00801fd3 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fd9:	83 ec 04             	sub    $0x4,%esp
  801fdc:	68 bc 30 80 00       	push   $0x8030bc
  801fe1:	68 2f 01 00 00       	push   $0x12f
  801fe6:	68 df 30 80 00       	push   $0x8030df
  801feb:	e8 aa e7 ff ff       	call   80079a <_panic>

00801ff0 <shrink>:
}
void shrink(uint32 newSize)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	68 bc 30 80 00       	push   $0x8030bc
  801ffe:	68 33 01 00 00       	push   $0x133
  802003:	68 df 30 80 00       	push   $0x8030df
  802008:	e8 8d e7 ff ff       	call   80079a <_panic>

0080200d <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	68 bc 30 80 00       	push   $0x8030bc
  80201b:	68 38 01 00 00       	push   $0x138
  802020:	68 df 30 80 00       	push   $0x8030df
  802025:	e8 70 e7 ff ff       	call   80079a <_panic>

0080202a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	57                   	push   %edi
  80202e:	56                   	push   %esi
  80202f:	53                   	push   %ebx
  802030:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	8b 55 0c             	mov    0xc(%ebp),%edx
  802039:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80203f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802042:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802045:	cd 30                	int    $0x30
  802047:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80204d:	83 c4 10             	add    $0x10,%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5f                   	pop    %edi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    

00802055 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	8b 45 10             	mov    0x10(%ebp),%eax
  80205e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802061:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	52                   	push   %edx
  80206d:	ff 75 0c             	pushl  0xc(%ebp)
  802070:	50                   	push   %eax
  802071:	6a 00                	push   $0x0
  802073:	e8 b2 ff ff ff       	call   80202a <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	90                   	nop
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_cgetc>:

int
sys_cgetc(void)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 01                	push   $0x1
  80208d:	e8 98 ff ff ff       	call   80202a <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	50                   	push   %eax
  8020a6:	6a 05                	push   $0x5
  8020a8:	e8 7d ff ff ff       	call   80202a <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 02                	push   $0x2
  8020c1:	e8 64 ff ff ff       	call   80202a <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 03                	push   $0x3
  8020da:	e8 4b ff ff ff       	call   80202a <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 04                	push   $0x4
  8020f3:	e8 32 ff ff ff       	call   80202a <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_env_exit>:


void sys_env_exit(void)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 06                	push   $0x6
  80210c:	e8 19 ff ff ff       	call   80202a <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	90                   	nop
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80211a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	52                   	push   %edx
  802127:	50                   	push   %eax
  802128:	6a 07                	push   $0x7
  80212a:	e8 fb fe ff ff       	call   80202a <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	56                   	push   %esi
  802138:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802139:	8b 75 18             	mov    0x18(%ebp),%esi
  80213c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802142:	8b 55 0c             	mov    0xc(%ebp),%edx
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	56                   	push   %esi
  802149:	53                   	push   %ebx
  80214a:	51                   	push   %ecx
  80214b:	52                   	push   %edx
  80214c:	50                   	push   %eax
  80214d:	6a 08                	push   $0x8
  80214f:	e8 d6 fe ff ff       	call   80202a <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215a:	5b                   	pop    %ebx
  80215b:	5e                   	pop    %esi
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    

0080215e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802161:	8b 55 0c             	mov    0xc(%ebp),%edx
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	52                   	push   %edx
  80216e:	50                   	push   %eax
  80216f:	6a 09                	push   $0x9
  802171:	e8 b4 fe ff ff       	call   80202a <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	ff 75 0c             	pushl  0xc(%ebp)
  802187:	ff 75 08             	pushl  0x8(%ebp)
  80218a:	6a 0a                	push   $0xa
  80218c:	e8 99 fe ff ff       	call   80202a <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 0b                	push   $0xb
  8021a5:	e8 80 fe ff ff       	call   80202a <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 0c                	push   $0xc
  8021be:	e8 67 fe ff ff       	call   80202a <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 0d                	push   $0xd
  8021d7:	e8 4e fe ff ff       	call   80202a <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	ff 75 0c             	pushl  0xc(%ebp)
  8021ed:	ff 75 08             	pushl  0x8(%ebp)
  8021f0:	6a 11                	push   $0x11
  8021f2:	e8 33 fe ff ff       	call   80202a <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
	return;
  8021fa:	90                   	nop
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	ff 75 0c             	pushl  0xc(%ebp)
  802209:	ff 75 08             	pushl  0x8(%ebp)
  80220c:	6a 12                	push   $0x12
  80220e:	e8 17 fe ff ff       	call   80202a <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
	return ;
  802216:	90                   	nop
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 0e                	push   $0xe
  802228:	e8 fd fd ff ff       	call   80202a <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	6a 0f                	push   $0xf
  802242:	e8 e3 fd ff ff       	call   80202a <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 10                	push   $0x10
  80225b:	e8 ca fd ff ff       	call   80202a <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 14                	push   $0x14
  802275:	e8 b0 fd ff ff       	call   80202a <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
}
  80227d:	90                   	nop
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 15                	push   $0x15
  80228f:	e8 96 fd ff ff       	call   80202a <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	90                   	nop
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_cputc>:


void
sys_cputc(const char c)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	50                   	push   %eax
  8022b3:	6a 16                	push   $0x16
  8022b5:	e8 70 fd ff ff       	call   80202a <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 17                	push   $0x17
  8022cf:	e8 56 fd ff ff       	call   80202a <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	90                   	nop
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	ff 75 0c             	pushl  0xc(%ebp)
  8022e9:	50                   	push   %eax
  8022ea:	6a 18                	push   $0x18
  8022ec:	e8 39 fd ff ff       	call   80202a <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	52                   	push   %edx
  802306:	50                   	push   %eax
  802307:	6a 1b                	push   $0x1b
  802309:	e8 1c fd ff ff       	call   80202a <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802316:	8b 55 0c             	mov    0xc(%ebp),%edx
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	52                   	push   %edx
  802323:	50                   	push   %eax
  802324:	6a 19                	push   $0x19
  802326:	e8 ff fc ff ff       	call   80202a <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
}
  80232e:	90                   	nop
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	52                   	push   %edx
  802341:	50                   	push   %eax
  802342:	6a 1a                	push   $0x1a
  802344:	e8 e1 fc ff ff       	call   80202a <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	90                   	nop
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	8b 45 10             	mov    0x10(%ebp),%eax
  802358:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80235b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80235e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	6a 00                	push   $0x0
  802367:	51                   	push   %ecx
  802368:	52                   	push   %edx
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	50                   	push   %eax
  80236d:	6a 1c                	push   $0x1c
  80236f:	e8 b6 fc ff ff       	call   80202a <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80237c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	52                   	push   %edx
  802389:	50                   	push   %eax
  80238a:	6a 1d                	push   $0x1d
  80238c:	e8 99 fc ff ff       	call   80202a <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802399:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80239c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	51                   	push   %ecx
  8023a7:	52                   	push   %edx
  8023a8:	50                   	push   %eax
  8023a9:	6a 1e                	push   $0x1e
  8023ab:	e8 7a fc ff ff       	call   80202a <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	52                   	push   %edx
  8023c5:	50                   	push   %eax
  8023c6:	6a 1f                	push   $0x1f
  8023c8:	e8 5d fc ff ff       	call   80202a <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 20                	push   $0x20
  8023e1:	e8 44 fc ff ff       	call   80202a <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	6a 00                	push   $0x0
  8023f3:	ff 75 14             	pushl  0x14(%ebp)
  8023f6:	ff 75 10             	pushl  0x10(%ebp)
  8023f9:	ff 75 0c             	pushl  0xc(%ebp)
  8023fc:	50                   	push   %eax
  8023fd:	6a 21                	push   $0x21
  8023ff:	e8 26 fc ff ff       	call   80202a <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	50                   	push   %eax
  802418:	6a 22                	push   $0x22
  80241a:	e8 0b fc ff ff       	call   80202a <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
}
  802422:	90                   	nop
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	50                   	push   %eax
  802434:	6a 23                	push   $0x23
  802436:	e8 ef fb ff ff       	call   80202a <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	90                   	nop
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802447:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244a:	8d 50 04             	lea    0x4(%eax),%edx
  80244d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	52                   	push   %edx
  802457:	50                   	push   %eax
  802458:	6a 24                	push   $0x24
  80245a:	e8 cb fb ff ff       	call   80202a <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
	return result;
  802462:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802465:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246b:	89 01                	mov    %eax,(%ecx)
  80246d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	c9                   	leave  
  802474:	c2 04 00             	ret    $0x4

00802477 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	ff 75 10             	pushl  0x10(%ebp)
  802481:	ff 75 0c             	pushl  0xc(%ebp)
  802484:	ff 75 08             	pushl  0x8(%ebp)
  802487:	6a 13                	push   $0x13
  802489:	e8 9c fb ff ff       	call   80202a <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
	return ;
  802491:	90                   	nop
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_rcr2>:
uint32 sys_rcr2()
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 25                	push   $0x25
  8024a3:	e8 82 fb ff ff       	call   80202a <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024b9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	50                   	push   %eax
  8024c6:	6a 26                	push   $0x26
  8024c8:	e8 5d fb ff ff       	call   80202a <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d0:	90                   	nop
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <rsttst>:
void rsttst()
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 28                	push   $0x28
  8024e2:	e8 43 fb ff ff       	call   80202a <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ea:	90                   	nop
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024f9:	8b 55 18             	mov    0x18(%ebp),%edx
  8024fc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802500:	52                   	push   %edx
  802501:	50                   	push   %eax
  802502:	ff 75 10             	pushl  0x10(%ebp)
  802505:	ff 75 0c             	pushl  0xc(%ebp)
  802508:	ff 75 08             	pushl  0x8(%ebp)
  80250b:	6a 27                	push   $0x27
  80250d:	e8 18 fb ff ff       	call   80202a <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
	return ;
  802515:	90                   	nop
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <chktst>:
void chktst(uint32 n)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	ff 75 08             	pushl  0x8(%ebp)
  802526:	6a 29                	push   $0x29
  802528:	e8 fd fa ff ff       	call   80202a <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
	return ;
  802530:	90                   	nop
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <inctst>:

void inctst()
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 2a                	push   $0x2a
  802542:	e8 e3 fa ff ff       	call   80202a <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
	return ;
  80254a:	90                   	nop
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <gettst>:
uint32 gettst()
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 2b                	push   $0x2b
  80255c:	e8 c9 fa ff ff       	call   80202a <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 2c                	push   $0x2c
  802578:	e8 ad fa ff ff       	call   80202a <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
  802580:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802583:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802587:	75 07                	jne    802590 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802589:	b8 01 00 00 00       	mov    $0x1,%eax
  80258e:	eb 05                	jmp    802595 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 2c                	push   $0x2c
  8025a9:	e8 7c fa ff ff       	call   80202a <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
  8025b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025b4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025b8:	75 07                	jne    8025c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bf:	eb 05                	jmp    8025c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 2c                	push   $0x2c
  8025da:	e8 4b fa ff ff       	call   80202a <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
  8025e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025e5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025e9:	75 07                	jne    8025f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f0:	eb 05                	jmp    8025f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 2c                	push   $0x2c
  80260b:	e8 1a fa ff ff       	call   80202a <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
  802613:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802616:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80261a:	75 07                	jne    802623 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80261c:	b8 01 00 00 00       	mov    $0x1,%eax
  802621:	eb 05                	jmp    802628 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	ff 75 08             	pushl  0x8(%ebp)
  802638:	6a 2d                	push   $0x2d
  80263a:	e8 eb f9 ff ff       	call   80202a <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
	return ;
  802642:	90                   	nop
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802649:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80264f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	6a 00                	push   $0x0
  802657:	53                   	push   %ebx
  802658:	51                   	push   %ecx
  802659:	52                   	push   %edx
  80265a:	50                   	push   %eax
  80265b:	6a 2e                	push   $0x2e
  80265d:	e8 c8 f9 ff ff       	call   80202a <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
}
  802665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80266d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	52                   	push   %edx
  80267a:	50                   	push   %eax
  80267b:	6a 2f                	push   $0x2f
  80267d:	e8 a8 f9 ff ff       	call   80202a <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    
  802687:	90                   	nop

00802688 <__udivdi3>:
  802688:	55                   	push   %ebp
  802689:	57                   	push   %edi
  80268a:	56                   	push   %esi
  80268b:	53                   	push   %ebx
  80268c:	83 ec 1c             	sub    $0x1c,%esp
  80268f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802693:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802697:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80269b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80269f:	89 ca                	mov    %ecx,%edx
  8026a1:	89 f8                	mov    %edi,%eax
  8026a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026a7:	85 f6                	test   %esi,%esi
  8026a9:	75 2d                	jne    8026d8 <__udivdi3+0x50>
  8026ab:	39 cf                	cmp    %ecx,%edi
  8026ad:	77 65                	ja     802714 <__udivdi3+0x8c>
  8026af:	89 fd                	mov    %edi,%ebp
  8026b1:	85 ff                	test   %edi,%edi
  8026b3:	75 0b                	jne    8026c0 <__udivdi3+0x38>
  8026b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ba:	31 d2                	xor    %edx,%edx
  8026bc:	f7 f7                	div    %edi
  8026be:	89 c5                	mov    %eax,%ebp
  8026c0:	31 d2                	xor    %edx,%edx
  8026c2:	89 c8                	mov    %ecx,%eax
  8026c4:	f7 f5                	div    %ebp
  8026c6:	89 c1                	mov    %eax,%ecx
  8026c8:	89 d8                	mov    %ebx,%eax
  8026ca:	f7 f5                	div    %ebp
  8026cc:	89 cf                	mov    %ecx,%edi
  8026ce:	89 fa                	mov    %edi,%edx
  8026d0:	83 c4 1c             	add    $0x1c,%esp
  8026d3:	5b                   	pop    %ebx
  8026d4:	5e                   	pop    %esi
  8026d5:	5f                   	pop    %edi
  8026d6:	5d                   	pop    %ebp
  8026d7:	c3                   	ret    
  8026d8:	39 ce                	cmp    %ecx,%esi
  8026da:	77 28                	ja     802704 <__udivdi3+0x7c>
  8026dc:	0f bd fe             	bsr    %esi,%edi
  8026df:	83 f7 1f             	xor    $0x1f,%edi
  8026e2:	75 40                	jne    802724 <__udivdi3+0x9c>
  8026e4:	39 ce                	cmp    %ecx,%esi
  8026e6:	72 0a                	jb     8026f2 <__udivdi3+0x6a>
  8026e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8026ec:	0f 87 9e 00 00 00    	ja     802790 <__udivdi3+0x108>
  8026f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f7:	89 fa                	mov    %edi,%edx
  8026f9:	83 c4 1c             	add    $0x1c,%esp
  8026fc:	5b                   	pop    %ebx
  8026fd:	5e                   	pop    %esi
  8026fe:	5f                   	pop    %edi
  8026ff:	5d                   	pop    %ebp
  802700:	c3                   	ret    
  802701:	8d 76 00             	lea    0x0(%esi),%esi
  802704:	31 ff                	xor    %edi,%edi
  802706:	31 c0                	xor    %eax,%eax
  802708:	89 fa                	mov    %edi,%edx
  80270a:	83 c4 1c             	add    $0x1c,%esp
  80270d:	5b                   	pop    %ebx
  80270e:	5e                   	pop    %esi
  80270f:	5f                   	pop    %edi
  802710:	5d                   	pop    %ebp
  802711:	c3                   	ret    
  802712:	66 90                	xchg   %ax,%ax
  802714:	89 d8                	mov    %ebx,%eax
  802716:	f7 f7                	div    %edi
  802718:	31 ff                	xor    %edi,%edi
  80271a:	89 fa                	mov    %edi,%edx
  80271c:	83 c4 1c             	add    $0x1c,%esp
  80271f:	5b                   	pop    %ebx
  802720:	5e                   	pop    %esi
  802721:	5f                   	pop    %edi
  802722:	5d                   	pop    %ebp
  802723:	c3                   	ret    
  802724:	bd 20 00 00 00       	mov    $0x20,%ebp
  802729:	89 eb                	mov    %ebp,%ebx
  80272b:	29 fb                	sub    %edi,%ebx
  80272d:	89 f9                	mov    %edi,%ecx
  80272f:	d3 e6                	shl    %cl,%esi
  802731:	89 c5                	mov    %eax,%ebp
  802733:	88 d9                	mov    %bl,%cl
  802735:	d3 ed                	shr    %cl,%ebp
  802737:	89 e9                	mov    %ebp,%ecx
  802739:	09 f1                	or     %esi,%ecx
  80273b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80273f:	89 f9                	mov    %edi,%ecx
  802741:	d3 e0                	shl    %cl,%eax
  802743:	89 c5                	mov    %eax,%ebp
  802745:	89 d6                	mov    %edx,%esi
  802747:	88 d9                	mov    %bl,%cl
  802749:	d3 ee                	shr    %cl,%esi
  80274b:	89 f9                	mov    %edi,%ecx
  80274d:	d3 e2                	shl    %cl,%edx
  80274f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802753:	88 d9                	mov    %bl,%cl
  802755:	d3 e8                	shr    %cl,%eax
  802757:	09 c2                	or     %eax,%edx
  802759:	89 d0                	mov    %edx,%eax
  80275b:	89 f2                	mov    %esi,%edx
  80275d:	f7 74 24 0c          	divl   0xc(%esp)
  802761:	89 d6                	mov    %edx,%esi
  802763:	89 c3                	mov    %eax,%ebx
  802765:	f7 e5                	mul    %ebp
  802767:	39 d6                	cmp    %edx,%esi
  802769:	72 19                	jb     802784 <__udivdi3+0xfc>
  80276b:	74 0b                	je     802778 <__udivdi3+0xf0>
  80276d:	89 d8                	mov    %ebx,%eax
  80276f:	31 ff                	xor    %edi,%edi
  802771:	e9 58 ff ff ff       	jmp    8026ce <__udivdi3+0x46>
  802776:	66 90                	xchg   %ax,%ax
  802778:	8b 54 24 08          	mov    0x8(%esp),%edx
  80277c:	89 f9                	mov    %edi,%ecx
  80277e:	d3 e2                	shl    %cl,%edx
  802780:	39 c2                	cmp    %eax,%edx
  802782:	73 e9                	jae    80276d <__udivdi3+0xe5>
  802784:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802787:	31 ff                	xor    %edi,%edi
  802789:	e9 40 ff ff ff       	jmp    8026ce <__udivdi3+0x46>
  80278e:	66 90                	xchg   %ax,%ax
  802790:	31 c0                	xor    %eax,%eax
  802792:	e9 37 ff ff ff       	jmp    8026ce <__udivdi3+0x46>
  802797:	90                   	nop

00802798 <__umoddi3>:
  802798:	55                   	push   %ebp
  802799:	57                   	push   %edi
  80279a:	56                   	push   %esi
  80279b:	53                   	push   %ebx
  80279c:	83 ec 1c             	sub    $0x1c,%esp
  80279f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8027a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027b7:	89 f3                	mov    %esi,%ebx
  8027b9:	89 fa                	mov    %edi,%edx
  8027bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027bf:	89 34 24             	mov    %esi,(%esp)
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	75 1a                	jne    8027e0 <__umoddi3+0x48>
  8027c6:	39 f7                	cmp    %esi,%edi
  8027c8:	0f 86 a2 00 00 00    	jbe    802870 <__umoddi3+0xd8>
  8027ce:	89 c8                	mov    %ecx,%eax
  8027d0:	89 f2                	mov    %esi,%edx
  8027d2:	f7 f7                	div    %edi
  8027d4:	89 d0                	mov    %edx,%eax
  8027d6:	31 d2                	xor    %edx,%edx
  8027d8:	83 c4 1c             	add    $0x1c,%esp
  8027db:	5b                   	pop    %ebx
  8027dc:	5e                   	pop    %esi
  8027dd:	5f                   	pop    %edi
  8027de:	5d                   	pop    %ebp
  8027df:	c3                   	ret    
  8027e0:	39 f0                	cmp    %esi,%eax
  8027e2:	0f 87 ac 00 00 00    	ja     802894 <__umoddi3+0xfc>
  8027e8:	0f bd e8             	bsr    %eax,%ebp
  8027eb:	83 f5 1f             	xor    $0x1f,%ebp
  8027ee:	0f 84 ac 00 00 00    	je     8028a0 <__umoddi3+0x108>
  8027f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8027f9:	29 ef                	sub    %ebp,%edi
  8027fb:	89 fe                	mov    %edi,%esi
  8027fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802801:	89 e9                	mov    %ebp,%ecx
  802803:	d3 e0                	shl    %cl,%eax
  802805:	89 d7                	mov    %edx,%edi
  802807:	89 f1                	mov    %esi,%ecx
  802809:	d3 ef                	shr    %cl,%edi
  80280b:	09 c7                	or     %eax,%edi
  80280d:	89 e9                	mov    %ebp,%ecx
  80280f:	d3 e2                	shl    %cl,%edx
  802811:	89 14 24             	mov    %edx,(%esp)
  802814:	89 d8                	mov    %ebx,%eax
  802816:	d3 e0                	shl    %cl,%eax
  802818:	89 c2                	mov    %eax,%edx
  80281a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80281e:	d3 e0                	shl    %cl,%eax
  802820:	89 44 24 04          	mov    %eax,0x4(%esp)
  802824:	8b 44 24 08          	mov    0x8(%esp),%eax
  802828:	89 f1                	mov    %esi,%ecx
  80282a:	d3 e8                	shr    %cl,%eax
  80282c:	09 d0                	or     %edx,%eax
  80282e:	d3 eb                	shr    %cl,%ebx
  802830:	89 da                	mov    %ebx,%edx
  802832:	f7 f7                	div    %edi
  802834:	89 d3                	mov    %edx,%ebx
  802836:	f7 24 24             	mull   (%esp)
  802839:	89 c6                	mov    %eax,%esi
  80283b:	89 d1                	mov    %edx,%ecx
  80283d:	39 d3                	cmp    %edx,%ebx
  80283f:	0f 82 87 00 00 00    	jb     8028cc <__umoddi3+0x134>
  802845:	0f 84 91 00 00 00    	je     8028dc <__umoddi3+0x144>
  80284b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80284f:	29 f2                	sub    %esi,%edx
  802851:	19 cb                	sbb    %ecx,%ebx
  802853:	89 d8                	mov    %ebx,%eax
  802855:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802859:	d3 e0                	shl    %cl,%eax
  80285b:	89 e9                	mov    %ebp,%ecx
  80285d:	d3 ea                	shr    %cl,%edx
  80285f:	09 d0                	or     %edx,%eax
  802861:	89 e9                	mov    %ebp,%ecx
  802863:	d3 eb                	shr    %cl,%ebx
  802865:	89 da                	mov    %ebx,%edx
  802867:	83 c4 1c             	add    $0x1c,%esp
  80286a:	5b                   	pop    %ebx
  80286b:	5e                   	pop    %esi
  80286c:	5f                   	pop    %edi
  80286d:	5d                   	pop    %ebp
  80286e:	c3                   	ret    
  80286f:	90                   	nop
  802870:	89 fd                	mov    %edi,%ebp
  802872:	85 ff                	test   %edi,%edi
  802874:	75 0b                	jne    802881 <__umoddi3+0xe9>
  802876:	b8 01 00 00 00       	mov    $0x1,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	f7 f7                	div    %edi
  80287f:	89 c5                	mov    %eax,%ebp
  802881:	89 f0                	mov    %esi,%eax
  802883:	31 d2                	xor    %edx,%edx
  802885:	f7 f5                	div    %ebp
  802887:	89 c8                	mov    %ecx,%eax
  802889:	f7 f5                	div    %ebp
  80288b:	89 d0                	mov    %edx,%eax
  80288d:	e9 44 ff ff ff       	jmp    8027d6 <__umoddi3+0x3e>
  802892:	66 90                	xchg   %ax,%ax
  802894:	89 c8                	mov    %ecx,%eax
  802896:	89 f2                	mov    %esi,%edx
  802898:	83 c4 1c             	add    $0x1c,%esp
  80289b:	5b                   	pop    %ebx
  80289c:	5e                   	pop    %esi
  80289d:	5f                   	pop    %edi
  80289e:	5d                   	pop    %ebp
  80289f:	c3                   	ret    
  8028a0:	3b 04 24             	cmp    (%esp),%eax
  8028a3:	72 06                	jb     8028ab <__umoddi3+0x113>
  8028a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028a9:	77 0f                	ja     8028ba <__umoddi3+0x122>
  8028ab:	89 f2                	mov    %esi,%edx
  8028ad:	29 f9                	sub    %edi,%ecx
  8028af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028b3:	89 14 24             	mov    %edx,(%esp)
  8028b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028be:	8b 14 24             	mov    (%esp),%edx
  8028c1:	83 c4 1c             	add    $0x1c,%esp
  8028c4:	5b                   	pop    %ebx
  8028c5:	5e                   	pop    %esi
  8028c6:	5f                   	pop    %edi
  8028c7:	5d                   	pop    %ebp
  8028c8:	c3                   	ret    
  8028c9:	8d 76 00             	lea    0x0(%esi),%esi
  8028cc:	2b 04 24             	sub    (%esp),%eax
  8028cf:	19 fa                	sbb    %edi,%edx
  8028d1:	89 d1                	mov    %edx,%ecx
  8028d3:	89 c6                	mov    %eax,%esi
  8028d5:	e9 71 ff ff ff       	jmp    80284b <__umoddi3+0xb3>
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8028e0:	72 ea                	jb     8028cc <__umoddi3+0x134>
  8028e2:	89 d9                	mov    %ebx,%ecx
  8028e4:	e9 62 ff ff ff       	jmp    80284b <__umoddi3+0xb3>
