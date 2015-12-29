"Filed out from Dolphin Smalltalk X6.2"!

StsImportProxy subclass: #StsBehaviorProxy
	instanceVariableNames: 'definition methodDictionary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsBehaviorProxy guid: (GUID fromString: '{566CCA11-EA06-49BE-9241-49E726D69609}')!
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

