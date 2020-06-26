"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_CACHE_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_KeyDesc' -> 16r0.
		'_OffsetOf_ParamDesc' -> 16r4
	}!
HTTP_SERVICE_CONFIG_CACHE_SET guid: (GUID fromString: '{7d7f269d-ce99-4ee1-979d-387f6f2147be}')!
HTTP_SERVICE_CONFIG_CACHE_SET comment: '<HTTP_SERVICE_CONFIG_CACHE_SET> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_CACHE_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"To set a cache parameter value use the set structure. To query use the key directly.When you query a parameter value the output buffer must be exactly the sizeof param."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(7d7f269d-ce99-4ee1-979d-387f6f2147be), helpstring("To set a cache parameter value use the set structure. To query use the key directly.When you query a parameter value the output buffer must be exactly the sizeof param.")]
struct tagHTTP_SERVICE_CONFIG_CACHE_SET {
	HTTP_SERVICE_CONFIG_CACHE_KEY KeyDesc;
	ULONG ParamDesc;
} HTTP_SERVICE_CONFIG_CACHE_SET;
'!
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVICE_CONFIG_CACHE_SET methodsFor!

KeyDesc
	"Answer the <Integer> value of the receiver's 'KeyDesc' field."

	^bytes sdwordAtOffset: _OffsetOf_KeyDesc!

KeyDesc: anInteger
	"Set the receiver's 'KeyDesc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_KeyDesc put: anInteger!

ParamDesc
	"Answer the <Integer> value of the receiver's 'ParamDesc' field."

	^bytes dwordAtOffset: _OffsetOf_ParamDesc!

ParamDesc: anInteger
	"Set the receiver's 'ParamDesc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ParamDesc put: anInteger! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #ParamDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #ParamDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_CACHE_SET class methodsFor!

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
		defineField: #KeyDesc type: SDWORDField new offset: 0;
		defineField: #ParamDesc type: DWORDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !
!HTTP_SERVICE_CONFIG_CACHE_SET class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_SERVICE_CONFIG_CACHE_SET class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

