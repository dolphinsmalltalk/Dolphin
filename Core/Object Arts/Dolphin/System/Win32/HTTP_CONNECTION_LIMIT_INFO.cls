"Filed out from Dolphin Smalltalk 7"!

HttpQosSetting subclass: #HTTP_CONNECTION_LIMIT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_CONNECTION_LIMIT_INFO guid: (GUID fromString: '{6fca5840-1e00-4065-ad55-203bd079a117}')!
HTTP_CONNECTION_LIMIT_INFO comment: '<HTTP_CONNECTION_LIMIT_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_CONNECTION_LIMIT_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used to set or query the limit on the maximum number of outstanding connections for a URL Group."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(6fca5840-1e00-4065-ad55-203bd079a117), helpstring("Used to set or query the limit on the maximum number of outstanding connections for a URL Group.")]
struct tagHTTP_CONNECTION_LIMIT_INFO {
	[nonbrowsable] HTTP_PROPERTY_FLAGS;
	ULONG MaxConnections;
} HTTP_CONNECTION_LIMIT_INFO;
'!
!HTTP_CONNECTION_LIMIT_INFO categoriesForClass!Win32-Structs! !
!HTTP_CONNECTION_LIMIT_INFO methodsFor!

MaxConnections
	"Answer the <Integer> value of the receiver's 'MaxConnections' field."

	^bytes dwordAtOffset: ##(self offsetOf: #MaxConnections)!

MaxConnections: anInteger
	"Set the receiver's 'MaxConnections' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #MaxConnections) put: anInteger!

value
	^self Present ifTrue: [self MaxConnections]!

value: anInteger
	anInteger
		ifNil: 
			[self
				Present: false;
				MaxConnections: 0]
		ifNotNil: 
			[self
				Present: true;
				MaxConnections: anInteger]! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #MaxConnections!**compiled accessors**!public! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #MaxConnections:!**compiled accessors**!public! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #value!accessing!public! !
!HTTP_CONNECTION_LIMIT_INFO categoriesFor: #value:!accessing!public! !

!HTTP_CONNECTION_LIMIT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_CONNECTION_LIMIT_INFO structure.

	HTTP_CONNECTION_LIMIT_INFO compileDefinition

		typedef [uuid(6fca5840-1e00-4065-ad55-203bd079a117), helpstring('Used to set or query the limit on the maximum number of outstanding connections for a URL Group.')]
		struct tagHTTP_CONNECTION_LIMIT_INFO {
			[nonbrowsable] HTTP_PROPERTY_FLAGS;
			ULONG MaxConnections;
		} HTTP_CONNECTION_LIMIT_INFO;
"

	super defineFields.
	self
		defineField: #MaxConnections type: DWORDField new offset: 4.
	self byteSize: 8!

maxConnections: anInteger
	^(self new)
		value: anInteger;
		yourself!

qosType
	^HttpQosSettingTypeConnectionLimit! !
!HTTP_CONNECTION_LIMIT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!HTTP_CONNECTION_LIMIT_INFO class categoriesFor: #maxConnections:!public! !
!HTTP_CONNECTION_LIMIT_INFO class categoriesFor: #qosType!constants!public! !

