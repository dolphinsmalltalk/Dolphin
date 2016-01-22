"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLineOption
	instanceVariableNames: 'name isArgumentAllowed isArgumentRequired block'
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

initializeOptionAllowingArgumentNamed: aString block: aBlock

	name :=aString.
	isArgumentAllowed := true.
	isArgumentRequired := false.
	block := aBlock.
!

initializeOptionNamed: aString

	name :=aString.
	isArgumentAllowed := false.
	isArgumentRequired := false.!

initializeOptionNamed: aString block: aBlock

	name :=aString.
	isArgumentAllowed := false.
	isArgumentRequired := false.
	block := aBlock.
!

initializeOptionRequiringArgumentNamed: aString

	name :=aString.
	isArgumentAllowed := true.
	isArgumentRequired := true.!

initializeOptionRequiringArgumentNamed: aString block: aBlock

	name :=aString.
	isArgumentAllowed := true.
	isArgumentRequired := true.
	block := aBlock.!

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
	name := anObject!

value: anObject

	block ifNil: [^self].
	isArgumentAllowed
		ifTrue: [block value: anObject]
		ifFalse: [block value].
! !
!CommandLineOption categoriesFor: #initializeFromStream:!private! !
!CommandLineOption categoriesFor: #initializeOptionAllowingArgumentNamed:!private! !
!CommandLineOption categoriesFor: #initializeOptionAllowingArgumentNamed:block:!private! !
!CommandLineOption categoriesFor: #initializeOptionNamed:!private! !
!CommandLineOption categoriesFor: #initializeOptionNamed:block:!private! !
!CommandLineOption categoriesFor: #initializeOptionRequiringArgumentNamed:!private! !
!CommandLineOption categoriesFor: #initializeOptionRequiringArgumentNamed:block:!private! !
!CommandLineOption categoriesFor: #isArgumentAllowed!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentAllowed:!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired:!accessing!public! !
!CommandLineOption categoriesFor: #isLongOption!public! !
!CommandLineOption categoriesFor: #name!accessing!public! !
!CommandLineOption categoriesFor: #name:!accessing!public! !
!CommandLineOption categoriesFor: #value:!public! !

!CommandLineOption class methodsFor!

allowingArgumentNamed: aString

	^self new
		initializeOptionAllowingArgumentNamed: aString;
		yourself!

allowingArgumentNamed: aString block: aBlock

	^self new
		initializeOptionAllowingArgumentNamed: aString block: aBlock;
		yourself!

fromStream: aStream

	^self new
		initializeFromStream: aStream;
		yourself!

named: aString

	^self new
		initializeOptionNamed: aString;
		yourself!

named: aString block: aBlock

	^self new
		initializeOptionNamed: aString block: aBlock;
		yourself!

requiringArgumentNamed: aString

	^self new
		initializeOptionRequiringArgumentNamed: aString;
		yourself!

requiringArgumentNamed: aString block: aBlock

	^self new
		initializeOptionRequiringArgumentNamed: aString block: aBlock;
		yourself! !
!CommandLineOption class categoriesFor: #allowingArgumentNamed:!public! !
!CommandLineOption class categoriesFor: #allowingArgumentNamed:block:!public! !
!CommandLineOption class categoriesFor: #fromStream:!public! !
!CommandLineOption class categoriesFor: #named:!public! !
!CommandLineOption class categoriesFor: #named:block:!public! !
!CommandLineOption class categoriesFor: #requiringArgumentNamed:!public! !
!CommandLineOption class categoriesFor: #requiringArgumentNamed:block:!public! !

