"Filed out from Dolphin Smalltalk"!

OS.COM.IEnumXXXX
	subclass: #'OS.COM.Examples.IEnumRECT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Examples.IEnumRECT guid: (OS.COM.IID fromString: '{00021140-0000-0000-c000-000000000046}')!
OS.COM.Examples.IEnumRECT comment: 'IEnumRECT is a sample specialization of the generic COM enumeration interface, IEnumXXX. 

See p115, Chapter2, "Inside OLE 2e", Kraig Brockschmidt, Microsoft Press.

In Dolphin each COM interface is represented as a class, derived from the IUnknown class, which, not surprisingly, implements the IUnknown interface. The IEnumRECT interface Kraig defines is implemented in Dolphin as a subclass of IEnumXXXX, which provides a generic implementation for COM enumerators, and consequently IEnumRECT need only define a single method, #elementClass, which answers the type of object being enumerated over. Occassionally enerators may require a little more effort (for example when there is memory or ref. counts to be managed), but #elementClass is typically all there is to it.
'!
!OS.COM.Examples.IEnumRECT categoriesForClass!Samples! !
!OS.COM.Examples.IEnumRECT class methodsFor!

elementClass
	"Answer the class of element enumerated by the receiver."

	^RECTL! !
!OS.COM.Examples.IEnumRECT class categoriesForMethods!
elementClass!constants!public! !
!

