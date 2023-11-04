"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.MINMAXINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MINMAXINFO_Size' -> 16r28.
			'_OffsetOf_ptMaxPosition' -> 16r10.
			'_OffsetOf_ptMaxSize' -> 16r8.
			'_OffsetOf_ptMaxTrackSize' -> 16r20.
			'_OffsetOf_ptMinTrackSize' -> 16r18.
			'_OffsetOf_ptReserved' -> 16r0
		}!
OS.MINMAXINFO guid: (Core.GUID fromString: '{76ebd637-6ab0-4d00-812c-fa6942e1318e}')!
OS.MINMAXINFO comment: '<MINMAXINFO> is an <ExternalStructure> class to wrap the struct ''Win.MINMAXINFO'' from type information in the ''Windows API (ANSI)'' library.

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
!OS.MINMAXINFO categoriesForClass!Win-Structs! !
!OS.MINMAXINFO methodsFor!

ptMaxTrackSize
	"Answer the <POINTL> value of the receiver's 'ptMaxTrackSize' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMaxTrackSize!

ptMaxTrackSize: aPOINTL
	"Set the receiver's 'ptMaxTrackSize' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMaxTrackSize + 1)
		to: ##(_OffsetOf_ptMaxTrackSize + POINTL._POINTL_Size)
		startingAt: 1!

ptMinTrackSize
	"Answer the <POINTL> value of the receiver's 'ptMinTrackSize' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMinTrackSize!

ptMinTrackSize: aPOINTL
	"Set the receiver's 'ptMinTrackSize' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMinTrackSize + 1)
		to: ##(_OffsetOf_ptMinTrackSize + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.MINMAXINFO categoriesForMethods!
ptMaxTrackSize!**compiled accessors**!public! !
ptMaxTrackSize:!**compiled accessors**!public! !
ptMinTrackSize!**compiled accessors**!public! !
ptMinTrackSize:!**compiled accessors**!public! !
!

!OS.MINMAXINFO class methodsFor!

byteSize
	^_MINMAXINFO_Size!

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
!OS.MINMAXINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

