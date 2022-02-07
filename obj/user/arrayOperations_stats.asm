
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 73 1b 00 00       	call   801bb6 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 9d 1b 00 00       	call   801be8 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 c0 25 80 00       	push   $0x8025c0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 14 1a 00 00       	call   801a80 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c4 25 80 00       	push   $0x8025c4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 fe 19 00 00       	call   801a80 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 cc 25 80 00       	push   $0x8025cc
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 e1 19 00 00       	call   801a80 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 da 25 80 00       	push   $0x8025da
  8000b8:	e8 a0 19 00 00       	call   801a5d <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 e4 25 80 00       	push   $0x8025e4
  80012b:	e8 16 06 00 00       	call   800746 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 09 26 80 00       	push   $0x802609
  80013f:	e8 19 19 00 00       	call   801a5d <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 0e 26 80 00       	push   $0x80260e
  80015e:	e8 fa 18 00 00       	call   801a5d <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 12 26 80 00       	push   $0x802612
  80017d:	e8 db 18 00 00       	call   801a5d <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 16 26 80 00       	push   $0x802616
  80019c:	e8 bc 18 00 00       	call   801a5d <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 1a 26 80 00       	push   $0x80261a
  8001bb:	e8 9d 18 00 00       	call   801a5d <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 10 1d 00 00       	call   801f45 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 97 16 00 00       	call   801bcf <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80054c:	01 c8                	add    %ecx,%eax
  80054e:	01 c0                	add    %eax,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	01 c0                	add    %eax,%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	89 c2                	mov    %eax,%edx
  800558:	c1 e2 05             	shl    $0x5,%edx
  80055b:	29 c2                	sub    %eax,%edx
  80055d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800564:	89 c2                	mov    %eax,%edx
  800566:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80056c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800571:	a1 20 30 80 00       	mov    0x803020,%eax
  800576:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80057c:	84 c0                	test   %al,%al
  80057e:	74 0f                	je     80058f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800580:	a1 20 30 80 00       	mov    0x803020,%eax
  800585:	05 40 3c 01 00       	add    $0x13c40,%eax
  80058a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800593:	7e 0a                	jle    80059f <libmain+0x72>
		binaryname = argv[0];
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 0c             	pushl  0xc(%ebp)
  8005a5:	ff 75 08             	pushl  0x8(%ebp)
  8005a8:	e8 8b fa ff ff       	call   800038 <_main>
  8005ad:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005b0:	e8 b5 17 00 00       	call   801d6a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005b5:	83 ec 0c             	sub    $0xc,%esp
  8005b8:	68 38 26 80 00       	push   $0x802638
  8005bd:	e8 84 01 00 00       	call   800746 <cprintf>
  8005c2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ca:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8005d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d5:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	52                   	push   %edx
  8005df:	50                   	push   %eax
  8005e0:	68 60 26 80 00       	push   $0x802660
  8005e5:	e8 5c 01 00 00       	call   800746 <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8005ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8005f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fd:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	68 88 26 80 00       	push   $0x802688
  80060d:	e8 34 01 00 00       	call   800746 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800615:	a1 20 30 80 00       	mov    0x803020,%eax
  80061a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	50                   	push   %eax
  800624:	68 c9 26 80 00       	push   $0x8026c9
  800629:	e8 18 01 00 00       	call   800746 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	68 38 26 80 00       	push   $0x802638
  800639:	e8 08 01 00 00       	call   800746 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800641:	e8 3e 17 00 00       	call   801d84 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800646:	e8 19 00 00 00       	call   800664 <exit>
}
  80064b:	90                   	nop
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	6a 00                	push   $0x0
  800659:	e8 3d 15 00 00       	call   801b9b <sys_env_destroy>
  80065e:	83 c4 10             	add    $0x10,%esp
}
  800661:	90                   	nop
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <exit>:

void
exit(void)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80066a:	e8 92 15 00 00       	call   801c01 <sys_env_exit>
}
  80066f:	90                   	nop
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	8d 48 01             	lea    0x1(%eax),%ecx
  800680:	8b 55 0c             	mov    0xc(%ebp),%edx
  800683:	89 0a                	mov    %ecx,(%edx)
  800685:	8b 55 08             	mov    0x8(%ebp),%edx
  800688:	88 d1                	mov    %dl,%cl
  80068a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069b:	75 2c                	jne    8006c9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80069d:	a0 24 30 80 00       	mov    0x803024,%al
  8006a2:	0f b6 c0             	movzbl %al,%eax
  8006a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a8:	8b 12                	mov    (%edx),%edx
  8006aa:	89 d1                	mov    %edx,%ecx
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	83 c2 08             	add    $0x8,%edx
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	50                   	push   %eax
  8006b6:	51                   	push   %ecx
  8006b7:	52                   	push   %edx
  8006b8:	e8 9c 14 00 00       	call   801b59 <sys_cputs>
  8006bd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	8b 40 04             	mov    0x4(%eax),%eax
  8006cf:	8d 50 01             	lea    0x1(%eax),%edx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d8:	90                   	nop
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006eb:	00 00 00 
	b.cnt = 0;
  8006ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	ff 75 08             	pushl  0x8(%ebp)
  8006fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800704:	50                   	push   %eax
  800705:	68 72 06 80 00       	push   $0x800672
  80070a:	e8 11 02 00 00       	call   800920 <vprintfmt>
  80070f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800712:	a0 24 30 80 00       	mov    0x803024,%al
  800717:	0f b6 c0             	movzbl %al,%eax
  80071a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800720:	83 ec 04             	sub    $0x4,%esp
  800723:	50                   	push   %eax
  800724:	52                   	push   %edx
  800725:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072b:	83 c0 08             	add    $0x8,%eax
  80072e:	50                   	push   %eax
  80072f:	e8 25 14 00 00       	call   801b59 <sys_cputs>
  800734:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800737:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80073e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <cprintf>:

int cprintf(const char *fmt, ...) {
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800753:	8d 45 0c             	lea    0xc(%ebp),%eax
  800756:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 f4             	pushl  -0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	e8 73 ff ff ff       	call   8006db <vcprintf>
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80076e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800771:	c9                   	leave  
  800772:	c3                   	ret    

00800773 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800779:	e8 ec 15 00 00       	call   801d6a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80077e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 f4             	pushl  -0xc(%ebp)
  80078d:	50                   	push   %eax
  80078e:	e8 48 ff ff ff       	call   8006db <vcprintf>
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800799:	e8 e6 15 00 00       	call   801d84 <sys_enable_interrupt>
	return cnt;
  80079e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a1:	c9                   	leave  
  8007a2:	c3                   	ret    

008007a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	53                   	push   %ebx
  8007a7:	83 ec 14             	sub    $0x14,%esp
  8007aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c1:	77 55                	ja     800818 <printnum+0x75>
  8007c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c6:	72 05                	jb     8007cd <printnum+0x2a>
  8007c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007cb:	77 4b                	ja     800818 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007cd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007db:	52                   	push   %edx
  8007dc:	50                   	push   %eax
  8007dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8007e3:	e8 74 1b 00 00       	call   80235c <__udivdi3>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	83 ec 04             	sub    $0x4,%esp
  8007ee:	ff 75 20             	pushl  0x20(%ebp)
  8007f1:	53                   	push   %ebx
  8007f2:	ff 75 18             	pushl  0x18(%ebp)
  8007f5:	52                   	push   %edx
  8007f6:	50                   	push   %eax
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	ff 75 08             	pushl  0x8(%ebp)
  8007fd:	e8 a1 ff ff ff       	call   8007a3 <printnum>
  800802:	83 c4 20             	add    $0x20,%esp
  800805:	eb 1a                	jmp    800821 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	ff 75 20             	pushl  0x20(%ebp)
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	ff d0                	call   *%eax
  800815:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800818:	ff 4d 1c             	decl   0x1c(%ebp)
  80081b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80081f:	7f e6                	jg     800807 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800821:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800824:	bb 00 00 00 00       	mov    $0x0,%ebx
  800829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80082f:	53                   	push   %ebx
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	e8 34 1c 00 00       	call   80246c <__umoddi3>
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	05 f4 28 80 00       	add    $0x8028f4,%eax
  800840:	8a 00                	mov    (%eax),%al
  800842:	0f be c0             	movsbl %al,%eax
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	50                   	push   %eax
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
}
  800854:	90                   	nop
  800855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800858:	c9                   	leave  
  800859:	c3                   	ret    

0080085a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80085d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800861:	7e 1c                	jle    80087f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 10                	mov    %edx,(%eax)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	83 e8 08             	sub    $0x8,%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	eb 40                	jmp    8008bf <getuint+0x65>
	else if (lflag)
  80087f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800883:	74 1e                	je     8008a3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	8d 50 04             	lea    0x4(%eax),%edx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	89 10                	mov    %edx,(%eax)
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a1:	eb 1c                	jmp    8008bf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	8d 50 04             	lea    0x4(%eax),%edx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	89 10                	mov    %edx,(%eax)
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	83 e8 04             	sub    $0x4,%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c8:	7e 1c                	jle    8008e6 <getint+0x25>
		return va_arg(*ap, long long);
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	8d 50 08             	lea    0x8(%eax),%edx
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	89 10                	mov    %edx,(%eax)
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	83 e8 08             	sub    $0x8,%eax
  8008df:	8b 50 04             	mov    0x4(%eax),%edx
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	eb 38                	jmp    80091e <getint+0x5d>
	else if (lflag)
  8008e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ea:	74 1a                	je     800906 <getint+0x45>
		return va_arg(*ap, long);
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	8d 50 04             	lea    0x4(%eax),%edx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	89 10                	mov    %edx,(%eax)
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	83 e8 04             	sub    $0x4,%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	99                   	cltd   
  800904:	eb 18                	jmp    80091e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	8d 50 04             	lea    0x4(%eax),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 10                	mov    %edx,(%eax)
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	99                   	cltd   
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	56                   	push   %esi
  800924:	53                   	push   %ebx
  800925:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800928:	eb 17                	jmp    800941 <vprintfmt+0x21>
			if (ch == '\0')
  80092a:	85 db                	test   %ebx,%ebx
  80092c:	0f 84 af 03 00 00    	je     800ce1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	ff d0                	call   *%eax
  80093e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800941:	8b 45 10             	mov    0x10(%ebp),%eax
  800944:	8d 50 01             	lea    0x1(%eax),%edx
  800947:	89 55 10             	mov    %edx,0x10(%ebp)
  80094a:	8a 00                	mov    (%eax),%al
  80094c:	0f b6 d8             	movzbl %al,%ebx
  80094f:	83 fb 25             	cmp    $0x25,%ebx
  800952:	75 d6                	jne    80092a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800954:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800958:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80095f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800966:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80096d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800974:	8b 45 10             	mov    0x10(%ebp),%eax
  800977:	8d 50 01             	lea    0x1(%eax),%edx
  80097a:	89 55 10             	mov    %edx,0x10(%ebp)
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f b6 d8             	movzbl %al,%ebx
  800982:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800985:	83 f8 55             	cmp    $0x55,%eax
  800988:	0f 87 2b 03 00 00    	ja     800cb9 <vprintfmt+0x399>
  80098e:	8b 04 85 18 29 80 00 	mov    0x802918(,%eax,4),%eax
  800995:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800997:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80099b:	eb d7                	jmp    800974 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80099d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a1:	eb d1                	jmp    800974 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ad:	89 d0                	mov    %edx,%eax
  8009af:	c1 e0 02             	shl    $0x2,%eax
  8009b2:	01 d0                	add    %edx,%eax
  8009b4:	01 c0                	add    %eax,%eax
  8009b6:	01 d8                	add    %ebx,%eax
  8009b8:	83 e8 30             	sub    $0x30,%eax
  8009bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009c6:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c9:	7e 3e                	jle    800a09 <vprintfmt+0xe9>
  8009cb:	83 fb 39             	cmp    $0x39,%ebx
  8009ce:	7f 39                	jg     800a09 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009d3:	eb d5                	jmp    8009aa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e9:	eb 1f                	jmp    800a0a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ef:	79 83                	jns    800974 <vprintfmt+0x54>
				width = 0;
  8009f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f8:	e9 77 ff ff ff       	jmp    800974 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a04:	e9 6b ff ff ff       	jmp    800974 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a09:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0e:	0f 89 60 ff ff ff    	jns    800974 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a1a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a21:	e9 4e ff ff ff       	jmp    800974 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a26:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a29:	e9 46 ff ff ff       	jmp    800974 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	83 e8 04             	sub    $0x4,%eax
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	50                   	push   %eax
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
			break;
  800a4e:	e9 89 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 c0 04             	add    $0x4,%eax
  800a59:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	83 e8 04             	sub    $0x4,%eax
  800a62:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a64:	85 db                	test   %ebx,%ebx
  800a66:	79 02                	jns    800a6a <vprintfmt+0x14a>
				err = -err;
  800a68:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a6a:	83 fb 64             	cmp    $0x64,%ebx
  800a6d:	7f 0b                	jg     800a7a <vprintfmt+0x15a>
  800a6f:	8b 34 9d 60 27 80 00 	mov    0x802760(,%ebx,4),%esi
  800a76:	85 f6                	test   %esi,%esi
  800a78:	75 19                	jne    800a93 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a7a:	53                   	push   %ebx
  800a7b:	68 05 29 80 00       	push   $0x802905
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 5e 02 00 00       	call   800ce9 <printfmt>
  800a8b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a8e:	e9 49 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a93:	56                   	push   %esi
  800a94:	68 0e 29 80 00       	push   $0x80290e
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	ff 75 08             	pushl  0x8(%ebp)
  800a9f:	e8 45 02 00 00       	call   800ce9 <printfmt>
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	e9 30 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 c0 04             	add    $0x4,%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 30                	mov    (%eax),%esi
  800abd:	85 f6                	test   %esi,%esi
  800abf:	75 05                	jne    800ac6 <vprintfmt+0x1a6>
				p = "(null)";
  800ac1:	be 11 29 80 00       	mov    $0x802911,%esi
			if (width > 0 && padc != '-')
  800ac6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aca:	7e 6d                	jle    800b39 <vprintfmt+0x219>
  800acc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad0:	74 67                	je     800b39 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	50                   	push   %eax
  800ad9:	56                   	push   %esi
  800ada:	e8 0c 03 00 00       	call   800deb <strnlen>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ae5:	eb 16                	jmp    800afd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ae7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	50                   	push   %eax
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800afa:	ff 4d e4             	decl   -0x1c(%ebp)
  800afd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b01:	7f e4                	jg     800ae7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b03:	eb 34                	jmp    800b39 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b09:	74 1c                	je     800b27 <vprintfmt+0x207>
  800b0b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b0e:	7e 05                	jle    800b15 <vprintfmt+0x1f5>
  800b10:	83 fb 7e             	cmp    $0x7e,%ebx
  800b13:	7e 12                	jle    800b27 <vprintfmt+0x207>
					putch('?', putdat);
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	6a 3f                	push   $0x3f
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	eb 0f                	jmp    800b36 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	53                   	push   %ebx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b36:	ff 4d e4             	decl   -0x1c(%ebp)
  800b39:	89 f0                	mov    %esi,%eax
  800b3b:	8d 70 01             	lea    0x1(%eax),%esi
  800b3e:	8a 00                	mov    (%eax),%al
  800b40:	0f be d8             	movsbl %al,%ebx
  800b43:	85 db                	test   %ebx,%ebx
  800b45:	74 24                	je     800b6b <vprintfmt+0x24b>
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	78 b8                	js     800b05 <vprintfmt+0x1e5>
  800b4d:	ff 4d e0             	decl   -0x20(%ebp)
  800b50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b54:	79 af                	jns    800b05 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b56:	eb 13                	jmp    800b6b <vprintfmt+0x24b>
				putch(' ', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 20                	push   $0x20
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b68:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6f:	7f e7                	jg     800b58 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b71:	e9 66 01 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b7f:	50                   	push   %eax
  800b80:	e8 3c fd ff ff       	call   8008c1 <getint>
  800b85:	83 c4 10             	add    $0x10,%esp
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b94:	85 d2                	test   %edx,%edx
  800b96:	79 23                	jns    800bbb <vprintfmt+0x29b>
				putch('-', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 2d                	push   $0x2d
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bae:	f7 d8                	neg    %eax
  800bb0:	83 d2 00             	adc    $0x0,%edx
  800bb3:	f7 da                	neg    %edx
  800bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bbb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc2:	e9 bc 00 00 00       	jmp    800c83 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcd:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd0:	50                   	push   %eax
  800bd1:	e8 84 fc ff ff       	call   80085a <getuint>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bdf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be6:	e9 98 00 00 00       	jmp    800c83 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	6a 58                	push   $0x58
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 0c             	pushl  0xc(%ebp)
  800c01:	6a 58                	push   $0x58
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
  800c08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 58                	push   $0x58
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
			break;
  800c1b:	e9 bc 00 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 30                	push   $0x30
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	6a 78                	push   $0x78
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 c0 04             	add    $0x4,%eax
  800c46:	89 45 14             	mov    %eax,0x14(%ebp)
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	83 e8 04             	sub    $0x4,%eax
  800c4f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c62:	eb 1f                	jmp    800c83 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c6d:	50                   	push   %eax
  800c6e:	e8 e7 fb ff ff       	call   80085a <getuint>
  800c73:	83 c4 10             	add    $0x10,%esp
  800c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c83:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8a:	83 ec 04             	sub    $0x4,%esp
  800c8d:	52                   	push   %edx
  800c8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c91:	50                   	push   %eax
  800c92:	ff 75 f4             	pushl  -0xc(%ebp)
  800c95:	ff 75 f0             	pushl  -0x10(%ebp)
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	e8 00 fb ff ff       	call   8007a3 <printnum>
  800ca3:	83 c4 20             	add    $0x20,%esp
			break;
  800ca6:	eb 34                	jmp    800cdc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	53                   	push   %ebx
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			break;
  800cb7:	eb 23                	jmp    800cdc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	6a 25                	push   $0x25
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc9:	ff 4d 10             	decl   0x10(%ebp)
  800ccc:	eb 03                	jmp    800cd1 <vprintfmt+0x3b1>
  800cce:	ff 4d 10             	decl   0x10(%ebp)
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	48                   	dec    %eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 25                	cmp    $0x25,%al
  800cd9:	75 f3                	jne    800cce <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cdb:	90                   	nop
		}
	}
  800cdc:	e9 47 fc ff ff       	jmp    800928 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cef:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf2:	83 c0 04             	add    $0x4,%eax
  800cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfe:	50                   	push   %eax
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	ff 75 08             	pushl  0x8(%ebp)
  800d05:	e8 16 fc ff ff       	call   800920 <vprintfmt>
  800d0a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d0d:	90                   	nop
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8b 40 08             	mov    0x8(%eax),%eax
  800d19:	8d 50 01             	lea    0x1(%eax),%edx
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8b 10                	mov    (%eax),%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8b 40 04             	mov    0x4(%eax),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	73 12                	jae    800d43 <sprintputch+0x33>
		*b->buf++ = ch;
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 48 01             	lea    0x1(%eax),%ecx
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	89 0a                	mov    %ecx,(%edx)
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	88 10                	mov    %dl,(%eax)
}
  800d43:	90                   	nop
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	01 d0                	add    %edx,%eax
  800d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d6b:	74 06                	je     800d73 <vsnprintf+0x2d>
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	7f 07                	jg     800d7a <vsnprintf+0x34>
		return -E_INVAL;
  800d73:	b8 03 00 00 00       	mov    $0x3,%eax
  800d78:	eb 20                	jmp    800d9a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d7a:	ff 75 14             	pushl  0x14(%ebp)
  800d7d:	ff 75 10             	pushl  0x10(%ebp)
  800d80:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d83:	50                   	push   %eax
  800d84:	68 10 0d 80 00       	push   $0x800d10
  800d89:	e8 92 fb ff ff       	call   800920 <vprintfmt>
  800d8e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da2:	8d 45 10             	lea    0x10(%ebp),%eax
  800da5:	83 c0 04             	add    $0x4,%eax
  800da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	ff 75 f4             	pushl  -0xc(%ebp)
  800db1:	50                   	push   %eax
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	ff 75 08             	pushl  0x8(%ebp)
  800db8:	e8 89 ff ff ff       	call   800d46 <vsnprintf>
  800dbd:	83 c4 10             	add    $0x10,%esp
  800dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd5:	eb 06                	jmp    800ddd <strlen+0x15>
		n++;
  800dd7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dda:	ff 45 08             	incl   0x8(%ebp)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	75 f1                	jne    800dd7 <strlen+0xf>
		n++;
	return n;
  800de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df8:	eb 09                	jmp    800e03 <strnlen+0x18>
		n++;
  800dfa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfd:	ff 45 08             	incl   0x8(%ebp)
  800e00:	ff 4d 0c             	decl   0xc(%ebp)
  800e03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e07:	74 09                	je     800e12 <strnlen+0x27>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	84 c0                	test   %al,%al
  800e10:	75 e8                	jne    800dfa <strnlen+0xf>
		n++;
	return n;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e23:	90                   	nop
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e36:	8a 12                	mov    (%edx),%dl
  800e38:	88 10                	mov    %dl,(%eax)
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	84 c0                	test   %al,%al
  800e3e:	75 e4                	jne    800e24 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 1f                	jmp    800e79 <strncpy+0x34>
		*dst++ = *src;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 08             	mov    %edx,0x8(%ebp)
  800e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e66:	8a 12                	mov    (%edx),%dl
  800e68:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	74 03                	je     800e76 <strncpy+0x31>
			src++;
  800e73:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e76:	ff 45 fc             	incl   -0x4(%ebp)
  800e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e7f:	72 d9                	jb     800e5a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 30                	je     800ec8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e98:	eb 16                	jmp    800eb0 <strlcpy+0x2a>
			*dst++ = *src++;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb0:	ff 4d 10             	decl   0x10(%ebp)
  800eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb7:	74 09                	je     800ec2 <strlcpy+0x3c>
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	84 c0                	test   %al,%al
  800ec0:	75 d8                	jne    800e9a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed7:	eb 06                	jmp    800edf <strcmp+0xb>
		p++, q++;
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	84 c0                	test   %al,%al
  800ee6:	74 0e                	je     800ef6 <strcmp+0x22>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 10                	mov    (%eax),%dl
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	38 c2                	cmp    %al,%dl
  800ef4:	74 e3                	je     800ed9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	0f b6 d0             	movzbl %al,%edx
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f b6 c0             	movzbl %al,%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
}
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f0f:	eb 09                	jmp    800f1a <strncmp+0xe>
		n--, p++, q++;
  800f11:	ff 4d 10             	decl   0x10(%ebp)
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 17                	je     800f37 <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	74 0e                	je     800f37 <strncmp+0x2b>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 10                	mov    (%eax),%dl
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	38 c2                	cmp    %al,%dl
  800f35:	74 da                	je     800f11 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3b:	75 07                	jne    800f44 <strncmp+0x38>
		return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f42:	eb 14                	jmp    800f58 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	0f b6 d0             	movzbl %al,%edx
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f b6 c0             	movzbl %al,%eax
  800f54:	29 c2                	sub    %eax,%edx
  800f56:	89 d0                	mov    %edx,%eax
}
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f66:	eb 12                	jmp    800f7a <strchr+0x20>
		if (*s == c)
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f70:	75 05                	jne    800f77 <strchr+0x1d>
			return (char *) s;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	eb 11                	jmp    800f88 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f77:	ff 45 08             	incl   0x8(%ebp)
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	75 e5                	jne    800f68 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 04             	sub    $0x4,%esp
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f96:	eb 0d                	jmp    800fa5 <strfind+0x1b>
		if (*s == c)
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa0:	74 0e                	je     800fb0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa2:	ff 45 08             	incl   0x8(%ebp)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 ea                	jne    800f98 <strfind+0xe>
  800fae:	eb 01                	jmp    800fb1 <strfind+0x27>
		if (*s == c)
			break;
  800fb0:	90                   	nop
	return (char *) s;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fc8:	eb 0e                	jmp    800fd8 <memset+0x22>
		*p++ = c;
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	8d 50 01             	lea    0x1(%eax),%edx
  800fd0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fd8:	ff 4d f8             	decl   -0x8(%ebp)
  800fdb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fdf:	79 e9                	jns    800fca <memset+0x14>
		*p++ = c;

	return v;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ff8:	eb 16                	jmp    801010 <memcpy+0x2a>
		*d++ = *s++;
  800ffa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffd:	8d 50 01             	lea    0x1(%eax),%edx
  801000:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801003:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801006:	8d 4a 01             	lea    0x1(%edx),%ecx
  801009:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100c:	8a 12                	mov    (%edx),%dl
  80100e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	8d 50 ff             	lea    -0x1(%eax),%edx
  801016:	89 55 10             	mov    %edx,0x10(%ebp)
  801019:	85 c0                	test   %eax,%eax
  80101b:	75 dd                	jne    800ffa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103a:	73 50                	jae    80108c <memmove+0x6a>
  80103c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	01 d0                	add    %edx,%eax
  801044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801047:	76 43                	jbe    80108c <memmove+0x6a>
		s += n;
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80104f:	8b 45 10             	mov    0x10(%ebp),%eax
  801052:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801055:	eb 10                	jmp    801067 <memmove+0x45>
			*--d = *--s;
  801057:	ff 4d f8             	decl   -0x8(%ebp)
  80105a:	ff 4d fc             	decl   -0x4(%ebp)
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	8a 10                	mov    (%eax),%dl
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 e3                	jne    801057 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801074:	eb 23                	jmp    801099 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	8d 50 01             	lea    0x1(%eax),%edx
  80107c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801082:	8d 4a 01             	lea    0x1(%edx),%ecx
  801085:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801088:	8a 12                	mov    (%edx),%dl
  80108a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801092:	89 55 10             	mov    %edx,0x10(%ebp)
  801095:	85 c0                	test   %eax,%eax
  801097:	75 dd                	jne    801076 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b0:	eb 2a                	jmp    8010dc <memcmp+0x3e>
		if (*s1 != *s2)
  8010b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b5:	8a 10                	mov    (%eax),%dl
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	38 c2                	cmp    %al,%dl
  8010be:	74 16                	je     8010d6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	0f b6 d0             	movzbl %al,%edx
  8010c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	0f b6 c0             	movzbl %al,%eax
  8010d0:	29 c2                	sub    %eax,%edx
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	eb 18                	jmp    8010ee <memcmp+0x50>
		s1++, s2++;
  8010d6:	ff 45 fc             	incl   -0x4(%ebp)
  8010d9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	75 c9                	jne    8010b2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801101:	eb 15                	jmp    801118 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	0f b6 d0             	movzbl %al,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	0f b6 c0             	movzbl %al,%eax
  801111:	39 c2                	cmp    %eax,%edx
  801113:	74 0d                	je     801122 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801115:	ff 45 08             	incl   0x8(%ebp)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80111e:	72 e3                	jb     801103 <memfind+0x13>
  801120:	eb 01                	jmp    801123 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801122:	90                   	nop
	return (void *) s;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80112e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801135:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80113c:	eb 03                	jmp    801141 <strtol+0x19>
		s++;
  80113e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 20                	cmp    $0x20,%al
  801148:	74 f4                	je     80113e <strtol+0x16>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 09                	cmp    $0x9,%al
  801151:	74 eb                	je     80113e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 2b                	cmp    $0x2b,%al
  80115a:	75 05                	jne    801161 <strtol+0x39>
		s++;
  80115c:	ff 45 08             	incl   0x8(%ebp)
  80115f:	eb 13                	jmp    801174 <strtol+0x4c>
	else if (*s == '-')
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 2d                	cmp    $0x2d,%al
  801168:	75 0a                	jne    801174 <strtol+0x4c>
		s++, neg = 1;
  80116a:	ff 45 08             	incl   0x8(%ebp)
  80116d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	74 06                	je     801180 <strtol+0x58>
  80117a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80117e:	75 20                	jne    8011a0 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 30                	cmp    $0x30,%al
  801187:	75 17                	jne    8011a0 <strtol+0x78>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	40                   	inc    %eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 78                	cmp    $0x78,%al
  801191:	75 0d                	jne    8011a0 <strtol+0x78>
		s += 2, base = 16;
  801193:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801197:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80119e:	eb 28                	jmp    8011c8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a4:	75 15                	jne    8011bb <strtol+0x93>
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	3c 30                	cmp    $0x30,%al
  8011ad:	75 0c                	jne    8011bb <strtol+0x93>
		s++, base = 8;
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b9:	eb 0d                	jmp    8011c8 <strtol+0xa0>
	else if (base == 0)
  8011bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bf:	75 07                	jne    8011c8 <strtol+0xa0>
		base = 10;
  8011c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 2f                	cmp    $0x2f,%al
  8011cf:	7e 19                	jle    8011ea <strtol+0xc2>
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	3c 39                	cmp    $0x39,%al
  8011d8:	7f 10                	jg     8011ea <strtol+0xc2>
			dig = *s - '0';
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	0f be c0             	movsbl %al,%eax
  8011e2:	83 e8 30             	sub    $0x30,%eax
  8011e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011e8:	eb 42                	jmp    80122c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 60                	cmp    $0x60,%al
  8011f1:	7e 19                	jle    80120c <strtol+0xe4>
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 7a                	cmp    $0x7a,%al
  8011fa:	7f 10                	jg     80120c <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	0f be c0             	movsbl %al,%eax
  801204:	83 e8 57             	sub    $0x57,%eax
  801207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80120a:	eb 20                	jmp    80122c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 40                	cmp    $0x40,%al
  801213:	7e 39                	jle    80124e <strtol+0x126>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 5a                	cmp    $0x5a,%al
  80121c:	7f 30                	jg     80124e <strtol+0x126>
			dig = *s - 'A' + 10;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 37             	sub    $0x37,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801232:	7d 19                	jge    80124d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801234:	ff 45 08             	incl   0x8(%ebp)
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80123e:	89 c2                	mov    %eax,%edx
  801240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801243:	01 d0                	add    %edx,%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801248:	e9 7b ff ff ff       	jmp    8011c8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80124d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80124e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801252:	74 08                	je     80125c <strtol+0x134>
		*endptr = (char *) s;
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8b 55 08             	mov    0x8(%ebp),%edx
  80125a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80125c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801260:	74 07                	je     801269 <strtol+0x141>
  801262:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801265:	f7 d8                	neg    %eax
  801267:	eb 03                	jmp    80126c <strtol+0x144>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <ltostr>:

void
ltostr(long value, char *str)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801282:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801286:	79 13                	jns    80129b <ltostr+0x2d>
	{
		neg = 1;
  801288:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801295:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801298:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012a3:	99                   	cltd   
  8012a4:	f7 f9                	idiv   %ecx
  8012a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ac:	8d 50 01             	lea    0x1(%eax),%edx
  8012af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012bc:	83 c2 30             	add    $0x30,%edx
  8012bf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c9:	f7 e9                	imul   %ecx
  8012cb:	c1 fa 02             	sar    $0x2,%edx
  8012ce:	89 c8                	mov    %ecx,%eax
  8012d0:	c1 f8 1f             	sar    $0x1f,%eax
  8012d3:	29 c2                	sub    %eax,%edx
  8012d5:	89 d0                	mov    %edx,%eax
  8012d7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e2:	f7 e9                	imul   %ecx
  8012e4:	c1 fa 02             	sar    $0x2,%edx
  8012e7:	89 c8                	mov    %ecx,%eax
  8012e9:	c1 f8 1f             	sar    $0x1f,%eax
  8012ec:	29 c2                	sub    %eax,%edx
  8012ee:	89 d0                	mov    %edx,%eax
  8012f0:	c1 e0 02             	shl    $0x2,%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	01 c0                	add    %eax,%eax
  8012f7:	29 c1                	sub    %eax,%ecx
  8012f9:	89 ca                	mov    %ecx,%edx
  8012fb:	85 d2                	test   %edx,%edx
  8012fd:	75 9c                	jne    80129b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	48                   	dec    %eax
  80130a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80130d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801311:	74 3d                	je     801350 <ltostr+0xe2>
		start = 1 ;
  801313:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80131a:	eb 34                	jmp    801350 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80131c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 c8                	add    %ecx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80133d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8a 45 eb             	mov    -0x15(%ebp),%al
  801348:	88 02                	mov    %al,(%edx)
		start++ ;
  80134a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80134d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c c4                	jl     80131c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801358:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 54 fa ff ff       	call   800dc8 <strlen>
  801374:	83 c4 04             	add    $0x4,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80137a:	ff 75 0c             	pushl  0xc(%ebp)
  80137d:	e8 46 fa ff ff       	call   800dc8 <strlen>
  801382:	83 c4 04             	add    $0x4,%esp
  801385:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801396:	eb 17                	jmp    8013af <strcconcat+0x49>
		final[s] = str1[s] ;
  801398:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139b:	8b 45 10             	mov    0x10(%ebp),%eax
  80139e:	01 c2                	add    %eax,%edx
  8013a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	01 c8                	add    %ecx,%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ac:	ff 45 fc             	incl   -0x4(%ebp)
  8013af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013b5:	7c e1                	jl     801398 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013c5:	eb 1f                	jmp    8013e6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d5:	01 c2                	add    %eax,%edx
  8013d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 c8                	add    %ecx,%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013e3:	ff 45 f8             	incl   -0x8(%ebp)
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ec:	7c d9                	jl     8013c7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f9:	90                   	nop
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801408:	8b 45 14             	mov    0x14(%ebp),%eax
  80140b:	8b 00                	mov    (%eax),%eax
  80140d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801414:	8b 45 10             	mov    0x10(%ebp),%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141f:	eb 0c                	jmp    80142d <strsplit+0x31>
			*string++ = 0;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8d 50 01             	lea    0x1(%eax),%edx
  801427:	89 55 08             	mov    %edx,0x8(%ebp)
  80142a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	84 c0                	test   %al,%al
  801434:	74 18                	je     80144e <strsplit+0x52>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f be c0             	movsbl %al,%eax
  80143e:	50                   	push   %eax
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	e8 13 fb ff ff       	call   800f5a <strchr>
  801447:	83 c4 08             	add    $0x8,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	75 d3                	jne    801421 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	74 5a                	je     8014b1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	8b 00                	mov    (%eax),%eax
  80145c:	83 f8 0f             	cmp    $0xf,%eax
  80145f:	75 07                	jne    801468 <strsplit+0x6c>
		{
			return 0;
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	eb 66                	jmp    8014ce <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 48 01             	lea    0x1(%eax),%ecx
  801470:	8b 55 14             	mov    0x14(%ebp),%edx
  801473:	89 0a                	mov    %ecx,(%edx)
  801475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147c:	8b 45 10             	mov    0x10(%ebp),%eax
  80147f:	01 c2                	add    %eax,%edx
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801486:	eb 03                	jmp    80148b <strsplit+0x8f>
			string++;
  801488:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 8b                	je     80141f <strsplit+0x23>
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be c0             	movsbl %al,%eax
  80149c:	50                   	push   %eax
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	e8 b5 fa ff ff       	call   800f5a <strchr>
  8014a5:	83 c4 08             	add    $0x8,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	74 dc                	je     801488 <strsplit+0x8c>
			string++;
	}
  8014ac:	e9 6e ff ff ff       	jmp    80141f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8014d6:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8014dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8014e3:	01 d0                	add    %edx,%eax
  8014e5:	48                   	dec    %eax
  8014e6:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8014e9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8014ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f1:	f7 75 ac             	divl   -0x54(%ebp)
  8014f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8014f7:	29 d0                	sub    %edx,%eax
  8014f9:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8014fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80150a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801511:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801518:	eb 3f                	jmp    801559 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  80151a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80151d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	50                   	push   %eax
  801528:	ff 75 e8             	pushl  -0x18(%ebp)
  80152b:	68 70 2a 80 00       	push   $0x802a70
  801530:	e8 11 f2 ff ff       	call   800746 <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80153b:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	50                   	push   %eax
  801546:	ff 75 e8             	pushl  -0x18(%ebp)
  801549:	68 85 2a 80 00       	push   $0x802a85
  80154e:	e8 f3 f1 ff ff       	call   800746 <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801556:	ff 45 e8             	incl   -0x18(%ebp)
  801559:	a1 28 30 80 00       	mov    0x803028,%eax
  80155e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801561:	7c b7                	jl     80151a <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801563:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80156a:	e9 35 01 00 00       	jmp    8016a4 <malloc+0x1d4>
		int flag0=1;
  80156f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801579:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80157c:	eb 5e                	jmp    8015dc <malloc+0x10c>
			for(int k=0;k<count;k++){
  80157e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801585:	eb 35                	jmp    8015bc <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801587:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80158a:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801591:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801594:	39 c2                	cmp    %eax,%edx
  801596:	77 21                	ja     8015b9 <malloc+0xe9>
  801598:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80159b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a5:	39 c2                	cmp    %eax,%edx
  8015a7:	76 10                	jbe    8015b9 <malloc+0xe9>
					ni=PAGE_SIZE;
  8015a9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  8015b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8015b7:	eb 0d                	jmp    8015c6 <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8015b9:	ff 45 d8             	incl   -0x28(%ebp)
  8015bc:	a1 28 30 80 00       	mov    0x803028,%eax
  8015c1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8015c4:	7c c1                	jl     801587 <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8015c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ca:	74 09                	je     8015d5 <malloc+0x105>
				flag0=0;
  8015cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8015d3:	eb 16                	jmp    8015eb <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8015d5:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8015dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	01 c2                	add    %eax,%edx
  8015e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015e7:	39 c2                	cmp    %eax,%edx
  8015e9:	77 93                	ja     80157e <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8015eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015ef:	0f 84 a2 00 00 00    	je     801697 <malloc+0x1c7>

			int f=1;
  8015f5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8015fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015ff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801602:	89 c8                	mov    %ecx,%eax
  801604:	01 c0                	add    %eax,%eax
  801606:	01 c8                	add    %ecx,%eax
  801608:	c1 e0 02             	shl    $0x2,%eax
  80160b:	05 20 31 80 00       	add    $0x803120,%eax
  801610:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80161b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161e:	89 d0                	mov    %edx,%eax
  801620:	01 c0                	add    %eax,%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	c1 e0 02             	shl    $0x2,%eax
  801627:	05 24 31 80 00       	add    $0x803124,%eax
  80162c:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80162e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801631:	89 d0                	mov    %edx,%eax
  801633:	01 c0                	add    %eax,%eax
  801635:	01 d0                	add    %edx,%eax
  801637:	c1 e0 02             	shl    $0x2,%eax
  80163a:	05 28 31 80 00       	add    $0x803128,%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801645:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801648:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80164f:	eb 36                	jmp    801687 <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  801651:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	01 c2                	add    %eax,%edx
  801659:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80165c:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801663:	39 c2                	cmp    %eax,%edx
  801665:	73 1d                	jae    801684 <malloc+0x1b4>
					ni=arr_add[l].end-i;
  801667:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80166a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801674:	29 c2                	sub    %eax,%edx
  801676:	89 d0                	mov    %edx,%eax
  801678:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  80167b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801682:	eb 0d                	jmp    801691 <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801684:	ff 45 d0             	incl   -0x30(%ebp)
  801687:	a1 28 30 80 00       	mov    0x803028,%eax
  80168c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80168f:	7c c0                	jl     801651 <malloc+0x181>
					break;

				}
			}

			if(f){
  801691:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801695:	75 1d                	jne    8016b4 <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  801697:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a1:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8016a4:	a1 04 30 80 00       	mov    0x803004,%eax
  8016a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ac:	0f 8c bd fe ff ff    	jl     80156f <malloc+0x9f>
  8016b2:	eb 01                	jmp    8016b5 <malloc+0x1e5>

				}
			}

			if(f){
				break;
  8016b4:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8016b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016b9:	75 7a                	jne    801735 <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8016bb:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	48                   	dec    %eax
  8016c7:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8016cc:	7c 0a                	jl     8016d8 <malloc+0x208>
			return NULL;
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	e9 a4 02 00 00       	jmp    80197c <malloc+0x4ac>
		else{
			uint32 s=base_add;
  8016d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8016dd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8016e0:	a1 28 30 80 00       	mov    0x803028,%eax
  8016e5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8016e8:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	ff 75 a4             	pushl  -0x5c(%ebp)
  8016f8:	e8 04 06 00 00       	call   801d01 <sys_allocateMem>
  8016fd:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801700:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	01 d0                	add    %edx,%eax
  80170b:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801710:	a1 28 30 80 00       	mov    0x803028,%eax
  801715:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80171b:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801722:	a1 28 30 80 00       	mov    0x803028,%eax
  801727:	40                   	inc    %eax
  801728:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  80172d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801730:	e9 47 02 00 00       	jmp    80197c <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  801735:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80173c:	e9 ac 00 00 00       	jmp    8017ed <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801741:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801744:	89 d0                	mov    %edx,%eax
  801746:	01 c0                	add    %eax,%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	c1 e0 02             	shl    $0x2,%eax
  80174d:	05 24 31 80 00       	add    $0x803124,%eax
  801752:	8b 00                	mov    (%eax),%eax
  801754:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801757:	eb 7e                	jmp    8017d7 <malloc+0x307>
			int flag=0;
  801759:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801760:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801767:	eb 57                	jmp    8017c0 <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801769:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80176c:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801773:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801776:	39 c2                	cmp    %eax,%edx
  801778:	77 1a                	ja     801794 <malloc+0x2c4>
  80177a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80177d:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801784:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801787:	39 c2                	cmp    %eax,%edx
  801789:	76 09                	jbe    801794 <malloc+0x2c4>
								flag=1;
  80178b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801792:	eb 36                	jmp    8017ca <malloc+0x2fa>
			arr[i].space++;
  801794:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801797:	89 d0                	mov    %edx,%eax
  801799:	01 c0                	add    %eax,%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	c1 e0 02             	shl    $0x2,%eax
  8017a0:	05 28 31 80 00       	add    $0x803128,%eax
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8017aa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8017ad:	89 d0                	mov    %edx,%eax
  8017af:	01 c0                	add    %eax,%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	c1 e0 02             	shl    $0x2,%eax
  8017b6:	05 28 31 80 00       	add    $0x803128,%eax
  8017bb:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8017bd:	ff 45 c0             	incl   -0x40(%ebp)
  8017c0:	a1 28 30 80 00       	mov    0x803028,%eax
  8017c5:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8017c8:	7c 9f                	jl     801769 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8017ca:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8017ce:	75 19                	jne    8017e9 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8017d0:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8017d7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8017da:	a1 04 30 80 00       	mov    0x803004,%eax
  8017df:	39 c2                	cmp    %eax,%edx
  8017e1:	0f 82 72 ff ff ff    	jb     801759 <malloc+0x289>
  8017e7:	eb 01                	jmp    8017ea <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8017e9:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8017ea:	ff 45 cc             	incl   -0x34(%ebp)
  8017ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017f3:	0f 8c 48 ff ff ff    	jl     801741 <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  8017f9:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801800:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801807:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80180e:	eb 37                	jmp    801847 <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801810:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801813:	89 d0                	mov    %edx,%eax
  801815:	01 c0                	add    %eax,%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	c1 e0 02             	shl    $0x2,%eax
  80181c:	05 28 31 80 00       	add    $0x803128,%eax
  801821:	8b 00                	mov    (%eax),%eax
  801823:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801826:	7d 1c                	jge    801844 <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801828:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80182b:	89 d0                	mov    %edx,%eax
  80182d:	01 c0                	add    %eax,%eax
  80182f:	01 d0                	add    %edx,%eax
  801831:	c1 e0 02             	shl    $0x2,%eax
  801834:	05 28 31 80 00       	add    $0x803128,%eax
  801839:	8b 00                	mov    (%eax),%eax
  80183b:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80183e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801841:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801844:	ff 45 b4             	incl   -0x4c(%ebp)
  801847:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80184a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184d:	7c c1                	jl     801810 <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80184f:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801855:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801858:	89 c8                	mov    %ecx,%eax
  80185a:	01 c0                	add    %eax,%eax
  80185c:	01 c8                	add    %ecx,%eax
  80185e:	c1 e0 02             	shl    $0x2,%eax
  801861:	05 20 31 80 00       	add    $0x803120,%eax
  801866:	8b 00                	mov    (%eax),%eax
  801868:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80186f:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801875:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801878:	89 c8                	mov    %ecx,%eax
  80187a:	01 c0                	add    %eax,%eax
  80187c:	01 c8                	add    %ecx,%eax
  80187e:	c1 e0 02             	shl    $0x2,%eax
  801881:	05 24 31 80 00       	add    $0x803124,%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  80188f:	a1 28 30 80 00       	mov    0x803028,%eax
  801894:	40                   	inc    %eax
  801895:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  80189a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80189d:	89 d0                	mov    %edx,%eax
  80189f:	01 c0                	add    %eax,%eax
  8018a1:	01 d0                	add    %edx,%eax
  8018a3:	c1 e0 02             	shl    $0x2,%eax
  8018a6:	05 20 31 80 00       	add    $0x803120,%eax
  8018ab:	8b 00                	mov    (%eax),%eax
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	ff 75 08             	pushl  0x8(%ebp)
  8018b3:	50                   	push   %eax
  8018b4:	e8 48 04 00 00       	call   801d01 <sys_allocateMem>
  8018b9:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8018bc:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8018c3:	eb 78                	jmp    80193d <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8018c5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8018c8:	89 d0                	mov    %edx,%eax
  8018ca:	01 c0                	add    %eax,%eax
  8018cc:	01 d0                	add    %edx,%eax
  8018ce:	c1 e0 02             	shl    $0x2,%eax
  8018d1:	05 20 31 80 00       	add    $0x803120,%eax
  8018d6:	8b 00                	mov    (%eax),%eax
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	50                   	push   %eax
  8018dc:	ff 75 b0             	pushl  -0x50(%ebp)
  8018df:	68 70 2a 80 00       	push   $0x802a70
  8018e4:	e8 5d ee ff ff       	call   800746 <cprintf>
  8018e9:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8018ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8018ef:	89 d0                	mov    %edx,%eax
  8018f1:	01 c0                	add    %eax,%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c1 e0 02             	shl    $0x2,%eax
  8018f8:	05 24 31 80 00       	add    $0x803124,%eax
  8018fd:	8b 00                	mov    (%eax),%eax
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	50                   	push   %eax
  801903:	ff 75 b0             	pushl  -0x50(%ebp)
  801906:	68 85 2a 80 00       	push   $0x802a85
  80190b:	e8 36 ee ff ff       	call   800746 <cprintf>
  801910:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801913:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801916:	89 d0                	mov    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	01 d0                	add    %edx,%eax
  80191c:	c1 e0 02             	shl    $0x2,%eax
  80191f:	05 28 31 80 00       	add    $0x803128,%eax
  801924:	8b 00                	mov    (%eax),%eax
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	50                   	push   %eax
  80192a:	ff 75 b0             	pushl  -0x50(%ebp)
  80192d:	68 98 2a 80 00       	push   $0x802a98
  801932:	e8 0f ee ff ff       	call   800746 <cprintf>
  801937:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80193a:	ff 45 b0             	incl   -0x50(%ebp)
  80193d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801940:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801943:	7c 80                	jl     8018c5 <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801945:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801948:	89 d0                	mov    %edx,%eax
  80194a:	01 c0                	add    %eax,%eax
  80194c:	01 d0                	add    %edx,%eax
  80194e:	c1 e0 02             	shl    $0x2,%eax
  801951:	05 20 31 80 00       	add    $0x803120,%eax
  801956:	8b 00                	mov    (%eax),%eax
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	50                   	push   %eax
  80195c:	68 ac 2a 80 00       	push   $0x802aac
  801961:	e8 e0 ed ff ff       	call   800746 <cprintf>
  801966:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801969:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80196c:	89 d0                	mov    %edx,%eax
  80196e:	01 c0                	add    %eax,%eax
  801970:	01 d0                	add    %edx,%eax
  801972:	c1 e0 02             	shl    $0x2,%eax
  801975:	05 20 31 80 00       	add    $0x803120,%eax
  80197a:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80198a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801991:	eb 4b                	jmp    8019de <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801996:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80199d:	89 c2                	mov    %eax,%edx
  80199f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a2:	39 c2                	cmp    %eax,%edx
  8019a4:	7f 35                	jg     8019db <free+0x5d>
  8019a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a9:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019b5:	39 c2                	cmp    %eax,%edx
  8019b7:	7e 22                	jle    8019db <free+0x5d>
				start=arr_add[i].start;
  8019b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bc:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8019c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c9:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8019d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8019d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8019d9:	eb 0d                	jmp    8019e8 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8019db:	ff 45 ec             	incl   -0x14(%ebp)
  8019de:	a1 28 30 80 00       	mov    0x803028,%eax
  8019e3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8019e6:	7c ab                	jl     801993 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8019e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019eb:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f5:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019fc:	29 c2                	sub    %eax,%edx
  8019fe:	89 d0                	mov    %edx,%eax
  801a00:	83 ec 08             	sub    $0x8,%esp
  801a03:	50                   	push   %eax
  801a04:	ff 75 f4             	pushl  -0xc(%ebp)
  801a07:	e8 d9 02 00 00       	call   801ce5 <sys_freeMem>
  801a0c:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a15:	eb 2d                	jmp    801a44 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1a:	40                   	inc    %eax
  801a1b:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a25:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a2f:	40                   	inc    %eax
  801a30:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a3a:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801a41:	ff 45 e8             	incl   -0x18(%ebp)
  801a44:	a1 28 30 80 00       	mov    0x803028,%eax
  801a49:	48                   	dec    %eax
  801a4a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a4d:	7f c8                	jg     801a17 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801a4f:	a1 28 30 80 00       	mov    0x803028,%eax
  801a54:	48                   	dec    %eax
  801a55:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801a5a:	90                   	nop
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 18             	sub    $0x18,%esp
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 c8 2a 80 00       	push   $0x802ac8
  801a71:	68 18 01 00 00       	push   $0x118
  801a76:	68 eb 2a 80 00       	push   $0x802aeb
  801a7b:	e8 0b 07 00 00       	call   80218b <_panic>

00801a80 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	68 c8 2a 80 00       	push   $0x802ac8
  801a8e:	68 1e 01 00 00       	push   $0x11e
  801a93:	68 eb 2a 80 00       	push   $0x802aeb
  801a98:	e8 ee 06 00 00       	call   80218b <_panic>

00801a9d <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	68 c8 2a 80 00       	push   $0x802ac8
  801aab:	68 24 01 00 00       	push   $0x124
  801ab0:	68 eb 2a 80 00       	push   $0x802aeb
  801ab5:	e8 d1 06 00 00       	call   80218b <_panic>

00801aba <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	68 c8 2a 80 00       	push   $0x802ac8
  801ac8:	68 29 01 00 00       	push   $0x129
  801acd:	68 eb 2a 80 00       	push   $0x802aeb
  801ad2:	e8 b4 06 00 00       	call   80218b <_panic>

00801ad7 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	68 c8 2a 80 00       	push   $0x802ac8
  801ae5:	68 2f 01 00 00       	push   $0x12f
  801aea:	68 eb 2a 80 00       	push   $0x802aeb
  801aef:	e8 97 06 00 00       	call   80218b <_panic>

00801af4 <shrink>:
}
void shrink(uint32 newSize)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	68 c8 2a 80 00       	push   $0x802ac8
  801b02:	68 33 01 00 00       	push   $0x133
  801b07:	68 eb 2a 80 00       	push   $0x802aeb
  801b0c:	e8 7a 06 00 00       	call   80218b <_panic>

00801b11 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	68 c8 2a 80 00       	push   $0x802ac8
  801b1f:	68 38 01 00 00       	push   $0x138
  801b24:	68 eb 2a 80 00       	push   $0x802aeb
  801b29:	e8 5d 06 00 00       	call   80218b <_panic>

00801b2e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	57                   	push   %edi
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b43:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b46:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b49:	cd 30                	int    $0x30
  801b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5f                   	pop    %edi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    

00801b59 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b65:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	6a 00                	push   $0x0
  801b77:	e8 b2 ff ff ff       	call   801b2e <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	90                   	nop
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 01                	push   $0x1
  801b91:	e8 98 ff ff ff       	call   801b2e <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	50                   	push   %eax
  801baa:	6a 05                	push   $0x5
  801bac:	e8 7d ff ff ff       	call   801b2e <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 02                	push   $0x2
  801bc5:	e8 64 ff ff ff       	call   801b2e <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 03                	push   $0x3
  801bde:	e8 4b ff ff ff       	call   801b2e <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 04                	push   $0x4
  801bf7:	e8 32 ff ff ff       	call   801b2e <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_env_exit>:


void sys_env_exit(void)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 06                	push   $0x6
  801c10:	e8 19 ff ff ff       	call   801b2e <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	90                   	nop
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	52                   	push   %edx
  801c2b:	50                   	push   %eax
  801c2c:	6a 07                	push   $0x7
  801c2e:	e8 fb fe ff ff       	call   801b2e <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	56                   	push   %esi
  801c3c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c3d:	8b 75 18             	mov    0x18(%ebp),%esi
  801c40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	56                   	push   %esi
  801c4d:	53                   	push   %ebx
  801c4e:	51                   	push   %ecx
  801c4f:	52                   	push   %edx
  801c50:	50                   	push   %eax
  801c51:	6a 08                	push   $0x8
  801c53:	e8 d6 fe ff ff       	call   801b2e <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5e                   	pop    %esi
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    

00801c62 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	6a 09                	push   $0x9
  801c75:	e8 b4 fe ff ff       	call   801b2e <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	6a 0a                	push   $0xa
  801c90:	e8 99 fe ff ff       	call   801b2e <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 0b                	push   $0xb
  801ca9:	e8 80 fe ff ff       	call   801b2e <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 0c                	push   $0xc
  801cc2:	e8 67 fe ff ff       	call   801b2e <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 0d                	push   $0xd
  801cdb:	e8 4e fe ff ff       	call   801b2e <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	6a 11                	push   $0x11
  801cf6:	e8 33 fe ff ff       	call   801b2e <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	ff 75 0c             	pushl  0xc(%ebp)
  801d0d:	ff 75 08             	pushl  0x8(%ebp)
  801d10:	6a 12                	push   $0x12
  801d12:	e8 17 fe ff ff       	call   801b2e <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 0e                	push   $0xe
  801d2c:	e8 fd fd ff ff       	call   801b2e <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 0f                	push   $0xf
  801d46:	e8 e3 fd ff ff       	call   801b2e <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 10                	push   $0x10
  801d5f:	e8 ca fd ff ff       	call   801b2e <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	90                   	nop
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 14                	push   $0x14
  801d79:	e8 b0 fd ff ff       	call   801b2e <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	90                   	nop
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 15                	push   $0x15
  801d93:	e8 96 fd ff ff       	call   801b2e <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	90                   	nop
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_cputc>:


void
sys_cputc(const char c)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 04             	sub    $0x4,%esp
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801daa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	50                   	push   %eax
  801db7:	6a 16                	push   $0x16
  801db9:	e8 70 fd ff ff       	call   801b2e <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	90                   	nop
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 17                	push   $0x17
  801dd3:	e8 56 fd ff ff       	call   801b2e <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	90                   	nop
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	50                   	push   %eax
  801dee:	6a 18                	push   $0x18
  801df0:	e8 39 fd ff ff       	call   801b2e <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	52                   	push   %edx
  801e0a:	50                   	push   %eax
  801e0b:	6a 1b                	push   $0x1b
  801e0d:	e8 1c fd ff ff       	call   801b2e <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 19                	push   $0x19
  801e2a:	e8 ff fc ff ff       	call   801b2e <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	90                   	nop
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	6a 1a                	push   $0x1a
  801e48:	e8 e1 fc ff ff       	call   801b2e <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	90                   	nop
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e62:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	6a 00                	push   $0x0
  801e6b:	51                   	push   %ecx
  801e6c:	52                   	push   %edx
  801e6d:	ff 75 0c             	pushl  0xc(%ebp)
  801e70:	50                   	push   %eax
  801e71:	6a 1c                	push   $0x1c
  801e73:	e8 b6 fc ff ff       	call   801b2e <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	52                   	push   %edx
  801e8d:	50                   	push   %eax
  801e8e:	6a 1d                	push   $0x1d
  801e90:	e8 99 fc ff ff       	call   801b2e <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	51                   	push   %ecx
  801eab:	52                   	push   %edx
  801eac:	50                   	push   %eax
  801ead:	6a 1e                	push   $0x1e
  801eaf:	e8 7a fc ff ff       	call   801b2e <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	6a 1f                	push   $0x1f
  801ecc:	e8 5d fc ff ff       	call   801b2e <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 20                	push   $0x20
  801ee5:	e8 44 fc ff ff       	call   801b2e <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	ff 75 14             	pushl  0x14(%ebp)
  801efa:	ff 75 10             	pushl  0x10(%ebp)
  801efd:	ff 75 0c             	pushl  0xc(%ebp)
  801f00:	50                   	push   %eax
  801f01:	6a 21                	push   $0x21
  801f03:	e8 26 fc ff ff       	call   801b2e <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	50                   	push   %eax
  801f1c:	6a 22                	push   $0x22
  801f1e:	e8 0b fc ff ff       	call   801b2e <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	90                   	nop
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	50                   	push   %eax
  801f38:	6a 23                	push   $0x23
  801f3a:	e8 ef fb ff ff       	call   801b2e <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	90                   	nop
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f4b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f4e:	8d 50 04             	lea    0x4(%eax),%edx
  801f51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	52                   	push   %edx
  801f5b:	50                   	push   %eax
  801f5c:	6a 24                	push   $0x24
  801f5e:	e8 cb fb ff ff       	call   801b2e <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
	return result;
  801f66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f6f:	89 01                	mov    %eax,(%ecx)
  801f71:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	c9                   	leave  
  801f78:	c2 04 00             	ret    $0x4

00801f7b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 10             	pushl  0x10(%ebp)
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	ff 75 08             	pushl  0x8(%ebp)
  801f8b:	6a 13                	push   $0x13
  801f8d:	e8 9c fb ff ff       	call   801b2e <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
	return ;
  801f95:	90                   	nop
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 25                	push   $0x25
  801fa7:	e8 82 fb ff ff       	call   801b2e <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 04             	sub    $0x4,%esp
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fbd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	50                   	push   %eax
  801fca:	6a 26                	push   $0x26
  801fcc:	e8 5d fb ff ff       	call   801b2e <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd4:	90                   	nop
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <rsttst>:
void rsttst()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 28                	push   $0x28
  801fe6:	e8 43 fb ff ff       	call   801b2e <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fee:	90                   	nop
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ffd:	8b 55 18             	mov    0x18(%ebp),%edx
  802000:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	ff 75 10             	pushl  0x10(%ebp)
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	6a 27                	push   $0x27
  802011:	e8 18 fb ff ff       	call   801b2e <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
	return ;
  802019:	90                   	nop
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <chktst>:
void chktst(uint32 n)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	ff 75 08             	pushl  0x8(%ebp)
  80202a:	6a 29                	push   $0x29
  80202c:	e8 fd fa ff ff       	call   801b2e <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
	return ;
  802034:	90                   	nop
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <inctst>:

void inctst()
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 2a                	push   $0x2a
  802046:	e8 e3 fa ff ff       	call   801b2e <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
	return ;
  80204e:	90                   	nop
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <gettst>:
uint32 gettst()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 2b                	push   $0x2b
  802060:	e8 c9 fa ff ff       	call   801b2e <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 2c                	push   $0x2c
  80207c:	e8 ad fa ff ff       	call   801b2e <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
  802084:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802087:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80208b:	75 07                	jne    802094 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80208d:	b8 01 00 00 00       	mov    $0x1,%eax
  802092:	eb 05                	jmp    802099 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 2c                	push   $0x2c
  8020ad:	e8 7c fa ff ff       	call   801b2e <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
  8020b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020b8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020bc:	75 07                	jne    8020c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	eb 05                	jmp    8020ca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 2c                	push   $0x2c
  8020de:	e8 4b fa ff ff       	call   801b2e <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
  8020e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020e9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020ed:	75 07                	jne    8020f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f4:	eb 05                	jmp    8020fb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 2c                	push   $0x2c
  80210f:	e8 1a fa ff ff       	call   801b2e <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
  802117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80211a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80211e:	75 07                	jne    802127 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802120:	b8 01 00 00 00       	mov    $0x1,%eax
  802125:	eb 05                	jmp    80212c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	ff 75 08             	pushl  0x8(%ebp)
  80213c:	6a 2d                	push   $0x2d
  80213e:	e8 eb f9 ff ff       	call   801b2e <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
	return ;
  802146:	90                   	nop
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80214d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802150:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802153:	8b 55 0c             	mov    0xc(%ebp),%edx
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	6a 00                	push   $0x0
  80215b:	53                   	push   %ebx
  80215c:	51                   	push   %ecx
  80215d:	52                   	push   %edx
  80215e:	50                   	push   %eax
  80215f:	6a 2e                	push   $0x2e
  802161:	e8 c8 f9 ff ff       	call   801b2e <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802171:	8b 55 0c             	mov    0xc(%ebp),%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	52                   	push   %edx
  80217e:	50                   	push   %eax
  80217f:	6a 2f                	push   $0x2f
  802181:	e8 a8 f9 ff ff       	call   801b2e <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802191:	8d 45 10             	lea    0x10(%ebp),%eax
  802194:	83 c0 04             	add    $0x4,%eax
  802197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80219a:	a1 60 3e 83 00       	mov    0x833e60,%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	74 16                	je     8021b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8021a3:	a1 60 3e 83 00       	mov    0x833e60,%eax
  8021a8:	83 ec 08             	sub    $0x8,%esp
  8021ab:	50                   	push   %eax
  8021ac:	68 f8 2a 80 00       	push   $0x802af8
  8021b1:	e8 90 e5 ff ff       	call   800746 <cprintf>
  8021b6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8021b9:	a1 00 30 80 00       	mov    0x803000,%eax
  8021be:	ff 75 0c             	pushl  0xc(%ebp)
  8021c1:	ff 75 08             	pushl  0x8(%ebp)
  8021c4:	50                   	push   %eax
  8021c5:	68 fd 2a 80 00       	push   $0x802afd
  8021ca:	e8 77 e5 ff ff       	call   800746 <cprintf>
  8021cf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8021d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d5:	83 ec 08             	sub    $0x8,%esp
  8021d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021db:	50                   	push   %eax
  8021dc:	e8 fa e4 ff ff       	call   8006db <vcprintf>
  8021e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8021e4:	83 ec 08             	sub    $0x8,%esp
  8021e7:	6a 00                	push   $0x0
  8021e9:	68 19 2b 80 00       	push   $0x802b19
  8021ee:	e8 e8 e4 ff ff       	call   8006db <vcprintf>
  8021f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8021f6:	e8 69 e4 ff ff       	call   800664 <exit>

	// should not return here
	while (1) ;
  8021fb:	eb fe                	jmp    8021fb <_panic+0x70>

008021fd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802203:	a1 20 30 80 00       	mov    0x803020,%eax
  802208:	8b 50 74             	mov    0x74(%eax),%edx
  80220b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	74 14                	je     802226 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	68 1c 2b 80 00       	push   $0x802b1c
  80221a:	6a 26                	push   $0x26
  80221c:	68 68 2b 80 00       	push   $0x802b68
  802221:	e8 65 ff ff ff       	call   80218b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802226:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80222d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802234:	e9 b6 00 00 00       	jmp    8022ef <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  802239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	01 d0                	add    %edx,%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	75 08                	jne    802256 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80224e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802251:	e9 96 00 00 00       	jmp    8022ec <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802256:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80225d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802264:	eb 5d                	jmp    8022c3 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802266:	a1 20 30 80 00       	mov    0x803020,%eax
  80226b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802271:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802274:	c1 e2 04             	shl    $0x4,%edx
  802277:	01 d0                	add    %edx,%eax
  802279:	8a 40 04             	mov    0x4(%eax),%al
  80227c:	84 c0                	test   %al,%al
  80227e:	75 40                	jne    8022c0 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802280:	a1 20 30 80 00       	mov    0x803020,%eax
  802285:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80228b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80228e:	c1 e2 04             	shl    $0x4,%edx
  802291:	01 d0                	add    %edx,%eax
  802293:	8b 00                	mov    (%eax),%eax
  802295:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802298:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80229b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8022a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	01 c8                	add    %ecx,%eax
  8022b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8022b3:	39 c2                	cmp    %eax,%edx
  8022b5:	75 09                	jne    8022c0 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8022b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8022be:	eb 12                	jmp    8022d2 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022c0:	ff 45 e8             	incl   -0x18(%ebp)
  8022c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8022c8:	8b 50 74             	mov    0x74(%eax),%edx
  8022cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ce:	39 c2                	cmp    %eax,%edx
  8022d0:	77 94                	ja     802266 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8022d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022d6:	75 14                	jne    8022ec <CheckWSWithoutLastIndex+0xef>
			panic(
  8022d8:	83 ec 04             	sub    $0x4,%esp
  8022db:	68 74 2b 80 00       	push   $0x802b74
  8022e0:	6a 3a                	push   $0x3a
  8022e2:	68 68 2b 80 00       	push   $0x802b68
  8022e7:	e8 9f fe ff ff       	call   80218b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8022ec:	ff 45 f0             	incl   -0x10(%ebp)
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022f5:	0f 8c 3e ff ff ff    	jl     802239 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8022fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802302:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802309:	eb 20                	jmp    80232b <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80230b:	a1 20 30 80 00       	mov    0x803020,%eax
  802310:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802316:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802319:	c1 e2 04             	shl    $0x4,%edx
  80231c:	01 d0                	add    %edx,%eax
  80231e:	8a 40 04             	mov    0x4(%eax),%al
  802321:	3c 01                	cmp    $0x1,%al
  802323:	75 03                	jne    802328 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802325:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802328:	ff 45 e0             	incl   -0x20(%ebp)
  80232b:	a1 20 30 80 00       	mov    0x803020,%eax
  802330:	8b 50 74             	mov    0x74(%eax),%edx
  802333:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802336:	39 c2                	cmp    %eax,%edx
  802338:	77 d1                	ja     80230b <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802340:	74 14                	je     802356 <CheckWSWithoutLastIndex+0x159>
		panic(
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	68 c8 2b 80 00       	push   $0x802bc8
  80234a:	6a 44                	push   $0x44
  80234c:	68 68 2b 80 00       	push   $0x802b68
  802351:	e8 35 fe ff ff       	call   80218b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802356:	90                   	nop
  802357:	c9                   	leave  
  802358:	c3                   	ret    
  802359:	66 90                	xchg   %ax,%ax
  80235b:	90                   	nop

0080235c <__udivdi3>:
  80235c:	55                   	push   %ebp
  80235d:	57                   	push   %edi
  80235e:	56                   	push   %esi
  80235f:	53                   	push   %ebx
  802360:	83 ec 1c             	sub    $0x1c,%esp
  802363:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802367:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80236b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80236f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802373:	89 ca                	mov    %ecx,%edx
  802375:	89 f8                	mov    %edi,%eax
  802377:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80237b:	85 f6                	test   %esi,%esi
  80237d:	75 2d                	jne    8023ac <__udivdi3+0x50>
  80237f:	39 cf                	cmp    %ecx,%edi
  802381:	77 65                	ja     8023e8 <__udivdi3+0x8c>
  802383:	89 fd                	mov    %edi,%ebp
  802385:	85 ff                	test   %edi,%edi
  802387:	75 0b                	jne    802394 <__udivdi3+0x38>
  802389:	b8 01 00 00 00       	mov    $0x1,%eax
  80238e:	31 d2                	xor    %edx,%edx
  802390:	f7 f7                	div    %edi
  802392:	89 c5                	mov    %eax,%ebp
  802394:	31 d2                	xor    %edx,%edx
  802396:	89 c8                	mov    %ecx,%eax
  802398:	f7 f5                	div    %ebp
  80239a:	89 c1                	mov    %eax,%ecx
  80239c:	89 d8                	mov    %ebx,%eax
  80239e:	f7 f5                	div    %ebp
  8023a0:	89 cf                	mov    %ecx,%edi
  8023a2:	89 fa                	mov    %edi,%edx
  8023a4:	83 c4 1c             	add    $0x1c,%esp
  8023a7:	5b                   	pop    %ebx
  8023a8:	5e                   	pop    %esi
  8023a9:	5f                   	pop    %edi
  8023aa:	5d                   	pop    %ebp
  8023ab:	c3                   	ret    
  8023ac:	39 ce                	cmp    %ecx,%esi
  8023ae:	77 28                	ja     8023d8 <__udivdi3+0x7c>
  8023b0:	0f bd fe             	bsr    %esi,%edi
  8023b3:	83 f7 1f             	xor    $0x1f,%edi
  8023b6:	75 40                	jne    8023f8 <__udivdi3+0x9c>
  8023b8:	39 ce                	cmp    %ecx,%esi
  8023ba:	72 0a                	jb     8023c6 <__udivdi3+0x6a>
  8023bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023c0:	0f 87 9e 00 00 00    	ja     802464 <__udivdi3+0x108>
  8023c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cb:	89 fa                	mov    %edi,%edx
  8023cd:	83 c4 1c             	add    $0x1c,%esp
  8023d0:	5b                   	pop    %ebx
  8023d1:	5e                   	pop    %esi
  8023d2:	5f                   	pop    %edi
  8023d3:	5d                   	pop    %ebp
  8023d4:	c3                   	ret    
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	89 fa                	mov    %edi,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	66 90                	xchg   %ax,%ax
  8023e8:	89 d8                	mov    %ebx,%eax
  8023ea:	f7 f7                	div    %edi
  8023ec:	31 ff                	xor    %edi,%edi
  8023ee:	89 fa                	mov    %edi,%edx
  8023f0:	83 c4 1c             	add    $0x1c,%esp
  8023f3:	5b                   	pop    %ebx
  8023f4:	5e                   	pop    %esi
  8023f5:	5f                   	pop    %edi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    
  8023f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023fd:	89 eb                	mov    %ebp,%ebx
  8023ff:	29 fb                	sub    %edi,%ebx
  802401:	89 f9                	mov    %edi,%ecx
  802403:	d3 e6                	shl    %cl,%esi
  802405:	89 c5                	mov    %eax,%ebp
  802407:	88 d9                	mov    %bl,%cl
  802409:	d3 ed                	shr    %cl,%ebp
  80240b:	89 e9                	mov    %ebp,%ecx
  80240d:	09 f1                	or     %esi,%ecx
  80240f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802413:	89 f9                	mov    %edi,%ecx
  802415:	d3 e0                	shl    %cl,%eax
  802417:	89 c5                	mov    %eax,%ebp
  802419:	89 d6                	mov    %edx,%esi
  80241b:	88 d9                	mov    %bl,%cl
  80241d:	d3 ee                	shr    %cl,%esi
  80241f:	89 f9                	mov    %edi,%ecx
  802421:	d3 e2                	shl    %cl,%edx
  802423:	8b 44 24 08          	mov    0x8(%esp),%eax
  802427:	88 d9                	mov    %bl,%cl
  802429:	d3 e8                	shr    %cl,%eax
  80242b:	09 c2                	or     %eax,%edx
  80242d:	89 d0                	mov    %edx,%eax
  80242f:	89 f2                	mov    %esi,%edx
  802431:	f7 74 24 0c          	divl   0xc(%esp)
  802435:	89 d6                	mov    %edx,%esi
  802437:	89 c3                	mov    %eax,%ebx
  802439:	f7 e5                	mul    %ebp
  80243b:	39 d6                	cmp    %edx,%esi
  80243d:	72 19                	jb     802458 <__udivdi3+0xfc>
  80243f:	74 0b                	je     80244c <__udivdi3+0xf0>
  802441:	89 d8                	mov    %ebx,%eax
  802443:	31 ff                	xor    %edi,%edi
  802445:	e9 58 ff ff ff       	jmp    8023a2 <__udivdi3+0x46>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802450:	89 f9                	mov    %edi,%ecx
  802452:	d3 e2                	shl    %cl,%edx
  802454:	39 c2                	cmp    %eax,%edx
  802456:	73 e9                	jae    802441 <__udivdi3+0xe5>
  802458:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80245b:	31 ff                	xor    %edi,%edi
  80245d:	e9 40 ff ff ff       	jmp    8023a2 <__udivdi3+0x46>
  802462:	66 90                	xchg   %ax,%ax
  802464:	31 c0                	xor    %eax,%eax
  802466:	e9 37 ff ff ff       	jmp    8023a2 <__udivdi3+0x46>
  80246b:	90                   	nop

0080246c <__umoddi3>:
  80246c:	55                   	push   %ebp
  80246d:	57                   	push   %edi
  80246e:	56                   	push   %esi
  80246f:	53                   	push   %ebx
  802470:	83 ec 1c             	sub    $0x1c,%esp
  802473:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802477:	8b 74 24 34          	mov    0x34(%esp),%esi
  80247b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80247f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802483:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802487:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80248b:	89 f3                	mov    %esi,%ebx
  80248d:	89 fa                	mov    %edi,%edx
  80248f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802493:	89 34 24             	mov    %esi,(%esp)
  802496:	85 c0                	test   %eax,%eax
  802498:	75 1a                	jne    8024b4 <__umoddi3+0x48>
  80249a:	39 f7                	cmp    %esi,%edi
  80249c:	0f 86 a2 00 00 00    	jbe    802544 <__umoddi3+0xd8>
  8024a2:	89 c8                	mov    %ecx,%eax
  8024a4:	89 f2                	mov    %esi,%edx
  8024a6:	f7 f7                	div    %edi
  8024a8:	89 d0                	mov    %edx,%eax
  8024aa:	31 d2                	xor    %edx,%edx
  8024ac:	83 c4 1c             	add    $0x1c,%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5e                   	pop    %esi
  8024b1:	5f                   	pop    %edi
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    
  8024b4:	39 f0                	cmp    %esi,%eax
  8024b6:	0f 87 ac 00 00 00    	ja     802568 <__umoddi3+0xfc>
  8024bc:	0f bd e8             	bsr    %eax,%ebp
  8024bf:	83 f5 1f             	xor    $0x1f,%ebp
  8024c2:	0f 84 ac 00 00 00    	je     802574 <__umoddi3+0x108>
  8024c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8024cd:	29 ef                	sub    %ebp,%edi
  8024cf:	89 fe                	mov    %edi,%esi
  8024d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024d5:	89 e9                	mov    %ebp,%ecx
  8024d7:	d3 e0                	shl    %cl,%eax
  8024d9:	89 d7                	mov    %edx,%edi
  8024db:	89 f1                	mov    %esi,%ecx
  8024dd:	d3 ef                	shr    %cl,%edi
  8024df:	09 c7                	or     %eax,%edi
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e2                	shl    %cl,%edx
  8024e5:	89 14 24             	mov    %edx,(%esp)
  8024e8:	89 d8                	mov    %ebx,%eax
  8024ea:	d3 e0                	shl    %cl,%eax
  8024ec:	89 c2                	mov    %eax,%edx
  8024ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024f2:	d3 e0                	shl    %cl,%eax
  8024f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024fc:	89 f1                	mov    %esi,%ecx
  8024fe:	d3 e8                	shr    %cl,%eax
  802500:	09 d0                	or     %edx,%eax
  802502:	d3 eb                	shr    %cl,%ebx
  802504:	89 da                	mov    %ebx,%edx
  802506:	f7 f7                	div    %edi
  802508:	89 d3                	mov    %edx,%ebx
  80250a:	f7 24 24             	mull   (%esp)
  80250d:	89 c6                	mov    %eax,%esi
  80250f:	89 d1                	mov    %edx,%ecx
  802511:	39 d3                	cmp    %edx,%ebx
  802513:	0f 82 87 00 00 00    	jb     8025a0 <__umoddi3+0x134>
  802519:	0f 84 91 00 00 00    	je     8025b0 <__umoddi3+0x144>
  80251f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802523:	29 f2                	sub    %esi,%edx
  802525:	19 cb                	sbb    %ecx,%ebx
  802527:	89 d8                	mov    %ebx,%eax
  802529:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80252d:	d3 e0                	shl    %cl,%eax
  80252f:	89 e9                	mov    %ebp,%ecx
  802531:	d3 ea                	shr    %cl,%edx
  802533:	09 d0                	or     %edx,%eax
  802535:	89 e9                	mov    %ebp,%ecx
  802537:	d3 eb                	shr    %cl,%ebx
  802539:	89 da                	mov    %ebx,%edx
  80253b:	83 c4 1c             	add    $0x1c,%esp
  80253e:	5b                   	pop    %ebx
  80253f:	5e                   	pop    %esi
  802540:	5f                   	pop    %edi
  802541:	5d                   	pop    %ebp
  802542:	c3                   	ret    
  802543:	90                   	nop
  802544:	89 fd                	mov    %edi,%ebp
  802546:	85 ff                	test   %edi,%edi
  802548:	75 0b                	jne    802555 <__umoddi3+0xe9>
  80254a:	b8 01 00 00 00       	mov    $0x1,%eax
  80254f:	31 d2                	xor    %edx,%edx
  802551:	f7 f7                	div    %edi
  802553:	89 c5                	mov    %eax,%ebp
  802555:	89 f0                	mov    %esi,%eax
  802557:	31 d2                	xor    %edx,%edx
  802559:	f7 f5                	div    %ebp
  80255b:	89 c8                	mov    %ecx,%eax
  80255d:	f7 f5                	div    %ebp
  80255f:	89 d0                	mov    %edx,%eax
  802561:	e9 44 ff ff ff       	jmp    8024aa <__umoddi3+0x3e>
  802566:	66 90                	xchg   %ax,%ax
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	89 f2                	mov    %esi,%edx
  80256c:	83 c4 1c             	add    $0x1c,%esp
  80256f:	5b                   	pop    %ebx
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    
  802574:	3b 04 24             	cmp    (%esp),%eax
  802577:	72 06                	jb     80257f <__umoddi3+0x113>
  802579:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80257d:	77 0f                	ja     80258e <__umoddi3+0x122>
  80257f:	89 f2                	mov    %esi,%edx
  802581:	29 f9                	sub    %edi,%ecx
  802583:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802587:	89 14 24             	mov    %edx,(%esp)
  80258a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80258e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802592:	8b 14 24             	mov    (%esp),%edx
  802595:	83 c4 1c             	add    $0x1c,%esp
  802598:	5b                   	pop    %ebx
  802599:	5e                   	pop    %esi
  80259a:	5f                   	pop    %edi
  80259b:	5d                   	pop    %ebp
  80259c:	c3                   	ret    
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	2b 04 24             	sub    (%esp),%eax
  8025a3:	19 fa                	sbb    %edi,%edx
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	89 c6                	mov    %eax,%esi
  8025a9:	e9 71 ff ff ff       	jmp    80251f <__umoddi3+0xb3>
  8025ae:	66 90                	xchg   %ax,%ax
  8025b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025b4:	72 ea                	jb     8025a0 <__umoddi3+0x134>
  8025b6:	89 d9                	mov    %ebx,%ecx
  8025b8:	e9 62 ff ff ff       	jmp    80251f <__umoddi3+0xb3>
