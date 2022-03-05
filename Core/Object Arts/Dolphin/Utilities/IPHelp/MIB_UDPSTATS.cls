"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MIB_UDPSTATS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwInDatagrams _OffsetOf_dwInErrors _OffsetOf_dwNoPorts _OffsetOf_dwNumAddrs _OffsetOf_dwOutDatagrams'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_UDPSTATS guid: (GUID fromString: '{c9d1622e-d10d-4ba8-a634-acebf006ae2e}')!
MIB_UDPSTATS addClassConstant: '_OffsetOf_dwInDatagrams' value: 16r0!
MIB_UDPSTATS addClassConstant: '_OffsetOf_dwInErrors' value: 16r8!
MIB_UDPSTATS addClassConstant: '_OffsetOf_dwNoPorts' value: 16r4!
MIB_UDPSTATS addClassConstant: '_OffsetOf_dwNumAddrs' value: 16r10!
MIB_UDPSTATS addClassConstant: '_OffsetOf_dwOutDatagrams' value: 16rC!
MIB_UDPSTATS comment: '<MIB_UDPSTATS> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPSTATS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_UDPSTATS {
	unsigned long dwInDatagrams;
	unsigned long dwNoPorts;
	unsigned long dwInErrors;
	unsigned long dwOutDatagrams;
	unsigned long dwNumAddrs;
} MIB_UDPSTATS;
'!
!MIB_UDPSTATS categoriesForClass!Win32-Structs! !
!MIB_UDPSTATS methodsFor!

dwInDatagrams
	"Answer the <Integer> value of the receiver's 'dwInDatagrams' field."

	^bytes dwordAtOffset: _OffsetOf_dwInDatagrams!

dwInErrors
	"Answer the <Integer> value of the receiver's 'dwInErrors' field."

	^bytes dwordAtOffset: _OffsetOf_dwInErrors!

dwNoPorts
	"Answer the <Integer> value of the receiver's 'dwNoPorts' field."

	^bytes dwordAtOffset: _OffsetOf_dwNoPorts!

dwNumAddrs
	"Answer the <Integer> value of the receiver's 'dwNumAddrs' field."

	^bytes dwordAtOffset: _OffsetOf_dwNumAddrs!

dwOutDatagrams
	"Answer the <Integer> value of the receiver's 'dwOutDatagrams' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutDatagrams! !
!MIB_UDPSTATS categoriesForMethods!
dwInDatagrams!**compiled accessors**!public! !
dwInErrors!**compiled accessors**!public! !
dwNoPorts!**compiled accessors**!public! !
dwNumAddrs!**compiled accessors**!public! !
dwOutDatagrams!**compiled accessors**!public! !
!

!MIB_UDPSTATS class methodsFor!

defineFields
	"Define the fields of the MIB_UDPSTATS structure.
		MIB_UDPSTATS compileDefinition
	
		typedef 
		struct tagMIB_UDPSTATS {
			unsigned long dwInDatagrams;
			unsigned long dwNoPorts;
			unsigned long dwInErrors;
			unsigned long dwOutDatagrams;
			unsigned long dwNumAddrs;
		} MIB_UDPSTATS;
"

	self
		defineField: #dwInDatagrams type: DWORDField readOnly offset: 0;
		defineField: #dwNoPorts type: DWORDField readOnly offset: 4;
		defineField: #dwInErrors type: DWORDField readOnly offset: 8;
		defineField: #dwOutDatagrams type: DWORDField readOnly offset: 12;
		defineField: #dwNumAddrs type: DWORDField readOnly offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#dwInDatagrams #dwNoPorts #dwInErrors #dwOutDatagrams #dwNumAddrs)! !
!MIB_UDPSTATS class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

