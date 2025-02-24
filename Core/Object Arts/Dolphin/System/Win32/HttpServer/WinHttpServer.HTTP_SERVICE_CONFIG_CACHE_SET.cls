﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVICE_CONFIG_CACHE_SET_Size' -> 16r8.
			'_OffsetOf_KeyDesc' -> 16r0.
			'_OffsetOf_ParamDesc' -> 16r4
		}!

WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET guid: (Core.GUID fromString: '{7d7f269d-ce99-4ee1-979d-387f6f2147be}')!

WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET comment: '`HTTP_SERVICE_CONFIG_CACHE_SET` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"To set a cache parameter value use the set structure. To query use the key directly. When you query a parameter value the output buffer must be exactly the sizeof param."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(7d7f269d-ce99-4ee1-979d-387f6f2147be), helpstring("To set a cache parameter value use the set structure. To query use the key directly. When you query a parameter value the output buffer must be exactly the sizeof param.")]
struct tagHTTP_SERVICE_CONFIG_CACHE_SET {
	HTTP_SERVICE_CONFIG_CACHE_KEY KeyDesc;
	ULONG ParamDesc;
} HTTP_SERVICE_CONFIG_CACHE_SET;
```
'!

!WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET methodsFor!

KeyDesc
	"Answer the <Integer> value of the receiver's 'KeyDesc' field."

	^bytes int32AtOffset: _OffsetOf_KeyDesc!

KeyDesc: anInteger
	"Set the receiver's 'KeyDesc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_KeyDesc put: anInteger!

ParamDesc
	"Answer the <Integer> value of the receiver's 'ParamDesc' field."

	^bytes uint32AtOffset: _OffsetOf_ParamDesc!

ParamDesc: anInteger
	"Set the receiver's 'ParamDesc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ParamDesc put: anInteger! !

!WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET categoriesForMethods!
KeyDesc!**compiled accessors**!public! !
KeyDesc:!**compiled accessors**!public! !
ParamDesc!**compiled accessors**!public! !
ParamDesc:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET class methodsFor!

byteSize
	^_HTTP_SERVICE_CONFIG_CACHE_SET_Size!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_CACHE_SET structure.

	HTTP_SERVICE_CONFIG_CACHE_SET compileDefinition

		typedef [uuid(7d7f269d-ce99-4ee1-979d-387f6f2147be), helpstring('To set a cache parameter value use the set structure. To query use the key directly.When you query a parameter value the output buffer must be exactly the sizeof param.')]
		struct tagHTTP_SERVICE_CONFIG_CACHE_SET {
			HTTP_SERVICE_CONFIG_CACHE_KEY KeyDesc;
			ULONG ParamDesc;
		} HTTP_SERVICE_CONFIG_CACHE_SET;
"

	self
		defineField: #KeyDesc type: Int32Field new offset: 0;
		defineField: #ParamDesc type: UInt32Field new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !

!WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

