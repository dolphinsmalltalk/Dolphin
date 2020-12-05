"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBPatternBlockNode subclass: #'Refactory.Browser.RBPatternWrapperBlockNode'
	instanceVariableNames: 'wrappedNode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBPatternWrapperBlockNode guid: (Core.GUID fromString: '{9c1e1f14-cb93-4be7-a1dd-a621ba57b12e}')!
Refactory.Browser.RBPatternWrapperBlockNode comment: ''!
!Refactory.Browser.RBPatternWrapperBlockNode categoriesForClass!Refactory-Parser! !
!Refactory.Browser.RBPatternWrapperBlockNode methodsFor!

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
!Refactory.Browser.RBPatternWrapperBlockNode categoriesFor: #acceptVisitor:!public!visitor! !
!Refactory.Browser.RBPatternWrapperBlockNode categoriesFor: #copyInContext:!matching!public! !
!Refactory.Browser.RBPatternWrapperBlockNode categoriesFor: #match:inContext:!matching!public! !
!Refactory.Browser.RBPatternWrapperBlockNode categoriesFor: #postCopy!copying!public! !
!Refactory.Browser.RBPatternWrapperBlockNode categoriesFor: #precedence!accessing!public! !
!Refactory.Browser.RBPatternWrapperBlockNode categoriesFor: #wrappedNode!accessing!public! !
!Refactory.Browser.RBPatternWrapperBlockNode categoriesFor: #wrappedNode:!accessing!public! !

