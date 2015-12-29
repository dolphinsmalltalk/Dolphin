"Filed out from Dolphin Smalltalk X6"!

Win32Error subclass: #OutOfMemoryError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OutOfMemoryError guid: (GUID fromString: '{87B4C568-026E-11D3-9FD7-00A0CC3E4A32}')!
OutOfMemoryError comment: ''!
!OutOfMemoryError categoriesForClass!System-Exception Handling! !
!OutOfMemoryError methodsFor!

initialize
	"Private - Initialize the receiver's instance variables."

	self tag: (HRESULT fromInteger: E_OUTOFMEMORY)! !
!OutOfMemoryError categoriesFor: #initialize!initializing!private! !

!OutOfMemoryError class methodsFor!

signal: messageText with: anObject

	^self shouldNotImplement! !
!OutOfMemoryError class categoriesFor: #signal:with:!instance creation!public! !

