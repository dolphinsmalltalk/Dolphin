"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.SECURITY_ATTRIBUTES'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_bInheritHandle' -> 16r8.
			'_OffsetOf_lpSecurityDescriptor' -> 16r4.
			'_SECURITY_ATTRIBUTES_Size' -> 16rC
		}!

OS.SECURITY_ATTRIBUTES guid: (Core.GUID fromString: '{f44c9145-2b3f-11d3-8368-7a8b5a000000}')!

OS.SECURITY_ATTRIBUTES comment: '<SECURITY_ATTRIBUTES> is an <ExternalStructure> class to wrap the struct ''Win32.SECURITY_ATTRIBUTES'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains the security descriptor for an object and specifies whether the handle retrieved by specifying this structure is inheritable."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F44C9145-2B3F-11D3-8368-7A8B5A000000), helpstring("Contains the security descriptor for an object and specifies whether the handle retrieved by specifying this structure is inheritable.")]
struct tagSECURITY_ATTRIBUTES {
	[helpstring("The size, in bytes, of this structure.")] unsigned long nLength;
	[helpstring("A pointer to a SECURITY_DESCRIPTOR structure that controls access to the object. If the value of this member is NULL, the object is assigned the default security descriptor associated with the access token of the calling process.")] LPVOID lpSecurityDescriptor;
	[helpstring("Specifies whether the returned handle is inherited when a new process is created. If this member is TRUE, the new process inherits the handle.")] BOOL bInheritHandle;
} SECURITY_ATTRIBUTES;
'!

!OS.SECURITY_ATTRIBUTES categoriesForClass!Win32-Structs! !

!OS.SECURITY_ATTRIBUTES methodsFor!

bInheritHandle
	"Answer the <Boolean> value of the receiver's 'bInheritHandle' field."

	^(bytes uint32AtOffset: _OffsetOf_bInheritHandle) asBoolean!

bInheritHandle: aBoolean
	"Set the receiver's 'bInheritHandle' field to the value of the argument, aBoolean"

	bytes uint32AtOffset: _OffsetOf_bInheritHandle put: aBoolean asParameter!

lpSecurityDescriptor
	"Answer the <Address> value of the receiver's 'lpSecurityDescriptor' field."

	^(bytes uintPtrAtOffset: _OffsetOf_lpSecurityDescriptor) asExternalAddress!

lpSecurityDescriptor: anAddress
	"Set the receiver's 'lpSecurityDescriptor' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpSecurityDescriptor put: anAddress! !

!OS.SECURITY_ATTRIBUTES categoriesForMethods!
bInheritHandle!**compiled accessors**!public! !
bInheritHandle:!**compiled accessors**!public! !
lpSecurityDescriptor!**compiled accessors**!public! !
lpSecurityDescriptor:!**compiled accessors**!public! !
!

!OS.SECURITY_ATTRIBUTES class methodsFor!

byteSize
	^_SECURITY_ATTRIBUTES_Size!

defineFields
	"Define the fields of the SECURITY_ATTRIBUTES structure.

	SECURITY_ATTRIBUTES  compileDefinition

		typedef [uuid(F44C9145-2B3F-11D3-8368-7A8B5A000000), helpstring('Contains the security descriptor for an object and specifies whether the handle retrieved by specifying this structure is inheritable.')]
		struct tagSECURITY_ATTRIBUTES {
			[helpstring('The size, in bytes, of this structure.')] unsigned long nLength;
			[helpstring('A pointer to a SECURITY_DESCRIPTOR structure that controls access to the object. If the value of this member is NULL, the object is assigned the default security descriptor associated with the access token of the calling process.')] LPVOID lpSecurityDescriptor;
			[helpstring('Specifies whether the returned handle is inherited when a new process is created. If this member is TRUE, the new process inherits the handle.')] BOOL bInheritHandle;
		} SECURITY_ATTRIBUTES;
"

	super defineFields.
	self
		defineField: #lpSecurityDescriptor type: LPVOIDField new;
		defineField: #bInheritHandle type: BOOLField new!

getFieldNames
	^#(#dwSize #lpSecurityDescriptor #bInheritHandle)! !

!OS.SECURITY_ATTRIBUTES class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

