"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.RGNDATA'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_iType' -> 16r4.
		'_OffsetOf_nCount' -> 16r8.
		'_OffsetOf_nRgnSize' -> 16rC.
		'_OffsetOf_rcBound' -> 16r10.
		'_RGNDATA_Size' -> 16r20
	}!
OS.RGNDATA guid: (Core.GUID fromString: '{87b4c60e-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.RGNDATA comment: ''!
!OS.RGNDATA categoriesForClass!External-Data-Structured-Win32! !
!OS.RGNDATA methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

iType
	"Answer the <Integer> value of the receiver's 'iType' field."

	^bytes dwordAtOffset: _OffsetOf_iType!

iType: anInteger
	"Set the receiver's 'iType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iType put: anInteger!

nCount
	"Answer the <Integer> value of the receiver's 'nCount' field."

	^bytes dwordAtOffset: _OffsetOf_nCount!

nCount: anInteger
	"Set the receiver's 'nCount' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nCount put: anInteger!

nRgnSize
	"Answer the <Integer> value of the receiver's 'nRgnSize' field."

	^bytes dwordAtOffset: _OffsetOf_nRgnSize!

nRgnSize: anInteger
	"Set the receiver's 'nRgnSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nRgnSize put: anInteger!

rcBound
	"Answer the <RECTL> value of the receiver's 'rcBound' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcBound!

rcBound: aRECTL
	"Set the receiver's 'rcBound' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcBound + 1)
		to: ##(_OffsetOf_rcBound + RECTL._RECTL_Size)
		startingAt: 1! !
!OS.RGNDATA categoriesForMethods!
dwSize:!**compiled accessors**!public! !
iType!**compiled accessors**!public! !
iType:!**compiled accessors**!public! !
nCount!**compiled accessors**!public! !
nCount:!**compiled accessors**!public! !
nRgnSize!**compiled accessors**!public! !
nRgnSize:!**compiled accessors**!public! !
rcBound!**compiled accessors**!public! !
rcBound:!**compiled accessors**!public! !
!

!OS.RGNDATA class methodsFor!

byteSize
	^_RGNDATA_Size!

defineFields
	"Define the fields of the RGNDATA 'structure'.
	Note that we cheat a bit here by including the header as members of the RGNDATA
	to avoid defining two structures, and to make using it a bit easier.

		RGNDATA compileDefinition

		struct RGNDATAHEADER 
		{
			DWORD   dwSize;
			DWORD   iType;
			DWORD   nCount;
			DWORD   nRgnSize;
			RECTL	rcBound;
		};

		struct RGNDATA 
		{
			RGNDATAHEADER   rdh;
			char			Buffer[1];
		};
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #iType type: DWORDField new;
		defineField: #nCount type: DWORDField new;
		defineField: #nRgnSize type: DWORDField new;
		defineField: #rcBound type: (StructureField type: RECTL)!

getFieldNames
	^#(#dwSize #iType #nCount #nRgnSize #rcBound)! !
!OS.RGNDATA class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

