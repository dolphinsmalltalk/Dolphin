"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLineOption
	instanceVariableNames: 'name isArgumentAllowed isArgumentRequired value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLineOption guid: (GUID fromString: '{24FED4FA-6D57-4F07-B973-B1CD9591567A}')!
CommandLineOption comment: ''!
!CommandLineOption categoriesForClass!Kernel-Objects! !
!CommandLineOption methodsFor!

initializeFromStream: aStream

	name := aStream next.
	(isArgumentAllowed := aStream peek == $:) ifFalse: [
		isArgumentRequired := false.
	] ifTrue: [
		aStream next.
		(isArgumentRequired := aStream peek ~~ $:) ifFalse: [
			aStream next.
		].
	].
!

isArgumentAllowed
	^isArgumentAllowed!

isArgumentAllowed: anObject
	^isArgumentAllowed := anObject!

isArgumentRequired
	^isArgumentRequired!

isArgumentRequired: anObject
	^isArgumentRequired := anObject!

name
	^name!

name: anObject
	name := anObject!

value
	^value!

value: anObject
	value := anObject! !
!CommandLineOption categoriesFor: #initializeFromStream:!private! !
!CommandLineOption categoriesFor: #isArgumentAllowed!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentAllowed:!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired:!accessing!public! !
!CommandLineOption categoriesFor: #name!accessing!public! !
!CommandLineOption categoriesFor: #name:!accessing!public! !
!CommandLineOption categoriesFor: #value!accessing!public! !
!CommandLineOption categoriesFor: #value:!accessing!public! !

!CommandLineOption class methodsFor!

fromStream: aStream

	^self new
		initializeFromStream: aStream;
		yourself! !
!CommandLineOption class categoriesFor: #fromStream:!public! !

