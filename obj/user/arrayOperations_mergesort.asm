
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 eb 1a 00 00       	call   801b2e <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 20 25 80 00       	push   $0x802520
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 62 19 00 00       	call   8019c6 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 24 25 80 00       	push   $0x802524
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 4c 19 00 00       	call   8019c6 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 2c 25 80 00       	push   $0x80252c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 2f 19 00 00       	call   8019c6 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 3a 25 80 00       	push   $0x80253a
  8000b0:	e8 ee 18 00 00       	call   8019a3 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 49 25 80 00       	push   $0x802549
  800111:	e8 76 05 00 00       	call   80068c <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 65 25 80 00       	push   $0x802565
  8001a7:	e8 e0 04 00 00       	call   80068c <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 67 25 80 00       	push   $0x802567
  8001c9:	e8 be 04 00 00       	call   80068c <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 6c 25 80 00       	push   $0x80256c
  8001f7:	e8 90 04 00 00       	call   80068c <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 79 11 00 00       	call   801416 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 64 11 00 00       	call   801416 <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 65 14 00 00       	call   8018c4 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 57 14 00 00       	call   8018c4 <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 97 16 00 00       	call   801b15 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800492:	01 c8                	add    %ecx,%eax
  800494:	01 c0                	add    %eax,%eax
  800496:	01 d0                	add    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	c1 e2 05             	shl    $0x5,%edx
  8004a1:	29 c2                	sub    %eax,%edx
  8004a3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8004aa:	89 c2                	mov    %eax,%edx
  8004ac:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8004b2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004bc:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8004c2:	84 c0                	test   %al,%al
  8004c4:	74 0f                	je     8004d5 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8004c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004cb:	05 40 3c 01 00       	add    $0x13c40,%eax
  8004d0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004d9:	7e 0a                	jle    8004e5 <libmain+0x72>
		binaryname = argv[0];
  8004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 45 fb ff ff       	call   800038 <_main>
  8004f3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004f6:	e8 b5 17 00 00       	call   801cb0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	68 88 25 80 00       	push   $0x802588
  800503:	e8 84 01 00 00       	call   80068c <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80050b:	a1 20 30 80 00       	mov    0x803020,%eax
  800510:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800516:	a1 20 30 80 00       	mov    0x803020,%eax
  80051b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800521:	83 ec 04             	sub    $0x4,%esp
  800524:	52                   	push   %edx
  800525:	50                   	push   %eax
  800526:	68 b0 25 80 00       	push   $0x8025b0
  80052b:	e8 5c 01 00 00       	call   80068c <cprintf>
  800530:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800533:	a1 20 30 80 00       	mov    0x803020,%eax
  800538:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80053e:	a1 20 30 80 00       	mov    0x803020,%eax
  800543:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	52                   	push   %edx
  80054d:	50                   	push   %eax
  80054e:	68 d8 25 80 00       	push   $0x8025d8
  800553:	e8 34 01 00 00       	call   80068c <cprintf>
  800558:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80055b:	a1 20 30 80 00       	mov    0x803020,%eax
  800560:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	50                   	push   %eax
  80056a:	68 19 26 80 00       	push   $0x802619
  80056f:	e8 18 01 00 00       	call   80068c <cprintf>
  800574:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800577:	83 ec 0c             	sub    $0xc,%esp
  80057a:	68 88 25 80 00       	push   $0x802588
  80057f:	e8 08 01 00 00       	call   80068c <cprintf>
  800584:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800587:	e8 3e 17 00 00       	call   801cca <sys_enable_interrupt>

	// exit gracefully
	exit();
  80058c:	e8 19 00 00 00       	call   8005aa <exit>
}
  800591:	90                   	nop
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80059a:	83 ec 0c             	sub    $0xc,%esp
  80059d:	6a 00                	push   $0x0
  80059f:	e8 3d 15 00 00       	call   801ae1 <sys_env_destroy>
  8005a4:	83 c4 10             	add    $0x10,%esp
}
  8005a7:	90                   	nop
  8005a8:	c9                   	leave  
  8005a9:	c3                   	ret    

008005aa <exit>:

void
exit(void)
{
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8005b0:	e8 92 15 00 00       	call   801b47 <sys_env_exit>
}
  8005b5:	90                   	nop
  8005b6:	c9                   	leave  
  8005b7:	c3                   	ret    

008005b8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005b8:	55                   	push   %ebp
  8005b9:	89 e5                	mov    %esp,%ebp
  8005bb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8005c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c9:	89 0a                	mov    %ecx,(%edx)
  8005cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ce:	88 d1                	mov    %dl,%cl
  8005d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005e1:	75 2c                	jne    80060f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005e3:	a0 24 30 80 00       	mov    0x803024,%al
  8005e8:	0f b6 c0             	movzbl %al,%eax
  8005eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ee:	8b 12                	mov    (%edx),%edx
  8005f0:	89 d1                	mov    %edx,%ecx
  8005f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f5:	83 c2 08             	add    $0x8,%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	e8 9c 14 00 00       	call   801a9f <sys_cputs>
  800603:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	8b 40 04             	mov    0x4(%eax),%eax
  800615:	8d 50 01             	lea    0x1(%eax),%edx
  800618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80061e:	90                   	nop
  80061f:	c9                   	leave  
  800620:	c3                   	ret    

00800621 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80062a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800631:	00 00 00 
	b.cnt = 0;
  800634:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80063b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80063e:	ff 75 0c             	pushl  0xc(%ebp)
  800641:	ff 75 08             	pushl  0x8(%ebp)
  800644:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80064a:	50                   	push   %eax
  80064b:	68 b8 05 80 00       	push   $0x8005b8
  800650:	e8 11 02 00 00       	call   800866 <vprintfmt>
  800655:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800658:	a0 24 30 80 00       	mov    0x803024,%al
  80065d:	0f b6 c0             	movzbl %al,%eax
  800660:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800666:	83 ec 04             	sub    $0x4,%esp
  800669:	50                   	push   %eax
  80066a:	52                   	push   %edx
  80066b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800671:	83 c0 08             	add    $0x8,%eax
  800674:	50                   	push   %eax
  800675:	e8 25 14 00 00       	call   801a9f <sys_cputs>
  80067a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80067d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800684:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80068a:	c9                   	leave  
  80068b:	c3                   	ret    

0080068c <cprintf>:

int cprintf(const char *fmt, ...) {
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800692:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800699:	8d 45 0c             	lea    0xc(%ebp),%eax
  80069c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a8:	50                   	push   %eax
  8006a9:	e8 73 ff ff ff       	call   800621 <vcprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b7:	c9                   	leave  
  8006b8:	c3                   	ret    

008006b9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
  8006bc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006bf:	e8 ec 15 00 00       	call   801cb0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d3:	50                   	push   %eax
  8006d4:	e8 48 ff ff ff       	call   800621 <vcprintf>
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006df:	e8 e6 15 00 00       	call   801cca <sys_enable_interrupt>
	return cnt;
  8006e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	53                   	push   %ebx
  8006ed:	83 ec 14             	sub    $0x14,%esp
  8006f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800707:	77 55                	ja     80075e <printnum+0x75>
  800709:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80070c:	72 05                	jb     800713 <printnum+0x2a>
  80070e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800711:	77 4b                	ja     80075e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800713:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800716:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800719:	8b 45 18             	mov    0x18(%ebp),%eax
  80071c:	ba 00 00 00 00       	mov    $0x0,%edx
  800721:	52                   	push   %edx
  800722:	50                   	push   %eax
  800723:	ff 75 f4             	pushl  -0xc(%ebp)
  800726:	ff 75 f0             	pushl  -0x10(%ebp)
  800729:	e8 72 1b 00 00       	call   8022a0 <__udivdi3>
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	83 ec 04             	sub    $0x4,%esp
  800734:	ff 75 20             	pushl  0x20(%ebp)
  800737:	53                   	push   %ebx
  800738:	ff 75 18             	pushl  0x18(%ebp)
  80073b:	52                   	push   %edx
  80073c:	50                   	push   %eax
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	ff 75 08             	pushl  0x8(%ebp)
  800743:	e8 a1 ff ff ff       	call   8006e9 <printnum>
  800748:	83 c4 20             	add    $0x20,%esp
  80074b:	eb 1a                	jmp    800767 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	ff 75 20             	pushl  0x20(%ebp)
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80075e:	ff 4d 1c             	decl   0x1c(%ebp)
  800761:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800765:	7f e6                	jg     80074d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800767:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80076a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800775:	53                   	push   %ebx
  800776:	51                   	push   %ecx
  800777:	52                   	push   %edx
  800778:	50                   	push   %eax
  800779:	e8 32 1c 00 00       	call   8023b0 <__umoddi3>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	05 54 28 80 00       	add    $0x802854,%eax
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f be c0             	movsbl %al,%eax
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	50                   	push   %eax
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	ff d0                	call   *%eax
  800797:	83 c4 10             	add    $0x10,%esp
}
  80079a:	90                   	nop
  80079b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a7:	7e 1c                	jle    8007c5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 08             	lea    0x8(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 08             	sub    $0x8,%eax
  8007be:	8b 50 04             	mov    0x4(%eax),%edx
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	eb 40                	jmp    800805 <getuint+0x65>
	else if (lflag)
  8007c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c9:	74 1e                	je     8007e9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	8d 50 04             	lea    0x4(%eax),%edx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	89 10                	mov    %edx,(%eax)
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	83 e8 04             	sub    $0x4,%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	eb 1c                	jmp    800805 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	8d 50 04             	lea    0x4(%eax),%edx
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	89 10                	mov    %edx,(%eax)
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	83 e8 04             	sub    $0x4,%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800805:	5d                   	pop    %ebp
  800806:	c3                   	ret    

00800807 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80080a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80080e:	7e 1c                	jle    80082c <getint+0x25>
		return va_arg(*ap, long long);
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	8d 50 08             	lea    0x8(%eax),%edx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	89 10                	mov    %edx,(%eax)
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	83 e8 08             	sub    $0x8,%eax
  800825:	8b 50 04             	mov    0x4(%eax),%edx
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	eb 38                	jmp    800864 <getint+0x5d>
	else if (lflag)
  80082c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800830:	74 1a                	je     80084c <getint+0x45>
		return va_arg(*ap, long);
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	8d 50 04             	lea    0x4(%eax),%edx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	89 10                	mov    %edx,(%eax)
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	99                   	cltd   
  80084a:	eb 18                	jmp    800864 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	8d 50 04             	lea    0x4(%eax),%edx
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	89 10                	mov    %edx,(%eax)
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	99                   	cltd   
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	56                   	push   %esi
  80086a:	53                   	push   %ebx
  80086b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086e:	eb 17                	jmp    800887 <vprintfmt+0x21>
			if (ch == '\0')
  800870:	85 db                	test   %ebx,%ebx
  800872:	0f 84 af 03 00 00    	je     800c27 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	ff 75 0c             	pushl  0xc(%ebp)
  80087e:	53                   	push   %ebx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	8d 50 01             	lea    0x1(%eax),%edx
  80088d:	89 55 10             	mov    %edx,0x10(%ebp)
  800890:	8a 00                	mov    (%eax),%al
  800892:	0f b6 d8             	movzbl %al,%ebx
  800895:	83 fb 25             	cmp    $0x25,%ebx
  800898:	75 d6                	jne    800870 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80089a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80089e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bd:	8d 50 01             	lea    0x1(%eax),%edx
  8008c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c3:	8a 00                	mov    (%eax),%al
  8008c5:	0f b6 d8             	movzbl %al,%ebx
  8008c8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008cb:	83 f8 55             	cmp    $0x55,%eax
  8008ce:	0f 87 2b 03 00 00    	ja     800bff <vprintfmt+0x399>
  8008d4:	8b 04 85 78 28 80 00 	mov    0x802878(,%eax,4),%eax
  8008db:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008dd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008e1:	eb d7                	jmp    8008ba <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008e3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008e7:	eb d1                	jmp    8008ba <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	c1 e0 02             	shl    $0x2,%eax
  8008f8:	01 d0                	add    %edx,%eax
  8008fa:	01 c0                	add    %eax,%eax
  8008fc:	01 d8                	add    %ebx,%eax
  8008fe:	83 e8 30             	sub    $0x30,%eax
  800901:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800904:	8b 45 10             	mov    0x10(%ebp),%eax
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80090c:	83 fb 2f             	cmp    $0x2f,%ebx
  80090f:	7e 3e                	jle    80094f <vprintfmt+0xe9>
  800911:	83 fb 39             	cmp    $0x39,%ebx
  800914:	7f 39                	jg     80094f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800916:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800919:	eb d5                	jmp    8008f0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 c0 04             	add    $0x4,%eax
  800921:	89 45 14             	mov    %eax,0x14(%ebp)
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80092f:	eb 1f                	jmp    800950 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800931:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800935:	79 83                	jns    8008ba <vprintfmt+0x54>
				width = 0;
  800937:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80093e:	e9 77 ff ff ff       	jmp    8008ba <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800943:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80094a:	e9 6b ff ff ff       	jmp    8008ba <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80094f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	0f 89 60 ff ff ff    	jns    8008ba <vprintfmt+0x54>
				width = precision, precision = -1;
  80095a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80095d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800960:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800967:	e9 4e ff ff ff       	jmp    8008ba <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80096c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80096f:	e9 46 ff ff ff       	jmp    8008ba <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 c0 04             	add    $0x4,%eax
  80097a:	89 45 14             	mov    %eax,0x14(%ebp)
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	83 e8 04             	sub    $0x4,%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	50                   	push   %eax
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	ff d0                	call   *%eax
  800991:	83 c4 10             	add    $0x10,%esp
			break;
  800994:	e9 89 02 00 00       	jmp    800c22 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 c0 04             	add    $0x4,%eax
  80099f:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	83 e8 04             	sub    $0x4,%eax
  8009a8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009aa:	85 db                	test   %ebx,%ebx
  8009ac:	79 02                	jns    8009b0 <vprintfmt+0x14a>
				err = -err;
  8009ae:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009b0:	83 fb 64             	cmp    $0x64,%ebx
  8009b3:	7f 0b                	jg     8009c0 <vprintfmt+0x15a>
  8009b5:	8b 34 9d c0 26 80 00 	mov    0x8026c0(,%ebx,4),%esi
  8009bc:	85 f6                	test   %esi,%esi
  8009be:	75 19                	jne    8009d9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009c0:	53                   	push   %ebx
  8009c1:	68 65 28 80 00       	push   $0x802865
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	ff 75 08             	pushl  0x8(%ebp)
  8009cc:	e8 5e 02 00 00       	call   800c2f <printfmt>
  8009d1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009d4:	e9 49 02 00 00       	jmp    800c22 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d9:	56                   	push   %esi
  8009da:	68 6e 28 80 00       	push   $0x80286e
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 45 02 00 00       	call   800c2f <printfmt>
  8009ea:	83 c4 10             	add    $0x10,%esp
			break;
  8009ed:	e9 30 02 00 00       	jmp    800c22 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 c0 04             	add    $0x4,%eax
  8009f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	83 e8 04             	sub    $0x4,%eax
  800a01:	8b 30                	mov    (%eax),%esi
  800a03:	85 f6                	test   %esi,%esi
  800a05:	75 05                	jne    800a0c <vprintfmt+0x1a6>
				p = "(null)";
  800a07:	be 71 28 80 00       	mov    $0x802871,%esi
			if (width > 0 && padc != '-')
  800a0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a10:	7e 6d                	jle    800a7f <vprintfmt+0x219>
  800a12:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a16:	74 67                	je     800a7f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	50                   	push   %eax
  800a1f:	56                   	push   %esi
  800a20:	e8 0c 03 00 00       	call   800d31 <strnlen>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a2b:	eb 16                	jmp    800a43 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a2d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	50                   	push   %eax
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e4                	jg     800a2d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a49:	eb 34                	jmp    800a7f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a4f:	74 1c                	je     800a6d <vprintfmt+0x207>
  800a51:	83 fb 1f             	cmp    $0x1f,%ebx
  800a54:	7e 05                	jle    800a5b <vprintfmt+0x1f5>
  800a56:	83 fb 7e             	cmp    $0x7e,%ebx
  800a59:	7e 12                	jle    800a6d <vprintfmt+0x207>
					putch('?', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 3f                	push   $0x3f
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
  800a6b:	eb 0f                	jmp    800a7c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	53                   	push   %ebx
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7f:	89 f0                	mov    %esi,%eax
  800a81:	8d 70 01             	lea    0x1(%eax),%esi
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	0f be d8             	movsbl %al,%ebx
  800a89:	85 db                	test   %ebx,%ebx
  800a8b:	74 24                	je     800ab1 <vprintfmt+0x24b>
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	78 b8                	js     800a4b <vprintfmt+0x1e5>
  800a93:	ff 4d e0             	decl   -0x20(%ebp)
  800a96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a9a:	79 af                	jns    800a4b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a9c:	eb 13                	jmp    800ab1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 20                	push   $0x20
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aae:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab5:	7f e7                	jg     800a9e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ab7:	e9 66 01 00 00       	jmp    800c22 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac5:	50                   	push   %eax
  800ac6:	e8 3c fd ff ff       	call   800807 <getint>
  800acb:	83 c4 10             	add    $0x10,%esp
  800ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ada:	85 d2                	test   %edx,%edx
  800adc:	79 23                	jns    800b01 <vprintfmt+0x29b>
				putch('-', putdat);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	6a 2d                	push   $0x2d
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	ff d0                	call   *%eax
  800aeb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af4:	f7 d8                	neg    %eax
  800af6:	83 d2 00             	adc    $0x0,%edx
  800af9:	f7 da                	neg    %edx
  800afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b08:	e9 bc 00 00 00       	jmp    800bc9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	ff 75 e8             	pushl  -0x18(%ebp)
  800b13:	8d 45 14             	lea    0x14(%ebp),%eax
  800b16:	50                   	push   %eax
  800b17:	e8 84 fc ff ff       	call   8007a0 <getuint>
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 98 00 00 00       	jmp    800bc9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	6a 58                	push   $0x58
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	ff d0                	call   *%eax
  800b3e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	6a 58                	push   $0x58
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	6a 58                	push   $0x58
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
			break;
  800b61:	e9 bc 00 00 00       	jmp    800c22 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	6a 30                	push   $0x30
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 0c             	pushl  0xc(%ebp)
  800b7c:	6a 78                	push   $0x78
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	ff d0                	call   *%eax
  800b83:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 c0 04             	add    $0x4,%eax
  800b8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ba1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ba8:	eb 1f                	jmp    800bc9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb3:	50                   	push   %eax
  800bb4:	e8 e7 fb ff ff       	call   8007a0 <getuint>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bc2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	83 ec 04             	sub    $0x4,%esp
  800bd3:	52                   	push   %edx
  800bd4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bd7:	50                   	push   %eax
  800bd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	e8 00 fb ff ff       	call   8006e9 <printnum>
  800be9:	83 c4 20             	add    $0x20,%esp
			break;
  800bec:	eb 34                	jmp    800c22 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	53                   	push   %ebx
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	ff d0                	call   *%eax
  800bfa:	83 c4 10             	add    $0x10,%esp
			break;
  800bfd:	eb 23                	jmp    800c22 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	6a 25                	push   $0x25
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	ff d0                	call   *%eax
  800c0c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c0f:	ff 4d 10             	decl   0x10(%ebp)
  800c12:	eb 03                	jmp    800c17 <vprintfmt+0x3b1>
  800c14:	ff 4d 10             	decl   0x10(%ebp)
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	48                   	dec    %eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	3c 25                	cmp    $0x25,%al
  800c1f:	75 f3                	jne    800c14 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c21:	90                   	nop
		}
	}
  800c22:	e9 47 fc ff ff       	jmp    80086e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c27:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c35:	8d 45 10             	lea    0x10(%ebp),%eax
  800c38:	83 c0 04             	add    $0x4,%eax
  800c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c41:	ff 75 f4             	pushl  -0xc(%ebp)
  800c44:	50                   	push   %eax
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	ff 75 08             	pushl  0x8(%ebp)
  800c4b:	e8 16 fc ff ff       	call   800866 <vprintfmt>
  800c50:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c53:	90                   	nop
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	8b 40 08             	mov    0x8(%eax),%eax
  800c5f:	8d 50 01             	lea    0x1(%eax),%edx
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8b 10                	mov    (%eax),%edx
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8b 40 04             	mov    0x4(%eax),%eax
  800c73:	39 c2                	cmp    %eax,%edx
  800c75:	73 12                	jae    800c89 <sprintputch+0x33>
		*b->buf++ = ch;
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	8d 48 01             	lea    0x1(%eax),%ecx
  800c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c82:	89 0a                	mov    %ecx,(%edx)
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	88 10                	mov    %dl,(%eax)
}
  800c89:	90                   	nop
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	01 d0                	add    %edx,%eax
  800ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cb1:	74 06                	je     800cb9 <vsnprintf+0x2d>
  800cb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb7:	7f 07                	jg     800cc0 <vsnprintf+0x34>
		return -E_INVAL;
  800cb9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbe:	eb 20                	jmp    800ce0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cc0:	ff 75 14             	pushl  0x14(%ebp)
  800cc3:	ff 75 10             	pushl  0x10(%ebp)
  800cc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc9:	50                   	push   %eax
  800cca:	68 56 0c 80 00       	push   $0x800c56
  800ccf:	e8 92 fb ff ff       	call   800866 <vprintfmt>
  800cd4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cda:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ce8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ceb:	83 c0 04             	add    $0x4,%eax
  800cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 89 ff ff ff       	call   800c8c <vsnprintf>
  800d03:	83 c4 10             	add    $0x10,%esp
  800d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1b:	eb 06                	jmp    800d23 <strlen+0x15>
		n++;
  800d1d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d20:	ff 45 08             	incl   0x8(%ebp)
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 f1                	jne    800d1d <strlen+0xf>
		n++;
	return n;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3e:	eb 09                	jmp    800d49 <strnlen+0x18>
		n++;
  800d40:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d43:	ff 45 08             	incl   0x8(%ebp)
  800d46:	ff 4d 0c             	decl   0xc(%ebp)
  800d49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4d:	74 09                	je     800d58 <strnlen+0x27>
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	84 c0                	test   %al,%al
  800d56:	75 e8                	jne    800d40 <strnlen+0xf>
		n++;
	return n;
  800d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d69:	90                   	nop
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8d 50 01             	lea    0x1(%eax),%edx
  800d70:	89 55 08             	mov    %edx,0x8(%ebp)
  800d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d79:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7c:	8a 12                	mov    (%edx),%dl
  800d7e:	88 10                	mov    %dl,(%eax)
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	84 c0                	test   %al,%al
  800d84:	75 e4                	jne    800d6a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d89:	c9                   	leave  
  800d8a:	c3                   	ret    

00800d8b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d9e:	eb 1f                	jmp    800dbf <strncpy+0x34>
		*dst++ = *src;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8d 50 01             	lea    0x1(%eax),%edx
  800da6:	89 55 08             	mov    %edx,0x8(%ebp)
  800da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dac:	8a 12                	mov    (%edx),%dl
  800dae:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	74 03                	je     800dbc <strncpy+0x31>
			src++;
  800db9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dbc:	ff 45 fc             	incl   -0x4(%ebp)
  800dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc5:	72 d9                	jb     800da0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	74 30                	je     800e0e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dde:	eb 16                	jmp    800df6 <strlcpy+0x2a>
			*dst++ = *src++;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8d 50 01             	lea    0x1(%eax),%edx
  800de6:	89 55 08             	mov    %edx,0x8(%ebp)
  800de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800def:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800df2:	8a 12                	mov    (%edx),%dl
  800df4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800df6:	ff 4d 10             	decl   0x10(%ebp)
  800df9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfd:	74 09                	je     800e08 <strlcpy+0x3c>
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	84 c0                	test   %al,%al
  800e06:	75 d8                	jne    800de0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e14:	29 c2                	sub    %eax,%edx
  800e16:	89 d0                	mov    %edx,%eax
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e1d:	eb 06                	jmp    800e25 <strcmp+0xb>
		p++, q++;
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	84 c0                	test   %al,%al
  800e2c:	74 0e                	je     800e3c <strcmp+0x22>
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 10                	mov    (%eax),%dl
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	38 c2                	cmp    %al,%dl
  800e3a:	74 e3                	je     800e1f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	0f b6 d0             	movzbl %al,%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f b6 c0             	movzbl %al,%eax
  800e4c:	29 c2                	sub    %eax,%edx
  800e4e:	89 d0                	mov    %edx,%eax
}
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e55:	eb 09                	jmp    800e60 <strncmp+0xe>
		n--, p++, q++;
  800e57:	ff 4d 10             	decl   0x10(%ebp)
  800e5a:	ff 45 08             	incl   0x8(%ebp)
  800e5d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	74 17                	je     800e7d <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	74 0e                	je     800e7d <strncmp+0x2b>
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 10                	mov    (%eax),%dl
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	38 c2                	cmp    %al,%dl
  800e7b:	74 da                	je     800e57 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e81:	75 07                	jne    800e8a <strncmp+0x38>
		return 0;
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
  800e88:	eb 14                	jmp    800e9e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d0             	movzbl %al,%edx
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	29 c2                	sub    %eax,%edx
  800e9c:	89 d0                	mov    %edx,%eax
}
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 04             	sub    $0x4,%esp
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eac:	eb 12                	jmp    800ec0 <strchr+0x20>
		if (*s == c)
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eb6:	75 05                	jne    800ebd <strchr+0x1d>
			return (char *) s;
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	eb 11                	jmp    800ece <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ebd:	ff 45 08             	incl   0x8(%ebp)
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	75 e5                	jne    800eae <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 04             	sub    $0x4,%esp
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800edc:	eb 0d                	jmp    800eeb <strfind+0x1b>
		if (*s == c)
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee6:	74 0e                	je     800ef6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ee8:	ff 45 08             	incl   0x8(%ebp)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 ea                	jne    800ede <strfind+0xe>
  800ef4:	eb 01                	jmp    800ef7 <strfind+0x27>
		if (*s == c)
			break;
  800ef6:	90                   	nop
	return (char *) s;
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f0e:	eb 0e                	jmp    800f1e <memset+0x22>
		*p++ = c;
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	8d 50 01             	lea    0x1(%eax),%edx
  800f16:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f1e:	ff 4d f8             	decl   -0x8(%ebp)
  800f21:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f25:	79 e9                	jns    800f10 <memset+0x14>
		*p++ = c;

	return v;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f3e:	eb 16                	jmp    800f56 <memcpy+0x2a>
		*d++ = *s++;
  800f40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f43:	8d 50 01             	lea    0x1(%eax),%edx
  800f46:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f49:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f52:	8a 12                	mov    (%edx),%dl
  800f54:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f56:	8b 45 10             	mov    0x10(%ebp),%eax
  800f59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	75 dd                	jne    800f40 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f80:	73 50                	jae    800fd2 <memmove+0x6a>
  800f82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	01 d0                	add    %edx,%eax
  800f8a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8d:	76 43                	jbe    800fd2 <memmove+0x6a>
		s += n;
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f95:	8b 45 10             	mov    0x10(%ebp),%eax
  800f98:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9b:	eb 10                	jmp    800fad <memmove+0x45>
			*--d = *--s;
  800f9d:	ff 4d f8             	decl   -0x8(%ebp)
  800fa0:	ff 4d fc             	decl   -0x4(%ebp)
  800fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa6:	8a 10                	mov    (%eax),%dl
  800fa8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fab:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	75 e3                	jne    800f9d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fba:	eb 23                	jmp    800fdf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbf:	8d 50 01             	lea    0x1(%eax),%edx
  800fc2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fcb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fce:	8a 12                	mov    (%edx),%dl
  800fd0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	75 dd                	jne    800fbc <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ff6:	eb 2a                	jmp    801022 <memcmp+0x3e>
		if (*s1 != *s2)
  800ff8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffb:	8a 10                	mov    (%eax),%dl
  800ffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	38 c2                	cmp    %al,%dl
  801004:	74 16                	je     80101c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801006:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	0f b6 d0             	movzbl %al,%edx
  80100e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 c0             	movzbl %al,%eax
  801016:	29 c2                	sub    %eax,%edx
  801018:	89 d0                	mov    %edx,%eax
  80101a:	eb 18                	jmp    801034 <memcmp+0x50>
		s1++, s2++;
  80101c:	ff 45 fc             	incl   -0x4(%ebp)
  80101f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	8d 50 ff             	lea    -0x1(%eax),%edx
  801028:	89 55 10             	mov    %edx,0x10(%ebp)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	75 c9                	jne    800ff8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80102f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801034:	c9                   	leave  
  801035:	c3                   	ret    

00801036 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	01 d0                	add    %edx,%eax
  801044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801047:	eb 15                	jmp    80105e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f b6 d0             	movzbl %al,%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	0f b6 c0             	movzbl %al,%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	74 0d                	je     801068 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80105b:	ff 45 08             	incl   0x8(%ebp)
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801064:	72 e3                	jb     801049 <memfind+0x13>
  801066:	eb 01                	jmp    801069 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801068:	90                   	nop
	return (void *) s;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80107b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801082:	eb 03                	jmp    801087 <strtol+0x19>
		s++;
  801084:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 20                	cmp    $0x20,%al
  80108e:	74 f4                	je     801084 <strtol+0x16>
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 09                	cmp    $0x9,%al
  801097:	74 eb                	je     801084 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	3c 2b                	cmp    $0x2b,%al
  8010a0:	75 05                	jne    8010a7 <strtol+0x39>
		s++;
  8010a2:	ff 45 08             	incl   0x8(%ebp)
  8010a5:	eb 13                	jmp    8010ba <strtol+0x4c>
	else if (*s == '-')
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	3c 2d                	cmp    $0x2d,%al
  8010ae:	75 0a                	jne    8010ba <strtol+0x4c>
		s++, neg = 1;
  8010b0:	ff 45 08             	incl   0x8(%ebp)
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010be:	74 06                	je     8010c6 <strtol+0x58>
  8010c0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010c4:	75 20                	jne    8010e6 <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 30                	cmp    $0x30,%al
  8010cd:	75 17                	jne    8010e6 <strtol+0x78>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	40                   	inc    %eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3c 78                	cmp    $0x78,%al
  8010d7:	75 0d                	jne    8010e6 <strtol+0x78>
		s += 2, base = 16;
  8010d9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010dd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010e4:	eb 28                	jmp    80110e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ea:	75 15                	jne    801101 <strtol+0x93>
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 30                	cmp    $0x30,%al
  8010f3:	75 0c                	jne    801101 <strtol+0x93>
		s++, base = 8;
  8010f5:	ff 45 08             	incl   0x8(%ebp)
  8010f8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010ff:	eb 0d                	jmp    80110e <strtol+0xa0>
	else if (base == 0)
  801101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801105:	75 07                	jne    80110e <strtol+0xa0>
		base = 10;
  801107:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 2f                	cmp    $0x2f,%al
  801115:	7e 19                	jle    801130 <strtol+0xc2>
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 39                	cmp    $0x39,%al
  80111e:	7f 10                	jg     801130 <strtol+0xc2>
			dig = *s - '0';
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f be c0             	movsbl %al,%eax
  801128:	83 e8 30             	sub    $0x30,%eax
  80112b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80112e:	eb 42                	jmp    801172 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 60                	cmp    $0x60,%al
  801137:	7e 19                	jle    801152 <strtol+0xe4>
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	3c 7a                	cmp    $0x7a,%al
  801140:	7f 10                	jg     801152 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	0f be c0             	movsbl %al,%eax
  80114a:	83 e8 57             	sub    $0x57,%eax
  80114d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801150:	eb 20                	jmp    801172 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 40                	cmp    $0x40,%al
  801159:	7e 39                	jle    801194 <strtol+0x126>
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 5a                	cmp    $0x5a,%al
  801162:	7f 30                	jg     801194 <strtol+0x126>
			dig = *s - 'A' + 10;
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	0f be c0             	movsbl %al,%eax
  80116c:	83 e8 37             	sub    $0x37,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801175:	3b 45 10             	cmp    0x10(%ebp),%eax
  801178:	7d 19                	jge    801193 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80117a:	ff 45 08             	incl   0x8(%ebp)
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801180:	0f af 45 10          	imul   0x10(%ebp),%eax
  801184:	89 c2                	mov    %eax,%edx
  801186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80118e:	e9 7b ff ff ff       	jmp    80110e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801193:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801194:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801198:	74 08                	je     8011a2 <strtol+0x134>
		*endptr = (char *) s;
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a6:	74 07                	je     8011af <strtol+0x141>
  8011a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ab:	f7 d8                	neg    %eax
  8011ad:	eb 03                	jmp    8011b2 <strtol+0x144>
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <ltostr>:

void
ltostr(long value, char *str)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	79 13                	jns    8011e1 <ltostr+0x2d>
	{
		neg = 1;
  8011ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011db:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011de:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e9:	99                   	cltd   
  8011ea:	f7 f9                	idiv   %ecx
  8011ec:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f2:	8d 50 01             	lea    0x1(%eax),%edx
  8011f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011f8:	89 c2                	mov    %eax,%edx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 d0                	add    %edx,%eax
  8011ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801202:	83 c2 30             	add    $0x30,%edx
  801205:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801207:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80120f:	f7 e9                	imul   %ecx
  801211:	c1 fa 02             	sar    $0x2,%edx
  801214:	89 c8                	mov    %ecx,%eax
  801216:	c1 f8 1f             	sar    $0x1f,%eax
  801219:	29 c2                	sub    %eax,%edx
  80121b:	89 d0                	mov    %edx,%eax
  80121d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801223:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801228:	f7 e9                	imul   %ecx
  80122a:	c1 fa 02             	sar    $0x2,%edx
  80122d:	89 c8                	mov    %ecx,%eax
  80122f:	c1 f8 1f             	sar    $0x1f,%eax
  801232:	29 c2                	sub    %eax,%edx
  801234:	89 d0                	mov    %edx,%eax
  801236:	c1 e0 02             	shl    $0x2,%eax
  801239:	01 d0                	add    %edx,%eax
  80123b:	01 c0                	add    %eax,%eax
  80123d:	29 c1                	sub    %eax,%ecx
  80123f:	89 ca                	mov    %ecx,%edx
  801241:	85 d2                	test   %edx,%edx
  801243:	75 9c                	jne    8011e1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801245:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	48                   	dec    %eax
  801250:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 3d                	je     801296 <ltostr+0xe2>
		start = 1 ;
  801259:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801260:	eb 34                	jmp    801296 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80126f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	01 c2                	add    %eax,%edx
  801277:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 c8                	add    %ecx,%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801283:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 c2                	add    %eax,%edx
  80128b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80128e:	88 02                	mov    %al,(%edx)
		start++ ;
  801290:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801293:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80129c:	7c c4                	jl     801262 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80129e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a9:	90                   	nop
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012b2:	ff 75 08             	pushl  0x8(%ebp)
  8012b5:	e8 54 fa ff ff       	call   800d0e <strlen>
  8012ba:	83 c4 04             	add    $0x4,%esp
  8012bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012c0:	ff 75 0c             	pushl  0xc(%ebp)
  8012c3:	e8 46 fa ff ff       	call   800d0e <strlen>
  8012c8:	83 c4 04             	add    $0x4,%esp
  8012cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012dc:	eb 17                	jmp    8012f5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e4:	01 c2                	add    %eax,%edx
  8012e6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	01 c8                	add    %ecx,%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012f2:	ff 45 fc             	incl   -0x4(%ebp)
  8012f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012fb:	7c e1                	jl     8012de <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801304:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80130b:	eb 1f                	jmp    80132c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80130d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801316:	89 c2                	mov    %eax,%edx
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	01 c2                	add    %eax,%edx
  80131d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	01 c8                	add    %ecx,%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801329:	ff 45 f8             	incl   -0x8(%ebp)
  80132c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801332:	7c d9                	jl     80130d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801334:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801337:	8b 45 10             	mov    0x10(%ebp),%eax
  80133a:	01 d0                	add    %edx,%eax
  80133c:	c6 00 00             	movb   $0x0,(%eax)
}
  80133f:	90                   	nop
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80134e:	8b 45 14             	mov    0x14(%ebp),%eax
  801351:	8b 00                	mov    (%eax),%eax
  801353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80135a:	8b 45 10             	mov    0x10(%ebp),%eax
  80135d:	01 d0                	add    %edx,%eax
  80135f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801365:	eb 0c                	jmp    801373 <strsplit+0x31>
			*string++ = 0;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8d 50 01             	lea    0x1(%eax),%edx
  80136d:	89 55 08             	mov    %edx,0x8(%ebp)
  801370:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	84 c0                	test   %al,%al
  80137a:	74 18                	je     801394 <strsplit+0x52>
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	0f be c0             	movsbl %al,%eax
  801384:	50                   	push   %eax
  801385:	ff 75 0c             	pushl  0xc(%ebp)
  801388:	e8 13 fb ff ff       	call   800ea0 <strchr>
  80138d:	83 c4 08             	add    $0x8,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	75 d3                	jne    801367 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	84 c0                	test   %al,%al
  80139b:	74 5a                	je     8013f7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80139d:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a0:	8b 00                	mov    (%eax),%eax
  8013a2:	83 f8 0f             	cmp    $0xf,%eax
  8013a5:	75 07                	jne    8013ae <strsplit+0x6c>
		{
			return 0;
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ac:	eb 66                	jmp    801414 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b6:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b9:	89 0a                	mov    %ecx,(%edx)
  8013bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c5:	01 c2                	add    %eax,%edx
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013cc:	eb 03                	jmp    8013d1 <strsplit+0x8f>
			string++;
  8013ce:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	84 c0                	test   %al,%al
  8013d8:	74 8b                	je     801365 <strsplit+0x23>
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	0f be c0             	movsbl %al,%eax
  8013e2:	50                   	push   %eax
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	e8 b5 fa ff ff       	call   800ea0 <strchr>
  8013eb:	83 c4 08             	add    $0x8,%esp
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	74 dc                	je     8013ce <strsplit+0x8c>
			string++;
	}
  8013f2:	e9 6e ff ff ff       	jmp    801365 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013f7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fb:	8b 00                	mov    (%eax),%eax
  8013fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	01 d0                	add    %edx,%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80140f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80141c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801423:	8b 55 08             	mov    0x8(%ebp),%edx
  801426:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	48                   	dec    %eax
  80142c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80142f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801432:	ba 00 00 00 00       	mov    $0x0,%edx
  801437:	f7 75 ac             	divl   -0x54(%ebp)
  80143a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80143d:	29 d0                	sub    %edx,%eax
  80143f:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801442:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801449:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801450:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801457:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80145e:	eb 3f                	jmp    80149f <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801463:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	50                   	push   %eax
  80146e:	ff 75 e8             	pushl  -0x18(%ebp)
  801471:	68 d0 29 80 00       	push   $0x8029d0
  801476:	e8 11 f2 ff ff       	call   80068c <cprintf>
  80147b:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  80147e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801481:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	50                   	push   %eax
  80148c:	ff 75 e8             	pushl  -0x18(%ebp)
  80148f:	68 e5 29 80 00       	push   $0x8029e5
  801494:	e8 f3 f1 ff ff       	call   80068c <cprintf>
  801499:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80149c:	ff 45 e8             	incl   -0x18(%ebp)
  80149f:	a1 28 30 80 00       	mov    0x803028,%eax
  8014a4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8014a7:	7c b7                	jl     801460 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8014a9:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8014b0:	e9 35 01 00 00       	jmp    8015ea <malloc+0x1d4>
		int flag0=1;
  8014b5:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8014bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014c2:	eb 5e                	jmp    801522 <malloc+0x10c>
			for(int k=0;k<count;k++){
  8014c4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8014cb:	eb 35                	jmp    801502 <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8014cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014d0:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8014d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014da:	39 c2                	cmp    %eax,%edx
  8014dc:	77 21                	ja     8014ff <malloc+0xe9>
  8014de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e1:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014eb:	39 c2                	cmp    %eax,%edx
  8014ed:	76 10                	jbe    8014ff <malloc+0xe9>
					ni=PAGE_SIZE;
  8014ef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  8014f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8014fd:	eb 0d                	jmp    80150c <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8014ff:	ff 45 d8             	incl   -0x28(%ebp)
  801502:	a1 28 30 80 00       	mov    0x803028,%eax
  801507:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80150a:	7c c1                	jl     8014cd <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  80150c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801510:	74 09                	je     80151b <malloc+0x105>
				flag0=0;
  801512:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801519:	eb 16                	jmp    801531 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80151b:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801522:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	01 c2                	add    %eax,%edx
  80152a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152d:	39 c2                	cmp    %eax,%edx
  80152f:	77 93                	ja     8014c4 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801531:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801535:	0f 84 a2 00 00 00    	je     8015dd <malloc+0x1c7>

			int f=1;
  80153b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801542:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801545:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801548:	89 c8                	mov    %ecx,%eax
  80154a:	01 c0                	add    %eax,%eax
  80154c:	01 c8                	add    %ecx,%eax
  80154e:	c1 e0 02             	shl    $0x2,%eax
  801551:	05 20 31 80 00       	add    $0x803120,%eax
  801556:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801558:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801564:	89 d0                	mov    %edx,%eax
  801566:	01 c0                	add    %eax,%eax
  801568:	01 d0                	add    %edx,%eax
  80156a:	c1 e0 02             	shl    $0x2,%eax
  80156d:	05 24 31 80 00       	add    $0x803124,%eax
  801572:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801577:	89 d0                	mov    %edx,%eax
  801579:	01 c0                	add    %eax,%eax
  80157b:	01 d0                	add    %edx,%eax
  80157d:	c1 e0 02             	shl    $0x2,%eax
  801580:	05 28 31 80 00       	add    $0x803128,%eax
  801585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  80158b:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  80158e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801595:	eb 36                	jmp    8015cd <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  801597:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	01 c2                	add    %eax,%edx
  80159f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8015a2:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8015a9:	39 c2                	cmp    %eax,%edx
  8015ab:	73 1d                	jae    8015ca <malloc+0x1b4>
					ni=arr_add[l].end-i;
  8015ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8015b0:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ba:	29 c2                	sub    %eax,%edx
  8015bc:	89 d0                	mov    %edx,%eax
  8015be:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8015c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8015c8:	eb 0d                	jmp    8015d7 <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8015ca:	ff 45 d0             	incl   -0x30(%ebp)
  8015cd:	a1 28 30 80 00       	mov    0x803028,%eax
  8015d2:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8015d5:	7c c0                	jl     801597 <malloc+0x181>
					break;

				}
			}

			if(f){
  8015d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8015db:	75 1d                	jne    8015fa <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  8015dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8015e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e7:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8015ea:	a1 04 30 80 00       	mov    0x803004,%eax
  8015ef:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015f2:	0f 8c bd fe ff ff    	jl     8014b5 <malloc+0x9f>
  8015f8:	eb 01                	jmp    8015fb <malloc+0x1e5>

				}
			}

			if(f){
				break;
  8015fa:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8015fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ff:	75 7a                	jne    80167b <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801601:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	01 d0                	add    %edx,%eax
  80160c:	48                   	dec    %eax
  80160d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801612:	7c 0a                	jl     80161e <malloc+0x208>
			return NULL;
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
  801619:	e9 a4 02 00 00       	jmp    8018c2 <malloc+0x4ac>
		else{
			uint32 s=base_add;
  80161e:	a1 04 30 80 00       	mov    0x803004,%eax
  801623:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801626:	a1 28 30 80 00       	mov    0x803028,%eax
  80162b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80162e:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	ff 75 08             	pushl  0x8(%ebp)
  80163b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80163e:	e8 04 06 00 00       	call   801c47 <sys_allocateMem>
  801643:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801646:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	01 d0                	add    %edx,%eax
  801651:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801656:	a1 28 30 80 00       	mov    0x803028,%eax
  80165b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801661:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801668:	a1 28 30 80 00       	mov    0x803028,%eax
  80166d:	40                   	inc    %eax
  80166e:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801673:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801676:	e9 47 02 00 00       	jmp    8018c2 <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  80167b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801682:	e9 ac 00 00 00       	jmp    801733 <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801687:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80168a:	89 d0                	mov    %edx,%eax
  80168c:	01 c0                	add    %eax,%eax
  80168e:	01 d0                	add    %edx,%eax
  801690:	c1 e0 02             	shl    $0x2,%eax
  801693:	05 24 31 80 00       	add    $0x803124,%eax
  801698:	8b 00                	mov    (%eax),%eax
  80169a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80169d:	eb 7e                	jmp    80171d <malloc+0x307>
			int flag=0;
  80169f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8016a6:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8016ad:	eb 57                	jmp    801706 <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8016af:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016b2:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8016b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016bc:	39 c2                	cmp    %eax,%edx
  8016be:	77 1a                	ja     8016da <malloc+0x2c4>
  8016c0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016c3:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8016ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016cd:	39 c2                	cmp    %eax,%edx
  8016cf:	76 09                	jbe    8016da <malloc+0x2c4>
								flag=1;
  8016d1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8016d8:	eb 36                	jmp    801710 <malloc+0x2fa>
			arr[i].space++;
  8016da:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8016dd:	89 d0                	mov    %edx,%eax
  8016df:	01 c0                	add    %eax,%eax
  8016e1:	01 d0                	add    %edx,%eax
  8016e3:	c1 e0 02             	shl    $0x2,%eax
  8016e6:	05 28 31 80 00       	add    $0x803128,%eax
  8016eb:	8b 00                	mov    (%eax),%eax
  8016ed:	8d 48 01             	lea    0x1(%eax),%ecx
  8016f0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8016f3:	89 d0                	mov    %edx,%eax
  8016f5:	01 c0                	add    %eax,%eax
  8016f7:	01 d0                	add    %edx,%eax
  8016f9:	c1 e0 02             	shl    $0x2,%eax
  8016fc:	05 28 31 80 00       	add    $0x803128,%eax
  801701:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801703:	ff 45 c0             	incl   -0x40(%ebp)
  801706:	a1 28 30 80 00       	mov    0x803028,%eax
  80170b:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80170e:	7c 9f                	jl     8016af <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801710:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801714:	75 19                	jne    80172f <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801716:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80171d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801720:	a1 04 30 80 00       	mov    0x803004,%eax
  801725:	39 c2                	cmp    %eax,%edx
  801727:	0f 82 72 ff ff ff    	jb     80169f <malloc+0x289>
  80172d:	eb 01                	jmp    801730 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  80172f:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801730:	ff 45 cc             	incl   -0x34(%ebp)
  801733:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801736:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801739:	0f 8c 48 ff ff ff    	jl     801687 <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  80173f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801746:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  80174d:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801754:	eb 37                	jmp    80178d <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801756:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801759:	89 d0                	mov    %edx,%eax
  80175b:	01 c0                	add    %eax,%eax
  80175d:	01 d0                	add    %edx,%eax
  80175f:	c1 e0 02             	shl    $0x2,%eax
  801762:	05 28 31 80 00       	add    $0x803128,%eax
  801767:	8b 00                	mov    (%eax),%eax
  801769:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80176c:	7d 1c                	jge    80178a <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  80176e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801771:	89 d0                	mov    %edx,%eax
  801773:	01 c0                	add    %eax,%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	c1 e0 02             	shl    $0x2,%eax
  80177a:	05 28 31 80 00       	add    $0x803128,%eax
  80177f:	8b 00                	mov    (%eax),%eax
  801781:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801784:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801787:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  80178a:	ff 45 b4             	incl   -0x4c(%ebp)
  80178d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801790:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801793:	7c c1                	jl     801756 <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801795:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80179b:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80179e:	89 c8                	mov    %ecx,%eax
  8017a0:	01 c0                	add    %eax,%eax
  8017a2:	01 c8                	add    %ecx,%eax
  8017a4:	c1 e0 02             	shl    $0x2,%eax
  8017a7:	05 20 31 80 00       	add    $0x803120,%eax
  8017ac:	8b 00                	mov    (%eax),%eax
  8017ae:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  8017b5:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8017bb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8017be:	89 c8                	mov    %ecx,%eax
  8017c0:	01 c0                	add    %eax,%eax
  8017c2:	01 c8                	add    %ecx,%eax
  8017c4:	c1 e0 02             	shl    $0x2,%eax
  8017c7:	05 24 31 80 00       	add    $0x803124,%eax
  8017cc:	8b 00                	mov    (%eax),%eax
  8017ce:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8017d5:	a1 28 30 80 00       	mov    0x803028,%eax
  8017da:	40                   	inc    %eax
  8017db:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8017e0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017e3:	89 d0                	mov    %edx,%eax
  8017e5:	01 c0                	add    %eax,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	c1 e0 02             	shl    $0x2,%eax
  8017ec:	05 20 31 80 00       	add    $0x803120,%eax
  8017f1:	8b 00                	mov    (%eax),%eax
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	ff 75 08             	pushl  0x8(%ebp)
  8017f9:	50                   	push   %eax
  8017fa:	e8 48 04 00 00       	call   801c47 <sys_allocateMem>
  8017ff:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801802:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801809:	eb 78                	jmp    801883 <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  80180b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80180e:	89 d0                	mov    %edx,%eax
  801810:	01 c0                	add    %eax,%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	c1 e0 02             	shl    $0x2,%eax
  801817:	05 20 31 80 00       	add    $0x803120,%eax
  80181c:	8b 00                	mov    (%eax),%eax
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	50                   	push   %eax
  801822:	ff 75 b0             	pushl  -0x50(%ebp)
  801825:	68 d0 29 80 00       	push   $0x8029d0
  80182a:	e8 5d ee ff ff       	call   80068c <cprintf>
  80182f:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801832:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801835:	89 d0                	mov    %edx,%eax
  801837:	01 c0                	add    %eax,%eax
  801839:	01 d0                	add    %edx,%eax
  80183b:	c1 e0 02             	shl    $0x2,%eax
  80183e:	05 24 31 80 00       	add    $0x803124,%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	50                   	push   %eax
  801849:	ff 75 b0             	pushl  -0x50(%ebp)
  80184c:	68 e5 29 80 00       	push   $0x8029e5
  801851:	e8 36 ee ff ff       	call   80068c <cprintf>
  801856:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801859:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80185c:	89 d0                	mov    %edx,%eax
  80185e:	01 c0                	add    %eax,%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	c1 e0 02             	shl    $0x2,%eax
  801865:	05 28 31 80 00       	add    $0x803128,%eax
  80186a:	8b 00                	mov    (%eax),%eax
  80186c:	83 ec 04             	sub    $0x4,%esp
  80186f:	50                   	push   %eax
  801870:	ff 75 b0             	pushl  -0x50(%ebp)
  801873:	68 f8 29 80 00       	push   $0x8029f8
  801878:	e8 0f ee ff ff       	call   80068c <cprintf>
  80187d:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801880:	ff 45 b0             	incl   -0x50(%ebp)
  801883:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801889:	7c 80                	jl     80180b <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  80188b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80188e:	89 d0                	mov    %edx,%eax
  801890:	01 c0                	add    %eax,%eax
  801892:	01 d0                	add    %edx,%eax
  801894:	c1 e0 02             	shl    $0x2,%eax
  801897:	05 20 31 80 00       	add    $0x803120,%eax
  80189c:	8b 00                	mov    (%eax),%eax
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	50                   	push   %eax
  8018a2:	68 0c 2a 80 00       	push   $0x802a0c
  8018a7:	e8 e0 ed ff ff       	call   80068c <cprintf>
  8018ac:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8018af:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8018b2:	89 d0                	mov    %edx,%eax
  8018b4:	01 c0                	add    %eax,%eax
  8018b6:	01 d0                	add    %edx,%eax
  8018b8:	c1 e0 02             	shl    $0x2,%eax
  8018bb:	05 20 31 80 00       	add    $0x803120,%eax
  8018c0:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8018d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8018d7:	eb 4b                	jmp    801924 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8018d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018dc:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018e3:	89 c2                	mov    %eax,%edx
  8018e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e8:	39 c2                	cmp    %eax,%edx
  8018ea:	7f 35                	jg     801921 <free+0x5d>
  8018ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ef:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018f6:	89 c2                	mov    %eax,%edx
  8018f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018fb:	39 c2                	cmp    %eax,%edx
  8018fd:	7e 22                	jle    801921 <free+0x5d>
				start=arr_add[i].start;
  8018ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801902:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801909:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  80190c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190f:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801916:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  80191f:	eb 0d                	jmp    80192e <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801921:	ff 45 ec             	incl   -0x14(%ebp)
  801924:	a1 28 30 80 00       	mov    0x803028,%eax
  801929:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80192c:	7c ab                	jl     8018d9 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  80192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801931:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193b:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801942:	29 c2                	sub    %eax,%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	83 ec 08             	sub    $0x8,%esp
  801949:	50                   	push   %eax
  80194a:	ff 75 f4             	pushl  -0xc(%ebp)
  80194d:	e8 d9 02 00 00       	call   801c2b <sys_freeMem>
  801952:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801958:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80195b:	eb 2d                	jmp    80198a <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  80195d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801960:	40                   	inc    %eax
  801961:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80196b:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801975:	40                   	inc    %eax
  801976:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80197d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801980:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801987:	ff 45 e8             	incl   -0x18(%ebp)
  80198a:	a1 28 30 80 00       	mov    0x803028,%eax
  80198f:	48                   	dec    %eax
  801990:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801993:	7f c8                	jg     80195d <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801995:	a1 28 30 80 00       	mov    0x803028,%eax
  80199a:	48                   	dec    %eax
  80199b:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8019a0:	90                   	nop
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 18             	sub    $0x18,%esp
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	68 28 2a 80 00       	push   $0x802a28
  8019b7:	68 18 01 00 00       	push   $0x118
  8019bc:	68 4b 2a 80 00       	push   $0x802a4b
  8019c1:	e8 0b 07 00 00       	call   8020d1 <_panic>

008019c6 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 28 2a 80 00       	push   $0x802a28
  8019d4:	68 1e 01 00 00       	push   $0x11e
  8019d9:	68 4b 2a 80 00       	push   $0x802a4b
  8019de:	e8 ee 06 00 00       	call   8020d1 <_panic>

008019e3 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	68 28 2a 80 00       	push   $0x802a28
  8019f1:	68 24 01 00 00       	push   $0x124
  8019f6:	68 4b 2a 80 00       	push   $0x802a4b
  8019fb:	e8 d1 06 00 00       	call   8020d1 <_panic>

00801a00 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	68 28 2a 80 00       	push   $0x802a28
  801a0e:	68 29 01 00 00       	push   $0x129
  801a13:	68 4b 2a 80 00       	push   $0x802a4b
  801a18:	e8 b4 06 00 00       	call   8020d1 <_panic>

00801a1d <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	68 28 2a 80 00       	push   $0x802a28
  801a2b:	68 2f 01 00 00       	push   $0x12f
  801a30:	68 4b 2a 80 00       	push   $0x802a4b
  801a35:	e8 97 06 00 00       	call   8020d1 <_panic>

00801a3a <shrink>:
}
void shrink(uint32 newSize)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	68 28 2a 80 00       	push   $0x802a28
  801a48:	68 33 01 00 00       	push   $0x133
  801a4d:	68 4b 2a 80 00       	push   $0x802a4b
  801a52:	e8 7a 06 00 00       	call   8020d1 <_panic>

00801a57 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	68 28 2a 80 00       	push   $0x802a28
  801a65:	68 38 01 00 00       	push   $0x138
  801a6a:	68 4b 2a 80 00       	push   $0x802a4b
  801a6f:	e8 5d 06 00 00       	call   8020d1 <_panic>

00801a74 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	57                   	push   %edi
  801a78:	56                   	push   %esi
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a89:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a8c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a8f:	cd 30                	int    $0x30
  801a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5f                   	pop    %edi
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    

00801a9f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801aab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	50                   	push   %eax
  801abb:	6a 00                	push   $0x0
  801abd:	e8 b2 ff ff ff       	call   801a74 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 01                	push   $0x1
  801ad7:	e8 98 ff ff ff       	call   801a74 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	50                   	push   %eax
  801af0:	6a 05                	push   $0x5
  801af2:	e8 7d ff ff ff       	call   801a74 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 02                	push   $0x2
  801b0b:	e8 64 ff ff ff       	call   801a74 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 03                	push   $0x3
  801b24:	e8 4b ff ff ff       	call   801a74 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 04                	push   $0x4
  801b3d:	e8 32 ff ff ff       	call   801a74 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_env_exit>:


void sys_env_exit(void)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 06                	push   $0x6
  801b56:	e8 19 ff ff ff       	call   801a74 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 07                	push   $0x7
  801b74:	e8 fb fe ff ff       	call   801a74 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b83:	8b 75 18             	mov    0x18(%ebp),%esi
  801b86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	51                   	push   %ecx
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	6a 08                	push   $0x8
  801b99:	e8 d6 fe ff ff       	call   801a74 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    

00801ba8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 09                	push   $0x9
  801bbb:	e8 b4 fe ff ff       	call   801a74 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 0a                	push   $0xa
  801bd6:	e8 99 fe ff ff       	call   801a74 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 0b                	push   $0xb
  801bef:	e8 80 fe ff ff       	call   801a74 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 0c                	push   $0xc
  801c08:	e8 67 fe ff ff       	call   801a74 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 0d                	push   $0xd
  801c21:	e8 4e fe ff ff       	call   801a74 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	6a 11                	push   $0x11
  801c3c:	e8 33 fe ff ff       	call   801a74 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	ff 75 08             	pushl  0x8(%ebp)
  801c56:	6a 12                	push   $0x12
  801c58:	e8 17 fe ff ff       	call   801a74 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c60:	90                   	nop
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 0e                	push   $0xe
  801c72:	e8 fd fd ff ff       	call   801a74 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	6a 0f                	push   $0xf
  801c8c:	e8 e3 fd ff ff       	call   801a74 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 10                	push   $0x10
  801ca5:	e8 ca fd ff ff       	call   801a74 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	90                   	nop
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 14                	push   $0x14
  801cbf:	e8 b0 fd ff ff       	call   801a74 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	90                   	nop
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 15                	push   $0x15
  801cd9:	e8 96 fd ff ff       	call   801a74 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	90                   	nop
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	50                   	push   %eax
  801cfd:	6a 16                	push   $0x16
  801cff:	e8 70 fd ff ff       	call   801a74 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	90                   	nop
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 17                	push   $0x17
  801d19:	e8 56 fd ff ff       	call   801a74 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	90                   	nop
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	50                   	push   %eax
  801d34:	6a 18                	push   $0x18
  801d36:	e8 39 fd ff ff       	call   801a74 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	6a 1b                	push   $0x1b
  801d53:	e8 1c fd ff ff       	call   801a74 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 19                	push   $0x19
  801d70:	e8 ff fc ff ff       	call   801a74 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	90                   	nop
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	52                   	push   %edx
  801d8b:	50                   	push   %eax
  801d8c:	6a 1a                	push   $0x1a
  801d8e:	e8 e1 fc ff ff       	call   801a74 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	90                   	nop
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 04             	sub    $0x4,%esp
  801d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801da5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801da8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	51                   	push   %ecx
  801db2:	52                   	push   %edx
  801db3:	ff 75 0c             	pushl  0xc(%ebp)
  801db6:	50                   	push   %eax
  801db7:	6a 1c                	push   $0x1c
  801db9:	e8 b6 fc ff ff       	call   801a74 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	52                   	push   %edx
  801dd3:	50                   	push   %eax
  801dd4:	6a 1d                	push   $0x1d
  801dd6:	e8 99 fc ff ff       	call   801a74 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801de3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	51                   	push   %ecx
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	6a 1e                	push   $0x1e
  801df5:	e8 7a fc ff ff       	call   801a74 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	52                   	push   %edx
  801e0f:	50                   	push   %eax
  801e10:	6a 1f                	push   $0x1f
  801e12:	e8 5d fc ff ff       	call   801a74 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 20                	push   $0x20
  801e2b:	e8 44 fc ff ff       	call   801a74 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	ff 75 14             	pushl  0x14(%ebp)
  801e40:	ff 75 10             	pushl  0x10(%ebp)
  801e43:	ff 75 0c             	pushl  0xc(%ebp)
  801e46:	50                   	push   %eax
  801e47:	6a 21                	push   $0x21
  801e49:	e8 26 fc ff ff       	call   801a74 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	50                   	push   %eax
  801e62:	6a 22                	push   $0x22
  801e64:	e8 0b fc ff ff       	call   801a74 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	90                   	nop
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	50                   	push   %eax
  801e7e:	6a 23                	push   $0x23
  801e80:	e8 ef fb ff ff       	call   801a74 <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	90                   	nop
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e91:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e94:	8d 50 04             	lea    0x4(%eax),%edx
  801e97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	6a 24                	push   $0x24
  801ea4:	e8 cb fb ff ff       	call   801a74 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return result;
  801eac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eb5:	89 01                	mov    %eax,(%ecx)
  801eb7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	c9                   	leave  
  801ebe:	c2 04 00             	ret    $0x4

00801ec1 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	ff 75 10             	pushl  0x10(%ebp)
  801ecb:	ff 75 0c             	pushl  0xc(%ebp)
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 13                	push   $0x13
  801ed3:	e8 9c fb ff ff       	call   801a74 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_rcr2>:
uint32 sys_rcr2()
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 25                	push   $0x25
  801eed:	e8 82 fb ff ff       	call   801a74 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f03:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	50                   	push   %eax
  801f10:	6a 26                	push   $0x26
  801f12:	e8 5d fb ff ff       	call   801a74 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1a:	90                   	nop
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <rsttst>:
void rsttst()
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 28                	push   $0x28
  801f2c:	e8 43 fb ff ff       	call   801a74 <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
	return ;
  801f34:	90                   	nop
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f43:	8b 55 18             	mov    0x18(%ebp),%edx
  801f46:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	ff 75 10             	pushl  0x10(%ebp)
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	6a 27                	push   $0x27
  801f57:	e8 18 fb ff ff       	call   801a74 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <chktst>:
void chktst(uint32 n)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	6a 29                	push   $0x29
  801f72:	e8 fd fa ff ff       	call   801a74 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7a:	90                   	nop
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <inctst>:

void inctst()
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 2a                	push   $0x2a
  801f8c:	e8 e3 fa ff ff       	call   801a74 <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
	return ;
  801f94:	90                   	nop
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <gettst>:
uint32 gettst()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 2b                	push   $0x2b
  801fa6:	e8 c9 fa ff ff       	call   801a74 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 2c                	push   $0x2c
  801fc2:	e8 ad fa ff ff       	call   801a74 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
  801fca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fcd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fd1:	75 07                	jne    801fda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd8:	eb 05                	jmp    801fdf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 2c                	push   $0x2c
  801ff3:	e8 7c fa ff ff       	call   801a74 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
  801ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ffe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802002:	75 07                	jne    80200b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802004:	b8 01 00 00 00       	mov    $0x1,%eax
  802009:	eb 05                	jmp    802010 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 2c                	push   $0x2c
  802024:	e8 4b fa ff ff       	call   801a74 <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
  80202c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80202f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802033:	75 07                	jne    80203c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802035:	b8 01 00 00 00       	mov    $0x1,%eax
  80203a:	eb 05                	jmp    802041 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 2c                	push   $0x2c
  802055:	e8 1a fa ff ff       	call   801a74 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
  80205d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802060:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802064:	75 07                	jne    80206d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802066:	b8 01 00 00 00       	mov    $0x1,%eax
  80206b:	eb 05                	jmp    802072 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	ff 75 08             	pushl  0x8(%ebp)
  802082:	6a 2d                	push   $0x2d
  802084:	e8 eb f9 ff ff       	call   801a74 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
	return ;
  80208c:	90                   	nop
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802093:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802096:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	53                   	push   %ebx
  8020a2:	51                   	push   %ecx
  8020a3:	52                   	push   %edx
  8020a4:	50                   	push   %eax
  8020a5:	6a 2e                	push   $0x2e
  8020a7:	e8 c8 f9 ff ff       	call   801a74 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	52                   	push   %edx
  8020c4:	50                   	push   %eax
  8020c5:	6a 2f                	push   $0x2f
  8020c7:	e8 a8 f9 ff ff       	call   801a74 <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8020d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8020da:	83 c0 04             	add    $0x4,%eax
  8020dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8020e0:	a1 60 3e 83 00       	mov    0x833e60,%eax
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	74 16                	je     8020ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8020e9:	a1 60 3e 83 00       	mov    0x833e60,%eax
  8020ee:	83 ec 08             	sub    $0x8,%esp
  8020f1:	50                   	push   %eax
  8020f2:	68 58 2a 80 00       	push   $0x802a58
  8020f7:	e8 90 e5 ff ff       	call   80068c <cprintf>
  8020fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8020ff:	a1 00 30 80 00       	mov    0x803000,%eax
  802104:	ff 75 0c             	pushl  0xc(%ebp)
  802107:	ff 75 08             	pushl  0x8(%ebp)
  80210a:	50                   	push   %eax
  80210b:	68 5d 2a 80 00       	push   $0x802a5d
  802110:	e8 77 e5 ff ff       	call   80068c <cprintf>
  802115:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802118:	8b 45 10             	mov    0x10(%ebp),%eax
  80211b:	83 ec 08             	sub    $0x8,%esp
  80211e:	ff 75 f4             	pushl  -0xc(%ebp)
  802121:	50                   	push   %eax
  802122:	e8 fa e4 ff ff       	call   800621 <vcprintf>
  802127:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80212a:	83 ec 08             	sub    $0x8,%esp
  80212d:	6a 00                	push   $0x0
  80212f:	68 79 2a 80 00       	push   $0x802a79
  802134:	e8 e8 e4 ff ff       	call   800621 <vcprintf>
  802139:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80213c:	e8 69 e4 ff ff       	call   8005aa <exit>

	// should not return here
	while (1) ;
  802141:	eb fe                	jmp    802141 <_panic+0x70>

00802143 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802149:	a1 20 30 80 00       	mov    0x803020,%eax
  80214e:	8b 50 74             	mov    0x74(%eax),%edx
  802151:	8b 45 0c             	mov    0xc(%ebp),%eax
  802154:	39 c2                	cmp    %eax,%edx
  802156:	74 14                	je     80216c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 7c 2a 80 00       	push   $0x802a7c
  802160:	6a 26                	push   $0x26
  802162:	68 c8 2a 80 00       	push   $0x802ac8
  802167:	e8 65 ff ff ff       	call   8020d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80216c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802173:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80217a:	e9 b6 00 00 00       	jmp    802235 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	01 d0                	add    %edx,%eax
  80218e:	8b 00                	mov    (%eax),%eax
  802190:	85 c0                	test   %eax,%eax
  802192:	75 08                	jne    80219c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802194:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802197:	e9 96 00 00 00       	jmp    802232 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80219c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8021a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8021aa:	eb 5d                	jmp    802209 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8021ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8021b1:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8021b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021ba:	c1 e2 04             	shl    $0x4,%edx
  8021bd:	01 d0                	add    %edx,%eax
  8021bf:	8a 40 04             	mov    0x4(%eax),%al
  8021c2:	84 c0                	test   %al,%al
  8021c4:	75 40                	jne    802206 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8021c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8021cb:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8021d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021d4:	c1 e2 04             	shl    $0x4,%edx
  8021d7:	01 d0                	add    %edx,%eax
  8021d9:	8b 00                	mov    (%eax),%eax
  8021db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8021de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021e6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8021f9:	39 c2                	cmp    %eax,%edx
  8021fb:	75 09                	jne    802206 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8021fd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802204:	eb 12                	jmp    802218 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802206:	ff 45 e8             	incl   -0x18(%ebp)
  802209:	a1 20 30 80 00       	mov    0x803020,%eax
  80220e:	8b 50 74             	mov    0x74(%eax),%edx
  802211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802214:	39 c2                	cmp    %eax,%edx
  802216:	77 94                	ja     8021ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802218:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80221c:	75 14                	jne    802232 <CheckWSWithoutLastIndex+0xef>
			panic(
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	68 d4 2a 80 00       	push   $0x802ad4
  802226:	6a 3a                	push   $0x3a
  802228:	68 c8 2a 80 00       	push   $0x802ac8
  80222d:	e8 9f fe ff ff       	call   8020d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802232:	ff 45 f0             	incl   -0x10(%ebp)
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80223b:	0f 8c 3e ff ff ff    	jl     80217f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802241:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802248:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80224f:	eb 20                	jmp    802271 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802251:	a1 20 30 80 00       	mov    0x803020,%eax
  802256:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80225c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80225f:	c1 e2 04             	shl    $0x4,%edx
  802262:	01 d0                	add    %edx,%eax
  802264:	8a 40 04             	mov    0x4(%eax),%al
  802267:	3c 01                	cmp    $0x1,%al
  802269:	75 03                	jne    80226e <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80226b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80226e:	ff 45 e0             	incl   -0x20(%ebp)
  802271:	a1 20 30 80 00       	mov    0x803020,%eax
  802276:	8b 50 74             	mov    0x74(%eax),%edx
  802279:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80227c:	39 c2                	cmp    %eax,%edx
  80227e:	77 d1                	ja     802251 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802286:	74 14                	je     80229c <CheckWSWithoutLastIndex+0x159>
		panic(
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	68 28 2b 80 00       	push   $0x802b28
  802290:	6a 44                	push   $0x44
  802292:	68 c8 2a 80 00       	push   $0x802ac8
  802297:	e8 35 fe ff ff       	call   8020d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80229c:	90                   	nop
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    
  80229f:	90                   	nop

008022a0 <__udivdi3>:
  8022a0:	55                   	push   %ebp
  8022a1:	57                   	push   %edi
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 1c             	sub    $0x1c,%esp
  8022a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022b7:	89 ca                	mov    %ecx,%edx
  8022b9:	89 f8                	mov    %edi,%eax
  8022bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8022bf:	85 f6                	test   %esi,%esi
  8022c1:	75 2d                	jne    8022f0 <__udivdi3+0x50>
  8022c3:	39 cf                	cmp    %ecx,%edi
  8022c5:	77 65                	ja     80232c <__udivdi3+0x8c>
  8022c7:	89 fd                	mov    %edi,%ebp
  8022c9:	85 ff                	test   %edi,%edi
  8022cb:	75 0b                	jne    8022d8 <__udivdi3+0x38>
  8022cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d2:	31 d2                	xor    %edx,%edx
  8022d4:	f7 f7                	div    %edi
  8022d6:	89 c5                	mov    %eax,%ebp
  8022d8:	31 d2                	xor    %edx,%edx
  8022da:	89 c8                	mov    %ecx,%eax
  8022dc:	f7 f5                	div    %ebp
  8022de:	89 c1                	mov    %eax,%ecx
  8022e0:	89 d8                	mov    %ebx,%eax
  8022e2:	f7 f5                	div    %ebp
  8022e4:	89 cf                	mov    %ecx,%edi
  8022e6:	89 fa                	mov    %edi,%edx
  8022e8:	83 c4 1c             	add    $0x1c,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    
  8022f0:	39 ce                	cmp    %ecx,%esi
  8022f2:	77 28                	ja     80231c <__udivdi3+0x7c>
  8022f4:	0f bd fe             	bsr    %esi,%edi
  8022f7:	83 f7 1f             	xor    $0x1f,%edi
  8022fa:	75 40                	jne    80233c <__udivdi3+0x9c>
  8022fc:	39 ce                	cmp    %ecx,%esi
  8022fe:	72 0a                	jb     80230a <__udivdi3+0x6a>
  802300:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802304:	0f 87 9e 00 00 00    	ja     8023a8 <__udivdi3+0x108>
  80230a:	b8 01 00 00 00       	mov    $0x1,%eax
  80230f:	89 fa                	mov    %edi,%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d 76 00             	lea    0x0(%esi),%esi
  80231c:	31 ff                	xor    %edi,%edi
  80231e:	31 c0                	xor    %eax,%eax
  802320:	89 fa                	mov    %edi,%edx
  802322:	83 c4 1c             	add    $0x1c,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5f                   	pop    %edi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	89 d8                	mov    %ebx,%eax
  80232e:	f7 f7                	div    %edi
  802330:	31 ff                	xor    %edi,%edi
  802332:	89 fa                	mov    %edi,%edx
  802334:	83 c4 1c             	add    $0x1c,%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    
  80233c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802341:	89 eb                	mov    %ebp,%ebx
  802343:	29 fb                	sub    %edi,%ebx
  802345:	89 f9                	mov    %edi,%ecx
  802347:	d3 e6                	shl    %cl,%esi
  802349:	89 c5                	mov    %eax,%ebp
  80234b:	88 d9                	mov    %bl,%cl
  80234d:	d3 ed                	shr    %cl,%ebp
  80234f:	89 e9                	mov    %ebp,%ecx
  802351:	09 f1                	or     %esi,%ecx
  802353:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802357:	89 f9                	mov    %edi,%ecx
  802359:	d3 e0                	shl    %cl,%eax
  80235b:	89 c5                	mov    %eax,%ebp
  80235d:	89 d6                	mov    %edx,%esi
  80235f:	88 d9                	mov    %bl,%cl
  802361:	d3 ee                	shr    %cl,%esi
  802363:	89 f9                	mov    %edi,%ecx
  802365:	d3 e2                	shl    %cl,%edx
  802367:	8b 44 24 08          	mov    0x8(%esp),%eax
  80236b:	88 d9                	mov    %bl,%cl
  80236d:	d3 e8                	shr    %cl,%eax
  80236f:	09 c2                	or     %eax,%edx
  802371:	89 d0                	mov    %edx,%eax
  802373:	89 f2                	mov    %esi,%edx
  802375:	f7 74 24 0c          	divl   0xc(%esp)
  802379:	89 d6                	mov    %edx,%esi
  80237b:	89 c3                	mov    %eax,%ebx
  80237d:	f7 e5                	mul    %ebp
  80237f:	39 d6                	cmp    %edx,%esi
  802381:	72 19                	jb     80239c <__udivdi3+0xfc>
  802383:	74 0b                	je     802390 <__udivdi3+0xf0>
  802385:	89 d8                	mov    %ebx,%eax
  802387:	31 ff                	xor    %edi,%edi
  802389:	e9 58 ff ff ff       	jmp    8022e6 <__udivdi3+0x46>
  80238e:	66 90                	xchg   %ax,%ax
  802390:	8b 54 24 08          	mov    0x8(%esp),%edx
  802394:	89 f9                	mov    %edi,%ecx
  802396:	d3 e2                	shl    %cl,%edx
  802398:	39 c2                	cmp    %eax,%edx
  80239a:	73 e9                	jae    802385 <__udivdi3+0xe5>
  80239c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80239f:	31 ff                	xor    %edi,%edi
  8023a1:	e9 40 ff ff ff       	jmp    8022e6 <__udivdi3+0x46>
  8023a6:	66 90                	xchg   %ax,%ax
  8023a8:	31 c0                	xor    %eax,%eax
  8023aa:	e9 37 ff ff ff       	jmp    8022e6 <__udivdi3+0x46>
  8023af:	90                   	nop

008023b0 <__umoddi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8023bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023cf:	89 f3                	mov    %esi,%ebx
  8023d1:	89 fa                	mov    %edi,%edx
  8023d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023d7:	89 34 24             	mov    %esi,(%esp)
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	75 1a                	jne    8023f8 <__umoddi3+0x48>
  8023de:	39 f7                	cmp    %esi,%edi
  8023e0:	0f 86 a2 00 00 00    	jbe    802488 <__umoddi3+0xd8>
  8023e6:	89 c8                	mov    %ecx,%eax
  8023e8:	89 f2                	mov    %esi,%edx
  8023ea:	f7 f7                	div    %edi
  8023ec:	89 d0                	mov    %edx,%eax
  8023ee:	31 d2                	xor    %edx,%edx
  8023f0:	83 c4 1c             	add    $0x1c,%esp
  8023f3:	5b                   	pop    %ebx
  8023f4:	5e                   	pop    %esi
  8023f5:	5f                   	pop    %edi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    
  8023f8:	39 f0                	cmp    %esi,%eax
  8023fa:	0f 87 ac 00 00 00    	ja     8024ac <__umoddi3+0xfc>
  802400:	0f bd e8             	bsr    %eax,%ebp
  802403:	83 f5 1f             	xor    $0x1f,%ebp
  802406:	0f 84 ac 00 00 00    	je     8024b8 <__umoddi3+0x108>
  80240c:	bf 20 00 00 00       	mov    $0x20,%edi
  802411:	29 ef                	sub    %ebp,%edi
  802413:	89 fe                	mov    %edi,%esi
  802415:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	d3 e0                	shl    %cl,%eax
  80241d:	89 d7                	mov    %edx,%edi
  80241f:	89 f1                	mov    %esi,%ecx
  802421:	d3 ef                	shr    %cl,%edi
  802423:	09 c7                	or     %eax,%edi
  802425:	89 e9                	mov    %ebp,%ecx
  802427:	d3 e2                	shl    %cl,%edx
  802429:	89 14 24             	mov    %edx,(%esp)
  80242c:	89 d8                	mov    %ebx,%eax
  80242e:	d3 e0                	shl    %cl,%eax
  802430:	89 c2                	mov    %eax,%edx
  802432:	8b 44 24 08          	mov    0x8(%esp),%eax
  802436:	d3 e0                	shl    %cl,%eax
  802438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802440:	89 f1                	mov    %esi,%ecx
  802442:	d3 e8                	shr    %cl,%eax
  802444:	09 d0                	or     %edx,%eax
  802446:	d3 eb                	shr    %cl,%ebx
  802448:	89 da                	mov    %ebx,%edx
  80244a:	f7 f7                	div    %edi
  80244c:	89 d3                	mov    %edx,%ebx
  80244e:	f7 24 24             	mull   (%esp)
  802451:	89 c6                	mov    %eax,%esi
  802453:	89 d1                	mov    %edx,%ecx
  802455:	39 d3                	cmp    %edx,%ebx
  802457:	0f 82 87 00 00 00    	jb     8024e4 <__umoddi3+0x134>
  80245d:	0f 84 91 00 00 00    	je     8024f4 <__umoddi3+0x144>
  802463:	8b 54 24 04          	mov    0x4(%esp),%edx
  802467:	29 f2                	sub    %esi,%edx
  802469:	19 cb                	sbb    %ecx,%ebx
  80246b:	89 d8                	mov    %ebx,%eax
  80246d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 e9                	mov    %ebp,%ecx
  802475:	d3 ea                	shr    %cl,%edx
  802477:	09 d0                	or     %edx,%eax
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	d3 eb                	shr    %cl,%ebx
  80247d:	89 da                	mov    %ebx,%edx
  80247f:	83 c4 1c             	add    $0x1c,%esp
  802482:	5b                   	pop    %ebx
  802483:	5e                   	pop    %esi
  802484:	5f                   	pop    %edi
  802485:	5d                   	pop    %ebp
  802486:	c3                   	ret    
  802487:	90                   	nop
  802488:	89 fd                	mov    %edi,%ebp
  80248a:	85 ff                	test   %edi,%edi
  80248c:	75 0b                	jne    802499 <__umoddi3+0xe9>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f7                	div    %edi
  802497:	89 c5                	mov    %eax,%ebp
  802499:	89 f0                	mov    %esi,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f5                	div    %ebp
  80249f:	89 c8                	mov    %ecx,%eax
  8024a1:	f7 f5                	div    %ebp
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	e9 44 ff ff ff       	jmp    8023ee <__umoddi3+0x3e>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	89 c8                	mov    %ecx,%eax
  8024ae:	89 f2                	mov    %esi,%edx
  8024b0:	83 c4 1c             	add    $0x1c,%esp
  8024b3:	5b                   	pop    %ebx
  8024b4:	5e                   	pop    %esi
  8024b5:	5f                   	pop    %edi
  8024b6:	5d                   	pop    %ebp
  8024b7:	c3                   	ret    
  8024b8:	3b 04 24             	cmp    (%esp),%eax
  8024bb:	72 06                	jb     8024c3 <__umoddi3+0x113>
  8024bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8024c1:	77 0f                	ja     8024d2 <__umoddi3+0x122>
  8024c3:	89 f2                	mov    %esi,%edx
  8024c5:	29 f9                	sub    %edi,%ecx
  8024c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8024cb:	89 14 24             	mov    %edx,(%esp)
  8024ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024d6:	8b 14 24             	mov    (%esp),%edx
  8024d9:	83 c4 1c             	add    $0x1c,%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	8d 76 00             	lea    0x0(%esi),%esi
  8024e4:	2b 04 24             	sub    (%esp),%eax
  8024e7:	19 fa                	sbb    %edi,%edx
  8024e9:	89 d1                	mov    %edx,%ecx
  8024eb:	89 c6                	mov    %eax,%esi
  8024ed:	e9 71 ff ff ff       	jmp    802463 <__umoddi3+0xb3>
  8024f2:	66 90                	xchg   %ax,%ax
  8024f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8024f8:	72 ea                	jb     8024e4 <__umoddi3+0x134>
  8024fa:	89 d9                	mov    %ebx,%ecx
  8024fc:	e9 62 ff ff ff       	jmp    802463 <__umoddi3+0xb3>
