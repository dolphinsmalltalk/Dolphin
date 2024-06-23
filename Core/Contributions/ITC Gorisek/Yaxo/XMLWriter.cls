"Filed out from Dolphin Smalltalk"!

Object subclass: #XMLWriter
	instanceVariableNames: 'stream stack scanner canonical'
	classVariableNames: 'XMLTranslation'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XMLWriter guid: (GUID fromString: '{d99a57a4-3582-4065-9544-4b3cfa0ba480}')!

XMLWriter comment: ''!

!XMLWriter categoriesForClass!XML-Parser! !

!XMLWriter methodsFor!

attribute: attributeName value: attributeValue
	self stream
		space;
		nextPutAll: attributeName.
	self
		eq;
		putAsXMLString: attributeValue.
	self stream flush!

canonical
	^canonical!

canonical: aBoolean
	canonical := aBoolean!

cdata: aString
	self startCData.
	self stream nextPutAll: aString.
	self endCData!

comment: aString
	self startComment.
	self stream nextPutAll: aString.
	self endComment!

endCData
	self stream nextPutAll: ']]>'!

endComment
	self stream nextPutAll: ' -->'!

endDecl: type
	self endTag!

endDeclaration
	self stream
		cr;
		nextPut: $].
	self endTag!

endEmptyTag: tagName
	self popTag: tagName.
	self stream nextPutAll: '/>'.
	self canonical
		ifFalse: [self stream space]!

endPI
	self stream nextPutAll: '?>'!

endTag
	self stream nextPut: $>.
	"self canonical
		ifFalse: [self stream space]"!

endTag: tagName
	self popTag: tagName.
	self stream
		nextPutAll: '</';
		nextPutAll: tagName.
	self endTag.
!

eq
	self stream nextPut: $=!

initialize
	stack := OrderedCollection new.
	canonical := false!

pcData: aString
	aString do: [:c |
		self stream nextPutAll: (XMLTranslation at: c ifAbsent: [String with: c])].!

pi: piTarget data: piData
	self startPI: piTarget.
	self stream nextPutAll: piData.
	self endPI!

popTag: tagName
	| stackTop |
	stackTop := self stack isEmpty
		ifTrue: ['<empty>']
		ifFalse: [self stack last].
	^stackTop = tagName
		ifTrue: [self stack removeLast]
		ifFalse: [self error: 'Closing tag "' , tagName , '" does not match "' , stackTop]!

pushTag: tagName
	self stack add: tagName!

putAsXMLString: aValue
	self stream nextPut: $".
	self pcData: aValue.
	self stream nextPut: $"!

stack
	^stack!

startCData
	self stream nextPutAll: '<!![CDATA['!

startComment
	self stream nextPutAll: '<-- '!

startDecl: type
	self stream
		nextPutAll: '<!!';
		nextPutAll: type asUppercase;
		space!

startDecl: type named: aString
	self stream
		nextPutAll: '<!!';
		nextPutAll: type asUppercase;
		space;
		nextPutAll: aString;
		space!

startDeclaration: dtdName
	self startDecl: 'DOCTYPE' named: dtdName.
	self stream
		nextPut: $[;
		cr!

startElement: elementName attributeList: attributeList
	self canonical
		ifFalse: [self stream cr].
	self startTag: elementName.
	attributeList keys asSortedCollection do: [:key |
		self attribute: key value: (attributeList at: key)]!

startPI: identifier
	self stream
		nextPutAll: '<?';
		nextPutAll: identifier;
		space!

startTag: tagName
	self stream
		nextPut: $<;
		nextPutAll: tagName.
	"self canonical
		ifFalse: [self stream space]."
	self pushTag: tagName!

stream
	^stream!

stream: aStream
	stream := aStream!

xmlDeclaration: versionString
	self canonical
		ifFalse: [
			self
				startPI: 'XML';
				attribute: 'version' value: versionString;
				endPI]! !

!XMLWriter categoriesForMethods!
attribute:value:!public!writing xml! !
canonical!accessing!public! !
canonical:!accessing!public! !
cdata:!public!writing xml! !
comment:!public!writing xml! !
endCData!private!tags! !
endComment!private!tags! !
endDecl:!public!writing dtd! !
endDeclaration!public!writing dtd! !
endEmptyTag:!public!writing xml! !
endPI!private!tags! !
endTag!public!writing xml! !
endTag:!public!writing xml! !
eq!private!writing xml! !
initialize!initialize!public! !
pcData:!public!writing xml! !
pi:data:!public!writing xml! !
popTag:!private!tags! !
pushTag:!private!tags! !
putAsXMLString:!private!writing xml! !
stack!accessing!private! !
startCData!private!tags! !
startComment!private!tags! !
startDecl:!public!writing dtd! !
startDecl:named:!public!writing dtd! !
startDeclaration:!public!writing dtd! !
startElement:attributeList:!public!writing xml! !
startPI:!private!tags! !
startTag:!public!writing xml! !
stream!accessing!public! !
stream:!accessing!public! !
xmlDeclaration:!public!writing xml! !
!

!XMLWriter class methodsFor!

initialize
	"
	XMLWriter initialize
	"

	XMLTranslation := Dictionary new.
	XMLTranslation
		at: Character cr put: '&#13;';
		at: Character lf put: '&#10;';
		at: Character tab put: '&#9;';
		at: $& put: '&amp;';
		at: $< put: '&lt;';
		at: $> put: '&gt;';
		at: $" put: '&quot;'
	"		at: $' put: '&apos;'; "!

on: aStream
	^self basicNew initialize stream: aStream! !

!XMLWriter class categoriesForMethods!
initialize!class initialization!public! !
on:!instance creation!public! !
!

