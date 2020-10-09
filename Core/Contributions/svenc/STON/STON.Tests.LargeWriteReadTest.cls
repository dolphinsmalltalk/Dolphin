"Filed out from Dolphin Smalltalk 7"!

STON.Tests.WriteReadTest subclass: #'STON.Tests.LargeWriteReadTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.LargeWriteReadTest guid: (Core.GUID fromString: '{29be0ac3-431b-4a04-95c4-c3c398ed2ca4}')!
STON.Tests.LargeWriteReadTest comment: 'STONLargeWriteReadTests test the optimalizations for large structures.'!
!STON.Tests.LargeWriteReadTest categoriesForClass!STON-Tests-Writer! !
!STON.Tests.LargeWriteReadTest methodsFor!

materialize: string
	^STON reader
		on: string readStream;
		optimizeForLargeStructures;
		next!

serialize: anObject
	^String streamContents: 
			[:stream |
			STON writer
				on: stream;
				optimizeForLargeStructures;
				nextPut: anObject]!

serializeJson: anObject
	^String streamContents: 
			[:stream |
			STON jsonPrettyPrinter
				on: stream;
				optimizeForLargeStructures;
				nextPut: anObject]! !
!STON.Tests.LargeWriteReadTest categoriesFor: #materialize:!private! !
!STON.Tests.LargeWriteReadTest categoriesFor: #serialize:!private! !
!STON.Tests.LargeWriteReadTest categoriesFor: #serializeJson:!private! !

