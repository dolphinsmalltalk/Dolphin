"Filed out from Dolphin Smalltalk XP"!

DhbAbstractDataServer subclass: #DhbMemoryBasedDataServer
	instanceVariableNames: 'data position'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbMemoryBasedDataServer guid: (GUID fromString: '{E550027F-7D2B-11D6-B6CC-00022D5019C8}')!
DhbMemoryBasedDataServer comment: ''!
!DhbMemoryBasedDataServer categoriesForClass!DHB Numerical! !
!DhbMemoryBasedDataServer methodsFor!

atEnd
		"Answers true if there is no more data element.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	^data size < position!

data: anOrderedCollection
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/16/00 "
	data := anOrderedCollection.
	self reset.!

dimension
		"Answers the dimension of the vectors catered by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	^data first size!

next
		"Answers the next element on the stream.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	| answer |
	answer := data at: position.
	position := position + 1.
	^answer!

open
		"Open the data stream (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self reset!

reset
		"Reset the position of the data stream to the beginning.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	position := 1.! !
!DhbMemoryBasedDataServer categoriesFor: #atEnd!information!public! !
!DhbMemoryBasedDataServer categoriesFor: #data:!initialization!public! !
!DhbMemoryBasedDataServer categoriesFor: #dimension!information!public! !
!DhbMemoryBasedDataServer categoriesFor: #next!operation!public! !
!DhbMemoryBasedDataServer categoriesFor: #open!operation!public! !
!DhbMemoryBasedDataServer categoriesFor: #reset!operation!public! !

