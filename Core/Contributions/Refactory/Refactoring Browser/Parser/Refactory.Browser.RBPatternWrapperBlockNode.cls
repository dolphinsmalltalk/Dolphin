﻿"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBPatternBlockNode
	subclass: #'Refactory.Browser.RBPatternWrapperBlockNode'
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

!Refactory.Browser.RBPatternWrapperBlockNode categoriesForMethods!
acceptVisitor:!public!visitor! !
copyInContext:!matching!public! !
match:inContext:!matching!public! !
postCopy!copying!public! !
precedence!accessing!public! !
wrappedNode!accessing!public! !
wrappedNode:!accessing!public! !
!

