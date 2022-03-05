"Filed out from Dolphin Smalltalk"!

Object subclass: #ScintillaAttribute
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: 'propertyMap'!
ScintillaAttribute guid: (GUID fromString: '{b73f94fe-0bb9-4c23-aee5-e77b3cf408af}')!
ScintillaAttribute isAbstract: true!
ScintillaAttribute comment: '`ScintillaAttribute` is the abstract superclass of objects that wrap various attributes of `ScintillaView`s. It provides a generic mechanism for setting the attribute value into the underlying control.

## Instance Variables:
  `id`		`<integer>`. Identifier of the attribute instance.

## Class Instance Variables:
  `propertyMap`	`IdentityDictionary` mapping from the property name `Symbol` on the subclass to an instance of `ScintillaPropertyDescriptor`



'!
!ScintillaAttribute categoriesForClass!MVP-Views-Support! !
!ScintillaAttribute methodsFor!

= aScintillaAttribute 
	^self class == aScintillaAttribute and: [self name = aScintillaAttribute name]!

applyToView: aScintillaView initializing: aBoolean
	self view: aScintillaView.
	self class propertyMap do: 
			[:descriptor |
			descriptor
				setAttribute: self
				ofView: aScintillaView
				initializing: aBoolean]!

asParameter
	^self basicId!

basicId
	^id!

basicId: anInteger 
	id := anInteger!

hash
	^self name hash!

id
	^self basicId ifNil: [0] ifNotNil: [:definedId | definedId bitAnd: 16rFF]!

id: anInteger 
	self basicId: anInteger!

name
	^self id!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self id;
		nextPut: $:;
		print: self name.
	self printPropertiesOn: aStream.
	aStream nextPut: $)!

printPropertiesOn: aStream
	self class propertyMap keysAndValuesDo: 
			[:name :descriptor |
			| value |
			value := descriptor getAttributeValue: self.
			(value notNil or: [descriptor alwaysPrint])
				ifTrue: 
					[aStream
						nextPutAll: ', ';
						nextPutAll: name;
						nextPutAll: '=';
						print: value]]!

storeableProperties
	^{#basicId} , self class propertyMap keys asArray!

storeOn: aStream
	"Append to the <puttableStream> argument an expression which when evaluated will answer a
	collection similar to the receiver."

	aStream
		nextPutAll: '((';
		print: self class;
		nextPutAll: ' new)';
		space.
	self storeableProperties do: 
			[:each |
			(self perform: each)
				ifNotNil: 
					[:attrib |
					aStream
						display: each;
						nextPut: $:;
						space.
					attrib storeOn: aStream.
					aStream
						nextPut: $;;
						space]].
	aStream
		display: #yourself;
		nextPut: $)!

updateView: aScintillaView property: aSymbol
	(self class propertyMap at: aSymbol)
		setAttribute: self
		ofView: aScintillaView
		initializing: false!

updateViewProperty: aSymbol
	self view ifNotNil: [:scintilla | self updateView: scintilla property: aSymbol]!

view
	^self subclassResponsibility!

view: aScintillaView 
	self subclassResponsibility! !
!ScintillaAttribute categoriesForMethods!
=!comparing!public! !
applyToView:initializing:!helpers!private! !
asParameter!converting!public! !
basicId!accessing!private! !
basicId:!accessing!private! !
hash!comparing!public! !
id!accessing!public! !
id:!accessing!public! !
name!accessing!public! !
printOn:!development!printing!public! !
printPropertiesOn:!development!helpers!printing!private! !
storeableProperties!development!printing!private! !
storeOn:!development!printing!public! !
updateView:property:!helpers!private! !
updateViewProperty:!helpers!private! !
view!accessing!private! !
view:!accessing!private! !
!

!ScintillaAttribute class methodsFor!

icon
	^ScintillaView icon!

propertyMap
	^propertyMap!

sortByIdBlock
	^[:a :b | a basicId ifNil: [true] ifNotNil: [:aId | b basicId ifNil: [false] ifNotNil: [:bId | aId <= bId]]]! !
!ScintillaAttribute class categoriesForMethods!
icon!constants!development!public! !
propertyMap!constants!private! !
sortByIdBlock!constants!public! !
!

