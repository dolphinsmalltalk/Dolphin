"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #CRYPTOAPI_BLOB
	instanceVariableNames: 'localData'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRYPTOAPI_BLOB guid: (GUID fromString: '{E93356A1-821E-4719-8038-F2813B7615D2}')!
CRYPTOAPI_BLOB comment: '<CRYPTOAPI_BLOB> is an <ExternalStructure> class to wrap the struct ''Win32.CRYPTOAPI_BLOB'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure to represent an arbitrary, counted, array of bytes."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [helpstring("Structure to represent an arbitrary, counted, array of bytes.")]
struct tagCRYPTOAPI_BLOB {
	unsigned long cbData;
	BYTE* pbData;
} CRYPTOAPI_BLOB;
'!
!CRYPTOAPI_BLOB categoriesForClass!Win32-Structs! !
!CRYPTOAPI_BLOB methodsFor!

basicFree
	"Private - Free external resources owned by the receiver."

	KernelLibrary default localFree: self basicPbData!

basicPbData
	^bytes intPtrAtOffset: ##(self offsetOf: #pbData)!

cbData
	"Answer the receiver's cbData field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

cbData: anObject
	"Set the receiver's cbData field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

data
	^localData ifNil: [
		self pbData]!

data: aByteObject
	| temp |
	temp := bytes.
	self free.
	bytes := temp.
	self pbData: (localData := aByteObject asParameter).
	self cbData: localData basicSize!

initialize
	"Private - Initialize the receiver (common to internal [value] and
	external [reference] buffers.
	These objects are finalizable since they may reference owned external
	resources."

	self beFinalizable!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources."

	^localData isNil and: [bytes notNull and: [self basicPbData ~~ 0]]!

pbData
	"Answer the receiver's pbData field as a Smalltalk object."

	^BYTEArray fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pbData)) length: self cbData!

pbData: anObject
	"Set the receiver's pbData field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pbData) put: anObject yourAddress! !
!CRYPTOAPI_BLOB categoriesFor: #basicFree!private!realizing/unrealizing! !
!CRYPTOAPI_BLOB categoriesFor: #basicPbData!private!realizing/unrealizing! !
!CRYPTOAPI_BLOB categoriesFor: #cbData!**compiled accessors**!public! !
!CRYPTOAPI_BLOB categoriesFor: #cbData:!**compiled accessors**!public! !
!CRYPTOAPI_BLOB categoriesFor: #data!public! !
!CRYPTOAPI_BLOB categoriesFor: #data:!public! !
!CRYPTOAPI_BLOB categoriesFor: #initialize!initializing!private! !
!CRYPTOAPI_BLOB categoriesFor: #needsFree!private!realizing/unrealizing! !
!CRYPTOAPI_BLOB categoriesFor: #pbData!**compiled accessors**!public! !
!CRYPTOAPI_BLOB categoriesFor: #pbData:!**compiled accessors**!public! !

!CRYPTOAPI_BLOB class methodsFor!

defineFields
	"Define the fields of the CRYPTOAPI_BLOB structure.

	CRYPTOAPI_BLOB  compileDefinition

		typedef [helpstring('Structure to represent an arbitrary, counted, array of bytes.')]
		struct tagCRYPTOAPI_BLOB {
			unsigned long cbData;
			BYTE* pbData;
		} CRYPTOAPI_BLOB;
"

	self
		defineField: #cbData type: DWORDField new offset: 0;
		defineField: #pbData type: (ConformantArrayPointerField type: BYTEArray length: #cbData) offset: 4.
	self byteSize: 8!

fromBytes: aByteObject
	^self new data: aByteObject! !
!CRYPTOAPI_BLOB class categoriesFor: #defineFields!initializing!public! !
!CRYPTOAPI_BLOB class categoriesFor: #fromBytes:!public! !

