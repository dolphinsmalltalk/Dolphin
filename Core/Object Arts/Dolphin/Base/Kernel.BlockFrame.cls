"Filed out from Dolphin Smalltalk"!

Kernel.StackFrame
	subclass: #'Kernel.BlockFrame'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.BlockFrame guid: (Core.GUID fromString: '{87b4c6e5-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.BlockFrame comment: ''!
!Kernel.BlockFrame categoriesForClass!Kernel-Methods! !
!Kernel.BlockFrame methodsFor!

argumentCount
	"Private - Answer the number of arguments to the receiver's stack frame, this will
	vary depending on whether the receiver is a frame for a block or method activation."
	
	^self block argumentCount!

block
	| context |
	context := self environment.
	^context class == BlockClosure ifTrue: [context] ifFalse: [context block]!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: '[] in '.
	super displayOn: aPuttableStream!

isBlockFrame
	^true!

method: aCompiledMethod
	"Private - Set the method of the stack frame."

	"Implementation Note: Override to update the block's method reference as well.
	We have to be careful here because clean block's are shared objects, so we must
	make a copy of them before updating them."

	| block |
	super method: aCompiledMethod.
	block := self block.
	block isNil ifTrue: [^self].
	block isClean
		ifTrue: 
			["Note that there may be other refs to the block in the stack, but we 
			  don't bother updating these because a clean block is a literal const 
			  and so it doesn't really matter how many copies there are"
			block := block shallowCopy.
			self environment: block].
	block method: aCompiledMethod! !
!Kernel.BlockFrame categoriesForMethods!
argumentCount!accessing!public! !
block!accessing!private! !
displayOn:!printing!public! !
isBlockFrame!private!testing! !
method:!accessing!private! !
!

!Kernel.BlockFrame class methodsFor!

findInitialIP: anInteger inTextMap: aTextMap
	"Private - Answer the index of the text map entry corresponding to the specified <integer> initial block ip."

	| i |
	i := 1.
	"It is an invariant that there is an entry with a key matching the initialIP. If one is not found, a BoundsError will be thrown."
	[anInteger == (aTextMap at: i) key] whileFalse: [i := i + 1].
	^i! !
!Kernel.BlockFrame class categoriesForMethods!
findInitialIP:inTextMap:!helpers!private! !
!

