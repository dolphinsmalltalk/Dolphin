"Filed out from Dolphin Smalltalk 7"!

STONWriteReadTests subclass: #STONWriteAsciiOnlyReadTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONWriteAsciiOnlyReadTests guid: (GUID fromString: '{4c42c50a-a5ee-46fb-865d-0ad651fd33ee}')!
STONWriteAsciiOnlyReadTests comment: 'Unit tests for writing ASCII only'!
!STONWriteAsciiOnlyReadTests categoriesForClass!STON-Tests-Writer! !
!STONWriteAsciiOnlyReadTests methodsFor!

serialize: anObject
	^ String streamContents: [ :stream |
		STON writer 
			on: stream; 
			asciiOnly: true;
			nextPut: anObject ]!

serializeJson: anObject
	^ String streamContents: [ :stream |
		STON jsonWriter 
			on: stream; 
			asciiOnly: true;
			nextPut: anObject ]! !
!STONWriteAsciiOnlyReadTests categoriesFor: #serialize:!private! !
!STONWriteAsciiOnlyReadTests categoriesFor: #serializeJson:!private! !

