"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #SECURITY_ATTRIBUTES
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bInheritHandle _OffsetOf_dwSize _OffsetOf_lpSecurityDescriptor'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SECURITY_ATTRIBUTES guid: (GUID fromString: '{f44c9145-2b3f-11d3-8368-7a8b5a000000}')!
SECURITY_ATTRIBUTES addClassConstant: '_OffsetOf_bInheritHandle' value: 16r8!
SECURITY_ATTRIBUTES addClassConstant: '_OffsetOf_dwSize' value: 16r0!
SECURITY_ATTRIBUTES addClassConstant: '_OffsetOf_lpSecurityDescriptor' value: 16r4!
SECURITY_ATTRIBUTES comment: '<SECURITY_ATTRIBUTES> is an <ExternalStructure> class to wrap the struct ''Win32.SECURITY_ATTRIBUTES'' from type information in the ''Win32 API'' library.

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
!SECURITY_ATTRIBUTES categoriesForClass!Win32-Structs! !
!SECURITY_ATTRIBUTES methodsFor!

bInheritHandle
	"Answer the <Boolean> value of the receiver's 'bInheritHandle' field."

	^(bytes dwordAtOffset: _OffsetOf_bInheritHandle) asBoolean!

bInheritHandle: aBoolean
	"Set the receiver's 'bInheritHandle' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: _OffsetOf_bInheritHandle put: aBoolean asParameter!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

lpSecurityDescriptor
	"Answer the <ExternalAddress> value of the receiver's 'lpSecurityDescriptor' field."

	^(bytes uintPtrAtOffset: _OffsetOf_lpSecurityDescriptor) asExternalAddress!

lpSecurityDescriptor: anExternalAddress
	"Set the receiver's 'lpSecurityDescriptor' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpSecurityDescriptor put: anExternalAddress! !
!SECURITY_ATTRIBUTES categoriesForMethods!
bInheritHandle!**compiled accessors**!public! !
bInheritHandle:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
lpSecurityDescriptor!**compiled accessors**!public! !
lpSecurityDescriptor:!**compiled accessors**!public! !
!

!SECURITY_ATTRIBUTES class methodsFor!

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

	self
		defineField: #dwSize type: DWORDField new beWriteOnly;
		defineField: #lpSecurityDescriptor type: LPVOIDField new;
		defineField: #bInheritHandle type: BOOLField new!

getFieldNames
	^#(#dwSize #lpSecurityDescriptor #bInheritHandle)! !
!SECURITY_ATTRIBUTES class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

