"Filed out from Dolphin Smalltalk"!

Kernel.StLiteralNode subclass: #'Kernel.AbstractLiteralArrayNode'
	instanceVariableNames: 'stop contents start'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AbstractLiteralArrayNode guid: (Core.GUID fromString: '{96fc9b84-f4c6-403b-b79a-a316c89abbaf}')!
Kernel.AbstractLiteralArrayNode isNonInstantiable: true!
Kernel.AbstractLiteralArrayNode comment: ''!
!Kernel.AbstractLiteralArrayNode categoriesForClass!Unclassified! !
!Kernel.AbstractLiteralArrayNode methodsFor!

= anObject
	| hisContents |
	self == anObject ifTrue: [^true].
	self class == anObject class ifFalse: [^false].
	contents size = (hisContents := anObject contents) size ifFalse: [^false].
	1 to: contents size do: [:i | (contents at: i) = (hisContents at: i) ifFalse: [^false]].
	^true!

children
	^contents!

childrenDo: aMonadicValuable
	contents do: aMonadicValuable!

contents
	^contents!

contents: aRBLiteralNodeCollection 
	contents := aRBLiteralNodeCollection.
	contents do: [:each | each parent: self]!

copyInContext: aDictionary
	^self class
		startPosition: nil
		contents: (self copyList: contents inContext: aDictionary)
		stopPosition: nil!

equalTo: anObject withMapping: aDictionary 
	self class = anObject class ifFalse: [^false].
	self contents size = anObject contents size ifFalse: [^false].
	1 to: self contents size
		do: 
			[:i | 
			((self contents at: i) equalTo: (anObject contents at: i) withMapping: aDictionary) 
				ifFalse: [^false]].
	^true!

postCopy
	super postCopy.
	self contents: (contents collect: [:each | each copy]).
	^self!

startPosition: startInteger contents: anArray stopPosition: stopInteger
	start := startInteger.
	self contents: anArray.
	stop := stopInteger!

startWithoutParentheses
	^start!

stopWithoutParentheses
	^stop!

value
	| array |
	array := self valueClass new: contents size.
	1 to: contents size do: [:each | array at: each put: (contents at: each) value].
	^array! !
!Kernel.AbstractLiteralArrayNode categoriesForMethods!
=!comparing!public! !
children!accessing!public! !
childrenDo:!accessing!public! !
contents!accessing!public! !
contents:!accessing!public! !
copyInContext:!matching!public! !
equalTo:withMapping:!comparing!public! !
postCopy!copying!public! !
startPosition:contents:stopPosition:!initializing!public! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
value!accessing!public! !
!

!Kernel.AbstractLiteralArrayNode class methodsFor!

contents: anArrayOfStLiteralNodes
	^self
		startPosition: nil
		contents: anArrayOfStLiteralNodes
		stopPosition: nil!

startPosition: startInteger contents: anArray stopPosition: stopInteger
	^self new
		startPosition: startInteger
			contents: anArray
			stopPosition: stopInteger;
		yourself!

value: aValue
	^(aValue class == ByteArray ifTrue: [StLiteralByteArrayNode] ifFalse: [StLiteralArrayNode])
		startPosition: nil
		contents: (aValue asArray collect: [:each | StLiteralNode value: each])
		stopPosition: nil! !
!Kernel.AbstractLiteralArrayNode class categoriesForMethods!
contents:!instance creation!public! !
startPosition:contents:stopPosition:!instance creation!public! !
value:!instance creation!public! !
!

