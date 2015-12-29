"Filed out from Dolphin Smalltalk X6.2"!

XMLNodeWithEntities subclass: #XMLDocument
	instanceVariableNames: 'dtd version encoding requiredMarkup'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XMLDocument guid: (GUID fromString: '{8C7AC663-973D-4B54-9AAE-E08E393B9616}')!
XMLDocument comment: ''!
!XMLDocument categoriesForClass!XML-Parser! !
!XMLDocument methodsFor!

dtd
	^dtd!

dtd: aDTD
	dtd := aDTD!

encoding	
	^encoding!

encoding: aString	
	encoding := aString!

hasDocumentElement
	#swYAXO.
	self entitiesDo: [ :k :v | v isTag ifTrue: [^true]].
	^false
	
!

isDocument
	#swYAXO.
	^true!

printCanonicalOn: aStream

	| writer |
	writer := XMLWriter on: aStream.
	writer canonical: true.
	self printXMLOn: writer!

printXMLOn: writer
	#swYAXO.
	version ifNotNil: 
			[:t | 
			"sw squeak expects monadic"

			writer xmlDeclaration: self version].
	super printXMLOn: writer!

requiredMarkup	
	^requiredMarkup!

requiredMarkup: aString	
	requiredMarkup := aString!

version	
	^version!

version: aString	
	version := aString! !
!XMLDocument categoriesFor: #dtd!accessing!public! !
!XMLDocument categoriesFor: #dtd:!accessing!public! !
!XMLDocument categoriesFor: #encoding!accessing!public! !
!XMLDocument categoriesFor: #encoding:!accessing!public! !
!XMLDocument categoriesFor: #hasDocumentElement!public!testing! !
!XMLDocument categoriesFor: #isDocument!public!testing! !
!XMLDocument categoriesFor: #printCanonicalOn:!printing!public! !
!XMLDocument categoriesFor: #printXMLOn:!printing!public! !
!XMLDocument categoriesFor: #requiredMarkup!accessing!public! !
!XMLDocument categoriesFor: #requiredMarkup:!accessing!public! !
!XMLDocument categoriesFor: #version!accessing!public! !
!XMLDocument categoriesFor: #version:!accessing!public! !

