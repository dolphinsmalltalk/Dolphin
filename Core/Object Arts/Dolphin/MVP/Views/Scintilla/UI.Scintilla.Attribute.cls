"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.Attribute'
	instanceVariableNames: 'id'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'propertyDescriptors'
	classConstants: {}!

UI.Scintilla.Attribute guid: (Core.GUID fromString: '{b73f94fe-0bb9-4c23-aee5-e77b3cf408af}')!

UI.Scintilla.Attribute isNonInstantiable: true!

UI.Scintilla.Attribute comment: '`ScintillaAttribute` is the abstract superclass of objects that wrap various attributes of `ScintillaView`s. It provides a generic mechanism for setting the attribute value into the underlying control.

## Instance Variables:
  `id`		`<integer>`. Identifier of the attribute instance.

## Class Instance Variables:
  `propertyMap`	`IdentityDictionary` mapping from the property name `Symbol` on the subclass to an instance of `ScintillaPropertyDescriptor`



'!

!UI.Scintilla.Attribute categoriesForClass!MVP-Views-Support! !

!UI.Scintilla.Attribute methodsFor!

= aScintillaAttribute 
	^self class == aScintillaAttribute class and: [self name = aScintillaAttribute name]!

applyToView: aScintillaView
	self view: aScintillaView.
	self class propertyDescriptors
		do: [:descriptor | descriptor setAttribute: self ofView: aScintillaView]!

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

initializeView: aScintillaView
	self view: aScintillaView.
	self class propertyDescriptors
		do: [:descriptor | descriptor initializeAttribute: self ofView: aScintillaView]!

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
	self class propertyDescriptors do: [:descriptor | descriptor printPropertyOf: self on: aStream]!

storeableProperties
	^{#basicId} , self class propertyDescriptors collect: [:each | each key]!

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

updateViewProperty: aPropertyDescriptor
	self view ifNotNil: [:scintilla | aPropertyDescriptor setAttribute: self ofView: scintilla]!

view
	^self subclassResponsibility!

view: aScintillaView 
	self subclassResponsibility! !

!UI.Scintilla.Attribute categoriesForMethods!
=!comparing!public! !
applyToView:!helpers!private! !
asParameter!converting!public! !
basicId!accessing!private! !
basicId:!accessing!private! !
hash!comparing!public! !
id!accessing!public! !
id:!accessing!public! !
initializeView:!helpers!private! !
name!accessing!public! !
printOn:!development!printing!public! !
printPropertiesOn:!development!helpers!printing!private! !
storeableProperties!development!printing!private! !
storeOn:!development!printing!public! !
updateViewProperty:!helpers!private! !
view!accessing!private! !
view:!accessing!private! !
!

!UI.Scintilla.Attribute class methodsFor!

icon
	^ScintillaView icon!

propertyDescriptors
	^propertyDescriptors!

sortByIdBlock
	^[:a :b | a basicId ifNil: [true] ifNotNil: [:aId | b basicId ifNil: [false] ifNotNil: [:bId | aId <= bId]]]! !

!UI.Scintilla.Attribute class categoriesForMethods!
icon!constants!development!public! !
propertyDescriptors!constants!private! !
sortByIdBlock!constants!public! !
!

