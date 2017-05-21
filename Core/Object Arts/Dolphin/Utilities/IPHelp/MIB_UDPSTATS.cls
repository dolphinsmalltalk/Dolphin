"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIB_UDPSTATS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_UDPSTATS guid: (GUID fromString: '{c9d1622e-d10d-4ba8-a634-acebf006ae2e}')!
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
	"Answer the receiver's dwInDatagrams field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwInErrors
	"Answer the receiver's dwInErrors field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwNoPorts
	"Answer the receiver's dwNoPorts field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwNumAddrs
	"Answer the receiver's dwNumAddrs field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwOutDatagrams
	"Answer the receiver's dwOutDatagrams field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)! !
!MIB_UDPSTATS categoriesFor: #dwInDatagrams!**compiled accessors**!public! !
!MIB_UDPSTATS categoriesFor: #dwInErrors!**compiled accessors**!public! !
!MIB_UDPSTATS categoriesFor: #dwNoPorts!**compiled accessors**!public! !
!MIB_UDPSTATS categoriesFor: #dwNumAddrs!**compiled accessors**!public! !
!MIB_UDPSTATS categoriesFor: #dwOutDatagrams!**compiled accessors**!public! !

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
	self byteSize: 20! !
!MIB_UDPSTATS class categoriesFor: #defineFields!initializing!public! !

