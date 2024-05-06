"Filed out from Dolphin Smalltalk"!

SAXHandler subclass: #XMLDOMParser
	instanceVariableNames: 'entity stack incremental'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XMLDOMParser guid: (GUID fromString: '{9aa6df2d-d670-4da4-afc3-d47d0003e980}')!

XMLDOMParser comment: ''!

!XMLDOMParser categoriesForClass!XML-Parser! !

!XMLDOMParser methodsFor!

characters: aString
	| newElement |
	newElement := XMLStringNode string: aString.
	self top addContent: newElement.
!

documentAttributes: attributeList
	self document version: (attributeList at: 'version' ifAbsent: [nil]).
	self document encoding: (attributeList at: 'encoding' ifAbsent: [nil]).
	self document requiredMarkup: (attributeList at: 'requiredMarkup' ifAbsent: [nil]).
!

endDocument
	| currentNode |
	#swYAXO.	"added wellformedness check"
	(currentNode := self pop) isDocument 
		ifFalse: [self driver errorExpected: 'document element must be complete'].
	super endDocument!

endElement: elementName
	| currentElement |
	#swYAXO.
	currentElement := self pop.
	"sw: added wellformedness check"
	currentElement isDocument ifTrue: [self driver malformedError: 'Invalid end tag'].
	"sw: added #asString"
	currentElement name asString = elementName 
		ifFalse: 
			[self driver 
				errorExpected: 'End tag "' , elementName , '" doesn''t match "' , currentElement name 
						, '".']!

incremental
	^incremental!

incremental: aBoolean
	incremental := aBoolean!

initialize
	super initialize.
	stack := OrderedCollection new.
	incremental := false!

nextEntity
	| currentTop |
	currentTop := self top.
	[self driver nextEntity isNil
		or: [self top ~~ currentTop]] whileTrue.
	^entity!

nextEntityStart
	[self driver nextEntity.
	self stack isEmpty] whileTrue.
	^entity!

pop
	| oldTop |
	oldTop := self stack removeLast.
	entity := oldTop.
	^oldTop!

processingInstruction: piName data: dataString
	| newElement |
	newElement := XMLPI target: piName data: dataString.
	self top addEntity: newElement!

push: anObject
	self stack add: anObject.
	entity := anObject
!

stack
	^stack!

startDocument
	self document: XMLDocument new.
	self push: self document !

startElement: elementName attributeList: attributeList
	| newElement |
	#swYAXO.
	newElement := XMLElement named: elementName attributes: attributeList.
	self incremental 
		ifFalse: 
			[self stack isEmpty 
				ifFalse: 
					["sw: added check for only one document element"

					| top |
					((top := self top) isDocument and: [top hasDocumentElement]) 
						ifTrue: [self driver errorExpected: 'only one document element'].
					top addEntity: newElement]].
	self push: newElement!

top
	^self stack isEmpty
		ifTrue: [nil]
		ifFalse: [self stack last]! !

!XMLDOMParser categoriesForMethods!
characters:!content!public! !
documentAttributes:!content!public! !
endDocument!content!public! !
endElement:!content!public! !
incremental!accessing!public! !
incremental:!accessing!public! !
initialize!initialize!public! !
nextEntity!parsing!public! !
nextEntityStart!parsing!public! !
pop!accessing!private! !
processingInstruction:data:!content!public! !
push:!accessing!private! !
stack!accessing!private! !
startDocument!content!public! !
startElement:attributeList:!content!public! !
top!accessing!private! !
!

!XMLDOMParser class methodsFor!

addressBookXMLWithDTD
	"XMLDOMParser addressBookXMLWithDTD"
	^self parseDocumentFrom: XMLTokenizer addressBookXMLWithDTD readStream!

parseDocumentFrom: aStream
	#swYAXO.	"Note that unlike the super class method, this method answers a XMLDocument"
	^(super parseDocumentFrom: aStream) document! !

!XMLDOMParser class categoriesForMethods!
addressBookXMLWithDTD!examples!public! !
parseDocumentFrom:!instance creation!public! !
!

