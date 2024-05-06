"Filed out from Dolphin Smalltalk"!

OLEFinalizableStructure subclass: #STATSTG
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_atime _OffsetOf_cbSize _OffsetOf_clsid _OffsetOf_ctime _OffsetOf_dwStgFmt _OffsetOf_grfLocksSupported _OffsetOf_grfMode _OffsetOf_grfStateBits _OffsetOf_mtime _OffsetOf_pwcsName _OffsetOf_type'
	poolDictionaries: 'OLEStructuredStorageConstants'
	classInstanceVariableNames: ''!

STATSTG guid: (GUID fromString: '{87b4c5c3-026e-11d3-9fd7-00a0cc3e4a32}')!

STATSTG addClassConstant: '_OffsetOf_atime' value: 16r20!
STATSTG addClassConstant: '_OffsetOf_cbSize' value: 16r8!
STATSTG addClassConstant: '_OffsetOf_clsid' value: 16r30!
STATSTG addClassConstant: '_OffsetOf_ctime' value: 16r18!
STATSTG addClassConstant: '_OffsetOf_dwStgFmt' value: 16r44!
STATSTG addClassConstant: '_OffsetOf_grfLocksSupported' value: 16r2C!
STATSTG addClassConstant: '_OffsetOf_grfMode' value: 16r28!
STATSTG addClassConstant: '_OffsetOf_grfStateBits' value: 16r40!
STATSTG addClassConstant: '_OffsetOf_mtime' value: 16r10!
STATSTG addClassConstant: '_OffsetOf_pwcsName' value: 16r0!
STATSTG addClassConstant: '_OffsetOf_type' value: 16r4!

STATSTG comment: 'STATSTG is an <ExternalStructure> class to represent the OLE Structured Storage structure of the same name.

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

!STATSTG categoriesForClass!External-Data-Structured-COM! !

!STATSTG methodsFor!

atime
	"Answer the <FILETIME> value of the receiver's 'atime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_atime!

atime: aFILETIME
	"Set the receiver's 'atime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_atime + 1)
		to: ##(_OffsetOf_atime + FILETIME basicByteSize)
		startingAt: 1!

cbSize
	"Answer the <Integer> value of the receiver's 'cbSize' field."

	^bytes qwordAtOffset: _OffsetOf_cbSize!

cbSize: anInteger
	"Set the receiver's 'cbSize' field to the value of the argument, anInteger"

	bytes qwordAtOffset: _OffsetOf_cbSize put: anInteger!

clsid
	"Answer the <CLSID> value of the receiver's 'clsid' field."

	^CLSID fromAddress: bytes yourAddress + _OffsetOf_clsid!

ctime
	"Answer the <FILETIME> value of the receiver's 'ctime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ctime!

dwStgFmt
	"Answer the <Integer> value of the receiver's 'dwStgFmt' field."

	^bytes dwordAtOffset: _OffsetOf_dwStgFmt!

grfLocksSupported
	"Answer the <Integer> value of the receiver's 'grfLocksSupported' field."

	^bytes dwordAtOffset: _OffsetOf_grfLocksSupported!

grfLocksSupported: anInteger
	"Set the receiver's 'grfLocksSupported' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_grfLocksSupported put: anInteger!

grfMode
	"Answer the <Integer> value of the receiver's 'grfMode' field."

	^bytes dwordAtOffset: _OffsetOf_grfMode!

grfStateBits
	"Answer the <Integer> value of the receiver's 'grfStateBits' field."

	^bytes dwordAtOffset: _OffsetOf_grfStateBits!

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

name
	"Answer the <readableString> name of the object whose status the receiver is recording."

	^self pwcsName asString!

name: aString
	"Set the <readableString> name of the object whose status the receiver is recording."

	| name |
	name := aString asUtf16String copyToCOMTaskMemory.
	self pwcsName: name.
	"struct now has ownership of the name"
	name beUnfinalizable!

pwcsName
	"Answer the <Utf16String> value of the receiver's 'pwcsName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwcsName)!

pwcsName: anUtf16String
	"Set the receiver's 'pwcsName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwcsName put: anUtf16String yourAddress!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes dwordAtOffset: _OffsetOf_type!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_type put: anInteger! !

!STATSTG categoriesForMethods!
atime!**compiled accessors**!public! !
atime:!**compiled accessors**!public! !
cbSize!**compiled accessors**!public! !
cbSize:!**compiled accessors**!public! !
clsid!**compiled accessors**!public! !
ctime!**compiled accessors**!public! !
dwStgFmt!**compiled accessors**!public! !
grfLocksSupported!**compiled accessors**!public! !
grfLocksSupported:!**compiled accessors**!public! !
grfMode!**compiled accessors**!public! !
grfStateBits!**compiled accessors**!public! !
isOLEStorage!public!testing! !
isOLEStream!public!testing! !
mtime!**compiled accessors**!public! !
name!accessing!public! !
name:!accessing!public! !
pwcsName!**compiled accessors**!public! !
pwcsName:!**compiled accessors**!public! !
type!**compiled accessors**!public! !
type:!**compiled accessors**!public! !
!

!STATSTG class methodsFor!

clear: addressOrBytes 
	"Free external resources referenced by STATSTG
	structure at the specified address. 	
	We must check that the name is non-null because it may be
	even after a successful call with STATFLAG_NONAME specified."

	| addr |
	addr := addressOrBytes dwordAtOffset: 0.
	addr isNull ifFalse: [COMTaskMemory free: addr]!

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
		defineField: #type type: DWORDField new;
		defineField: #cbSize type: QWORDField new;
		defineField: #mtime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #ctime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #atime type: (StructureField type: FILETIME);
		defineField: #grfMode type: DWORDField readOnly;
		defineField: #grfLocksSupported type: DWORDField new;
		defineField: #clsid type: (StructureField type: CLSID) beReadOnly;
		defineField: #grfStateBits type: DWORDField readOnly;
		defineField: #dwStgFmt type: DWORDField readOnly!

getFieldNames
	^#(#pwcsName #type #cbSize #mtime #ctime #atime #grfMode #grfLocksSupported #clsid #grfStateBits #dwStgFmt)! !

!STATSTG class categoriesForMethods!
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

