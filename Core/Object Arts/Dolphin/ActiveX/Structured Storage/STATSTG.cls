"Filed out from Dolphin Smalltalk X6.1"!

OLEFinalizableStructure subclass: #STATSTG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'OLEStructuredStorageConstants'
	classInstanceVariableNames: ''!
STATSTG guid: (GUID fromString: '{87B4C5C3-026E-11D3-9FD7-00A0CC3E4A32}')!
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
	"Answer the receiver's atime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #atime)!

atime: anObject 
	"Set the receiver's atime field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##(self offsetOf: #atime) + 1
		to: ##(self offsetOf: #atime) + ##(FILETIME basicByteSize)
		startingAt: 1!

cbSize
	"Answer the receiver's cbSize field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #cbSize)!

cbSize: anObject 
	"Set the receiver's cbSize field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #cbSize) put: anObject!

clsid
	"Answer the receiver's clsid field as a Smalltalk object."

	^CLSID fromAddress: bytes yourAddress + ##(self offsetOf: #clsid)!

ctime
	"Answer the receiver's ctime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #ctime)!

dwStgFmt
	"Answer the receiver's dwStgFmt field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwStgFmt)!

grfLocksSupported
	"Answer the receiver's grfLocksSupported field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #grfLocksSupported)!

grfLocksSupported: anObject 
	"Set the receiver's grfLocksSupported field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #grfLocksSupported) put: anObject!

grfMode
	"Answer the receiver's grfMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #grfMode)!

grfStateBits
	"Answer the receiver's grfStateBits field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #grfStateBits)!

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
	"Answer the receiver's mtime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #mtime)!

name
	"Answer the <readableString> name of the object whose status the receiver is recording."

	^self pwcsName asString!

name: aString 
	"Set the <readableString> name of the object whose status the receiver is recording."

	| name |
	name := aString asUnicodeString copyToCOMTaskMemory.
	self pwcsName: name.
	"struct now has ownership of the name"
	name beUnfinalizable!

pwcsName
	"Answer the receiver's pwcsName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 0)!

pwcsName: anObject 
	"Set the receiver's pwcsName field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress!

type
	"Answer the receiver's type field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #type)!

type: anObject 
	"Set the receiver's type field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #type) put: anObject! !
!STATSTG categoriesFor: #atime!**compiled accessors**!public! !
!STATSTG categoriesFor: #atime:!**compiled accessors**!public! !
!STATSTG categoriesFor: #cbSize!**compiled accessors**!public! !
!STATSTG categoriesFor: #cbSize:!**compiled accessors**!public! !
!STATSTG categoriesFor: #clsid!**compiled accessors**!public! !
!STATSTG categoriesFor: #ctime!**compiled accessors**!public! !
!STATSTG categoriesFor: #dwStgFmt!**compiled accessors**!public! !
!STATSTG categoriesFor: #grfLocksSupported!**compiled accessors**!public! !
!STATSTG categoriesFor: #grfLocksSupported:!**compiled accessors**!public! !
!STATSTG categoriesFor: #grfMode!**compiled accessors**!public! !
!STATSTG categoriesFor: #grfStateBits!**compiled accessors**!public! !
!STATSTG categoriesFor: #isOLEStorage!public!testing! !
!STATSTG categoriesFor: #isOLEStream!public!testing! !
!STATSTG categoriesFor: #mtime!**compiled accessors**!public! !
!STATSTG categoriesFor: #name!accessing!public! !
!STATSTG categoriesFor: #name:!accessing!public! !
!STATSTG categoriesFor: #pwcsName!**compiled accessors**!public! !
!STATSTG categoriesFor: #pwcsName:!**compiled accessors**!public! !
!STATSTG categoriesFor: #type!**compiled accessors**!public! !
!STATSTG categoriesFor: #type:!**compiled accessors**!public! !

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
		defineField: #pwcsName type: (PointerField type: UnicodeString);
		defineField: #type type: DWORDField new;
		defineField: #cbSize type: QWORDField new;
		defineField: #mtime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #ctime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #atime type: (StructureField type: FILETIME);
		defineField: #grfMode type: DWORDField readOnly;
		defineField: #grfLocksSupported type: DWORDField new;
		defineField: #clsid type: (StructureField type: CLSID) beReadOnly;
		defineField: #grfStateBits type: DWORDField readOnly;
		defineField: #dwStgFmt type: DWORDField readOnly! !
!STATSTG class categoriesFor: #clear:!public!realizing/unrealizing! !
!STATSTG class categoriesFor: #defineFields!initializing!public! !

