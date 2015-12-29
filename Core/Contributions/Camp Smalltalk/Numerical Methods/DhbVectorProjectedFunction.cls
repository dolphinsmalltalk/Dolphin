"Filed out from Dolphin Smalltalk XP"!

DhbProjectedOneVariableFunction subclass: #DhbVectorProjectedFunction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbVectorProjectedFunction guid: (GUID fromString: '{E5500287-7D2B-11D6-B6CC-00022D5019C8}')!
DhbVectorProjectedFunction comment: ''!
!DhbVectorProjectedFunction categoriesForClass!DHB Numerical! !
!DhbVectorProjectedFunction methodsFor!

argumentWith: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^aNumber * self direction + self origin!

direction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^index!

direction: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index := aVector.!

origin
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^argument!

origin: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	argument := aVector.!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	self origin printOn: aStream.
	aStream nextPutAll: ' ('.
	self direction printOn: aStream.
	aStream nextPut: $).! !
!DhbVectorProjectedFunction categoriesFor: #argumentWith:!information!public! !
!DhbVectorProjectedFunction categoriesFor: #direction!information!public! !
!DhbVectorProjectedFunction categoriesFor: #direction:!initialization!public! !
!DhbVectorProjectedFunction categoriesFor: #origin!information!public! !
!DhbVectorProjectedFunction categoriesFor: #origin:!initialization!public! !
!DhbVectorProjectedFunction categoriesFor: #printOn:!display!public! !

