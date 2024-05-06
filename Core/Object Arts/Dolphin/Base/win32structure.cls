"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #Win32Structure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

Win32Structure guid: (GUID fromString: '{87b4c59c-026e-11d3-9fd7-00a0cc3e4a32}')!

Win32Structure isAbstract: true!

Win32Structure comment: 'Win32Structure is the abstract superclass of all classes that describe <ExternalStructure>s that are a part of the Win32 API. For the most part, these structures hold a <DWORD> byte size as the first field which Windows can use as version information to determine how the structure is to be interpreted. Where available,  this is set using #dwSize:.
'!

!Win32Structure categoriesForClass!External-Data-Structured-Win32! !

!Win32Structure methodsFor!

dwSize: anInteger
	"Store the size of the structure into itself (a common feature of Win32 structures,
	but unfortunately not all, so the default is to do nothing)"!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	self dwSize: anInteger! !

!Win32Structure categoriesForMethods!
dwSize:!initializing!public! !
initialize:!initializing!private! !
!

