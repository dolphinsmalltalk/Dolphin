"Filed out from Dolphin Smalltalk 7"!

XMLNodeWithEntities subclass: #XMLDocument
	instanceVariableNames: 'dtd version encoding requiredMarkup'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

