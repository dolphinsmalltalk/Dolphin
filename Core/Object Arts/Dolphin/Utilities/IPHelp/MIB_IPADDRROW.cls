"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIB_IPADDRROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IPADDRROW guid: (GUID fromString: '{6B58A372-62E2-40B7-861B-D91FE418BACF}')!
MIB_IPADDRROW comment: '<MIB_IPADDRROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPADDRROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPADDRROW {
	unsigned long dwAddr;
	unsigned long dwIndex;
	unsigned long dwMask;
	unsigned long dwBCastAddr;
	unsigned long dwReasmSize;
	unsigned short Unused1;
	unsigned short wType;
} MIB_IPADDRROW;
'!
!MIB_IPADDRROW categoriesForClass!Win32-Structs! !
!MIB_IPADDRROW methodsFor!

dwAddr
	"Answer the receiver's dwAddr field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwBCastAddr
	"Answer the receiver's dwBCastAddr field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwIndex
	"Answer the receiver's dwIndex field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwMask
	"Answer the receiver's dwMask field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwReasmSize
	"Answer the receiver's dwReasmSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

wType
	"Answer the receiver's wType field as a Smalltalk object."

	^(bytes wordAtOffset: 22)! !
!MIB_IPADDRROW categoriesFor: #dwAddr!**compiled accessors**!public! !
!MIB_IPADDRROW categoriesFor: #dwBCastAddr!**compiled accessors**!public! !
!MIB_IPADDRROW categoriesFor: #dwIndex!**compiled accessors**!public! !
!MIB_IPADDRROW categoriesFor: #dwMask!**compiled accessors**!public! !
!MIB_IPADDRROW categoriesFor: #dwReasmSize!**compiled accessors**!public! !
!MIB_IPADDRROW categoriesFor: #wType!**compiled accessors**!public! !

!MIB_IPADDRROW class methodsFor!

defineFields
	"Define the fields of the MIB_IPADDRROW structure.
		MIB_IPADDRROW compileDefinition
	
		typedef 
		struct tagMIB_IPADDRROW {
			unsigned long dwAddr;
			unsigned long dwIndex;
			unsigned long dwMask;
			unsigned long dwBCastAddr;
			unsigned long dwReasmSize;
			unsigned short Unused1;
			unsigned short wType;
		} MIB_IPADDRROW;
"

	self
		defineField: #dwAddr
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwIndex
			type: DWORDField readOnly
			offset: 4;
		defineField: #dwMask
			type: DWORDField readOnly
			offset: 8;
		defineField: #dwBCastAddr
			type: DWORDField readOnly
			offset: 12;
		defineField: #dwReasmSize
			type: DWORDField readOnly
			offset: 16;
		defineField: #Unused1
			type: WORDField filler
			offset: 20;
		defineField: #wType
			type: WORDField readOnly
			offset: 22.
	self byteSize: 24! !
!MIB_IPADDRROW class categoriesFor: #defineFields!initializing!public! !

