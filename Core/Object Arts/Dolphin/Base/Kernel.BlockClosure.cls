"Filed out from Dolphin Smalltalk"!

Core.Object
	variableSubclass: #'Kernel.BlockClosure'
	instanceVariableNames: 'outer method initialIP info receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.BlockClosure guid: (Core.GUID fromString: '{9f8fdcd4-036d-4d00-b781-623ce474a835}')!
Kernel.BlockClosure comment: 'BlockClosure is the class of objects that represent "blocks" in Smalltalk. Blocks encapsulate a sequence of statements to be performed at a later time. Blocks may capture (or "close over") runtime state, such as the values of temporary variables, from the enclosing lexical scope at the point where they are created. When evaluated a block executes as if in the lexical scope in which it was defined, except that blocks may have arguments that are bound at the time of evaluation. Blocks may be passed as arguments with messages to other objects and evaluated by those objects when appropriate, and thus form a very powerful and generic "pluggability" mechanism that is a core feature which provides much of the power of Smalltalk. 

BlockClosures in Dolphin 6.0 and later are substantially revised from in earlier versions of Dolphin. Dolphin 6.0 now supports true lexical closures, and implements all advanced optimizations. Block arguments now always reside on the stack, and their lifetime is limited to the duration of the activation of the block. This means that blocks can be used recursively, and even shared between processes (e.g. a sort block can now safely be shared). It also means that blocks no longer retain a reference to their last arguments, and so previous problems with blocks in (for example) MVP views keeping object trees from being garbage collected are no longer an issue. Furthermore block activation is now exactly the same as method activation, and can be no more expensive.

Blocks are now categorized into five basic types:
	1) Inlined
	2) Clean
	3) Copying
	4) Hybrid
	5) Full

Inlined blocks are those literal blocks which the compiler "optimizes" away by replacing them with an equivalent set of instructions that execute directly in the context of the enclosing  scope. BlockClosure instances are never created for inlined blocks. The most common type of inlined blocks are the operands of the #ifTrue:ifFalse: family of messages, but the literal block arguments and/or receivers of a number of other messages are also inlined. The complete set of inlined messages at the time of writing is as follows:
	#and:
	#or:
	#ifTrue:[ifFalse:]
	#ifFalse:[ifTrue:]
	#ifNil:[ifNotNil:]
	#ifNotNil:[#ifNil:]
	#repeat
	#timesRepeat:
	#to:[by:]do:
	#whileTrue[:]
	#whileFalse[:]

The receiver/operands to these, if literal blocks, are usually inlined. Though in the case of #timesRepeat: and #to:by:do:, the compiler may not inline the messages if the receiver/operands are not literals meeting certain criteria. Where this is the case the compiler emits a warning that it is not able to optimize the message. One can also suppress all the inlined forms by first assigning the literal block to a temporary, and then referencing that as the operand. For example:
	i := 0.
	b := [i <= 10].
	b whileTrue: [i := i + 1]. i

The categorization of the other types of blocks is dependent upon the references they make to variables. In order to understand the differences between the other types of blocks, it is necessary to first understand the different types of variables that the Dolphin compiler now distinguishes.

	1) Static variables.
	2) Arguments.
	3) Stack Temps.
	4) Copied Values. 
	5) Shared (aka Environment) Temps

Static variables, are variables such as globals, class variables, and pool variables. A block''s references to these has no bearing on its status.

Arguments are temporary variables held on the stack which are read-only [Note that earlier versions of Dolphin permitted assignment to block arguments, but this will now cause a compilation error]. The arguments to a method or block are pushed on the stack, and remain there, in the same locations, until the method or block returns.

Stack temporaries are local temporary variables that are referenced only in the declaring scope. These are allocated as stack slots, and their lifetime is thus limited to the duration of the method or block activation.

Copied values are block temporaries whose value can be copied from an enclosing scope. They can be regarded as additional implicit arguments to a block that are bound at block creation time by copying them into the indexed slots of the block object itself from the enclosing scope. On block activation any copied values are pushed back on the stack, and subsequently the block''s code accesses them using the same instructions as for its arguments and other stack temporaries. In order for a variable to be copyable it must not be assigned to after the point at which the block is created, as otherwise scopes which may reference that variable would not see the same value. This implies that all copied values are, like arguments, read-only temporaries from the point of view of the block which has copied them. The receiver is a special case of copied value, because it is not legal in Smalltalk to assign to ''self''.

Shared temporaries are those which are referenced from scopes other than that in which they are declared, and which are either written to by an enclosed scope, or written to by the declaring scope after a block has been created which references the variable. Any variable which is shared in this way must be allocated a slot which is visible to, and shared between, all the referencing scopes.

Clean blocks are limited to those which do not perform any non-local returns (^-returns), and which refer only to their arguments, locally declared temporaries which are not shared with any nested blocks, or static variables such as globals and pool variables. Blocks which refer to any other variables in the enclosing scope, including the receiver (i.e. ''self''), cannot be treated as clean. Essentially a clean block does not "close over" any state at the time it is created, and hence they can be created at compile time rather than at run time. Clean blocks are the most efficient form  because they do not require any objects to be created when they are referenced or activated, making their activation cost essentially the same as a normal method. The default sort block used by SortedCollection is an example of a clean block.
	
The empty block, [], is a special case of clean block which is folded to a single instance by the compiler to save space. 

Copying blocks are those which may also reference variables, including the receiver, in the lexically enclosing scope, where those variables are not written to after the block has been created. Any block which references the receiver, or arguments of an enclosing scope is automatically at least a copying block. Copying blocks require that the BlockClosure object be created at run-time, since the correct values to copy are not available until that point. If a copying block references the receiver current at the time it was created, or any instance variables, then the blocks receiver instance variable will be set to that receiver (i.e. the receiver will also have been copied). If the receiver is not needed, then it is not copied in order to avoid creating an unecessary reference. Here are a couple of simple examples of the use of copying blocks: 

	blocks := 1 to: 10 collect: [:i | [i]].	"Note that the captured value of ''i'' in each block will be different"
	blocks inject: 0 into: [:sum :each | sum + each value].

	| factorial | 
	factorial := [:x | x < 2 ifTrue: [1] ifFalse: [(factorial value: x - 1) * x].
	factorial value: 6.

Copying blocks are still a relatively efficient form in that they do not require the allocation of additional heap objects when either their enclosing method or when they themselves are activated. However in order to copy the values from enclosing scopes when the block is created, the compiler must emit additional instructions to push the copied values onto the stack, and there is then the very small overhead of the VM copying the values into the block. At activation time the overhead is the very small overhead of the VM pushing the copied values back onto the stack. The overhead of copying ''self'' is negligible as it does not need to be pushed onto the stack on block creation or activation.

We have mentioned that whether or not a block contains a ^-return has a bearing on its category. Since ^ returns from the lexically enclosing scope, not the block or its caller, its implementation requires a mechanism to locate the return destination, and which allows us to detect the error of attempting to ^-return from a method activation which has itself already returned. For example:

	block := [^1].
	block value.

If we evaluate this as a single expression, it is valid, but if we evaluate it as two separate expressions then the second will give an error since the first (in which the block was captured) has already returned.

In order to implement non-local returns we make use of the ''outer'' pointers in the BlockClosures themselves, and in <Contexts>. A Context in Dolphin is not the same object as a Context in the Smalltalk-80 sense, in that is not the reified representation of a method or block activation, but rather it is little more than a vector to hold shared temps, and to chain out to Contexts associated with enclosing scopes should that be needed. Any block with a ^-return must have a non-nil ''outer'' which refers to a Context object. That Context object, if it is not the Context for a method, may itself refer to a further outer Context through its own ''outer'' instance variable. 

A hybrid type of block between copying and full block status is the otherwise clean or copying block which either incorporates a ^-return, or which references shared temporaries from outer scopes, but which does not itself define any shared temporaries. Such a block will still have an outer pointer (and so may force its enclosing method to require a Context be allocated when it is activated), but will not itself have a Context. In this case the ''outer'' pointer of the block will point to the Context of the nearest enclosing scope with shared temporaries, or the method Context if none of the enclosing scopes has any shared temporaries. Note that any method containing a ^-return in any of the non-inlined blocks that it contains will always have a Context allocated when it is activated, regardless of whether it declares and shared temporaries.

Full blocks are those that require a context to hold temporaries they define that are shared with nested blocks. Full blocks are the most inefficient form because they require the creation of a heap object when the block itself is created, and (more importantly), a Context object every time the block is activated. Obviously this can be a significant cost in a loop. However, if one is careful in ones coding, and in particular if one uses small methods that define temporaries at the innermost possible scope, then full blocks are very rarely needed. For example, consider these statistics from a sample image:

	Total Methods: 		34390 
	Methods needing Context:	665	(either define shared temps, or blocks with ^-returns)
	Methods with Shared Temps: 	340 	(implying (665-340) = 325 contexts required just for ^-returns)
	Static Blocks:		1812	(clean blocks, created at compile time and stored in methods'' literal frames)
	Dynamic Blocks:		5001	(created at runtime, and may need Context: copying, hybrid, or full)
	Copying Blocks:		3895	(pure copying, no ^-return or access to any shared temps, so no Context needed for block or method)
	Hybrid Blocks: 		1075	(reference outer context for ^-return, or outer shared temps, requires that method have a Context)
	Full Blocks:			31		(as above, plus defines own shared temps, both method and block require a Context when activated)

As you can see Full Blocks are very rare indeed. Hybrid blocks are much more common, and these cause their own outer scope(s) to require a context due to a ^-return, or by assigning to an outer temporary.

Instance Variables:
	outer		<Context>|nil
	method		<CompiledCode>
	initialIP		<SmallInteger>
	info			<SmallInteger>
	receiver		<Object> that was ''self'' when the block was created, or nil if the block does not reference ''self'' or any instance variables.

The indexable fields of a BlockClosure are used to hold any copied values.

Info word usage:

	Bits:	Use:
	0		SmallInteger flag (not visible in Smalltalk)
	1..7		Unused
	8..15	argument count
	16..23	stack temp count
	24..31	env temp count (Context size, 0 if no Context needed).
'!
!Kernel.BlockClosure categoriesForClass!Kernel-Methods! !
!Kernel.BlockClosure methodsFor!

= aBlockClosure
	^aBlockClosure class == self class and: 
			[method = aBlockClosure method and: 
					[initialIP = aBlockClosure initialIP and: 
							[outer = aBlockClosure outer and: 
									[self size = aBlockClosure size
										and: [(1 to: self size) allSatisfy: [:i | (self at: i) = (aBlockClosure at: i)]]]]]]!

argumentCount
	"Answer the <integer> number of arguments expected by the receiver."

	^(info bitShift: -7) bitAnd: 16rFF!

argumentCount: anInteger
	info := (info bitAnd: ##((16rFF bitShift: 7) bitInvert))
				bitOr: ((anInteger bitAnd: 16rFF) bitShift: 7)!

atPriority: anInteger
	"Evaluate the receiver at the specified priority. On completion or curtailment the active process' 
	priority is returned to its previous value."

	| activePriority proc |
	proc := Processor activeProcess.
	activePriority := proc priority: anInteger.
	^self ensure: [proc priority: activePriority]!

copiedValues
	"Private - Answer an array of the copiedValues in the receiver."

	| count |
	count := self size.
	^self
		replaceElementsOf: (Array new: count)
		from: 1
		to: count
		startingAt: 1!

critical
	"Private - Evaluate the receiver as a Critical Section with asynchronous process switching disabled.
	When asynchronous process switching is disabled, process pre-emption cannot occur because
	all interrupts and asynchronous Semaphore signals remain pending. If synchronous process
	synchronisation primitives are attempted (e.g. sending #signal or #wait to a Semaphore)
	then asynchronous process switching is automatically re-enabled, and any pending interrupts/
	asynchronous signals will get delivered."

	"Use this VERY sparingly, and for very short durations, as this is a very broadbrush (though
	very high performance) approach to process synchronisation. It is an easy and high performance
	way to protect, for example, a shared data structure from being accessed by other processes
	while it is being modified, but it will prevent any other processes from executing unrelated
	code too. Also, it may not be available in a future multi-threaded VM.
	Synchronisation of access to shared data structures is best done by including a 
	mutual exclusion Semaphore or Mutex with the data structure (i.e. in the Object which manages the 
	data structure), and then using the #critical: method as here. 
	
	See the SharedQueue class for an example of the use of mutual exlusion semaphores, or SharedSet for
	and example of the use of a Mutex to guarantee mutually exclusive access."

	"Implementation Note: We must use an #ensure: block to guarantee re-enabling of aysnc events, 
	because the receiver may perform a ^-return (should an exception occur then they will be 
	re-enabled anyway). This does mean it may be quicker to send #enableAsyncEvents: directly
	in some circumstances."

	| oldState |
	oldState := Processor enableAsyncEvents: false.
	[self value] ensure: [Processor enableAsyncEvents: oldState]!

cull: arg1
	<primitive: 81>
	^self argumentCount == 0 ifTrue: [self value] ifFalse: [self value: arg1]!

cull: arg1 cull: arg2
	<primitive: 81>
	^self argumentCount < 2 ifTrue: [self cull: arg1] ifFalse: [self value: arg1 value: arg2]!

cull: arg1 cull: arg2 cull: arg3 
	<primitive: 81>
	^self argumentCount < 3 
		ifTrue: [self cull: arg1 cull: arg2]
		ifFalse: 
			[self 
				value: arg1
				value: arg2
				value: arg3]!

cull: arg1 cull: arg2 cull: arg3 cull: arg4 
	<primitive: 81>
	^self argumentCount < 4 
		ifTrue: 
			[self 
				cull: arg1
				cull: arg2
				cull: arg3]
		ifFalse: 
			[self 
				value: arg1
				value: arg2
				value: arg3
				value: arg4]!

deferredValue
	"Answer a <niladicValuable> that begins evaluating the receiver asynchronously,
	and which when evaluated will synchronously supply the result."

	^self deferredValueAt: Processor activePriority!

deferredValueAt: priority
	"Answer a <niladicValuable> that begins evaluating the receiver asynchronously
	at the specified <Process> priority, and which when evaluated will synchronously 
	supply the result."

	^DeferredValue evaluate: self at: priority!

ensure: terminationBlock
	"Evaluate the receiver, and regardless of the means by which it exits, 
	be it by normal or non-local (^) return, or by raising an exception, evaluate
	the <niladicBlock> argument, terminationBlock.
	Answers the result of evaluating the receiver, unless <terminationBlock>
	contains a non-local return, in which case the result of <terminationBlock> will be
	answered to its home contexts sender, e.g.:

		[^1. 2] ensure: [Sound bell. 3]		answers 1, but also woofs
		[^1. 2] ensure: [Sound bell. ^3]	woofs and answers 3.
		[1. 2] ensure: [Sound bell. ^3]	ditto
		[1. 2] ensure: [Sound bell. 3]	woofs and answers 2

	See also #ifCurtailed:"

	| answer |
	answer := self ifCurtailed: terminationBlock.
	terminationBlock value.
	^answer!

envTempCount
	"Private - Answer the <integer> number of environment (shared) temps required
	by the receiver. If this value is greater than zero, then this is a full block, and requires
	that a heap-based environment be allocated each time it is activated. The heap-based
	environment will hold all the shared temps declared in the block, and also a link
	to any outer environments from which shared outer temps are accessed."

	^(info bitShift: -23) bitAnd: 16rFF!

envTempCount: anInteger
	info := (info bitAnd: ##((16rFF bitShift: 23) bitInvert)) 
				bitOr: ((anInteger bitAnd: 16rFF) bitShift: 23)!

fork
	"Create and schedule a new Process at the same priority as the current active process.
	The new Process will be placed on the end of the queue of processes of the same priority in 
	the Ready state (i.e. the current active process continues to run). Answer the new Process.
	The new Process will run when it gets its turn (i.e. when there are no higher
	priority processes in the Ready state, and the receiver is at the front of the
	queue of Ready Processes at its priority)."

	^self forkMaxStack: nil!

forkAt: anInteger
	"Evaluate the receiver in a new process at the priority specified by the argument, anInteger. 
	If the new process is of a higher priority than the current active process then it will
	start running immediately. If of a lower priority, then it must wait until there are no
	higher priority processes Ready to run. If of the same priority, then it does not preempt
	the current active process. N.B. Do not rely on the latter behaviour, as it may change in
	a future release. Answer the new process."

	^self forkAt: anInteger maxStack: nil!

forkAt: priorityInteger maxStack: slotsInteger
	"Evaluate the receiver in a new process at the priority specified by the argument,
	priorityInteger, reserving a maximum stack size of slotsInteger slots (i.e. spaces to hold
	references to objects, not the number of bytes). Answer the new Process."

	^(self newProcess: slotsInteger)
		priority: priorityInteger;
		resume!

forkMaxStack: slotsInteger
	"Create and schedule a new Process at the same priority as the current active process.
	The new Process will be placed on the end of the queue of processes of the same priority in 
	the Ready state (i.e. the current active process continues to run). Answer the new Process.
	The new Process will run when it gets its turn (i.e. when there are no higher
	priority processes in the Ready state, and the receiver is at the front of the
	queue of Ready Processes at its priority)."

	^(self newProcess: slotsInteger) resume!

frameClass
	"Private - Answer the class of <StackFrame> to represent activations of the
	receiver."

	^BlockFrame!

home
	"Private - Answer the home context of the context. In the case of a BlockClosure,
	this is the <Context> active for the method which created the block. 
	N.B. The home context (which is always a Context) may have already returned, and 
	only exists in order to provide a 'home'. A BlockClosure uses its home purely execute
	non-local returns. If the block does not contain any non-local returns, then the home
	may be nil."

	^outer isNil ifFalse: [outer home]!

ifCurtailed: terminationBlock
	"Evaluate the receiver, and should it exit via a non-local (^) return, or by raising an 
	exception, evaluate the <niladicBlock>, terminationBlock.
	Answers the result of evaluating the receiver, unless curtailed and the terminationBlock 
	contains a non-local return of its own, in which case the result of that block 
	will be answered to its home context's sender, e.g.:

		[^1] ifCurtailed: [Sound beep]			answers 1, but also woofs
		[^1] ifCurtailed: [Sound beep. ^2]		woofs and answers 2.
		[1] ifCurtailed: [Sound beep. ^2]		answers 1

	Be warned: The system may become unstable if this method is modified. The receiver is
	not the original receiver of the message after #valueOnUnwind: has been sent, but is
	valid inside the unwind block. In addition, #valueOnUnwind: leaves additional objects
	on the stack.

	See also #ensure:"

	^self valueOnUnwind: [:retValue :retFrame |
		terminationBlock value.
		Processor returnValue: retValue toFrame: retFrame]!

info
	^info!

info: aSmallInteger 
	info := aSmallInteger!

initialIP
	"Answer the initial instruction pointer index into the home method, used when the block
	receives a #value* message. Note that this is 1-based."

	^initialIP!

initialIP: anInteger 
	"Private - Set the initial instruction pointer index into the receiver's compiled byte codes
	(used when the block receives a #value* message), to the 1-based <integer> index argument."

	initialIP := anInteger!

isClean
	"Answer whether the receiver is a clean block, i.e. a block that refers only to its arguments, and which does
	not contain any ^-returns. This makes it a shareable object."

	^receiver isNil and: [outer isNil and: [self size = 0 and: [self envTempCount = 0]]]!

localCount
	"Private - Answer the <integer> number of stack temps (including any arguments and
	copied values) used by the receiver. This number of stack slots is used every 
	time the receiver is activated, in addition to the fixed slots for the stack frame."

	^self argumentCount + self stackTempCount + self size!

method
	"Private - Answer the home method for which the context represents execution state"

	^method!

method: aCompiledMethod
	"Private - Set the home method for which the context represents execution state."

	method := aCompiledMethod!

newProcess
	"Answer a new, suspended, <Process> which will evaluate the receiver, and terminate when and
	if the code in the receiver returns. The default 'name' given to the process is the home
	method. The process will have the default initial and maximum stack sizes."

	^self newProcess: nil!

newProcess: anIntegerOrNil
	"Answer a new, suspended, <Process> which will evaluate the receiver, and terminate 
	when and if the code in the receiver returns. The default 'name' given to the process 
	is the home method - this is useful for debugging because it allows one to locate the source 
	(e.g. Process name getSource) to determine what the process is doing. The integer argument
	specifies the maximum stack size in bytes. If nil, then the default maximum stack size is used."

	^(Process
		forContext: 
			[self on: ProcessTermination do: [:e | e return].
			"^-return catches attempt to drop off bottom of process stack (which would cause a GPF)"
			^Processor activeProcess shutdown]
		priority: Processor activePriority
		maxStack: anIntegerOrNil)
		name: self method;
		yourself!

newProcessWithArguments: anArray
	"Answer a new process which will evaluate the receiver with arguments
	from anArray, then terminate"

	^[self valueWithArguments: anArray] newProcess: nil!

numArgs
	^self argumentCount!

on: selector do: action
	"Try to evaluate the receiver, and should an exception occur which is matched
	by the <exceptionSelector>, selector, normally a class object which is a subclass 
	of Exception), evaluate the <monadicBlock>, action, passing it the exception 
	instance as its argument."

	^(ExceptionHandler on: selector do: action) try: self!

on: selector1 do: action1 on: selector2 do: action2
	"Try to evaluate the receiver, and should an exception occur which is matched by any of the
	<exceptionSelector>s, selector1..selector2, then evaluate the corresponding <monadicBlock>,
	actionN, passing it the exception instance as its argument."

	^(ExceptionHandlerSet handlers: {selector1. action1. selector2. action2}) try: self!

on: selector1 do: action1 on: selector2 do: action2 on: selector3 do: action3
	"Try to evaluate the receiver, and should an exception occur which is matched by any of the
	<exceptionSelector>s, selector1..selector3, then evaluate the corresponding <monadicBlock>,
	actionN, passing it the exception instance as its argument."

	^(ExceptionHandlerSet handlers: {selector1. action1. selector2. action2. selector3. action3})
		try: self!

on: selector1 do: action1 on: selector2 do: action2 on: selector3 do: action3 on: selector4 do: action4
	"Try to evaluate the receiver, and should an exception occur which is matched by any of the
	<exceptionSelector>s, selector1..selector4, then evaluate the corresponding <monadicBlock>,
	actionN, passing it the exception instance as its argument."

	^(ExceptionHandlerSet
		handlers: {selector1. action1. selector2. action2. selector3. action3. selector4. action4})
			try: self!

on: selector1 do: action1 on: selector2 do: action2 on: selector3 do: action3 on: selector4 do: action4 on: selector5 do: action5
	"Try to evaluate the receiver, and should an exception occur which is matched by any of the
	<exceptionSelector>s, selector1..selector5, then evaluate the corresponding <monadicBlock>,
	actionN, passing it the exception instance as its argument."

	^(ExceptionHandlerSet handlers: {selector1.
				action1.
				selector2.
				action2.
				selector3.
				action3.
				selector4.
				action4.
				selector5.
				action5})
		try: self!

on: selector1 do: action1 on: selector2 do: action2 on: selector3 do: action3 on: selector4 do: action4 on: selector5 do: action5 on: selector6 do: action6
	"Try to evaluate the receiver, and should an exception occur which is matched by any of the
	<exceptionSelector>s, selector1..selector6, then evaluate the corresponding <monadicBlock>,
	actionN, passing it the exception instance as its argument."

	^(ExceptionHandlerSet handlers: {selector1.
				action1.
				selector2.
				action2.
				selector3.
				action3.
				selector4.
				action4.
				selector5.
				action5.
				selector6.
				action6})
		try: self!

onDo: exceptionHandler
	"Try to evaluate the receiver under the protection of the <ExceptionHandler>
	argument, exceptionHandler."

	^exceptionHandler try: self!

outer
	"Private - Answer the receiver's outer context, which may be nil."

	^outer!

outer: anObject
	"Private - Set the outer context of the receiver to anObject (a Context or nil).
	Answer the receiver."

	outer := anObject!

postToInputQueue
	"Queue the receiver as a deferred action to be evaluated by the main UI process
	when the Windows message queue is empty."

	SessionManager.Current inputState queueDeferredAction: self!

postToMessageQueue
	"Queue the receiver as a deferred action to be evaluated by the main UI process in
	synchronisation with the Windows message queue (this posts a message to the queue so the
	action will be processed after any messages currently in the queue, but before any windows
	messages that may get posted there subsequently. Note the subtle difference from
	#postToInputQueue, which will defer an action until the message queue is empty - i.e. any
	deferred actions are treated as a lower priority than any Windows messages. Also it will
	work even when a modal message loop (such as the menu processing loop) is active."

	SessionManager.Current inputState postAction: self!

printOn: aStream 
	"Append, to aStream, a <String> whose characters are a description of the receiver."

	| m |
	m := self method.
	(m notNil and: [m isExpression]) 
		ifTrue: 
			["We can print the source"
			aStream nextPutAll: m getSource]
		ifFalse: 
			["We can just show where the source is"
			aStream
				nextPutAll: '[] in ';
				print: m]!

receiver
	"Private - Answer the 'self' of the context. May be nil if the block does not reference 'self'
	or any instance variables."

	^receiver!

receiver: newReceiver
	"Private - Set the 'self' of the context"

	receiver := newReceiver!

repeat
	"Evaluate the receiver repeatedly, ending only if the block throws some exception or 
	explicity returns"

	"Note that this message is inlined by the Compiler for literal block receivers."

	
	[self value.
	true] whileTrue!

replaceElementsOf: anIndexableObject from: startInteger to: stopInteger startingAt: startAtInteger
	"Private - Replace the indexable instance variables of the variable pointer object,
	anIndexableObject, between startInteger and stopInteger inclusive with literals from the
	receiver starting from startAtInteger. Answers anIndexableObject."

	<primitive: 188>
	| offset |
	offset := startAtInteger - startInteger.
	(anIndexableObject == self and: [startAtInteger < startInteger])
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]]
		ifFalse: 
			[startInteger to: stopInteger do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]].
	^anIndexableObject!

stackTempCount
	"Private - Answer the <integer> number of extra stack temps (in addition to the arguments)
	used by the receiver. This number of stack slots is reserved and nilled every time
	the receiver is activated."

	^(info bitShift: -15) bitAnd: 16rFF!

stackTempCount: anInteger 
	info := (info bitAnd: ##((16rFF bitShift: 15) bitInvert)) 
				bitOr: ((anInteger bitAnd: 16rFF) bitShift: 15)!

tempCount
	"Answer the total <integer> number of temps used by the receiver. 
	This includes all arguments, stack temps, copied values, and environment 
	(shared) temps used by the receiver."

	^self localCount + self envTempCount!

ticksToRun
	"Private - Answer the number of performance counter ticks consumed by the evaluation of the receiver (including the overhead). The length of a counter tick is system dependent, but usually it is 100nS."

	| startTime endTime endTimeAddress |
	startTime := LargeInteger new64.
	endTime := LargeInteger new64.
	endTimeAddress := endTime basicYourAddress.
	Kernel32 queryPerformanceCounter: startTime basicYourAddress.
	self value.
	Kernel32 queryPerformanceCounter: endTimeAddress.
	^endTime normalize - startTime normalize!

timeToRepeat: anInteger
	"Evaluate the receiver the number of times specified by the <integer> argument, and answer a <Duration> measuring the time taken to do so."

	^(([anInteger timesRepeat: [self value]] ticksToRun - [anInteger timesRepeat: [self]] ticksToRun)
		* Delay.TicksToNanos) nanoseconds!

timeToRun
	"Evaluate the receiver and answer a <Duration> measuring the time taken to do so."

	^((self ticksToRun - [self] ticksToRun) * Delay.TicksToNanos) nanoseconds!

value
	"Answer the result of evaluating the receiver. Fail if the receiver is not  a niladic (zero argument) block.
	
	Primitive failure reasons:
		WrongNumberOfArgs	- the receiver does not expect 0 arguments."

	"Implementation Note: This method is present to handle failures and as a  target for #performs, as invocations of #value are performed directly for zero argument blocks."

	<primitive: 81>
	^self valueFailed: _failureCode argumentCount: 0!

value: arg1
	"Answer the result of evaluating the receiver. Fail if the receiver is not a monadic (one argument) block.
	
	Primitive failure reasons:
		WrongNumberOfArgs	- the receiver does not expect 1 argument."

	"Implementation Note: This method is present to handle failures and as a target for #performs, as invocations of #value are performed directly for one argument blocks."

	<primitive: 81>
	^self valueFailed: _failureCode argumentCount: 1!

value: arg1 value: arg2
	"Answer the result of evaluating the receiver. Fail if the receiver is not a dyadic (two argument) block.

	Primitive failure reasons:
		WrongNumberOfArgs	- the receiver does not expect 2 arguments."

	"Implementation Note: This method is present to handle failures and as a target for #performs, as invocations of #value are performed directly for two argument blocks."

	<primitive: 81>
	^self valueFailed: _failureCode argumentCount: 2!

value: arg1 value: arg2 value: arg3
	"Answer the result of evaluating the receiver. Fail if the receiver is not a three argument block.

	Primitive failure reasons:
		WrongNumberOfArgs	- the receiver does not expect 3 arguments."

	<primitive: 81>
	^self valueFailed: _failureCode argumentCount: 3!

value: arg1 value: arg2 value: arg3 value: arg4
	"Answer the result of evaluating the receiver. Fail if the receiver is not  a four argument block.

	Primitive failure reasons:
		WrongNumberOfArgs	- the receiver does not expect 4 arguments."

	<primitive: 81>
	^self valueFailed: _failureCode argumentCount: 4!

valueFailed: failureCode argumentCount: anInteger
	"Private - A primitive value call failed, generate an appropriate error"

	^failureCode == _PrimitiveFailureCode.WrongNumberOfArgs
		ifTrue: 
			[self error: ('Block expects <1p> argument(s), <2p> given' expandMacrosWith: self argumentCount
						with: anInteger)]
		ifFalse: [self primitiveFailed: failureCode]!

valueOnUnwind: aTwoArgBlock
	"Private - Evaluate the receiver, and should it exit by a non-local return to its home method's sender
	(i.e. via a ^-return) then evaluate aTwoArgBlock, passing it the receiver's home context's sender (i.e.
	the return destination), and the return value. aTwoArgBlock must include an explicit return of its
	own, either via ProcessorScheduler>>returnValue:toFrame: to return the argument value to the 
	unwind destination, or via a further ^-return, which will override the result and return destinations.

	Primitive failure reasons:
		WrongNumberOfArgs	- the receiver does not expect 0 arguments."

	"Implementation Note: Be warned: The primitive marks the caller's stack frame as having an unwind 
	block, by changing it's receiver to be a special magic block. The VM looks for this object when performing 
	^-returns from blocks, and, on detecting such, locates and evaluates the unwind block. The current 
	implementation of  this unwind mechanism leaves its unwind block argument on the stack before 
	evaluating the receiver in the normal way. 
	It is recommended that user code should not send this message directly, as it is possible that the system
	may become unstable if this is not done correctly. User code should use one of the two methods, #ensure: 
	and #ifCurtailed: to record unwind blocks that are performed regardless of whether the block evalutes 
	and returns normally or is curtailed by a non-local return or an exception, or only if curtailed (respectively)."

	<primitive: 79>
	^self primitiveFailed: _failureCode!

valueWithArguments: argumentArray
	"Answer the result of evaluating the receiver with arguments from
	the <Array>, argumentArray. Fail if the argument is not an <Array>, 
	or if the receiver does not take the same number of arguments as are 
	present in the <Array>.

	Primitive failure reasons:
		InvalidParameter1	-	argumentArray is not an <Array>.
		WrongNumberOfArgs	-	the receiver does not expect the number of arguments in argumentArray."

	"Implementation Note: A block can have a maximum of 256 arguments, however 
	this range is shared with other stack temporaries (including copied values), so the 
	effective limit is typically somewhat less. Be aware than many Smalltalks have lower 
	limits, and for complete portability it is recommended to use no more than two. 
	Stack overflow is also a possibility when the arguments are transferred to the stack."

	<primitive: 82>
	^self valueFailed: _failureCode argumentCount: argumentArray size!

valueWithArgumentsAt: anAddress descriptor: anExternalFunctionDescriptor
	"Private - Answer the result of evaluating the receiver with arguments instantiated from memory at anAddress using the external argument types from, anExternalFunctionDescriptor.

	Primitive Failure reasons:
		InvalidParameter1	-	anAddress is not a valid address object (SmallInteger/byte indirection)
		InvalidParameter2	-	anExternalFunctionDescriptor is not a byte object.
		WrongNumberOfArgs	-	the number of arguments whose types are specified by anExternalFunctionDescriptor does not match the number of arguments expected by the receiver."

	"Implementation Note: For performance and consistency (with outbound external calls) reasons, we use a VM supplied primitive to instantiate and push the arguments and perform the message, but there is no reason that this cannot be done in Smalltalk if different argument conversions are required. The standard conversions are the same as those performed for return types by the external call primitive (see the ExternalLibrary class)."

	<primitive: 117>
	^self valueFailed: _failureCode argumentCount: anExternalFunctionDescriptor argumentCount!

whileFalse
	"Repeatedly evaluate the receiver until it evaluates to true. Answer nil."

	"Implementation Note: This message is inlined by the compiler if the
	receiver is a zero-argument literal block, i.e. it will inline the definition
	below, so this method is not actually recursive."

	^[self value] whileFalse!

whileFalse: iterationBlock 
	"Repeatedly evaluate the receiver until it evaluates to true, and
	on each iteration evaluate the <niladicValuable> argument, iterationBlock. 
	Answer nil."

	"Implementation Note: This message is inlined by the compiler if the
	receiver and argument are zero-argument literal block, i.e. it will inline 
	the definition below, so this method is not actually recursive."

	^[self value] whileFalse: [iterationBlock value]!

whileTrue
	"Repeatedly evaluate the receiver until it evaluates to false. Answer nil."

	"Implementation Note: This message is inlined by the compiler if the
	receiver is a zero-argument literal block, i.e. it will inline the definition
	below, so this method is not actually recursive."

	^[self value] whileTrue!

whileTrue: iterationBlock 
	"Repeatedly evaluate the receiver until it evaluates to false, and
	on each iteration evaluate the <niladicValuable> argument, iterationBlock. 
	Answer nil."

	"Implementation Note: This message is inlined by the compiler if the
	receiver and argument are zero-argument literal block, i.e. it will inline 
	the definition below, so this method is not actually recursive."

	^[self value] whileTrue: [iterationBlock value]! !
!Kernel.BlockClosure categoriesForMethods!
=!comparing!public! !
argumentCount!accessing!public! !
argumentCount:!accessing!development!private! !
atPriority:!evaluating!public! !
copiedValues!private! !
critical!private!scheduling! !
cull:!evaluating!public! !
cull:cull:!evaluating!public! !
cull:cull:cull:!evaluating!public! !
cull:cull:cull:cull:!evaluating!public! !
deferredValue!evaluating!public! !
deferredValueAt:!evaluating!public! !
ensure:!debugger-step through!not restartable!public!unwinding! !
envTempCount!accessing!private! !
envTempCount:!accessing!development!private! !
fork!public!scheduling! !
forkAt:!public!scheduling! !
forkAt:maxStack:!public!scheduling! !
forkMaxStack:!public!scheduling! !
frameClass!constants!private! !
home!accessing!private! !
ifCurtailed:!debugger-step through!not restartable!public!unwinding! !
info!accessing!private! !
info:!accessing!development!private! !
initialIP!accessing!public! !
initialIP:!accessing!development!private! !
isClean!private!testing! !
localCount!accessing!private! !
method!accessing!private! !
method:!accessing!private! !
newProcess!public!scheduling! !
newProcess:!public!scheduling! !
newProcessWithArguments:!public!scheduling! !
numArgs!accessing!public! !
on:do:!debugger-step through!exceptions!public! !
on:do:on:do:!exceptions!public! !
on:do:on:do:on:do:!exceptions!public! !
on:do:on:do:on:do:on:do:!exceptions!public! !
on:do:on:do:on:do:on:do:on:do:!exceptions!public! !
on:do:on:do:on:do:on:do:on:do:on:do:!exceptions!public! !
onDo:!exceptions!public! !
outer!accessing!private! !
outer:!accessing!development!private! !
postToInputQueue!event handling!public! !
postToMessageQueue!event handling!public! !
printOn:!development!printing!public! !
receiver!accessing!private! !
receiver:!accessing!private! !
repeat!evaluating!public! !
replaceElementsOf:from:to:startingAt:!public!replacing! !
stackTempCount!accessing!private! !
stackTempCount:!accessing!development!private! !
tempCount!accessing!public! !
ticksToRun!operations!private! !
timeToRepeat:!event handling!public! !
timeToRun!evaluating!public! !
value!evaluating!public! !
value:!evaluating!public! !
value:value:!evaluating!public! !
value:value:value:!evaluating!public! !
value:value:value:value:!evaluating!public! !
valueFailed:argumentCount:!exceptions!private! !
valueOnUnwind:!private!unwinding! !
valueWithArguments:!evaluating!public! !
valueWithArgumentsAt:descriptor:!evaluating!private! !
whileFalse!evaluating!public! !
whileFalse:!evaluating!public! !
whileTrue!evaluating!public! !
whileTrue:!evaluating!public! !
!

Kernel.BlockClosure methodProtocol: #dyadicValuable attributes: #(#readOnly) selectors: #(#argumentCount #value:value: #valueWithArguments:)!
Kernel.BlockClosure methodProtocol: #monadicValuable attributes: #(#readOnly) selectors: #(#argumentCount #value: #valueWithArguments:)!
Kernel.BlockClosure methodProtocol: #niladicValuable attributes: #(#readOnly) selectors: #(#argumentCount #value #valueWithArguments:)!

