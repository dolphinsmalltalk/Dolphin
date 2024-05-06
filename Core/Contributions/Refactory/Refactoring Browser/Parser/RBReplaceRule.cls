"Filed out from Dolphin Smalltalk"!

RBParseTreeRule subclass: #RBReplaceRule
	instanceVariableNames: 'verificationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!RBReplaceRule categoriesForMethods!
canMatch:!matching!public! !
foundMatchFor:!matching!public! !
initialize!initialize/release!public! !
replace:with:!matching!public! !
!

