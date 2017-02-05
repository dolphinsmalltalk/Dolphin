"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_REQUEST_CHANNEL_BIND_STATUS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST_CHANNEL_BIND_STATUS guid: (GUID fromString: '{2FC21C2A-E0C8-4C4C-A68F-E8270F8FBD2A}')!
HTTP_REQUEST_CHANNEL_BIND_STATUS comment: '<HTTP_REQUEST_CHANNEL_BIND_STATUS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_CHANNEL_BIND_STATUS'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2FC21C2A-E0C8-4C4C-A68F-E8270F8FBD2A)]
struct tagHTTP_REQUEST_CHANNEL_BIND_STATUS {
	PHTTP_SERVICE_BINDING_BASE ServiceName;
	BYTE* ChannelToken;
	unsigned long ChannelTokenSize;
	unsigned long flags;
} HTTP_REQUEST_CHANNEL_BIND_STATUS;
'!
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS methodsFor!

ChannelToken
	"Answer the receiver's ChannelToken field as a Smalltalk object."

	^BYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ChannelToken))!

ChannelToken: anObject
	"Set the receiver's ChannelToken field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #ChannelToken) put: anObject yourAddress!

ChannelTokenSize
	"Answer the receiver's ChannelTokenSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ChannelTokenSize)!

ChannelTokenSize: anObject
	"Set the receiver's ChannelTokenSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ChannelTokenSize) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

ServiceName
	"Answer the receiver's ServiceName field as a Smalltalk object."

	^HTTP_SERVICE_BINDING_BASE fromAddress: (bytes intPtrAtOffset: 0)!

ServiceName: anObject
	"Set the receiver's ServiceName field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelToken!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelToken:!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelTokenSize!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelTokenSize:!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ServiceName!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ServiceName:!**compiled accessors**!public! !

!HTTP_REQUEST_CHANNEL_BIND_STATUS class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_CHANNEL_BIND_STATUS structure.

	HTTP_REQUEST_CHANNEL_BIND_STATUS  compileDefinition

		typedef [uuid(2FC21C2A-E0C8-4C4C-A68F-E8270F8FBD2A)]
		struct tagHTTP_REQUEST_CHANNEL_BIND_STATUS {
			PHTTP_SERVICE_BINDING_BASE ServiceName;
			BYTE* ChannelToken;
			unsigned long ChannelTokenSize;
			unsigned long flags;
		} HTTP_REQUEST_CHANNEL_BIND_STATUS;
"

	self
		defineField: #ServiceName type: (PointerField type: HTTP_SERVICE_BINDING_BASE) offset: 0;
		defineField: #ChannelToken type: (PointerField type: BYTE) offset: 4;
		defineField: #ChannelTokenSize type: DWORDField new offset: 8;
		defineField: #flags type: DWORDField new offset: 12.
	self byteSize: 16! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

