"Filed out from Dolphin Smalltalk 7"!

StsChangeNode subclass: #StsChangedResourceNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedResourceNode guid: (GUID fromString: '{b2642402-3173-451a-a6aa-340acd00a824}')!
StsChangedResourceNode comment: ''!
!StsChangedResourceNode categoriesForClass!Unclassified! !
!StsChangedResourceNode methodsFor!

browseEditions
	(leftEdition ifNil: [rightEdition ifNil: [^nil]]) browseEdition!

icon
	^ResourceIdentifier icon!

leftSource
	^leftEdition isNil 
		ifTrue: ['The resource does not exist' asRichText]
		ifFalse: [leftEdition resource printString]!

loadLeft
	leftEdition load!

loadRight
	rightEdition load!

rightSource
	^rightEdition isNil 
		ifTrue: ['The resource does not exist' asRichText]
		ifFalse: [rightEdition resource printString]! !
!StsChangedResourceNode categoriesFor: #browseEditions!public! !
!StsChangedResourceNode categoriesFor: #icon!public! !
!StsChangedResourceNode categoriesFor: #leftSource!public! !
!StsChangedResourceNode categoriesFor: #loadLeft!public! !
!StsChangedResourceNode categoriesFor: #loadRight!public! !
!StsChangedResourceNode categoriesFor: #rightSource!public! !

