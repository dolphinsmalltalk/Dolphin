"Filed out from Dolphin Smalltalk"!

STONWriteReadTest subclass: #STONWriteAsciiOnlyReadTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STONWriteAsciiOnlyReadTest guid: (GUID fromString: '{4c42c50a-a5ee-46fb-865d-0ad651fd33ee}')!

STONWriteAsciiOnlyReadTest comment: 'Unit tests for writing ASCII only'!

!STONWriteAsciiOnlyReadTest categoriesForClass!STON-Tests-Writer! !

!STONWriteAsciiOnlyReadTest methodsFor!

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

!STONWriteAsciiOnlyReadTest categoriesForMethods!
serialize:!private! !
serializeJson:!private! !
!

