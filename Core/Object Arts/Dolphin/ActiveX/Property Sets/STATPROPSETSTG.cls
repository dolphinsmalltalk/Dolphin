"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #STATPROPSETSTG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STATPROPSETSTG guid: (GUID fromString: '{D84B17C5-F75E-4F3D-B9A0-DD0B1FCE58B7}')!
STATPROPSETSTG comment: '<STATPROPSETSTG> is an <ExternalStructure> class to wrap the struct ''OBJIDL.STATPROPSETSTG'' from type information in the ''ObjIDL Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagSTATPROPSETSTG {
	GUID fmtid;
	GUID clsid;
	unsigned long grfFlags;
	FILETIME mtime;
	FILETIME ctime;
	FILETIME atime;
	unsigned long dwOSVersion;
} STATPROPSETSTG;
'!
!STATPROPSETSTG categoriesForClass!OBJIDL-Structs! !
!STATPROPSETSTG methodsFor!

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

clsid
	"Answer the receiver's clsid field as a Smalltalk object."

	^GUID fromAddress: bytes yourAddress + ##(self offsetOf: #clsid)!

clsid: anObject 
	"Set the receiver's clsid field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##(self offsetOf: #clsid) + 1
		to: ##(self offsetOf: #clsid) + ##(GUID basicByteSize)
		startingAt: 1!

ctime
	"Answer the receiver's ctime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #ctime)!

ctime: anObject 
	"Set the receiver's ctime field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##(self offsetOf: #ctime) + 1
		to: ##(self offsetOf: #ctime) + ##(FILETIME basicByteSize)
		startingAt: 1!

dwOSVersion
	"Answer the receiver's dwOSVersion field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwOSVersion)!

dwOSVersion: anObject 
	"Set the receiver's dwOSVersion field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwOSVersion) put: anObject!

fmtid
	"Answer the receiver's fmtid field as a Smalltalk object."

	^GUID fromAddress: bytes yourAddress!

fmtid: anObject 
	"Set the receiver's fmtid field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: 1
		to: ##(GUID basicByteSize)
		startingAt: 1!

grfFlags
	"Answer the receiver's grfFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #grfFlags)!

grfFlags: anObject 
	"Set the receiver's grfFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #grfFlags) put: anObject!

mtime
	"Answer the receiver's mtime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #mtime)!

mtime: anObject 
	"Set the receiver's mtime field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##(self offsetOf: #mtime) + 1
		to: ##(self offsetOf: #mtime) + ##(FILETIME basicByteSize)
		startingAt: 1! !
!STATPROPSETSTG categoriesFor: #atime!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #atime:!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #clsid!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #clsid:!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #ctime!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #ctime:!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #dwOSVersion!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #dwOSVersion:!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #fmtid!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #fmtid:!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #grfFlags!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #grfFlags:!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #mtime!**compiled accessors**!public! !
!STATPROPSETSTG categoriesFor: #mtime:!**compiled accessors**!public! !

!STATPROPSETSTG class methodsFor!

defineFields
	"Define the fields of the STATPROPSETSTG structure.
		STATPROPSETSTG compileDefinition
	
		typedef 		struct tagSTATPROPSETSTG {
			GUID fmtid;
			GUID clsid;
			unsigned long grfFlags;
			FILETIME mtime;
			FILETIME ctime;
			FILETIME atime;
			unsigned long dwOSVersion;
		} STATPROPSETSTG;

	"

	self
		defineField: #fmtid type: (StructureField type: GUID);
		defineField: #clsid type: (StructureField type: GUID);
		defineField: #grfFlags type: DWORDField new;
		defineField: #mtime type: (StructureField type: FILETIME);
		defineField: #ctime type: (StructureField type: FILETIME);
		defineField: #atime type: (StructureField type: FILETIME);
		defineField: #dwOSVersion type: DWORDField new! !
!STATPROPSETSTG class categoriesFor: #defineFields!**auto generated**!initializing!public! !

