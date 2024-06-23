"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HttpServiceConfigQuery'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_HttpServiceConfigQuery_Size' -> 16r4. '_OffsetOf_QueryDesc' -> 16r0 }!

WinHttpServer.HttpServiceConfigQuery guid: (Core.GUID fromString: '{38f6548e-ee39-4262-9f31-96ce0e8c6cb7}')!

WinHttpServer.HttpServiceConfigQuery comment: '`HttpServiceConfigQuery` is an `External.Structure` class to wrap the struct ''WinHttpServer.HttpServiceConfigQuery'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(38f6548e-ee39-4262-9f31-96ce0e8c6cb7)]
struct tagHttpServiceConfigQuery {
	HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
} HttpServiceConfigQuery;
```
'!

!WinHttpServer.HttpServiceConfigQuery categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HttpServiceConfigQuery methodsFor!

QueryDesc
	"Answer the <Integer> value of the receiver's 'QueryDesc' field."

	^bytes int32AtOffset: _OffsetOf_QueryDesc!

QueryDesc: anInteger
	"Set the receiver's 'QueryDesc' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_QueryDesc put: anInteger! !

!WinHttpServer.HttpServiceConfigQuery categoriesForMethods!
QueryDesc!**compiled accessors**!public! !
QueryDesc:!**compiled accessors**!public! !
!

!WinHttpServer.HttpServiceConfigQuery class methodsFor!

byteSize
	^_HttpServiceConfigQuery_Size!

defineFields
	"Define the fields of the HttpServiceConfigQuery structure.

	HttpServiceConfigQuery compileDefinition

		typedef [uuid(38f6548e-ee39-4262-9f31-96ce0e8c6cb7)]
		struct tagHttpServiceConfigQuery {
			HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
		} HttpServiceConfigQuery;
"

	self
		defineField: #QueryDesc type: Int32Field new offset: 0.
	self byteSize: 4!

getFieldNames
	^#(#QueryDesc)! !

!WinHttpServer.HttpServiceConfigQuery class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

