"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_CONNECTION_LIMIT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_CONNECTION_LIMIT_INFO guid: (GUID fromString: '{6FCA5840-1E00-4065-AD55-203BD079A117}')!
HTTP_CONNECTION_LIMIT_INFO comment: '<HTTP_CONNECTION_LIMIT_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_CONNECTION_LIMIT_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used to set or query the limit on the maximum number of outstanding connections for a URL Group."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(6FCA5840-1E00-4065-AD55-203BD079A117), helpstring("Used to set or query the limit on the maximum number of outstanding connections for a URL Group.")]
struct tagHTTP_CONNECTION_LIMIT_INFO {
	HTTP_PROPERTY_FLAGS flags;
	unsigned long MaxConnections;
} HTTP_CONNECTION_LIMIT_INFO;
'!
!HTTP_CONNECTION_LIMIT_INFO categoriesForClass!Win32-Structs! !
!HTTP_CONNECTION_LIMIT_INFO methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

MaxConnections
	"Answer the receiver's MaxConnections field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #MaxConnections)!

MaxConnections: anObject
	"Set the receiver's MaxConnections field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #MaxConnections) put: anObject! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #MaxConnections!**compiled accessors**!public! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #MaxConnections:!**compiled accessors**!public! !

!HTTP_CONNECTION_LIMIT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_CONNECTION_LIMIT_INFO structure.

	HTTP_CONNECTION_LIMIT_INFO  compileDefinition

		typedef [uuid(6FCA5840-1E00-4065-AD55-203BD079A117), helpstring('Used to set or query the limit on the maximum number of outstanding connections for a URL Group.')]
		struct tagHTTP_CONNECTION_LIMIT_INFO {
			HTTP_PROPERTY_FLAGS flags;
			unsigned long MaxConnections;
		} HTTP_CONNECTION_LIMIT_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #MaxConnections type: DWORDField new offset: 4.
	self byteSize: 8! !
!HTTP_CONNECTION_LIMIT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

