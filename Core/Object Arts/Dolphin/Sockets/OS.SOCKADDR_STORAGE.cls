"Filed out from Dolphin Smalltalk 7"!

OS.SOCKADDR subclass: #'OS.SOCKADDR_STORAGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf___ss_align' -> 16r8.
		'_OffsetOf___ss_pad1' -> 16r2.
		'_OffsetOf___ss_pad2' -> 16r10.
		'_OffsetOf_ss_family' -> 16r0
	}!
OS.SOCKADDR_STORAGE guid: (Core.GUID fromString: '{ff1980c9-d114-4e61-8569-e2ed5321209b}')!
OS.SOCKADDR_STORAGE comment: '<SOCKADDR_STORAGE> is an <ExternalStructure> class to wrap the struct ''Win32.SOCKADDR_STORAGE'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"A generic structure that specifies a transport address"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(FF1980C9-D114-4E61-8569-E2ED5321209B), helpstring("A generic structure that specifies a transport address")]
struct tagSOCKADDR_STORAGE {
	[hidden] ADDRESS_FAMILY ss_family;
	[hidden] BYTE __ss_pad1[6];
	[hidden] __int64 __ss_align;
	[hidden] BYTE __ss_pad2[112];
} SOCKADDR_STORAGE;
'!
!OS.SOCKADDR_STORAGE categoriesForClass!Win32-Structs! !
!OS.SOCKADDR_STORAGE class methodsFor!

defineFields
	"Define the fields of the SOCKADDR_STORAGE structure.

	SOCKADDR_STORAGE compileDefinition

		typedef [uuid(ff1980c9-d114-4e61-8569-e2ed5321209b), helpstring('A generic structure that specifies a transport address')]
		struct tagSOCKADDR_STORAGE {
			[hidden] ADDRESS_FAMILY ss_family;
			[hidden] BYTE __ss_pad1[6];
			[hidden] __int64 __ss_align;
			[hidden] BYTE __ss_pad2[112];
		} SOCKADDR_STORAGE;
"

	self
		defineField: #ss_family type: WORDField new beFiller offset: 0;
		defineField: #__ss_pad1 type: (ArrayField type: ExternalArray length: 6) beFiller offset: 2;
		defineField: #__ss_align type: SQWORDField new beFiller offset: 8;
		defineField: #__ss_pad2 type: (ArrayField type: ExternalArray length: 112) beFiller offset: 16.
	self byteSize: 128!

getFieldNames
	^#()! !
!OS.SOCKADDR_STORAGE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.SOCKADDR_STORAGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

