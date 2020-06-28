"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #CCHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_flags' -> 16r8.
		'_OffsetOf_pt' -> 16r0
	}!
CCHITTESTINFO guid: (GUID fromString: '{87b4c5cd-026e-11d3-9fd7-00a0cc3e4a32}')!
CCHITTESTINFO isAbstract: true!
CCHITTESTINFO comment: 'CCHITTESTINFO is an ExternalStructure class which implements shared behaviour and state for the common controls hit-test structures, LVHITTESTINFO, TCHITTESTINFO, and TVHITTESTINFO. There is no actual Win32 common control structure of this name.'!
!CCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!CCHITTESTINFO methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

handle
	"Private - Answer the item 'handle' associated with the receiver."

	^self subclassResponsibility!

isItemHit
	"Answer whether the receiver represents a hit on an item in a list view."

	^self handle notNull!

pt: aPOINTL
	"Set the receiver's 'pt' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_pt + 1)
		to: ##(_OffsetOf_pt + POINTL basicByteSize)
		startingAt: 1! !
!CCHITTESTINFO categoriesFor: #flags!**compiled accessors**!public! !
!CCHITTESTINFO categoriesFor: #handle!accessing!private! !
!CCHITTESTINFO categoriesFor: #isItemHit!public!testing! !
!CCHITTESTINFO categoriesFor: #pt:!**compiled accessors**!public! !

!CCHITTESTINFO class methodsFor!

defineFields
	"Define the common fields of the common control hit test structures.

		CCHITTESTINFO compileDefinition
	"

	self
		defineField: #pt type: (StructureField type: POINTL) beWriteOnly;
		defineField: #flags type: DWORDField readOnly!

getFieldNames
	^#(#pt #flags)! !
!CCHITTESTINFO class categoriesFor: #defineFields!development!public!template definition! !
!CCHITTESTINFO class categoriesFor: #getFieldNames!constants!private! !

