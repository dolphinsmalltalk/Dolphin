﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HTTP_PROPERTY_FLAGS
	subclass: #'WinHttpServer.HTTP_STATE_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_HTTP_STATE_INFO_Size' -> 16r8. '_OffsetOf_State' -> 16r4 }!

WinHttpServer.HTTP_STATE_INFO guid: (Core.GUID fromString: '{5dc84435-3eb8-42fe-94bf-25f253e612fd}')!

WinHttpServer.HTTP_STATE_INFO comment: '`HTTP_STATE_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_STATE_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"The HTTP_STATE_INFO structure is used to enable or disable a Server Session or URL Group."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(5dc84435-3eb8-42fe-94bf-25f253e612fd), helpstring("The HTTP_STATE_INFO structure is used to enable or disable a Server Session or URL Group.")]
struct tagHTTP_STATE_INFO {
	[nonbrowsable, helpstring("specifying whether the property is present.")] HTTP_PROPERTY_FLAGS;
	[helpstring("A member of the HTTP_ENABLED_STATE enumeration specifying the whether the configuration object is enabled or disabled.	This can be used to disable a URL Group or Server Session.")] HTTP_ENABLED_STATE State;
} HTTP_STATE_INFO;
```
'!

!WinHttpServer.HTTP_STATE_INFO categoriesForClass!Win32-Structs! !

!WinHttpServer.HTTP_STATE_INFO methodsFor!

isActive
	"Answer a three state boolean; true if the queue/Url group/session is active, false if
	inactive, or nil if unspecified."

	^self value ifNotNil: [:state | state asBoolean not]!

isActive: aBooleanOrNil
	self value: (aBooleanOrNil ifNotNil: [aBooleanOrNil not asInteger])!

printFields: aCollection on: aStream
	self Present ifTrue: [aStream nextPutAll: (self isActive ifTrue: ['Active'] ifFalse: ['Inactive'])]!

State
	"Answer the <Integer> value of the receiver's 'State' field."

	^bytes int32AtOffset: _OffsetOf_State!

State: anInteger
	"Set the receiver's 'State' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_State put: anInteger!

value
	^self Present ifTrue: [self State]!

value: anInteger
	anInteger
		ifNil: 
			[self
				Present: false;
				State: 0]
		ifNotNil: 
			[self
				Present: true;
				State: anInteger]! !

!WinHttpServer.HTTP_STATE_INFO categoriesForMethods!
isActive!accessing!public! !
isActive:!accessing!public! !
printFields:on:!printing!private! !
State!**compiled accessors**!public! !
State:!**compiled accessors**!public! !
value!public! !
value:!public! !
!

!WinHttpServer.HTTP_STATE_INFO class methodsFor!

active
	^(self new)
		value: HttpEnabledStateActive;
		yourself!

byteSize
	^_HTTP_STATE_INFO_Size!

defineFields
	"Define the fields of the HTTP_STATE_INFO structure.

	HTTP_STATE_INFO compileDefinition

		typedef [uuid(5dc84435-3eb8-42fe-94bf-25f253e612fd), helpstring('The HTTP_STATE_INFO structure is used to enable or disable a Server Session or URL Group.')]
		struct tagHTTP_STATE_INFO {
			[nonbrowsable, helpstring('specifying whether the property is present.')] HTTP_PROPERTY_FLAGS;
			[helpstring('A member of the HTTP_ENABLED_STATE enumeration specifying whether the configuration object is enabled or disabled. This can be used to disable a URL Group or Server Session.')] HTTP_ENABLED_STATE State;
		} HTTP_STATE_INFO;
"

	super defineFields.
	self
		defineField: #State type: Int32Field new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#Present #State)!

inactive
	^(self new)
		value: HttpEnabledStateInactive;
		yourself!

propertyId
	^HttpServerStateProperty! !

!WinHttpServer.HTTP_STATE_INFO class categoriesForMethods!
active!instance creation!public! !
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
inactive!instance creation!public! !
propertyId!constants!public! !
!

