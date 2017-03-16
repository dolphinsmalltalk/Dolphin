"Filed out from Dolphin Smalltalk 7"!

StNumberLiteralToken subclass: #StNumberStylingToken
	instanceVariableNames: 'numberClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StNumberStylingToken guid: (GUID fromString: '{c7c638b9-53cd-4316-803a-a5ac217d7f73}')!
StNumberStylingToken comment: ''!
!StNumberStylingToken categoriesForClass!Unclassified! !
!StNumberStylingToken methodsFor!

numberClass
	^numberClass ifNil: [self value class]!

numberClass: aClass 
	numberClass := aClass!

value
	value isNil ifTrue: [value := [Number readFrom: self source readStream] on: Error do: [0]].
	^value! !
!StNumberStylingToken categoriesFor: #numberClass!public! !
!StNumberStylingToken categoriesFor: #numberClass:!accessing!private! !
!StNumberStylingToken categoriesFor: #value!accessing!public! !

