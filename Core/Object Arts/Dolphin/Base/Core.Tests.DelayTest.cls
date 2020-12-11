"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.DelayTest'
	instanceVariableNames: 'delay startTime'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DelayTest guid: (Core.GUID fromString: '{0b7c6875-1051-4b80-b137-cd1c02754bcd}')!
Core.Tests.DelayTest comment: ''!
!Core.Tests.DelayTest categoriesForClass!Unclassified! !
!Core.Tests.DelayTest methodsFor!

expectDelay: expectedDuration for: nowMicroseconds
	| elapsed delta |
	elapsed := nowMicroseconds - startTime.
	delta := elapsed - expectedDuration asMicroseconds.
	"Although a Delay could end up waiting much longer than the expected duration,
	e.g. if the CPU is very busy, this should happen only rarely, and we do not want
	to tolerate it if it happens all the time as that would indicate an actual bug."
	self assert: (delta > -1000 and: [delta < 3000])
		description: ('Expected delay of <1d>ms, got <2d>ms' expandMacrosWith: expectedDuration
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
	self expectDelay: 20 milliseconds for: Time microsecondClockValue!

testCancel
	| proc endTime |
	delay := Delay forMilliseconds: 20.
	proc := 
			[delay wait.
			endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	
	[delay cancel.
	self deny: Delay.Current identicalTo: delay.
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
	self expectDelay: 20 milliseconds for: endTime.
	self expectDelay: 30 milliseconds for: Time microsecondClockValue!

testSchedulingMultipleDelaysLongerFirst
	| endTime |
	delay := Delay forMilliseconds: 30.
	
	[delay wait.
	endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	"Wait for a shorter period than the other process"
	(Delay forMilliseconds: 20) wait.
	"We should have waited for the correct time, other proc is still waiting"
	self expectDelay: 20 milliseconds for: Time microsecondClockValue.
	self assertIsNil: endTime.
	"Now wait long enough for it to be done"
	(Delay forMilliseconds: 20) wait.
	self expectDelay: 30 milliseconds for: endTime.
	self expectDelay: 40 milliseconds for: Time microsecondClockValue!

testSignal
	| endTime |
	delay := Delay forMilliseconds: 20.
	
	[delay wait.
	endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	(Delay forMilliseconds: 10) wait.
	delay signal.
	self expectDelay: 10 milliseconds for: endTime!

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
	OS.KernelLibrary default sleep: 10.	"Wait for both processes above to finish, without using the Delay mechanism"
	self expectDelay: 0 milliseconds for: endTime.	"Process should not have actually waited on the delay"
	self assertIsNil: waitError.
	self assert: signalFinished.
	self assertIsNil: signalError!

testSimultaneousWaitAndSignalWithOtherLongerDelay
	[(Delay forMilliseconds: 25) wait] forkAt: Processor userInterruptPriority.
	self testSimultaneousWaitAndSignal!

testSimultaneousWaitAndSignalWithOtherShorterDelay
	[(Delay forMilliseconds: 15) wait] forkAt: Processor userInterruptPriority.
	self testSimultaneousWaitAndSignal! !
!Core.Tests.DelayTest categoriesFor: #expectDelay:for:!helpers!private! !
!Core.Tests.DelayTest categoriesFor: #setUp!private!running! !
!Core.Tests.DelayTest categoriesFor: #tearDown!private!running! !
!Core.Tests.DelayTest categoriesFor: #testBasicWait!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testCancel!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testCancelWithOtherShorterDelay!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testSchedulingMultipleDelays!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testSchedulingMultipleDelaysLongerFirst!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testSignal!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testSimultaneousWaitAndSignal!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testSimultaneousWaitAndSignalWithOtherLongerDelay!public!unit tests! !
!Core.Tests.DelayTest categoriesFor: #testSimultaneousWaitAndSignalWithOtherShorterDelay!public!unit tests! !

