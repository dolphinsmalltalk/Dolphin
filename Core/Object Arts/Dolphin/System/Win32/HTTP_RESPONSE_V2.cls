"Filed out from Dolphin Smalltalk 7"!

HTTP_RESPONSE_V1 subclass: #HTTP_RESPONSE_V2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_pResponseInfo' -> 16r11C.
		'_OffsetOf_ResponseInfoCount' -> 16r118
	}!
HTTP_RESPONSE_V2 guid: (GUID fromString: '{5e3a97da-7345-49a7-a5a9-1ddea2366eb2}')!
HTTP_RESPONSE_V2 comment: '<HTTP_RESPONSE_V2> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_RESPONSE_V2'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an HTTP response (V2)."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(5e3a97da-7345-49a7-a5a9-1ddea2366eb2), helpstring("This structure describes an HTTP response (V2).")]
struct tagHTTP_RESPONSE_V2 {
	HTTP_RESPONSE_V1;
	[nonbrowsable] USHORT ResponseInfoCount;
	[size_is("ResponseInfoCount")] HTTP_RESPONSE_INFO* pResponseInfo;
} HTTP_RESPONSE_V2;
'!
!HTTP_RESPONSE_V2 categoriesForClass!Win32-Structs! !
!HTTP_RESPONSE_V2 methodsFor!

pResponseInfo
	"Answer the <StructureArray> value of the receiver's 'pResponseInfo' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pResponseInfo)
		length: self ResponseInfoCount
		elementClass: HTTP_RESPONSE_INFO!

pResponseInfo: aStructureArray
	"Set the receiver's 'pResponseInfo' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_pResponseInfo put: aStructureArray yourAddress.
	self ResponseInfoCount: aStructureArray size!

ResponseInfoCount
	"Private - Answer the <Integer> value of the receiver's 'ResponseInfoCount' field."

	^bytes wordAtOffset: _OffsetOf_ResponseInfoCount!

ResponseInfoCount: anInteger
	"Set the receiver's 'ResponseInfoCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ResponseInfoCount put: anInteger! !
!HTTP_RESPONSE_V2 categoriesFor: #pResponseInfo!**compiled accessors**!public! !
!HTTP_RESPONSE_V2 categoriesFor: #pResponseInfo:!**compiled accessors**!public! !
!HTTP_RESPONSE_V2 categoriesFor: #ResponseInfoCount!**compiled accessors**!private! !
!HTTP_RESPONSE_V2 categoriesFor: #ResponseInfoCount:!**compiled accessors**!private! !

!HTTP_RESPONSE_V2 class methodsFor!

defineFields
	"Define the fields of the HTTP_RESPONSE_V2 structure.

	HTTP_RESPONSE_V2 compileDefinition

		typedef [uuid(5e3a97da-7345-49a7-a5a9-1ddea2366eb2), helpstring('This structure describes an HTTP response (V2).')]
		struct tagHTTP_RESPONSE_V2 {
			HTTP_RESPONSE_V1;
			[nonbrowsable] USHORT ResponseInfoCount;
			[size_is('ResponseInfoCount')] HTTP_RESPONSE_INFO* pResponseInfo;
		} HTTP_RESPONSE_V2;
"

	super defineFields.
	self
		defineField: #ResponseInfoCount type: WORDField new beNonBrowsable offset: 280;
		defineField: #pResponseInfo type: (StructureArrayPointerField type: HTTP_RESPONSE_INFO lengthField: #ResponseInfoCount) offset: 284.
	self byteSize: 288!

getFieldNames
	^#(#Flags #Version #StatusCode #ReasonLength #pReason #Headers #EntityChunkCount #pEntityChunks #ResponseInfoCount #pResponseInfo)! !
!HTTP_RESPONSE_V2 class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_RESPONSE_V2 class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

