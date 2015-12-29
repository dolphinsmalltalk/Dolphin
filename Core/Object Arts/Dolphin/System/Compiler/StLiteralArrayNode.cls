"Filed out from Dolphin Smalltalk X6"!

StLiteralNode subclass: #StLiteralArrayNode
	instanceVariableNames: 'isByteArray stop contents start'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLiteralArrayNode guid: (GUID fromString: '{D0AEC5F6-FBC7-4020-8545-2BCA5EEB2BCA}')!
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
	^aProgramNodeVisitor acceptLiteralArrayNode: self!

children
	^contents!

childrenDo: aMonadicValuable
	contents do: aMonadicValuable!

contents
	^contents!

contents: aRBLiteralNodeCollection 
	contents := aRBLiteralNodeCollection.
	contents do: [:each | each parent: self]!

equalTo: anObject withMapping: aDictionary 
	self class = anObject class ifFalse: [^false].
	self isForByteArray = anObject isForByteArray ifFalse: [^false].
	self contents size = anObject contents size ifFalse: [^false].
	1 to: self contents size
		do: 
			[:i | 
			((self contents at: i) equalTo: (anObject contents at: i) withMapping: aDictionary) 
				ifFalse: [^false]].
	^true!

isForByteArray
	^isByteArray!

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
	array := (isByteArray ifTrue: [ByteArray] ifFalse: [Array]) 
				new: contents size.
	1 to: contents size
		do: [:each | array at: each put: (contents at: each) value].
	^array! !
!StLiteralArrayNode categoriesFor: #=!comparing!public! !
!StLiteralArrayNode categoriesFor: #acceptVisitor:!public!visitor! !
!StLiteralArrayNode categoriesFor: #children!accessing!public! !
!StLiteralArrayNode categoriesFor: #childrenDo:!accessing!public! !
!StLiteralArrayNode categoriesFor: #contents!accessing!public! !
!StLiteralArrayNode categoriesFor: #contents:!accessing!public! !
!StLiteralArrayNode categoriesFor: #equalTo:withMapping:!comparing!public! !
!StLiteralArrayNode categoriesFor: #isForByteArray!public!testing! !
!StLiteralArrayNode categoriesFor: #postCopy!copying!public! !
!StLiteralArrayNode categoriesFor: #startPosition:contents:stopPosition:isByteArray:!initializing!public! !
!StLiteralArrayNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StLiteralArrayNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StLiteralArrayNode categoriesFor: #value!accessing!public! !

!StLiteralArrayNode class methodsFor!

startPosition: startInteger contents: anArray stopPosition: stopInteger isByteArray: aBoolean 
	^(self new)
		startPosition: startInteger
			contents: anArray
			stopPosition: stopInteger
			isByteArray: aBoolean;
		yourself!

value: aValue 
	^(self new)
		startPosition: nil
			contents: (aValue asArray collect: [:each | StLiteralNode value: each])
			stopPosition: nil
			isByteArray: aValue class ~~ Array;
		yourself! !
!StLiteralArrayNode class categoriesFor: #startPosition:contents:stopPosition:isByteArray:!instance creation!public! !
!StLiteralArrayNode class categoriesFor: #value:!instance creation!public! !

