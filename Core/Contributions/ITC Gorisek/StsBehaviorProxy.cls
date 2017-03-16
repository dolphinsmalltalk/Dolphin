"Filed out from Dolphin Smalltalk 7"!

StsImportProxy subclass: #StsBehaviorProxy
	instanceVariableNames: 'definition methodDictionary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsBehaviorProxy guid: (GUID fromString: '{566cca11-ea06-49be-9241-49e726d69609}')!
StsBehaviorProxy comment: ''!
!StsBehaviorProxy categoriesForClass!Unclassified! !
!StsBehaviorProxy methodsFor!

definition
	^definition!

definition: aString 
	definition := aString!

displayOn: aStream 
	aStream nextPutAll: name asString!

methodDictionary
	methodDictionary isNil ifTrue: [methodDictionary := LookupTable new].
	^methodDictionary!

methods
	^self methodDictionary values! !
!StsBehaviorProxy categoriesFor: #definition!public! !
!StsBehaviorProxy categoriesFor: #definition:!public! !
!StsBehaviorProxy categoriesFor: #displayOn:!public! !
!StsBehaviorProxy categoriesFor: #methodDictionary!public! !
!StsBehaviorProxy categoriesFor: #methods!public! !

