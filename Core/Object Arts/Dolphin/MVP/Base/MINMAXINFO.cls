"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #MINMAXINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ptMaxPosition _OffsetOf_ptMaxSize _OffsetOf_ptMaxTrackSize _OffsetOf_ptMinTrackSize _OffsetOf_ptReserved'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MINMAXINFO guid: (GUID fromString: '{76ebd637-6ab0-4d00-812c-fa6942e1318e}')!

MINMAXINFO addClassConstant: '_OffsetOf_ptMaxPosition' value: 16r10!
MINMAXINFO addClassConstant: '_OffsetOf_ptMaxSize' value: 16r8!
MINMAXINFO addClassConstant: '_OffsetOf_ptMaxTrackSize' value: 16r20!
MINMAXINFO addClassConstant: '_OffsetOf_ptMinTrackSize' value: 16r18!
MINMAXINFO addClassConstant: '_OffsetOf_ptReserved' value: 16r0!

MINMAXINFO comment: '<MINMAXINFO> is an <ExternalStructure> class to wrap the struct ''Win.MINMAXINFO'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagMINMAXINFO {
	POINTL ptReserved;
	POINTL ptMaxSize;
	POINTL ptMaxPosition;
	POINTL ptMinTrackSize;
	POINTL ptMaxTrackSize;
} MINMAXINFO;
'!

!MINMAXINFO categoriesForClass!Win-Structs! !

!MINMAXINFO methodsFor!

ptMaxTrackSize
	"Answer the <POINTL> value of the receiver's 'ptMaxTrackSize' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMaxTrackSize!

ptMaxTrackSize: aPOINTL
	"Set the receiver's 'ptMaxTrackSize' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMaxTrackSize + 1)
		to: ##(_OffsetOf_ptMaxTrackSize + POINTL basicByteSize)
		startingAt: 1!

ptMinTrackSize
	"Answer the <POINTL> value of the receiver's 'ptMinTrackSize' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMinTrackSize!

ptMinTrackSize: aPOINTL
	"Set the receiver's 'ptMinTrackSize' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMinTrackSize + 1)
		to: ##(_OffsetOf_ptMinTrackSize + POINTL basicByteSize)
		startingAt: 1! !

!MINMAXINFO categoriesForMethods!
ptMaxTrackSize!**compiled accessors**!public! !
ptMaxTrackSize:!**compiled accessors**!public! !
ptMinTrackSize!**compiled accessors**!public! !
ptMinTrackSize:!**compiled accessors**!public! !
!

!MINMAXINFO class methodsFor!

defineFields
	"Define the fields of the MINMAXINFO structure.
		MINMAXINFO compileDefinition
	
		typedef 		struct tagMINMAXINFO {
			POINTL ptReserved;
			POINTL ptMaxSize;
			POINTL ptMaxPosition;
			POINTL ptMinTrackSize;
			POINTL ptMaxTrackSize;
		} MINMAXINFO;
"

	self
		defineField: #ptReserved type: (StructureField type: POINTL) beFiller;
		defineField: #ptMaxSize type: (StructureField type: POINTL) beUncompiled;
		defineField: #ptMaxPosition type: (StructureField type: POINTL) beUncompiled;
		defineField: #ptMinTrackSize type: (StructureField type: POINTL);
		defineField: #ptMaxTrackSize type: (StructureField type: POINTL)!

getFieldNames
	^#(#ptMaxSize #ptMaxPosition #ptMinTrackSize #ptMaxTrackSize)! !

!MINMAXINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

