"Filed out from Dolphin Smalltalk 7"!

WeakSet variableSubclass: #WeakIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WeakIdentitySet guid: (GUID fromString: '{87B4C539-026E-11D3-9FD7-00A0CC3E4A32}')!
WeakIdentitySet comment: ''!
!WeakIdentitySet categoriesForClass!Collections-Unordered!Collections-Weak! !
!WeakIdentitySet methodsFor!

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
	^anObject identityHash \\ anInteger + 1! !
!WeakIdentitySet categoriesFor: #findElementOrNil:!private!searching! !
!WeakIdentitySet categoriesFor: #hash:max:!private!searching! !

!WeakIdentitySet class methodsFor!

initialize
	"Initialize the receiver.
	Class initialize methods are ignored by the SourceManager unless directly implemented
	so we must implement to get the bereavement notifications."

	super initialize! !
!WeakIdentitySet class categoriesFor: #initialize!development!initializing!public! !

