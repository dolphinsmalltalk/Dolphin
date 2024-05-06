"Filed out from Dolphin Smalltalk"!

Win32Error subclass: #OutOfMemoryError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OutOfMemoryError guid: (GUID fromString: '{87b4c568-026e-11d3-9fd7-00a0cc3e4a32}')!

OutOfMemoryError comment: ''!

!OutOfMemoryError categoriesForClass!System-Exception Handling! !

!OutOfMemoryError methodsFor!

initialize
	"Private - Initialize the receiver's instance variables."

	self tag: (HRESULT fromInteger: E_OUTOFMEMORY)! !

!OutOfMemoryError categoriesForMethods!
initialize!initializing!private! !
!

!OutOfMemoryError class methodsFor!

signal: messageText with: anObject

	^self shouldNotImplement! !

!OutOfMemoryError class categoriesForMethods!
signal:with:!instance creation!public! !
!

