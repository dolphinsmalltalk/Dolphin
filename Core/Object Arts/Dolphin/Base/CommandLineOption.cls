"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLineOption
	instanceVariableNames: 'name isArgumentAllowed isArgumentRequired'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLineOption guid: (GUID fromString: '{24FED4FA-6D57-4F07-B973-B1CD9591567A}')!
CommandLineOption comment: 'This class is used internally by instances of CommandLine to encapsulate option rules.'!
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

initializeOptionAllowingArgumentNamed: aString

	name :=aString.
	isArgumentAllowed := true.
	isArgumentRequired := false.!

initializeOptionNamed: aString

	name :=aString.
	isArgumentAllowed := false.
	isArgumentRequired := false.!

initializeOptionRequiringArgumentNamed: aString

	name :=aString.
	isArgumentAllowed := true.
	isArgumentRequired := true.!

isArgumentAllowed
	^isArgumentAllowed!

isArgumentAllowed: anObject
	^isArgumentAllowed := anObject!

isArgumentRequired
	^isArgumentRequired!

isArgumentRequired: anObject
	^isArgumentRequired := anObject!

isLongOption

	^name isString!

name
	^name!

name: anObject
	name := anObject! !
!CommandLineOption categoriesFor: #initializeFromStream:!private! !
!CommandLineOption categoriesFor: #initializeOptionAllowingArgumentNamed:!private! !
!CommandLineOption categoriesFor: #initializeOptionNamed:!private! !
!CommandLineOption categoriesFor: #initializeOptionRequiringArgumentNamed:!private! !
!CommandLineOption categoriesFor: #isArgumentAllowed!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentAllowed:!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired:!accessing!public! !
!CommandLineOption categoriesFor: #isLongOption!public! !
!CommandLineOption categoriesFor: #name!accessing!public! !
!CommandLineOption categoriesFor: #name:!accessing!public! !

!CommandLineOption class methodsFor!

allowingArgumentNamed: aString

	^self new
		initializeOptionAllowingArgumentNamed: aString;
		yourself!

fromStream: aStream

	^self new
		initializeFromStream: aStream;
		yourself!

named: aString

	^self new
		initializeOptionNamed: aString;
		yourself!

requiringArgumentNamed: aString

	^self new
		initializeOptionRequiringArgumentNamed: aString;
		yourself! !
!CommandLineOption class categoriesFor: #allowingArgumentNamed:!public! !
!CommandLineOption class categoriesFor: #fromStream:!public! !
!CommandLineOption class categoriesFor: #named:!public! !
!CommandLineOption class categoriesFor: #requiringArgumentNamed:!public! !

