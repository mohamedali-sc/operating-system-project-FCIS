
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 37 04 00 00       	call   80046d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
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
  800087:	68 c0 25 80 00       	push   $0x8025c0
  80008c:	6a 12                	push   $0x12
  80008e:	68 dc 25 80 00       	push   $0x8025dc
  800093:	e8 1a 05 00 00       	call   8005b2 <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 fc 25 80 00       	push   $0x8025fc
  8000a0:	e8 af 07 00 00       	call   800854 <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 30 26 80 00       	push   $0x802630
  8000b0:	e8 9f 07 00 00       	call   800854 <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 8c 26 80 00       	push   $0x80268c
  8000c0:	e8 8f 07 00 00       	call   800854 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000c8:	e8 f7 1b 00 00       	call   801cc4 <sys_getenvid>
  8000cd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 c0 26 80 00       	push   $0x8026c0
  8000d8:	e8 77 07 00 00       	call   800854 <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8000f2:	8b 40 74             	mov    0x74(%eax),%eax
  8000f5:	6a 32                	push   $0x32
  8000f7:	52                   	push   %edx
  8000f8:	50                   	push   %eax
  8000f9:	68 01 27 80 00       	push   $0x802701
  8000fe:	e8 fa 1e 00 00       	call   801ffd <sys_create_env>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800114:	89 c2                	mov    %eax,%edx
  800116:	a1 20 40 80 00       	mov    0x804020,%eax
  80011b:	8b 40 74             	mov    0x74(%eax),%eax
  80011e:	6a 32                	push   $0x32
  800120:	52                   	push   %edx
  800121:	50                   	push   %eax
  800122:	68 01 27 80 00       	push   $0x802701
  800127:	e8 d1 1e 00 00       	call   801ffd <sys_create_env>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800132:	e8 71 1c 00 00       	call   801da8 <sys_calculate_free_frames>
  800137:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	6a 01                	push   $0x1
  80013f:	68 00 10 00 00       	push   $0x1000
  800144:	68 0f 27 80 00       	push   $0x80270f
  800149:	e8 1d 1a 00 00       	call   801b6b <smalloc>
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	68 14 27 80 00       	push   $0x802714
  80015c:	e8 f3 06 00 00       	call   800854 <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800164:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80016b:	74 14                	je     800181 <_main+0x149>
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	68 34 27 80 00       	push   $0x802734
  800175:	6a 26                	push   $0x26
  800177:	68 dc 25 80 00       	push   $0x8025dc
  80017c:	e8 31 04 00 00       	call   8005b2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800181:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800184:	e8 1f 1c 00 00       	call   801da8 <sys_calculate_free_frames>
  800189:	29 c3                	sub    %eax,%ebx
  80018b:	89 d8                	mov    %ebx,%eax
  80018d:	83 f8 04             	cmp    $0x4,%eax
  800190:	74 14                	je     8001a6 <_main+0x16e>
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	68 a0 27 80 00       	push   $0x8027a0
  80019a:	6a 27                	push   $0x27
  80019c:	68 dc 25 80 00       	push   $0x8025dc
  8001a1:	e8 0c 04 00 00       	call   8005b2 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001a6:	e8 3a 1f 00 00       	call   8020e5 <rsttst>

		sys_run_env(envIdSlave1);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b1:	e8 65 1e 00 00       	call   80201b <sys_run_env>
  8001b6:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001bf:	e8 57 1e 00 00       	call   80201b <sys_run_env>
  8001c4:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	68 1e 28 80 00       	push   $0x80281e
  8001cf:	e8 80 06 00 00       	call   800854 <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 b8 0b 00 00       	push   $0xbb8
  8001df:	e8 b5 20 00 00       	call   802299 <env_sleep>
  8001e4:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001e7:	e8 73 1f 00 00       	call   80215f <gettst>
  8001ec:	83 f8 02             	cmp    $0x2,%eax
  8001ef:	74 14                	je     800205 <_main+0x1cd>
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	68 35 28 80 00       	push   $0x802835
  8001f9:	6a 33                	push   $0x33
  8001fb:	68 dc 25 80 00       	push   $0x8025dc
  800200:	e8 ad 03 00 00       	call   8005b2 <_panic>

		sfree(x);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	ff 75 dc             	pushl  -0x24(%ebp)
  80020b:	e8 9b 19 00 00       	call   801bab <sfree>
  800210:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	68 44 28 80 00       	push   $0x802844
  80021b:	e8 34 06 00 00       	call   800854 <cprintf>
  800220:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800223:	e8 80 1b 00 00       	call   801da8 <sys_calculate_free_frames>
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022d:	29 c2                	sub    %eax,%edx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  800234:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 64 28 80 00       	push   $0x802864
  800242:	6a 38                	push   $0x38
  800244:	68 dc 25 80 00       	push   $0x8025dc
  800249:	e8 64 03 00 00       	call   8005b2 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	68 94 28 80 00       	push   $0x802894
  800256:	e8 f9 05 00 00       	call   800854 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	68 b8 28 80 00       	push   $0x8028b8
  800266:	e8 e9 05 00 00       	call   800854 <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80026e:	a1 20 40 80 00       	mov    0x804020,%eax
  800273:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800279:	89 c2                	mov    %eax,%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 40 74             	mov    0x74(%eax),%eax
  800283:	6a 32                	push   $0x32
  800285:	52                   	push   %edx
  800286:	50                   	push   %eax
  800287:	68 e8 28 80 00       	push   $0x8028e8
  80028c:	e8 6c 1d 00 00       	call   801ffd <sys_create_env>
  800291:	83 c4 10             	add    $0x10,%esp
  800294:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  800297:	a1 20 40 80 00       	mov    0x804020,%eax
  80029c:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8002a2:	89 c2                	mov    %eax,%edx
  8002a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a9:	8b 40 74             	mov    0x74(%eax),%eax
  8002ac:	6a 32                	push   $0x32
  8002ae:	52                   	push   %edx
  8002af:	50                   	push   %eax
  8002b0:	68 f8 28 80 00       	push   $0x8028f8
  8002b5:	e8 43 1d 00 00       	call   801ffd <sys_create_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c0:	83 ec 04             	sub    $0x4,%esp
  8002c3:	6a 01                	push   $0x1
  8002c5:	68 00 10 00 00       	push   $0x1000
  8002ca:	68 08 29 80 00       	push   $0x802908
  8002cf:	e8 97 18 00 00       	call   801b6b <smalloc>
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	68 0c 29 80 00       	push   $0x80290c
  8002e2:	e8 6d 05 00 00       	call   800854 <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	6a 01                	push   $0x1
  8002ef:	68 00 10 00 00       	push   $0x1000
  8002f4:	68 0f 27 80 00       	push   $0x80270f
  8002f9:	e8 6d 18 00 00       	call   801b6b <smalloc>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 14 27 80 00       	push   $0x802714
  80030c:	e8 43 05 00 00       	call   800854 <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

		rsttst();
  800314:	e8 cc 1d 00 00       	call   8020e5 <rsttst>

		sys_run_env(envIdSlaveB1);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031f:	e8 f7 1c 00 00       	call   80201b <sys_run_env>
  800324:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	ff 75 d0             	pushl  -0x30(%ebp)
  80032d:	e8 e9 1c 00 00       	call   80201b <sys_run_env>
  800332:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	68 a0 0f 00 00       	push   $0xfa0
  80033d:	e8 57 1f 00 00       	call   802299 <env_sleep>
  800342:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  800345:	e8 5e 1a 00 00       	call   801da8 <sys_calculate_free_frames>
  80034a:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	ff 75 cc             	pushl  -0x34(%ebp)
  800353:	e8 53 18 00 00       	call   801bab <sfree>
  800358:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80035b:	83 ec 0c             	sub    $0xc,%esp
  80035e:	68 2c 29 80 00       	push   $0x80292c
  800363:	e8 ec 04 00 00       	call   800854 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80036b:	83 ec 0c             	sub    $0xc,%esp
  80036e:	ff 75 c8             	pushl  -0x38(%ebp)
  800371:	e8 35 18 00 00       	call   801bab <sfree>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 42 29 80 00       	push   $0x802942
  800381:	e8 ce 04 00 00       	call   800854 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  800389:	e8 1a 1a 00 00       	call   801da8 <sys_calculate_free_frames>
  80038e:	89 c2                	mov    %eax,%edx
  800390:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800393:	29 c2                	sub    %eax,%edx
  800395:	89 d0                	mov    %edx,%eax
  800397:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  80039a:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  80039e:	74 14                	je     8003b4 <_main+0x37c>
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	68 58 29 80 00       	push   $0x802958
  8003a8:	6a 59                	push   $0x59
  8003aa:	68 dc 25 80 00       	push   $0x8025dc
  8003af:	e8 fe 01 00 00       	call   8005b2 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003b4:	e8 8c 1d 00 00       	call   802145 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	6a 01                	push   $0x1
  8003be:	6a 04                	push   $0x4
  8003c0:	68 fd 29 80 00       	push   $0x8029fd
  8003c5:	e8 a1 17 00 00       	call   801b6b <smalloc>
  8003ca:	83 c4 10             	add    $0x10,%esp
  8003cd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003d9:	e8 18 19 00 00       	call   801cf6 <sys_getparentenvid>
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	0f 8e 81 00 00 00    	jle    800467 <_main+0x42f>
			while(*finish_children != 1);
  8003e6:	90                   	nop
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	83 f8 01             	cmp    $0x1,%eax
  8003ef:	75 f6                	jne    8003e7 <_main+0x3af>
			cprintf("done\n");
  8003f1:	83 ec 0c             	sub    $0xc,%esp
  8003f4:	68 0d 2a 80 00       	push   $0x802a0d
  8003f9:	e8 56 04 00 00       	call   800854 <cprintf>
  8003fe:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlave1);
  800401:	83 ec 0c             	sub    $0xc,%esp
  800404:	ff 75 e8             	pushl  -0x18(%ebp)
  800407:	e8 2b 1c 00 00       	call   802037 <sys_free_env>
  80040c:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlave2);
  80040f:	83 ec 0c             	sub    $0xc,%esp
  800412:	ff 75 e4             	pushl  -0x1c(%ebp)
  800415:	e8 1d 1c 00 00       	call   802037 <sys_free_env>
  80041a:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlaveB1);
  80041d:	83 ec 0c             	sub    $0xc,%esp
  800420:	ff 75 d4             	pushl  -0x2c(%ebp)
  800423:	e8 0f 1c 00 00       	call   802037 <sys_free_env>
  800428:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlaveB2);
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	ff 75 d0             	pushl  -0x30(%ebp)
  800431:	e8 01 1c 00 00       	call   802037 <sys_free_env>
  800436:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  800439:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800440:	e8 b1 18 00 00       	call   801cf6 <sys_getparentenvid>
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	68 13 2a 80 00       	push   $0x802a13
  80044d:	50                   	push   %eax
  80044e:	e8 3b 17 00 00       	call   801b8e <sget>
  800453:	83 c4 10             	add    $0x10,%esp
  800456:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  800459:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	8d 50 01             	lea    0x1(%eax),%edx
  800461:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800464:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  800466:	90                   	nop
  800467:	90                   	nop
}
  800468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    

0080046d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800473:	e8 65 18 00 00       	call   801cdd <sys_getenvindex>
  800478:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80047b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80047e:	89 d0                	mov    %edx,%eax
  800480:	c1 e0 03             	shl    $0x3,%eax
  800483:	01 d0                	add    %edx,%eax
  800485:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	01 c0                	add    %eax,%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	01 c0                	add    %eax,%eax
  800494:	01 d0                	add    %edx,%eax
  800496:	89 c2                	mov    %eax,%edx
  800498:	c1 e2 05             	shl    $0x5,%edx
  80049b:	29 c2                	sub    %eax,%edx
  80049d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8004a4:	89 c2                	mov    %eax,%edx
  8004a6:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8004ac:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b6:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8004bc:	84 c0                	test   %al,%al
  8004be:	74 0f                	je     8004cf <libmain+0x62>
		binaryname = myEnv->prog_name;
  8004c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c5:	05 40 3c 01 00       	add    $0x13c40,%eax
  8004ca:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004d3:	7e 0a                	jle    8004df <libmain+0x72>
		binaryname = argv[0];
  8004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	ff 75 0c             	pushl  0xc(%ebp)
  8004e5:	ff 75 08             	pushl  0x8(%ebp)
  8004e8:	e8 4b fb ff ff       	call   800038 <_main>
  8004ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004f0:	e8 83 19 00 00       	call   801e78 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004f5:	83 ec 0c             	sub    $0xc,%esp
  8004f8:	68 3c 2a 80 00       	push   $0x802a3c
  8004fd:	e8 52 03 00 00       	call   800854 <cprintf>
  800502:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800505:	a1 20 40 80 00       	mov    0x804020,%eax
  80050a:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800510:	a1 20 40 80 00       	mov    0x804020,%eax
  800515:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	68 64 2a 80 00       	push   $0x802a64
  800525:	e8 2a 03 00 00       	call   800854 <cprintf>
  80052a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80052d:	a1 20 40 80 00       	mov    0x804020,%eax
  800532:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800538:	a1 20 40 80 00       	mov    0x804020,%eax
  80053d:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	68 8c 2a 80 00       	push   $0x802a8c
  80054d:	e8 02 03 00 00       	call   800854 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 40 80 00       	mov    0x804020,%eax
  80055a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 cd 2a 80 00       	push   $0x802acd
  800569:	e8 e6 02 00 00       	call   800854 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 3c 2a 80 00       	push   $0x802a3c
  800579:	e8 d6 02 00 00       	call   800854 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800581:	e8 0c 19 00 00       	call   801e92 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800586:	e8 19 00 00 00       	call   8005a4 <exit>
}
  80058b:	90                   	nop
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	6a 00                	push   $0x0
  800599:	e8 0b 17 00 00       	call   801ca9 <sys_env_destroy>
  80059e:	83 c4 10             	add    $0x10,%esp
}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <exit>:

void
exit(void)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8005aa:	e8 60 17 00 00       	call   801d0f <sys_env_exit>
}
  8005af:	90                   	nop
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b8:	8d 45 10             	lea    0x10(%ebp),%eax
  8005bb:	83 c0 04             	add    $0x4,%eax
  8005be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005c1:	a1 18 41 80 00       	mov    0x804118,%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	74 16                	je     8005e0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005ca:	a1 18 41 80 00       	mov    0x804118,%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	50                   	push   %eax
  8005d3:	68 e4 2a 80 00       	push   $0x802ae4
  8005d8:	e8 77 02 00 00       	call   800854 <cprintf>
  8005dd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005e0:	a1 00 40 80 00       	mov    0x804000,%eax
  8005e5:	ff 75 0c             	pushl  0xc(%ebp)
  8005e8:	ff 75 08             	pushl  0x8(%ebp)
  8005eb:	50                   	push   %eax
  8005ec:	68 e9 2a 80 00       	push   $0x802ae9
  8005f1:	e8 5e 02 00 00       	call   800854 <cprintf>
  8005f6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	50                   	push   %eax
  800603:	e8 e1 01 00 00       	call   8007e9 <vcprintf>
  800608:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	6a 00                	push   $0x0
  800610:	68 05 2b 80 00       	push   $0x802b05
  800615:	e8 cf 01 00 00       	call   8007e9 <vcprintf>
  80061a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061d:	e8 82 ff ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  800622:	eb fe                	jmp    800622 <_panic+0x70>

00800624 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800624:	55                   	push   %ebp
  800625:	89 e5                	mov    %esp,%ebp
  800627:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80062a:	a1 20 40 80 00       	mov    0x804020,%eax
  80062f:	8b 50 74             	mov    0x74(%eax),%edx
  800632:	8b 45 0c             	mov    0xc(%ebp),%eax
  800635:	39 c2                	cmp    %eax,%edx
  800637:	74 14                	je     80064d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800639:	83 ec 04             	sub    $0x4,%esp
  80063c:	68 08 2b 80 00       	push   $0x802b08
  800641:	6a 26                	push   $0x26
  800643:	68 54 2b 80 00       	push   $0x802b54
  800648:	e8 65 ff ff ff       	call   8005b2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800654:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80065b:	e9 b6 00 00 00       	jmp    800716 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800663:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	85 c0                	test   %eax,%eax
  800673:	75 08                	jne    80067d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800675:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800678:	e9 96 00 00 00       	jmp    800713 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80067d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800684:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80068b:	eb 5d                	jmp    8006ea <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068d:	a1 20 40 80 00       	mov    0x804020,%eax
  800692:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800698:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80069b:	c1 e2 04             	shl    $0x4,%edx
  80069e:	01 d0                	add    %edx,%eax
  8006a0:	8a 40 04             	mov    0x4(%eax),%al
  8006a3:	84 c0                	test   %al,%al
  8006a5:	75 40                	jne    8006e7 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8006ac:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8006b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b5:	c1 e2 04             	shl    $0x4,%edx
  8006b8:	01 d0                	add    %edx,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006c7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	01 c8                	add    %ecx,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006da:	39 c2                	cmp    %eax,%edx
  8006dc:	75 09                	jne    8006e7 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8006de:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006e5:	eb 12                	jmp    8006f9 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e7:	ff 45 e8             	incl   -0x18(%ebp)
  8006ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8006ef:	8b 50 74             	mov    0x74(%eax),%edx
  8006f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f5:	39 c2                	cmp    %eax,%edx
  8006f7:	77 94                	ja     80068d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006fd:	75 14                	jne    800713 <CheckWSWithoutLastIndex+0xef>
			panic(
  8006ff:	83 ec 04             	sub    $0x4,%esp
  800702:	68 60 2b 80 00       	push   $0x802b60
  800707:	6a 3a                	push   $0x3a
  800709:	68 54 2b 80 00       	push   $0x802b54
  80070e:	e8 9f fe ff ff       	call   8005b2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800713:	ff 45 f0             	incl   -0x10(%ebp)
  800716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800719:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80071c:	0f 8c 3e ff ff ff    	jl     800660 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800722:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800729:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800730:	eb 20                	jmp    800752 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800732:	a1 20 40 80 00       	mov    0x804020,%eax
  800737:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80073d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800740:	c1 e2 04             	shl    $0x4,%edx
  800743:	01 d0                	add    %edx,%eax
  800745:	8a 40 04             	mov    0x4(%eax),%al
  800748:	3c 01                	cmp    $0x1,%al
  80074a:	75 03                	jne    80074f <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80074c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074f:	ff 45 e0             	incl   -0x20(%ebp)
  800752:	a1 20 40 80 00       	mov    0x804020,%eax
  800757:	8b 50 74             	mov    0x74(%eax),%edx
  80075a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075d:	39 c2                	cmp    %eax,%edx
  80075f:	77 d1                	ja     800732 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800764:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800767:	74 14                	je     80077d <CheckWSWithoutLastIndex+0x159>
		panic(
  800769:	83 ec 04             	sub    $0x4,%esp
  80076c:	68 b4 2b 80 00       	push   $0x802bb4
  800771:	6a 44                	push   $0x44
  800773:	68 54 2b 80 00       	push   $0x802b54
  800778:	e8 35 fe ff ff       	call   8005b2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800786:	8b 45 0c             	mov    0xc(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	8d 48 01             	lea    0x1(%eax),%ecx
  80078e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800791:	89 0a                	mov    %ecx,(%edx)
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
  800796:	88 d1                	mov    %dl,%cl
  800798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80079b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007a9:	75 2c                	jne    8007d7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ab:	a0 24 40 80 00       	mov    0x804024,%al
  8007b0:	0f b6 c0             	movzbl %al,%eax
  8007b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b6:	8b 12                	mov    (%edx),%edx
  8007b8:	89 d1                	mov    %edx,%ecx
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	83 c2 08             	add    $0x8,%edx
  8007c0:	83 ec 04             	sub    $0x4,%esp
  8007c3:	50                   	push   %eax
  8007c4:	51                   	push   %ecx
  8007c5:	52                   	push   %edx
  8007c6:	e8 9c 14 00 00       	call   801c67 <sys_cputs>
  8007cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007da:	8b 40 04             	mov    0x4(%eax),%eax
  8007dd:	8d 50 01             	lea    0x1(%eax),%edx
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007e6:	90                   	nop
  8007e7:	c9                   	leave  
  8007e8:	c3                   	ret    

008007e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007f9:	00 00 00 
	b.cnt = 0;
  8007fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800803:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	ff 75 08             	pushl  0x8(%ebp)
  80080c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	68 80 07 80 00       	push   $0x800780
  800818:	e8 11 02 00 00       	call   800a2e <vprintfmt>
  80081d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800820:	a0 24 40 80 00       	mov    0x804024,%al
  800825:	0f b6 c0             	movzbl %al,%eax
  800828:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80082e:	83 ec 04             	sub    $0x4,%esp
  800831:	50                   	push   %eax
  800832:	52                   	push   %edx
  800833:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800839:	83 c0 08             	add    $0x8,%eax
  80083c:	50                   	push   %eax
  80083d:	e8 25 14 00 00       	call   801c67 <sys_cputs>
  800842:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800845:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80084c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <cprintf>:

int cprintf(const char *fmt, ...) {
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80085a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800861:	8d 45 0c             	lea    0xc(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 f4             	pushl  -0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	e8 73 ff ff ff       	call   8007e9 <vcprintf>
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800887:	e8 ec 15 00 00       	call   801e78 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80088c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80088f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 f4             	pushl  -0xc(%ebp)
  80089b:	50                   	push   %eax
  80089c:	e8 48 ff ff ff       	call   8007e9 <vcprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008a7:	e8 e6 15 00 00       	call   801e92 <sys_enable_interrupt>
	return cnt;
  8008ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	53                   	push   %ebx
  8008b5:	83 ec 14             	sub    $0x14,%esp
  8008b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008cf:	77 55                	ja     800926 <printnum+0x75>
  8008d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008d4:	72 05                	jb     8008db <printnum+0x2a>
  8008d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008d9:	77 4b                	ja     800926 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008db:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008de:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8008f1:	e8 5a 1a 00 00       	call   802350 <__udivdi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	83 ec 04             	sub    $0x4,%esp
  8008fc:	ff 75 20             	pushl  0x20(%ebp)
  8008ff:	53                   	push   %ebx
  800900:	ff 75 18             	pushl  0x18(%ebp)
  800903:	52                   	push   %edx
  800904:	50                   	push   %eax
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	ff 75 08             	pushl  0x8(%ebp)
  80090b:	e8 a1 ff ff ff       	call   8008b1 <printnum>
  800910:	83 c4 20             	add    $0x20,%esp
  800913:	eb 1a                	jmp    80092f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	ff 75 20             	pushl  0x20(%ebp)
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800926:	ff 4d 1c             	decl   0x1c(%ebp)
  800929:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80092d:	7f e6                	jg     800915 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80092f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800932:	bb 00 00 00 00       	mov    $0x0,%ebx
  800937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093d:	53                   	push   %ebx
  80093e:	51                   	push   %ecx
  80093f:	52                   	push   %edx
  800940:	50                   	push   %eax
  800941:	e8 1a 1b 00 00       	call   802460 <__umoddi3>
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	05 14 2e 80 00       	add    $0x802e14,%eax
  80094e:	8a 00                	mov    (%eax),%al
  800950:	0f be c0             	movsbl %al,%eax
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	50                   	push   %eax
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
}
  800962:	90                   	nop
  800963:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80096b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80096f:	7e 1c                	jle    80098d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	8d 50 08             	lea    0x8(%eax),%edx
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	89 10                	mov    %edx,(%eax)
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	83 e8 08             	sub    $0x8,%eax
  800986:	8b 50 04             	mov    0x4(%eax),%edx
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	eb 40                	jmp    8009cd <getuint+0x65>
	else if (lflag)
  80098d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800991:	74 1e                	je     8009b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	8d 50 04             	lea    0x4(%eax),%edx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 10                	mov    %edx,(%eax)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	83 e8 04             	sub    $0x4,%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009af:	eb 1c                	jmp    8009cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	8d 50 04             	lea    0x4(%eax),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	89 10                	mov    %edx,(%eax)
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 00                	mov    (%eax),%eax
  8009c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009d6:	7e 1c                	jle    8009f4 <getint+0x25>
		return va_arg(*ap, long long);
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	8d 50 08             	lea    0x8(%eax),%edx
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 10                	mov    %edx,(%eax)
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 00                	mov    (%eax),%eax
  8009ea:	83 e8 08             	sub    $0x8,%eax
  8009ed:	8b 50 04             	mov    0x4(%eax),%edx
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	eb 38                	jmp    800a2c <getint+0x5d>
	else if (lflag)
  8009f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f8:	74 1a                	je     800a14 <getint+0x45>
		return va_arg(*ap, long);
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	8d 50 04             	lea    0x4(%eax),%edx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	89 10                	mov    %edx,(%eax)
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	83 e8 04             	sub    $0x4,%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	99                   	cltd   
  800a12:	eb 18                	jmp    800a2c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 00                	mov    (%eax),%eax
  800a19:	8d 50 04             	lea    0x4(%eax),%edx
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	89 10                	mov    %edx,(%eax)
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 00                	mov    (%eax),%eax
  800a26:	83 e8 04             	sub    $0x4,%eax
  800a29:	8b 00                	mov    (%eax),%eax
  800a2b:	99                   	cltd   
}
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	56                   	push   %esi
  800a32:	53                   	push   %ebx
  800a33:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a36:	eb 17                	jmp    800a4f <vprintfmt+0x21>
			if (ch == '\0')
  800a38:	85 db                	test   %ebx,%ebx
  800a3a:	0f 84 af 03 00 00    	je     800def <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	53                   	push   %ebx
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a52:	8d 50 01             	lea    0x1(%eax),%edx
  800a55:	89 55 10             	mov    %edx,0x10(%ebp)
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	0f b6 d8             	movzbl %al,%ebx
  800a5d:	83 fb 25             	cmp    $0x25,%ebx
  800a60:	75 d6                	jne    800a38 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a62:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a66:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a6d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
  800a85:	8d 50 01             	lea    0x1(%eax),%edx
  800a88:	89 55 10             	mov    %edx,0x10(%ebp)
  800a8b:	8a 00                	mov    (%eax),%al
  800a8d:	0f b6 d8             	movzbl %al,%ebx
  800a90:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a93:	83 f8 55             	cmp    $0x55,%eax
  800a96:	0f 87 2b 03 00 00    	ja     800dc7 <vprintfmt+0x399>
  800a9c:	8b 04 85 38 2e 80 00 	mov    0x802e38(,%eax,4),%eax
  800aa3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aa5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800aa9:	eb d7                	jmp    800a82 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aaf:	eb d1                	jmp    800a82 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ab8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	c1 e0 02             	shl    $0x2,%eax
  800ac0:	01 d0                	add    %edx,%eax
  800ac2:	01 c0                	add    %eax,%eax
  800ac4:	01 d8                	add    %ebx,%eax
  800ac6:	83 e8 30             	sub    $0x30,%eax
  800ac9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800acc:	8b 45 10             	mov    0x10(%ebp),%eax
  800acf:	8a 00                	mov    (%eax),%al
  800ad1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ad4:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad7:	7e 3e                	jle    800b17 <vprintfmt+0xe9>
  800ad9:	83 fb 39             	cmp    $0x39,%ebx
  800adc:	7f 39                	jg     800b17 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ade:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ae1:	eb d5                	jmp    800ab8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800af7:	eb 1f                	jmp    800b18 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800af9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afd:	79 83                	jns    800a82 <vprintfmt+0x54>
				width = 0;
  800aff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b06:	e9 77 ff ff ff       	jmp    800a82 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b0b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b12:	e9 6b ff ff ff       	jmp    800a82 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b17:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1c:	0f 89 60 ff ff ff    	jns    800a82 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b2f:	e9 4e ff ff ff       	jmp    800a82 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b34:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b37:	e9 46 ff ff ff       	jmp    800a82 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	83 c0 04             	add    $0x4,%eax
  800b42:	89 45 14             	mov    %eax,0x14(%ebp)
  800b45:	8b 45 14             	mov    0x14(%ebp),%eax
  800b48:	83 e8 04             	sub    $0x4,%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	50                   	push   %eax
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
			break;
  800b5c:	e9 89 02 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	83 c0 04             	add    $0x4,%eax
  800b67:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6d:	83 e8 04             	sub    $0x4,%eax
  800b70:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b72:	85 db                	test   %ebx,%ebx
  800b74:	79 02                	jns    800b78 <vprintfmt+0x14a>
				err = -err;
  800b76:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b78:	83 fb 64             	cmp    $0x64,%ebx
  800b7b:	7f 0b                	jg     800b88 <vprintfmt+0x15a>
  800b7d:	8b 34 9d 80 2c 80 00 	mov    0x802c80(,%ebx,4),%esi
  800b84:	85 f6                	test   %esi,%esi
  800b86:	75 19                	jne    800ba1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b88:	53                   	push   %ebx
  800b89:	68 25 2e 80 00       	push   $0x802e25
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	ff 75 08             	pushl  0x8(%ebp)
  800b94:	e8 5e 02 00 00       	call   800df7 <printfmt>
  800b99:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b9c:	e9 49 02 00 00       	jmp    800dea <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ba1:	56                   	push   %esi
  800ba2:	68 2e 2e 80 00       	push   $0x802e2e
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 45 02 00 00       	call   800df7 <printfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	e9 30 02 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bba:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbd:	83 c0 04             	add    $0x4,%eax
  800bc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc6:	83 e8 04             	sub    $0x4,%eax
  800bc9:	8b 30                	mov    (%eax),%esi
  800bcb:	85 f6                	test   %esi,%esi
  800bcd:	75 05                	jne    800bd4 <vprintfmt+0x1a6>
				p = "(null)";
  800bcf:	be 31 2e 80 00       	mov    $0x802e31,%esi
			if (width > 0 && padc != '-')
  800bd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd8:	7e 6d                	jle    800c47 <vprintfmt+0x219>
  800bda:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bde:	74 67                	je     800c47 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	50                   	push   %eax
  800be7:	56                   	push   %esi
  800be8:	e8 0c 03 00 00       	call   800ef9 <strnlen>
  800bed:	83 c4 10             	add    $0x10,%esp
  800bf0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bf3:	eb 16                	jmp    800c0b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bf5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	50                   	push   %eax
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c08:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0f:	7f e4                	jg     800bf5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c11:	eb 34                	jmp    800c47 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c13:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c17:	74 1c                	je     800c35 <vprintfmt+0x207>
  800c19:	83 fb 1f             	cmp    $0x1f,%ebx
  800c1c:	7e 05                	jle    800c23 <vprintfmt+0x1f5>
  800c1e:	83 fb 7e             	cmp    $0x7e,%ebx
  800c21:	7e 12                	jle    800c35 <vprintfmt+0x207>
					putch('?', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 3f                	push   $0x3f
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
  800c33:	eb 0f                	jmp    800c44 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	53                   	push   %ebx
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c44:	ff 4d e4             	decl   -0x1c(%ebp)
  800c47:	89 f0                	mov    %esi,%eax
  800c49:	8d 70 01             	lea    0x1(%eax),%esi
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	0f be d8             	movsbl %al,%ebx
  800c51:	85 db                	test   %ebx,%ebx
  800c53:	74 24                	je     800c79 <vprintfmt+0x24b>
  800c55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c59:	78 b8                	js     800c13 <vprintfmt+0x1e5>
  800c5b:	ff 4d e0             	decl   -0x20(%ebp)
  800c5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c62:	79 af                	jns    800c13 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c64:	eb 13                	jmp    800c79 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 20                	push   $0x20
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c76:	ff 4d e4             	decl   -0x1c(%ebp)
  800c79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7d:	7f e7                	jg     800c66 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c7f:	e9 66 01 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 e8             	pushl  -0x18(%ebp)
  800c8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8d:	50                   	push   %eax
  800c8e:	e8 3c fd ff ff       	call   8009cf <getint>
  800c93:	83 c4 10             	add    $0x10,%esp
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca2:	85 d2                	test   %edx,%edx
  800ca4:	79 23                	jns    800cc9 <vprintfmt+0x29b>
				putch('-', putdat);
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	6a 2d                	push   $0x2d
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	ff d0                	call   *%eax
  800cb3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbc:	f7 d8                	neg    %eax
  800cbe:	83 d2 00             	adc    $0x0,%edx
  800cc1:	f7 da                	neg    %edx
  800cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cc9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cd0:	e9 bc 00 00 00       	jmp    800d91 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800cdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800cde:	50                   	push   %eax
  800cdf:	e8 84 fc ff ff       	call   800968 <getuint>
  800ce4:	83 c4 10             	add    $0x10,%esp
  800ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ced:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cf4:	e9 98 00 00 00       	jmp    800d91 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	6a 58                	push   $0x58
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff d0                	call   *%eax
  800d06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	6a 58                	push   $0x58
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	ff d0                	call   *%eax
  800d16:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 58                	push   $0x58
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			break;
  800d29:	e9 bc 00 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	6a 30                	push   $0x30
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	ff d0                	call   *%eax
  800d3b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	6a 78                	push   $0x78
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	ff d0                	call   *%eax
  800d4b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d51:	83 c0 04             	add    $0x4,%eax
  800d54:	89 45 14             	mov    %eax,0x14(%ebp)
  800d57:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5a:	83 e8 04             	sub    $0x4,%eax
  800d5d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d70:	eb 1f                	jmp    800d91 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 e8             	pushl  -0x18(%ebp)
  800d78:	8d 45 14             	lea    0x14(%ebp),%eax
  800d7b:	50                   	push   %eax
  800d7c:	e8 e7 fb ff ff       	call   800968 <getuint>
  800d81:	83 c4 10             	add    $0x10,%esp
  800d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d87:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d91:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d98:	83 ec 04             	sub    $0x4,%esp
  800d9b:	52                   	push   %edx
  800d9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d9f:	50                   	push   %eax
  800da0:	ff 75 f4             	pushl  -0xc(%ebp)
  800da3:	ff 75 f0             	pushl  -0x10(%ebp)
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	ff 75 08             	pushl  0x8(%ebp)
  800dac:	e8 00 fb ff ff       	call   8008b1 <printnum>
  800db1:	83 c4 20             	add    $0x20,%esp
			break;
  800db4:	eb 34                	jmp    800dea <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db6:	83 ec 08             	sub    $0x8,%esp
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	53                   	push   %ebx
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	ff d0                	call   *%eax
  800dc2:	83 c4 10             	add    $0x10,%esp
			break;
  800dc5:	eb 23                	jmp    800dea <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	6a 25                	push   $0x25
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	ff d0                	call   *%eax
  800dd4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd7:	ff 4d 10             	decl   0x10(%ebp)
  800dda:	eb 03                	jmp    800ddf <vprintfmt+0x3b1>
  800ddc:	ff 4d 10             	decl   0x10(%ebp)
  800ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  800de2:	48                   	dec    %eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3c 25                	cmp    $0x25,%al
  800de7:	75 f3                	jne    800ddc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800de9:	90                   	nop
		}
	}
  800dea:	e9 47 fc ff ff       	jmp    800a36 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800def:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dfd:	8d 45 10             	lea    0x10(%ebp),%eax
  800e00:	83 c0 04             	add    $0x4,%eax
  800e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e06:	8b 45 10             	mov    0x10(%ebp),%eax
  800e09:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0c:	50                   	push   %eax
  800e0d:	ff 75 0c             	pushl  0xc(%ebp)
  800e10:	ff 75 08             	pushl  0x8(%ebp)
  800e13:	e8 16 fc ff ff       	call   800a2e <vprintfmt>
  800e18:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e1b:	90                   	nop
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	8b 40 08             	mov    0x8(%eax),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 10                	mov    (%eax),%edx
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	8b 40 04             	mov    0x4(%eax),%eax
  800e3b:	39 c2                	cmp    %eax,%edx
  800e3d:	73 12                	jae    800e51 <sprintputch+0x33>
		*b->buf++ = ch;
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	8d 48 01             	lea    0x1(%eax),%ecx
  800e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4a:	89 0a                	mov    %ecx,(%edx)
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	88 10                	mov    %dl,(%eax)
}
  800e51:	90                   	nop
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	01 d0                	add    %edx,%eax
  800e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e79:	74 06                	je     800e81 <vsnprintf+0x2d>
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	7f 07                	jg     800e88 <vsnprintf+0x34>
		return -E_INVAL;
  800e81:	b8 03 00 00 00       	mov    $0x3,%eax
  800e86:	eb 20                	jmp    800ea8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e88:	ff 75 14             	pushl  0x14(%ebp)
  800e8b:	ff 75 10             	pushl  0x10(%ebp)
  800e8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e91:	50                   	push   %eax
  800e92:	68 1e 0e 80 00       	push   $0x800e1e
  800e97:	e8 92 fb ff ff       	call   800a2e <vprintfmt>
  800e9c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ea2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800eb3:	83 c0 04             	add    $0x4,%eax
  800eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	ff 75 08             	pushl  0x8(%ebp)
  800ec6:	e8 89 ff ff ff       	call   800e54 <vsnprintf>
  800ecb:	83 c4 10             	add    $0x10,%esp
  800ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800edc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee3:	eb 06                	jmp    800eeb <strlen+0x15>
		n++;
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee8:	ff 45 08             	incl   0x8(%ebp)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 f1                	jne    800ee5 <strlen+0xf>
		n++;
	return n;
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    

00800ef9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f06:	eb 09                	jmp    800f11 <strnlen+0x18>
		n++;
  800f08:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 4d 0c             	decl   0xc(%ebp)
  800f11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f15:	74 09                	je     800f20 <strnlen+0x27>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	75 e8                	jne    800f08 <strnlen+0xf>
		n++;
	return n;
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f31:	90                   	nop
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8d 50 01             	lea    0x1(%eax),%edx
  800f38:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f41:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f44:	8a 12                	mov    (%edx),%dl
  800f46:	88 10                	mov    %dl,(%eax)
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	84 c0                	test   %al,%al
  800f4c:	75 e4                	jne    800f32 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f66:	eb 1f                	jmp    800f87 <strncpy+0x34>
		*dst++ = *src;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8d 50 01             	lea    0x1(%eax),%edx
  800f6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	84 c0                	test   %al,%al
  800f7f:	74 03                	je     800f84 <strncpy+0x31>
			src++;
  800f81:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f84:	ff 45 fc             	incl   -0x4(%ebp)
  800f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f8d:	72 d9                	jb     800f68 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	74 30                	je     800fd6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fa6:	eb 16                	jmp    800fbe <strlcpy+0x2a>
			*dst++ = *src++;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8d 50 01             	lea    0x1(%eax),%edx
  800fae:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fba:	8a 12                	mov    (%edx),%dl
  800fbc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fbe:	ff 4d 10             	decl   0x10(%ebp)
  800fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc5:	74 09                	je     800fd0 <strlcpy+0x3c>
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	75 d8                	jne    800fa8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdc:	29 c2                	sub    %eax,%edx
  800fde:	89 d0                	mov    %edx,%eax
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fe5:	eb 06                	jmp    800fed <strcmp+0xb>
		p++, q++;
  800fe7:	ff 45 08             	incl   0x8(%ebp)
  800fea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	84 c0                	test   %al,%al
  800ff4:	74 0e                	je     801004 <strcmp+0x22>
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 10                	mov    (%eax),%dl
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	38 c2                	cmp    %al,%dl
  801002:	74 e3                	je     800fe7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 d0             	movzbl %al,%edx
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	0f b6 c0             	movzbl %al,%eax
  801014:	29 c2                	sub    %eax,%edx
  801016:	89 d0                	mov    %edx,%eax
}
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80101d:	eb 09                	jmp    801028 <strncmp+0xe>
		n--, p++, q++;
  80101f:	ff 4d 10             	decl   0x10(%ebp)
  801022:	ff 45 08             	incl   0x8(%ebp)
  801025:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801028:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102c:	74 17                	je     801045 <strncmp+0x2b>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	84 c0                	test   %al,%al
  801035:	74 0e                	je     801045 <strncmp+0x2b>
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 10                	mov    (%eax),%dl
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	38 c2                	cmp    %al,%dl
  801043:	74 da                	je     80101f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801045:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801049:	75 07                	jne    801052 <strncmp+0x38>
		return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
  801050:	eb 14                	jmp    801066 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	0f b6 d0             	movzbl %al,%edx
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f b6 c0             	movzbl %al,%eax
  801062:	29 c2                	sub    %eax,%edx
  801064:	89 d0                	mov    %edx,%eax
}
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 04             	sub    $0x4,%esp
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801074:	eb 12                	jmp    801088 <strchr+0x20>
		if (*s == c)
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80107e:	75 05                	jne    801085 <strchr+0x1d>
			return (char *) s;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	eb 11                	jmp    801096 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801085:	ff 45 08             	incl   0x8(%ebp)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	84 c0                	test   %al,%al
  80108f:	75 e5                	jne    801076 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 04             	sub    $0x4,%esp
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010a4:	eb 0d                	jmp    8010b3 <strfind+0x1b>
		if (*s == c)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010ae:	74 0e                	je     8010be <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b0:	ff 45 08             	incl   0x8(%ebp)
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	84 c0                	test   %al,%al
  8010ba:	75 ea                	jne    8010a6 <strfind+0xe>
  8010bc:	eb 01                	jmp    8010bf <strfind+0x27>
		if (*s == c)
			break;
  8010be:	90                   	nop
	return (char *) s;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010d6:	eb 0e                	jmp    8010e6 <memset+0x22>
		*p++ = c;
  8010d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010db:	8d 50 01             	lea    0x1(%eax),%edx
  8010de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010e6:	ff 4d f8             	decl   -0x8(%ebp)
  8010e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010ed:	79 e9                	jns    8010d8 <memset+0x14>
		*p++ = c;

	return v;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801106:	eb 16                	jmp    80111e <memcpy+0x2a>
		*d++ = *s++;
  801108:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110b:	8d 50 01             	lea    0x1(%eax),%edx
  80110e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801111:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801114:	8d 4a 01             	lea    0x1(%edx),%ecx
  801117:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80111a:	8a 12                	mov    (%edx),%dl
  80111c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	8d 50 ff             	lea    -0x1(%eax),%edx
  801124:	89 55 10             	mov    %edx,0x10(%ebp)
  801127:	85 c0                	test   %eax,%eax
  801129:	75 dd                	jne    801108 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801145:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801148:	73 50                	jae    80119a <memmove+0x6a>
  80114a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114d:	8b 45 10             	mov    0x10(%ebp),%eax
  801150:	01 d0                	add    %edx,%eax
  801152:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801155:	76 43                	jbe    80119a <memmove+0x6a>
		s += n;
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801163:	eb 10                	jmp    801175 <memmove+0x45>
			*--d = *--s;
  801165:	ff 4d f8             	decl   -0x8(%ebp)
  801168:	ff 4d fc             	decl   -0x4(%ebp)
  80116b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116e:	8a 10                	mov    (%eax),%dl
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801175:	8b 45 10             	mov    0x10(%ebp),%eax
  801178:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117b:	89 55 10             	mov    %edx,0x10(%ebp)
  80117e:	85 c0                	test   %eax,%eax
  801180:	75 e3                	jne    801165 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801182:	eb 23                	jmp    8011a7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801184:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801190:	8d 4a 01             	lea    0x1(%edx),%ecx
  801193:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801196:	8a 12                	mov    (%edx),%dl
  801198:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80119a:	8b 45 10             	mov    0x10(%ebp),%eax
  80119d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	75 dd                	jne    801184 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011be:	eb 2a                	jmp    8011ea <memcmp+0x3e>
		if (*s1 != *s2)
  8011c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c3:	8a 10                	mov    (%eax),%dl
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	38 c2                	cmp    %al,%dl
  8011cc:	74 16                	je     8011e4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	0f b6 d0             	movzbl %al,%edx
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f b6 c0             	movzbl %al,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	eb 18                	jmp    8011fc <memcmp+0x50>
		s1++, s2++;
  8011e4:	ff 45 fc             	incl   -0x4(%ebp)
  8011e7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	75 c9                	jne    8011c0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801204:	8b 55 08             	mov    0x8(%ebp),%edx
  801207:	8b 45 10             	mov    0x10(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80120f:	eb 15                	jmp    801226 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f b6 d0             	movzbl %al,%edx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	0f b6 c0             	movzbl %al,%eax
  80121f:	39 c2                	cmp    %eax,%edx
  801221:	74 0d                	je     801230 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80122c:	72 e3                	jb     801211 <memfind+0x13>
  80122e:	eb 01                	jmp    801231 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801230:	90                   	nop
	return (void *) s;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80123c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801243:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124a:	eb 03                	jmp    80124f <strtol+0x19>
		s++;
  80124c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 20                	cmp    $0x20,%al
  801256:	74 f4                	je     80124c <strtol+0x16>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	3c 09                	cmp    $0x9,%al
  80125f:	74 eb                	je     80124c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 2b                	cmp    $0x2b,%al
  801268:	75 05                	jne    80126f <strtol+0x39>
		s++;
  80126a:	ff 45 08             	incl   0x8(%ebp)
  80126d:	eb 13                	jmp    801282 <strtol+0x4c>
	else if (*s == '-')
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 2d                	cmp    $0x2d,%al
  801276:	75 0a                	jne    801282 <strtol+0x4c>
		s++, neg = 1;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801286:	74 06                	je     80128e <strtol+0x58>
  801288:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80128c:	75 20                	jne    8012ae <strtol+0x78>
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	3c 30                	cmp    $0x30,%al
  801295:	75 17                	jne    8012ae <strtol+0x78>
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	40                   	inc    %eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 78                	cmp    $0x78,%al
  80129f:	75 0d                	jne    8012ae <strtol+0x78>
		s += 2, base = 16;
  8012a1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012a5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ac:	eb 28                	jmp    8012d6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b2:	75 15                	jne    8012c9 <strtol+0x93>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 30                	cmp    $0x30,%al
  8012bb:	75 0c                	jne    8012c9 <strtol+0x93>
		s++, base = 8;
  8012bd:	ff 45 08             	incl   0x8(%ebp)
  8012c0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c7:	eb 0d                	jmp    8012d6 <strtol+0xa0>
	else if (base == 0)
  8012c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cd:	75 07                	jne    8012d6 <strtol+0xa0>
		base = 10;
  8012cf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 2f                	cmp    $0x2f,%al
  8012dd:	7e 19                	jle    8012f8 <strtol+0xc2>
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 39                	cmp    $0x39,%al
  8012e6:	7f 10                	jg     8012f8 <strtol+0xc2>
			dig = *s - '0';
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	0f be c0             	movsbl %al,%eax
  8012f0:	83 e8 30             	sub    $0x30,%eax
  8012f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f6:	eb 42                	jmp    80133a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	3c 60                	cmp    $0x60,%al
  8012ff:	7e 19                	jle    80131a <strtol+0xe4>
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 7a                	cmp    $0x7a,%al
  801308:	7f 10                	jg     80131a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f be c0             	movsbl %al,%eax
  801312:	83 e8 57             	sub    $0x57,%eax
  801315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801318:	eb 20                	jmp    80133a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3c 40                	cmp    $0x40,%al
  801321:	7e 39                	jle    80135c <strtol+0x126>
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 5a                	cmp    $0x5a,%al
  80132a:	7f 30                	jg     80135c <strtol+0x126>
			dig = *s - 'A' + 10;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	0f be c0             	movsbl %al,%eax
  801334:	83 e8 37             	sub    $0x37,%eax
  801337:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80133a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801340:	7d 19                	jge    80135b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801342:	ff 45 08             	incl   0x8(%ebp)
  801345:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801348:	0f af 45 10          	imul   0x10(%ebp),%eax
  80134c:	89 c2                	mov    %eax,%edx
  80134e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801356:	e9 7b ff ff ff       	jmp    8012d6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80135b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80135c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801360:	74 08                	je     80136a <strtol+0x134>
		*endptr = (char *) s;
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	8b 55 08             	mov    0x8(%ebp),%edx
  801368:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80136a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80136e:	74 07                	je     801377 <strtol+0x141>
  801370:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801373:	f7 d8                	neg    %eax
  801375:	eb 03                	jmp    80137a <strtol+0x144>
  801377:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <ltostr>:

void
ltostr(long value, char *str)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801389:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801394:	79 13                	jns    8013a9 <ltostr+0x2d>
	{
		neg = 1;
  801396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013a6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b1:	99                   	cltd   
  8013b2:	f7 f9                	idiv   %ecx
  8013b4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ba:	8d 50 01             	lea    0x1(%eax),%edx
  8013bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c0:	89 c2                	mov    %eax,%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	01 d0                	add    %edx,%eax
  8013c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ca:	83 c2 30             	add    $0x30,%edx
  8013cd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d7:	f7 e9                	imul   %ecx
  8013d9:	c1 fa 02             	sar    $0x2,%edx
  8013dc:	89 c8                	mov    %ecx,%eax
  8013de:	c1 f8 1f             	sar    $0x1f,%eax
  8013e1:	29 c2                	sub    %eax,%edx
  8013e3:	89 d0                	mov    %edx,%eax
  8013e5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f0:	f7 e9                	imul   %ecx
  8013f2:	c1 fa 02             	sar    $0x2,%edx
  8013f5:	89 c8                	mov    %ecx,%eax
  8013f7:	c1 f8 1f             	sar    $0x1f,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	c1 e0 02             	shl    $0x2,%eax
  801401:	01 d0                	add    %edx,%eax
  801403:	01 c0                	add    %eax,%eax
  801405:	29 c1                	sub    %eax,%ecx
  801407:	89 ca                	mov    %ecx,%edx
  801409:	85 d2                	test   %edx,%edx
  80140b:	75 9c                	jne    8013a9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801417:	48                   	dec    %eax
  801418:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80141b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141f:	74 3d                	je     80145e <ltostr+0xe2>
		start = 1 ;
  801421:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801428:	eb 34                	jmp    80145e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c2                	add    %eax,%edx
  80143f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c8                	add    %ecx,%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80144b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	01 c2                	add    %eax,%edx
  801453:	8a 45 eb             	mov    -0x15(%ebp),%al
  801456:	88 02                	mov    %al,(%edx)
		start++ ;
  801458:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80145b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801461:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801464:	7c c4                	jl     80142a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801466:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 54 fa ff ff       	call   800ed6 <strlen>
  801482:	83 c4 04             	add    $0x4,%esp
  801485:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801488:	ff 75 0c             	pushl  0xc(%ebp)
  80148b:	e8 46 fa ff ff       	call   800ed6 <strlen>
  801490:	83 c4 04             	add    $0x4,%esp
  801493:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801496:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a4:	eb 17                	jmp    8014bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 c2                	add    %eax,%edx
  8014ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	01 c8                	add    %ecx,%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ba:	ff 45 fc             	incl   -0x4(%ebp)
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c3:	7c e1                	jl     8014a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d3:	eb 1f                	jmp    8014f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d8:	8d 50 01             	lea    0x1(%eax),%edx
  8014db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e3:	01 c2                	add    %eax,%edx
  8014e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	01 c8                	add    %ecx,%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f1:	ff 45 f8             	incl   -0x8(%ebp)
  8014f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014fa:	7c d9                	jl     8014d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801502:	01 d0                	add    %edx,%eax
  801504:	c6 00 00             	movb   $0x0,(%eax)
}
  801507:	90                   	nop
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801516:	8b 45 14             	mov    0x14(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801522:	8b 45 10             	mov    0x10(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152d:	eb 0c                	jmp    80153b <strsplit+0x31>
			*string++ = 0;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8d 50 01             	lea    0x1(%eax),%edx
  801535:	89 55 08             	mov    %edx,0x8(%ebp)
  801538:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	84 c0                	test   %al,%al
  801542:	74 18                	je     80155c <strsplit+0x52>
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f be c0             	movsbl %al,%eax
  80154c:	50                   	push   %eax
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	e8 13 fb ff ff       	call   801068 <strchr>
  801555:	83 c4 08             	add    $0x8,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	75 d3                	jne    80152f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	84 c0                	test   %al,%al
  801563:	74 5a                	je     8015bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801565:	8b 45 14             	mov    0x14(%ebp),%eax
  801568:	8b 00                	mov    (%eax),%eax
  80156a:	83 f8 0f             	cmp    $0xf,%eax
  80156d:	75 07                	jne    801576 <strsplit+0x6c>
		{
			return 0;
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	eb 66                	jmp    8015dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801576:	8b 45 14             	mov    0x14(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	8d 48 01             	lea    0x1(%eax),%ecx
  80157e:	8b 55 14             	mov    0x14(%ebp),%edx
  801581:	89 0a                	mov    %ecx,(%edx)
  801583:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158a:	8b 45 10             	mov    0x10(%ebp),%eax
  80158d:	01 c2                	add    %eax,%edx
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801594:	eb 03                	jmp    801599 <strsplit+0x8f>
			string++;
  801596:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	84 c0                	test   %al,%al
  8015a0:	74 8b                	je     80152d <strsplit+0x23>
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	0f be c0             	movsbl %al,%eax
  8015aa:	50                   	push   %eax
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	e8 b5 fa ff ff       	call   801068 <strchr>
  8015b3:	83 c4 08             	add    $0x8,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 dc                	je     801596 <strsplit+0x8c>
			string++;
	}
  8015ba:	e9 6e ff ff ff       	jmp    80152d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8015e4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ee:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	48                   	dec    %eax
  8015f4:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8015f7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8015fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ff:	f7 75 ac             	divl   -0x54(%ebp)
  801602:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801605:	29 d0                	sub    %edx,%eax
  801607:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  80160a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801611:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801618:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80161f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801626:	eb 3f                	jmp    801667 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80162b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	50                   	push   %eax
  801636:	ff 75 e8             	pushl  -0x18(%ebp)
  801639:	68 90 2f 80 00       	push   $0x802f90
  80163e:	e8 11 f2 ff ff       	call   800854 <cprintf>
  801643:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801649:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	50                   	push   %eax
  801654:	ff 75 e8             	pushl  -0x18(%ebp)
  801657:	68 a5 2f 80 00       	push   $0x802fa5
  80165c:	e8 f3 f1 ff ff       	call   800854 <cprintf>
  801661:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801664:	ff 45 e8             	incl   -0x18(%ebp)
  801667:	a1 28 40 80 00       	mov    0x804028,%eax
  80166c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80166f:	7c b7                	jl     801628 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801671:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801678:	e9 35 01 00 00       	jmp    8017b2 <malloc+0x1d4>
		int flag0=1;
  80167d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801687:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80168a:	eb 5e                	jmp    8016ea <malloc+0x10c>
			for(int k=0;k<count;k++){
  80168c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801693:	eb 35                	jmp    8016ca <malloc+0xec>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801698:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  80169f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016a2:	39 c2                	cmp    %eax,%edx
  8016a4:	77 21                	ja     8016c7 <malloc+0xe9>
  8016a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016a9:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8016b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b3:	39 c2                	cmp    %eax,%edx
  8016b5:	76 10                	jbe    8016c7 <malloc+0xe9>
					ni=PAGE_SIZE;
  8016b7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
					flag1=1;
  8016be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8016c5:	eb 0d                	jmp    8016d4 <malloc+0xf6>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8016c7:	ff 45 d8             	incl   -0x28(%ebp)
  8016ca:	a1 28 40 80 00       	mov    0x804028,%eax
  8016cf:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8016d2:	7c c1                	jl     801695 <malloc+0xb7>
					ni=PAGE_SIZE;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8016d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d8:	74 09                	je     8016e3 <malloc+0x105>
				flag0=0;
  8016da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8016e1:	eb 16                	jmp    8016f9 <malloc+0x11b>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8016e3:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8016ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	01 c2                	add    %eax,%edx
  8016f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016f5:	39 c2                	cmp    %eax,%edx
  8016f7:	77 93                	ja     80168c <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8016f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016fd:	0f 84 a2 00 00 00    	je     8017a5 <malloc+0x1c7>

			int f=1;
  801703:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  80170a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80170d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801710:	89 c8                	mov    %ecx,%eax
  801712:	01 c0                	add    %eax,%eax
  801714:	01 c8                	add    %ecx,%eax
  801716:	c1 e0 02             	shl    $0x2,%eax
  801719:	05 20 41 80 00       	add    $0x804120,%eax
  80171e:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801729:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172c:	89 d0                	mov    %edx,%eax
  80172e:	01 c0                	add    %eax,%eax
  801730:	01 d0                	add    %edx,%eax
  801732:	c1 e0 02             	shl    $0x2,%eax
  801735:	05 24 41 80 00       	add    $0x804124,%eax
  80173a:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80173c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173f:	89 d0                	mov    %edx,%eax
  801741:	01 c0                	add    %eax,%eax
  801743:	01 d0                	add    %edx,%eax
  801745:	c1 e0 02             	shl    $0x2,%eax
  801748:	05 28 41 80 00       	add    $0x804128,%eax
  80174d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801753:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801756:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80175d:	eb 36                	jmp    801795 <malloc+0x1b7>
				if(i+size<arr_add[l].start){
  80175f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	01 c2                	add    %eax,%edx
  801767:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80176a:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801771:	39 c2                	cmp    %eax,%edx
  801773:	73 1d                	jae    801792 <malloc+0x1b4>
					ni=arr_add[l].end-i;
  801775:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801778:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  80177f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801782:	29 c2                	sub    %eax,%edx
  801784:	89 d0                	mov    %edx,%eax
  801786:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801789:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801790:	eb 0d                	jmp    80179f <malloc+0x1c1>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801792:	ff 45 d0             	incl   -0x30(%ebp)
  801795:	a1 28 40 80 00       	mov    0x804028,%eax
  80179a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80179d:	7c c0                	jl     80175f <malloc+0x181>
					break;

				}
			}

			if(f){
  80179f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8017a3:	75 1d                	jne    8017c2 <malloc+0x1e4>
				break;
			}

		}

		flag1=0;
  8017a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8017b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8017b7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017ba:	0f 8c bd fe ff ff    	jl     80167d <malloc+0x9f>
  8017c0:	eb 01                	jmp    8017c3 <malloc+0x1e5>

				}
			}

			if(f){
				break;
  8017c2:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8017c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c7:	75 7a                	jne    801843 <malloc+0x265>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8017c9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	01 d0                	add    %edx,%eax
  8017d4:	48                   	dec    %eax
  8017d5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017da:	7c 0a                	jl     8017e6 <malloc+0x208>
			return NULL;
  8017dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e1:	e9 a4 02 00 00       	jmp    801a8a <malloc+0x4ac>
		else{
			uint32 s=base_add;
  8017e6:	a1 04 40 80 00       	mov    0x804004,%eax
  8017eb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8017ee:	a1 28 40 80 00       	mov    0x804028,%eax
  8017f3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8017f6:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	ff 75 a4             	pushl  -0x5c(%ebp)
  801806:	e8 04 06 00 00       	call   801e0f <sys_allocateMem>
  80180b:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80180e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  80181e:	a1 28 40 80 00       	mov    0x804028,%eax
  801823:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801829:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801830:	a1 28 40 80 00       	mov    0x804028,%eax
  801835:	40                   	inc    %eax
  801836:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  80183b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80183e:	e9 47 02 00 00       	jmp    801a8a <malloc+0x4ac>
	}
	else{



	for(int i=0;i<count2;i++){
  801843:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80184a:	e9 ac 00 00 00       	jmp    8018fb <malloc+0x31d>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80184f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801852:	89 d0                	mov    %edx,%eax
  801854:	01 c0                	add    %eax,%eax
  801856:	01 d0                	add    %edx,%eax
  801858:	c1 e0 02             	shl    $0x2,%eax
  80185b:	05 24 41 80 00       	add    $0x804124,%eax
  801860:	8b 00                	mov    (%eax),%eax
  801862:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801865:	eb 7e                	jmp    8018e5 <malloc+0x307>
			int flag=0;
  801867:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80186e:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801875:	eb 57                	jmp    8018ce <malloc+0x2f0>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801877:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80187a:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801881:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801884:	39 c2                	cmp    %eax,%edx
  801886:	77 1a                	ja     8018a2 <malloc+0x2c4>
  801888:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80188b:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801892:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801895:	39 c2                	cmp    %eax,%edx
  801897:	76 09                	jbe    8018a2 <malloc+0x2c4>
								flag=1;
  801899:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8018a0:	eb 36                	jmp    8018d8 <malloc+0x2fa>
			arr[i].space++;
  8018a2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8018a5:	89 d0                	mov    %edx,%eax
  8018a7:	01 c0                	add    %eax,%eax
  8018a9:	01 d0                	add    %edx,%eax
  8018ab:	c1 e0 02             	shl    $0x2,%eax
  8018ae:	05 28 41 80 00       	add    $0x804128,%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8018b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8018bb:	89 d0                	mov    %edx,%eax
  8018bd:	01 c0                	add    %eax,%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	c1 e0 02             	shl    $0x2,%eax
  8018c4:	05 28 41 80 00       	add    $0x804128,%eax
  8018c9:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8018cb:	ff 45 c0             	incl   -0x40(%ebp)
  8018ce:	a1 28 40 80 00       	mov    0x804028,%eax
  8018d3:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8018d6:	7c 9f                	jl     801877 <malloc+0x299>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8018d8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8018dc:	75 19                	jne    8018f7 <malloc+0x319>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8018de:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8018e5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8018e8:	a1 04 40 80 00       	mov    0x804004,%eax
  8018ed:	39 c2                	cmp    %eax,%edx
  8018ef:	0f 82 72 ff ff ff    	jb     801867 <malloc+0x289>
  8018f5:	eb 01                	jmp    8018f8 <malloc+0x31a>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8018f7:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8018f8:	ff 45 cc             	incl   -0x34(%ebp)
  8018fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801901:	0f 8c 48 ff ff ff    	jl     80184f <malloc+0x271>
			if(flag)
				break;
		}
	}

	int index=0;
  801907:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80190e:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801915:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80191c:	eb 37                	jmp    801955 <malloc+0x377>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80191e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801921:	89 d0                	mov    %edx,%eax
  801923:	01 c0                	add    %eax,%eax
  801925:	01 d0                	add    %edx,%eax
  801927:	c1 e0 02             	shl    $0x2,%eax
  80192a:	05 28 41 80 00       	add    $0x804128,%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801934:	7d 1c                	jge    801952 <malloc+0x374>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801936:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	01 c0                	add    %eax,%eax
  80193d:	01 d0                	add    %edx,%eax
  80193f:	c1 e0 02             	shl    $0x2,%eax
  801942:	05 28 41 80 00       	add    $0x804128,%eax
  801947:	8b 00                	mov    (%eax),%eax
  801949:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80194c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80194f:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801952:	ff 45 b4             	incl   -0x4c(%ebp)
  801955:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801958:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80195b:	7c c1                	jl     80191e <malloc+0x340>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80195d:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801963:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801966:	89 c8                	mov    %ecx,%eax
  801968:	01 c0                	add    %eax,%eax
  80196a:	01 c8                	add    %ecx,%eax
  80196c:	c1 e0 02             	shl    $0x2,%eax
  80196f:	05 20 41 80 00       	add    $0x804120,%eax
  801974:	8b 00                	mov    (%eax),%eax
  801976:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80197d:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801983:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801986:	89 c8                	mov    %ecx,%eax
  801988:	01 c0                	add    %eax,%eax
  80198a:	01 c8                	add    %ecx,%eax
  80198c:	c1 e0 02             	shl    $0x2,%eax
  80198f:	05 24 41 80 00       	add    $0x804124,%eax
  801994:	8b 00                	mov    (%eax),%eax
  801996:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  80199d:	a1 28 40 80 00       	mov    0x804028,%eax
  8019a2:	40                   	inc    %eax
  8019a3:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  8019a8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8019ab:	89 d0                	mov    %edx,%eax
  8019ad:	01 c0                	add    %eax,%eax
  8019af:	01 d0                	add    %edx,%eax
  8019b1:	c1 e0 02             	shl    $0x2,%eax
  8019b4:	05 20 41 80 00       	add    $0x804120,%eax
  8019b9:	8b 00                	mov    (%eax),%eax
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	ff 75 08             	pushl  0x8(%ebp)
  8019c1:	50                   	push   %eax
  8019c2:	e8 48 04 00 00       	call   801e0f <sys_allocateMem>
  8019c7:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8019ca:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8019d1:	eb 78                	jmp    801a4b <malloc+0x46d>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8019d3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8019d6:	89 d0                	mov    %edx,%eax
  8019d8:	01 c0                	add    %eax,%eax
  8019da:	01 d0                	add    %edx,%eax
  8019dc:	c1 e0 02             	shl    $0x2,%eax
  8019df:	05 20 41 80 00       	add    $0x804120,%eax
  8019e4:	8b 00                	mov    (%eax),%eax
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	50                   	push   %eax
  8019ea:	ff 75 b0             	pushl  -0x50(%ebp)
  8019ed:	68 90 2f 80 00       	push   $0x802f90
  8019f2:	e8 5d ee ff ff       	call   800854 <cprintf>
  8019f7:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8019fa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8019fd:	89 d0                	mov    %edx,%eax
  8019ff:	01 c0                	add    %eax,%eax
  801a01:	01 d0                	add    %edx,%eax
  801a03:	c1 e0 02             	shl    $0x2,%eax
  801a06:	05 24 41 80 00       	add    $0x804124,%eax
  801a0b:	8b 00                	mov    (%eax),%eax
  801a0d:	83 ec 04             	sub    $0x4,%esp
  801a10:	50                   	push   %eax
  801a11:	ff 75 b0             	pushl  -0x50(%ebp)
  801a14:	68 a5 2f 80 00       	push   $0x802fa5
  801a19:	e8 36 ee ff ff       	call   800854 <cprintf>
  801a1e:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801a21:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801a24:	89 d0                	mov    %edx,%eax
  801a26:	01 c0                	add    %eax,%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c1 e0 02             	shl    $0x2,%eax
  801a2d:	05 28 41 80 00       	add    $0x804128,%eax
  801a32:	8b 00                	mov    (%eax),%eax
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	50                   	push   %eax
  801a38:	ff 75 b0             	pushl  -0x50(%ebp)
  801a3b:	68 b8 2f 80 00       	push   $0x802fb8
  801a40:	e8 0f ee ff ff       	call   800854 <cprintf>
  801a45:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801a48:	ff 45 b0             	incl   -0x50(%ebp)
  801a4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801a4e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a51:	7c 80                	jl     8019d3 <malloc+0x3f5>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801a53:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a56:	89 d0                	mov    %edx,%eax
  801a58:	01 c0                	add    %eax,%eax
  801a5a:	01 d0                	add    %edx,%eax
  801a5c:	c1 e0 02             	shl    $0x2,%eax
  801a5f:	05 20 41 80 00       	add    $0x804120,%eax
  801a64:	8b 00                	mov    (%eax),%eax
  801a66:	83 ec 08             	sub    $0x8,%esp
  801a69:	50                   	push   %eax
  801a6a:	68 cc 2f 80 00       	push   $0x802fcc
  801a6f:	e8 e0 ed ff ff       	call   800854 <cprintf>
  801a74:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801a77:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a7a:	89 d0                	mov    %edx,%eax
  801a7c:	01 c0                	add    %eax,%eax
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	c1 e0 02             	shl    $0x2,%eax
  801a83:	05 20 41 80 00       	add    $0x804120,%eax
  801a88:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801a98:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801a9f:	eb 4b                	jmp    801aec <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa4:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801aab:	89 c2                	mov    %eax,%edx
  801aad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab0:	39 c2                	cmp    %eax,%edx
  801ab2:	7f 35                	jg     801ae9 <free+0x5d>
  801ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab7:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801abe:	89 c2                	mov    %eax,%edx
  801ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ac3:	39 c2                	cmp    %eax,%edx
  801ac5:	7e 22                	jle    801ae9 <free+0x5d>
				start=arr_add[i].start;
  801ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aca:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad7:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ade:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801ae7:	eb 0d                	jmp    801af6 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801ae9:	ff 45 ec             	incl   -0x14(%ebp)
  801aec:	a1 28 40 80 00       	mov    0x804028,%eax
  801af1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801af4:	7c ab                	jl     801aa1 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af9:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b03:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801b0a:	29 c2                	sub    %eax,%edx
  801b0c:	89 d0                	mov    %edx,%eax
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	50                   	push   %eax
  801b12:	ff 75 f4             	pushl  -0xc(%ebp)
  801b15:	e8 d9 02 00 00       	call   801df3 <sys_freeMem>
  801b1a:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b20:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b23:	eb 2d                	jmp    801b52 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b28:	40                   	inc    %eax
  801b29:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b33:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b3d:	40                   	inc    %eax
  801b3e:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b48:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801b4f:	ff 45 e8             	incl   -0x18(%ebp)
  801b52:	a1 28 40 80 00       	mov    0x804028,%eax
  801b57:	48                   	dec    %eax
  801b58:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b5b:	7f c8                	jg     801b25 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801b5d:	a1 28 40 80 00       	mov    0x804028,%eax
  801b62:	48                   	dec    %eax
  801b63:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 18             	sub    $0x18,%esp
  801b71:	8b 45 10             	mov    0x10(%ebp),%eax
  801b74:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	68 e8 2f 80 00       	push   $0x802fe8
  801b7f:	68 18 01 00 00       	push   $0x118
  801b84:	68 0b 30 80 00       	push   $0x80300b
  801b89:	e8 24 ea ff ff       	call   8005b2 <_panic>

00801b8e <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	68 e8 2f 80 00       	push   $0x802fe8
  801b9c:	68 1e 01 00 00       	push   $0x11e
  801ba1:	68 0b 30 80 00       	push   $0x80300b
  801ba6:	e8 07 ea ff ff       	call   8005b2 <_panic>

00801bab <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	68 e8 2f 80 00       	push   $0x802fe8
  801bb9:	68 24 01 00 00       	push   $0x124
  801bbe:	68 0b 30 80 00       	push   $0x80300b
  801bc3:	e8 ea e9 ff ff       	call   8005b2 <_panic>

00801bc8 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	68 e8 2f 80 00       	push   $0x802fe8
  801bd6:	68 29 01 00 00       	push   $0x129
  801bdb:	68 0b 30 80 00       	push   $0x80300b
  801be0:	e8 cd e9 ff ff       	call   8005b2 <_panic>

00801be5 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 e8 2f 80 00       	push   $0x802fe8
  801bf3:	68 2f 01 00 00       	push   $0x12f
  801bf8:	68 0b 30 80 00       	push   $0x80300b
  801bfd:	e8 b0 e9 ff ff       	call   8005b2 <_panic>

00801c02 <shrink>:
}
void shrink(uint32 newSize)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	68 e8 2f 80 00       	push   $0x802fe8
  801c10:	68 33 01 00 00       	push   $0x133
  801c15:	68 0b 30 80 00       	push   $0x80300b
  801c1a:	e8 93 e9 ff ff       	call   8005b2 <_panic>

00801c1f <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	68 e8 2f 80 00       	push   $0x802fe8
  801c2d:	68 38 01 00 00       	push   $0x138
  801c32:	68 0b 30 80 00       	push   $0x80300b
  801c37:	e8 76 e9 ff ff       	call   8005b2 <_panic>

00801c3c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	57                   	push   %edi
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c51:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c54:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c57:	cd 30                	int    $0x30
  801c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	5b                   	pop    %ebx
  801c63:	5e                   	pop    %esi
  801c64:	5f                   	pop    %edi
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    

00801c67 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	ff 75 0c             	pushl  0xc(%ebp)
  801c82:	50                   	push   %eax
  801c83:	6a 00                	push   $0x0
  801c85:	e8 b2 ff ff ff       	call   801c3c <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 01                	push   $0x1
  801c9f:	e8 98 ff ff ff       	call   801c3c <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	50                   	push   %eax
  801cb8:	6a 05                	push   $0x5
  801cba:	e8 7d ff ff ff       	call   801c3c <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 02                	push   $0x2
  801cd3:	e8 64 ff ff ff       	call   801c3c <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 03                	push   $0x3
  801cec:	e8 4b ff ff ff       	call   801c3c <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 04                	push   $0x4
  801d05:	e8 32 ff ff ff       	call   801c3c <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_env_exit>:


void sys_env_exit(void)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 06                	push   $0x6
  801d1e:	e8 19 ff ff ff       	call   801c3c <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	90                   	nop
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	6a 07                	push   $0x7
  801d3c:	e8 fb fe ff ff       	call   801c3c <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	56                   	push   %esi
  801d4a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d4b:	8b 75 18             	mov    0x18(%ebp),%esi
  801d4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	56                   	push   %esi
  801d5b:	53                   	push   %ebx
  801d5c:	51                   	push   %ecx
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 08                	push   $0x8
  801d61:	e8 d6 fe ff ff       	call   801c3c <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    

00801d70 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	52                   	push   %edx
  801d80:	50                   	push   %eax
  801d81:	6a 09                	push   $0x9
  801d83:	e8 b4 fe ff ff       	call   801c3c <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	ff 75 08             	pushl  0x8(%ebp)
  801d9c:	6a 0a                	push   $0xa
  801d9e:	e8 99 fe ff ff       	call   801c3c <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 0b                	push   $0xb
  801db7:	e8 80 fe ff ff       	call   801c3c <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 0c                	push   $0xc
  801dd0:	e8 67 fe ff ff       	call   801c3c <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 0d                	push   $0xd
  801de9:	e8 4e fe ff ff       	call   801c3c <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	6a 11                	push   $0x11
  801e04:	e8 33 fe ff ff       	call   801c3c <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
	return;
  801e0c:	90                   	nop
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	6a 12                	push   $0x12
  801e20:	e8 17 fe ff ff       	call   801c3c <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
	return ;
  801e28:	90                   	nop
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 0e                	push   $0xe
  801e3a:	e8 fd fd ff ff       	call   801c3c <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	6a 0f                	push   $0xf
  801e54:	e8 e3 fd ff ff       	call   801c3c <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 10                	push   $0x10
  801e6d:	e8 ca fd ff ff       	call   801c3c <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	90                   	nop
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 14                	push   $0x14
  801e87:	e8 b0 fd ff ff       	call   801c3c <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	90                   	nop
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 15                	push   $0x15
  801ea1:	e8 96 fd ff ff       	call   801c3c <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	90                   	nop
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_cputc>:


void
sys_cputc(const char c)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eb8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	50                   	push   %eax
  801ec5:	6a 16                	push   $0x16
  801ec7:	e8 70 fd ff ff       	call   801c3c <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 17                	push   $0x17
  801ee1:	e8 56 fd ff ff       	call   801c3c <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	90                   	nop
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	ff 75 0c             	pushl  0xc(%ebp)
  801efb:	50                   	push   %eax
  801efc:	6a 18                	push   $0x18
  801efe:	e8 39 fd ff ff       	call   801c3c <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	6a 1b                	push   $0x1b
  801f1b:	e8 1c fd ff ff       	call   801c3c <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	52                   	push   %edx
  801f35:	50                   	push   %eax
  801f36:	6a 19                	push   $0x19
  801f38:	e8 ff fc ff ff       	call   801c3c <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	90                   	nop
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	6a 1a                	push   $0x1a
  801f56:	e8 e1 fc ff ff       	call   801c3c <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	90                   	nop
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f6d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f70:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	51                   	push   %ecx
  801f7a:	52                   	push   %edx
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	50                   	push   %eax
  801f7f:	6a 1c                	push   $0x1c
  801f81:	e8 b6 fc ff ff       	call   801c3c <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	52                   	push   %edx
  801f9b:	50                   	push   %eax
  801f9c:	6a 1d                	push   $0x1d
  801f9e:	e8 99 fc ff ff       	call   801c3c <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	51                   	push   %ecx
  801fb9:	52                   	push   %edx
  801fba:	50                   	push   %eax
  801fbb:	6a 1e                	push   $0x1e
  801fbd:	e8 7a fc ff ff       	call   801c3c <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 1f                	push   $0x1f
  801fda:	e8 5d fc ff ff       	call   801c3c <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 20                	push   $0x20
  801ff3:	e8 44 fc ff ff       	call   801c3c <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	6a 00                	push   $0x0
  802005:	ff 75 14             	pushl  0x14(%ebp)
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	50                   	push   %eax
  80200f:	6a 21                	push   $0x21
  802011:	e8 26 fc ff ff       	call   801c3c <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	50                   	push   %eax
  80202a:	6a 22                	push   $0x22
  80202c:	e8 0b fc ff ff       	call   801c3c <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	90                   	nop
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	50                   	push   %eax
  802046:	6a 23                	push   $0x23
  802048:	e8 ef fb ff ff       	call   801c3c <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	90                   	nop
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802059:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80205c:	8d 50 04             	lea    0x4(%eax),%edx
  80205f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	52                   	push   %edx
  802069:	50                   	push   %eax
  80206a:	6a 24                	push   $0x24
  80206c:	e8 cb fb ff ff       	call   801c3c <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
	return result;
  802074:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80207d:	89 01                	mov    %eax,(%ecx)
  80207f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	c9                   	leave  
  802086:	c2 04 00             	ret    $0x4

00802089 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	ff 75 10             	pushl  0x10(%ebp)
  802093:	ff 75 0c             	pushl  0xc(%ebp)
  802096:	ff 75 08             	pushl  0x8(%ebp)
  802099:	6a 13                	push   $0x13
  80209b:	e8 9c fb ff ff       	call   801c3c <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a3:	90                   	nop
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 25                	push   $0x25
  8020b5:	e8 82 fb ff ff       	call   801c3c <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020cb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	50                   	push   %eax
  8020d8:	6a 26                	push   $0x26
  8020da:	e8 5d fb ff ff       	call   801c3c <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e2:	90                   	nop
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <rsttst>:
void rsttst()
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 28                	push   $0x28
  8020f4:	e8 43 fb ff ff       	call   801c3c <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fc:	90                   	nop
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	8b 45 14             	mov    0x14(%ebp),%eax
  802108:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80210b:	8b 55 18             	mov    0x18(%ebp),%edx
  80210e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802112:	52                   	push   %edx
  802113:	50                   	push   %eax
  802114:	ff 75 10             	pushl  0x10(%ebp)
  802117:	ff 75 0c             	pushl  0xc(%ebp)
  80211a:	ff 75 08             	pushl  0x8(%ebp)
  80211d:	6a 27                	push   $0x27
  80211f:	e8 18 fb ff ff       	call   801c3c <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
	return ;
  802127:	90                   	nop
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <chktst>:
void chktst(uint32 n)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	ff 75 08             	pushl  0x8(%ebp)
  802138:	6a 29                	push   $0x29
  80213a:	e8 fd fa ff ff       	call   801c3c <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
	return ;
  802142:	90                   	nop
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <inctst>:

void inctst()
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 2a                	push   $0x2a
  802154:	e8 e3 fa ff ff       	call   801c3c <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
	return ;
  80215c:	90                   	nop
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <gettst>:
uint32 gettst()
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 2b                	push   $0x2b
  80216e:	e8 c9 fa ff ff       	call   801c3c <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 2c                	push   $0x2c
  80218a:	e8 ad fa ff ff       	call   801c3c <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
  802192:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802195:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802199:	75 07                	jne    8021a2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80219b:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a0:	eb 05                	jmp    8021a7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 2c                	push   $0x2c
  8021bb:	e8 7c fa ff ff       	call   801c3c <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
  8021c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021c6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021ca:	75 07                	jne    8021d3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d1:	eb 05                	jmp    8021d8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 2c                	push   $0x2c
  8021ec:	e8 4b fa ff ff       	call   801c3c <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
  8021f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021f7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021fb:	75 07                	jne    802204 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802202:	eb 05                	jmp    802209 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 2c                	push   $0x2c
  80221d:	e8 1a fa ff ff       	call   801c3c <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
  802225:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802228:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80222c:	75 07                	jne    802235 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80222e:	b8 01 00 00 00       	mov    $0x1,%eax
  802233:	eb 05                	jmp    80223a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	ff 75 08             	pushl  0x8(%ebp)
  80224a:	6a 2d                	push   $0x2d
  80224c:	e8 eb f9 ff ff       	call   801c3c <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
	return ;
  802254:	90                   	nop
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80225b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802261:	8b 55 0c             	mov    0xc(%ebp),%edx
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	6a 00                	push   $0x0
  802269:	53                   	push   %ebx
  80226a:	51                   	push   %ecx
  80226b:	52                   	push   %edx
  80226c:	50                   	push   %eax
  80226d:	6a 2e                	push   $0x2e
  80226f:	e8 c8 f9 ff ff       	call   801c3c <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80227f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	52                   	push   %edx
  80228c:	50                   	push   %eax
  80228d:	6a 2f                	push   $0x2f
  80228f:	e8 a8 f9 ff ff       	call   801c3c <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80229f:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a2:	89 d0                	mov    %edx,%eax
  8022a4:	c1 e0 02             	shl    $0x2,%eax
  8022a7:	01 d0                	add    %edx,%eax
  8022a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022b0:	01 d0                	add    %edx,%eax
  8022b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022c2:	01 d0                	add    %edx,%eax
  8022c4:	c1 e0 04             	shl    $0x4,%eax
  8022c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8022ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8022d1:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8022d4:	83 ec 0c             	sub    $0xc,%esp
  8022d7:	50                   	push   %eax
  8022d8:	e8 76 fd ff ff       	call   802053 <sys_get_virtual_time>
  8022dd:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8022e0:	eb 41                	jmp    802323 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8022e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	50                   	push   %eax
  8022e9:	e8 65 fd ff ff       	call   802053 <sys_get_virtual_time>
  8022ee:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8022f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f7:	29 c2                	sub    %eax,%edx
  8022f9:	89 d0                	mov    %edx,%eax
  8022fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8022fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802301:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802304:	89 d1                	mov    %edx,%ecx
  802306:	29 c1                	sub    %eax,%ecx
  802308:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80230b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230e:	39 c2                	cmp    %eax,%edx
  802310:	0f 97 c0             	seta   %al
  802313:	0f b6 c0             	movzbl %al,%eax
  802316:	29 c1                	sub    %eax,%ecx
  802318:	89 c8                	mov    %ecx,%eax
  80231a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80231d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802320:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802329:	72 b7                	jb     8022e2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80232b:	90                   	nop
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802334:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80233b:	eb 03                	jmp    802340 <busy_wait+0x12>
  80233d:	ff 45 fc             	incl   -0x4(%ebp)
  802340:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802343:	3b 45 08             	cmp    0x8(%ebp),%eax
  802346:	72 f5                	jb     80233d <busy_wait+0xf>
	return i;
  802348:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    
  80234d:	66 90                	xchg   %ax,%ax
  80234f:	90                   	nop

00802350 <__udivdi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80235b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80235f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802363:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802367:	89 ca                	mov    %ecx,%edx
  802369:	89 f8                	mov    %edi,%eax
  80236b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80236f:	85 f6                	test   %esi,%esi
  802371:	75 2d                	jne    8023a0 <__udivdi3+0x50>
  802373:	39 cf                	cmp    %ecx,%edi
  802375:	77 65                	ja     8023dc <__udivdi3+0x8c>
  802377:	89 fd                	mov    %edi,%ebp
  802379:	85 ff                	test   %edi,%edi
  80237b:	75 0b                	jne    802388 <__udivdi3+0x38>
  80237d:	b8 01 00 00 00       	mov    $0x1,%eax
  802382:	31 d2                	xor    %edx,%edx
  802384:	f7 f7                	div    %edi
  802386:	89 c5                	mov    %eax,%ebp
  802388:	31 d2                	xor    %edx,%edx
  80238a:	89 c8                	mov    %ecx,%eax
  80238c:	f7 f5                	div    %ebp
  80238e:	89 c1                	mov    %eax,%ecx
  802390:	89 d8                	mov    %ebx,%eax
  802392:	f7 f5                	div    %ebp
  802394:	89 cf                	mov    %ecx,%edi
  802396:	89 fa                	mov    %edi,%edx
  802398:	83 c4 1c             	add    $0x1c,%esp
  80239b:	5b                   	pop    %ebx
  80239c:	5e                   	pop    %esi
  80239d:	5f                   	pop    %edi
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    
  8023a0:	39 ce                	cmp    %ecx,%esi
  8023a2:	77 28                	ja     8023cc <__udivdi3+0x7c>
  8023a4:	0f bd fe             	bsr    %esi,%edi
  8023a7:	83 f7 1f             	xor    $0x1f,%edi
  8023aa:	75 40                	jne    8023ec <__udivdi3+0x9c>
  8023ac:	39 ce                	cmp    %ecx,%esi
  8023ae:	72 0a                	jb     8023ba <__udivdi3+0x6a>
  8023b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023b4:	0f 87 9e 00 00 00    	ja     802458 <__udivdi3+0x108>
  8023ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bf:	89 fa                	mov    %edi,%edx
  8023c1:	83 c4 1c             	add    $0x1c,%esp
  8023c4:	5b                   	pop    %ebx
  8023c5:	5e                   	pop    %esi
  8023c6:	5f                   	pop    %edi
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    
  8023c9:	8d 76 00             	lea    0x0(%esi),%esi
  8023cc:	31 ff                	xor    %edi,%edi
  8023ce:	31 c0                	xor    %eax,%eax
  8023d0:	89 fa                	mov    %edi,%edx
  8023d2:	83 c4 1c             	add    $0x1c,%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5f                   	pop    %edi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	89 d8                	mov    %ebx,%eax
  8023de:	f7 f7                	div    %edi
  8023e0:	31 ff                	xor    %edi,%edi
  8023e2:	89 fa                	mov    %edi,%edx
  8023e4:	83 c4 1c             	add    $0x1c,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5f                   	pop    %edi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    
  8023ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023f1:	89 eb                	mov    %ebp,%ebx
  8023f3:	29 fb                	sub    %edi,%ebx
  8023f5:	89 f9                	mov    %edi,%ecx
  8023f7:	d3 e6                	shl    %cl,%esi
  8023f9:	89 c5                	mov    %eax,%ebp
  8023fb:	88 d9                	mov    %bl,%cl
  8023fd:	d3 ed                	shr    %cl,%ebp
  8023ff:	89 e9                	mov    %ebp,%ecx
  802401:	09 f1                	or     %esi,%ecx
  802403:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802407:	89 f9                	mov    %edi,%ecx
  802409:	d3 e0                	shl    %cl,%eax
  80240b:	89 c5                	mov    %eax,%ebp
  80240d:	89 d6                	mov    %edx,%esi
  80240f:	88 d9                	mov    %bl,%cl
  802411:	d3 ee                	shr    %cl,%esi
  802413:	89 f9                	mov    %edi,%ecx
  802415:	d3 e2                	shl    %cl,%edx
  802417:	8b 44 24 08          	mov    0x8(%esp),%eax
  80241b:	88 d9                	mov    %bl,%cl
  80241d:	d3 e8                	shr    %cl,%eax
  80241f:	09 c2                	or     %eax,%edx
  802421:	89 d0                	mov    %edx,%eax
  802423:	89 f2                	mov    %esi,%edx
  802425:	f7 74 24 0c          	divl   0xc(%esp)
  802429:	89 d6                	mov    %edx,%esi
  80242b:	89 c3                	mov    %eax,%ebx
  80242d:	f7 e5                	mul    %ebp
  80242f:	39 d6                	cmp    %edx,%esi
  802431:	72 19                	jb     80244c <__udivdi3+0xfc>
  802433:	74 0b                	je     802440 <__udivdi3+0xf0>
  802435:	89 d8                	mov    %ebx,%eax
  802437:	31 ff                	xor    %edi,%edi
  802439:	e9 58 ff ff ff       	jmp    802396 <__udivdi3+0x46>
  80243e:	66 90                	xchg   %ax,%ax
  802440:	8b 54 24 08          	mov    0x8(%esp),%edx
  802444:	89 f9                	mov    %edi,%ecx
  802446:	d3 e2                	shl    %cl,%edx
  802448:	39 c2                	cmp    %eax,%edx
  80244a:	73 e9                	jae    802435 <__udivdi3+0xe5>
  80244c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80244f:	31 ff                	xor    %edi,%edi
  802451:	e9 40 ff ff ff       	jmp    802396 <__udivdi3+0x46>
  802456:	66 90                	xchg   %ax,%ax
  802458:	31 c0                	xor    %eax,%eax
  80245a:	e9 37 ff ff ff       	jmp    802396 <__udivdi3+0x46>
  80245f:	90                   	nop

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80246b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80246f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802473:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802477:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80247b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80247f:	89 f3                	mov    %esi,%ebx
  802481:	89 fa                	mov    %edi,%edx
  802483:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802487:	89 34 24             	mov    %esi,(%esp)
  80248a:	85 c0                	test   %eax,%eax
  80248c:	75 1a                	jne    8024a8 <__umoddi3+0x48>
  80248e:	39 f7                	cmp    %esi,%edi
  802490:	0f 86 a2 00 00 00    	jbe    802538 <__umoddi3+0xd8>
  802496:	89 c8                	mov    %ecx,%eax
  802498:	89 f2                	mov    %esi,%edx
  80249a:	f7 f7                	div    %edi
  80249c:	89 d0                	mov    %edx,%eax
  80249e:	31 d2                	xor    %edx,%edx
  8024a0:	83 c4 1c             	add    $0x1c,%esp
  8024a3:	5b                   	pop    %ebx
  8024a4:	5e                   	pop    %esi
  8024a5:	5f                   	pop    %edi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    
  8024a8:	39 f0                	cmp    %esi,%eax
  8024aa:	0f 87 ac 00 00 00    	ja     80255c <__umoddi3+0xfc>
  8024b0:	0f bd e8             	bsr    %eax,%ebp
  8024b3:	83 f5 1f             	xor    $0x1f,%ebp
  8024b6:	0f 84 ac 00 00 00    	je     802568 <__umoddi3+0x108>
  8024bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8024c1:	29 ef                	sub    %ebp,%edi
  8024c3:	89 fe                	mov    %edi,%esi
  8024c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	d3 e0                	shl    %cl,%eax
  8024cd:	89 d7                	mov    %edx,%edi
  8024cf:	89 f1                	mov    %esi,%ecx
  8024d1:	d3 ef                	shr    %cl,%edi
  8024d3:	09 c7                	or     %eax,%edi
  8024d5:	89 e9                	mov    %ebp,%ecx
  8024d7:	d3 e2                	shl    %cl,%edx
  8024d9:	89 14 24             	mov    %edx,(%esp)
  8024dc:	89 d8                	mov    %ebx,%eax
  8024de:	d3 e0                	shl    %cl,%eax
  8024e0:	89 c2                	mov    %eax,%edx
  8024e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024e6:	d3 e0                	shl    %cl,%eax
  8024e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024f0:	89 f1                	mov    %esi,%ecx
  8024f2:	d3 e8                	shr    %cl,%eax
  8024f4:	09 d0                	or     %edx,%eax
  8024f6:	d3 eb                	shr    %cl,%ebx
  8024f8:	89 da                	mov    %ebx,%edx
  8024fa:	f7 f7                	div    %edi
  8024fc:	89 d3                	mov    %edx,%ebx
  8024fe:	f7 24 24             	mull   (%esp)
  802501:	89 c6                	mov    %eax,%esi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	39 d3                	cmp    %edx,%ebx
  802507:	0f 82 87 00 00 00    	jb     802594 <__umoddi3+0x134>
  80250d:	0f 84 91 00 00 00    	je     8025a4 <__umoddi3+0x144>
  802513:	8b 54 24 04          	mov    0x4(%esp),%edx
  802517:	29 f2                	sub    %esi,%edx
  802519:	19 cb                	sbb    %ecx,%ebx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802521:	d3 e0                	shl    %cl,%eax
  802523:	89 e9                	mov    %ebp,%ecx
  802525:	d3 ea                	shr    %cl,%edx
  802527:	09 d0                	or     %edx,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	d3 eb                	shr    %cl,%ebx
  80252d:	89 da                	mov    %ebx,%edx
  80252f:	83 c4 1c             	add    $0x1c,%esp
  802532:	5b                   	pop    %ebx
  802533:	5e                   	pop    %esi
  802534:	5f                   	pop    %edi
  802535:	5d                   	pop    %ebp
  802536:	c3                   	ret    
  802537:	90                   	nop
  802538:	89 fd                	mov    %edi,%ebp
  80253a:	85 ff                	test   %edi,%edi
  80253c:	75 0b                	jne    802549 <__umoddi3+0xe9>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f7                	div    %edi
  802547:	89 c5                	mov    %eax,%ebp
  802549:	89 f0                	mov    %esi,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	f7 f5                	div    %ebp
  80254f:	89 c8                	mov    %ecx,%eax
  802551:	f7 f5                	div    %ebp
  802553:	89 d0                	mov    %edx,%eax
  802555:	e9 44 ff ff ff       	jmp    80249e <__umoddi3+0x3e>
  80255a:	66 90                	xchg   %ax,%ax
  80255c:	89 c8                	mov    %ecx,%eax
  80255e:	89 f2                	mov    %esi,%edx
  802560:	83 c4 1c             	add    $0x1c,%esp
  802563:	5b                   	pop    %ebx
  802564:	5e                   	pop    %esi
  802565:	5f                   	pop    %edi
  802566:	5d                   	pop    %ebp
  802567:	c3                   	ret    
  802568:	3b 04 24             	cmp    (%esp),%eax
  80256b:	72 06                	jb     802573 <__umoddi3+0x113>
  80256d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802571:	77 0f                	ja     802582 <__umoddi3+0x122>
  802573:	89 f2                	mov    %esi,%edx
  802575:	29 f9                	sub    %edi,%ecx
  802577:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80257b:	89 14 24             	mov    %edx,(%esp)
  80257e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802582:	8b 44 24 04          	mov    0x4(%esp),%eax
  802586:	8b 14 24             	mov    (%esp),%edx
  802589:	83 c4 1c             	add    $0x1c,%esp
  80258c:	5b                   	pop    %ebx
  80258d:	5e                   	pop    %esi
  80258e:	5f                   	pop    %edi
  80258f:	5d                   	pop    %ebp
  802590:	c3                   	ret    
  802591:	8d 76 00             	lea    0x0(%esi),%esi
  802594:	2b 04 24             	sub    (%esp),%eax
  802597:	19 fa                	sbb    %edi,%edx
  802599:	89 d1                	mov    %edx,%ecx
  80259b:	89 c6                	mov    %eax,%esi
  80259d:	e9 71 ff ff ff       	jmp    802513 <__umoddi3+0xb3>
  8025a2:	66 90                	xchg   %ax,%ax
  8025a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025a8:	72 ea                	jb     802594 <__umoddi3+0x134>
  8025aa:	89 d9                	mov    %ebx,%ecx
  8025ac:	e9 62 ff ff ff       	jmp    802513 <__umoddi3+0xb3>
