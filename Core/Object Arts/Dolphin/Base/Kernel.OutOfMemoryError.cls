"Filed out from Dolphin Smalltalk 7"!

OS.Win32Error subclass: #'Kernel.OutOfMemoryError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.OutOfMemoryError guid: (Core.GUID fromString: '{87b4c568-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.OutOfMemoryError comment: ''!
!Kernel.OutOfMemoryError categoriesForClass!System-Exception Handling! !
!Kernel.OutOfMemoryError methodsFor!

initialize
	"Private - Initialize the receiver's instance variables."

	self tag: (HRESULT fromInteger: E_OUTOFMEMORY)! !
!Kernel.OutOfMemoryError categoriesFor: #initialize!initializing!private! !

!Kernel.OutOfMemoryError class methodsFor!

signal: messageText with: anObject

	^self shouldNotImplement! !
!Kernel.OutOfMemoryError class categoriesFor: #signal:with:!instance creation!public! !

