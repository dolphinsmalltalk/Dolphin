"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_REQUEST_TOKEN_BINDING_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST_TOKEN_BINDING_INFO guid: (GUID fromString: '{9A86EB3D-22EE-4CC3-980D-F3427EECDB0C}')!
HTTP_REQUEST_TOKEN_BINDING_INFO comment: '<HTTP_REQUEST_TOKEN_BINDING_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_TOKEN_BINDING_INFO'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(9A86EB3D-22EE-4CC3-980D-F3427EECDB0C)]
struct tagHTTP_REQUEST_TOKEN_BINDING_INFO {
	BYTE* TokenBinding;
	unsigned long TokenBindingSize;
	BYTE* TlsUnique;
	unsigned long TlsUniqueSize;
	LPWSTR KeyType;
} HTTP_REQUEST_TOKEN_BINDING_INFO;
'!
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_TOKEN_BINDING_INFO methodsFor!

KeyType
	"Answer the receiver's KeyType field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #KeyType))!

KeyType: anObject
	"Set the receiver's KeyType field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #KeyType) put: anObject yourAddress!

TlsUnique
	"Answer the receiver's TlsUnique field as a Smalltalk object."

	^BYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #TlsUnique))!

TlsUnique: anObject
	"Set the receiver's TlsUnique field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #TlsUnique) put: anObject yourAddress!

TlsUniqueSize
	"Answer the receiver's TlsUniqueSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #TlsUniqueSize)!

TlsUniqueSize: anObject
	"Set the receiver's TlsUniqueSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #TlsUniqueSize) put: anObject!

TokenBinding
	"Answer the receiver's TokenBinding field as a Smalltalk object."

	^BYTE fromAddress: (bytes intPtrAtOffset: 0)!

TokenBinding: anObject
	"Set the receiver's TokenBinding field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress!

TokenBindingSize
	"Answer the receiver's TokenBindingSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #TokenBindingSize)!

TokenBindingSize: anObject
	"Set the receiver's TokenBindingSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #TokenBindingSize) put: anObject! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #KeyType!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #KeyType:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUnique!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUnique:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUniqueSize!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUniqueSize:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBinding!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBinding:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBindingSize!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBindingSize:!**compiled accessors**!public! !

!HTTP_REQUEST_TOKEN_BINDING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_TOKEN_BINDING_INFO structure.

	HTTP_REQUEST_TOKEN_BINDING_INFO  compileDefinition

		typedef [uuid(9A86EB3D-22EE-4CC3-980D-F3427EECDB0C)]
		struct tagHTTP_REQUEST_TOKEN_BINDING_INFO {
			BYTE* TokenBinding;
			unsigned long TokenBindingSize;
			BYTE* TlsUnique;
			unsigned long TlsUniqueSize;
			LPWSTR KeyType;
		} HTTP_REQUEST_TOKEN_BINDING_INFO;
"

	self
		defineField: #TokenBinding type: (PointerField type: BYTE) offset: 0;
		defineField: #TokenBindingSize type: DWORDField new offset: 4;
		defineField: #TlsUnique type: (PointerField type: BYTE) offset: 8;
		defineField: #TlsUniqueSize type: DWORDField new offset: 12;
		defineField: #KeyType type: (PointerField type: UnicodeString) offset: 16.
	self byteSize: 20! !
!HTTP_REQUEST_TOKEN_BINDING_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

