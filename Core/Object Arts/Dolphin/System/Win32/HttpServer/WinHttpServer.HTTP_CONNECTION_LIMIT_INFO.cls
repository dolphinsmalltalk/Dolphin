﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpQosSetting
	subclass: #'WinHttpServer.HTTP_CONNECTION_LIMIT_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_HTTP_CONNECTION_LIMIT_INFO_Size' -> 16r8. '_OffsetOf_MaxConnections' -> 16r4 }!

WinHttpServer.HTTP_CONNECTION_LIMIT_INFO guid: (Core.GUID fromString: '{6fca5840-1e00-4065-ad55-203bd079a117}')!

WinHttpServer.HTTP_CONNECTION_LIMIT_INFO comment: '`HTTP_CONNECTION_LIMIT_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_CONNECTION_LIMIT_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used to set or query the limit on the maximum number of outstanding connections for a URL Group."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(6fca5840-1e00-4065-ad55-203bd079a117), helpstring("Used to set or query the limit on the maximum number of outstanding connections for a URL Group.")]
struct tagHTTP_CONNECTION_LIMIT_INFO {
	[nonbrowsable] HTTP_PROPERTY_FLAGS;
	ULONG MaxConnections;
} HTTP_CONNECTION_LIMIT_INFO;
```
'!

!WinHttpServer.HTTP_CONNECTION_LIMIT_INFO categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_CONNECTION_LIMIT_INFO methodsFor!

MaxConnections
	"Answer the <Integer> value of the receiver's 'MaxConnections' field."

	^bytes uint32AtOffset: _OffsetOf_MaxConnections!

MaxConnections: anInteger
	"Set the receiver's 'MaxConnections' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_MaxConnections put: anInteger!

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

!WinHttpServer.HTTP_CONNECTION_LIMIT_INFO categoriesForMethods!
MaxConnections!**compiled accessors**!public! !
MaxConnections:!**compiled accessors**!public! !
value!accessing!public! !
value:!accessing!public! !
!

!WinHttpServer.HTTP_CONNECTION_LIMIT_INFO class methodsFor!

byteSize
	^_HTTP_CONNECTION_LIMIT_INFO_Size!

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
		defineField: #MaxConnections type: UInt32Field new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#Present #MaxConnections)!

maxConnections: anInteger
	^(self new)
		value: anInteger;
		yourself!

qosType
	^HttpQosSettingTypeConnectionLimit! !

!WinHttpServer.HTTP_CONNECTION_LIMIT_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
maxConnections:!public! !
qosType!constants!public! !
!

