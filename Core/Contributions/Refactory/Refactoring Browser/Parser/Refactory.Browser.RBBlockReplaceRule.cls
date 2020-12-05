"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBReplaceRule subclass: #'Refactory.Browser.RBBlockReplaceRule'
	instanceVariableNames: 'replaceBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBBlockReplaceRule guid: (Core.GUID fromString: '{66d568a6-5f15-4871-8f69-3a2ced82706f}')!
Refactory.Browser.RBBlockReplaceRule comment: ''!
!Refactory.Browser.RBBlockReplaceRule categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.RBBlockReplaceRule methodsFor!

foundMatchFor: aProgramNode 
	| newNode |
	newNode := replaceBlock value: aProgramNode.
	aProgramNode replaceMethodSource: newNode.
	^newNode!

initialize
	super initialize.
	replaceBlock := [:aNode | aNode]!

searchFor: searchString replaceWith: aBlock 
	self searchString: searchString.
	replaceBlock := aBlock!

searchFor: searchString replaceWith: replBlock when: verifyBlock 
	self searchFor: searchString replaceWith: replBlock.
	verificationBlock := verifyBlock!

searchForMethod: searchString replaceWith: aBlock 
	self methodSearchString: searchString.
	replaceBlock := aBlock!

searchForMethod: searchString replaceWith: replBlock when: verifyBlock 
	self searchForMethod: searchString replaceWith: replBlock.
	verificationBlock := verifyBlock!

searchForTree: aBRProgramNode replaceWith: aBlock 
	searchTree := aBRProgramNode.
	replaceBlock := aBlock!

searchForTree: aBRProgramNode replaceWith: replBlock when: verifyBlock 
	self searchForTree: aBRProgramNode replaceWith: replBlock.
	verificationBlock := verifyBlock! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #foundMatchFor:!matching!public! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #searchFor:replaceWith:!initialize/release!public! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #searchFor:replaceWith:when:!initialize/release!public! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #searchForMethod:replaceWith:!initialize/release!public! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #searchForMethod:replaceWith:when:!initialize/release!public! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #searchForTree:replaceWith:!initialize/release!public! !
!Refactory.Browser.RBBlockReplaceRule categoriesFor: #searchForTree:replaceWith:when:!initialize/release!public! !

!Refactory.Browser.RBBlockReplaceRule class methodsFor!

searchFor: searchString replaceWith: replaceBlock 
	^self new searchFor: searchString replaceWith: replaceBlock!

searchFor: searchString replaceWith: replaceBlock when: aBlock 
	^self new 
		searchFor: searchString
		replaceWith: replaceBlock
		when: aBlock!

searchForMethod: searchString replaceWith: replaceBlock 
	^self new searchForMethod: searchString replaceWith: replaceBlock!

searchForMethod: searchString replaceWith: replaceBlock when: aBlock 
	^self new 
		searchForMethod: searchString
		replaceWith: replaceBlock
		when: aBlock!

searchForTree: aRBProgramNode replaceWith: replaceBlock 
	^self new searchForTree: aRBProgramNode replaceWith: replaceBlock!

searchForTree: aRBProgramNode replaceWith: replaceBlock when: aBlock 
	^self new 
		searchForTree: aRBProgramNode
		replaceWith: replaceBlock
		when: aBlock! !
!Refactory.Browser.RBBlockReplaceRule class categoriesFor: #searchFor:replaceWith:!instance creation!public! !
!Refactory.Browser.RBBlockReplaceRule class categoriesFor: #searchFor:replaceWith:when:!instance creation!public! !
!Refactory.Browser.RBBlockReplaceRule class categoriesFor: #searchForMethod:replaceWith:!instance creation!public! !
!Refactory.Browser.RBBlockReplaceRule class categoriesFor: #searchForMethod:replaceWith:when:!instance creation!public! !
!Refactory.Browser.RBBlockReplaceRule class categoriesFor: #searchForTree:replaceWith:!instance creation!public! !
!Refactory.Browser.RBBlockReplaceRule class categoriesFor: #searchForTree:replaceWith:when:!instance creation!public! !

