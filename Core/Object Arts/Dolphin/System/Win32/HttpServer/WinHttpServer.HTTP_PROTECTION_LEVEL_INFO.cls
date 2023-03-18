"Filed out from Dolphin Smalltalk"!

WinHttpServer.HTTP_PROPERTY_FLAGS subclass: #'WinHttpServer.HTTP_PROTECTION_LEVEL_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_HTTP_PROTECTION_LEVEL_INFO_Size' -> 16r8.
		'_OffsetOf_Level' -> 16r4
	}!
WinHttpServer.HTTP_PROTECTION_LEVEL_INFO guid: (Core.GUID fromString: '{e1881388-d03e-4ea0-8e39-8f1439753299}')!
WinHttpServer.HTTP_PROTECTION_LEVEL_INFO comment: '`HTTP_PROTECTION_LEVEL_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_PROTECTION_LEVEL_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Controls whether the associated UrlGroup Namespace should receive edge traversed traffic. By default this parameter is unspecified."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(e1881388-d03e-4ea0-8e39-8f1439753299), helpstring("Controls whether the associated UrlGroup Namespace should receive edge traversed traffic. By default this parameter is unspecified.")]
struct tagHTTP_PROTECTION_LEVEL_INFO {
	HTTP_PROPERTY_FLAGS;
	HTTP_PROTECTION_LEVEL_TYPE Level;
} HTTP_PROTECTION_LEVEL_INFO;
```
'!
!WinHttpServer.HTTP_PROTECTION_LEVEL_INFO categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_PROTECTION_LEVEL_INFO methodsFor!

Level
	"Answer the <Integer> value of the receiver's 'Level' field."

	^bytes int32AtOffset: _OffsetOf_Level!

Level: anInteger
	"Set the receiver's 'Level' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Level put: anInteger! !
!WinHttpServer.HTTP_PROTECTION_LEVEL_INFO categoriesForMethods!
Level!**compiled accessors**!public! !
Level:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_PROTECTION_LEVEL_INFO class methodsFor!

byteSize
	^_HTTP_PROTECTION_LEVEL_INFO_Size!

defineFields
	"Define the fields of the HTTP_PROTECTION_LEVEL_INFO structure.

	HTTP_PROTECTION_LEVEL_INFO compileDefinition

		typedef [uuid(e1881388-d03e-4ea0-8e39-8f1439753299), helpstring('Controls whether the associated UrlGroup Namespace should receive edge traversed traffic. By default this parameter is unspecified.')]
		struct tagHTTP_PROTECTION_LEVEL_INFO {
			HTTP_PROPERTY_FLAGS;
			HTTP_PROTECTION_LEVEL_TYPE Level;
		} HTTP_PROTECTION_LEVEL_INFO;
"

	super defineFields.
	self
		defineField: #Level type: Int32Field new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#Present #Level)!

propertyId
	^HttpServerProtectionLevelProperty! !
!WinHttpServer.HTTP_PROTECTION_LEVEL_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
propertyId!public! !
!

