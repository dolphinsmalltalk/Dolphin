"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.BLOB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_BLOB_Size' -> 16r8. '_OffsetOf_cbSize' -> 16r0. '_OffsetOf_pBlobData' -> 16r4 }!

OS.COM.BLOB guid: (Core.GUID fromString: '{9cc92cd0-a77e-4c94-8ce0-a38932a3bee9}')!

OS.COM.BLOB comment: '`BLOB` is an `External.Structure` class to wrap the Win32/COM Property Storage structure of the same name.

`BLOB` represents a counted array of arbitrary bytes in a `PROPVARIANT`.

Note that BLOB is subclassed from `CountedArray` for implementation convenience, as a BLOB is conceptually a not a vector but a scalar value (an opaque block of bytes). It has exactly the same memory layout as the true counted array `CAUB`, but is stored into a PROPVARIANT as a scalar VT_BLOB, rather than a VT_VECTOR | VT_UI1.

IDL definition follows:
```
typedef struct tagBLOB {
    ULONG cbSize;
    [size_is(cbSize)]
    BYTE  *pBlobData;
} BLOB, * LPBLOB;
```
'!

!OS.COM.BLOB categoriesForClass!WIC-Structs! !

!OS.COM.BLOB methodsFor!

cbSize
	"Answer the <Integer> value of the receiver's 'cbSize' field."

	^bytes uint32AtOffset: _OffsetOf_cbSize!

cbSize: anInteger
	"Set the receiver's 'cbSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cbSize put: anInteger!

copyBytes: aByteObject
	| count |
	count := aByteObject uint32AtOffset: _OffsetOf_cbSize.
	count == 0
		ifTrue: [bytes uintPtrAtOffset: _OffsetOf_pBlobData put: 0]
		ifFalse: 
			[| pBlobData |
			pBlobData := Ole32 coTaskMemAlloc: count.
			Ucrt
				memcpy_s: pBlobData
				destSize: count
				src: (aByteObject uintPtrAtOffset: _OffsetOf_pBlobData)
				count: count.
			bytes
				uintPtrAtOffset: _OffsetOf_pBlobData put: pBlobData;
				uintPtrAtOffset: _OffsetOf_cbSize put: count]!

copyToCOMTaskMemory
	"Answer a block of COM Task Memory into which the bytes of the receiver have been copied."

	| size |
	size := self cbSize.
	^(OS.COM.TaskMemory newUninitialized: size)
		replaceFrom: 1
		to: size
		with: self pBlobData
		startingAt: 1!

initializeVariant: anOleVariant
	anOleVariant blob: self!

pBlobData
	"Answer the <UInt8Array> value of the receiver's 'pBlobData' field."

	^UInt8Array
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pBlobData)
		owner: self fieldOwner
		length: self cbSize!

pBlobData: anUInt8Array
	"Set the receiver's 'pBlobData' field to the value of the argument, anUInt8Array"

	bytes uintPtrAtOffset: _OffsetOf_pBlobData put: anUInt8Array yourAddress.
	self cbSize: anUInt8Array size!

value
	^ByteArray fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pBlobData)
		length: (bytes uint32AtOffset: _OffsetOf_cbSize)!

value: aByteArray
	self basicFree.
	bytes
		uintPtrAtOffset: _OffsetOf_pBlobData put: aByteArray copyToCOMTaskMemory detach;
		uint32AtOffset: _OffsetOf_cbSize put: aByteArray size! !

!OS.COM.BLOB categoriesForMethods!
cbSize!**compiled accessors**!public! !
cbSize:!**compiled accessors**!public! !
copyBytes:!copying!private! !
copyToCOMTaskMemory!copying!public! !
initializeVariant:!converting!private! !
pBlobData!**compiled accessors**!public! !
pBlobData:!**compiled accessors**!public! !
value!accessing!public! !
value:!accessing!public! !
!

!OS.COM.BLOB class methodsFor!

byteSize
	^_BLOB_Size!

clear: addressOrBytes
	"Free external resources referenced by BLOB structure at the specified address."

	Ole32 coTaskMemFree: (addressOrBytes uintPtrAtOffset: _OffsetOf_pBlobData)!

defineFields
	"Define the fields of the BLOB structure.

	BLOB compileDefinition

		typedef 
		struct tagBLOB {
			unsigned long cbSize;
			[size_is('cbSize')] BYTE* pBlobData;
		} BLOB;
"

	self
		defineField: #cbSize type: UInt32Field new offset: 0;
		defineField: #pBlobData type: (ArrayPointerField type: UInt8Array lengthField: #cbSize) offset: 4.
	self byteSize: 8!

elementClass
	^UInt8!

fromBytes: aByteObject
	^self new
		value: aByteObject;
		yourself!

variantVectorName
	^#blobVector!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^OleVariant.VT_BLOB! !

!OS.COM.BLOB class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
clear:!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!public! !
fromBytes:!instance creation!public! !
variantVectorName!constants!private! !
vt!constants!public! !
!

