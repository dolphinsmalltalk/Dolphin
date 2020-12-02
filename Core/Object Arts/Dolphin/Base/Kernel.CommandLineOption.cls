"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLineOption
	instanceVariableNames: 'name isArgumentAllowed isArgumentRequired block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CommandLineOption guid: (GUID fromString: '{24fed4fa-6d57-4f07-b973-b1cd9591567a}')!
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

initializeOption: aString 
	name := aString.
	isArgumentAllowed := false.
	isArgumentRequired := false!

initializeOption: aString block: aBlock 
	name := aString.
	isArgumentAllowed := false.
	isArgumentRequired := false.
	block := aBlock!

initializeOptionAllowingArgument: aString 
	name := aString.
	isArgumentAllowed := true.
	isArgumentRequired := false!

initializeOptionAllowingArgument: aString block: aBlock 
	name := aString.
	isArgumentAllowed := true.
	isArgumentRequired := false.
	block := aBlock!

initializeOptionRequiringArgument: aString 
	name := aString.
	isArgumentAllowed := true.
	isArgumentRequired := true!

initializeOptionRequiringArgument: aString block: aBlock 
	name := aString.
	isArgumentAllowed := true.
	isArgumentRequired := true.
	block := aBlock!

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
!CommandLineOption categoriesFor: #initializeOption:!private! !
!CommandLineOption categoriesFor: #initializeOption:block:!private! !
!CommandLineOption categoriesFor: #initializeOptionAllowingArgument:!private! !
!CommandLineOption categoriesFor: #initializeOptionAllowingArgument:block:!private! !
!CommandLineOption categoriesFor: #initializeOptionRequiringArgument:!private! !
!CommandLineOption categoriesFor: #initializeOptionRequiringArgument:block:!private! !
!CommandLineOption categoriesFor: #isArgumentAllowed!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentAllowed:!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired!accessing!public! !
!CommandLineOption categoriesFor: #isArgumentRequired:!accessing!public! !
!CommandLineOption categoriesFor: #isLongOption!public! !
!CommandLineOption categoriesFor: #name!accessing!public! !
!CommandLineOption categoriesFor: #name:!accessing!public! !
!CommandLineOption categoriesFor: #value:!public! !

!CommandLineOption class methodsFor!

allowingArgument: aString 
	^(self new)
		initializeOptionAllowingArgument: aString;
		yourself!

allowingArgument: aString block: aBlock 
	^(self new)
		initializeOptionAllowingArgument: aString block: aBlock;
		yourself!

fromStream: aStream

	^self new
		initializeFromStream: aStream;
		yourself!

named: aString 
	^(self new)
		initializeOption: aString;
		yourself!

named: aString block: aBlock 
	^(self new)
		initializeOption: aString block: aBlock;
		yourself!

requiringArgument: aString 
	^(self new)
		initializeOptionRequiringArgument: aString;
		yourself!

requiringArgument: aString block: aBlock 
	^(self new)
		initializeOptionRequiringArgument: aString block: aBlock;
		yourself! !
!CommandLineOption class categoriesFor: #allowingArgument:!public! !
!CommandLineOption class categoriesFor: #allowingArgument:block:!public! !
!CommandLineOption class categoriesFor: #fromStream:!public! !
!CommandLineOption class categoriesFor: #named:!public! !
!CommandLineOption class categoriesFor: #named:block:!public! !
!CommandLineOption class categoriesFor: #requiringArgument:!public! !
!CommandLineOption class categoriesFor: #requiringArgument:block:!public! !

