"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.COM.STATSTG'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.StorageConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_atime' -> 16r20.
			'_OffsetOf_cbSize' -> 16r8.
			'_OffsetOf_clsid' -> 16r30.
			'_OffsetOf_ctime' -> 16r18.
			'_OffsetOf_grfLocksSupported' -> 16r2C.
			'_OffsetOf_grfMode' -> 16r28.
			'_OffsetOf_grfStateBits' -> 16r40.
			'_OffsetOf_mtime' -> 16r10.
			'_OffsetOf_pwcsName' -> 16r0.
			'_OffsetOf_reserved' -> 16r44.
			'_OffsetOf_type' -> 16r4.
			'_STATSTG_Size' -> 16r48
		}!
OS.COM.STATSTG guid: (Core.GUID fromString: '{87b4c5c3-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.STATSTG comment: 'STATSTG is an <ExternalStructure> class to represent the OLE Structured Storage structure of the same name.

STATSTG contains directory type information about a structured storage object (storage, stream, or lock bytes)

N.B. The pwcsName member is a pointer to a UnicodeString that has been allocated from the COM task heap, and which must be free''d back to that heap. This is managed using finalization.

Member variables:
	pwcsName		<UnicodeString> "file" name
	type			<integer> from STGTY enumeration - the type of storage object
	cbSize			<integer> size in bytes
	mtime			<FILETIME> when last modified
	ctime			<FILETIME> when created
	atime			<FILETIME> when last accessed
	grfMode			<integer> access mode
	grfLocksSupported		<integer> from LOCKTYPES enumeration - the types of lock supported
	clsid			<CLSID> of storage object
	grfStateBits		<integer> bit mask last set by IStorage>>SetStateBits
	dwStgFmt			<integer> from STGFMT enumeration - the format of the storage object.'!
!OS.COM.STATSTG categoriesForClass!External-Data-Structured-COM! !
!OS.COM.STATSTG methodsFor!

atime
	"Answer the <FILETIME> value of the receiver's 'atime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_atime!

atime: aFILETIME
	"Set the receiver's 'atime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_atime + 1)
		to: ##(_OffsetOf_atime + FILETIME._FILETIME_Size)
		startingAt: 1!

cbSize
	"Answer the <Integer> value of the receiver's 'cbSize' field."

	^bytes uint64AtOffset: _OffsetOf_cbSize!

cbSize: anInteger
	"Set the receiver's 'cbSize' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_cbSize put: anInteger!

clsid
	"Answer the <CLSID> value of the receiver's 'clsid' field."

	^CLSID fromAddress: bytes yourAddress + _OffsetOf_clsid!

ctime
	"Answer the <FILETIME> value of the receiver's 'ctime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ctime!

ctime: aFILETIME
	"Set the receiver's 'ctime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ctime + 1)
		to: ##(_OffsetOf_ctime + FILETIME._FILETIME_Size)
		startingAt: 1!

grfLocksSupported
	"Answer the <Integer> value of the receiver's 'grfLocksSupported' field."

	^bytes uint32AtOffset: _OffsetOf_grfLocksSupported!

grfLocksSupported: anInteger
	"Set the receiver's 'grfLocksSupported' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_grfLocksSupported put: anInteger!

grfMode
	"Answer the <Integer> value of the receiver's 'grfMode' field."

	^bytes uint32AtOffset: _OffsetOf_grfMode!

grfMode: anInteger
	"Set the receiver's 'grfMode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_grfMode put: anInteger!

grfStateBits
	"Answer the <Integer> value of the receiver's 'grfStateBits' field."

	^bytes uint32AtOffset: _OffsetOf_grfStateBits!

isOLEStorage
	"Answer whether the receiver contains status information for a Storage element
	(as opposed to a Stream element).
	To avoid confusion with a class testing method, we include the 'OLE' infix."

	^self type == STGTY_STORAGE!

isOLEStream
	"Answer whether the receiver contains status information for a Storage element
	(as opposed to a Stream element).
	To avoid confusion with a class testing method, we include the 'OLE' infix."

	^self type == STGTY_STREAM!

mtime
	"Answer the <FILETIME> value of the receiver's 'mtime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_mtime!

mtime: aFILETIME
	"Set the receiver's 'mtime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_mtime + 1)
		to: ##(_OffsetOf_mtime + FILETIME._FILETIME_Size)
		startingAt: 1!

name
	"Answer the <readableString> name of the object whose status the receiver is recording."

	^self pwcsName!

name: aString
	"Set the <readableString> name of the object whose status the receiver is recording."

	| name size utf16 |
	utf16 := aString asUtf16String.
	size := utf16 byteSize.
	"Note that CoTaskMemAlloc does not guarantee to initialize/zero the memory, so we must be sure to add the null terminator."
	name := Ole32 coTaskMemAlloc: size.
	name
		replaceFrom: 1
			to: size - 2
			with: utf16
			startingAt: 1;
		uint16AtOffset: size - 2 put: 0.
	self pwcsName: name
	"struct now has ownership of the name"!

pwcsName
	"Answer the <Utf16String> value of the receiver's 'pwcsName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwcsName)!

pwcsName: anUtf16String
	"Set the receiver's 'pwcsName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwcsName put: anUtf16String yourAddress!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes uint32AtOffset: _OffsetOf_type!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_type put: anInteger! !
!OS.COM.STATSTG categoriesForMethods!
atime!**compiled accessors**!public! !
atime:!**compiled accessors**!public! !
cbSize!**compiled accessors**!public! !
cbSize:!**compiled accessors**!public! !
clsid!**compiled accessors**!public! !
ctime!**compiled accessors**!public! !
ctime:!**compiled accessors**!public! !
grfLocksSupported!**compiled accessors**!public! !
grfLocksSupported:!**compiled accessors**!public! !
grfMode!**compiled accessors**!public! !
grfMode:!**compiled accessors**!public! !
grfStateBits!**compiled accessors**!public! !
isOLEStorage!public!testing! !
isOLEStream!public!testing! !
mtime!**compiled accessors**!public! !
mtime:!**compiled accessors**!public! !
name!accessing!public! !
name:!accessing!public! !
pwcsName!**compiled accessors**!public! !
pwcsName:!**compiled accessors**!public! !
type!**compiled accessors**!public! !
type:!**compiled accessors**!public! !
!

!OS.COM.STATSTG class methodsFor!

byteSize
	^_STATSTG_Size!

clear: addressOrBytes
	"Free external resources referenced by STATSTG
	structure at the specified address. 	
	We must check that the name is non-null because it may be
	even after a successful call with STATFLAG_NONAME specified."

	| addr |
	addr := addressOrBytes uint32AtOffset: 0.
	addr isNull ifFalse: [Ole32 coTaskMemFree: addr]!

defineFields
	"Define the fields of the STATSTG structure.
		STATSTG compileDefinition
	
		typedef 		struct tagSTATSTG {
			LPWSTR pwcsName;
			unsigned long type;
			ULARGE_INTEGER cbSize;
			FILETIME mtime;
			FILETIME ctime;
			FILETIME atime;
			unsigned long grfMode;
			unsigned long grfLocksSupported;
			GUID clsid;
			unsigned long grfStateBits;
			unsigned long reserved;
		} STATSTG;

	"

	self
		defineField: #pwcsName type: (PointerField type: Utf16String);
		defineField: #type type: UInt32Field new;
		defineField: #cbSize type: UInt64Field new;
		defineField: #mtime type: (StructureField type: FILETIME);
		defineField: #ctime type: (StructureField type: FILETIME);
		defineField: #atime type: (StructureField type: FILETIME);
		defineField: #grfMode type: UInt32Field new;
		defineField: #grfLocksSupported type: UInt32Field new;
		defineField: #clsid type: (StructureField type: CLSID) beReadOnly;
		defineField: #grfStateBits type: UInt32Field readOnly;
		defineField: #reserved type: UInt32Field filler!

getFieldNames
	^#(#pwcsName #type #cbSize #mtime #ctime #atime #grfMode #grfLocksSupported #clsid #grfStateBits)! !
!OS.COM.STATSTG class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

