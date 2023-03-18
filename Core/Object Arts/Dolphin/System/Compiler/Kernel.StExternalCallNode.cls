"Filed out from Dolphin Smalltalk"!

Kernel.StTagNode
	subclass: #'Kernel.StExternalCallNode'
	instanceVariableNames: 'nameOrOrdinal returnType argumentTypes flags callingConvention'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'OverlappedMask' -> 16r1. 'VirtualMask' -> 16r2 }!
Kernel.StExternalCallNode guid: (Core.GUID fromString: '{66add179-2714-4fbb-b856-33dee83e11f4}')!
Kernel.StExternalCallNode comment: ''!
!Kernel.StExternalCallNode categoriesForClass!System-Compiler! !
!Kernel.StExternalCallNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	self class == anObject class ifFalse: [^false].
	flags = anObject flags ifFalse: [^false].
	nameOrOrdinal = anObject nameOrOrdinal ifFalse: [^false].
	callingConvention == anObject callingConvention ifFalse: [^false].
	returnType = anObject returnType ifFalse: [^false].
	^argumentTypes = anObject argumentTypes!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitExternalCallNode: self!

argumentTypes
	^argumentTypes!

argumentTypes: aSequenceableCollection
	argumentTypes := aSequenceableCollection.
	aSequenceableCollection do: [:each | each parent: self]!

callingConvention
	^callingConvention!

callingConvention: anInteger 
	callingConvention := anInteger!

childrenDo: aMonadicValuable
	aMonadicValuable value: returnType.
	argumentTypes do: aMonadicValuable!

defines: aName
	^'_failureCode' = aName!

flags
	^flags!

flags: anInteger
	flags := anInteger!

hash
	^((nameOrOrdinal hash + callingConvention) hashMultiply + returnType hash) hashMultiply
		+ (self hashForCollection: argumentTypes)!

initialize
	flags := 0.
	argumentTypes := #().!

isExternalCall
	^true!

isOverlapped
	^flags allMask: OverlappedMask!

isOverlapped: aBoolean
	flags := flags mask: OverlappedMask set: aBoolean!

isVirtual
	^flags allMask: VirtualMask!

isVirtual: aBoolean
	flags := flags mask: VirtualMask set: aBoolean!

nameOrOrdinal
	^nameOrOrdinal!

nameOrOrdinal: anObject
	nameOrOrdinal := anObject!

postCopy
	super postCopy.
	self returnType: returnType copy.
	self argumentTypes: (argumentTypes collect: [:each | each copy]).
	^self!

primitiveIndex
	^self isVirtual ifTrue: [80] ifFalse: [self isOverlapped ifTrue: [48] ifFalse: [96]]!

returnType
	^returnType!

returnType: aStExternalArgTypeNode
	returnType := aStExternalArgTypeNode.
	aStExternalArgTypeNode parent: self!

selector
	^FunctionDescriptor nameOfConvention: callingConvention! !
!Kernel.StExternalCallNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
argumentTypes!accessing!public! !
argumentTypes:!accessing!public! !
callingConvention!accessing!public! !
callingConvention:!accessing!public! !
childrenDo:!accessing!public! !
defines:!public!testing! !
flags!accessing!private! !
flags:!initializing!private! !
hash!comparing!public! !
initialize!initializing!public! !
isExternalCall!public!testing! !
isOverlapped!public!testing! !
isOverlapped:!accessing!public! !
isVirtual!public!testing! !
isVirtual:!accessing!public! !
nameOrOrdinal!accessing!public! !
nameOrOrdinal:!accessing!public! !
postCopy!copying!public! !
primitiveIndex!accessing!public! !
returnType!accessing!public! !
returnType:!accessing!public! !
selector!accessing!public! !
!

!Kernel.StExternalCallNode class methodsFor!

new
	^super new initialize! !
!Kernel.StExternalCallNode class categoriesForMethods!
new!instance creation!public! !
!

