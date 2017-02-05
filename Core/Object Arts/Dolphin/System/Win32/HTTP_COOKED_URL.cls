"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_COOKED_URL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_COOKED_URL guid: (GUID fromString: '{24928162-1798-46A3-B2C1-3C6EE66C08BE}')!
HTTP_COOKED_URL comment: '<HTTP_COOKED_URL> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_COOKED_URL'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of cooked URL."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(24928162-1798-46A3-B2C1-3C6EE66C08BE), helpstring("Structure defining format of cooked URL.")]
struct tagHTTP_COOKED_URL {
	[helpstring("Pointers overlap and point into pFullUrl. NULL if not present.")] unsigned short FullUrlLength;
	unsigned short HostLength;
	unsigned short AbsPathLength;
	unsigned short QueryStringLength;
	LPCWSTR pFullUrl;
	LPCWSTR pHost;
	LPCWSTR pAbsPath;
	LPCWSTR pQueryString;
} HTTP_COOKED_URL;
'!
!HTTP_COOKED_URL categoriesForClass!Win32-Structs! !
!HTTP_COOKED_URL methodsFor!

AbsPathLength
	"Answer the receiver's AbsPathLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #AbsPathLength)!

AbsPathLength: anObject
	"Set the receiver's AbsPathLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #AbsPathLength) put: anObject!

FullUrlLength
	"Answer the receiver's FullUrlLength field as a Smalltalk object."

	^bytes wordAtOffset: 0!

FullUrlLength: anObject
	"Set the receiver's FullUrlLength field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

HostLength
	"Answer the receiver's HostLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #HostLength)!

HostLength: anObject
	"Set the receiver's HostLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #HostLength) put: anObject!

pAbsPath
	"Answer the receiver's pAbsPath field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pAbsPath))!

pAbsPath: anObject
	"Set the receiver's pAbsPath field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pAbsPath) put: anObject yourAddress!

pFullUrl
	"Answer the receiver's pFullUrl field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pFullUrl))!

pFullUrl: anObject
	"Set the receiver's pFullUrl field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pFullUrl) put: anObject yourAddress!

pHost
	"Answer the receiver's pHost field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pHost))!

pHost: anObject
	"Set the receiver's pHost field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pHost) put: anObject yourAddress!

pQueryString
	"Answer the receiver's pQueryString field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pQueryString))!

pQueryString: anObject
	"Set the receiver's pQueryString field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pQueryString) put: anObject yourAddress!

QueryStringLength
	"Answer the receiver's QueryStringLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #QueryStringLength)!

QueryStringLength: anObject
	"Set the receiver's QueryStringLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #QueryStringLength) put: anObject! !
!HTTP_COOKED_URL categoriesFor: #AbsPathLength!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #AbsPathLength:!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #FullUrlLength!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #FullUrlLength:!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #HostLength!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #HostLength:!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pAbsPath!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pAbsPath:!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pFullUrl!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pFullUrl:!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pHost!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pHost:!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pQueryString!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pQueryString:!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #QueryStringLength!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #QueryStringLength:!**compiled accessors**!public! !

!HTTP_COOKED_URL class methodsFor!

defineFields
	"Define the fields of the HTTP_COOKED_URL structure.

	HTTP_COOKED_URL  compileDefinition

		typedef [uuid(24928162-1798-46A3-B2C1-3C6EE66C08BE), helpstring('Structure defining format of cooked URL.')]
		struct tagHTTP_COOKED_URL {
			[helpstring('Pointers overlap and point into pFullUrl. NULL if not present.')] unsigned short FullUrlLength;
			unsigned short HostLength;
			unsigned short AbsPathLength;
			unsigned short QueryStringLength;
			LPCWSTR pFullUrl;
			LPCWSTR pHost;
			LPCWSTR pAbsPath;
			LPCWSTR pQueryString;
		} HTTP_COOKED_URL;
"

	self
		defineField: #FullUrlLength type: WORDField new offset: 0;
		defineField: #HostLength type: WORDField new offset: 2;
		defineField: #AbsPathLength type: WORDField new offset: 4;
		defineField: #QueryStringLength type: WORDField new offset: 6;
		defineField: #pFullUrl type: (PointerField type: UnicodeString) offset: 8;
		defineField: #pHost type: (PointerField type: UnicodeString) offset: 12;
		defineField: #pAbsPath type: (PointerField type: UnicodeString) offset: 16;
		defineField: #pQueryString type: (PointerField type: UnicodeString) offset: 20.
	self byteSize: 24! !
!HTTP_COOKED_URL class categoriesFor: #defineFields!**auto generated**!initializing!public! !

