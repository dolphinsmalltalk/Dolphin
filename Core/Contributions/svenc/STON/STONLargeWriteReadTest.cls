"Filed out from Dolphin Smalltalk"!

STONWriteReadTest subclass: #STONLargeWriteReadTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONLargeWriteReadTest guid: (GUID fromString: '{29be0ac3-431b-4a04-95c4-c3c398ed2ca4}')!
STONLargeWriteReadTest comment: 'STONLargeWriteReadTests test the optimalizations for large structures.'!
!STONLargeWriteReadTest categoriesForClass!STON-Tests-Writer! !
!STONLargeWriteReadTest methodsFor!

materialize: string
	^ STON reader
		on: string readStream;
		optimizeForLargeStructures;
		next!

serialize: anObject
	^ String streamContents: [ :stream |
		STON writer 
			on: stream; 
			optimizeForLargeStructures; 
			nextPut: anObject ]!

serializeJson: anObject
	^ String streamContents: [ :stream |
		STON jsonWriter 
			on: stream; 
			prettyPrint: true;
			optimizeForLargeStructures; 
			nextPut: anObject ]! !
!STONLargeWriteReadTest categoriesForMethods!
materialize:!private! !
serialize:!private! !
serializeJson:!private! !
!

