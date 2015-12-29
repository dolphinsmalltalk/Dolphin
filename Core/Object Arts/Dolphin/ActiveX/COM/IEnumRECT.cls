"Filed out from Dolphin Smalltalk 99 release 3.0"!

IEnumXXXX subclass: #IEnumRECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

IEnumRECT class instanceVariableNames: ''!

IEnumRECT comment: ''!

IEnumRECT guid: (IID fromString: '{00021140-0000-0000-C000-000000000046}')!

!IEnumRECT categoriesForClass!No category! !

!IEnumRECT class methodsFor!

elementClass
	"Answer the class of element enumerated by the receiver."

	^RECT!

initialize
	"Private - Initialize the receiver.
		IEnumRECT initialize
	Generate the IID from its string representation."

	"This is the IID of the chapter 2 sample in Inside OLE2,
	Kraig Brockschmidt, Microsoft Press.
	As an exercise you may like to try interfacing
	Kraig's C++ sample to the Dolphin EnumRect sample, which
	is possible using C++ as a server, or Dolphin as a server."
	self iidString: '{00021140-0000-0000-C000-000000000046}'.
! !

!IEnumRECT class categoriesFor: #elementClass!constants!public! !
!IEnumRECT class categoriesFor: #initialize!initializing!public! !

