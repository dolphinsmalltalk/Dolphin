"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.CCHITTESTINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommCtrlConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_CCHITTESTINFO_Size' -> 16rC.
		'_OffsetOf_flags' -> 16r8.
		'_OffsetOf_pt' -> 16r0
	}!
OS.CCHITTESTINFO guid: (Core.GUID fromString: '{87b4c5cd-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.CCHITTESTINFO isNonInstantiable: true!
OS.CCHITTESTINFO comment: 'CCHITTESTINFO is an ExternalStructure class which implements shared behaviour and state for the common controls hit-test structures, LVHITTESTINFO, TCHITTESTINFO, and TVHITTESTINFO. There is no actual Win32 common control structure of this name.'!
!OS.CCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.CCHITTESTINFO methodsFor!

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
		to: ##(_OffsetOf_pt + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.CCHITTESTINFO categoriesForMethods!
flags!**compiled accessors**!public! !
handle!accessing!private! !
isItemHit!public!testing! !
pt:!**compiled accessors**!public! !
!

!OS.CCHITTESTINFO class methodsFor!

byteSize
	^_CCHITTESTINFO_Size!

defineFields
	"Define the common fields of the common control hit test structures.

		CCHITTESTINFO compileDefinition
	"

	self
		defineField: #pt type: (StructureField type: POINTL) beWriteOnly;
		defineField: #flags type: DWORDField readOnly!

getFieldNames
	^#(#pt #flags)! !
!OS.CCHITTESTINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!development!public!template definition! !
getFieldNames!constants!private! !
!

