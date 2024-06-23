"Filed out from Dolphin Smalltalk"!

XMLNodeWithEntities subclass: #XMLDocument
	instanceVariableNames: 'dtd version encoding requiredMarkup'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XMLDocument guid: (GUID fromString: '{8c7ac663-973d-4b54-9aae-e08e393b9616}')!

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

!XMLDocument categoriesForMethods!
dtd!accessing!public! !
dtd:!accessing!public! !
encoding!accessing!public! !
encoding:!accessing!public! !
hasDocumentElement!public!testing! !
isDocument!public!testing! !
printCanonicalOn:!printing!public! !
printXMLOn:!printing!public! !
requiredMarkup!accessing!public! !
requiredMarkup:!accessing!public! !
version!accessing!public! !
version:!accessing!public! !
!

