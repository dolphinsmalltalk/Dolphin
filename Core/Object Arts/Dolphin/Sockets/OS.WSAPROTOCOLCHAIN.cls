"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.WSAPROTOCOLCHAIN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_ChainEntries' -> 16r4.
			'_OffsetOf_ChainLen' -> 16r0.
			'_WSAPROTOCOLCHAIN_Size' -> 16r20
		}!

OS.WSAPROTOCOLCHAIN guid: (Core.GUID fromString: '{fe42049a-9581-456b-b5e4-3b56e56d6f35}')!

OS.WSAPROTOCOLCHAIN comment: '`WSAPROTOCOLCHAIN` is an `External.Structure` class to wrap the struct ''Win32.WSAPROTOCOLCHAIN'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagWSAPROTOCOLCHAIN {
	int ChainLen;
	DWORD ChainEntries[7];
} WSAPROTOCOLCHAIN;
```
'!

!OS.WSAPROTOCOLCHAIN categoriesForClass!Win32-Structs! !

!OS.WSAPROTOCOLCHAIN methodsFor!

ChainEntries
	"Answer the <UInt32Array> value of the receiver's 'ChainEntries' field."

	^UInt32Array fromAddress: bytes yourAddress + _OffsetOf_ChainEntries length: 7!

ChainEntries: anUInt32Array
	"Set the receiver's 'ChainEntries' field to the value of the argument, anUInt32Array"

	| size |
	size := anUInt32Array byteSize min: ##(7 * UInt32Array elementSize).
	anUInt32Array
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ChainEntries + 1)
		to: _OffsetOf_ChainEntries + size
		startingAt: 1!

ChainLen
	"Answer the <Integer> value of the receiver's 'ChainLen' field."

	^bytes int32AtOffset: _OffsetOf_ChainLen!

ChainLen: anInteger
	"Set the receiver's 'ChainLen' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_ChainLen put: anInteger! !

!OS.WSAPROTOCOLCHAIN categoriesForMethods!
ChainEntries!**compiled accessors**!public! !
ChainEntries:!**compiled accessors**!public! !
ChainLen!**compiled accessors**!public! !
ChainLen:!**compiled accessors**!public! !
!

!OS.WSAPROTOCOLCHAIN class methodsFor!

byteSize
	^_WSAPROTOCOLCHAIN_Size!

defineFields
	"Define the fields of the WSAPROTOCOLCHAIN structure.

	WSAPROTOCOLCHAIN compileDefinition

		typedef 
		struct tagWSAPROTOCOLCHAIN {
			int ChainLen;
			DWORD ChainEntries[7];
		} WSAPROTOCOLCHAIN;
"

	self
		defineField: #ChainLen type: Int32Field new offset: 0;
		defineField: #ChainEntries type: (ArrayField type: UInt32Array length: 7) offset: 4.
	self byteSize: 32!

getFieldNames
	^#(#ChainLen #ChainEntries)! !

!OS.WSAPROTOCOLCHAIN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

