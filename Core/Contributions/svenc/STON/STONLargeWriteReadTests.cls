"Filed out from Dolphin Smalltalk 7"!

STONWriteReadTests subclass: #STONLargeWriteReadTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONLargeWriteReadTests guid: (GUID fromString: '{29be0ac3-431b-4a04-95c4-c3c398ed2ca4}')!
STONLargeWriteReadTests comment: 'STONLargeWriteReadTests test the optimalizations for large structures.'!
!STONLargeWriteReadTests categoriesForClass!STON-Tests-Writer! !
!STONLargeWriteReadTests methodsFor!

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
!STONLargeWriteReadTests categoriesFor: #materialize:!private! !
!STONLargeWriteReadTests categoriesFor: #serialize:!private! !
!STONLargeWriteReadTests categoriesFor: #serializeJson:!private! !

