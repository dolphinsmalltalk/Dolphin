"Filed out from Dolphin Smalltalk X6"!

MIB_UDPROW subclass: #MIB_UDPEXROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_UDPEXROW guid: (GUID fromString: '{FDA0765B-395F-447B-881B-26155C88393A}')!
MIB_UDPEXROW comment: '<MIB_UDPEXROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPEXROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_UDPEXROW {
	unsigned long dwLocalAddr;
	unsigned long dwLocalPort;
	unsigned long dwProcessId;
} MIB_UDPEXROW;
'!
!MIB_UDPEXROW categoriesForClass!Win32-Structs! !
!MIB_UDPEXROW methodsFor!

dwProcessId
	"Answer the receiver's dwProcessId field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)! !
!MIB_UDPEXROW categoriesFor: #dwProcessId!**compiled accessors**!public! !

!MIB_UDPEXROW class methodsFor!

defineFields
	"Define the fields of the MIB_UDPEXROW structure.
		MIB_UDPEXROW compileDefinition
	
		typedef 
		struct tagMIB_UDPEXROW {
			unsigned long dwLocalAddr;
			unsigned long dwLocalPort;
			unsigned long dwProcessId;
		} MIB_UDPEXROW;
"

	super defineFields.
	self 
		defineField: #dwProcessId
		type: DWORDField readOnly
		offset: 8.
	self byteSize: 12! !
!MIB_UDPEXROW class categoriesFor: #defineFields!initializing!public! !

