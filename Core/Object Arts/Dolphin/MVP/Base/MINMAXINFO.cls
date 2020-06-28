"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MINMAXINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ptMaxPosition' -> 16r10.
		'_OffsetOf_ptMaxSize' -> 16r8.
		'_OffsetOf_ptMaxTrackSize' -> 16r20.
		'_OffsetOf_ptMinTrackSize' -> 16r18.
		'_OffsetOf_ptReserved' -> 16r0
	}!
MINMAXINFO guid: (GUID fromString: '{76ebd637-6ab0-4d00-812c-fa6942e1318e}')!
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
!MINMAXINFO categoriesFor: #ptMaxTrackSize!**compiled accessors**!public! !
!MINMAXINFO categoriesFor: #ptMaxTrackSize:!**compiled accessors**!public! !
!MINMAXINFO categoriesFor: #ptMinTrackSize!**compiled accessors**!public! !
!MINMAXINFO categoriesFor: #ptMinTrackSize:!**compiled accessors**!public! !

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
!MINMAXINFO class categoriesFor: #defineFields!public!template definition! !
!MINMAXINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

