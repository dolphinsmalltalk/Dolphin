"Filed out from Dolphin Smalltalk 7"!

RBPatternBlockNode subclass: #RBPatternWrapperBlockNode
	instanceVariableNames: 'wrappedNode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBPatternWrapperBlockNode guid: (GUID fromString: '{9C1E1F14-CB93-4BE7-A1DD-A621BA57B12E}')!
RBPatternWrapperBlockNode comment: ''!
!RBPatternWrapperBlockNode categoriesForClass!Refactory-Parser! !
!RBPatternWrapperBlockNode methodsFor!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptPatternWrapperBlockNode: self!

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

