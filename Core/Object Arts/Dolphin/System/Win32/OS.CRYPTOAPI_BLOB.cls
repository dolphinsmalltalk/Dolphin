"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.CRYPTOAPI_BLOB'
	instanceVariableNames: 'localData'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_CRYPTOAPI_BLOB_Size' -> 16r8.
		'_OffsetOf_cbData' -> 16r0.
		'_OffsetOf_pbData' -> 16r4
	}!
OS.CRYPTOAPI_BLOB guid: (Core.GUID fromString: '{e93356a1-821e-4719-8038-f2813b7615d2}')!
OS.CRYPTOAPI_BLOB comment: '<CRYPTOAPI_BLOB> is an <ExternalStructure> class to wrap the struct ''Win32.CRYPTOAPI_BLOB'' from type information in the ''Win32 API'' library.

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
!OS.CRYPTOAPI_BLOB categoriesForClass!Win32-Structs! !
!OS.CRYPTOAPI_BLOB methodsFor!

basicFree
	"Private - Free external resources owned by the receiver."

	Kernel32 localFree: self basicPbData!

basicPbData
	^bytes intPtrAtOffset:_OffsetOf_pbData!

cbData
	"Private - Answer the <Integer> value of the receiver's 'cbData' field."

	^bytes dwordAtOffset: _OffsetOf_cbData!

cbData: anInteger
	"Set the receiver's 'cbData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbData put: anInteger!

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
	"Answer the <ExternalArray> value of the receiver's 'pbData' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_pbData) length: self cbData!

pbData: anExternalArray
	"Set the receiver's 'pbData' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: _OffsetOf_pbData put: anExternalArray yourAddress.
	self cbData: anExternalArray size! !
!OS.CRYPTOAPI_BLOB categoriesForMethods!
basicFree!private!realizing/unrealizing! !
basicPbData!private!realizing/unrealizing! !
cbData!**compiled accessors**!private! !
cbData:!**compiled accessors**!private! !
data!public! !
data:!public! !
initialize!initializing!private! !
needsFree!private!realizing/unrealizing! !
pbData!**compiled accessors**!public! !
pbData:!**compiled accessors**!public! !
!

!OS.CRYPTOAPI_BLOB class methodsFor!

byteSize
	^_CRYPTOAPI_BLOB_Size!

defineFields
	"Define the fields of the CRYPTOAPI_BLOB structure.

	CRYPTOAPI_BLOB  compileDefinition

		typedef [helpstring('Structure to represent an arbitrary, counted, array of bytes.')]
		struct tagCRYPTOAPI_BLOB {
			[nonbrowsable] unsigned long cbData;
			BYTE* pbData;
		} CRYPTOAPI_BLOB;
"

	self
		defineField: #cbData
			type: DWORDField new beNonBrowsable
			offset: 0;
		defineField: #pbData
			type: (ArrayPointerField type: ExternalArray
					arrayLength: (ConformantArrayFieldLength lengthField: #cbData))
			offset: 4.
	self byteSize: 8!

fromBytes: aByteObject
	^self new data: aByteObject!

getFieldNames
	^#(#cbData #pbData)! !
!OS.CRYPTOAPI_BLOB class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
fromBytes:!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

