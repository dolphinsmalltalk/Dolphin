"Filed out from Dolphin Smalltalk"!

StLiteralNode subclass: #StLiteralArrayNode
	instanceVariableNames: 'isByteArray stop contents start'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLiteralArrayNode guid: (GUID fromString: '{d0aec5f6-fbc7-4020-8545-2bca5eeb2bca}')!
StLiteralArrayNode comment: ''!
!StLiteralArrayNode categoriesForClass!Unclassified! !
!StLiteralArrayNode methodsFor!

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
!StLiteralArrayNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
children!accessing!public! !
childrenDo:!accessing!public! !
contents!accessing!public! !
contents:!accessing!public! !
isForByteArray!public!testing! !
isLiteralArray!public!testing! !
postCopy!copying!public! !
startPosition:contents:stopPosition:isByteArray:!initializing!public! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
value!accessing!public! !
valueClass!accessing!public! !
!

!StLiteralArrayNode class methodsFor!

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
!StLiteralArrayNode class categoriesForMethods!
startPosition:contents:stopPosition:isByteArray:!instance creation!public! !
value:!instance creation!public! !
!

