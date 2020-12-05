"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBParseTreeRule subclass: #'Refactory.Browser.RBReplaceRule'
	instanceVariableNames: 'verificationBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBReplaceRule guid: (Core.GUID fromString: '{206caebb-9f38-4bdf-85a6-50261f48360e}')!
Refactory.Browser.RBReplaceRule isNonInstantiable: true!
Refactory.Browser.RBReplaceRule comment: ''!
!Refactory.Browser.RBReplaceRule categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.RBReplaceRule methodsFor!

canMatch: aProgramNode 
	^verificationBlock value: aProgramNode!

foundMatchFor: aProgramNode 
	self subclassResponsibility!

initialize
	super initialize.
	verificationBlock := [:aNode | true]!

replace: aProgramNode with: newNode 
	aProgramNode replaceMethodSource: newNode! !
!Refactory.Browser.RBReplaceRule categoriesFor: #canMatch:!matching!public! !
!Refactory.Browser.RBReplaceRule categoriesFor: #foundMatchFor:!matching!public! !
!Refactory.Browser.RBReplaceRule categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.RBReplaceRule categoriesFor: #replace:with:!matching!public! !

