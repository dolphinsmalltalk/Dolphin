"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_REQUEST_TOKEN_BINDING_INFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_KeyType _OffsetOf_TlsUnique _OffsetOf_TlsUniqueSize _OffsetOf_TokenBinding _OffsetOf_TokenBindingSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST_TOKEN_BINDING_INFO guid: (GUID fromString: '{9a86eb3d-22ee-4cc3-980d-f3427eecdb0c}')!
HTTP_REQUEST_TOKEN_BINDING_INFO addClassConstant: '_OffsetOf_KeyType' value: 16r10!
HTTP_REQUEST_TOKEN_BINDING_INFO addClassConstant: '_OffsetOf_TlsUnique' value: 16r8!
HTTP_REQUEST_TOKEN_BINDING_INFO addClassConstant: '_OffsetOf_TlsUniqueSize' value: 16rC!
HTTP_REQUEST_TOKEN_BINDING_INFO addClassConstant: '_OffsetOf_TokenBinding' value: 16r0!
HTTP_REQUEST_TOKEN_BINDING_INFO addClassConstant: '_OffsetOf_TokenBindingSize' value: 16r4!
HTTP_REQUEST_TOKEN_BINDING_INFO comment: '<HTTP_REQUEST_TOKEN_BINDING_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_REQUEST_TOKEN_BINDING_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(9a86eb3d-22ee-4cc3-980d-f3427eecdb0c)]
struct tagHTTP_REQUEST_TOKEN_BINDING_INFO {
	UCHAR* TokenBinding;
	ULONG TokenBindingSize;
	UCHAR* TlsUnique;
	ULONG TlsUniqueSize;
	LPWSTR KeyType;
} HTTP_REQUEST_TOKEN_BINDING_INFO;
'!
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesForClass!WinHttpServer-Structs! !
!HTTP_REQUEST_TOKEN_BINDING_INFO methodsFor!

KeyType
	"Answer the <Utf16String> value of the receiver's 'KeyType' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_KeyType)!

KeyType: anUtf16String
	"Set the receiver's 'KeyType' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_KeyType put: anUtf16String yourAddress!

TlsUnique
	"Answer the <BYTE> value of the receiver's 'TlsUnique' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: _OffsetOf_TlsUnique)!

TlsUnique: aBYTE
	"Set the receiver's 'TlsUnique' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: _OffsetOf_TlsUnique put: aBYTE yourAddress!

TlsUniqueSize
	"Answer the <Integer> value of the receiver's 'TlsUniqueSize' field."

	^bytes dwordAtOffset: _OffsetOf_TlsUniqueSize!

TlsUniqueSize: anInteger
	"Set the receiver's 'TlsUniqueSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_TlsUniqueSize put: anInteger!

TokenBinding
	"Answer the <BYTE> value of the receiver's 'TokenBinding' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: _OffsetOf_TokenBinding)!

TokenBinding: aBYTE
	"Set the receiver's 'TokenBinding' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: _OffsetOf_TokenBinding put: aBYTE yourAddress!

TokenBindingSize
	"Answer the <Integer> value of the receiver's 'TokenBindingSize' field."

	^bytes dwordAtOffset: _OffsetOf_TokenBindingSize!

TokenBindingSize: anInteger
	"Set the receiver's 'TokenBindingSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_TokenBindingSize put: anInteger! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesForMethods!
KeyType!**compiled accessors**!public! !
KeyType:!**compiled accessors**!public! !
TlsUnique!**compiled accessors**!public! !
TlsUnique:!**compiled accessors**!public! !
TlsUniqueSize!**compiled accessors**!public! !
TlsUniqueSize:!**compiled accessors**!public! !
TokenBinding!**compiled accessors**!public! !
TokenBinding:!**compiled accessors**!public! !
TokenBindingSize!**compiled accessors**!public! !
TokenBindingSize:!**compiled accessors**!public! !
!

!HTTP_REQUEST_TOKEN_BINDING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_TOKEN_BINDING_INFO structure.

	HTTP_REQUEST_TOKEN_BINDING_INFO compileDefinition

		typedef [uuid(9a86eb3d-22ee-4cc3-980d-f3427eecdb0c)]
		struct tagHTTP_REQUEST_TOKEN_BINDING_INFO {
			UCHAR* TokenBinding;
			ULONG TokenBindingSize;
			UCHAR* TlsUnique;
			ULONG TlsUniqueSize;
			LPWSTR KeyType;
		} HTTP_REQUEST_TOKEN_BINDING_INFO;
"

	self
		defineField: #TokenBinding type: (PointerField type: BYTE) offset: 0;
		defineField: #TokenBindingSize type: DWORDField new offset: 4;
		defineField: #TlsUnique type: (PointerField type: BYTE) offset: 8;
		defineField: #TlsUniqueSize type: DWORDField new offset: 12;
		defineField: #KeyType type: (PointerField type: Utf16String) offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#TokenBinding #TokenBindingSize #TlsUnique #TlsUniqueSize #KeyType)! !
!HTTP_REQUEST_TOKEN_BINDING_INFO class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

