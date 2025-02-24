﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_PROPERTY_FLAGS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_Present' -> 16r0 }!

WinHttpServer.HTTP_PROPERTY_FLAGS guid: (Core.GUID fromString: '{6ba76c16-b60f-4235-9179-145a93b3f5cb}')!

WinHttpServer.HTTP_PROPERTY_FLAGS isNonInstantiable: true!

WinHttpServer.HTTP_PROPERTY_FLAGS comment: '`HTTP_PROPERTY_FLAGS` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_PROPERTY_FLAGS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Generic property flags. Each structure defining a property info typically contain an element of this type."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(6ba76c16-b60f-4235-9179-145a93b3f5cb), helpstring("Generic property flags. Each structure defining a property info typically contain an element of this type.")]
struct tagHTTP_PROPERTY_FLAGS {
	[nonbrowsable] BOOL Present;
} HTTP_PROPERTY_FLAGS;
```
'!

!WinHttpServer.HTTP_PROPERTY_FLAGS categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_PROPERTY_FLAGS methodsFor!

Present
	"Private - Answer the <Boolean> value of the receiver's 'Present' field."

	^(bytes uint32AtOffset: _OffsetOf_Present) asBoolean!

Present: aBoolean
	"Set the receiver's 'Present' field to the value of the argument, aBoolean"

	bytes uint32AtOffset: _OffsetOf_Present put: aBoolean asParameter!

printFields: aCollection on: aStream
	| sep template getField |
	sep := [sep := [aStream space]].
	template := self template.
	aStream nextPutAll: 'Present='.
	(bytes uint32AtOffset: _OffsetOf_Present) printOn: aStream base: 2.
	aStream nextPutAll: ': '.
	getField := self Present ifTrue: [[:field | self getField: field]] ifFalse: [[:field | ]].
	aCollection do: 
			[:each |
			| field |
			field := template at: each.
			field isBrowsable
				ifTrue: 
					[sep value.
					aStream
						display: each;
						nextPutAll: '=';
						print: (getField value: each)]]!

propertyId
	^self class propertyId! !

!WinHttpServer.HTTP_PROPERTY_FLAGS categoriesForMethods!
Present!**compiled accessors**!private! !
Present:!**compiled accessors**!private! !
printFields:on:!development!printing!private! !
propertyId!constants!public! !
!

!WinHttpServer.HTTP_PROPERTY_FLAGS class methodsFor!

defineFields
	"Define the fields of the HTTP_PROPERTY_FLAGS structure.

	HTTP_PROPERTY_FLAGS compileDefinition

		typedef [uuid(6ba76c16-b60f-4235-9179-145a93b3f5cb), helpstring('Generic property flags. Each structure defining a property info typically contain an element of this type.')]
		struct tagHTTP_PROPERTY_FLAGS {
			[nonbrowsable] BOOL Present;
		} HTTP_PROPERTY_FLAGS;
"

	self
		defineField: #Present type: BOOLField new beNonBrowsable offset: 0.
	self byteSize: 4!

propertyId
	^self subclassResponsibility! !

!WinHttpServer.HTTP_PROPERTY_FLAGS class categoriesForMethods!
defineFields!**auto generated**!private!template definition! !
propertyId!constants!public! !
!

