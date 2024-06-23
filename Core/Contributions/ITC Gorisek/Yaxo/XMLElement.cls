"Filed out from Dolphin Smalltalk"!

XMLNodeWithEntities subclass: #XMLElement
	instanceVariableNames: 'name contents attributes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XMLElement guid: (GUID fromString: '{41122550-bc8f-4a1a-8913-ab228b16dc0f}')!

XMLElement comment: ''!

!XMLElement categoriesForClass!XML-Parser! !

!XMLElement methodsFor!

addContent: contentString
	self contents add: contentString!

attributeAt: attributeName
	^self attributeAt: attributeName ifAbsent: [nil]!

attributeAt: attributeName ifAbsent: aBlock
	^self attributes at: attributeName ifAbsent: [^aBlock value]!

attributeAt: attributeName put: attributeValue
	self attributes at: attributeName asSymbol put: attributeValue!

attributes
	^attributes!

characterData
	^self contentString!

contents
	contents ifNil: [contents := OrderedCollection new].
	^contents!

contentsDo: aBlock
	#swYAXO.
	contents ifNotNil: 
			[:t | 
			"sw squeak expects monadic"

			self contents do: [:each | aBlock value: each]]!

contentString
	^(self contents size == 1
		and: [self contents first isKindOf: XMLStringNode])
		ifTrue: [self contents first string]
		ifFalse: ['']!

contentStringAt: entityName
	^(self entityAt: entityName ifAbsent: [^'']) string!

elements
	^super elements , self contents!

firstTagNamed: aSymbol 
	"Return the first encountered node with the specified tag.
	If it is not the receiver, pass the message on"

	self tag == aSymbol ifTrue: [^self].
	^super firstTagNamed: aSymbol !

firstTagNamed: aSymbol with: aBlock
	"Return the first encountered node with the specified tag that allows
	the block to evaluate to true. Pass the message on"

	(self tag == aSymbol and: [aBlock value: self]) ifTrue: [^self].
	^super firstTagNamed: aSymbol with: aBlock.!

isEmpty
	^self entities isEmpty
		and: [self contents isEmpty]!

isTag
	^true!

name
	^name!

name: aString
	name := aString asSymbol!

printXMLOn: writer
	writer startElement: self name attributeList: self attributes.
	(writer canonical not
		and: [self isEmpty and: [self attributes isEmpty not]])
		ifTrue: [writer endEmptyTag: self name]
		ifFalse: [
			writer endTag.
			self contentsDo: [:content | content printXMLOn: writer].
			super printXMLOn: writer.
			writer endTag: self name]!

setAttributes: newAttributes
	attributes := newAttributes!

tag
	^name asSymbol!

tagsNamed: aSymbol contentsDo: aBlock
	"Evaluate aBlock for all of the contents of the receiver
	if the receiver tag equals aSymbol. Pass the message on"

	self tag == aSymbol ifTrue: [self contentsDo: aBlock].
	super tagsNamed: aSymbol contentsDo: aBlock!

tagsNamed: aSymbol do: aOneArgumentBlock
	"If the receiver tag equals aSymbol, evaluate aOneArgumentBlock
	with the receiver. Continue the search"

	self tag == aSymbol ifTrue: [aOneArgumentBlock value: self].
	super tagsNamed: aSymbol do: aOneArgumentBlock!

tagsNamed: aSymbol ifReceiverDo: aOneArgumentBlock
	"If the receiver tag equals aSymbol, evaluate aOneArgumentBlock with the receiver"

	self tag == aSymbol ifTrue: [aOneArgumentBlock value: self]
!

tagsNamed: aSymbol ifReceiverDoAndRecurse: aOneArgumentBlock
	"If the receiver tag equals aSymbol, evaluate aOneArgumentBlock
	with the receiver. Then recurse through all the children"

	self tag == aSymbol ifTrue: [aOneArgumentBlock value: self].
	super tagsNamed: aSymbol ifReceiverDoAndRecurse: aOneArgumentBlock!

tagsNamed: aSymbol ifReceiverOrChildDo: aOneArgumentBlock
	"If the receiver tag equals aSymbol, evaluate aOneArgumentBlock with the receiver.
	For each of the receiver's children do the same. Do not go beyond direct children"

	self tag == aSymbol ifTrue: [aOneArgumentBlock value: self].
	super tagsNamed: aSymbol ifReceiverDo: aOneArgumentBlock!

valueFor: aSymbol 
	^self attributes at: aSymbol ifAbsent: ['']!

valueFor: aSymbol ifAbsent: aBlock 
	^self attributes at: aSymbol ifAbsent: aBlock! !

!XMLElement categoriesForMethods!
addContent:!initialize!public! !
attributeAt:!accessing!public! !
attributeAt:ifAbsent:!accessing!public! !
attributeAt:put:!accessing!public! !
attributes!accessing!public! !
characterData!accessing!public! !
contents!accessing!public! !
contentsDo:!enumerating!public! !
contentString!accessing!public! !
contentStringAt:!accessing!public! !
elements!accessing!public! !
firstTagNamed:!public!searching! !
firstTagNamed:with:!public!searching! !
isEmpty!public!testing! !
isTag!public!testing! !
name!accessing!public! !
name:!initialize!public! !
printXMLOn:!printing!public! !
setAttributes:!initialize!public! !
tag!accessing!public! !
tagsNamed:contentsDo:!public!searching! !
tagsNamed:do:!public!searching! !
tagsNamed:ifReceiverDo:!public!searching! !
tagsNamed:ifReceiverDoAndRecurse:!public!searching! !
tagsNamed:ifReceiverOrChildDo:!public!searching! !
valueFor:!accessing!public! !
valueFor:ifAbsent:!accessing!public! !
!

!XMLElement class methodsFor!

named: aString
	^self new name: aString!

named: aString attributes: attributeList
	^self new
		name: aString;
		setAttributes: attributeList! !

!XMLElement class categoriesForMethods!
named:!instance creation!public! !
named:attributes:!instance creation!public! !
!

