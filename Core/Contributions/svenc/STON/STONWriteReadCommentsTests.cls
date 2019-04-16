"Filed out from Dolphin Smalltalk 7"!

STONWriteReadTests subclass: #STONWriteReadCommentsTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONWriteReadCommentsTests guid: (GUID fromString: '{bf56364e-5655-4f45-abbe-c24e5e081d0c}')!
STONWriteReadCommentsTests comment: 'Unit test writing and reading of comments'!
!STONWriteReadCommentsTests categoriesForClass!STON-Tests-Writer! !
!STONWriteReadCommentsTests methodsFor!

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
!STONWriteReadCommentsTests categoriesFor: #materialize:!private! !
!STONWriteReadCommentsTests categoriesFor: #serialize:!private! !

