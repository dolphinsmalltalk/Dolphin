"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #CCHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_pt'
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!

CCHITTESTINFO guid: (GUID fromString: '{87b4c5cd-026e-11d3-9fd7-00a0cc3e4a32}')!

CCHITTESTINFO isAbstract: true!

CCHITTESTINFO addClassConstant: '_OffsetOf_pt' value: 16r0!

CCHITTESTINFO comment: 'CCHITTESTINFO is an ExternalStructure class which implements shared behaviour and state for the common controls hit-test structures, LVHITTESTINFO, TCHITTESTINFO, and TVHITTESTINFO. There is no actual Win32 common control structure of this name.'!

!CCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !

!CCHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver."

	^self subclassResponsibility!

isItemHit
	"Answer whether the receiver represents a hit on an item in a list view."

	^self handle notNull!

pt
	"Answer the <POINTL> value of the receiver's 'pt' field."

	^POINTL fromAddress: bytes yourAddress!

pt: aPOINTL
	"Set the receiver's 'pt' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_pt + 1)
		to: ##(_OffsetOf_pt + POINTL basicByteSize)
		startingAt: 1! !

!CCHITTESTINFO categoriesForMethods!
handle!accessing!private! !
isItemHit!public!testing! !
pt!**compiled accessors**!public! !
pt:!**compiled accessors**!public! !
!

!CCHITTESTINFO class methodsFor!

defineFields
	"Define the common fields of the common control hit test structures.

		CCHITTESTINFO compileDefinition
	"

	self defineField: #pt type: (StructureField type: POINTL)!

getFieldNames
	^#(#pt)!

position: aPoint
	^self basicNew bytes: ((ByteArray newFixed: self byteSize)
				sdwordAtOffset: ##(_OffsetOf_pt + POINTL._OffsetOf_x) put: aPoint x;
				sdwordAtOffset: ##(_OffsetOf_pt + POINTL._OffsetOf_y) put: aPoint y;
				yourself)! !

!CCHITTESTINFO class categoriesForMethods!
defineFields!development!public!template definition! !
getFieldNames!constants!private! !
position:!instance creation!public! !
!

