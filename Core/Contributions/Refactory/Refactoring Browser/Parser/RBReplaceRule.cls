"Filed out from Dolphin Smalltalk XP 2002 release 5.02"!

RBParseTreeRule subclass: #RBReplaceRule
	instanceVariableNames: 'verificationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBReplaceRule guid: (GUID fromString: '{206CAEBB-9F38-4BDF-85A6-50261F48360E}')!
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

