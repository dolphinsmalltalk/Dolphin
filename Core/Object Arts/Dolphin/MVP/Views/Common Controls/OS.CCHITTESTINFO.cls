"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.CCHITTESTINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommCtrlConstants})
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_pt' -> 16r0 }!
OS.CCHITTESTINFO guid: (Core.GUID fromString: '{87b4c5cd-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.CCHITTESTINFO isNonInstantiable: true!
OS.CCHITTESTINFO comment: 'CCHITTESTINFO is an ExternalStructure class which implements shared behaviour and state for the common controls hit-test structures, LVHITTESTINFO, TCHITTESTINFO, and TVHITTESTINFO. There is no actual Win32 common control structure of this name.'!
!OS.CCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.CCHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver."

	^self subclassResponsibility!

isItemHit
	"Answer whether the receiver represents a hit on an item in a list view."

	^self handle notNull!

position: aPoint
	bytes
		int32AtOffset: ##(_OffsetOf_pt + POINTL._OffsetOf_x) put: aPoint x;
		int32AtOffset: ##(_OffsetOf_pt + POINTL._OffsetOf_y) put: aPoint y!

pt
	"Answer the <POINTL> value of the receiver's 'pt' field."

	^POINTL fromAddress: bytes yourAddress!

pt: aPOINTL
	"Set the receiver's 'pt' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_pt + 1)
		to: ##(_OffsetOf_pt + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.CCHITTESTINFO categoriesForMethods!
handle!accessing!private! !
isItemHit!public!testing! !
position:!accessing!public! !
pt!**compiled accessors**!public! !
pt:!**compiled accessors**!public! !
!

!OS.CCHITTESTINFO class methodsFor!

defineFields
	"Define the common fields of the common control hit test structures.

		CCHITTESTINFO compileDefinition
	"

	self defineField: #pt type: (StructureField type: POINTL)!

position: aPoint
	^self basicNew bytes: ((ByteArray newFixed: self byteSize)
				int32AtOffset: ##(_OffsetOf_pt + POINTL._OffsetOf_x) put: aPoint x;
				int32AtOffset: ##(_OffsetOf_pt + POINTL._OffsetOf_y) put: aPoint y;
				yourself)! !
!OS.CCHITTESTINFO class categoriesForMethods!
defineFields!development!public!template definition! !
position:!accessing!instance creation!public! !
!

