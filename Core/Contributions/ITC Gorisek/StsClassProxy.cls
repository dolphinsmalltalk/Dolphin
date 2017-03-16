"Filed out from Dolphin Smalltalk 7"!

StsBehaviorProxy subclass: #StsClassProxy
	instanceVariableNames: 'guid metaClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsClassProxy guid: (GUID fromString: '{b87aa04b-d6db-4824-bfe0-b0a4e5cf5a04}')!
StsClassProxy comment: ''!
!StsClassProxy categoriesForClass!Unclassified! !
!StsClassProxy methodsFor!

displayOn: aStream 
	aStream nextPutAll: name asString!

guid
	^guid!

guid: aGUID 
	guid := aGUID!

metaClass
	metaClass isNil 
		ifTrue: 
			[metaClass := (StsMetaClassProxy new)
						name: self name asString , ' class';
						instanceClass: self].
	^metaClass! !
!StsClassProxy categoriesFor: #displayOn:!public! !
!StsClassProxy categoriesFor: #guid!public! !
!StsClassProxy categoriesFor: #guid:!public! !
!StsClassProxy categoriesFor: #metaClass!public! !

