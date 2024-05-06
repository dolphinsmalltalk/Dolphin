"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_CACHE_POLICY
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_Policy _OffsetOf_SecondsToLive NoCache UserInvalidates'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

HTTP_CACHE_POLICY guid: (GUID fromString: '{02064551-c601-4e48-85ac-6d19fe34f58b}')!

HTTP_CACHE_POLICY addClassConstant: '_OffsetOf_Policy' value: 16r0!
HTTP_CACHE_POLICY addClassConstant: '_OffsetOf_SecondsToLive' value: 16r4!

HTTP_CACHE_POLICY comment: '<HTTP_CACHE_POLICY> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_CACHE_POLICY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	" Only cache unauthorized GETs + HEADs."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(02064551-c601-4e48-85ac-6d19fe34f58b), helpstring(" Only cache unauthorized GETs + HEADs.")]
struct tagHTTP_CACHE_POLICY {
	HTTP_CACHE_POLICY_TYPE Policy;
	ULONG SecondsToLive;
} HTTP_CACHE_POLICY;
'!

!HTTP_CACHE_POLICY categoriesForClass!WinHttpServer-Structs! !

!HTTP_CACHE_POLICY methodsFor!

policy
	^#(#noCache #userInvalidates #timeToLive:) at: self Policy + 1!

Policy
	"Answer the <Integer> value of the receiver's 'Policy' field."

	^bytes sdwordAtOffset: _OffsetOf_Policy!

Policy: anInteger
	"Set the receiver's 'Policy' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_Policy put: anInteger!

printFields: aCollection on: aStream limit: anInteger
	| policy |
	policy := self policy.
	aStream nextPutAll: policy.
	policy == #timeToLive:
		ifTrue: 
			[aStream
				space;
				print: self SecondsToLive]!

SecondsToLive
	"Answer the <Integer> value of the receiver's 'SecondsToLive' field."

	^bytes dwordAtOffset: _OffsetOf_SecondsToLive!

SecondsToLive: anInteger
	"Set the receiver's 'SecondsToLive' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_SecondsToLive put: anInteger! !

!HTTP_CACHE_POLICY categoriesForMethods!
policy!accessing!public! !
Policy!**compiled accessors**!public! !
Policy:!**compiled accessors**!public! !
printFields:on:limit:!development!printing!private! !
SecondsToLive!**compiled accessors**!public! !
SecondsToLive:!**compiled accessors**!public! !
!

!HTTP_CACHE_POLICY class methodsFor!

defineFields
	"Define the fields of the HTTP_CACHE_POLICY structure.

	HTTP_CACHE_POLICY compileDefinition

		typedef [uuid(02064551-c601-4e48-85ac-6d19fe34f58b), helpstring(' Only cache unauthorized GETs + HEADs.')]
		struct tagHTTP_CACHE_POLICY {
			HTTP_CACHE_POLICY_TYPE Policy;
			ULONG SecondsToLive;
		} HTTP_CACHE_POLICY;
"

	self
		defineField: #Policy type: SDWORDField new offset: 0;
		defineField: #SecondsToLive type: DWORDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#Policy #SecondsToLive)!

initialize
	self
		addClassConstant: 'NoCache'
			value: ((self new)
					Policy: HttpCachePolicyNocache;
					yourself);
		addClassConstant: 'UserInvalidates'
			value: ((self new)
					Policy: HttpCachePolicyUserInvalidates;
					yourself)!

noCache
	^NoCache!

timeToLive: anInteger
	^(self new)
		Policy: HttpCachePolicyTimeToLive;
		SecondsToLive: anInteger;
		yourself!

userInvalidates
	^UserInvalidates! !

!HTTP_CACHE_POLICY class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!public! !
noCache!instance creation!public! !
timeToLive:!instance creation!public! !
userInvalidates!instance creation!public! !
!

