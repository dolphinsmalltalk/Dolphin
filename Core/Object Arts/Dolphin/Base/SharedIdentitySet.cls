"Filed out from Dolphin Smalltalk X6"!

SharedSet variableSubclass: #SharedIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedIdentitySet guid: (GUID fromString: '{87B4C537-026E-11D3-9FD7-00A0CC3E4A32}')!
SharedIdentitySet comment: ''!
!SharedIdentitySet categoriesForClass!Collections-Unordered! !
!SharedIdentitySet methodsFor!

findElementOrNil: anObject 
	"Private - This method is a copy of IdentitySet>>findElementOrNil:"

	| capacity index |
	capacity := self basicSize.
	index := self hash: anObject max: capacity.
	
	[| element |
	(element := self basicAt: index) isNil or: [anObject == element]] 
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anInteger < 8192 
		ifTrue: [anObject identityHash \\ anInteger + 1]
		ifFalse: [anObject identityHash * (anInteger bitShift: -12) \\ anInteger + 1]! !
!SharedIdentitySet categoriesFor: #findElementOrNil:!private!searching! !
!SharedIdentitySet categoriesFor: #hash:max:!private!searching! !

