"Filed out from Dolphin Smalltalk"!

Object subclass: #StackFrame
	instanceVariableNames: 'process index'
	classVariableNames: 'BPOffset EnvOffset FrameSize IPOffset MethodOffset ReturnOffset SPOffset'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StackFrame guid: (GUID fromString: '{87b4c4be-026e-11d3-9fd7-00a0cc3e4a32}')!

StackFrame addClassConstant: 'BPOffset' value: 16r5!
StackFrame addClassConstant: 'EnvOffset' value: 16r1!
StackFrame addClassConstant: 'FrameSize' value: 16r6!
StackFrame addClassConstant: 'IPOffset' value: 16r3!
StackFrame addClassConstant: 'MethodOffset' value: 16r0!
StackFrame addClassConstant: 'ReturnOffset' value: 16r2!
StackFrame addClassConstant: 'SPOffset' value: 16r4!

StackFrame comment: 'StackFrame encapsulates behaviour of an activation record for use by the development tools (especially the debugger) and other reflective activities. A StackFrame is only valid as a snapshot of <Process> state (e.g. when the process is suspended, as it is when being debugged).

Dolphin''s activation records are not objects, in fact they are just range of slots in the Process stack, so this class is employed to stand in and wrap those records.

The layout of a stack frame is:

	Method (CompiledCode subinstance)
	Environment (pointer to environment/context object, or nil if the activation does not require one)
	Calling stack frame address
	Instruction Pointer (offset into methods byte codes)
	Stack Pointer (address in Process stack)
	Base Pointer (address of stack temps, which preceed the stack frame)

An activation''s arguments and receiver preceed the frame, with the arguments being pointed at by the frames BP. The receiver is at BP-1, with arguments at BP+0..BP+n-1, where n is the number of arguments. 

If the activation is for a block then any copied values it contains are pushed onto the stack immediately after the arguments. Subsequently the copied values are accessed using normal push temp instructions (they will never be written too). After the arguments (and copied values, if any), slots are reserved for the stack temporaries required by the method/block. The frame itself follows these - i.e. all stack temps are directly indexable off BP because they are contiguously allocated before the frame. Any stack working space required by the method/block succeeds the frame.

Note that there is no difference between method and block activations (with one special case, see below). Either may have stack based arguments and temps which are always stored on the stack before the frame. Either may define shared temps that require an "environment" object. This will be an instance of Context, which is not a context in the Smalltalk-80 sense, but a rather simpler object that consists of a vector of the shared temps and a pointer to any outer Context. The outer context chain is used to locate shared temps that a nested block may reference from its enclosing scopes. It is also used to locate the home context when a block performs a ^-return.

When a block does not itself require a context to hold shared temps (the common case in fact), the environment slot is initialised with a reference to the block itself. This is useful for the debugger and other reflective facilities in the image, as otherwise it would not be possible to locate the closure associated with the frame. It is also used by the VM when it needs to create a nested block that requires an outer pointer; the outer pointer of the new block is set to be the same as the outer pointer of the enclosing, contextless, block. i.e. the outer pointer of a block may *not* point to the context of its immediately enclosing block, but to the context of some wider scope such as the method.'!

!StackFrame categoriesForClass!Kernel-Methods! !

!StackFrame methodsFor!

= anObject
	"Answer whether the receiver and anObject are considered equivalent.
	Two frames are equal if they are of the same species, are for the same
	Process, and frame pointer."

	^self species == anObject species and: [
		process = anObject process and: [index == anObject index]]
	!

argAt: anInteger
	"Private - Answer the argument indexed, anInteger, from the receiver's stack frame.
	Arguments preceed other temporaries."

	^(anInteger between: 1 and: self argumentCount) 
		ifTrue: [self at: anInteger + self argsOffset]
		ifFalse: [self errorSubscriptBounds: anInteger]!

argsOffset
	^0!

argumentCount
	"Private - Answer the number of arguments to the receivers stack frame, this will 
	vary depending on whether the receiver is a frame for a block or method activation."
	
	^self method argumentCount!

arguments
	"Private - Answer a SequenceableCollection of the receiver's arguments."

	^(1 to: self argumentCount) collect: [:i | self argAt: i]!

asInteger
	"Private - Answer the stack frame index represented by the receiver."

	^index!

at: anInteger
	"Private - Answer the stack temporary indexed, anInteger, from the receivers stack frame."
	
	^(anInteger between: 1 and: self localCount)
		ifTrue: [process at: self bp + anInteger - 1] 
		ifFalse: [self errorSubscriptBounds: anInteger]!

at: anInteger put: anObject
	"Private - Replace the stack temporary indexed, anInteger, in the 
	receiver's stack frame with anObject."
	
	^(anInteger between: 1 and: self localCount)
		ifTrue: [process at: self bp + anInteger - 1 put: anObject] 
		ifFalse: [self errorSubscriptBounds: anInteger]!

basicBP
	"Private - Answer the <SmallInteger> base pointer of the frame. This points
	at the first argument of the activation."

	^process at: index + BPOffset!

basicBP: aSmallInteger 
	"Private - Set the base pointer of the frame. The argument must be a SmallInteger
	pointer (i.e. the address with the bottom bit set) to the first argument associated 
	with the activation. If there are no arguments then it 	will point at the frame itself 
	as the BP is still used to access the receiver, which is in the slot at [BP-1]."

	process at: index + BPOffset put: aSmallInteger!

basicIP
	"Private - Answer the unadjusted SmallInteger IP index from the appropriate stack slot."

	^process at: index + IPOffset!

basicIP: anInteger
	"Private - Set the IP of the process stack frame the receiver represents to anInteger (which
	is a zero-based offset from the start of the byte code object of the method)."

	process at: index + IPOffset put: anInteger!

basicSender
	"Private - Answer the context which caused the activation that the receiver represents"

	^process at: index + ReturnOffset!

basicSender: spInteger
	"Private - Set the sender of the process stack frame the receiver represents
	to spInteger (address/2 of the sender frame in the same process)."

	^process at: index + ReturnOffset put: spInteger!

basicSP
	"Private - Answer the SmallInteger stack pointer from the appropriate stack slot."

	^process at: index + SPOffset!

basicSP: aSmallInteger 
	"Private - Set the SP of the process stack frame the receiver represents
	to spInteger (address/2 of the receivers TOS in the process)."

	process at: index + SPOffset put: aSmallInteger!

bp
	"Private - Answer the index of first temporary of the frame the receiver represents."

	^process indexOfSP: self basicBP!

bp: anInteger 
	"Private - Set the BP of the process stack frame the receiver represents
	to be pointing at the slot with the specified index."

	self basicBP: (process spOfIndex: anInteger)!

callstackDo: aMonadicValuable depth: anInteger
	"Private - Walk the stack starting from this frame, to the maximum depth specificed by the <integer>
	argument (or the entire stack if anInteger < 0), evaluating the <monadicValuable> argument
	for each visited."

	| frame i |
	frame := self.
	i := anInteger.
	[i ~~ 0 and: [frame notNil and: [frame method selector notNil]]] whileTrue: 
			[aMonadicValuable value: frame.
			frame := frame sender.
			i := i - 1]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that a user would want to see."

	"Display processing will fail if this stack frame is dead"

	| method class mClass selector |
	self isDead
		ifTrue: 
			[aPuttableStream nextPutAll: self basicPrintString.
			^self].
	method := self method.
	mClass := method methodClass.
	self receiver
		ifNil: 
			["Assume a block which has no receiver refs"
			aPuttableStream display: mClass]
		ifNotNil: 
			[:receiver |
			class := receiver basicClass.	"Use basic class to avoid deref'ing proxies"
			aPuttableStream nextPutAll: class name.
			mClass == class
				ifFalse: 
					[aPuttableStream
						nextPut: $(;
						display: mClass name;
						nextPut: $)]].
	aPuttableStream nextPutAll: '>>'.
	selector := method selector.
	method isUnbound
		ifTrue: 
			["Method is unbound if it is either not in the class' method dictionary, or it doesn't have the same
			source as that currently in the dictionary"
			aPuttableStream nextPutAll: '{unbound}'].
	aPuttableStream nextPutAll: selector!

environment
	"Private - Answer the environment associated with the stack frame, if any.
	This may be nil, a <Context> or a <BlockClosure>."

	| env |
	env := process at: index + EnvOffset.
	^env == 0 ifFalse: [env]!

environment: anObject 
	process at: index + EnvOffset put: anObject!

frameAddress
	^process spOfIndex: index!

frameSize
	"Private - Answer the size of a real stack frame (in Oops)."

	^FrameSize!

getFrames: anInteger
	"Return the stack of frames starting from this one and back in sequence through
	the callers to the maximum depth specificed by the <integer> argument (or the entire stack
	if anInteger < 0)."

	| answer |
	answer := Array writeStream: (anInteger < 0 ifTrue: [40] ifFalse: [anInteger]).
	self callstackDo: [:frame | answer nextPut: frame] depth: anInteger.
	^answer grabContents!

getOuter: anInteger 
	| answer |
	answer := self.
	anInteger timesRepeat: 
			[| outer |
			outer := answer outer.
			#todo.	"This is necessary because the Compiler seems to return the wrong outer depth in the temps map in some cases."
			outer isInteger ifTrue: [^answer].
			answer := outer].
	^answer!

hash
	"Answer the SmallInteger hash value for the receiver.

	Implemented here because equivalent objects (i.e. those that answer 
	true for #=) MUST answer the same hash value, and we override #=."

	^process hash bitXor: index hash!

homeContext
	^self environment ifNotNil: [:env | env home]!

homeFrame
	"Private - Answer a StackFrame to represent the receiver's home, or nil if it has returned."

	| env |
	env := process at: index + EnvOffset.
	^env == 0 
		ifTrue: 
			["Normal method frame without a context"

			self]
		ifFalse: 
			[
			"Context frame, may be block or method"
			env home ifNotNil: 
					[:homeContext | 
					| frame |
					frame := homeContext outer.
					frame == 0 ifFalse: [process frameAtAddress: frame]]]!

index
	"Private - Answer the receiver's frame index."

	^index!

index: anInteger
	"Private - Set the index of the receiver's actual frame in its process' stack to
	be anInteger. Answer the receiver."

	index := anInteger!

ip
	"Private - Answer the instruction pointer index into the bytes of the home method, 
	saved down when the context was last suspended."

	| ip |
	ip := self basicIP.
	^self method isPacked 
		ifTrue: [ip + 1]
		ifFalse: [ip - self ipBias]
!

ip: anInteger
	"Private - Set the IP of the process stack frame the receiver represents to
	anInteger (which is an index into the byte codes of the method)."

	self basicIP: (self method isPacked ifTrue: [anInteger - 1] ifFalse: [anInteger + self ipBias])!

ipBias
	"Private - Answer the bias of an IP index to the true IP offset in
	an compiled code object."

	^MemoryManager current objectHeaderSize - 1!

isBlockFrame
	^false!

isDead
	"Private - Answer whether this is a dead stack frame (i.e. one which has returned).
	Note that this is only an indication."

	^self index + BPOffset > process size!

isRestartable
	"Private - Answer whether this frame is restartable. Some methods, such as
	callback entry points, cannot be restarted at all, others not reliably."

	^self sender notNil and: 
			[| method |
			method := self method.
			method notNil
				and: [method isExpression or: [('not restartable' asMethodCategory includesMethod: method) not]]]!

localAt: anInteger
	"Private - Answer the argument indexed, anInteger, from the receiver's stack frame."

	^self at: anInteger + self argumentCount!

localCount
	"Private - Answer the number of locals variables (stack temporaries and arguments) in the receiver's
	stack frame."
	
	^index - self bp!

method
	"Private - Answer a compiled code object for which the receiver represents a stack frame."

	^process at: index + MethodOffset!

method: aCompiledMethod
	"Private - Set the method of the stack frame."

	process at: index + MethodOffset put: aCompiledMethod!

outer
	^self environment!

prevIP
	^self method byteCodeDispatcher prevIP: self ip!

printOn: aStream
	self displayOn: aStream.
	aStream
		nextPutAll: ' @ ';
		print: index!

printStackOn: aPuttableStream depth: anInteger
	self callstackDo: 
			[:frame |
			aPuttableStream
				display: frame;
				cr]
		depth: anInteger!

process
	"Private - Answer the process for which the receiver is representing a stack frame"
	
	^process!

process: aProcess
	"Private - Set the Process in whose stack the receiver's frame resides"

	process := aProcess!

receiver
	"Private - Answer the 'self' of the context. This is at BP-1."

	^process at: self bp - 1!

return: anObject
	"Return anObject from the receiver to its caller."

	| sender |
	sender := self basicSender.
	(sender isNil or: [sender == 0]) ifTrue: [^Processor cannotReturn: anObject].
	Processor returnValue: anObject toFrame: (process indexOfSP: sender)!

sender
	"Private - Answer the invoking/calling/sending StackFrame."

	| sender |
	sender := self basicSender.
	^sender == 0
		ifFalse: [process frameAtAddress: sender]!

sender: aStackFrameOrIndex
	"Private - Set the sender of the process stack frame the receiver represents
	to aStackFrameOrIndex."

	self basicSender: (process spOfIndex: aStackFrameOrIndex asInteger)!

setProcess: aProcess index: anInteger
	"Private - Set the Process in whose stack the receiver's frame resides
	and the index of the frame in that stack."

	process := aProcess.
	index := anInteger!

sp
	"Private - Answer the index into the process stack which is the TOS for the receivers
	corresponding activation record"

	^process indexOfSP: self basicSP!

sp: anIntegerIndex
	"Private - Set the SP of the process stack frame the receiver represents
	to the slot at the specified index."

	self basicSP: (process spOfIndex: anIntegerIndex)!

stackTrace: anInteger
	| stackStream |
	stackStream := String writeStream: 25 * ((anInteger max: 0) min: 20).
	[self printStackOn: stackStream depth: anInteger] on: Error do: [:e | e notify].
	^stackStream contents!

temp: depthInteger at: indexInteger 
	"Private - Answer the stack temporary indexed, anInteger, from the receivers stack frame."

	| env |
	env := self getOuter: depthInteger.
	^env at: indexInteger!

tempNames
	"Private - Answer a list of temporaries in-scope for the instruction before the 
	receiver's ip. This may include 'unnamed' temporaries which are not in scope,
	but which are placeholders for temporaries reserved for previous blocks."

	^self temps collect: [:each | each first]!

temps
	^self tempsBeforeIp: self ip!

tempsBeforeIp: anInteger
	"Private - Answer a list of temporaries for the instruction before the specified ip."

	^anInteger isNil ifTrue: [{}] ifFalse: [self method debugInfo tempsAtIp: anInteger - 1]!

textMap
	"Private - Answer the map between source text and ip values for the receiver's method."

	^self method textMap! !

!StackFrame categoriesForMethods!
=!comparing!public! !
argAt:!accessing!private! !
argsOffset!accessing!private! !
argumentCount!accessing!private! !
arguments!accessing!private! !
asInteger!accessing!private! !
at:!accessing!private! !
at:put:!accessing!private! !
basicBP!accessing!private! !
basicBP:!accessing!private! !
basicIP!accessing!private! !
basicIP:!accessing!private! !
basicSender!accessing!private! !
basicSender:!accessing!private! !
basicSP!accessing!private! !
basicSP:!accessing!private! !
bp!accessing!private! !
bp:!accessing!private! !
callstackDo:depth:!private! !
displayOn:!printing!public! !
environment!accessing!private! !
environment:!accessing!private! !
frameAddress!accessing!private! !
frameSize!constants!private! !
getFrames:!public! !
getOuter:!accessing!private! !
hash!comparing!public! !
homeContext!accessing!private! !
homeFrame!accessing!private! !
index!accessing!private! !
index:!accessing!private! !
ip!accessing!private! !
ip:!accessing!private! !
ipBias!constants!private! !
isBlockFrame!private!testing! !
isDead!printing!private! !
isRestartable!development!private!testing! !
localAt:!accessing!private! !
localCount!accessing!private! !
method!accessing!private! !
method:!accessing!private! !
outer!accessing!private! !
prevIP!accessing!private! !
printOn:!public! !
printStackOn:depth:!public! !
process!accessing!private! !
process:!accessing!private! !
receiver!accessing!private! !
return:!operations!public! !
sender!accessing!private! !
sender:!accessing!private! !
setProcess:index:!initializing!private! !
sp!accessing!private! !
sp:!accessing!private! !
stackTrace:!printing!private! !
temp:at:!accessing!private! !
tempNames!accessing!development!private! !
temps!accessing!development!private! !
tempsBeforeIp:!accessing!development!private! !
textMap!accessing!development!private! !
!

!StackFrame class methodsFor!

findIP: anInteger inTextMap: aTextMap
	"Private - Answer the index of the source map entry corresponding to the
    	specified <integer> ip. The key of each text map entry identifies the first IP of the code generated for the range
	of source which is held as the <interval> value."

	| i size |
	i := 1.
	size := aTextMap size.
	[i < size and: [anInteger > (aTextMap at: i) key]] whileTrue: [i := i + 1].
	^i!

frameClassFor: aProcess at: anInteger
	"Private - Answer the subclass of the receiver to use to represent a stack frame in aProcess
	at the specified index. Answer nil if the index is out of bounds."

	| env sp |
	sp := anInteger + EnvOffset.
	env := (sp > 0 and: [sp <= aProcess size]) ifTrue: [aProcess at: sp] ifFalse: [^nil].
	^(env isInteger or: [env isNil]) ifTrue: [self] ifFalse: [env frameClass]!

onProcess: aProcess index: anInteger
	<primitive: 157>
	^(self basicNew)
		setProcess: aProcess index: anInteger;
		yourself!

process: aProcess index: anInteger
	"Private - Answer a new instance of the receiver representing the stack frame in aProcess
	at the specified index in aProcess, or nil if the specified index is out of bounds in the process."

	^(self frameClassFor: aProcess at: anInteger)
		ifNotNil: [:frameClass | frameClass onProcess: aProcess index: anInteger]! !

!StackFrame class categoriesForMethods!
findIP:inTextMap:!helpers!private! !
frameClassFor:at:!instance creation!private! !
onProcess:index:!instance creation!private! !
process:index:!instance creation!public! !
!

