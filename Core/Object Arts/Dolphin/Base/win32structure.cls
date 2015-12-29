"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #Win32Structure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Win32Structure guid: (GUID fromString: '{87B4C59C-026E-11D3-9FD7-00A0CC3E4A32}')!
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
!Win32Structure categoriesFor: #dwSize:!initializing!public! !
!Win32Structure categoriesFor: #initialize:!initializing!private! !

