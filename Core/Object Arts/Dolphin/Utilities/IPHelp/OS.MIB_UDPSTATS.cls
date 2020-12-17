"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.MIB_UDPSTATS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwInDatagrams' -> 16r0.
		'_OffsetOf_dwInErrors' -> 16r8.
		'_OffsetOf_dwNoPorts' -> 16r4.
		'_OffsetOf_dwNumAddrs' -> 16r10.
		'_OffsetOf_dwOutDatagrams' -> 16rC
	}!
OS.MIB_UDPSTATS guid: (Core.GUID fromString: '{c9d1622e-d10d-4ba8-a634-acebf006ae2e}')!
OS.MIB_UDPSTATS comment: '<MIB_UDPSTATS> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPSTATS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.MIB_UDPSTATS categoriesForClass!Win32-Structs! !
!OS.MIB_UDPSTATS methodsFor!

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
!OS.MIB_UDPSTATS categoriesFor: #dwInDatagrams!**compiled accessors**!public! !
!OS.MIB_UDPSTATS categoriesFor: #dwInErrors!**compiled accessors**!public! !
!OS.MIB_UDPSTATS categoriesFor: #dwNoPorts!**compiled accessors**!public! !
!OS.MIB_UDPSTATS categoriesFor: #dwNumAddrs!**compiled accessors**!public! !
!OS.MIB_UDPSTATS categoriesFor: #dwOutDatagrams!**compiled accessors**!public! !

!OS.MIB_UDPSTATS class methodsFor!

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
!OS.MIB_UDPSTATS class categoriesFor: #defineFields!initializing!public! !
!OS.MIB_UDPSTATS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

