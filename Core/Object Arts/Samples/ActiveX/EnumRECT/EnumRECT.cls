"Filed out from Dolphin Smalltalk 7"!

COMInterfaceImp subclass: #EnumRECT
	instanceVariableNames: 'm_iCur m_rgrc'
	classVariableNames: 'CRECTS'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EnumRECT guid: (GUID fromString: '{e3913c41-9396-11d3-b376-0800460222f0}')!
EnumRECT comment: 'EnumRECT is a sample implementation of the generic COM enumeration interface, IEnumXXX, specialized to enumeration RECT (rectangle) structures.'!
!EnumRECT categoriesForClass!Samples! !
!EnumRECT methodsFor!

Clone: ppEnum 
	"Implement the IEnumXXXX::Clone() interface function.
	See: Inside OLE2, Kraig Brockschmidt, Microsoft Press.
	N.B. For clarity this is a fairly direct port of Kraig's 
	code to Smalltalk, and doesn't really implement the Clone()
	function correctly (Clone() should return a cloned enumerator
	over the same collection, not a separate but equal collection)."

	| enum iEnum |
	enum := self class new.
	iEnum := enum queryInterface: IEnumRECT.
	"We must detach the temporary interface to prevent automatic Release()
	of the new EnumRect on finalization of iEnum"
	ppEnum value: iEnum detach.
	^S_OK!

initialize
	"Initialize the array of rectangles."

	m_iCur := 0.
	m_rgrc := StructureArray
				length: CRECTS
				elementClass: RECT
				initializer: 
					[:rect :index |
					| i |
					i := index - 1.
					rect
						top: i;
						left: i * 2;
						bottom: i * 3;
						right: i * 4]!

Next: next rgelt: rgelt pceltFetched: pdwRects 
	"Implement the IEnumXXXX::Next() interface function.
	See: Inside OLE2, Kraig Brockschmidt, Microsoft Press.
	N.B. For clarity this is a fairly direct port of Kraig's 
	code to Smalltalk, and is certainly not the simplest or
	most efficient way to copy back a range of elements."

	| cRect cRectReturn prc |
	cRectReturn := 0.
	cRect := next.		"can't assign to args in Smalltalk"
	pdwRects yourAddress isNull
		ifTrue: [cRect ~= 1 ifTrue: [^S_FALSE]]
		ifFalse: [pdwRects value: 0].

	(rgelt isNull or: [m_iCur >= CRECTS])
		ifTrue: [^S_FALSE].

	prc := StructureArray fromAddress: rgelt length: cRect elementClass: RECT.

	[m_iCur < CRECTS and: [cRect > 0]] whileTrue: [
		cRectReturn := cRectReturn + 1.
		m_iCur := m_iCur + 1.
		prc at: cRectReturn put: (m_rgrc at: m_iCur).
		cRect := cRect - 1].

    pdwRects yourAddress isNull ifFalse: [pdwRects value: cRectReturn].

	^S_OK!

Reset
	"Implement the IEnumXXXX::Reset() interface function.
	See: Inside OLE2, Kraig Brockschmidt, Microsoft Press."

	m_iCur := 0.
	^S_OK!

Skip: cSkip
	"Implement the IEnumXXXX::Skip() interface function.
	See: Inside OLE2, Kraig Brockschmidt, Microsoft Press."

	m_iCur+cSkip >= CRECTS
        ifTrue: [^S_FALSE].

	m_iCur := m_iCur + cSkip.
	^S_OK
!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^Array with: IEnumRECT! !
!EnumRECT categoriesFor: #Clone:!COM Interfaces-IEnumXXXX!public! !
!EnumRECT categoriesFor: #initialize!initializing!public! !
!EnumRECT categoriesFor: #Next:rgelt:pceltFetched:!COM Interfaces-IEnumXXXX!public! !
!EnumRECT categoriesFor: #Reset!COM Interfaces-IEnumXXXX!public! !
!EnumRECT categoriesFor: #Skip:!COM Interfaces-IEnumXXXX!public! !
!EnumRECT categoriesFor: #supportedInterfaces!constants!public! !

!EnumRECT class methodsFor!

initialize
	"Private - Initialize the receiver's class variables."

	CRECTS := 15!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !
!EnumRECT class categoriesFor: #initialize!initializing!private! !
!EnumRECT class categoriesFor: #new!instance creation!public! !

