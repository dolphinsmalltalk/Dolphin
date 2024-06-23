"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.ProcessCopier'
	instanceVariableNames: 'source delta copied clone'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.ProcessCopier guid: (Core.GUID fromString: '{8645a83f-7f36-4167-b325-234f811a2264}')!

Kernel.ProcessCopier comment: '<ProcessCopier> is responsible for copying the stack of a <Process> in such a way that the copy is an independent runnable process that can be continued from the point at which the source <Process> was when the copy was taken, but which shares no temporary variables (or other execution state) with the source process. This is required to implement <Continuation>s in Dolphin, but may have other uses.

Copying a <Process> in Dolphin involves the following steps:
1) Creating a shallow copy of the source Process, the stack being the indexable part of the Process object.
2) Patching the suspended activation records in the stack to fix up the internal pointers (i.e. the stack pointers, base pointers, and sender frame address).
3) Dropping frames/stack slots down to the top-most desired frame.
4) Walking the stack to find objects that need to be copied (e.g. BlockClosures, MethodContexts) and replacing all references to these.
5) Walking the exception handler stack to create independent copies of these (in practice this is actually accomplished during step (4))

The "deepening" of the stack copy involves the co-operation of the objects in the stack. Each object is sent a #acceptProcessCopier: message, the default implementation of which does nothing. Objects that need to be copied (basically anything that stores per-process execution state) are expected to send back a #copyObject: message to the <ProcessCopier> with itself as the argument. The <ProcessCopier> will then answer an existing copy of the object, or if not copied before it shallow copies that object and sends the copy a #deepenProcessCopy: message with itself as the argument. The copy must then take what further action is required to make itself independent of its source, usually this is done by sending #visit: messages to the <ProcessCopier> with the relevant instance variables as arguments, assigning the return values back into those instance variables. ProcessCopier>>visit: in turn sends #acceptProcessCopier: messages back to instance variable objects, so the Process copy can be recursively deepened as necessary.

Any object which captures blocks in instance variables may need to override #acceptProcessCopier: and #deepenProcessCopy: in order that <ProcessCopier> can create an independent process copy. For an example of how to do this see <ExceptionHandlerAbstract>.

The resulting <Process> copy will be suspended at the requested frame, but expecting a return value to that frame. Although the copy can be directly #resume''d, the results may be incorrect, depending on whether the process was copied when already suspended on the requested frame. If the process was active, or the requested frame is not the top-most frame, then a return value should be supplied. The copied <Process> should, in that case, be resumed by sending it an appropriately formed interrupt block, for example:

	copyProcess interruptWith: [Process returnValue: nil toFrame: copyProcess basicSuspendedFrame].

Alternatively the copy can be patched up by pushing an appropriate return value onto the stack, and then it can be directly #resume''d. See Process>>copy for an example.'!

!Kernel.ProcessCopier categoriesForClass!System-Continuations! !

!Kernel.ProcessCopier methodsFor!

copyObject: anObject 
	^copied at: anObject
		ifAbsent: 
			[| copy |
			copy := anObject copy.
			copied at: anObject put: copy.
			copy deepenProcessCopy: self.
			copy]!

copyStack: aStackFrame
	self
		createBasicCopyOfStack: aStackFrame;
		initializeCopiedMap;
		patchFrames;
		patchStackSlots;
		patchExceptionHandlers.
	"The clone is now a valid, runnable, process and so should be finalizable"
	clone beFinalizable.
	^clone!

createBasicCopyOfStack: aStackFrame
	source := aStackFrame process.
	clone := source shallowCopy postCopy.
	clone
		suspendedFrame: aStackFrame asInteger;
		resize: aStackFrame sp;
		name: (String writeStream
					nextPutAll: 'Copy of ';
					print: source id;
					nextPut: $:;
					display: source name;
					contents)!

delta
	^delta!

existingCopyOf: anObject
	^copied at: anObject ifAbsent: [anObject]!

hasVisited: anObject
	^copied includesKey: anObject!

initializeCopiedMap
	copied := IdentityDictionary new.
	copied at: source put: clone!

patchExceptionHandlers
	clone exceptionEnvironment: (self visit: source exceptionEnvironment)!

patchFrames
	| copyFrame |
	delta := (clone yourAddress - source yourAddress) // 2.
	copyFrame := clone suspendedFrame.
	[copyFrame isNil] whileFalse: 
			[copyFrame rebase: self.
			copyFrame := copyFrame sender].
	^copied!

patchStackSlots
	1 to: clone size
		do: 
			[:i | 
			| each |
			each := source at: i.
			each isInteger ifFalse: [clone at: i put: (self visit: each)]]!

recordVisitTo: anObject
	self assert: [(self hasVisited: anObject) not].
	^copied at: anObject put: anObject!

visit: anObject
	^anObject acceptProcessCopier: self! !

!Kernel.ProcessCopier categoriesForMethods!
copyObject:!copying!public! !
copyStack:!copying!private! !
createBasicCopyOfStack:!copying!private! !
delta!accessing!public! !
existingCopyOf:!copying!public! !
hasVisited:!private!testing! !
initializeCopiedMap!copying!private! !
patchExceptionHandlers!copying!private! !
patchFrames!copying!private! !
patchStackSlots!copying!private! !
recordVisitTo:!copying!public! !
visit:!copying!public! !
!

!Kernel.ProcessCopier class methodsFor!

copyStack: aStackFrame
	"Answer a <Process> which is a copy of the frames of the process up to and including
	the <StackFrame> argument. The answer will be suspended, but continuable."

	^self new copyStack: aStackFrame! !

!Kernel.ProcessCopier class categoriesForMethods!
copyStack:!operations!public! !
!

