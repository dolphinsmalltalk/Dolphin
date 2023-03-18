"Filed out from Dolphin Smalltalk"!

OS.COM.OLEStructure
	subclass: #'OS.COM.BINDINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BINDINFO_Size' -> 16r24.
			'_OffsetOf_cbstgmedData' -> 16r20.
			'_OffsetOf_dwBindVerb' -> 16r18.
			'_OffsetOf_dwSize' -> 16r0.
			'_OffsetOf_grfBindInfoF' -> 16r14.
			'_OffsetOf_stgmedData' -> 16r8.
			'_OffsetOf_szCustomVerb' -> 16r1C.
			'_OffsetOf_szExtraInfo' -> 16r4
		}!
OS.COM.BINDINFO guid: (Core.GUID fromString: '{464f7fac-9ba3-4055-8492-dc95aba83383}')!
OS.COM.BINDINFO comment: '<BINDINFO> is an <ExternalStructure> class to wrap the struct ''UrlMon.tagBINDINFO'' from type information in the ''UrlMon Library'' library.
'!
!OS.COM.BINDINFO categoriesForClass!OCIDL-Structs! !
!OS.COM.BINDINFO methodsFor!

cbstgmedData
	"Answer the <Integer> value of the receiver's 'cbstgmedData' field."

	^bytes uint32AtOffset: _OffsetOf_cbstgmedData!

cbstgmedData: anInteger
	"Set the receiver's 'cbstgmedData' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbstgmedData put: anInteger!

dwBindVerb
	"Answer the <Integer> value of the receiver's 'dwBindVerb' field."

	^bytes uint32AtOffset: _OffsetOf_dwBindVerb!

dwBindVerb: anInteger
	"Set the receiver's 'dwBindVerb' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwBindVerb put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

grfBindInfoF
	"Answer the <Integer> value of the receiver's 'grfBindInfoF' field."

	^bytes uint32AtOffset: _OffsetOf_grfBindInfoF!

grfBindInfoF: anInteger
	"Set the receiver's 'grfBindInfoF' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_grfBindInfoF put: anInteger!

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
!OS.COM.BINDINFO categoriesForMethods!
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

!OS.COM.BINDINFO class methodsFor!

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
		defineField: #dwSize type: UInt32Field writeOnly;
		defineField: #szExtraInfo type: (PointerField type: Utf16String);
		defineField: #stgmedData type: (StructureField type: STGMEDIUM);
		defineField: #grfBindInfoF type: UInt32Field new;
		defineField: #dwBindVerb type: UInt32Field new;
		defineField: #szCustomVerb type: (PointerField type: Utf16String);
		defineField: #cbstgmedData type: UInt32Field new!

getFieldNames
	^#(#dwSize #szExtraInfo #stgmedData #grfBindInfoF #dwBindVerb #szCustomVerb #cbstgmedData)! !
!OS.COM.BINDINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

