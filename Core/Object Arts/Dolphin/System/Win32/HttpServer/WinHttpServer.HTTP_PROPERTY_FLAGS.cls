"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_PROPERTY_FLAGS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Present' -> 16r0
	}!
HTTP_PROPERTY_FLAGS guid: (GUID fromString: '{6ba76c16-b60f-4235-9179-145a93b3f5cb}')!
HTTP_PROPERTY_FLAGS isAbstract: true!
HTTP_PROPERTY_FLAGS comment: '<HTTP_PROPERTY_FLAGS> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_PROPERTY_FLAGS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Generic property flags. Each structure defining a property info typically contain an element of this type."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(6ba76c16-b60f-4235-9179-145a93b3f5cb), helpstring("Generic property flags. Each structure defining a property info typically contain an element of this type.")]
struct tagHTTP_PROPERTY_FLAGS {
	[nonbrowsable] BOOL Present;
} HTTP_PROPERTY_FLAGS;
'!
!HTTP_PROPERTY_FLAGS categoriesForClass!WinHttpServer-Structs! !
!HTTP_PROPERTY_FLAGS methodsFor!

Present
	"Private - Answer the <Boolean> value of the receiver's 'Present' field."

	^(bytes dwordAtOffset: _OffsetOf_Present) asBoolean!

Present: aBoolean
	"Set the receiver's 'Present' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: _OffsetOf_Present put: aBoolean asParameter!

printFields: aCollection on: aStream
	| sep template getField |
	sep := [sep := [aStream space]].
	template := self template.
	aStream nextPutAll: 'Present='.
	(bytes dwordAtOffset: 0) printOn: aStream base: 2.
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
!HTTP_PROPERTY_FLAGS categoriesFor: #Present!**compiled accessors**!private! !
!HTTP_PROPERTY_FLAGS categoriesFor: #Present:!**compiled accessors**!private! !
!HTTP_PROPERTY_FLAGS categoriesFor: #printFields:on:!development!printing!private! !
!HTTP_PROPERTY_FLAGS categoriesFor: #propertyId!constants!public! !

!HTTP_PROPERTY_FLAGS class methodsFor!

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
!HTTP_PROPERTY_FLAGS class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_PROPERTY_FLAGS class categoriesFor: #propertyId!constants!public! !

