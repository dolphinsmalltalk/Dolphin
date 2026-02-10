"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.COM.VersionedStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_guidVersion' -> 16r0.
			'_OffsetOf_pStream' -> 16r10.
			'_VersionedStream_Size' -> 16r14
		}!

OS.COM.VersionedStream guid: (Core.GUID fromString: '{a621e862-bc5c-44ed-8b67-3f038db02076}')!

OS.COM.VersionedStream comment: '`VersionedStream` is an `External.Structure` class to represent the Win32 COM Property Storage VersionedStream structure.

IDL definition follows:
```
typedef 
struct tagVersionedStream {
	GUID guidVersion;
	IStream* pStream;
} VersionedStream;
```
'!

!OS.COM.VersionedStream categoriesForClass!Win32-Structs! !

!OS.COM.VersionedStream methodsFor!

guidVersion
	"Answer the <GUID> value of the receiver's 'guidVersion' field."

	^GUID fromAddress: bytes yourAddress!

guidVersion: aGUID
	"Set the receiver's 'guidVersion' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_guidVersion + 1)
		to: ##(_OffsetOf_guidVersion + GUID._GUID_Size)
		startingAt: 1!

pStream
	"Answer the <IStream> value of the receiver's 'pStream' field."

	^IStream fromAddress: (bytes intPtrAtOffset: _OffsetOf_pStream)!

pStream: anIStream
	"Set the receiver's 'pStream' field to the value of the argument, anIStream"

	anIStream _addRef.
	bytes uintPtrAtOffset: _OffsetOf_pStream put: anIStream yourAddress! !

!OS.COM.VersionedStream categoriesForMethods!
guidVersion!**compiled accessors**!public! !
guidVersion:!**compiled accessors**!public! !
pStream!**compiled accessors**!public! !
pStream:!public! !
!

!OS.COM.VersionedStream class methodsFor!

byteSize
	^_VersionedStream_Size!

clear: addressOrBytes
	"Free external resources referenced by the structure of the receiver's element type at the specified address."

	| pi |
	pi := addressOrBytes intPtrAtOffset: _OffsetOf_pStream.
	pi notNull ifTrue: [(IStream attach: pi) free]!

defineFields
	"Define the fields of the VersionedStream structure.

	VersionedStream compileDefinition

		typedef 
		struct tagVersionedStream {
			GUID guidVersion;
			IStream* pStream;
		} VersionedStream;
"

	self
		defineField: #guidVersion type: (StructureField type: GUID) offset: 0;
		defineField: #pStream type: (PointerField type: IStream) offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#guidVersion #pStream)! !

!OS.COM.VersionedStream class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

