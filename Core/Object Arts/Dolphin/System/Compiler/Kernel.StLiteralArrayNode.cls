"Filed out from Dolphin Smalltalk 7"!

Kernel.StLiteralNode subclass: #'Kernel.StLiteralArrayNode'
	instanceVariableNames: 'isByteArray stop contents start'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralArrayNode guid: (Core.GUID fromString: '{d0aec5f6-fbc7-4020-8545-2bca5eeb2bca}')!
Kernel.StLiteralArrayNode comment: ''!
!Kernel.StLiteralArrayNode categoriesForClass!Unclassified! !
!Kernel.StLiteralArrayNode methodsFor!

= anObject 
	super = anObject ifFalse: [^false].
	self isForByteArray = anObject isForByteArray ifFalse: [^false].
	self contents size = anObject contents size ifFalse: [^false].
	1 to: self contents size
		do: [:i | (self contents at: i) = (anObject contents at: i) ifFalse: [^false]].
	^true!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitLiteralArrayNode: self!

children
	^contents!

childrenDo: aMonadicValuable
	contents do: aMonadicValuable!

contents
	^contents!

contents: aRBLiteralNodeCollection 
	contents := aRBLiteralNodeCollection.
	contents do: [:each | each parent: self]!

isForByteArray
	^isByteArray!

isLiteralArray
	^true!

postCopy
	super postCopy.
	self contents: (contents collect: [:each | each copy]).
	^self!

startPosition: startInteger contents: anArray stopPosition: stopInteger isByteArray: aBoolean 
	start := startInteger.
	self contents: anArray.
	stop := stopInteger.
	isByteArray := aBoolean!

startWithoutParentheses
	^start!

stopWithoutParentheses
	^stop!

value
	| array |
	array := self valueClass new: contents size.
	1 to: contents size do: [:each | array at: each put: (contents at: each) value].
	^array!

valueClass
	^isByteArray ifTrue: [ByteArray] ifFalse: [Array]! !
!Kernel.StLiteralArrayNode categoriesFor: #=!comparing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StLiteralArrayNode categoriesFor: #children!accessing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #contents!accessing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #contents:!accessing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #isForByteArray!public!testing! !
!Kernel.StLiteralArrayNode categoriesFor: #isLiteralArray!public!testing! !
!Kernel.StLiteralArrayNode categoriesFor: #postCopy!copying!public! !
!Kernel.StLiteralArrayNode categoriesFor: #startPosition:contents:stopPosition:isByteArray:!initializing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #value!accessing!public! !
!Kernel.StLiteralArrayNode categoriesFor: #valueClass!accessing!public! !

!Kernel.StLiteralArrayNode class methodsFor!

startPosition: startInteger contents: anArray stopPosition: stopInteger isByteArray: aBoolean 
	^(self new)
		startPosition: startInteger
			contents: anArray
			stopPosition: stopInteger
			isByteArray: aBoolean;
		yourself!

value: aValue
	^self
		startPosition: nil
		contents: (aValue asArray collect: [:each | StLiteralNode value: each])
		stopPosition: nil
		isByteArray: aValue class ~~ Array! !
!Kernel.StLiteralArrayNode class categoriesFor: #startPosition:contents:stopPosition:isByteArray:!instance creation!public! !
!Kernel.StLiteralArrayNode class categoriesFor: #value:!instance creation!public! !

