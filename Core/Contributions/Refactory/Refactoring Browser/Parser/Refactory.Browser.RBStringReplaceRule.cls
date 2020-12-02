"Filed out from Dolphin Smalltalk 7"!

RBReplaceRule subclass: #RBStringReplaceRule
	instanceVariableNames: 'replaceTree'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBStringReplaceRule guid: (GUID fromString: '{bbdb2681-b086-4cdc-9efd-14d33492c0aa}')!
RBStringReplaceRule comment: ''!
!RBStringReplaceRule categoriesForClass!Refactory-ParseTree Matching! !
!RBStringReplaceRule methodsFor!

foundMatchFor: aProgramNode 
	| newNode |
	newNode := replaceTree copyInContext: self context.
	aProgramNode replaceMethodSource: newNode.
	newNode copyCommentsFrom: aProgramNode.
	^newNode!

methodReplaceString: replaceString 
	replaceTree := RBParser parseRewriteMethod: replaceString!

replaceString: replaceString
	replaceTree := RBParser parseRewriteExpression: replaceString.
	searchTree isSequence = replaceTree isSequence
		ifFalse: 
			[searchTree isSequence
				ifTrue: [replaceTree := RBSequenceNode statements: {replaceTree}]
				ifFalse: [searchTree := RBSequenceNode statements: {searchTree}]]!

searchFor: searchString replaceWith: replaceString 
	self searchString: searchString.
	self replaceString: replaceString!

searchFor: searchString replaceWith: replaceString when: aBlock 
	self searchFor: searchString replaceWith: replaceString.
	verificationBlock := aBlock!

searchForMethod: searchString replaceWith: replaceString 
	self methodSearchString: searchString.
	self methodReplaceString: replaceString!

searchForMethod: searchString replaceWith: replaceString when: aBlock 
	self searchForMethod: searchString replaceWith: replaceString.
	verificationBlock := aBlock!

searchForTree: aBRProgramNode replaceWith: replaceNode 
	searchTree := aBRProgramNode.
	replaceTree := replaceNode!

searchForTree: aBRProgramNode replaceWith: replaceString when: aBlock 
	self searchForTree: aBRProgramNode replaceWith: replaceString.
	verificationBlock := aBlock! !
!RBStringReplaceRule categoriesFor: #foundMatchFor:!matching!public! !
!RBStringReplaceRule categoriesFor: #methodReplaceString:!initialize/release!public! !
!RBStringReplaceRule categoriesFor: #replaceString:!initialize/release!public! !
!RBStringReplaceRule categoriesFor: #searchFor:replaceWith:!initialize/release!public! !
!RBStringReplaceRule categoriesFor: #searchFor:replaceWith:when:!initialize/release!public! !
!RBStringReplaceRule categoriesFor: #searchForMethod:replaceWith:!initialize/release!public! !
!RBStringReplaceRule categoriesFor: #searchForMethod:replaceWith:when:!initialize/release!public! !
!RBStringReplaceRule categoriesFor: #searchForTree:replaceWith:!initialize/release!public! !
!RBStringReplaceRule categoriesFor: #searchForTree:replaceWith:when:!initialize/release!public! !

!RBStringReplaceRule class methodsFor!

searchFor: searchString replaceWith: replaceString 
	^self new searchFor: searchString replaceWith: replaceString!

searchFor: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchFor: searchString
		replaceWith: replaceString
		when: aBlock!

searchForMethod: searchString replaceWith: replaceString 
	^(self new)
		searchForMethod: searchString replaceWith: replaceString;
		yourself!

searchForMethod: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchForMethod: searchString
		replaceWith: replaceString
		when: aBlock!

searchForTree: anStProgramNode replaceWith: replaceString 
	^self new searchForTree: anStProgramNode replaceWith: replaceString!

searchForTree: aRBProgramNode replaceWith: replaceString when: aBlock 
	^self new 
		searchForTree: aRBProgramNode
		replaceWith: replaceString
		when: aBlock! !
!RBStringReplaceRule class categoriesFor: #searchFor:replaceWith:!instance creation!public! !
!RBStringReplaceRule class categoriesFor: #searchFor:replaceWith:when:!instance creation!public! !
!RBStringReplaceRule class categoriesFor: #searchForMethod:replaceWith:!instance creation!public! !
!RBStringReplaceRule class categoriesFor: #searchForMethod:replaceWith:when:!instance creation!public! !
!RBStringReplaceRule class categoriesFor: #searchForTree:replaceWith:!instance creation!public! !
!RBStringReplaceRule class categoriesFor: #searchForTree:replaceWith:when:!instance creation!public! !

