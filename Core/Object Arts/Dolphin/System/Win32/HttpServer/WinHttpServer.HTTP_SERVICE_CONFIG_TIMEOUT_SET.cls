"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVICE_CONFIG_TIMEOUT_SET_Size' -> 16r8.
			'_OffsetOf_KeyDesc' -> 16r0.
			'_OffsetOf_ParamDesc' -> 16r4
		}!
WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET guid: (Core.GUID fromString: '{6f4abcfc-2a59-4996-a958-5de93dc64213}')!
WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET comment: '`HTTP_SERVICE_CONFIG_TIMEOUT_SET` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(6f4abcfc-2a59-4996-a958-5de93dc64213), helpstring("To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param.")]
struct tagHTTP_SERVICE_CONFIG_TIMEOUT_SET {
	HTTP_SERVICE_CONFIG_TIMEOUT_KEY KeyDesc;
	USHORT ParamDesc;
} HTTP_SERVICE_CONFIG_TIMEOUT_SET;
```
'!
!WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET methodsFor!

KeyDesc
	"Answer the <Integer> value of the receiver's 'KeyDesc' field."

	^bytes int32AtOffset: _OffsetOf_KeyDesc!

KeyDesc: anInteger
	"Set the receiver's 'KeyDesc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_KeyDesc put: anInteger!

ParamDesc
	"Answer the <Integer> value of the receiver's 'ParamDesc' field."

	^bytes uint16AtOffset: _OffsetOf_ParamDesc!

ParamDesc: anInteger
	"Set the receiver's 'ParamDesc' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_ParamDesc put: anInteger! !
!WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesForMethods!
KeyDesc!**compiled accessors**!public! !
KeyDesc:!**compiled accessors**!public! !
ParamDesc!**compiled accessors**!public! !
ParamDesc:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET class methodsFor!

byteSize
	^_HTTP_SERVICE_CONFIG_TIMEOUT_SET_Size!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_TIMEOUT_SET structure.

	HTTP_SERVICE_CONFIG_TIMEOUT_SET compileDefinition

		typedef [uuid(6f4abcfc-2a59-4996-a958-5de93dc64213), helpstring('To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param.')]
		struct tagHTTP_SERVICE_CONFIG_TIMEOUT_SET {
			HTTP_SERVICE_CONFIG_TIMEOUT_KEY KeyDesc;
			USHORT ParamDesc;
		} HTTP_SERVICE_CONFIG_TIMEOUT_SET;
"

	self
		defineField: #KeyDesc type: Int32Field new offset: 0;
		defineField: #ParamDesc type: UInt16Field new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !
!WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

