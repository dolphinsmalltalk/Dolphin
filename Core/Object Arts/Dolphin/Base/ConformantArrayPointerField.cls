"Filed out from Dolphin Smalltalk 7"!

ArrayPointerField subclass: #ConformantArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConformantArrayPointerField guid: (GUID fromString: '{CCFDA366-C068-4419-862A-121BC8CA340D}')!
ConformantArrayPointerField comment: ''!
!ConformantArrayPointerField categoriesForClass!External-Data-Types! !
!ConformantArrayPointerField methodsFor!

printLengthExpressionOn: aWriteStream 
	aWriteStream
		nextPutAll: 'self ';
		display: length! !
!ConformantArrayPointerField categoriesFor: #printLengthExpressionOn:!automatic generation!private! !

