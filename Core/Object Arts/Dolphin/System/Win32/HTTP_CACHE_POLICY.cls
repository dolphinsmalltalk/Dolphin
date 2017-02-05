"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_CACHE_POLICY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_CACHE_POLICY guid: (GUID fromString: '{02064551-C601-4E48-85AC-6D19FE34F58B}')!
HTTP_CACHE_POLICY comment: '<HTTP_CACHE_POLICY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_CACHE_POLICY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	" Only cache unauthorized GETs + HEADs."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(02064551-C601-4E48-85AC-6D19FE34F58B), helpstring(" Only cache unauthorized GETs + HEADs.")]
struct tagHTTP_CACHE_POLICY {
	HTTP_CACHE_POLICY_TYPE Policy;
	unsigned long SecondsToLive;
} HTTP_CACHE_POLICY;
'!
!HTTP_CACHE_POLICY categoriesForClass!Win32-Structs! !
!HTTP_CACHE_POLICY methodsFor!

Policy
	"Answer the receiver's Policy field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

Policy: anObject
	"Set the receiver's Policy field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

SecondsToLive
	"Answer the receiver's SecondsToLive field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #SecondsToLive)!

SecondsToLive: anObject
	"Set the receiver's SecondsToLive field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #SecondsToLive) put: anObject! !
!HTTP_CACHE_POLICY categoriesFor: #Policy!**compiled accessors**!public! !
!HTTP_CACHE_POLICY categoriesFor: #Policy:!**compiled accessors**!public! !
!HTTP_CACHE_POLICY categoriesFor: #SecondsToLive!**compiled accessors**!public! !
!HTTP_CACHE_POLICY categoriesFor: #SecondsToLive:!**compiled accessors**!public! !

!HTTP_CACHE_POLICY class methodsFor!

defineFields
	"Define the fields of the HTTP_CACHE_POLICY structure.

	HTTP_CACHE_POLICY  compileDefinition

		typedef [uuid(02064551-C601-4E48-85AC-6D19FE34F58B), helpstring(' Only cache unauthorized GETs + HEADs.')]
		struct tagHTTP_CACHE_POLICY {
			HTTP_CACHE_POLICY_TYPE Policy;
			unsigned long SecondsToLive;
		} HTTP_CACHE_POLICY;
"

	self
		defineField: #Policy type: SDWORDField new offset: 0;
		defineField: #SecondsToLive type: DWORDField new offset: 4.
	self byteSize: 8! !
!HTTP_CACHE_POLICY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

