"Filed out from Dolphin Smalltalk X6"!

Object subclass: #DummyWshExec
	instanceVariableNames: 'processID'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
DummyWshExec guid: (GUID fromString: '{1B00B441-3C15-4FC6-AF06-7F1189146AF2}')!
DummyWshExec comment: ''!
!DummyWshExec categoriesForClass!Kernel-Objects! !
!DummyWshExec methodsFor!

processID
	^processID!

processID: anObject
	processID := anObject!

terminate
	"Ignore the termination request, since the process was not started by the calling ApplicationController."

	KernelLibrary default terminateProcessId: self processID! !
!DummyWshExec categoriesFor: #processID!accessing!public! !
!DummyWshExec categoriesFor: #processID:!accessing!public! !
!DummyWshExec categoriesFor: #terminate!public! !

!DummyWshExec class methodsFor!

attachProcessId: anInteger 
	^(self new)
		processID: anInteger;
		yourself! !
!DummyWshExec class categoriesFor: #attachProcessId:!public! !

