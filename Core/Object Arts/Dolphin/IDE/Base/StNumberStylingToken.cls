"Filed out from Dolphin Smalltalk X6"!

StNumberLiteralToken subclass: #StNumberStylingToken
	instanceVariableNames: 'numberClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StNumberStylingToken guid: (GUID fromString: '{C7C638B9-53CD-4316-803A-A5AC217D7F73}')!
StNumberStylingToken comment: ''!
!StNumberStylingToken categoriesForClass!Unclassified! !
!StNumberStylingToken methodsFor!

isNegative
	^self source first == $-!

numberClass
	^numberClass ifNil: [self value class]!

numberClass: aClass 
	numberClass := aClass!

value
	value isNil ifTrue: [value := [Number readFrom: self source readStream] on: Error do: [0]].
	^value! !
!StNumberStylingToken categoriesFor: #isNegative!accessing!public! !
!StNumberStylingToken categoriesFor: #numberClass!public! !
!StNumberStylingToken categoriesFor: #numberClass:!accessing!private! !
!StNumberStylingToken categoriesFor: #value!accessing!public! !

