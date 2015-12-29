"Filed out from Dolphin Smalltalk X6.2"!

StsBehaviorProxy subclass: #StsMetaClassProxy
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsMetaClassProxy guid: (GUID fromString: '{D44A26C0-44C0-4709-8E13-A405B9D25126}')!
StsMetaClassProxy comment: ''!
!StsMetaClassProxy categoriesForClass!Unclassified! !
!StsMetaClassProxy methodsFor!

definition
	| stream classInstVars |
	stream := ReadStream on: instanceClass definition.
	classInstVars := (stream
				nextLine;
				nextLine;
				nextLine;
				nextLine;
				nextLine) trimBlanks.
	^self name asString , ' instanceVariableNames: ' 
		, (classInstVars copyFrom: 29 to: classInstVars size)!

instanceClass: aStsClassProxy 
	instanceClass := aStsClassProxy! !
!StsMetaClassProxy categoriesFor: #definition!public! !
!StsMetaClassProxy categoriesFor: #instanceClass:!public! !

