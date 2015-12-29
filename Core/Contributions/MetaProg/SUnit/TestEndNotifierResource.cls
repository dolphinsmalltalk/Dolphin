"Filed out from Dolphin Smalltalk 2002 release 5.02"!

TestResource subclass: #TestEndNotifierResource
	instanceVariableNames: 'result'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestEndNotifierResource guid: (GUID fromString: '{DA387816-4B9C-4E83-AA16-15F0333A33D9}')!
TestEndNotifierResource comment: ''!
!TestEndNotifierResource categoriesForClass!Unclassified! !
!TestEndNotifierResource methodsFor!

fullPrintResult: aResult on: aStream
	aStream
		cr;
		nextPutAll: aResult runCount printString;
		nextPutAll: ' run, ';
		cr;
		nextPutAll: aResult passedCount printString;
		nextPutAll: ' passed, '.
	"result passed do: [ :each |
			aStream cr; nextPutAll: '    #', each selector]."
	aStream
		cr;
		nextPutAll: aResult failureCount printString;
		nextPutAll: ' failed, '.
	aResult failures do: 
			[:each | 
			aStream
				cr;
				nextPutAll: '    #' , each selector].
	aStream
		cr;
		nextPutAll: aResult errorCount printString;
		nextPutAll: ' error'.
	aResult errors do: 
			[:each | 
			aStream
				cr;
				nextPutAll: '    #' , each selector]!

result: aResult
	result := aResult!

tearDown
	"Do nothing. This is the place to hook in any actions which should
	occur when the test suite is finished. In the commented-out code
	below, we look whether the result is OK, and if not, we print the
	details to the Transcript"

	"Transcript cr; show: '---->', result size printString.
	result defects isEmpty not ifTrue: [
		self fullPrintResult: result on: Transcript.
		Transcript flush]"

! !
!TestEndNotifierResource categoriesFor: #fullPrintResult:on:!public! !
!TestEndNotifierResource categoriesFor: #result:!public! !
!TestEndNotifierResource categoriesFor: #tearDown!public! !

!TestEndNotifierResource class methodsFor!

isAvailable
	^true! !
!TestEndNotifierResource class categoriesFor: #isAvailable!public! !

