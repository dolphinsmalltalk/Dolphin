"Filed out from Dolphin Smalltalk"!

STON.Tests.WriteReadTest
	subclass: #'STON.Tests.WriteAsciiOnlyReadTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.WriteAsciiOnlyReadTest guid: (Core.GUID fromString: '{4c42c50a-a5ee-46fb-865d-0ad651fd33ee}')!
STON.Tests.WriteAsciiOnlyReadTest comment: 'Unit tests for writing ASCII only'!
!STON.Tests.WriteAsciiOnlyReadTest categoriesForClass!STON-Tests-Writer! !
!STON.Tests.WriteAsciiOnlyReadTest methodsFor!

serialize: anObject
	^String streamContents: 
			[:stream |
			STON writer
				on: stream;
				asciiOnly: true;
				nextPut: anObject]!

serializeJson: anObject
	^String streamContents: 
			[:stream |
			STON jsonWriter
				on: stream;
				asciiOnly: true;
				nextPut: anObject]! !
!STON.Tests.WriteAsciiOnlyReadTest categoriesForMethods!
serialize:!private! !
serializeJson:!private! !
!

