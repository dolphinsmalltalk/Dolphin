"Filed out from Dolphin Smalltalk 7"!

StackFrame subclass: #BlockFrame
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BlockFrame guid: (GUID fromString: '{87b4c6e5-026e-11d3-9fd7-00a0cc3e4a32}')!
BlockFrame comment: ''!
!BlockFrame categoriesForClass!Kernel-Methods! !
!BlockFrame methodsFor!

argumentCount
	"Private - Answer the number of arguments to the receivers stack frame, this will 
	vary depending on whether the receiver is a frame for a block or method activation."
	
	^self block argumentCount!

block
	| context |
	context := self environment.
	^context class == BlockClosure ifTrue: [context] ifFalse: [context block]!

displayOn: aStream
	"Append a short textual description of the receiver to aStream appropriate
	for displaying in a stack trace."

	aStream nextPutAll: '[] in '.
	super displayOn: aStream!

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
!BlockFrame categoriesFor: #argumentCount!accessing!public! !
!BlockFrame categoriesFor: #block!accessing!private! !
!BlockFrame categoriesFor: #displayOn:!printing!public! !
!BlockFrame categoriesFor: #isBlockFrame!private!testing! !
!BlockFrame categoriesFor: #method:!accessing!private! !

