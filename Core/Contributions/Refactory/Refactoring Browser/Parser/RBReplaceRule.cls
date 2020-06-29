"Filed out from Dolphin Smalltalk 7"!

RBParseTreeRule subclass: #RBReplaceRule
	instanceVariableNames: 'verificationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBReplaceRule guid: (GUID fromString: '{206caebb-9f38-4bdf-85a6-50261f48360e}')!
RBReplaceRule isAbstract: true!
RBReplaceRule comment: ''!
!RBReplaceRule categoriesForClass!Refactory-ParseTree Matching! !
!RBReplaceRule methodsFor!

canMatch: aProgramNode 
	^verificationBlock value: aProgramNode!

foundMatchFor: aProgramNode 
	self subclassResponsibility!

initialize
	super initialize.
	verificationBlock := [:aNode | true]!

replace: aProgramNode with: newNode 
	aProgramNode replaceMethodSource: newNode! !
!RBReplaceRule categoriesFor: #canMatch:!matching!public! !
!RBReplaceRule categoriesFor: #foundMatchFor:!matching!public! !
!RBReplaceRule categoriesFor: #initialize!initialize/release!public! !
!RBReplaceRule categoriesFor: #replace:with:!matching!public! !

