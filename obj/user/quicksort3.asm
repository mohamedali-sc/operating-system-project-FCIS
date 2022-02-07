
obj/user/quicksort3:     file format elf32-i386


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
  800031:	e8 c9 05 00 00       	call   8005ff <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 f2 20 00 00       	call   802140 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 04 21 00 00       	call   802159 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80005d:	e8 ae 21 00 00       	call   802210 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 a0 28 80 00       	push   $0x8028a0
  800071:	e8 f2 0f 00 00       	call   801068 <readline>
  800076:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 42 15 00 00       	call   8015ce <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 d5 18 00 00       	call   801976 <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Elements[NumOfElements] = 10 ;
  8000a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b4:	01 d0                	add    %edx,%eax
  8000b6:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 c0 28 80 00       	push   $0x8028c0
  8000c4:	e8 1d 09 00 00       	call   8009e6 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 e3 28 80 00       	push   $0x8028e3
  8000d4:	e8 0d 09 00 00       	call   8009e6 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 f1 28 80 00       	push   $0x8028f1
  8000e4:	e8 fd 08 00 00       	call   8009e6 <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\nSelect: ") ;
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 00 29 80 00       	push   $0x802900
  8000f4:	e8 ed 08 00 00       	call   8009e6 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8000fc:	e8 a6 04 00 00       	call   8005a7 <getchar>
  800101:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  800104:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800108:	83 ec 0c             	sub    $0xc,%esp
  80010b:	50                   	push   %eax
  80010c:	e8 4e 04 00 00       	call   80055f <cputchar>
  800111:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	6a 0a                	push   $0xa
  800119:	e8 41 04 00 00       	call   80055f <cputchar>
  80011e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800121:	e8 04 21 00 00       	call   80222a <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  800126:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012a:	83 f8 62             	cmp    $0x62,%eax
  80012d:	74 1d                	je     80014c <_main+0x114>
  80012f:	83 f8 63             	cmp    $0x63,%eax
  800132:	74 2b                	je     80015f <_main+0x127>
  800134:	83 f8 61             	cmp    $0x61,%eax
  800137:	75 39                	jne    800172 <_main+0x13a>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	ff 75 ec             	pushl  -0x14(%ebp)
  80013f:	ff 75 e8             	pushl  -0x18(%ebp)
  800142:	e8 e0 02 00 00       	call   800427 <InitializeAscending>
  800147:	83 c4 10             	add    $0x10,%esp
			break ;
  80014a:	eb 37                	jmp    800183 <_main+0x14b>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	ff 75 ec             	pushl  -0x14(%ebp)
  800152:	ff 75 e8             	pushl  -0x18(%ebp)
  800155:	e8 fe 02 00 00       	call   800458 <InitializeDescending>
  80015a:	83 c4 10             	add    $0x10,%esp
			break ;
  80015d:	eb 24                	jmp    800183 <_main+0x14b>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	ff 75 ec             	pushl  -0x14(%ebp)
  800165:	ff 75 e8             	pushl  -0x18(%ebp)
  800168:	e8 20 03 00 00       	call   80048d <InitializeSemiRandom>
  80016d:	83 c4 10             	add    $0x10,%esp
			break ;
  800170:	eb 11                	jmp    800183 <_main+0x14b>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	ff 75 ec             	pushl  -0x14(%ebp)
  800178:	ff 75 e8             	pushl  -0x18(%ebp)
  80017b:	e8 0d 03 00 00       	call   80048d <InitializeSemiRandom>
  800180:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 ec             	pushl  -0x14(%ebp)
  800189:	ff 75 e8             	pushl  -0x18(%ebp)
  80018c:	e8 db 00 00 00       	call   80026c <QuickSort>
  800191:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 ec             	pushl  -0x14(%ebp)
  80019a:	ff 75 e8             	pushl  -0x18(%ebp)
  80019d:	e8 db 01 00 00       	call   80037d <CheckSorted>
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001ac:	75 14                	jne    8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 18 29 80 00       	push   $0x802918
  8001b6:	6a 42                	push   $0x42
  8001b8:	68 3a 29 80 00       	push   $0x80293a
  8001bd:	e8 82 05 00 00       	call   800744 <_panic>
		else
		{ 
			cprintf("\n===============================================\n") ;
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 4c 29 80 00       	push   $0x80294c
  8001ca:	e8 17 08 00 00       	call   8009e6 <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 80 29 80 00       	push   $0x802980
  8001da:	e8 07 08 00 00       	call   8009e6 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 b4 29 80 00       	push   $0x8029b4
  8001ea:	e8 f7 07 00 00       	call   8009e6 <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	68 e6 29 80 00       	push   $0x8029e6
  8001fa:	e8 e7 07 00 00       	call   8009e6 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	ff 75 e8             	pushl  -0x18(%ebp)
  800208:	e8 17 1c 00 00       	call   801e24 <free>
  80020d:	83 c4 10             	add    $0x10,%esp


		///========================================================================
	sys_disable_interrupt();
  800210:	e8 fb 1f 00 00       	call   802210 <sys_disable_interrupt>
		cprintf("Do you want to repeat (y/n): ") ;
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	68 fc 29 80 00       	push   $0x8029fc
  80021d:	e8 c4 07 00 00       	call   8009e6 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp

		Chose = getchar() ;
  800225:	e8 7d 03 00 00       	call   8005a7 <getchar>
  80022a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80022d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	50                   	push   %eax
  800235:	e8 25 03 00 00       	call   80055f <cputchar>
  80023a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 0a                	push   $0xa
  800242:	e8 18 03 00 00       	call   80055f <cputchar>
  800247:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	6a 0a                	push   $0xa
  80024f:	e8 0b 03 00 00       	call   80055f <cputchar>
  800254:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800257:	e8 ce 1f 00 00       	call   80222a <sys_enable_interrupt>

	} while (Chose == 'y');
  80025c:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800260:	0f 84 e3 fd ff ff    	je     800049 <_main+0x11>

}
  800266:	90                   	nop
  800267:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	48                   	dec    %eax
  800276:	50                   	push   %eax
  800277:	6a 00                	push   $0x0
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	e8 06 00 00 00       	call   80028a <QSort>
  800284:	83 c4 10             	add    $0x10,%esp
}
  800287:	90                   	nop
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  800290:	8b 45 10             	mov    0x10(%ebp),%eax
  800293:	3b 45 14             	cmp    0x14(%ebp),%eax
  800296:	0f 8d de 00 00 00    	jge    80037a <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80029c:	8b 45 10             	mov    0x10(%ebp),%eax
  80029f:	40                   	inc    %eax
  8002a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002a9:	e9 80 00 00 00       	jmp    80032e <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002ae:	ff 45 f4             	incl   -0xc(%ebp)
  8002b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002b7:	7f 2b                	jg     8002e4 <QSort+0x5a>
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	8b 10                	mov    (%eax),%edx
  8002ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d7:	01 c8                	add    %ecx,%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	39 c2                	cmp    %eax,%edx
  8002dd:	7d cf                	jge    8002ae <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002df:	eb 03                	jmp    8002e4 <QSort+0x5a>
  8002e1:	ff 4d f0             	decl   -0x10(%ebp)
  8002e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002ea:	7e 26                	jle    800312 <QSort+0x88>
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	8b 10                	mov    (%eax),%edx
  8002fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800300:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	01 c8                	add    %ecx,%eax
  80030c:	8b 00                	mov    (%eax),%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	7e cf                	jle    8002e1 <QSort+0x57>

		if (i <= j)
  800312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800315:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800318:	7f 14                	jg     80032e <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	ff 75 f0             	pushl  -0x10(%ebp)
  800320:	ff 75 f4             	pushl  -0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 a9 00 00 00       	call   8003d4 <Swap>
  80032b:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800334:	0f 8e 77 ff ff ff    	jle    8002b1 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	ff 75 f0             	pushl  -0x10(%ebp)
  800340:	ff 75 10             	pushl  0x10(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 89 00 00 00       	call   8003d4 <Swap>
  80034b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800351:	48                   	dec    %eax
  800352:	50                   	push   %eax
  800353:	ff 75 10             	pushl  0x10(%ebp)
  800356:	ff 75 0c             	pushl  0xc(%ebp)
  800359:	ff 75 08             	pushl  0x8(%ebp)
  80035c:	e8 29 ff ff ff       	call   80028a <QSort>
  800361:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800364:	ff 75 14             	pushl  0x14(%ebp)
  800367:	ff 75 f4             	pushl  -0xc(%ebp)
  80036a:	ff 75 0c             	pushl  0xc(%ebp)
  80036d:	ff 75 08             	pushl  0x8(%ebp)
  800370:	e8 15 ff ff ff       	call   80028a <QSort>
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	eb 01                	jmp    80037b <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80037a:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800383:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80038a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800391:	eb 33                	jmp    8003c6 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800393:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800396:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	01 d0                	add    %edx,%eax
  8003a2:	8b 10                	mov    (%eax),%edx
  8003a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003a7:	40                   	inc    %eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	7e 09                	jle    8003c3 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003c1:	eb 0c                	jmp    8003cf <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003c3:	ff 45 f8             	incl   -0x8(%ebp)
  8003c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c9:	48                   	dec    %eax
  8003ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003cd:	7f c4                	jg     800393 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	01 c2                	add    %eax,%edx
  8003fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800400:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c2                	add    %eax,%edx
  80041f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800422:	89 02                	mov    %eax,(%edx)
}
  800424:	90                   	nop
  800425:	c9                   	leave  
  800426:	c3                   	ret    

00800427 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80042d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800434:	eb 17                	jmp    80044d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800436:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800439:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800448:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80044a:	ff 45 fc             	incl   -0x4(%ebp)
  80044d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800450:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800453:	7c e1                	jl     800436 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800455:	90                   	nop
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80045e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800465:	eb 1b                	jmp    800482 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	01 c2                	add    %eax,%edx
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80047c:	48                   	dec    %eax
  80047d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80047f:	ff 45 fc             	incl   -0x4(%ebp)
  800482:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800485:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800488:	7c dd                	jl     800467 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80048a:	90                   	nop
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    

0080048d <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800496:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80049b:	f7 e9                	imul   %ecx
  80049d:	c1 f9 1f             	sar    $0x1f,%ecx
  8004a0:	89 d0                	mov    %edx,%eax
  8004a2:	29 c8                	sub    %ecx,%eax
  8004a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004ae:	eb 1e                	jmp    8004ce <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c3:	99                   	cltd   
  8004c4:	f7 7d f8             	idivl  -0x8(%ebp)
  8004c7:	89 d0                	mov    %edx,%eax
  8004c9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cb:	ff 45 fc             	incl   -0x4(%ebp)
  8004ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004d4:	7c da                	jl     8004b0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004df:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004ed:	eb 42                	jmp    800531 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f2:	99                   	cltd   
  8004f3:	f7 7d f0             	idivl  -0x10(%ebp)
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	85 c0                	test   %eax,%eax
  8004fa:	75 10                	jne    80050c <PrintElements+0x33>
			cprintf("\n");
  8004fc:	83 ec 0c             	sub    $0xc,%esp
  8004ff:	68 1a 2a 80 00       	push   $0x802a1a
  800504:	e8 dd 04 00 00       	call   8009e6 <cprintf>
  800509:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80050c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	01 d0                	add    %edx,%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	50                   	push   %eax
  800521:	68 1c 2a 80 00       	push   $0x802a1c
  800526:	e8 bb 04 00 00       	call   8009e6 <cprintf>
  80052b:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052e:	ff 45 f4             	incl   -0xc(%ebp)
  800531:	8b 45 0c             	mov    0xc(%ebp),%eax
  800534:	48                   	dec    %eax
  800535:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800538:	7f b5                	jg     8004ef <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80053a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	50                   	push   %eax
  80054f:	68 21 2a 80 00       	push   $0x802a21
  800554:	e8 8d 04 00 00       	call   8009e6 <cprintf>
  800559:	83 c4 10             	add    $0x10,%esp

}
  80055c:	90                   	nop
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    

0080055f <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80056b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80056f:	83 ec 0c             	sub    $0xc,%esp
  800572:	50                   	push   %eax
  800573:	e8 cc 1c 00 00       	call   802244 <sys_cputc>
  800578:	83 c4 10             	add    $0x10,%esp
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800584:	e8 87 1c 00 00       	call   802210 <sys_disable_interrupt>
	char c = ch;
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80058f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	50                   	push   %eax
  800597:	e8 a8 1c 00 00       	call   802244 <sys_cputc>
  80059c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80059f:	e8 86 1c 00 00       	call   80222a <sys_enable_interrupt>
}
  8005a4:	90                   	nop
  8005a5:	c9                   	leave  
  8005a6:	c3                   	ret    

008005a7 <getchar>:

int
getchar(void)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005b4:	eb 08                	jmp    8005be <getchar+0x17>
	{
		c = sys_cgetc();
  8005b6:	e8 6d 1a 00 00       	call   802028 <sys_cgetc>
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005c2:	74 f2                	je     8005b6 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005cf:	e8 3c 1c 00 00       	call   802210 <sys_disable_interrupt>
	int c=0;
  8005d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005db:	eb 08                	jmp    8005e5 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005dd:	e8 46 1a 00 00       	call   802028 <sys_cgetc>
  8005e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005e9:	74 f2                	je     8005dd <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005eb:	e8 3a 1c 00 00       	call   80222a <sys_enable_interrupt>
	return c;
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

008005f5 <iscons>:

int iscons(int fdnum)
{
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fd:	5d                   	pop    %ebp
  8005fe:	c3                   	ret    

008005ff <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ff:	55                   	push   %ebp
  800600:	89 e5                	mov    %esp,%ebp
  800602:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800605:	e8 6b 1a 00 00       	call   802075 <sys_getenvindex>
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80060d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800610:	89 d0                	mov    %edx,%eax
  800612:	c1 e0 03             	shl    $0x3,%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80061e:	01 c8                	add    %ecx,%eax
  800620:	01 c0                	add    %eax,%eax
  800622:	01 d0                	add    %edx,%eax
  800624:	01 c0                	add    %eax,%eax
  800626:	01 d0                	add    %edx,%eax
  800628:	89 c2                	mov    %eax,%edx
  80062a:	c1 e2 05             	shl    $0x5,%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800636:	89 c2                	mov    %eax,%edx
  800638:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80063e:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800643:	a1 24 40 80 00       	mov    0x804024,%eax
  800648:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80064e:	84 c0                	test   %al,%al
  800650:	74 0f                	je     800661 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800652:	a1 24 40 80 00       	mov    0x804024,%eax
  800657:	05 40 3c 01 00       	add    $0x13c40,%eax
  80065c:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800665:	7e 0a                	jle    800671 <libmain+0x72>
		binaryname = argv[0];
  800667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	ff 75 08             	pushl  0x8(%ebp)
  80067a:	e8 b9 f9 ff ff       	call   800038 <_main>
  80067f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800682:	e8 89 1b 00 00       	call   802210 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 40 2a 80 00       	push   $0x802a40
  80068f:	e8 52 03 00 00       	call   8009e6 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800697:	a1 24 40 80 00       	mov    0x804024,%eax
  80069c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006a2:	a1 24 40 80 00       	mov    0x804024,%eax
  8006a7:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	52                   	push   %edx
  8006b1:	50                   	push   %eax
  8006b2:	68 68 2a 80 00       	push   $0x802a68
  8006b7:	e8 2a 03 00 00       	call   8009e6 <cprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006bf:	a1 24 40 80 00       	mov    0x804024,%eax
  8006c4:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006ca:	a1 24 40 80 00       	mov    0x804024,%eax
  8006cf:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006d5:	83 ec 04             	sub    $0x4,%esp
  8006d8:	52                   	push   %edx
  8006d9:	50                   	push   %eax
  8006da:	68 90 2a 80 00       	push   $0x802a90
  8006df:	e8 02 03 00 00       	call   8009e6 <cprintf>
  8006e4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e7:	a1 24 40 80 00       	mov    0x804024,%eax
  8006ec:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	50                   	push   %eax
  8006f6:	68 d1 2a 80 00       	push   $0x802ad1
  8006fb:	e8 e6 02 00 00       	call   8009e6 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800703:	83 ec 0c             	sub    $0xc,%esp
  800706:	68 40 2a 80 00       	push   $0x802a40
  80070b:	e8 d6 02 00 00       	call   8009e6 <cprintf>
  800710:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800713:	e8 12 1b 00 00       	call   80222a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800718:	e8 19 00 00 00       	call   800736 <exit>
}
  80071d:	90                   	nop
  80071e:	c9                   	leave  
  80071f:	c3                   	ret    

00800720 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800726:	83 ec 0c             	sub    $0xc,%esp
  800729:	6a 00                	push   $0x0
  80072b:	e8 11 19 00 00       	call   802041 <sys_env_destroy>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <exit>:

void
exit(void)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80073c:	e8 66 19 00 00       	call   8020a7 <sys_env_exit>
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80074a:	8d 45 10             	lea    0x10(%ebp),%eax
  80074d:	83 c0 04             	add    $0x4,%eax
  800750:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800753:	a1 18 41 80 00       	mov    0x804118,%eax
  800758:	85 c0                	test   %eax,%eax
  80075a:	74 16                	je     800772 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80075c:	a1 18 41 80 00       	mov    0x804118,%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	50                   	push   %eax
  800765:	68 e8 2a 80 00       	push   $0x802ae8
  80076a:	e8 77 02 00 00       	call   8009e6 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800772:	a1 00 40 80 00       	mov    0x804000,%eax
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	ff 75 08             	pushl  0x8(%ebp)
  80077d:	50                   	push   %eax
  80077e:	68 ed 2a 80 00       	push   $0x802aed
  800783:	e8 5e 02 00 00       	call   8009e6 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80078b:	8b 45 10             	mov    0x10(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 e1 01 00 00       	call   80097b <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	6a 00                	push   $0x0
  8007a2:	68 09 2b 80 00       	push   $0x802b09
  8007a7:	e8 cf 01 00 00       	call   80097b <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007af:	e8 82 ff ff ff       	call   800736 <exit>

	// should not return here
	while (1) ;
  8007b4:	eb fe                	jmp    8007b4 <_panic+0x70>

008007b6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007bc:	a1 24 40 80 00       	mov    0x804024,%eax
  8007c1:	8b 50 74             	mov    0x74(%eax),%edx
  8007c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c7:	39 c2                	cmp    %eax,%edx
  8007c9:	74 14                	je     8007df <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007cb:	83 ec 04             	sub    $0x4,%esp
  8007ce:	68 0c 2b 80 00       	push   $0x802b0c
  8007d3:	6a 26                	push   $0x26
  8007d5:	68 58 2b 80 00       	push   $0x802b58
  8007da:	e8 65 ff ff ff       	call   800744 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007ed:	e9 b6 00 00 00       	jmp    8008a8 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 d0                	add    %edx,%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	85 c0                	test   %eax,%eax
  800805:	75 08                	jne    80080f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800807:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80080a:	e9 96 00 00 00       	jmp    8008a5 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80080f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800816:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80081d:	eb 5d                	jmp    80087c <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80081f:	a1 24 40 80 00       	mov    0x804024,%eax
  800824:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	c1 e2 04             	shl    $0x4,%edx
  800830:	01 d0                	add    %edx,%eax
  800832:	8a 40 04             	mov    0x4(%eax),%al
  800835:	84 c0                	test   %al,%al
  800837:	75 40                	jne    800879 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800839:	a1 24 40 80 00       	mov    0x804024,%eax
  80083e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800844:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800847:	c1 e2 04             	shl    $0x4,%edx
  80084a:	01 d0                	add    %edx,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800851:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800859:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80085b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	01 c8                	add    %ecx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80086c:	39 c2                	cmp    %eax,%edx
  80086e:	75 09                	jne    800879 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800870:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800877:	eb 12                	jmp    80088b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800879:	ff 45 e8             	incl   -0x18(%ebp)
  80087c:	a1 24 40 80 00       	mov    0x804024,%eax
  800881:	8b 50 74             	mov    0x74(%eax),%edx
  800884:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800887:	39 c2                	cmp    %eax,%edx
  800889:	77 94                	ja     80081f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80088b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80088f:	75 14                	jne    8008a5 <CheckWSWithoutLastIndex+0xef>
			panic(
  800891:	83 ec 04             	sub    $0x4,%esp
  800894:	68 64 2b 80 00       	push   $0x802b64
  800899:	6a 3a                	push   $0x3a
  80089b:	68 58 2b 80 00       	push   $0x802b58
  8008a0:	e8 9f fe ff ff       	call   800744 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008a5:	ff 45 f0             	incl   -0x10(%ebp)
  8008a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008ae:	0f 8c 3e ff ff ff    	jl     8007f2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008c2:	eb 20                	jmp    8008e4 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008c4:	a1 24 40 80 00       	mov    0x804024,%eax
  8008c9:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008d2:	c1 e2 04             	shl    $0x4,%edx
  8008d5:	01 d0                	add    %edx,%eax
  8008d7:	8a 40 04             	mov    0x4(%eax),%al
  8008da:	3c 01                	cmp    $0x1,%al
  8008dc:	75 03                	jne    8008e1 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008de:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008e1:	ff 45 e0             	incl   -0x20(%ebp)
  8008e4:	a1 24 40 80 00       	mov    0x804024,%eax
  8008e9:	8b 50 74             	mov    0x74(%eax),%edx
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	39 c2                	cmp    %eax,%edx
  8008f1:	77 d1                	ja     8008c4 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008f9:	74 14                	je     80090f <CheckWSWithoutLastIndex+0x159>
		panic(
  8008fb:	83 ec 04             	sub    $0x4,%esp
  8008fe:	68 b8 2b 80 00       	push   $0x802bb8
  800903:	6a 44                	push   $0x44
  800905:	68 58 2b 80 00       	push   $0x802b58
  80090a:	e8 35 fe ff ff       	call   800744 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	8d 48 01             	lea    0x1(%eax),%ecx
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
  800923:	89 0a                	mov    %ecx,(%edx)
  800925:	8b 55 08             	mov    0x8(%ebp),%edx
  800928:	88 d1                	mov    %dl,%cl
  80092a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800931:	8b 45 0c             	mov    0xc(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	3d ff 00 00 00       	cmp    $0xff,%eax
  80093b:	75 2c                	jne    800969 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80093d:	a0 28 40 80 00       	mov    0x804028,%al
  800942:	0f b6 c0             	movzbl %al,%eax
  800945:	8b 55 0c             	mov    0xc(%ebp),%edx
  800948:	8b 12                	mov    (%edx),%edx
  80094a:	89 d1                	mov    %edx,%ecx
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	83 c2 08             	add    $0x8,%edx
  800952:	83 ec 04             	sub    $0x4,%esp
  800955:	50                   	push   %eax
  800956:	51                   	push   %ecx
  800957:	52                   	push   %edx
  800958:	e8 a2 16 00 00       	call   801fff <sys_cputs>
  80095d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800960:	8b 45 0c             	mov    0xc(%ebp),%eax
  800963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	8b 40 04             	mov    0x4(%eax),%eax
  80096f:	8d 50 01             	lea    0x1(%eax),%edx
  800972:	8b 45 0c             	mov    0xc(%ebp),%eax
  800975:	89 50 04             	mov    %edx,0x4(%eax)
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800984:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80098b:	00 00 00 
	b.cnt = 0;
  80098e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800995:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	ff 75 08             	pushl  0x8(%ebp)
  80099e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	68 12 09 80 00       	push   $0x800912
  8009aa:	e8 11 02 00 00       	call   800bc0 <vprintfmt>
  8009af:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009b2:	a0 28 40 80 00       	mov    0x804028,%al
  8009b7:	0f b6 c0             	movzbl %al,%eax
  8009ba:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009c0:	83 ec 04             	sub    $0x4,%esp
  8009c3:	50                   	push   %eax
  8009c4:	52                   	push   %edx
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	83 c0 08             	add    $0x8,%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 2b 16 00 00       	call   801fff <sys_cputs>
  8009d4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009d7:	c6 05 28 40 80 00 00 	movb   $0x0,0x804028
	return b.cnt;
  8009de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009ec:	c6 05 28 40 80 00 01 	movb   $0x1,0x804028
	va_start(ap, fmt);
  8009f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800a02:	50                   	push   %eax
  800a03:	e8 73 ff ff ff       	call   80097b <vcprintf>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    

00800a13 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a19:	e8 f2 17 00 00       	call   802210 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a1e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2d:	50                   	push   %eax
  800a2e:	e8 48 ff ff ff       	call   80097b <vcprintf>
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a39:	e8 ec 17 00 00       	call   80222a <sys_enable_interrupt>
	return cnt;
  800a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	53                   	push   %ebx
  800a47:	83 ec 14             	sub    $0x14,%esp
  800a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a56:	8b 45 18             	mov    0x18(%ebp),%eax
  800a59:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a61:	77 55                	ja     800ab8 <printnum+0x75>
  800a63:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a66:	72 05                	jb     800a6d <printnum+0x2a>
  800a68:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a6b:	77 4b                	ja     800ab8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a6d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a70:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a73:	8b 45 18             	mov    0x18(%ebp),%eax
  800a76:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7b:	52                   	push   %edx
  800a7c:	50                   	push   %eax
  800a7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a80:	ff 75 f0             	pushl  -0x10(%ebp)
  800a83:	e8 ac 1b 00 00       	call   802634 <__udivdi3>
  800a88:	83 c4 10             	add    $0x10,%esp
  800a8b:	83 ec 04             	sub    $0x4,%esp
  800a8e:	ff 75 20             	pushl  0x20(%ebp)
  800a91:	53                   	push   %ebx
  800a92:	ff 75 18             	pushl  0x18(%ebp)
  800a95:	52                   	push   %edx
  800a96:	50                   	push   %eax
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	ff 75 08             	pushl  0x8(%ebp)
  800a9d:	e8 a1 ff ff ff       	call   800a43 <printnum>
  800aa2:	83 c4 20             	add    $0x20,%esp
  800aa5:	eb 1a                	jmp    800ac1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	ff 75 20             	pushl  0x20(%ebp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ab8:	ff 4d 1c             	decl   0x1c(%ebp)
  800abb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800abf:	7f e6                	jg     800aa7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ac1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ac4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800acf:	53                   	push   %ebx
  800ad0:	51                   	push   %ecx
  800ad1:	52                   	push   %edx
  800ad2:	50                   	push   %eax
  800ad3:	e8 6c 1c 00 00       	call   802744 <__umoddi3>
  800ad8:	83 c4 10             	add    $0x10,%esp
  800adb:	05 34 2e 80 00       	add    $0x802e34,%eax
  800ae0:	8a 00                	mov    (%eax),%al
  800ae2:	0f be c0             	movsbl %al,%eax
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
}
  800af4:	90                   	nop
  800af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800afd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b01:	7e 1c                	jle    800b1f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	8d 50 08             	lea    0x8(%eax),%edx
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	89 10                	mov    %edx,(%eax)
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	83 e8 08             	sub    $0x8,%eax
  800b18:	8b 50 04             	mov    0x4(%eax),%edx
  800b1b:	8b 00                	mov    (%eax),%eax
  800b1d:	eb 40                	jmp    800b5f <getuint+0x65>
	else if (lflag)
  800b1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b23:	74 1e                	je     800b43 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	8d 50 04             	lea    0x4(%eax),%edx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	89 10                	mov    %edx,(%eax)
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 00                	mov    (%eax),%eax
  800b37:	83 e8 04             	sub    $0x4,%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b41:	eb 1c                	jmp    800b5f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b64:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b68:	7e 1c                	jle    800b86 <getint+0x25>
		return va_arg(*ap, long long);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 08             	lea    0x8(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 08             	sub    $0x8,%eax
  800b7f:	8b 50 04             	mov    0x4(%eax),%edx
  800b82:	8b 00                	mov    (%eax),%eax
  800b84:	eb 38                	jmp    800bbe <getint+0x5d>
	else if (lflag)
  800b86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8a:	74 1a                	je     800ba6 <getint+0x45>
		return va_arg(*ap, long);
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 00                	mov    (%eax),%eax
  800b91:	8d 50 04             	lea    0x4(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 10                	mov    %edx,(%eax)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 00                	mov    (%eax),%eax
  800b9e:	83 e8 04             	sub    $0x4,%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	99                   	cltd   
  800ba4:	eb 18                	jmp    800bbe <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	8d 50 04             	lea    0x4(%eax),%edx
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	89 10                	mov    %edx,(%eax)
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	83 e8 04             	sub    $0x4,%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	99                   	cltd   
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc8:	eb 17                	jmp    800be1 <vprintfmt+0x21>
			if (ch == '\0')
  800bca:	85 db                	test   %ebx,%ebx
  800bcc:	0f 84 af 03 00 00    	je     800f81 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	53                   	push   %ebx
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	ff d0                	call   *%eax
  800bde:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be1:	8b 45 10             	mov    0x10(%ebp),%eax
  800be4:	8d 50 01             	lea    0x1(%eax),%edx
  800be7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bea:	8a 00                	mov    (%eax),%al
  800bec:	0f b6 d8             	movzbl %al,%ebx
  800bef:	83 fb 25             	cmp    $0x25,%ebx
  800bf2:	75 d6                	jne    800bca <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bf4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bf8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c0d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1d:	8a 00                	mov    (%eax),%al
  800c1f:	0f b6 d8             	movzbl %al,%ebx
  800c22:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c25:	83 f8 55             	cmp    $0x55,%eax
  800c28:	0f 87 2b 03 00 00    	ja     800f59 <vprintfmt+0x399>
  800c2e:	8b 04 85 58 2e 80 00 	mov    0x802e58(,%eax,4),%eax
  800c35:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c37:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c3b:	eb d7                	jmp    800c14 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c3d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c41:	eb d1                	jmp    800c14 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4d:	89 d0                	mov    %edx,%eax
  800c4f:	c1 e0 02             	shl    $0x2,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	01 d8                	add    %ebx,%eax
  800c58:	83 e8 30             	sub    $0x30,%eax
  800c5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c66:	83 fb 2f             	cmp    $0x2f,%ebx
  800c69:	7e 3e                	jle    800ca9 <vprintfmt+0xe9>
  800c6b:	83 fb 39             	cmp    $0x39,%ebx
  800c6e:	7f 39                	jg     800ca9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c70:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c73:	eb d5                	jmp    800c4a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c75:	8b 45 14             	mov    0x14(%ebp),%eax
  800c78:	83 c0 04             	add    $0x4,%eax
  800c7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c81:	83 e8 04             	sub    $0x4,%eax
  800c84:	8b 00                	mov    (%eax),%eax
  800c86:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c89:	eb 1f                	jmp    800caa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8f:	79 83                	jns    800c14 <vprintfmt+0x54>
				width = 0;
  800c91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c98:	e9 77 ff ff ff       	jmp    800c14 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c9d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ca4:	e9 6b ff ff ff       	jmp    800c14 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ca9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800caa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cae:	0f 89 60 ff ff ff    	jns    800c14 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cc1:	e9 4e ff ff ff       	jmp    800c14 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cc6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cc9:	e9 46 ff ff ff       	jmp    800c14 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cce:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd1:	83 c0 04             	add    $0x4,%eax
  800cd4:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cda:	83 e8 04             	sub    $0x4,%eax
  800cdd:	8b 00                	mov    (%eax),%eax
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	50                   	push   %eax
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	ff d0                	call   *%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
			break;
  800cee:	e9 89 02 00 00       	jmp    800f7c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cf3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf6:	83 c0 04             	add    $0x4,%eax
  800cf9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cff:	83 e8 04             	sub    $0x4,%eax
  800d02:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d04:	85 db                	test   %ebx,%ebx
  800d06:	79 02                	jns    800d0a <vprintfmt+0x14a>
				err = -err;
  800d08:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d0a:	83 fb 64             	cmp    $0x64,%ebx
  800d0d:	7f 0b                	jg     800d1a <vprintfmt+0x15a>
  800d0f:	8b 34 9d a0 2c 80 00 	mov    0x802ca0(,%ebx,4),%esi
  800d16:	85 f6                	test   %esi,%esi
  800d18:	75 19                	jne    800d33 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d1a:	53                   	push   %ebx
  800d1b:	68 45 2e 80 00       	push   $0x802e45
  800d20:	ff 75 0c             	pushl  0xc(%ebp)
  800d23:	ff 75 08             	pushl  0x8(%ebp)
  800d26:	e8 5e 02 00 00       	call   800f89 <printfmt>
  800d2b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d2e:	e9 49 02 00 00       	jmp    800f7c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d33:	56                   	push   %esi
  800d34:	68 4e 2e 80 00       	push   $0x802e4e
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	ff 75 08             	pushl  0x8(%ebp)
  800d3f:	e8 45 02 00 00       	call   800f89 <printfmt>
  800d44:	83 c4 10             	add    $0x10,%esp
			break;
  800d47:	e9 30 02 00 00       	jmp    800f7c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4f:	83 c0 04             	add    $0x4,%eax
  800d52:	89 45 14             	mov    %eax,0x14(%ebp)
  800d55:	8b 45 14             	mov    0x14(%ebp),%eax
  800d58:	83 e8 04             	sub    $0x4,%eax
  800d5b:	8b 30                	mov    (%eax),%esi
  800d5d:	85 f6                	test   %esi,%esi
  800d5f:	75 05                	jne    800d66 <vprintfmt+0x1a6>
				p = "(null)";
  800d61:	be 51 2e 80 00       	mov    $0x802e51,%esi
			if (width > 0 && padc != '-')
  800d66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6a:	7e 6d                	jle    800dd9 <vprintfmt+0x219>
  800d6c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d70:	74 67                	je     800dd9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	50                   	push   %eax
  800d79:	56                   	push   %esi
  800d7a:	e8 12 05 00 00       	call   801291 <strnlen>
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d85:	eb 16                	jmp    800d9d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d87:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d8b:	83 ec 08             	sub    $0x8,%esp
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	50                   	push   %eax
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	ff d0                	call   *%eax
  800d97:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d9a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da1:	7f e4                	jg     800d87 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da3:	eb 34                	jmp    800dd9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800da5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800da9:	74 1c                	je     800dc7 <vprintfmt+0x207>
  800dab:	83 fb 1f             	cmp    $0x1f,%ebx
  800dae:	7e 05                	jle    800db5 <vprintfmt+0x1f5>
  800db0:	83 fb 7e             	cmp    $0x7e,%ebx
  800db3:	7e 12                	jle    800dc7 <vprintfmt+0x207>
					putch('?', putdat);
  800db5:	83 ec 08             	sub    $0x8,%esp
  800db8:	ff 75 0c             	pushl  0xc(%ebp)
  800dbb:	6a 3f                	push   $0x3f
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	ff d0                	call   *%eax
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	eb 0f                	jmp    800dd6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	53                   	push   %ebx
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	ff d0                	call   *%eax
  800dd3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd6:	ff 4d e4             	decl   -0x1c(%ebp)
  800dd9:	89 f0                	mov    %esi,%eax
  800ddb:	8d 70 01             	lea    0x1(%eax),%esi
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f be d8             	movsbl %al,%ebx
  800de3:	85 db                	test   %ebx,%ebx
  800de5:	74 24                	je     800e0b <vprintfmt+0x24b>
  800de7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800deb:	78 b8                	js     800da5 <vprintfmt+0x1e5>
  800ded:	ff 4d e0             	decl   -0x20(%ebp)
  800df0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df4:	79 af                	jns    800da5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df6:	eb 13                	jmp    800e0b <vprintfmt+0x24b>
				putch(' ', putdat);
  800df8:	83 ec 08             	sub    $0x8,%esp
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	6a 20                	push   $0x20
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	ff d0                	call   *%eax
  800e05:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e08:	ff 4d e4             	decl   -0x1c(%ebp)
  800e0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0f:	7f e7                	jg     800df8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e11:	e9 66 01 00 00       	jmp    800f7c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 3c fd ff ff       	call   800b61 <getint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e34:	85 d2                	test   %edx,%edx
  800e36:	79 23                	jns    800e5b <vprintfmt+0x29b>
				putch('-', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 2d                	push   $0x2d
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4e:	f7 d8                	neg    %eax
  800e50:	83 d2 00             	adc    $0x0,%edx
  800e53:	f7 da                	neg    %edx
  800e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e5b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e62:	e9 bc 00 00 00       	jmp    800f23 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e67:	83 ec 08             	sub    $0x8,%esp
  800e6a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e70:	50                   	push   %eax
  800e71:	e8 84 fc ff ff       	call   800afa <getuint>
  800e76:	83 c4 10             	add    $0x10,%esp
  800e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e7f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e86:	e9 98 00 00 00       	jmp    800f23 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e8b:	83 ec 08             	sub    $0x8,%esp
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	6a 58                	push   $0x58
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	ff d0                	call   *%eax
  800e98:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	6a 58                	push   $0x58
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	ff d0                	call   *%eax
  800ea8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eab:	83 ec 08             	sub    $0x8,%esp
  800eae:	ff 75 0c             	pushl  0xc(%ebp)
  800eb1:	6a 58                	push   $0x58
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	ff d0                	call   *%eax
  800eb8:	83 c4 10             	add    $0x10,%esp
			break;
  800ebb:	e9 bc 00 00 00       	jmp    800f7c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ec0:	83 ec 08             	sub    $0x8,%esp
  800ec3:	ff 75 0c             	pushl  0xc(%ebp)
  800ec6:	6a 30                	push   $0x30
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	ff d0                	call   *%eax
  800ecd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	6a 78                	push   $0x78
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	ff d0                	call   *%eax
  800edd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ee0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee3:	83 c0 04             	add    $0x4,%eax
  800ee6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eec:	83 e8 04             	sub    $0x4,%eax
  800eef:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800efb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f02:	eb 1f                	jmp    800f23 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 e8             	pushl  -0x18(%ebp)
  800f0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f0d:	50                   	push   %eax
  800f0e:	e8 e7 fb ff ff       	call   800afa <getuint>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f1c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f23:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f2a:	83 ec 04             	sub    $0x4,%esp
  800f2d:	52                   	push   %edx
  800f2e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f31:	50                   	push   %eax
  800f32:	ff 75 f4             	pushl  -0xc(%ebp)
  800f35:	ff 75 f0             	pushl  -0x10(%ebp)
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	ff 75 08             	pushl  0x8(%ebp)
  800f3e:	e8 00 fb ff ff       	call   800a43 <printnum>
  800f43:	83 c4 20             	add    $0x20,%esp
			break;
  800f46:	eb 34                	jmp    800f7c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	ff 75 0c             	pushl  0xc(%ebp)
  800f4e:	53                   	push   %ebx
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	ff d0                	call   *%eax
  800f54:	83 c4 10             	add    $0x10,%esp
			break;
  800f57:	eb 23                	jmp    800f7c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f59:	83 ec 08             	sub    $0x8,%esp
  800f5c:	ff 75 0c             	pushl  0xc(%ebp)
  800f5f:	6a 25                	push   $0x25
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f69:	ff 4d 10             	decl   0x10(%ebp)
  800f6c:	eb 03                	jmp    800f71 <vprintfmt+0x3b1>
  800f6e:	ff 4d 10             	decl   0x10(%ebp)
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
  800f74:	48                   	dec    %eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 25                	cmp    $0x25,%al
  800f79:	75 f3                	jne    800f6e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f7b:	90                   	nop
		}
	}
  800f7c:	e9 47 fc ff ff       	jmp    800bc8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f81:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800f92:	83 c0 04             	add    $0x4,%eax
  800f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	50                   	push   %eax
  800f9f:	ff 75 0c             	pushl  0xc(%ebp)
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 16 fc ff ff       	call   800bc0 <vprintfmt>
  800faa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fad:	90                   	nop
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 08             	mov    0x8(%eax),%eax
  800fb9:	8d 50 01             	lea    0x1(%eax),%edx
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8b 10                	mov    (%eax),%edx
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	8b 40 04             	mov    0x4(%eax),%eax
  800fcd:	39 c2                	cmp    %eax,%edx
  800fcf:	73 12                	jae    800fe3 <sprintputch+0x33>
		*b->buf++ = ch;
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	8b 00                	mov    (%eax),%eax
  800fd6:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdc:	89 0a                	mov    %ecx,(%edx)
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	88 10                	mov    %dl,(%eax)
}
  800fe3:	90                   	nop
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801000:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100b:	74 06                	je     801013 <vsnprintf+0x2d>
  80100d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801011:	7f 07                	jg     80101a <vsnprintf+0x34>
		return -E_INVAL;
  801013:	b8 03 00 00 00       	mov    $0x3,%eax
  801018:	eb 20                	jmp    80103a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80101a:	ff 75 14             	pushl  0x14(%ebp)
  80101d:	ff 75 10             	pushl  0x10(%ebp)
  801020:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801023:	50                   	push   %eax
  801024:	68 b0 0f 80 00       	push   $0x800fb0
  801029:	e8 92 fb ff ff       	call   800bc0 <vprintfmt>
  80102e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801034:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801037:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801042:	8d 45 10             	lea    0x10(%ebp),%eax
  801045:	83 c0 04             	add    $0x4,%eax
  801048:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	ff 75 f4             	pushl  -0xc(%ebp)
  801051:	50                   	push   %eax
  801052:	ff 75 0c             	pushl  0xc(%ebp)
  801055:	ff 75 08             	pushl  0x8(%ebp)
  801058:	e8 89 ff ff ff       	call   800fe6 <vsnprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801063:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80106e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801072:	74 13                	je     801087 <readline+0x1f>
		cprintf("%s", prompt);
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	ff 75 08             	pushl  0x8(%ebp)
  80107a:	68 b0 2f 80 00       	push   $0x802fb0
  80107f:	e8 62 f9 ff ff       	call   8009e6 <cprintf>
  801084:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801087:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80108e:	83 ec 0c             	sub    $0xc,%esp
  801091:	6a 00                	push   $0x0
  801093:	e8 5d f5 ff ff       	call   8005f5 <iscons>
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80109e:	e8 04 f5 ff ff       	call   8005a7 <getchar>
  8010a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010aa:	79 22                	jns    8010ce <readline+0x66>
			if (c != -E_EOF)
  8010ac:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010b0:	0f 84 ad 00 00 00    	je     801163 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010b6:	83 ec 08             	sub    $0x8,%esp
  8010b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8010bc:	68 b3 2f 80 00       	push   $0x802fb3
  8010c1:	e8 20 f9 ff ff       	call   8009e6 <cprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
			return;
  8010c9:	e9 95 00 00 00       	jmp    801163 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010ce:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010d2:	7e 34                	jle    801108 <readline+0xa0>
  8010d4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010db:	7f 2b                	jg     801108 <readline+0xa0>
			if (echoing)
  8010dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010e1:	74 0e                	je     8010f1 <readline+0x89>
				cputchar(c);
  8010e3:	83 ec 0c             	sub    $0xc,%esp
  8010e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8010e9:	e8 71 f4 ff ff       	call   80055f <cputchar>
  8010ee:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f4:	8d 50 01             	lea    0x1(%eax),%edx
  8010f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801104:	88 10                	mov    %dl,(%eax)
  801106:	eb 56                	jmp    80115e <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801108:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80110c:	75 1f                	jne    80112d <readline+0xc5>
  80110e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801112:	7e 19                	jle    80112d <readline+0xc5>
			if (echoing)
  801114:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801118:	74 0e                	je     801128 <readline+0xc0>
				cputchar(c);
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	ff 75 ec             	pushl  -0x14(%ebp)
  801120:	e8 3a f4 ff ff       	call   80055f <cputchar>
  801125:	83 c4 10             	add    $0x10,%esp

			i--;
  801128:	ff 4d f4             	decl   -0xc(%ebp)
  80112b:	eb 31                	jmp    80115e <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80112d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801131:	74 0a                	je     80113d <readline+0xd5>
  801133:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801137:	0f 85 61 ff ff ff    	jne    80109e <readline+0x36>
			if (echoing)
  80113d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801141:	74 0e                	je     801151 <readline+0xe9>
				cputchar(c);
  801143:	83 ec 0c             	sub    $0xc,%esp
  801146:	ff 75 ec             	pushl  -0x14(%ebp)
  801149:	e8 11 f4 ff ff       	call   80055f <cputchar>
  80114e:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 d0                	add    %edx,%eax
  801159:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80115c:	eb 06                	jmp    801164 <readline+0xfc>
		}
	}
  80115e:	e9 3b ff ff ff       	jmp    80109e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801163:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80116c:	e8 9f 10 00 00       	call   802210 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801171:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801175:	74 13                	je     80118a <atomic_readline+0x24>
		cprintf("%s", prompt);
  801177:	83 ec 08             	sub    $0x8,%esp
  80117a:	ff 75 08             	pushl  0x8(%ebp)
  80117d:	68 b0 2f 80 00       	push   $0x802fb0
  801182:	e8 5f f8 ff ff       	call   8009e6 <cprintf>
  801187:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80118a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	6a 00                	push   $0x0
  801196:	e8 5a f4 ff ff       	call   8005f5 <iscons>
  80119b:	83 c4 10             	add    $0x10,%esp
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011a1:	e8 01 f4 ff ff       	call   8005a7 <getchar>
  8011a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011ad:	79 23                	jns    8011d2 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011af:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011b3:	74 13                	je     8011c8 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8011bb:	68 b3 2f 80 00       	push   $0x802fb3
  8011c0:	e8 21 f8 ff ff       	call   8009e6 <cprintf>
  8011c5:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011c8:	e8 5d 10 00 00       	call   80222a <sys_enable_interrupt>
			return;
  8011cd:	e9 9a 00 00 00       	jmp    80126c <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011d2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011d6:	7e 34                	jle    80120c <atomic_readline+0xa6>
  8011d8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011df:	7f 2b                	jg     80120c <atomic_readline+0xa6>
			if (echoing)
  8011e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011e5:	74 0e                	je     8011f5 <atomic_readline+0x8f>
				cputchar(c);
  8011e7:	83 ec 0c             	sub    $0xc,%esp
  8011ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8011ed:	e8 6d f3 ff ff       	call   80055f <cputchar>
  8011f2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f8:	8d 50 01             	lea    0x1(%eax),%edx
  8011fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011fe:	89 c2                	mov    %eax,%edx
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801208:	88 10                	mov    %dl,(%eax)
  80120a:	eb 5b                	jmp    801267 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80120c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801210:	75 1f                	jne    801231 <atomic_readline+0xcb>
  801212:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801216:	7e 19                	jle    801231 <atomic_readline+0xcb>
			if (echoing)
  801218:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80121c:	74 0e                	je     80122c <atomic_readline+0xc6>
				cputchar(c);
  80121e:	83 ec 0c             	sub    $0xc,%esp
  801221:	ff 75 ec             	pushl  -0x14(%ebp)
  801224:	e8 36 f3 ff ff       	call   80055f <cputchar>
  801229:	83 c4 10             	add    $0x10,%esp
			i--;
  80122c:	ff 4d f4             	decl   -0xc(%ebp)
  80122f:	eb 36                	jmp    801267 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801231:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801235:	74 0a                	je     801241 <atomic_readline+0xdb>
  801237:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80123b:	0f 85 60 ff ff ff    	jne    8011a1 <atomic_readline+0x3b>
			if (echoing)
  801241:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801245:	74 0e                	je     801255 <atomic_readline+0xef>
				cputchar(c);
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	ff 75 ec             	pushl  -0x14(%ebp)
  80124d:	e8 0d f3 ff ff       	call   80055f <cputchar>
  801252:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801255:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	01 d0                	add    %edx,%eax
  80125d:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801260:	e8 c5 0f 00 00       	call   80222a <sys_enable_interrupt>
			return;
  801265:	eb 05                	jmp    80126c <atomic_readline+0x106>
		}
	}
  801267:	e9 35 ff ff ff       	jmp    8011a1 <atomic_readline+0x3b>
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80127b:	eb 06                	jmp    801283 <strlen+0x15>
		n++;
  80127d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 f1                	jne    80127d <strlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129e:	eb 09                	jmp    8012a9 <strnlen+0x18>
		n++;
  8012a0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012a3:	ff 45 08             	incl   0x8(%ebp)
  8012a6:	ff 4d 0c             	decl   0xc(%ebp)
  8012a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ad:	74 09                	je     8012b8 <strnlen+0x27>
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	75 e8                	jne    8012a0 <strnlen+0xf>
		n++;
	return n;
  8012b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012c9:	90                   	nop
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8d 50 01             	lea    0x1(%eax),%edx
  8012d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8012d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012dc:	8a 12                	mov    (%edx),%dl
  8012de:	88 10                	mov    %dl,(%eax)
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	84 c0                	test   %al,%al
  8012e4:	75 e4                	jne    8012ca <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fe:	eb 1f                	jmp    80131f <strncpy+0x34>
		*dst++ = *src;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8d 50 01             	lea    0x1(%eax),%edx
  801306:	89 55 08             	mov    %edx,0x8(%ebp)
  801309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130c:	8a 12                	mov    (%edx),%dl
  80130e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	84 c0                	test   %al,%al
  801317:	74 03                	je     80131c <strncpy+0x31>
			src++;
  801319:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80131c:	ff 45 fc             	incl   -0x4(%ebp)
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801322:	3b 45 10             	cmp    0x10(%ebp),%eax
  801325:	72 d9                	jb     801300 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801338:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133c:	74 30                	je     80136e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80133e:	eb 16                	jmp    801356 <strlcpy+0x2a>
			*dst++ = *src++;
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8d 50 01             	lea    0x1(%eax),%edx
  801346:	89 55 08             	mov    %edx,0x8(%ebp)
  801349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801352:	8a 12                	mov    (%edx),%dl
  801354:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801356:	ff 4d 10             	decl   0x10(%ebp)
  801359:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135d:	74 09                	je     801368 <strlcpy+0x3c>
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	84 c0                	test   %al,%al
  801366:	75 d8                	jne    801340 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80136e:	8b 55 08             	mov    0x8(%ebp),%edx
  801371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801374:	29 c2                	sub    %eax,%edx
  801376:	89 d0                	mov    %edx,%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80137d:	eb 06                	jmp    801385 <strcmp+0xb>
		p++, q++;
  80137f:	ff 45 08             	incl   0x8(%ebp)
  801382:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	84 c0                	test   %al,%al
  80138c:	74 0e                	je     80139c <strcmp+0x22>
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 10                	mov    (%eax),%dl
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	38 c2                	cmp    %al,%dl
  80139a:	74 e3                	je     80137f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	0f b6 d0             	movzbl %al,%edx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	0f b6 c0             	movzbl %al,%eax
  8013ac:	29 c2                	sub    %eax,%edx
  8013ae:	89 d0                	mov    %edx,%eax
}
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    

008013b2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013b5:	eb 09                	jmp    8013c0 <strncmp+0xe>
		n--, p++, q++;
  8013b7:	ff 4d 10             	decl   0x10(%ebp)
  8013ba:	ff 45 08             	incl   0x8(%ebp)
  8013bd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c4:	74 17                	je     8013dd <strncmp+0x2b>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 0e                	je     8013dd <strncmp+0x2b>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 10                	mov    (%eax),%dl
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	38 c2                	cmp    %al,%dl
  8013db:	74 da                	je     8013b7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 07                	jne    8013ea <strncmp+0x38>
		return 0;
  8013e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e8:	eb 14                	jmp    8013fe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80140c:	eb 12                	jmp    801420 <strchr+0x20>
		if (*s == c)
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801416:	75 05                	jne    80141d <strchr+0x1d>
			return (char *) s;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	eb 11                	jmp    80142e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80141d:	ff 45 08             	incl   0x8(%ebp)
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	84 c0                	test   %al,%al
  801427:	75 e5                	jne    80140e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80143c:	eb 0d                	jmp    80144b <strfind+0x1b>
		if (*s == c)
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801446:	74 0e                	je     801456 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	84 c0                	test   %al,%al
  801452:	75 ea                	jne    80143e <strfind+0xe>
  801454:	eb 01                	jmp    801457 <strfind+0x27>
		if (*s == c)
			break;
  801456:	90                   	nop
	return (char *) s;
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80146e:	eb 0e                	jmp    80147e <memset+0x22>
		*p++ = c;
  801470:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801473:	8d 50 01             	lea    0x1(%eax),%edx
  801476:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80147e:	ff 4d f8             	decl   -0x8(%ebp)
  801481:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801485:	79 e9                	jns    801470 <memset+0x14>
		*p++ = c;

	return v;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80149e:	eb 16                	jmp    8014b6 <memcpy+0x2a>
		*d++ = *s++;
  8014a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a3:	8d 50 01             	lea    0x1(%eax),%edx
  8014a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014b2:	8a 12                	mov    (%edx),%dl
  8014b4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	75 dd                	jne    8014a0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e0:	73 50                	jae    801532 <memmove+0x6a>
  8014e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	01 d0                	add    %edx,%eax
  8014ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014ed:	76 43                	jbe    801532 <memmove+0x6a>
		s += n;
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014fb:	eb 10                	jmp    80150d <memmove+0x45>
			*--d = *--s;
  8014fd:	ff 4d f8             	decl   -0x8(%ebp)
  801500:	ff 4d fc             	decl   -0x4(%ebp)
  801503:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801506:	8a 10                	mov    (%eax),%dl
  801508:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80150d:	8b 45 10             	mov    0x10(%ebp),%eax
  801510:	8d 50 ff             	lea    -0x1(%eax),%edx
  801513:	89 55 10             	mov    %edx,0x10(%ebp)
  801516:	85 c0                	test   %eax,%eax
  801518:	75 e3                	jne    8014fd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80151a:	eb 23                	jmp    80153f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80151c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151f:	8d 50 01             	lea    0x1(%eax),%edx
  801522:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801525:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801528:	8d 4a 01             	lea    0x1(%edx),%ecx
  80152b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80152e:	8a 12                	mov    (%edx),%dl
  801530:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	8d 50 ff             	lea    -0x1(%eax),%edx
  801538:	89 55 10             	mov    %edx,0x10(%ebp)
  80153b:	85 c0                	test   %eax,%eax
  80153d:	75 dd                	jne    80151c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801556:	eb 2a                	jmp    801582 <memcmp+0x3e>
		if (*s1 != *s2)
  801558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155b:	8a 10                	mov    (%eax),%dl
  80155d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	38 c2                	cmp    %al,%dl
  801564:	74 16                	je     80157c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	0f b6 d0             	movzbl %al,%edx
  80156e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	0f b6 c0             	movzbl %al,%eax
  801576:	29 c2                	sub    %eax,%edx
  801578:	89 d0                	mov    %edx,%eax
  80157a:	eb 18                	jmp    801594 <memcmp+0x50>
		s1++, s2++;
  80157c:	ff 45 fc             	incl   -0x4(%ebp)
  80157f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801582:	8b 45 10             	mov    0x10(%ebp),%eax
  801585:	8d 50 ff             	lea    -0x1(%eax),%edx
  801588:	89 55 10             	mov    %edx,0x10(%ebp)
  80158b:	85 c0                	test   %eax,%eax
  80158d:	75 c9                	jne    801558 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80159c:	8b 55 08             	mov    0x8(%ebp),%edx
  80159f:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a2:	01 d0                	add    %edx,%eax
  8015a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015a7:	eb 15                	jmp    8015be <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	0f b6 d0             	movzbl %al,%edx
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	0f b6 c0             	movzbl %al,%eax
  8015b7:	39 c2                	cmp    %eax,%edx
  8015b9:	74 0d                	je     8015c8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015bb:	ff 45 08             	incl   0x8(%ebp)
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015c4:	72 e3                	jb     8015a9 <memfind+0x13>
  8015c6:	eb 01                	jmp    8015c9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015c8:	90                   	nop
	return (void *) s;
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e2:	eb 03                	jmp    8015e7 <strtol+0x19>
		s++;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	8a 00                	mov    (%eax),%al
  8015ec:	3c 20                	cmp    $0x20,%al
  8015ee:	74 f4                	je     8015e4 <strtol+0x16>
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	3c 09                	cmp    $0x9,%al
  8015f7:	74 eb                	je     8015e4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	8a 00                	mov    (%eax),%al
  8015fe:	3c 2b                	cmp    $0x2b,%al
  801600:	75 05                	jne    801607 <strtol+0x39>
		s++;
  801602:	ff 45 08             	incl   0x8(%ebp)
  801605:	eb 13                	jmp    80161a <strtol+0x4c>
	else if (*s == '-')
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 2d                	cmp    $0x2d,%al
  80160e:	75 0a                	jne    80161a <strtol+0x4c>
		s++, neg = 1;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	74 06                	je     801626 <strtol+0x58>
  801620:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801624:	75 20                	jne    801646 <strtol+0x78>
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	3c 30                	cmp    $0x30,%al
  80162d:	75 17                	jne    801646 <strtol+0x78>
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	40                   	inc    %eax
  801633:	8a 00                	mov    (%eax),%al
  801635:	3c 78                	cmp    $0x78,%al
  801637:	75 0d                	jne    801646 <strtol+0x78>
		s += 2, base = 16;
  801639:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80163d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801644:	eb 28                	jmp    80166e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801646:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164a:	75 15                	jne    801661 <strtol+0x93>
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	3c 30                	cmp    $0x30,%al
  801653:	75 0c                	jne    801661 <strtol+0x93>
		s++, base = 8;
  801655:	ff 45 08             	incl   0x8(%ebp)
  801658:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80165f:	eb 0d                	jmp    80166e <strtol+0xa0>
	else if (base == 0)
  801661:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801665:	75 07                	jne    80166e <strtol+0xa0>
		base = 10;
  801667:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	8a 00                	mov    (%eax),%al
  801673:	3c 2f                	cmp    $0x2f,%al
  801675:	7e 19                	jle    801690 <strtol+0xc2>
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8a 00                	mov    (%eax),%al
  80167c:	3c 39                	cmp    $0x39,%al
  80167e:	7f 10                	jg     801690 <strtol+0xc2>
			dig = *s - '0';
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	0f be c0             	movsbl %al,%eax
  801688:	83 e8 30             	sub    $0x30,%eax
  80168b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168e:	eb 42                	jmp    8016d2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	3c 60                	cmp    $0x60,%al
  801697:	7e 19                	jle    8016b2 <strtol+0xe4>
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	3c 7a                	cmp    $0x7a,%al
  8016a0:	7f 10                	jg     8016b2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	0f be c0             	movsbl %al,%eax
  8016aa:	83 e8 57             	sub    $0x57,%eax
  8016ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b0:	eb 20                	jmp    8016d2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	3c 40                	cmp    $0x40,%al
  8016b9:	7e 39                	jle    8016f4 <strtol+0x126>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	3c 5a                	cmp    $0x5a,%al
  8016c2:	7f 30                	jg     8016f4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	8a 00                	mov    (%eax),%al
  8016c9:	0f be c0             	movsbl %al,%eax
  8016cc:	83 e8 37             	sub    $0x37,%eax
  8016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016d8:	7d 19                	jge    8016f3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016da:	ff 45 08             	incl   0x8(%ebp)
  8016dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e9:	01 d0                	add    %edx,%eax
  8016eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016ee:	e9 7b ff ff ff       	jmp    80166e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016f3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016f8:	74 08                	je     801702 <strtol+0x134>
		*endptr = (char *) s;
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801700:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801702:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801706:	74 07                	je     80170f <strtol+0x141>
  801708:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170b:	f7 d8                	neg    %eax
  80170d:	eb 03                	jmp    801712 <strtol+0x144>
  80170f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <ltostr>:

void
ltostr(long value, char *str)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80171a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801721:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801728:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80172c:	79 13                	jns    801741 <ltostr+0x2d>
	{
		neg = 1;
  80172e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801735:	8b 45 0c             	mov    0xc(%ebp),%eax
  801738:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80173b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80173e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801749:	99                   	cltd   
  80174a:	f7 f9                	idiv   %ecx
  80174c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801752:	8d 50 01             	lea    0x1(%eax),%edx
  801755:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801758:	89 c2                	mov    %eax,%edx
  80175a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175d:	01 d0                	add    %edx,%eax
  80175f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801762:	83 c2 30             	add    $0x30,%edx
  801765:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801767:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80176f:	f7 e9                	imul   %ecx
  801771:	c1 fa 02             	sar    $0x2,%edx
  801774:	89 c8                	mov    %ecx,%eax
  801776:	c1 f8 1f             	sar    $0x1f,%eax
  801779:	29 c2                	sub    %eax,%edx
  80177b:	89 d0                	mov    %edx,%eax
  80177d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801780:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801783:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801788:	f7 e9                	imul   %ecx
  80178a:	c1 fa 02             	sar    $0x2,%edx
  80178d:	89 c8                	mov    %ecx,%eax
  80178f:	c1 f8 1f             	sar    $0x1f,%eax
  801792:	29 c2                	sub    %eax,%edx
  801794:	89 d0                	mov    %edx,%eax
  801796:	c1 e0 02             	shl    $0x2,%eax
  801799:	01 d0                	add    %edx,%eax
  80179b:	01 c0                	add    %eax,%eax
  80179d:	29 c1                	sub    %eax,%ecx
  80179f:	89 ca                	mov    %ecx,%edx
  8017a1:	85 d2                	test   %edx,%edx
  8017a3:	75 9c                	jne    801741 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	48                   	dec    %eax
  8017b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017b7:	74 3d                	je     8017f6 <ltostr+0xe2>
		start = 1 ;
  8017b9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017c0:	eb 34                	jmp    8017f6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	01 d0                	add    %edx,%eax
  8017ca:	8a 00                	mov    (%eax),%al
  8017cc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d5:	01 c2                	add    %eax,%edx
  8017d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c8                	add    %ecx,%eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e9:	01 c2                	add    %eax,%edx
  8017eb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017ee:	88 02                	mov    %al,(%edx)
		start++ ;
  8017f0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017f3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017fc:	7c c4                	jl     8017c2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801801:	8b 45 0c             	mov    0xc(%ebp),%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801809:	90                   	nop
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	e8 54 fa ff ff       	call   80126e <strlen>
  80181a:	83 c4 04             	add    $0x4,%esp
  80181d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	e8 46 fa ff ff       	call   80126e <strlen>
  801828:	83 c4 04             	add    $0x4,%esp
  80182b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80182e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80183c:	eb 17                	jmp    801855 <strcconcat+0x49>
		final[s] = str1[s] ;
  80183e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801841:	8b 45 10             	mov    0x10(%ebp),%eax
  801844:	01 c2                	add    %eax,%edx
  801846:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	01 c8                	add    %ecx,%eax
  80184e:	8a 00                	mov    (%eax),%al
  801850:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801852:	ff 45 fc             	incl   -0x4(%ebp)
  801855:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801858:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80185b:	7c e1                	jl     80183e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80185d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801864:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80186b:	eb 1f                	jmp    80188c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80186d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801870:	8d 50 01             	lea    0x1(%eax),%edx
  801873:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801876:	89 c2                	mov    %eax,%edx
  801878:	8b 45 10             	mov    0x10(%ebp),%eax
  80187b:	01 c2                	add    %eax,%edx
  80187d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801880:	8b 45 0c             	mov    0xc(%ebp),%eax
  801883:	01 c8                	add    %ecx,%eax
  801885:	8a 00                	mov    (%eax),%al
  801887:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801889:	ff 45 f8             	incl   -0x8(%ebp)
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801892:	7c d9                	jl     80186d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801894:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801897:	8b 45 10             	mov    0x10(%ebp),%eax
  80189a:	01 d0                	add    %edx,%eax
  80189c:	c6 00 00             	movb   $0x0,(%eax)
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b1:	8b 00                	mov    (%eax),%eax
  8018b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bd:	01 d0                	add    %edx,%eax
  8018bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c5:	eb 0c                	jmp    8018d3 <strsplit+0x31>
			*string++ = 0;
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8d 50 01             	lea    0x1(%eax),%edx
  8018cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	8a 00                	mov    (%eax),%al
  8018d8:	84 c0                	test   %al,%al
  8018da:	74 18                	je     8018f4 <strsplit+0x52>
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	8a 00                	mov    (%eax),%al
  8018e1:	0f be c0             	movsbl %al,%eax
  8018e4:	50                   	push   %eax
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	e8 13 fb ff ff       	call   801400 <strchr>
  8018ed:	83 c4 08             	add    $0x8,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	75 d3                	jne    8018c7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	84 c0                	test   %al,%al
  8018fb:	74 5a                	je     801957 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801900:	8b 00                	mov    (%eax),%eax
  801902:	83 f8 0f             	cmp    $0xf,%eax
  801905:	75 07                	jne    80190e <strsplit+0x6c>
		{
			return 0;
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
  80190c:	eb 66                	jmp    801974 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80190e:	8b 45 14             	mov    0x14(%ebp),%eax
  801911:	8b 00                	mov    (%eax),%eax
  801913:	8d 48 01             	lea    0x1(%eax),%ecx
  801916:	8b 55 14             	mov    0x14(%ebp),%edx
  801919:	89 0a                	mov    %ecx,(%edx)
  80191b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	01 c2                	add    %eax,%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80192c:	eb 03                	jmp    801931 <strsplit+0x8f>
			string++;
  80192e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	8a 00                	mov    (%eax),%al
  801936:	84 c0                	test   %al,%al
  801938:	74 8b                	je     8018c5 <strsplit+0x23>
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	0f be c0             	movsbl %al,%eax
  801942:	50                   	push   %eax
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	e8 b5 fa ff ff       	call   801400 <strchr>
  80194b:	83 c4 08             	add    $0x8,%esp
  80194e:	85 c0                	test   %eax,%eax
  801950:	74 dc                	je     80192e <strsplit+0x8c>
			string++;
	}
  801952:	e9 6e ff ff ff       	jmp    8018c5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801957:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801958:	8b 45 14             	mov    0x14(%ebp),%eax
  80195b:	8b 00                	mov    (%eax),%eax
  80195d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	01 d0                	add    %edx,%eax
  801969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80196f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80197c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801983:	8b 55 08             	mov    0x8(%ebp),%edx
  801986:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	48                   	dec    %eax
  80198c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80198f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801992:	ba 00 00 00 00       	mov    $0x0,%edx
  801997:	f7 75 ac             	divl   -0x54(%ebp)
  80199a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80199d:	29 d0                	sub    %edx,%eax
  80199f:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8019a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8019a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8019b0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8019b7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019be:	eb 3f                	jmp    8019ff <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8019c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019c3:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	50                   	push   %eax
  8019ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8019d1:	68 c4 2f 80 00       	push   $0x802fc4
  8019d6:	e8 0b f0 ff ff       	call   8009e6 <cprintf>
  8019db:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8019de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019e1:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	50                   	push   %eax
  8019ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8019ef:	68 d9 2f 80 00       	push   $0x802fd9
  8019f4:	e8 ed ef ff ff       	call   8009e6 <cprintf>
  8019f9:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8019fc:	ff 45 e8             	incl   -0x18(%ebp)
  8019ff:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a04:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801a07:	7c b7                	jl     8019c0 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a09:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801a10:	e9 35 01 00 00       	jmp    801b4a <malloc+0x1d4>
		int flag0=1;
  801a15:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a22:	eb 5e                	jmp    801a82 <malloc+0x10c>
			for(int k=0;k<count;k++){
  801a24:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a2b:	eb 35                	jmp    801a62 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a30:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801a37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a3a:	39 c2                	cmp    %eax,%edx
  801a3c:	77 21                	ja     801a5f <malloc+0xe9>
  801a3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a41:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801a48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a4b:	39 c2                	cmp    %eax,%edx
  801a4d:	76 10                	jbe    801a5f <malloc+0xe9>
					ni=PAGE_SIZE;
  801a4f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  801a56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801a5d:	eb 0d                	jmp    801a6c <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801a5f:	ff 45 d8             	incl   -0x28(%ebp)
  801a62:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a67:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801a6a:	7c c1                	jl     801a2d <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801a6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a70:	74 09                	je     801a7b <malloc+0x105>
				flag0=0;
  801a72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801a79:	eb 16                	jmp    801a91 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a7b:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801a82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	01 c2                	add    %eax,%edx
  801a8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a8d:	39 c2                	cmp    %eax,%edx
  801a8f:	77 93                	ja     801a24 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801a91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a95:	0f 84 a2 00 00 00    	je     801b3d <malloc+0x1c7>

			int f=1;
  801a9b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801aa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aa5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801aa8:	89 c8                	mov    %ecx,%eax
  801aaa:	01 c0                	add    %eax,%eax
  801aac:	01 c8                	add    %ecx,%eax
  801aae:	c1 e0 02             	shl    $0x2,%eax
  801ab1:	05 20 41 80 00       	add    $0x804120,%eax
  801ab6:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801ab8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ac1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 02             	shl    $0x2,%eax
  801acd:	05 24 41 80 00       	add    $0x804124,%eax
  801ad2:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad7:	89 d0                	mov    %edx,%eax
  801ad9:	01 c0                	add    %eax,%eax
  801adb:	01 d0                	add    %edx,%eax
  801add:	c1 e0 02             	shl    $0x2,%eax
  801ae0:	05 28 41 80 00       	add    $0x804128,%eax
  801ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801aeb:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801aee:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801af5:	eb 36                	jmp    801b2d <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  801af7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	01 c2                	add    %eax,%edx
  801aff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b02:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801b09:	39 c2                	cmp    %eax,%edx
  801b0b:	73 1d                	jae    801b2a <malloc+0x1b4>
					ni=arr_add[l].end-i;
  801b0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b10:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1a:	29 c2                	sub    %eax,%edx
  801b1c:	89 d0                	mov    %edx,%eax
  801b1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801b21:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801b28:	eb 0d                	jmp    801b37 <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801b2a:	ff 45 d0             	incl   -0x30(%ebp)
  801b2d:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b32:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801b35:	7c c0                	jl     801af7 <malloc+0x181>
					break;

				}
			}

			if(f){
  801b37:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801b3b:	75 1d                	jne    801b5a <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  801b3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b47:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801b4a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b4f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b52:	0f 8c bd fe ff ff    	jl     801a15 <malloc+0x9f>
  801b58:	eb 01                	jmp    801b5b <malloc+0x1e5>

				}
			}

			if(f){
				break;
  801b5a:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b5f:	75 7a                	jne    801bdb <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801b61:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	01 d0                	add    %edx,%eax
  801b6c:	48                   	dec    %eax
  801b6d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801b72:	7c 0a                	jl     801b7e <malloc+0x208>
			return NULL;
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
  801b79:	e9 a4 02 00 00       	jmp    801e22 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  801b7e:	a1 04 40 80 00       	mov    0x804004,%eax
  801b83:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801b86:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b8b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801b8e:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	ff 75 a4             	pushl  -0x5c(%ebp)
  801b9e:	e8 04 06 00 00       	call   8021a7 <sys_allocateMem>
  801ba3:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801ba6:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	01 d0                	add    %edx,%eax
  801bb1:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801bb6:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bbb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bc1:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801bc8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bcd:	40                   	inc    %eax
  801bce:	a3 2c 40 80 00       	mov    %eax,0x80402c

			return (void*)s;
  801bd3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801bd6:	e9 47 02 00 00       	jmp    801e22 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  801bdb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801be2:	e9 ac 00 00 00       	jmp    801c93 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801be7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801bea:	89 d0                	mov    %edx,%eax
  801bec:	01 c0                	add    %eax,%eax
  801bee:	01 d0                	add    %edx,%eax
  801bf0:	c1 e0 02             	shl    $0x2,%eax
  801bf3:	05 24 41 80 00       	add    $0x804124,%eax
  801bf8:	8b 00                	mov    (%eax),%eax
  801bfa:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801bfd:	eb 7e                	jmp    801c7d <malloc+0x307>
			int flag=0;
  801bff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801c06:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801c0d:	eb 57                	jmp    801c66 <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801c0f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c12:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c19:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c1c:	39 c2                	cmp    %eax,%edx
  801c1e:	77 1a                	ja     801c3a <malloc+0x2c4>
  801c20:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c23:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c2a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c2d:	39 c2                	cmp    %eax,%edx
  801c2f:	76 09                	jbe    801c3a <malloc+0x2c4>
								flag=1;
  801c31:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801c38:	eb 36                	jmp    801c70 <malloc+0x2fa>
			arr[i].space++;
  801c3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c3d:	89 d0                	mov    %edx,%eax
  801c3f:	01 c0                	add    %eax,%eax
  801c41:	01 d0                	add    %edx,%eax
  801c43:	c1 e0 02             	shl    $0x2,%eax
  801c46:	05 28 41 80 00       	add    $0x804128,%eax
  801c4b:	8b 00                	mov    (%eax),%eax
  801c4d:	8d 48 01             	lea    0x1(%eax),%ecx
  801c50:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c53:	89 d0                	mov    %edx,%eax
  801c55:	01 c0                	add    %eax,%eax
  801c57:	01 d0                	add    %edx,%eax
  801c59:	c1 e0 02             	shl    $0x2,%eax
  801c5c:	05 28 41 80 00       	add    $0x804128,%eax
  801c61:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801c63:	ff 45 c0             	incl   -0x40(%ebp)
  801c66:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c6b:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801c6e:	7c 9f                	jl     801c0f <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801c70:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801c74:	75 19                	jne    801c8f <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801c76:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801c7d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801c80:	a1 04 40 80 00       	mov    0x804004,%eax
  801c85:	39 c2                	cmp    %eax,%edx
  801c87:	0f 82 72 ff ff ff    	jb     801bff <malloc+0x289>
  801c8d:	eb 01                	jmp    801c90 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801c8f:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801c90:	ff 45 cc             	incl   -0x34(%ebp)
  801c93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c99:	0f 8c 48 ff ff ff    	jl     801be7 <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801c9f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801ca6:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801cad:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801cb4:	eb 37                	jmp    801ced <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801cb6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801cb9:	89 d0                	mov    %edx,%eax
  801cbb:	01 c0                	add    %eax,%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	c1 e0 02             	shl    $0x2,%eax
  801cc2:	05 28 41 80 00       	add    $0x804128,%eax
  801cc7:	8b 00                	mov    (%eax),%eax
  801cc9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801ccc:	7d 1c                	jge    801cea <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801cce:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	01 c0                	add    %eax,%eax
  801cd5:	01 d0                	add    %edx,%eax
  801cd7:	c1 e0 02             	shl    $0x2,%eax
  801cda:	05 28 41 80 00       	add    $0x804128,%eax
  801cdf:	8b 00                	mov    (%eax),%eax
  801ce1:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801ce4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801ce7:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801cea:	ff 45 b4             	incl   -0x4c(%ebp)
  801ced:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801cf0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cf3:	7c c1                	jl     801cb6 <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801cf5:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801cfb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	01 c0                	add    %eax,%eax
  801d02:	01 c8                	add    %ecx,%eax
  801d04:	c1 e0 02             	shl    $0x2,%eax
  801d07:	05 20 41 80 00       	add    $0x804120,%eax
  801d0c:	8b 00                	mov    (%eax),%eax
  801d0e:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801d15:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801d1b:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d1e:	89 c8                	mov    %ecx,%eax
  801d20:	01 c0                	add    %eax,%eax
  801d22:	01 c8                	add    %ecx,%eax
  801d24:	c1 e0 02             	shl    $0x2,%eax
  801d27:	05 24 41 80 00       	add    $0x804124,%eax
  801d2c:	8b 00                	mov    (%eax),%eax
  801d2e:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801d35:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d3a:	40                   	inc    %eax
  801d3b:	a3 2c 40 80 00       	mov    %eax,0x80402c


		sys_allocateMem(arr[index].start,size);
  801d40:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	01 c0                	add    %eax,%eax
  801d47:	01 d0                	add    %edx,%eax
  801d49:	c1 e0 02             	shl    $0x2,%eax
  801d4c:	05 20 41 80 00       	add    $0x804120,%eax
  801d51:	8b 00                	mov    (%eax),%eax
  801d53:	83 ec 08             	sub    $0x8,%esp
  801d56:	ff 75 08             	pushl  0x8(%ebp)
  801d59:	50                   	push   %eax
  801d5a:	e8 48 04 00 00       	call   8021a7 <sys_allocateMem>
  801d5f:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801d62:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801d69:	eb 78                	jmp    801de3 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801d6b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801d6e:	89 d0                	mov    %edx,%eax
  801d70:	01 c0                	add    %eax,%eax
  801d72:	01 d0                	add    %edx,%eax
  801d74:	c1 e0 02             	shl    $0x2,%eax
  801d77:	05 20 41 80 00       	add    $0x804120,%eax
  801d7c:	8b 00                	mov    (%eax),%eax
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	50                   	push   %eax
  801d82:	ff 75 b0             	pushl  -0x50(%ebp)
  801d85:	68 c4 2f 80 00       	push   $0x802fc4
  801d8a:	e8 57 ec ff ff       	call   8009e6 <cprintf>
  801d8f:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801d92:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801d95:	89 d0                	mov    %edx,%eax
  801d97:	01 c0                	add    %eax,%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	c1 e0 02             	shl    $0x2,%eax
  801d9e:	05 24 41 80 00       	add    $0x804124,%eax
  801da3:	8b 00                	mov    (%eax),%eax
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	50                   	push   %eax
  801da9:	ff 75 b0             	pushl  -0x50(%ebp)
  801dac:	68 d9 2f 80 00       	push   $0x802fd9
  801db1:	e8 30 ec ff ff       	call   8009e6 <cprintf>
  801db6:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801db9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dbc:	89 d0                	mov    %edx,%eax
  801dbe:	01 c0                	add    %eax,%eax
  801dc0:	01 d0                	add    %edx,%eax
  801dc2:	c1 e0 02             	shl    $0x2,%eax
  801dc5:	05 28 41 80 00       	add    $0x804128,%eax
  801dca:	8b 00                	mov    (%eax),%eax
  801dcc:	83 ec 04             	sub    $0x4,%esp
  801dcf:	50                   	push   %eax
  801dd0:	ff 75 b0             	pushl  -0x50(%ebp)
  801dd3:	68 ec 2f 80 00       	push   $0x802fec
  801dd8:	e8 09 ec ff ff       	call   8009e6 <cprintf>
  801ddd:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801de0:	ff 45 b0             	incl   -0x50(%ebp)
  801de3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801de6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de9:	7c 80                	jl     801d6b <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801deb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801dee:	89 d0                	mov    %edx,%eax
  801df0:	01 c0                	add    %eax,%eax
  801df2:	01 d0                	add    %edx,%eax
  801df4:	c1 e0 02             	shl    $0x2,%eax
  801df7:	05 20 41 80 00       	add    $0x804120,%eax
  801dfc:	8b 00                	mov    (%eax),%eax
  801dfe:	83 ec 08             	sub    $0x8,%esp
  801e01:	50                   	push   %eax
  801e02:	68 00 30 80 00       	push   $0x803000
  801e07:	e8 da eb ff ff       	call   8009e6 <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801e0f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e12:	89 d0                	mov    %edx,%eax
  801e14:	01 c0                	add    %eax,%eax
  801e16:	01 d0                	add    %edx,%eax
  801e18:	c1 e0 02             	shl    $0x2,%eax
  801e1b:	05 20 41 80 00       	add    $0x804120,%eax
  801e20:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801e30:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e37:	eb 4b                	jmp    801e84 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3c:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e43:	89 c2                	mov    %eax,%edx
  801e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e48:	39 c2                	cmp    %eax,%edx
  801e4a:	7f 35                	jg     801e81 <free+0x5d>
  801e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4f:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801e56:	89 c2                	mov    %eax,%edx
  801e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e5b:	39 c2                	cmp    %eax,%edx
  801e5d:	7e 22                	jle    801e81 <free+0x5d>
				start=arr_add[i].start;
  801e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e62:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6f:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801e76:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801e7f:	eb 0d                	jmp    801e8e <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801e81:	ff 45 ec             	incl   -0x14(%ebp)
  801e84:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801e89:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801e8c:	7c ab                	jl     801e39 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e91:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ea2:	29 c2                	sub    %eax,%edx
  801ea4:	89 d0                	mov    %edx,%eax
  801ea6:	83 ec 08             	sub    $0x8,%esp
  801ea9:	50                   	push   %eax
  801eaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ead:	e8 d9 02 00 00       	call   80218b <sys_freeMem>
  801eb2:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ebb:	eb 2d                	jmp    801eea <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801ebd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ec0:	40                   	inc    %eax
  801ec1:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ecb:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ed5:	40                   	inc    %eax
  801ed6:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ee0:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801ee7:	ff 45 e8             	incl   -0x18(%ebp)
  801eea:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801eef:	48                   	dec    %eax
  801ef0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ef3:	7f c8                	jg     801ebd <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801ef5:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801efa:	48                   	dec    %eax
  801efb:	a3 2c 40 80 00       	mov    %eax,0x80402c
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801f00:	90                   	nop
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 18             	sub    $0x18,%esp
  801f09:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0c:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	68 1c 30 80 00       	push   $0x80301c
  801f17:	68 18 01 00 00       	push   $0x118
  801f1c:	68 3f 30 80 00       	push   $0x80303f
  801f21:	e8 1e e8 ff ff       	call   800744 <_panic>

00801f26 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f2c:	83 ec 04             	sub    $0x4,%esp
  801f2f:	68 1c 30 80 00       	push   $0x80301c
  801f34:	68 1e 01 00 00       	push   $0x11e
  801f39:	68 3f 30 80 00       	push   $0x80303f
  801f3e:	e8 01 e8 ff ff       	call   800744 <_panic>

00801f43 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	68 1c 30 80 00       	push   $0x80301c
  801f51:	68 24 01 00 00       	push   $0x124
  801f56:	68 3f 30 80 00       	push   $0x80303f
  801f5b:	e8 e4 e7 ff ff       	call   800744 <_panic>

00801f60 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f66:	83 ec 04             	sub    $0x4,%esp
  801f69:	68 1c 30 80 00       	push   $0x80301c
  801f6e:	68 29 01 00 00       	push   $0x129
  801f73:	68 3f 30 80 00       	push   $0x80303f
  801f78:	e8 c7 e7 ff ff       	call   800744 <_panic>

00801f7d <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f83:	83 ec 04             	sub    $0x4,%esp
  801f86:	68 1c 30 80 00       	push   $0x80301c
  801f8b:	68 2f 01 00 00       	push   $0x12f
  801f90:	68 3f 30 80 00       	push   $0x80303f
  801f95:	e8 aa e7 ff ff       	call   800744 <_panic>

00801f9a <shrink>:
}
void shrink(uint32 newSize)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fa0:	83 ec 04             	sub    $0x4,%esp
  801fa3:	68 1c 30 80 00       	push   $0x80301c
  801fa8:	68 33 01 00 00       	push   $0x133
  801fad:	68 3f 30 80 00       	push   $0x80303f
  801fb2:	e8 8d e7 ff ff       	call   800744 <_panic>

00801fb7 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	68 1c 30 80 00       	push   $0x80301c
  801fc5:	68 38 01 00 00       	push   $0x138
  801fca:	68 3f 30 80 00       	push   $0x80303f
  801fcf:	e8 70 e7 ff ff       	call   800744 <_panic>

00801fd4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	57                   	push   %edi
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fe9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fef:	cd 30                	int    $0x30
  801ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	5b                   	pop    %ebx
  801ffb:	5e                   	pop    %esi
  801ffc:	5f                   	pop    %edi
  801ffd:	5d                   	pop    %ebp
  801ffe:	c3                   	ret    

00801fff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	8b 45 10             	mov    0x10(%ebp),%eax
  802008:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80200b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	52                   	push   %edx
  802017:	ff 75 0c             	pushl  0xc(%ebp)
  80201a:	50                   	push   %eax
  80201b:	6a 00                	push   $0x0
  80201d:	e8 b2 ff ff ff       	call   801fd4 <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
}
  802025:	90                   	nop
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_cgetc>:

int
sys_cgetc(void)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 01                	push   $0x1
  802037:	e8 98 ff ff ff       	call   801fd4 <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	50                   	push   %eax
  802050:	6a 05                	push   $0x5
  802052:	e8 7d ff ff ff       	call   801fd4 <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 02                	push   $0x2
  80206b:	e8 64 ff ff ff       	call   801fd4 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 03                	push   $0x3
  802084:	e8 4b ff ff ff       	call   801fd4 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 04                	push   $0x4
  80209d:	e8 32 ff ff ff       	call   801fd4 <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_env_exit>:


void sys_env_exit(void)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 06                	push   $0x6
  8020b6:	e8 19 ff ff ff       	call   801fd4 <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	52                   	push   %edx
  8020d1:	50                   	push   %eax
  8020d2:	6a 07                	push   $0x7
  8020d4:	e8 fb fe ff ff       	call   801fd4 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	56                   	push   %esi
  8020e2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8020e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	56                   	push   %esi
  8020f3:	53                   	push   %ebx
  8020f4:	51                   	push   %ecx
  8020f5:	52                   	push   %edx
  8020f6:	50                   	push   %eax
  8020f7:	6a 08                	push   $0x8
  8020f9:	e8 d6 fe ff ff       	call   801fd4 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802104:	5b                   	pop    %ebx
  802105:	5e                   	pop    %esi
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    

00802108 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80210b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	52                   	push   %edx
  802118:	50                   	push   %eax
  802119:	6a 09                	push   $0x9
  80211b:	e8 b4 fe ff ff       	call   801fd4 <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	ff 75 0c             	pushl  0xc(%ebp)
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	6a 0a                	push   $0xa
  802136:	e8 99 fe ff ff       	call   801fd4 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 0b                	push   $0xb
  80214f:	e8 80 fe ff ff       	call   801fd4 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 0c                	push   $0xc
  802168:	e8 67 fe ff ff       	call   801fd4 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 0d                	push   $0xd
  802181:	e8 4e fe ff ff       	call   801fd4 <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	ff 75 0c             	pushl  0xc(%ebp)
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 11                	push   $0x11
  80219c:	e8 33 fe ff ff       	call   801fd4 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
	return;
  8021a4:	90                   	nop
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	ff 75 0c             	pushl  0xc(%ebp)
  8021b3:	ff 75 08             	pushl  0x8(%ebp)
  8021b6:	6a 12                	push   $0x12
  8021b8:	e8 17 fe ff ff       	call   801fd4 <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c0:	90                   	nop
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 0e                	push   $0xe
  8021d2:	e8 fd fd ff ff       	call   801fd4 <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	ff 75 08             	pushl  0x8(%ebp)
  8021ea:	6a 0f                	push   $0xf
  8021ec:	e8 e3 fd ff ff       	call   801fd4 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 10                	push   $0x10
  802205:	e8 ca fd ff ff       	call   801fd4 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	90                   	nop
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 14                	push   $0x14
  80221f:	e8 b0 fd ff ff       	call   801fd4 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	90                   	nop
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 15                	push   $0x15
  802239:	e8 96 fd ff ff       	call   801fd4 <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	90                   	nop
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_cputc>:


void
sys_cputc(const char c)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802250:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	50                   	push   %eax
  80225d:	6a 16                	push   $0x16
  80225f:	e8 70 fd ff ff       	call   801fd4 <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	90                   	nop
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 17                	push   $0x17
  802279:	e8 56 fd ff ff       	call   801fd4 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	90                   	nop
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	ff 75 0c             	pushl  0xc(%ebp)
  802293:	50                   	push   %eax
  802294:	6a 18                	push   $0x18
  802296:	e8 39 fd ff ff       	call   801fd4 <syscall>
  80229b:	83 c4 18             	add    $0x18,%esp
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	52                   	push   %edx
  8022b0:	50                   	push   %eax
  8022b1:	6a 1b                	push   $0x1b
  8022b3:	e8 1c fd ff ff       	call   801fd4 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	52                   	push   %edx
  8022cd:	50                   	push   %eax
  8022ce:	6a 19                	push   $0x19
  8022d0:	e8 ff fc ff ff       	call   801fd4 <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
}
  8022d8:	90                   	nop
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	52                   	push   %edx
  8022eb:	50                   	push   %eax
  8022ec:	6a 1a                	push   $0x1a
  8022ee:	e8 e1 fc ff ff       	call   801fd4 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	90                   	nop
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 04             	sub    $0x4,%esp
  8022ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802302:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802305:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802308:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	6a 00                	push   $0x0
  802311:	51                   	push   %ecx
  802312:	52                   	push   %edx
  802313:	ff 75 0c             	pushl  0xc(%ebp)
  802316:	50                   	push   %eax
  802317:	6a 1c                	push   $0x1c
  802319:	e8 b6 fc ff ff       	call   801fd4 <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	52                   	push   %edx
  802333:	50                   	push   %eax
  802334:	6a 1d                	push   $0x1d
  802336:	e8 99 fc ff ff       	call   801fd4 <syscall>
  80233b:	83 c4 18             	add    $0x18,%esp
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802343:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802346:	8b 55 0c             	mov    0xc(%ebp),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	51                   	push   %ecx
  802351:	52                   	push   %edx
  802352:	50                   	push   %eax
  802353:	6a 1e                	push   $0x1e
  802355:	e8 7a fc ff ff       	call   801fd4 <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802362:	8b 55 0c             	mov    0xc(%ebp),%edx
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	52                   	push   %edx
  80236f:	50                   	push   %eax
  802370:	6a 1f                	push   $0x1f
  802372:	e8 5d fc ff ff       	call   801fd4 <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 20                	push   $0x20
  80238b:	e8 44 fc ff ff       	call   801fd4 <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	ff 75 14             	pushl  0x14(%ebp)
  8023a0:	ff 75 10             	pushl  0x10(%ebp)
  8023a3:	ff 75 0c             	pushl  0xc(%ebp)
  8023a6:	50                   	push   %eax
  8023a7:	6a 21                	push   $0x21
  8023a9:	e8 26 fc ff ff       	call   801fd4 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	50                   	push   %eax
  8023c2:	6a 22                	push   $0x22
  8023c4:	e8 0b fc ff ff       	call   801fd4 <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
}
  8023cc:	90                   	nop
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	50                   	push   %eax
  8023de:	6a 23                	push   $0x23
  8023e0:	e8 ef fb ff ff       	call   801fd4 <syscall>
  8023e5:	83 c4 18             	add    $0x18,%esp
}
  8023e8:	90                   	nop
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023f4:	8d 50 04             	lea    0x4(%eax),%edx
  8023f7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	52                   	push   %edx
  802401:	50                   	push   %eax
  802402:	6a 24                	push   $0x24
  802404:	e8 cb fb ff ff       	call   801fd4 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
	return result;
  80240c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80240f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802412:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802415:	89 01                	mov    %eax,(%ecx)
  802417:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	c9                   	leave  
  80241e:	c2 04 00             	ret    $0x4

00802421 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	ff 75 10             	pushl  0x10(%ebp)
  80242b:	ff 75 0c             	pushl  0xc(%ebp)
  80242e:	ff 75 08             	pushl  0x8(%ebp)
  802431:	6a 13                	push   $0x13
  802433:	e8 9c fb ff ff       	call   801fd4 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
	return ;
  80243b:	90                   	nop
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <sys_rcr2>:
uint32 sys_rcr2()
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 25                	push   $0x25
  80244d:	e8 82 fb ff ff       	call   801fd4 <syscall>
  802452:	83 c4 18             	add    $0x18,%esp
}
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802463:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	50                   	push   %eax
  802470:	6a 26                	push   $0x26
  802472:	e8 5d fb ff ff       	call   801fd4 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
	return ;
  80247a:	90                   	nop
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <rsttst>:
void rsttst()
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 28                	push   $0x28
  80248c:	e8 43 fb ff ff       	call   801fd4 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
	return ;
  802494:	90                   	nop
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024a3:	8b 55 18             	mov    0x18(%ebp),%edx
  8024a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024aa:	52                   	push   %edx
  8024ab:	50                   	push   %eax
  8024ac:	ff 75 10             	pushl  0x10(%ebp)
  8024af:	ff 75 0c             	pushl  0xc(%ebp)
  8024b2:	ff 75 08             	pushl  0x8(%ebp)
  8024b5:	6a 27                	push   $0x27
  8024b7:	e8 18 fb ff ff       	call   801fd4 <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8024bf:	90                   	nop
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <chktst>:
void chktst(uint32 n)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	ff 75 08             	pushl  0x8(%ebp)
  8024d0:	6a 29                	push   $0x29
  8024d2:	e8 fd fa ff ff       	call   801fd4 <syscall>
  8024d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024da:	90                   	nop
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <inctst>:

void inctst()
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 2a                	push   $0x2a
  8024ec:	e8 e3 fa ff ff       	call   801fd4 <syscall>
  8024f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f4:	90                   	nop
}
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <gettst>:
uint32 gettst()
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 2b                	push   $0x2b
  802506:	e8 c9 fa ff ff       	call   801fd4 <syscall>
  80250b:	83 c4 18             	add    $0x18,%esp
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 2c                	push   $0x2c
  802522:	e8 ad fa ff ff       	call   801fd4 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
  80252a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80252d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802531:	75 07                	jne    80253a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802533:	b8 01 00 00 00       	mov    $0x1,%eax
  802538:	eb 05                	jmp    80253f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 2c                	push   $0x2c
  802553:	e8 7c fa ff ff       	call   801fd4 <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
  80255b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80255e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802562:	75 07                	jne    80256b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802564:	b8 01 00 00 00       	mov    $0x1,%eax
  802569:	eb 05                	jmp    802570 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 2c                	push   $0x2c
  802584:	e8 4b fa ff ff       	call   801fd4 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
  80258c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80258f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802593:	75 07                	jne    80259c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802595:	b8 01 00 00 00       	mov    $0x1,%eax
  80259a:	eb 05                	jmp    8025a1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 2c                	push   $0x2c
  8025b5:	e8 1a fa ff ff       	call   801fd4 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
  8025bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025c0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025c4:	75 07                	jne    8025cd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cb:	eb 05                	jmp    8025d2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	ff 75 08             	pushl  0x8(%ebp)
  8025e2:	6a 2d                	push   $0x2d
  8025e4:	e8 eb f9 ff ff       	call   801fd4 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ec:	90                   	nop
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	6a 00                	push   $0x0
  802601:	53                   	push   %ebx
  802602:	51                   	push   %ecx
  802603:	52                   	push   %edx
  802604:	50                   	push   %eax
  802605:	6a 2e                	push   $0x2e
  802607:	e8 c8 f9 ff ff       	call   801fd4 <syscall>
  80260c:	83 c4 18             	add    $0x18,%esp
}
  80260f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	52                   	push   %edx
  802624:	50                   	push   %eax
  802625:	6a 2f                	push   $0x2f
  802627:	e8 a8 f9 ff ff       	call   801fd4 <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    
  802631:	66 90                	xchg   %ax,%ax
  802633:	90                   	nop

00802634 <__udivdi3>:
  802634:	55                   	push   %ebp
  802635:	57                   	push   %edi
  802636:	56                   	push   %esi
  802637:	53                   	push   %ebx
  802638:	83 ec 1c             	sub    $0x1c,%esp
  80263b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80263f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802647:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80264b:	89 ca                	mov    %ecx,%edx
  80264d:	89 f8                	mov    %edi,%eax
  80264f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802653:	85 f6                	test   %esi,%esi
  802655:	75 2d                	jne    802684 <__udivdi3+0x50>
  802657:	39 cf                	cmp    %ecx,%edi
  802659:	77 65                	ja     8026c0 <__udivdi3+0x8c>
  80265b:	89 fd                	mov    %edi,%ebp
  80265d:	85 ff                	test   %edi,%edi
  80265f:	75 0b                	jne    80266c <__udivdi3+0x38>
  802661:	b8 01 00 00 00       	mov    $0x1,%eax
  802666:	31 d2                	xor    %edx,%edx
  802668:	f7 f7                	div    %edi
  80266a:	89 c5                	mov    %eax,%ebp
  80266c:	31 d2                	xor    %edx,%edx
  80266e:	89 c8                	mov    %ecx,%eax
  802670:	f7 f5                	div    %ebp
  802672:	89 c1                	mov    %eax,%ecx
  802674:	89 d8                	mov    %ebx,%eax
  802676:	f7 f5                	div    %ebp
  802678:	89 cf                	mov    %ecx,%edi
  80267a:	89 fa                	mov    %edi,%edx
  80267c:	83 c4 1c             	add    $0x1c,%esp
  80267f:	5b                   	pop    %ebx
  802680:	5e                   	pop    %esi
  802681:	5f                   	pop    %edi
  802682:	5d                   	pop    %ebp
  802683:	c3                   	ret    
  802684:	39 ce                	cmp    %ecx,%esi
  802686:	77 28                	ja     8026b0 <__udivdi3+0x7c>
  802688:	0f bd fe             	bsr    %esi,%edi
  80268b:	83 f7 1f             	xor    $0x1f,%edi
  80268e:	75 40                	jne    8026d0 <__udivdi3+0x9c>
  802690:	39 ce                	cmp    %ecx,%esi
  802692:	72 0a                	jb     80269e <__udivdi3+0x6a>
  802694:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802698:	0f 87 9e 00 00 00    	ja     80273c <__udivdi3+0x108>
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a3:	89 fa                	mov    %edi,%edx
  8026a5:	83 c4 1c             	add    $0x1c,%esp
  8026a8:	5b                   	pop    %ebx
  8026a9:	5e                   	pop    %esi
  8026aa:	5f                   	pop    %edi
  8026ab:	5d                   	pop    %ebp
  8026ac:	c3                   	ret    
  8026ad:	8d 76 00             	lea    0x0(%esi),%esi
  8026b0:	31 ff                	xor    %edi,%edi
  8026b2:	31 c0                	xor    %eax,%eax
  8026b4:	89 fa                	mov    %edi,%edx
  8026b6:	83 c4 1c             	add    $0x1c,%esp
  8026b9:	5b                   	pop    %ebx
  8026ba:	5e                   	pop    %esi
  8026bb:	5f                   	pop    %edi
  8026bc:	5d                   	pop    %ebp
  8026bd:	c3                   	ret    
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	89 d8                	mov    %ebx,%eax
  8026c2:	f7 f7                	div    %edi
  8026c4:	31 ff                	xor    %edi,%edi
  8026c6:	89 fa                	mov    %edi,%edx
  8026c8:	83 c4 1c             	add    $0x1c,%esp
  8026cb:	5b                   	pop    %ebx
  8026cc:	5e                   	pop    %esi
  8026cd:	5f                   	pop    %edi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    
  8026d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8026d5:	89 eb                	mov    %ebp,%ebx
  8026d7:	29 fb                	sub    %edi,%ebx
  8026d9:	89 f9                	mov    %edi,%ecx
  8026db:	d3 e6                	shl    %cl,%esi
  8026dd:	89 c5                	mov    %eax,%ebp
  8026df:	88 d9                	mov    %bl,%cl
  8026e1:	d3 ed                	shr    %cl,%ebp
  8026e3:	89 e9                	mov    %ebp,%ecx
  8026e5:	09 f1                	or     %esi,%ecx
  8026e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8026eb:	89 f9                	mov    %edi,%ecx
  8026ed:	d3 e0                	shl    %cl,%eax
  8026ef:	89 c5                	mov    %eax,%ebp
  8026f1:	89 d6                	mov    %edx,%esi
  8026f3:	88 d9                	mov    %bl,%cl
  8026f5:	d3 ee                	shr    %cl,%esi
  8026f7:	89 f9                	mov    %edi,%ecx
  8026f9:	d3 e2                	shl    %cl,%edx
  8026fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026ff:	88 d9                	mov    %bl,%cl
  802701:	d3 e8                	shr    %cl,%eax
  802703:	09 c2                	or     %eax,%edx
  802705:	89 d0                	mov    %edx,%eax
  802707:	89 f2                	mov    %esi,%edx
  802709:	f7 74 24 0c          	divl   0xc(%esp)
  80270d:	89 d6                	mov    %edx,%esi
  80270f:	89 c3                	mov    %eax,%ebx
  802711:	f7 e5                	mul    %ebp
  802713:	39 d6                	cmp    %edx,%esi
  802715:	72 19                	jb     802730 <__udivdi3+0xfc>
  802717:	74 0b                	je     802724 <__udivdi3+0xf0>
  802719:	89 d8                	mov    %ebx,%eax
  80271b:	31 ff                	xor    %edi,%edi
  80271d:	e9 58 ff ff ff       	jmp    80267a <__udivdi3+0x46>
  802722:	66 90                	xchg   %ax,%ax
  802724:	8b 54 24 08          	mov    0x8(%esp),%edx
  802728:	89 f9                	mov    %edi,%ecx
  80272a:	d3 e2                	shl    %cl,%edx
  80272c:	39 c2                	cmp    %eax,%edx
  80272e:	73 e9                	jae    802719 <__udivdi3+0xe5>
  802730:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802733:	31 ff                	xor    %edi,%edi
  802735:	e9 40 ff ff ff       	jmp    80267a <__udivdi3+0x46>
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	31 c0                	xor    %eax,%eax
  80273e:	e9 37 ff ff ff       	jmp    80267a <__udivdi3+0x46>
  802743:	90                   	nop

00802744 <__umoddi3>:
  802744:	55                   	push   %ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	83 ec 1c             	sub    $0x1c,%esp
  80274b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80274f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802757:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80275b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80275f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802763:	89 f3                	mov    %esi,%ebx
  802765:	89 fa                	mov    %edi,%edx
  802767:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80276b:	89 34 24             	mov    %esi,(%esp)
  80276e:	85 c0                	test   %eax,%eax
  802770:	75 1a                	jne    80278c <__umoddi3+0x48>
  802772:	39 f7                	cmp    %esi,%edi
  802774:	0f 86 a2 00 00 00    	jbe    80281c <__umoddi3+0xd8>
  80277a:	89 c8                	mov    %ecx,%eax
  80277c:	89 f2                	mov    %esi,%edx
  80277e:	f7 f7                	div    %edi
  802780:	89 d0                	mov    %edx,%eax
  802782:	31 d2                	xor    %edx,%edx
  802784:	83 c4 1c             	add    $0x1c,%esp
  802787:	5b                   	pop    %ebx
  802788:	5e                   	pop    %esi
  802789:	5f                   	pop    %edi
  80278a:	5d                   	pop    %ebp
  80278b:	c3                   	ret    
  80278c:	39 f0                	cmp    %esi,%eax
  80278e:	0f 87 ac 00 00 00    	ja     802840 <__umoddi3+0xfc>
  802794:	0f bd e8             	bsr    %eax,%ebp
  802797:	83 f5 1f             	xor    $0x1f,%ebp
  80279a:	0f 84 ac 00 00 00    	je     80284c <__umoddi3+0x108>
  8027a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8027a5:	29 ef                	sub    %ebp,%edi
  8027a7:	89 fe                	mov    %edi,%esi
  8027a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ad:	89 e9                	mov    %ebp,%ecx
  8027af:	d3 e0                	shl    %cl,%eax
  8027b1:	89 d7                	mov    %edx,%edi
  8027b3:	89 f1                	mov    %esi,%ecx
  8027b5:	d3 ef                	shr    %cl,%edi
  8027b7:	09 c7                	or     %eax,%edi
  8027b9:	89 e9                	mov    %ebp,%ecx
  8027bb:	d3 e2                	shl    %cl,%edx
  8027bd:	89 14 24             	mov    %edx,(%esp)
  8027c0:	89 d8                	mov    %ebx,%eax
  8027c2:	d3 e0                	shl    %cl,%eax
  8027c4:	89 c2                	mov    %eax,%edx
  8027c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027ca:	d3 e0                	shl    %cl,%eax
  8027cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027d4:	89 f1                	mov    %esi,%ecx
  8027d6:	d3 e8                	shr    %cl,%eax
  8027d8:	09 d0                	or     %edx,%eax
  8027da:	d3 eb                	shr    %cl,%ebx
  8027dc:	89 da                	mov    %ebx,%edx
  8027de:	f7 f7                	div    %edi
  8027e0:	89 d3                	mov    %edx,%ebx
  8027e2:	f7 24 24             	mull   (%esp)
  8027e5:	89 c6                	mov    %eax,%esi
  8027e7:	89 d1                	mov    %edx,%ecx
  8027e9:	39 d3                	cmp    %edx,%ebx
  8027eb:	0f 82 87 00 00 00    	jb     802878 <__umoddi3+0x134>
  8027f1:	0f 84 91 00 00 00    	je     802888 <__umoddi3+0x144>
  8027f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027fb:	29 f2                	sub    %esi,%edx
  8027fd:	19 cb                	sbb    %ecx,%ebx
  8027ff:	89 d8                	mov    %ebx,%eax
  802801:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802805:	d3 e0                	shl    %cl,%eax
  802807:	89 e9                	mov    %ebp,%ecx
  802809:	d3 ea                	shr    %cl,%edx
  80280b:	09 d0                	or     %edx,%eax
  80280d:	89 e9                	mov    %ebp,%ecx
  80280f:	d3 eb                	shr    %cl,%ebx
  802811:	89 da                	mov    %ebx,%edx
  802813:	83 c4 1c             	add    $0x1c,%esp
  802816:	5b                   	pop    %ebx
  802817:	5e                   	pop    %esi
  802818:	5f                   	pop    %edi
  802819:	5d                   	pop    %ebp
  80281a:	c3                   	ret    
  80281b:	90                   	nop
  80281c:	89 fd                	mov    %edi,%ebp
  80281e:	85 ff                	test   %edi,%edi
  802820:	75 0b                	jne    80282d <__umoddi3+0xe9>
  802822:	b8 01 00 00 00       	mov    $0x1,%eax
  802827:	31 d2                	xor    %edx,%edx
  802829:	f7 f7                	div    %edi
  80282b:	89 c5                	mov    %eax,%ebp
  80282d:	89 f0                	mov    %esi,%eax
  80282f:	31 d2                	xor    %edx,%edx
  802831:	f7 f5                	div    %ebp
  802833:	89 c8                	mov    %ecx,%eax
  802835:	f7 f5                	div    %ebp
  802837:	89 d0                	mov    %edx,%eax
  802839:	e9 44 ff ff ff       	jmp    802782 <__umoddi3+0x3e>
  80283e:	66 90                	xchg   %ax,%ax
  802840:	89 c8                	mov    %ecx,%eax
  802842:	89 f2                	mov    %esi,%edx
  802844:	83 c4 1c             	add    $0x1c,%esp
  802847:	5b                   	pop    %ebx
  802848:	5e                   	pop    %esi
  802849:	5f                   	pop    %edi
  80284a:	5d                   	pop    %ebp
  80284b:	c3                   	ret    
  80284c:	3b 04 24             	cmp    (%esp),%eax
  80284f:	72 06                	jb     802857 <__umoddi3+0x113>
  802851:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802855:	77 0f                	ja     802866 <__umoddi3+0x122>
  802857:	89 f2                	mov    %esi,%edx
  802859:	29 f9                	sub    %edi,%ecx
  80285b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80285f:	89 14 24             	mov    %edx,(%esp)
  802862:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802866:	8b 44 24 04          	mov    0x4(%esp),%eax
  80286a:	8b 14 24             	mov    (%esp),%edx
  80286d:	83 c4 1c             	add    $0x1c,%esp
  802870:	5b                   	pop    %ebx
  802871:	5e                   	pop    %esi
  802872:	5f                   	pop    %edi
  802873:	5d                   	pop    %ebp
  802874:	c3                   	ret    
  802875:	8d 76 00             	lea    0x0(%esi),%esi
  802878:	2b 04 24             	sub    (%esp),%eax
  80287b:	19 fa                	sbb    %edi,%edx
  80287d:	89 d1                	mov    %edx,%ecx
  80287f:	89 c6                	mov    %eax,%esi
  802881:	e9 71 ff ff ff       	jmp    8027f7 <__umoddi3+0xb3>
  802886:	66 90                	xchg   %ax,%ax
  802888:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80288c:	72 ea                	jb     802878 <__umoddi3+0x134>
  80288e:	89 d9                	mov    %ebx,%ecx
  802890:	e9 62 ff ff ff       	jmp    8027f7 <__umoddi3+0xb3>
