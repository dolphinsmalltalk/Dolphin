"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #Win32Structure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Win32Structure guid: (GUID fromString: '{274af70e-26ab-4bc3-9f33-d321934f4e11}')!

Win32Structure comment: 'Win32Structure is now deprecated.  Structures following the windows versioning convention of storing the structure size as their first field should be subclassed from `OS.SizedStructure`. Otherwise subclass Structure directly.'!

!Win32Structure categoriesForClass!Deprecated! !

!Win32Structure methodsFor!

dwSize: anInteger
	"Store the size of the structure into itself (a common feature of Win32 structures,
	but unfortunately not all, so the default is to do nothing)" !

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	self dwSize: anInteger! !

!Win32Structure categoriesForMethods!
dwSize:!initializing!public! !
initialize:!initializing!public! !
!

