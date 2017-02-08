"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_SET guid: (GUID fromString: '{F2C9434B-739E-4905-BCF3-D552724F69FF}')!
HTTP_SERVICE_CONFIG_SSL_SET comment: '<HTTP_SERVICE_CONFIG_SSL_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F2C9434B-739E-4905-BCF3-D552724F69FF), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_SET {
	HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
} HTTP_SERVICE_CONFIG_SSL_SET;
'!
!HTTP_SERVICE_CONFIG_SSL_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SET methodsFor!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: 0)!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress!

paramdesc
	"Answer the receiver's paramdesc field as a Smalltalk object."

	^HTTP_SERVICE_CONFIG_SSL_PARAM fromAddress: bytes yourAddress + ##(self offsetOf: #paramdesc)!

paramdesc: anObject
	"Set the receiver's paramdesc field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #paramdesc) + 1)
		to: ##((self offsetOf: #paramdesc) + HTTP_SERVICE_CONFIG_SSL_PARAM basicByteSize)
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #paramdesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #paramdesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_SET structure.

	HTTP_SERVICE_CONFIG_SSL_SET  compileDefinition

		typedef [uuid(F2C9434B-739E-4905-BCF3-D552724F69FF), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list')]
		struct tagHTTP_SERVICE_CONFIG_SSL_SET {
			HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
		} HTTP_SERVICE_CONFIG_SSL_SET;
"

	self
		defineField: #KeyDesc type: (PointerField type: SOCKADDR) offset: 0;
		defineField: #paramdesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_PARAM) offset: 4.
	self byteSize: 56! !
!HTTP_SERVICE_CONFIG_SSL_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

