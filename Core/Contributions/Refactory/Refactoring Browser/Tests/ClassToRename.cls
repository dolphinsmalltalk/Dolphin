"Filed out from Dolphin Smalltalk 7"!

Model subclass: #ClassToRename
	instanceVariableNames: 'rewriteRule builder class'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'notUsed'
	classConstants: {}!
ClassToRename guid: (GUID fromString: '{83c27f52-b80f-487b-bd8c-b4035ca0cf2e}')!
ClassToRename comment: ''!
!ClassToRename categoriesForClass!Refactory-Test data! !
!ClassToRename methodsFor!

method1
	^self method2!

method2
	^self method1! !
!ClassToRename categoriesFor: #method1!performing!public! !
!ClassToRename categoriesFor: #method2!performing!public! !

!ClassToRename class methodsFor!

new
	^super new initialize! !
!ClassToRename class categoriesFor: #new!performing!public! !

