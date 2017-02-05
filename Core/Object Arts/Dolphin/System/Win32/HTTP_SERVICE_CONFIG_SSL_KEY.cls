"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_KEY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_KEY guid: (GUID fromString: '{1B197959-4571-4CB1-AF19-6728D6BA0A55}')!
HTTP_SERVICE_CONFIG_SSL_KEY comment: '<HTTP_SERVICE_CONFIG_SSL_KEY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_KEY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"These data structures are used to define the key types of the various SSL bindings."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1B197959-4571-4CB1-AF19-6728D6BA0A55), helpstring("These data structures are used to define the key types of the various SSL bindings.")]
struct tagHTTP_SERVICE_CONFIG_SSL_KEY {
	sockaddr* pIpPort;
} HTTP_SERVICE_CONFIG_SSL_KEY;
'!
!HTTP_SERVICE_CONFIG_SSL_KEY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_KEY methodsFor!

pIpPort
	"Answer the receiver's pIpPort field as a Smalltalk object."

	^Sockaddr fromAddress: (bytes intPtrAtOffset: 0)!

pIpPort: anObject
	"Set the receiver's pIpPort field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress! !
!HTTP_SERVICE_CONFIG_SSL_KEY categoriesFor: #pIpPort!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_KEY categoriesFor: #pIpPort:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_KEY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_KEY structure.

	HTTP_SERVICE_CONFIG_SSL_KEY  compileDefinition

		typedef [uuid(1B197959-4571-4CB1-AF19-6728D6BA0A55), helpstring('These data structures are used to define the key types of the various SSL bindings.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_KEY {
			sockaddr* pIpPort;
		} HTTP_SERVICE_CONFIG_SSL_KEY;
"

	self
		defineField: #pIpPort type: (PointerField type: Sockaddr) offset: 0.
	self byteSize: 4! !
!HTTP_SERVICE_CONFIG_SSL_KEY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

