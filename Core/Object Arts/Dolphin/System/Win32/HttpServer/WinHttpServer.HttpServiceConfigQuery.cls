"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HttpServiceConfigQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_QueryDesc' -> 16r0
	}!
HttpServiceConfigQuery guid: (GUID fromString: '{38f6548e-ee39-4262-9f31-96ce0e8c6cb7}')!
HttpServiceConfigQuery comment: '<HttpServiceConfigQuery> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HttpServiceConfigQuery'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(38f6548e-ee39-4262-9f31-96ce0e8c6cb7)]
struct tagHttpServiceConfigQuery {
	HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
} HttpServiceConfigQuery;
'!
!HttpServiceConfigQuery categoriesForClass!WinHttpServer-Structs! !
!HttpServiceConfigQuery methodsFor!

QueryDesc
	"Answer the <Integer> value of the receiver's 'QueryDesc' field."

	^bytes sdwordAtOffset: _OffsetOf_QueryDesc!

QueryDesc: anInteger
	"Set the receiver's 'QueryDesc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_QueryDesc put: anInteger! !
!HttpServiceConfigQuery categoriesFor: #QueryDesc!**compiled accessors**!public! !
!HttpServiceConfigQuery categoriesFor: #QueryDesc:!**compiled accessors**!public! !

!HttpServiceConfigQuery class methodsFor!

defineFields
	"Define the fields of the HttpServiceConfigQuery structure.

	HttpServiceConfigQuery compileDefinition

		typedef [uuid(38f6548e-ee39-4262-9f31-96ce0e8c6cb7)]
		struct tagHttpServiceConfigQuery {
			HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
		} HttpServiceConfigQuery;
"

	self
		defineField: #QueryDesc type: SDWORDField new offset: 0.
	self byteSize: 4!

getFieldNames
	^#(#QueryDesc)! !
!HttpServiceConfigQuery class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HttpServiceConfigQuery class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

