"Filed out from Dolphin Smalltalk X6.2"!

StsChangedClassDefinitionNode subclass: #StsChangedClassClassDefinitionNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedClassClassDefinitionNode guid: (GUID fromString: '{661CE4C8-289A-11D4-B0D0-000000000000}')!
StsChangedClassClassDefinitionNode comment: ''!
!StsChangedClassClassDefinitionNode categoriesForClass!Unclassified! !
!StsChangedClassClassDefinitionNode methodsFor!

elementDescription
	^self elementName , ' class definition'!

leftSource
	^leftEdition isNil 
		ifTrue: 
			[rightEdition isNil 
				ifTrue: ['']
				ifFalse: [(rightEdition name asString , ' does not exist') asRichText]]
		ifFalse: [leftEdition classDefinition]!

rightSource
	^rightEdition isNil 
		ifTrue: 
			[leftEdition isNil ifTrue: [''] ifFalse: [(leftEdition name asString , ' does not exist') asRichText]]
		ifFalse: [rightEdition classDefinition]! !
!StsChangedClassClassDefinitionNode categoriesFor: #elementDescription!public! !
!StsChangedClassClassDefinitionNode categoriesFor: #leftSource!public! !
!StsChangedClassClassDefinitionNode categoriesFor: #rightSource!public! !

