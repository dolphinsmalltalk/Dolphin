"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.CommandLineOption'
	instanceVariableNames: 'name isArgumentAllowed isArgumentRequired block'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CommandLineOption guid: (Core.GUID fromString: '{24fed4fa-6d57-4f07-b973-b1cd9591567a}')!
Kernel.CommandLineOption comment: 'This class is used internally by instances of CommandLine to encapsulate option rules.'!
!Kernel.CommandLineOption categoriesForClass!Kernel-Objects! !
!Kernel.CommandLineOption methodsFor!

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
!Kernel.CommandLineOption categoriesFor: #initializeFromStream:!private! !
!Kernel.CommandLineOption categoriesFor: #initializeOption:!private! !
!Kernel.CommandLineOption categoriesFor: #initializeOption:block:!private! !
!Kernel.CommandLineOption categoriesFor: #initializeOptionAllowingArgument:!private! !
!Kernel.CommandLineOption categoriesFor: #initializeOptionAllowingArgument:block:!private! !
!Kernel.CommandLineOption categoriesFor: #initializeOptionRequiringArgument:!private! !
!Kernel.CommandLineOption categoriesFor: #initializeOptionRequiringArgument:block:!private! !
!Kernel.CommandLineOption categoriesFor: #isArgumentAllowed!accessing!public! !
!Kernel.CommandLineOption categoriesFor: #isArgumentAllowed:!accessing!public! !
!Kernel.CommandLineOption categoriesFor: #isArgumentRequired!accessing!public! !
!Kernel.CommandLineOption categoriesFor: #isArgumentRequired:!accessing!public! !
!Kernel.CommandLineOption categoriesFor: #isLongOption!public! !
!Kernel.CommandLineOption categoriesFor: #name!accessing!public! !
!Kernel.CommandLineOption categoriesFor: #name:!accessing!public! !
!Kernel.CommandLineOption categoriesFor: #value:!public! !

!Kernel.CommandLineOption class methodsFor!

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
!Kernel.CommandLineOption class categoriesFor: #allowingArgument:!public! !
!Kernel.CommandLineOption class categoriesFor: #allowingArgument:block:!public! !
!Kernel.CommandLineOption class categoriesFor: #fromStream:!public! !
!Kernel.CommandLineOption class categoriesFor: #named:!public! !
!Kernel.CommandLineOption class categoriesFor: #named:block:!public! !
!Kernel.CommandLineOption class categoriesFor: #requiringArgument:!public! !
!Kernel.CommandLineOption class categoriesFor: #requiringArgument:block:!public! !

