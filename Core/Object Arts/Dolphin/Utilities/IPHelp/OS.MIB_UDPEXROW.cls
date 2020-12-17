"Filed out from Dolphin Smalltalk 7"!

OS.MIB_UDPROW subclass: #'OS.MIB_UDPEXROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwProcessId' -> 16r8
	}!
OS.MIB_UDPEXROW guid: (Core.GUID fromString: '{fda0765b-395f-447b-881b-26155c88393a}')!
OS.MIB_UDPEXROW comment: '<MIB_UDPEXROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPEXROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.MIB_UDPEXROW categoriesForClass!Win32-Structs! !
!OS.MIB_UDPEXROW methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes dwordAtOffset: _OffsetOf_dwProcessId! !
!OS.MIB_UDPEXROW categoriesFor: #dwProcessId!**compiled accessors**!public! !

!OS.MIB_UDPEXROW class methodsFor!

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
	self byteSize: 12!

getFieldNames
	^#(#dwLocalAddr #dwLocalPort #dwProcessId)! !
!OS.MIB_UDPEXROW class categoriesFor: #defineFields!initializing!public! !
!OS.MIB_UDPEXROW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

