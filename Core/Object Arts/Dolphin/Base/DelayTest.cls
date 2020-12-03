"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DelayTest
	instanceVariableNames: 'delay startTime'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DelayTest guid: (GUID fromString: '{0b7c6875-1051-4b80-b137-cd1c02754bcd}')!
DelayTest comment: ''!
!DelayTest categoriesForClass!Unclassified! !
!DelayTest methodsFor!

expectDelay: expectedMilliseconds for: nowMicroseconds
	| elapsed delta |
	elapsed := nowMicroseconds - startTime.
	delta := (elapsed - (expectedMilliseconds * 1000)) abs.
	self assert: delta < 2000
		description: ('Expected delay of <1d>ms, got <2d>ms' expandMacrosWith: expectedMilliseconds
				with: (elapsed // 100 / 10 asScaledDecimal: 1))!

setUp
	super setUp.
	startTime := Time microsecondClockValue.
	Delay resolution: 1 milliseconds set: true!

tearDown
	Delay resolution: 1 milliseconds set: false.
	super tearDown!

testBasicWait
	delay := Delay forMilliseconds: 20.
	delay wait.
	self expectDelay: 20 for: Time microsecondClockValue!

testCancel
	| proc endTime |
	delay := Delay forMilliseconds: 20.
	proc := 
			[delay wait.
			endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	
	[delay cancel.
	self deny: Delay.Current == delay.
	self deny: (Delay.Pending includes: delay).
	(Delay forMilliseconds: 30) wait.
	self assertIsNil: endTime.
	self assert: proc isWaiting]
			ensure: [proc terminate]!

testCancelWithOtherShorterDelay
	[(Delay forMilliseconds: 10) wait] forkAt: Processor userInterruptPriority.
	self testCancel!

testSchedulingMultipleDelays
	| endTime |
	delay := Delay forMilliseconds: 20.
	
	[delay wait.
	endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	(Delay forMilliseconds: 30) wait.
	self expectDelay: 20 for: endTime.
	self expectDelay: 30 for: Time microsecondClockValue!

testSchedulingMultipleDelaysLongerFirst
	| endTime |
	delay := Delay forMilliseconds: 30.
	
	[delay wait.
	endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	"Wait for a shorter period than the other process"
	(Delay forMilliseconds: 20) wait.
	"We should have waited for the correct time, other proc is still waiting"
	self expectDelay: 20 for: Time microsecondClockValue.
	self assertIsNil: endTime.
	"Now wait long enough for it to be done"
	(Delay forMilliseconds: 20) wait.
	self expectDelay: 30 for: endTime.
	self expectDelay: 40 for: Time microsecondClockValue!

testSignal
	| endTime |
	delay := Delay forMilliseconds: 20.
	
	[delay wait.
	endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	(Delay forMilliseconds: 10) wait.
	delay signal.
	self expectDelay: 10 for: endTime!

testSimultaneousWaitAndSignal
	| waitError signalError signalFinished endTime |
	delay := Delay forMilliseconds: 20.
	signalFinished := false.
	Delay.AccessProtect wait.	"Ensure that the Delay wait will be blocked"
	
	[[delay wait] on: Error do: [:ex | waitError := ex].
	endTime := Time microsecondClockValue] fork.	"Delay>>wait will calc a resumption time, then block"
	
	[[delay signal] on: Error do: [:ex | signalError := ex].
	signalFinished := true]
			forkAt: Processor userInterruptPriority.	"Will block on AccessProtect in #cancel too, but higher priority"
	Delay.AccessProtect signal.	"Allow the bug to unfold"
	KernelLibrary default sleep: 10.	"Wait for both processes above to finish, without using the Delay mechanism"
	self expectDelay: 0 for: endTime.	"Process should not have actually waited on the delay"
	self assertIsNil: waitError.
	self assert: signalFinished.
	self assertIsNil: signalError!

testSimultaneousWaitAndSignalWithOtherLongerDelay
	[(Delay forMilliseconds: 25) wait] forkAt: Processor userInterruptPriority.
	self testSimultaneousWaitAndSignal!

testSimultaneousWaitAndSignalWithOtherShorterDelay
	[(Delay forMilliseconds: 15) wait] forkAt: Processor userInterruptPriority.
	self testSimultaneousWaitAndSignal! !
!DelayTest categoriesFor: #expectDelay:for:!helpers!private! !
!DelayTest categoriesFor: #setUp!private!running! !
!DelayTest categoriesFor: #tearDown!private!running! !
!DelayTest categoriesFor: #testBasicWait!public!unit tests! !
!DelayTest categoriesFor: #testCancel!public!unit tests! !
!DelayTest categoriesFor: #testCancelWithOtherShorterDelay!public!unit tests! !
!DelayTest categoriesFor: #testSchedulingMultipleDelays!public!unit tests! !
!DelayTest categoriesFor: #testSchedulingMultipleDelaysLongerFirst!public!unit tests! !
!DelayTest categoriesFor: #testSignal!public!unit tests! !
!DelayTest categoriesFor: #testSimultaneousWaitAndSignal!public!unit tests! !
!DelayTest categoriesFor: #testSimultaneousWaitAndSignalWithOtherLongerDelay!public!unit tests! !
!DelayTest categoriesFor: #testSimultaneousWaitAndSignalWithOtherShorterDelay!public!unit tests! !

