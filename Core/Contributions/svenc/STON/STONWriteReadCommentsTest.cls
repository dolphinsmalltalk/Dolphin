"Filed out from Dolphin Smalltalk"!

STONWriteReadTest subclass: #STONWriteReadCommentsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STONWriteReadCommentsTest guid: (GUID fromString: '{bf56364e-5655-4f45-abbe-c24e5e081d0c}')!

STONWriteReadCommentsTest comment: 'Unit test writing and reading of comments'!

!STONWriteReadCommentsTest categoriesForClass!STON-Tests-Writer! !

!STONWriteReadCommentsTest methodsFor!

materialize: string
	^ STON reader
		on: (STONCStyleCommentsSkipStream on: string readStream);
		optimizeForLargeStructures;
		next!

serialize: anObject
	^ String streamContents: [ :stream |
		stream << '/* initial comment */'.
		STON writer 
			on: stream;
			nextPut: anObject.
		stream << '/* final comment */' ]! !

!STONWriteReadCommentsTest categoriesForMethods!
materialize:!private! !
serialize:!private! !
!

