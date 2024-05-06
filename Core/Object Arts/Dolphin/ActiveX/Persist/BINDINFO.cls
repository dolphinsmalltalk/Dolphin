"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #BINDINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbstgmedData _OffsetOf_dwBindVerb _OffsetOf_dwSize _OffsetOf_grfBindInfoF _OffsetOf_stgmedData _OffsetOf_szCustomVerb _OffsetOf_szExtraInfo'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BINDINFO guid: (GUID fromString: '{464f7fac-9ba3-4055-8492-dc95aba83383}')!

BINDINFO addClassConstant: '_OffsetOf_cbstgmedData' value: 16r20!
BINDINFO addClassConstant: '_OffsetOf_dwBindVerb' value: 16r18!
BINDINFO addClassConstant: '_OffsetOf_dwSize' value: 16r0!
BINDINFO addClassConstant: '_OffsetOf_grfBindInfoF' value: 16r14!
BINDINFO addClassConstant: '_OffsetOf_stgmedData' value: 16r8!
BINDINFO addClassConstant: '_OffsetOf_szCustomVerb' value: 16r1C!
BINDINFO addClassConstant: '_OffsetOf_szExtraInfo' value: 16r4!

BINDINFO comment: '<BINDINFO> is an <ExternalStructure> class to wrap the struct ''UrlMon.tagBINDINFO'' from type information in the ''UrlMon Library'' library.
'!

!BINDINFO categoriesForClass!OCIDL-Structs! !

!BINDINFO methodsFor!

cbstgmedData
	"Answer the <Integer> value of the receiver's 'cbstgmedData' field."

	^bytes dwordAtOffset: _OffsetOf_cbstgmedData!

cbstgmedData: anInteger
	"Set the receiver's 'cbstgmedData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbstgmedData put: anInteger!

dwBindVerb
	"Answer the <Integer> value of the receiver's 'dwBindVerb' field."

	^bytes dwordAtOffset: _OffsetOf_dwBindVerb!

dwBindVerb: anInteger
	"Set the receiver's 'dwBindVerb' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwBindVerb put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

grfBindInfoF
	"Answer the <Integer> value of the receiver's 'grfBindInfoF' field."

	^bytes dwordAtOffset: _OffsetOf_grfBindInfoF!

grfBindInfoF: anInteger
	"Set the receiver's 'grfBindInfoF' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_grfBindInfoF put: anInteger!

stgmedData
	"Answer the <STGMEDIUM> value of the receiver's 'stgmedData' field."

	^STGMEDIUM fromAddress: bytes yourAddress + _OffsetOf_stgmedData!

stgmedData: aSTGMEDIUM
	"Set the receiver's 'stgmedData' field to the value of the argument, aSTGMEDIUM"

	aSTGMEDIUM
		replaceBytesOf: bytes
		from: ##(_OffsetOf_stgmedData + 1)
		to: ##(_OffsetOf_stgmedData + STGMEDIUM basicByteSize)
		startingAt: 1!

szCustomVerb
	"Answer the <Utf16String> value of the receiver's 'szCustomVerb' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_szCustomVerb)!

szCustomVerb: anUtf16String
	"Set the receiver's 'szCustomVerb' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_szCustomVerb put: anUtf16String yourAddress!

szExtraInfo
	"Answer the <Utf16String> value of the receiver's 'szExtraInfo' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_szExtraInfo)!

szExtraInfo: anUtf16String
	"Set the receiver's 'szExtraInfo' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_szExtraInfo put: anUtf16String yourAddress! !

!BINDINFO categoriesForMethods!
cbstgmedData!**compiled accessors**!public! !
cbstgmedData:!**compiled accessors**!public! !
dwBindVerb!**compiled accessors**!public! !
dwBindVerb:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
grfBindInfoF!**compiled accessors**!public! !
grfBindInfoF:!**compiled accessors**!public! !
stgmedData!**compiled accessors**!public! !
stgmedData:!**compiled accessors**!public! !
szCustomVerb!**compiled accessors**!public! !
szCustomVerb:!**compiled accessors**!public! !
szExtraInfo!**compiled accessors**!public! !
szExtraInfo:!**compiled accessors**!public! !
!

!BINDINFO class methodsFor!

defineFields
	"Define the fields of the BINDINFO structure.
		BINDINFO compileDefinition
	
		typedef 		struct tagtBINDINFO {
			unsigned long cbSize;
			LPWSTR szExtraInfo;
			STGMEDIUM stgmedData;
			unsigned long grfBindInfoF;
			unsigned long dwBindVerb;
			LPWSTR szCustomVerb;
			unsigned long cbstgmedData;
		} BINDINFO;

	"

	self
		defineField: #dwSize type: DWORDField writeOnly;
		defineField: #szExtraInfo type: (PointerField type: Utf16String);
		defineField: #stgmedData type: (StructureField type: STGMEDIUM);
		defineField: #grfBindInfoF type: DWORDField new;
		defineField: #dwBindVerb type: DWORDField new;
		defineField: #szCustomVerb type: (PointerField type: Utf16String);
		defineField: #cbstgmedData type: DWORDField new!

getFieldNames
	^#(#dwSize #szExtraInfo #stgmedData #grfBindInfoF #dwBindVerb #szCustomVerb #cbstgmedData)! !

!BINDINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

