"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_CHANNEL_BIND_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_CHANNEL_BIND_INFO guid: (GUID fromString: '{84EA1900-0BC6-4AC8-9025-7F74436D5DC9}')!
HTTP_CHANNEL_BIND_INFO comment: '<HTTP_CHANNEL_BIND_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_CHANNEL_BIND_INFO'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(84EA1900-0BC6-4AC8-9025-7F74436D5DC9)]
struct tagHTTP_CHANNEL_BIND_INFO {
	HTTP_AUTHENTICATION_HARDENING_LEVELS Hardening;
	unsigned long flags;
	PHTTP_SERVICE_BINDING_BASE* ServiceNames;
	unsigned long NumberOfServiceNames;
} HTTP_CHANNEL_BIND_INFO;
'!
!HTTP_CHANNEL_BIND_INFO categoriesForClass!Win32-Structs! !
!HTTP_CHANNEL_BIND_INFO methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

Hardening
	"Answer the receiver's Hardening field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

Hardening: anObject
	"Set the receiver's Hardening field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

NumberOfServiceNames
	"Answer the receiver's NumberOfServiceNames field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #NumberOfServiceNames)!

NumberOfServiceNames: anObject
	"Set the receiver's NumberOfServiceNames field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #NumberOfServiceNames) put: anObject!

ServiceNames
	"Answer the receiver's ServiceNames field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #ServiceNames)) asExternalAddress!

ServiceNames: anObject
	"Set the receiver's ServiceNames field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #ServiceNames) put: anObject! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #Hardening!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #Hardening:!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #NumberOfServiceNames!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #NumberOfServiceNames:!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #ServiceNames!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #ServiceNames:!**compiled accessors**!public! !

!HTTP_CHANNEL_BIND_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_CHANNEL_BIND_INFO structure.

	HTTP_CHANNEL_BIND_INFO  compileDefinition

		typedef [uuid(84EA1900-0BC6-4AC8-9025-7F74436D5DC9)]
		struct tagHTTP_CHANNEL_BIND_INFO {
			HTTP_AUTHENTICATION_HARDENING_LEVELS Hardening;
			unsigned long flags;
			PHTTP_SERVICE_BINDING_BASE* ServiceNames;
			unsigned long NumberOfServiceNames;
		} HTTP_CHANNEL_BIND_INFO;
"

	self
		defineField: #Hardening type: SDWORDField new offset: 0;
		defineField: #flags type: DWORDField new offset: 4;
		defineField: #ServiceNames type: LPVOIDField new offset: 8;
		defineField: #NumberOfServiceNames type: DWORDField new offset: 12.
	self byteSize: 16! !
!HTTP_CHANNEL_BIND_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

