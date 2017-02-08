"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM guid: (GUID fromString: '{00A93E39-C011-4A5B-AF4D-13F2DF7A38D4}')!
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM comment: '<HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Set/Delete IP Listen-Only List record. Used as a parameter to both HttpSetServiceConfiguration() and HttpDeleteServiceConfiguration() functions."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(00A93E39-C011-4A5B-AF4D-13F2DF7A38D4), helpstring("Set/Delete IP Listen-Only List record. Used as a parameter to both HttpSetServiceConfiguration() and HttpDeleteServiceConfiguration() functions.")]
struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_PARAM {
	unsigned short AddrLength;
	sockaddr* pAddress;
} HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM;
'!
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM methodsFor!

AddrLength
	"Answer the receiver's AddrLength field as a Smalltalk object."

	^bytes wordAtOffset: 0!

AddrLength: anObject
	"Set the receiver's AddrLength field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

pAddress
	"Answer the receiver's pAddress field as a Smalltalk object."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pAddress))!

pAddress: anObject
	"Set the receiver's pAddress field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pAddress) put: anObject yourAddress! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM categoriesFor: #AddrLength!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM categoriesFor: #AddrLength:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM categoriesFor: #pAddress!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM categoriesFor: #pAddress:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM structure.

	HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM  compileDefinition

		typedef [uuid(00A93E39-C011-4A5B-AF4D-13F2DF7A38D4), helpstring('Set/Delete IP Listen-Only List record. Used as a parameter to both HttpSetServiceConfiguration() and HttpDeleteServiceConfiguration() functions.')]
		struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_PARAM {
			unsigned short AddrLength;
			SOCKADDR* pAddress;
		} HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM;
"

	self
		defineField: #AddrLength type: WORDField new offset: 0;
		defineField: #pAddress type: (PointerField type: SOCKADDR) offset: 4.
	self byteSize: 8! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class categoriesFor: #defineFields!**auto generated**!initializing!public! !

