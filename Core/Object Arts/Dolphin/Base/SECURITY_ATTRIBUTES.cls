"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #SECURITY_ATTRIBUTES
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SECURITY_ATTRIBUTES guid: (GUID fromString: '{f44c9145-2b3f-11d3-8368-7a8b5a000000}')!
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
	"Answer the receiver's bInheritHandle field as a Smalltalk object."

	^(bytes dwordAtOffset: ##(self offsetOf: #bInheritHandle)) asBoolean!

bInheritHandle: anObject
	"Set the receiver's bInheritHandle field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #bInheritHandle) put: anObject asParameter!

dwSize: anObject
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

lpSecurityDescriptor
	"Answer the receiver's lpSecurityDescriptor field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #lpSecurityDescriptor)) asExternalAddress!

lpSecurityDescriptor: anObject
	"Set the receiver's lpSecurityDescriptor field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpSecurityDescriptor) put: anObject! !
!SECURITY_ATTRIBUTES categoriesFor: #bInheritHandle!**compiled accessors**!public! !
!SECURITY_ATTRIBUTES categoriesFor: #bInheritHandle:!**compiled accessors**!public! !
!SECURITY_ATTRIBUTES categoriesFor: #dwSize:!**compiled accessors**!public! !
!SECURITY_ATTRIBUTES categoriesFor: #lpSecurityDescriptor!**compiled accessors**!public! !
!SECURITY_ATTRIBUTES categoriesFor: #lpSecurityDescriptor:!**compiled accessors**!public! !

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
		defineField: #bInheritHandle type: BOOLField new! !
!SECURITY_ATTRIBUTES class categoriesFor: #defineFields!initializing!public! !

