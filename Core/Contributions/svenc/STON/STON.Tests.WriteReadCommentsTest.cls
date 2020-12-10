"Filed out from Dolphin Smalltalk 7"!

STON.Tests.WriteReadTest subclass: #'STON.Tests.WriteReadCommentsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.WriteReadCommentsTest guid: (Core.GUID fromString: '{bf56364e-5655-4f45-abbe-c24e5e081d0c}')!
STON.Tests.WriteReadCommentsTest comment: 'Unit test writing and reading of comments'!
!STON.Tests.WriteReadCommentsTest categoriesForClass!STON-Tests-Writer! !
!STON.Tests.WriteReadCommentsTest methodsFor!

materialize: string
	^STON reader
		on: (CStyleCommentsSkipStream on: string readStream);
		optimizeForLargeStructures;
		next!

serialize: anObject
	^String streamContents: 
			[:stream |
			stream << '/* initial comment */'.
			STON writer
				on: stream;
				nextPut: anObject.
			stream << '/* final comment */']! !
!STON.Tests.WriteReadCommentsTest categoriesFor: #materialize:!private! !
!STON.Tests.WriteReadCommentsTest categoriesFor: #serialize:!private! !

