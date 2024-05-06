"Filed out from Dolphin Smalltalk"!

XMLNode subclass: #XMLNodeWithEntities
	instanceVariableNames: 'entities'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XMLNodeWithEntities guid: (GUID fromString: '{3a3489a9-1660-4041-ad01-203dc0006b3c}')!

XMLNodeWithEntities comment: ''!

!XMLNodeWithEntities categoriesForClass!XML-Parser! !

!XMLNodeWithEntities methodsFor!

addEntity: entity
	self addEntity: entity name value: entity!

addEntity: entityName value: entityValue
	self entities add: entityName->entityValue!

elements
	^self entities collect: [:each | each value]!

entities
	entities ifNil: [entities := OrderedCollection new].
	^entities!

entitiesDo: aBlock
	#swYAXO.
	entities ifNotNil: 
			[:t | 
			"sw squeak expects monadic"

			self entities do: [:each | aBlock value: each key value: each value]]!

entityAt: entityName
	^self entityAt: entityName ifAbsent: [nil]!

entityAt: entityName ifAbsent: aBlock
	^(entities detect: [:each | each key = entityName] ifNone: [^aBlock value]) value!

printXMLOn: writer
	self entitiesDo: [:eName :eValue | eValue printXMLOn: writer]!

topElement
	^self entities first value! !

!XMLNodeWithEntities categoriesForMethods!
addEntity:!accessing!public! !
addEntity:value:!accessing!public! !
elements!accessing!public! !
entities!accessing!public! !
entitiesDo:!enumerating!public! !
entityAt:!accessing!public! !
entityAt:ifAbsent:!accessing!public! !
printXMLOn:!printing!public! !
topElement!accessing!public! !
!

