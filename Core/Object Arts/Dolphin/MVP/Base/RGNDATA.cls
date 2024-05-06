"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #RGNDATA
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_iType _OffsetOf_nCount _OffsetOf_nRgnSize _OffsetOf_rcBound'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RGNDATA guid: (GUID fromString: '{87b4c60e-026e-11d3-9fd7-00a0cc3e4a32}')!

RGNDATA addClassConstant: '_OffsetOf_dwSize' value: 16r0!
RGNDATA addClassConstant: '_OffsetOf_iType' value: 16r4!
RGNDATA addClassConstant: '_OffsetOf_nCount' value: 16r8!
RGNDATA addClassConstant: '_OffsetOf_nRgnSize' value: 16rC!
RGNDATA addClassConstant: '_OffsetOf_rcBound' value: 16r10!

RGNDATA comment: ''!

!RGNDATA categoriesForClass!External-Data-Structured-Win32! !

!RGNDATA methodsFor!

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
	"Answer the <RECT> value of the receiver's 'rcBound' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcBound!

rcBound: aRECT
	"Set the receiver's 'rcBound' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcBound + 1)
		to: ##(_OffsetOf_rcBound + RECT basicByteSize)
		startingAt: 1! !

!RGNDATA categoriesForMethods!
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

!RGNDATA class methodsFor!

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
			RECT	rcBound;
		};

		struct RGNDATA 
		{
			RGNDATAHEADER   rdh;
			char			Buffer[1];
		};
	"

	self
		defineField: #dwSize 	type: DWORDField writeOnly beOverride;
		defineField: #iType		type: DWORDField new;
		defineField: #nCount	type: DWORDField new;
		defineField: #nRgnSize	type: DWORDField new;
		defineField: #rcBound	type: (StructureField type: RECT)
!

getFieldNames
	^#(#dwSize #iType #nCount #nRgnSize #rcBound)! !

!RGNDATA class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

