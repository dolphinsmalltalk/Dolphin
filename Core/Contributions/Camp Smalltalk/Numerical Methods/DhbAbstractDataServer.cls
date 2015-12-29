"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbAbstractDataServer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbAbstractDataServer guid: (GUID fromString: '{E550027E-7D2B-11D6-B6CC-00022D5019C8}')!
DhbAbstractDataServer comment: ''!
!DhbAbstractDataServer categoriesForClass!DHB Numerical! !
!DhbAbstractDataServer methodsFor!

atEnd
		"Answers true if there is no more data element.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility!

close
		"Close the data stream (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "!

next
		"Answers the next element on the stream.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility!

open
		"Open the data stream (must be implemented by subclass).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility!

reset
		"Reset the position of the data stream to the beginning.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 9/3/99 "
	self subclassResponsibility! !
!DhbAbstractDataServer categoriesFor: #atEnd!information!public! !
!DhbAbstractDataServer categoriesFor: #close!operation!public! !
!DhbAbstractDataServer categoriesFor: #next!operation!public! !
!DhbAbstractDataServer categoriesFor: #open!operation!public! !
!DhbAbstractDataServer categoriesFor: #reset!operation!public! !

