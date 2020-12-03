"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.InputState'
	instanceVariableNames: 'inputSemaphore idler idleTimer main windows deferredActions lastWindow wakeupEvent msgWindow queueStatusMask'
	classVariableNames: 'EnumHandlesDescriptor MaxIdleSleep SamplingInterval UserInterruptSignal'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.InputState guid: (Core.GUID fromString: '{87b4c494-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.InputState comment: '<InputState> is a singleton responsible for managing the windows message loop and related <Process>es.

Instance Variables:
	inputSemaphore	<Semaphore> on which the UI process blocks when the idle (i.e. when message loop is empty).
	idler			<Process>. The idle process responsible for relinquishing control to Windows when no other Smalltalk <Process>es are ready to run.
	idleTimer		<WeakArray> holding <window> currently hosting WM_TIMER used to keep background processing operational when running Windows modal msg loops such as those for common dialogs.
	main			<Process>. The current main UI process.
	windows		<LookupTable> of <Integer>. Map of window handles to associated Smalltalk windows (usually <View>s).
	deferredActions	<SharedQueue> of <niladicValuable>. Actions to be processed by the main process when the message loop is empty.
	lastWindow	<window> that last received a message (cached because most likely to receive next message too).
	wakeupEvent	<ExternalHandle> of Win32 Event object signalled by the VM when it wants the image to wake up.
	msgWindow	<PostedActionWindow> 

Class Variables:
	EnumHandlesDescriptor	<ExternalDescriptor>. Callback descriptor for EnumWindows.
	UserInterruptSignal		<Signal>. Exception raised when Break key combination is pressed.
	SamplingInterval		<SmallInteger> approximate millisecond interval between tests of system input queue for host system messsages when running background processes.
'!
!Kernel.InputState categoriesForClass!Kernel-Support! !
!Kernel.InputState methodsFor!

aboutToForkUI
	"Private - A new main UI process is being started. Reset any global UI state."
!

aboutToIdle
	"The message loop is about to go to sleep - perform any actions necessary before that
	happens. We inform all views so that they may perform idle time updating of their user
	interfaces. Note that this is called from the main UI process, NOT the idle process."

		"Make sure we have at least one process (the idle process) to run"

	self uiIdle ifFalse: [^self].
	self
		ensureIdlerRunning;
		keepAlive.
		"Publish that the UI is about to go idle"
	self trigger: #aboutToIdle!

consoleStartup
	"Private - System startup has entered the second stage, and it is time to reinitialize the
	user interaction subsystem for a console session."

	windows := LookupTable new.
	self createPostedActionWindow.
	"#aboutToIdle will not be invoked, so best to to start the idler manually as otherwise an
	idlePanic interrupt will be sent by the VM"
	self ensureIdlerRunning!

createAndRegisterInputSemaphore
	"Private - Create the input semaphore and register it with the VM to be signalled when input
	is available for the Main UI Process."

	inputSemaphore := Semaphore new.
	VMLibrary default registryAt: #InputSemaphore put: inputSemaphore!

createAndRegisterWakeupEvent
	"Private - Create and register the Win32 Event object that is signalled by the VM when it
	wants to wake up the image from an idle state (i.e. from its call to
	MsgWaitForMultipleObjects[Ex])."

	wakeupEvent := KernelLibrary default
				createEvent: nil
				bManualReset: false
				bInitialState: false
				lpName: nil.
	VMLibrary default registryAt: #WakeupEvent put: wakeupEvent!

createPostedActionWindow
	| hWnd |
	hWnd := VMLibrary default registryAt: #MsgWndHandle.
	msgWindow := PostedActionWindow new
				handle: hWnd;
				yourself.
	self windowAt: hWnd put: msgWindow!

deferredActions
	^deferredActions!

ensureIdlerRunning
	"Private - Ensure that the idle process is still running, and if not restart it."

	idler isNil ifTrue: [self forkIdler].
	idler isReady ifFalse: [idler terminate. "auto reforks"]
	!

ensureMainRunning
	main notNil
		ifTrue: 
			[main suspendingList == inputSemaphore ifTrue: [^self].
			main isAlive
				ifTrue: 
					["Check for user break"
					VMLibrary default isUserBreakRequested ifTrue: [main queueInterrupt: Processor userBreakInterrupt].
					^self]].
	self forkMain!

enterIdle
	"Private - Put the current active process to sleep on the inputSemaphore. This is intended
	to provide an opportunity for background processes to run. Use with care."

	self inputSemaphore wait!

forkIdler
	"Private - Start a process at the lowest possible priority (system background) to perform
	idle time processing. The VM scheduler requires that there always be a process ready to run,
	and the system idle process is that process. It is designed to put Dolphin to sleep in a
	CPU-cycle friendly manner by calling the Win32 function MsgWaitForMultipleObjects() to put
	the main Dolphin thread to sleep. Should the system idle process die for some reason, then
	another is normally started by the dying idler. If this mechanism fails, then the VM will
	send an Idle Panic interrupt to whatever was the last active process, regardless of its
	state. See ProcessorScheduler>>idlePanic: for further details. The system idle process is
	not the appropriate place to perform background processing; simply fork a further Process at
	#userBackgroundPriority. It is important that any background processes run at a priority
	below #userSchedulingPriority, or Windows message starvation could occur."

	idler := (
			["Notification signal: self class name, ': Starting Idler process...'."
			
			[[self idleLoop] on: self userInterruptSignal
				do: 
					[:s | 
					"Assume user really wants to interrupt main UI process"
					self main queueInterrupt: Processor userBreakInterrupt.
					"Must explicitly resume to continue idle loop"
					s resume]] 
					ifCurtailed: 
						["If the idler terminates for some reason, start another"
						Processor activeProcess == idler ifTrue: [self forkIdler]]] 
					forkAt: Processor systemBasePriority
					maxStack: 16384)
				name: 'Idler';
				yourself!

forkMain
	"Private - Start a new Main process at user scheduling priority, which runs until another
	Process asserts that it is the Main process. Any existing main process will terminate.
	Answer the new process."

	self aboutToForkUI.
	(
	[main := Processor activeProcess.
	self mainLoop] forkAt: Processor userSchedulingPriority)
		name: 'Main';
		yourself!

hasVisibleWindows
	"Private - Answer whether there are any visible windows belonging to the current session
	still open."

	"Implementation Note: We use the bare metal UserLibrary functions to avoid any dependency on
	the existing View classes. This might be important to those wanting to implement their own
	window class hierarchy."

	| hDesktop user |
	user := UserLibrary default.
	hDesktop := user getDesktopWindow.
	^windows anySatisfy: 
			[:each |
			| hWnd |
			hWnd := each asParameter.
			hWnd notNil and: [hWnd ~= hDesktop and: [(user isWindow: hWnd) and: [user isWindowVisible: hWnd]]]]!

idle
	"Private - Put the VM thread to sleep until there are messages from the host system, or a
	timer fires, to prevent unecessary consumption of host system time. This is called from the
	idle Process."

	"Implementation Note: This implementation is only suitable for platforms that correctly
	support MsgWaitForMultipleObjectsEx() with the MWMO_ALERTABLE flag,"

	MemoryManager current aboutToIdle.
	"Disable background sampling while sleeping"
	self primSampleInterval: -1.
	UserLibrary default
		msgWaitForMultipleObjectsEx: 1
		pHandles: wakeupEvent
		dwMilliseconds: MaxIdleSleep
		dwWakeMask: queueStatusMask
		dwFlags: MWMO_ALERTABLE.
	"Rather than use the return value from MsgWaitForMultipleObjectsEx() we call
	GetQueueStatus(). This has the effect of clearing the 'new message' flag so that the next
	call to MsgWaitFor&c will not return immediately if the UI loop is blocked for some reason
	and so is not calling PeekMessage/GetMessage (which also clear the flag). This prevents
	short-cycling where the idle process goes into a tight loop calling MsgWaitFor&c when the
	main UI process is put to sleep."
	self isInputAvailable
		ifTrue: 
			[self ensureMainRunning.
			inputSemaphore set]!

idleLoop
	"Private - Repeatedly perform system idle processing (this is the control loop of the Idler
	process). This loop is intended for system idle processing only, and should be kept simple
	to avoid instability. Perform user background processing in a background process forked for
	the purpose."

	[Processor activeProcess == idler] whileTrue: [self idle]!

idlePanic
	"Private - The Processor is panicking because it can't find any processes which are prepared
	to run. This has probably happened due to a deadlock, so terminate the existing idler in an
	attempt to continue. In order not to terminate the current active process, fork off a new
	one to do the termination, at the highest possible priority. When we kill the idler it will
	get restarted by its termination handler, will notice that the main process is dead, and
	restart that too if necessary."

	[self forkIdler] forkAt: Processor timingPriority!

idler
	"Private - Answer the Idle Process."

	^idler!

initializeFrom: anInputState
	anInputState isNil
		ifTrue: 
			[deferredActions := SharedQueue new.
			windows := LookupTable new]
		ifFalse: 
			[deferredActions := anInputState deferredActions.
			windows := anInputState windows.
			anInputState main: nil.
			anInputState idler ifNotNil: [:process | process kill]].
	idleTimer := WeakArray with: DeadObject current.
	self
		createAndRegisterWakeupEvent;
		registerAsDispatcher;
		createAndRegisterInputSemaphore;
		setSamplingInterval: 60.
	queueStatusMask := KernelLibrary default inputQueueMask!

inputSemaphore
	"Private - Answer the queue empty/not-empty semaphore"

	^inputSemaphore!

isInputAvailable
	"Private - Answer whether there is any input waiting in the Windows message queue. Note that
	a true answer does not guarantee that a call to GetMessage() will not block, since
	pre-processing may remove the messages, therefore this is only an indication that
	GetMessage() may need to be called (see also #isInputReady:)."

	"Implementation Note: We want to see if any input is available, not just what new input has
	arrived since the last call to GetMessage, PeekMessage, or GetQueueStatus, so we have to
	test against the high word."

	^(UserLibrary default getQueueStatus: queueStatusMask) anyMask: (queueStatusMask bitShift: 16)!

isInputReady: aMSG
	"Private - Answer whether there is currently a message waiting in the host system queue (if
	there is, it is peeked into the argument, aMSG). Reset the VM sample interval too. Does not
	signal the inputSemaphore, which is left to the caller to do when appropriate."

	"Implementation Note: We must use PeekMessage() rather than GetQueueStatus() because the
	latter provides only an indication that a certain sort of input is available, and does not
	guarantee that a subsequent call to GetMessage() will not block. Since blocking on
	GetMessage() would prevent Dolphin's background green threads from getting any CPU time, we
	have to peek with the no-remove flag so that if this method answers true it is guaranteed
	that GetMessage() can be called without it blocking."

	self primSampleInterval: SamplingInterval.
	^UserLibrary default
		peekMessage: aMSG
		hWnd: 0
		uMsgFilterMin: 0
		uMsgFilterMax: 0
		wRemoveMsg: PM_NOREMOVE!

keepAlive
	"Private - Stay-alive test. Sent during idle time to determine if the session needs to stay
	alive. Detects headless condition and reports to the session manager."

	self hasVisibleWindows ifFalse: [SessionManager current noVisibleWindows]!

loopWhile: aBlock
	"Pump messages until the <niladicValuable> argument evaluates to false."

	"Implementation Note: Host system events are processed at a higher priority to deferred
	actions. A single message/action is processed before testing again to see if the loop should
	be terminated. A single deferred action is processed between each test to see if there are
	further Windows messages. Generally however the Windows message queue remains empty for long
	periods, and all deferred messages will be quickly processed. When both queues are empty the
	active process (which should be the UI process) will yield control to lower priority
	processes, in particular the idle process which is responsible for quiescing the whole
	system."

	| msg activity |
	msg := MSG new.
	activity := false.
	
	[
	[aBlock value ifFalse: [^self].
	self isInputReady: msg] whileTrue: 
				[activity := true.
				self pumpMessage: msg].
	"The PostedActionWindow should evaluate all posted actions in the message pump, but for
	robustness ensure it does not accumulate a backlog of actions as this would cause very
	strange behaviour."
	msgWindow evaluatePendingActions ifTrue: [activity := true].
	deferredActions nextNoWait
		ifNil: 
			[self waitForInput: activity.
			activity := false]
		ifNotNil: 
			[:action |
			activity := true.
			action value]]
			repeat!

main
	"Private - Answer the Main Process"

	^main!

main: aProcess
	"Private - Set the Main Process to be the argument, aProcess. Any existing main process will
	drop out of its message loop."

	main := aProcess!

mainLoop
	"Private - Pump messages until the another process assumes the role of main message loop."

	self loopWhile: [main == Processor activeProcess]
!

millisecondClockValue
	"Private - Answer the current value of the system millisecond clock."

	"Implementation Note: Primitive 174 is actually just a call to the QueryPerformanceCounter
	API which should be accurate sub-1mS (unlike GetTickCount() which is only accurate to 10mS),
	and which also does not suffer the problem of wrapping after ~49 days of uptime."

	<primitive: 174>
	^self primitiveFailed: _failureCode!

msgWindow
	^msgWindow!

onExit
	"Private - The system is closing down, release system resources."

	KernelLibrary default closeHandle: wakeupEvent!

postAction: aNiladicValuable 
	"Queue a niladic valuable (e.g. a MessageSend or niladic block) for deferred evaluation from
	in synchronisation with the message queue (i.e. it is effectively posted to the message queue)"

	msgWindow postAction: aNiladicValuable!

postQuit: anInteger
	"Private - Initiate graceful system shutdown with the appropriate Windows API call."

	UserLibrary default postQuitMessage: anInteger!

preTranslateMessage: aMSG
	"Private - Pre-dispatch message filter. Answers true if some window consumed the message, or
	false to have message dispatched as normal."

	| handle |
	handle := aMSG hwnd.
	[handle isNull] whileFalse: 
			[(self windowAt: handle ifAbsent: [])
				ifNotNil: [:window | (window preTranslateMessage: aMSG) ifTrue: [^true]].
			handle := UserLibrary default getParent: handle].
	^false!

primSampleInterval: anInteger
	"Private - Set the interval (measured in milliseconds) between polls of the host system input queue when running background processes. After at least the polling interval (on average 1.5 times the interval) following the last invocation of #isInputReady, or the dispatch of the last message through the VM window proc, the VM will test the queue, and will signal the inputSemaphore if there is any input ready. If anInteger is 0, the sample counter is reset to the current sampling interval value (which is answered)."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger."

	"Notes:

	1) The sampling interval only comes into play when running CPU intensive background Processes - it has no significance if you never run lengthy computations in background Processes.

	2) It determines the frequency with which the VM samples the Windows message queue and checks for Ctrl+Break.

	3) During normal operation the sampling is suppressed by the main thread's message loop (in fact by it calling #isInputReady:, and by the arrival of messages dispatched through the VM's window procedure..

	4) The choice of sampling interval is a trade off between best performance and responsiveness when running CPU intensive background tasks continually. Increasing the value may give a slight performance boost, but it will probably not be significant. Reducing the value can improve responsiveness, but if it is reduced much below about 30mS then the cost will start to become measurable.

	4) The sampling can be turned off completely by specifying a value of -1 to #primSampleInterval:, but this will disable CTRL+BREAK, and switching away from background processes, so this should be done programmatically for short periods only."

	<primitive: 94>
	^self primitiveFailed: _failureCode!

processDeferredActions
	"Process all deferred actions. Normally these are processed one at a time when the message
	queue is found to be empty by the main UI process, but this message can be sent to empty the
	deferred actions queue if desired."

	| deferred |
	[(deferred := deferredActions nextNoWait) isNil] whileFalse: [deferred value]!

prod
	"Prod the message loop into life if sent from a background process. Useful when a background
	process does something with visual effect that would not be seen unless the message loop
	comes to life."

	Processor activeProcess == main ifFalse: [self inputSemaphore signal]!

pumpMessage: aMSG
	"Private - Read and dispatch the first pending host system message. If a WM_QUIT is
	received, then exit Smalltalk."

	(UserLibrary default
		getMessage: aMSG
		hWnd: 0
		wMsgFilterMin: 0
		wMsgFilterMax: 0) == 0
		ifTrue: [SessionManager current onQuit: aMSG swParam]
		ifFalse: 
			[(self preTranslateMessage: aMSG)
				ifFalse: 
					[UserLibrary default
						translateMessage: aMSG;
						dispatchMessage: aMSG]]!

pumpMessages
	"Read and dispatch any pending host system messages until the queue is empty. If a WM_QUIT
	is received, then exit Smalltalk. This can be used from user code to empty the message queue
	if necessary."

	Processor isActiveMain
		ifTrue: 
			[| msg |
			msg := MSG new.
			self loopWhile: [self isInputReady: msg]]
		ifFalse: [self prod]!

purgeDeadWindows
	"Remove any windows in the windows collection which have a NULL handle. In normal use there
	will be no such windows, but as a result of errors, debugging sessions, etc, these can
	arise, so this message is provided to be used to purge any such zombies."

	| bEnabled |
	bEnabled := Processor enableAsyncEvents: false.
	windows := windows select: 
					[:each |
					| hWnd |
					(hWnd := each asParameter) notNil and: [UserLibrary default isWindow: hWnd]].
	lastWindow := nil.
	Processor enableAsyncEvents: bEnabled!

queueDeferredAction: operation
	"Queue a niladic valuable (e.g. a MessageSend or niladic block) for deferred evaluation from
	the message pump when the Windows message queue is empty."

	"Implementation Note: We must signal the input semaphore or the action may end up hanging
	around until the next windows message arrives if the main process is currently idle (i.e.
	this is not the main process, or does not return to the message loop)."

	deferredActions nextPut: operation.
	inputSemaphore set!

registerAsDispatcher
	"Private - Notify the VM that the receiver should receive callbacks via the WndProc().
		SessionManager inputState registerAsDispatcher
	"

	VMLibrary default registryAt: #Dispatcher put: self!

removeWindowAt: aHandle 
	"Private - Unregister a Window object with the specified handle."

	"Implementation Note: Interrupts are disabled to prevent concurrent access to the windows
	collection without the possibility of deadlock."

	| bEnabled |
	aHandle isNil ifTrue: [^self].
	bEnabled := Processor enableAsyncEvents: false.
	windows removeKey: aHandle asInteger ifAbsent: [].
	lastWindow := nil.
	Processor enableAsyncEvents: bEnabled!

setSamplingInterval: anInteger 
	"Private - Set sampling interval. This is the approximate interval, in milliseconds, at
	which the system will sample the input queue and check for the Break key combination when
	running computationally expensive tasks in background threads."

	SamplingInterval := anInteger.
	self primSampleInterval: SamplingInterval!

startIdleTimer: aView
	"Private - Start the idle timer (e.g. when a menu is popped), hosted by the window, aView,
	which must respond to #asParameter by answering its window handle (it need not be a View).
	If the idle timer is already active then this do nothing."

	
	[| idleHost hWnd |
	idleHost := idleTimer basicAt: 1.
	hWnd := aView asParameter.
	(idleHost == DeadObject current or: [hWnd isNull or: [(UserLibrary default isWindow: hWnd) not]])
		ifTrue: 
			[idleTimer basicAt: 1 put: aView.
			UserLibrary default
				setTimer: hWnd
				nIDEvent: WM_ENTERIDLE
				uElapse: 100
				lpTimerFunc: nil]]
			critical!

stopIdleTimer: aView
	"Private - Stop the idle timer hosted by the specified window. If the idle timer is not
	actually hosted by aView, then do nothing."

	
	[| idleHost |
	idleHost := idleTimer basicAt: 1.
	idleHost == aView
		ifTrue: 
			[idleTimer basicAt: 1 put: DeadObject current.
			UserLibrary default killTimer: aView asParameter uIDEvent: WM_ENTERIDLE]]
			critical!

topLevelWindows
	"Answer an unordered <Collection> containing all top level windows belonging to the Dolphin process."

	^#()!

uiIdle
	"Private - The application is about to go idle."

	^true!

userInterruptSignal
	"Answer the user interrupt <Signal>."

	UserInterruptSignal isNil
		ifTrue: [UserInterruptSignal := Signal resumableDescription: 'User Interrupt'].
	^UserInterruptSignal!

waitForInput: aBoolean 
	"Private - The input queues are empty, so quiesce the main process to avoid consuming CPU
	cycles unecessarily, and to provide an opportunity for background processes to run. Before
	putting the main process to sleep (this method should only be invoked by the UI process) on
	the inputSemaphore, various pre-idle activities may be performed before, depending on
	whether any input has been processed since the UI process last woke up, as indicated by the
	<boolean> argument."

	aBoolean ifTrue: [self aboutToIdle].
	self inputSemaphore wait!

windowAt: aHandle ifAbsent: exceptionHandler
	"Answers an open window that has a handle of aHandle (an Integer or ExternalHandle). If the
	handle is nil, then answers nil."

	| hWnd wasEnabled window |
	aHandle isNil ifTrue: [^exceptionHandler value].
	hWnd := aHandle asInteger.
	wasEnabled := Processor enableAsyncEvents: false.
	window := windows lookup: hWnd.
	Processor enableAsyncEvents: wasEnabled.
	^window ifNil: [exceptionHandler value]!

windowAt: aHandle put: aWindow 
	"Register a Window object (which understands #dispatchMessage:) with the specified handle."

	| wasEnabled hWnd |
	hWnd := aHandle asInteger.
	wasEnabled := Processor enableAsyncEvents: false.
	windows at: hWnd put: aWindow.
	lastWindow := nil.
	Processor enableAsyncEvents: wasEnabled!

windows
	"Private - Answer the collection of all open windows (a <LookupTable> mapping <integer>
	window handles to <windows>."

	^windows!

wndProc: hWnd message: message wParam: wParam lParam: lParam cookie: cookie
	"Private - Dispatch a Windows message to the appropriate event handler of the view whose
	handle is hWnd. If the window handle is not registered, then the default window procedure is
	invoked."

	"WARNING: This method is an entry point from the VM, and must not be invoked from Smalltalk
	code, as it returns directly to the VM as if from a callback. Do not modify or remove this
	method."

	"Implementation Note: The VM sends this message with asynchronous process switching
	disabled."

	| window |
	lastWindow asParameter = hWnd
		ifTrue: [window := lastWindow]
		ifFalse: 
			[window := windows lookup: hWnd.
			window isNil
				ifTrue: 
					[^Processor callback: cookie
						evaluate: 
							[UserLibrary default
								defWindowProc: hWnd
								msg: message
								wParam: wParam
								lParam: lParam]]
				ifFalse: [lastWindow := window]].
	^Processor
		enableAsyncEvents: true;
		callback: cookie
			return: ([(window
					dispatchMessage: message
					wParam: wParam
					lParam: lParam) asUIntPtr]
					ifCurtailed: [Processor unwindCallback: cookie])! !
!Kernel.InputState categoriesFor: #aboutToForkUI!idling!private! !
!Kernel.InputState categoriesFor: #aboutToIdle!idling!public! !
!Kernel.InputState categoriesFor: #consoleStartup!operations-startup!private! !
!Kernel.InputState categoriesFor: #createAndRegisterInputSemaphore!initializing!private! !
!Kernel.InputState categoriesFor: #createAndRegisterWakeupEvent!initializing!private! !
!Kernel.InputState categoriesFor: #createPostedActionWindow!initializing!private! !
!Kernel.InputState categoriesFor: #deferredActions!accessing!private! !
!Kernel.InputState categoriesFor: #ensureIdlerRunning!idling!private! !
!Kernel.InputState categoriesFor: #ensureMainRunning!idling!private! !
!Kernel.InputState categoriesFor: #enterIdle!idling!private! !
!Kernel.InputState categoriesFor: #forkIdler!idling!private! !
!Kernel.InputState categoriesFor: #forkMain!message dispatching!private! !
!Kernel.InputState categoriesFor: #hasVisibleWindows!private!testing! !
!Kernel.InputState categoriesFor: #idle!idling!private! !
!Kernel.InputState categoriesFor: #idleLoop!idling!private! !
!Kernel.InputState categoriesFor: #idlePanic!idling!private! !
!Kernel.InputState categoriesFor: #idler!idling!private! !
!Kernel.InputState categoriesFor: #initializeFrom:!initializing!private! !
!Kernel.InputState categoriesFor: #inputSemaphore!accessing!private! !
!Kernel.InputState categoriesFor: #isInputAvailable!idling!private! !
!Kernel.InputState categoriesFor: #isInputReady:!message dispatching!private! !
!Kernel.InputState categoriesFor: #keepAlive!idling!private! !
!Kernel.InputState categoriesFor: #loopWhile:!message dispatching!public! !
!Kernel.InputState categoriesFor: #main!accessing!private! !
!Kernel.InputState categoriesFor: #main:!initializing!private! !
!Kernel.InputState categoriesFor: #mainLoop!message dispatching!private! !
!Kernel.InputState categoriesFor: #millisecondClockValue!enquiries!private! !
!Kernel.InputState categoriesFor: #msgWindow!accessing!private! !
!Kernel.InputState categoriesFor: #onExit!event handling!private! !
!Kernel.InputState categoriesFor: #postAction:!message dispatching!public! !
!Kernel.InputState categoriesFor: #postQuit:!operations-shutdown!private! !
!Kernel.InputState categoriesFor: #preTranslateMessage:!message dispatching!private! !
!Kernel.InputState categoriesFor: #primSampleInterval:!message dispatching!private! !
!Kernel.InputState categoriesFor: #processDeferredActions!operations!public! !
!Kernel.InputState categoriesFor: #prod!message dispatching!public! !
!Kernel.InputState categoriesFor: #pumpMessage:!message dispatching!private! !
!Kernel.InputState categoriesFor: #pumpMessages!message dispatching!public! !
!Kernel.InputState categoriesFor: #purgeDeadWindows!public!removing! !
!Kernel.InputState categoriesFor: #queueDeferredAction:!message dispatching!public! !
!Kernel.InputState categoriesFor: #registerAsDispatcher!initializing!private! !
!Kernel.InputState categoriesFor: #removeWindowAt:!accessing!private! !
!Kernel.InputState categoriesFor: #setSamplingInterval:!initializing!private! !
!Kernel.InputState categoriesFor: #startIdleTimer:!idling!private! !
!Kernel.InputState categoriesFor: #stopIdleTimer:!idling!private! !
!Kernel.InputState categoriesFor: #topLevelWindows!enumerating!public! !
!Kernel.InputState categoriesFor: #uiIdle!idling!private! !
!Kernel.InputState categoriesFor: #userInterruptSignal!constants!public! !
!Kernel.InputState categoriesFor: #waitForInput:!idling!private! !
!Kernel.InputState categoriesFor: #windowAt:ifAbsent:!accessing!public! !
!Kernel.InputState categoriesFor: #windowAt:put:!accessing!public! !
!Kernel.InputState categoriesFor: #windows!accessing!private! !
!Kernel.InputState categoriesFor: #wndProc:message:wParam:lParam:cookie:!message dispatching!not restartable!private!vm entry points! !

!Kernel.InputState class methodsFor!

initialize
	SamplingInterval := 16384.
	EnumHandlesDescriptor := External.Descriptor fromString: 'stdcall: dword handle dword'.
	MaxIdleSleep := 15000!

maxIdleSleep
	^MaxIdleSleep!

maxIdleSleep: aSmallInteger 
	MaxIdleSleep := aSmallInteger!

newFromOld: anInputState 
	^(self new)
		initializeFrom: anInputState;
		yourself! !
!Kernel.InputState class categoriesFor: #initialize!development!initializing!public! !
!Kernel.InputState class categoriesFor: #maxIdleSleep!accessing!public! !
!Kernel.InputState class categoriesFor: #maxIdleSleep:!accessing!public! !
!Kernel.InputState class categoriesFor: #newFromOld:!instance creation!private! !

