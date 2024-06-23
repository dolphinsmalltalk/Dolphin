"Filed out from Dolphin Smalltalk"!

Kernel.StTagNode
	subclass: #'Kernel.StAnnotationNode'
	instanceVariableNames: 'selector arguments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StAnnotationNode guid: (Core.GUID fromString: '{e65cb014-8373-4447-9994-f337d37f7544}')!

Kernel.StAnnotationNode comment: ''!

!Kernel.StAnnotationNode categoriesForClass!System-Compiler! !

!Kernel.StAnnotationNode methodsFor!

= anObject
	^self == anObject or: 
			[self class = anObject class
				and: [selector == anObject selector and: [arguments = anObject arguments]]]!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitAnnotationNode: self!

argumentCount
	^arguments size!

arguments
	^arguments!

arguments: aSequencedReadableCollection
	arguments := aSequencedReadableCollection asArray.
	arguments do: [:each | each parent: self]!

childrenDo: aMonadicValuable
	arguments do: aMonadicValuable!

hash
	^selector hash bitXor: (self hashForCollection: arguments)!

isAnnotation
	^true!

keywords
	^selector keywords!

postCopy
	super postCopy.
	self arguments: (arguments collect: [:each | each copy]).
	^self!

selector
	^selector!

setSelector: aSymbol arguments: anArray
	selector := aSymbol asSymbol.
	self arguments: anArray.
	^self! !

!Kernel.StAnnotationNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
argumentCount!accessing!public! !
arguments!accessing!public! !
arguments:!accessing!public! !
childrenDo:!accessing!public! !
hash!comparing!public! !
isAnnotation!public!testing! !
keywords!accessing!public! !
postCopy!copying!public! !
selector!accessing!public! !
setSelector:arguments:!initializing!private! !
!

!Kernel.StAnnotationNode class methodsFor!

selector: aSymbol arguments: anArrayOfStLiteralValueNode
	^self new setSelector: aSymbol arguments: anArrayOfStLiteralValueNode! !

!Kernel.StAnnotationNode class categoriesForMethods!
selector:arguments:!instance creation!public! !
!

