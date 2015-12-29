"Filed out from Dolphin Smalltalk X6.2"!

StsBehaviorProxy subclass: #StsClassProxy
	instanceVariableNames: 'guid metaClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsClassProxy guid: (GUID fromString: '{B87AA04B-D6DB-4824-BFE0-B0A4E5CF5A04}')!
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

