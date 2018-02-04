"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #ThreadPoolTest
	instanceVariableNames: 'tp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ThreadPoolTest guid: (GUID fromString: '{3164f12a-4c7c-4b08-b7af-0361d0903d79}')!
ThreadPoolTest comment: ''!
!ThreadPoolTest categoriesForClass!SUnit! !
!ThreadPoolTest methodsFor!

setUp
	tp := ThreadPool new start!

tearDown
	tp stop.
	tp := nil!

testFree
	tp free.
	self deny: tp isRunning.
	self deny: tp isFinalizable!

testNewInstanceIsFinalizable

	self assert: tp isFinalizable!

testQueueWork
	| cookie |
	cookie := false.
	tp queueWorkItem: [cookie := true].
	tp processQueueElement. "Far from being perfect but I prefer this to a more complicated test that randomly fails."
	self assert: cookie!

testStart
	self assert: tp isRunning.
	tp stop.
	self deny: tp isRunning.
	tp start.
	self assert: tp isRunning!

testStop
	self assert: tp isRunning.
	tp stop.
	self deny: tp isRunning! !
!ThreadPoolTest categoriesFor: #setUp!private! !
!ThreadPoolTest categoriesFor: #tearDown!private! !
!ThreadPoolTest categoriesFor: #testFree!public! !
!ThreadPoolTest categoriesFor: #testNewInstanceIsFinalizable!public! !
!ThreadPoolTest categoriesFor: #testQueueWork!public! !
!ThreadPoolTest categoriesFor: #testStart!public! !
!ThreadPoolTest categoriesFor: #testStop!public! !

