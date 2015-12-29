"Filed out from Dolphin Smalltalk 2000 release 4.01"!

Model subclass: #ClassToRename
	instanceVariableNames: 'rewriteRule builder class'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'notUsed'!
ClassToRename comment: ''!

ClassToRename guid: (GUID fromString: '{83C27F52-B80F-487B-BD8C-B4035CA0CF2E}')!

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

