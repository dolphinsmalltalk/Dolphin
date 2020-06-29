"Filed out from Dolphin Smalltalk 7"!

RBPatternBlockNode subclass: #RBPatternWrapperBlockNode
	instanceVariableNames: 'wrappedNode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBPatternWrapperBlockNode guid: (GUID fromString: '{9c1e1f14-cb93-4be7-a1dd-a621ba57b12e}')!
RBPatternWrapperBlockNode comment: ''!
!RBPatternWrapperBlockNode categoriesForClass!Refactory-Parser! !
!RBPatternWrapperBlockNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitPatternWrapperBlockNode: self!

copyInContext: aDictionary 
	"I don't know what this would mean, so ignore it."

	^wrappedNode copyInContext: aDictionary!

match: aNode inContext: aDictionary 
	(wrappedNode match: aNode inContext: aDictionary) ifFalse: [^false].
	^super match: aNode inContext: aDictionary!

postCopy
	super postCopy.
	self wrappedNode: wrappedNode copy.
	^self!

precedence
	^1!

wrappedNode
	^wrappedNode!

wrappedNode: aRBProgramNode 
	wrappedNode := aRBProgramNode.
	aRBProgramNode parent: self! !
!RBPatternWrapperBlockNode categoriesFor: #acceptVisitor:!public!visitor! !
!RBPatternWrapperBlockNode categoriesFor: #copyInContext:!matching!public! !
!RBPatternWrapperBlockNode categoriesFor: #match:inContext:!matching!public! !
!RBPatternWrapperBlockNode categoriesFor: #postCopy!copying!public! !
!RBPatternWrapperBlockNode categoriesFor: #precedence!accessing!public! !
!RBPatternWrapperBlockNode categoriesFor: #wrappedNode!accessing!public! !
!RBPatternWrapperBlockNode categoriesFor: #wrappedNode:!accessing!public! !

