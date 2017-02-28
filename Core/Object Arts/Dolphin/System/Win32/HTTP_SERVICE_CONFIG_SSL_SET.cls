"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_SSL_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_SET guid: (GUID fromString: '{f2c9434b-739e-4905-bcf3-d552724f69ff}')!
HTTP_SERVICE_CONFIG_SSL_SET comment: '<HTTP_SERVICE_CONFIG_SSL_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(f2c9434b-739e-4905-bcf3-d552724f69ff), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_SET {
	HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
} HTTP_SERVICE_CONFIG_SSL_SET;
'!
!HTTP_SERVICE_CONFIG_SSL_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SET methodsFor!

KeyDesc
	"Answer the <SOCKADDR> value of the receiver's 'KeyDesc' field."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: 0)!

KeyDesc: aSOCKADDR
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR"

	bytes uintPtrAtOffset: 0 put: aSOCKADDR yourAddress!

paramdesc
	"Answer the <HTTP_SERVICE_CONFIG_SSL_PARAM> value of the receiver's 'paramdesc' field."

	^HTTP_SERVICE_CONFIG_SSL_PARAM fromAddress: bytes yourAddress + ##(self offsetOf: #paramdesc)!

paramdesc: aHTTP_SERVICE_CONFIG_SSL_PARAM
	"Set the receiver's 'paramdesc' field to the value of the argument, aHTTP_SERVICE_CONFIG_SSL_PARAM"

	aHTTP_SERVICE_CONFIG_SSL_PARAM
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

	HTTP_SERVICE_CONFIG_SSL_SET compileDefinition

		typedef [uuid(f2c9434b-739e-4905-bcf3-d552724f69ff), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list')]
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

