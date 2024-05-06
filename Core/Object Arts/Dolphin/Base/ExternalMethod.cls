"Filed out from Dolphin Smalltalk"!

CompiledMethod variableSubclass: #ExternalMethod
	instanceVariableNames: ''
	classVariableNames: 'ArgsLenIndex ArgumentStartIndex CallingConventionIndex ReturnParmIndex ReturnTypeIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalMethod guid: (GUID fromString: '{87b4c546-026e-11d3-9fd7-00a0cc3e4a32}')!

ExternalMethod comment: 'ExternalMethod is the class of primitive <CompiledMethod>s which represent native, or external, function calls, such as those in the Win32 API. ExternalMethods mediate between the dynamically typed Smalltalk world of objects and the static value based world of C prevailing elsewhere.

The first literal of each ExternalMethod holds a <ByteArray> which contains a descriptor for the function call. The byte array format is understood by the <ExternalDescriptor> class, but essentially there are details of the return and argument types, the name of function, and space to cache the procedure address.
'!

!ExternalMethod categoriesForClass!Kernel-Methods! !

!ExternalMethod methodsFor!

argsLen
	"Private - Answer the size of the argument description bytes in the receivers descriptor."

	^self descriptorLiteral at: ArgsLenIndex!

argumentTypes
	"Private - Answer a Collection of the names of the argument types in the receiver
	in left to right order."

	^self descriptor argumentTypes!

clear
	"Private - Clear down temporary information cached in the receiver.
	Here we clear down the proc. address cache."

	self descriptorLiteral replaceFrom: 1 to: 4 withObject: 0!

descriptor
	"Private - Answer an ExternalDescriptor generated from the receivers descriptor literal (which has
	a more compact, but more complex, format)."

	| descriptor typeinfo i descriptorClass size |
	descriptor := self descriptorLiteral.
	i := self argsLen.
	size := i + 4.
	typeinfo := ByteArray new: size.
	typeinfo
		at: 1 put: (descriptor at: CallingConventionIndex);
		at: 2 put: self argumentCount;
		at: 3 put: (descriptor at: ReturnTypeIndex);
		at: 4 put: (descriptor at: ReturnParmIndex);
		replaceFrom: 5
			to: size
			with: descriptor
			startingAt: ArgumentStartIndex.
	descriptorClass := self descriptorClass.
	i := size.
	[i > 4] whileTrue: 
			[| type |
			type := typeinfo at: i.
			i := i - 1.
			(descriptorClass typeHasArgument: type) 
				ifTrue: 
					[typeinfo at: i + 1 put: (typeinfo at: i).
					typeinfo at: i put: type.
					i := i - 1]].
	^descriptorClass descriptor: typeinfo literals: self literals

	"
(UserLibrary compiledMethodAt: #childWindowFromPoint:point:) descriptor

descriptorLiteral at: 11
"!

descriptorClass
	"Private - Answer the class of descriptor to use for the receiver."

	^ExternalDescriptor!

descriptorLiteral
	"Private - Answer the argument type descriptor literal from the receiver's 'literal frame'.
	The VM considers the descriptor part of the literal frame (for performance and VM simplicity
	a fixed offset is assumed for the literal frame), but we know better - all ExternalMethods 
	must have a descriptor, so it is an inst. var."

	^self basicAt: 1!

functionName
	"Private - Answer the functionName."

	| bytes |
	bytes := self descriptorLiteral.
	^AnsiString fromAddress: bytes yourAddress + ArgumentStartIndex + self argsLen - 1!

isExternalCall
	"Private - Answer whether the receiver is an external library call (foreign function invocation)."

	^true!

isVirtualFunction
	^self primitiveIndex = 80!

printOn: aStream
	"Append a textual description of the receiver to aStream."

	super printOn: aStream.
	aStream nextPut: $(; print: self functionName; nextPut: $)
!

procAddress
	"Private - Answer the receiver's proc. address. The cache will hold zero
	if a call has not yet been made through the function, so we detect this
	and use the appropriate KernelLibrary function."

	| address |
	address := self descriptorLiteral addressAtOffset: 0.
	^address isNull
		ifTrue: [self methodClass default getProcAddress: self functionName]
		ifFalse: [address]
!

returnType
	"Private - Answer the return type for the receiver."

	^self descriptor returnType!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the cached proc. address is cleared."

	| descriptor |
	descriptor := self descriptorLiteral.
	anSTBOutFiler override: descriptor with: (descriptor copy replaceFrom: 1 to: 4 withObject: 0; yourself).
	super stbSaveOn: anSTBOutFiler.

! !

!ExternalMethod categoriesForMethods!
argsLen!accessing!private! !
argumentTypes!accessing!private! !
clear!operations!private! !
descriptor!accessing!private! !
descriptorClass!constants!private! !
descriptorLiteral!accessing!private! !
functionName!accessing!private! !
isExternalCall!private!testing! !
isVirtualFunction!private!testing! !
printOn:!development!printing!public! !
procAddress!accessing!private! !
returnType!accessing!private! !
stbSaveOn:!binary filing!public! !
!

!ExternalMethod class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.

		ExternalMethod initialize.

	The format of the descriptor is:
		
		Proc								Return				ArgN			...	(Arg1)			External
		Address		Calling		Args	Literal	Return		Literal	ArgN	...	(Literal)	Arg1	Function
		Cache		Convention	Length	Index		Type		Index		Type	...	(Index)	Type	Name

		00 00 00 00	00			00		00		00		00		00	...	(00)		00	AAAAAAAAAAA00

	The literal indices referred to are the indices of the (optional) argument types stored in the literal frame.
	The standard, built-in, types (such as #lpvoid, #dword) do not have these indices, or entries in the literal
	frame, but the types for passing/returning structures by value (#struct:) and by reference (#lp:) do - the
	entry in the literal frame is the relevant ExternalStructure class.
	Note that the arguments/return type are stored in reverse order for easier and faster processing by the VM
	external call primitives.
	"

	CallingConventionIndex := 5.
	ArgsLenIndex := 6.				"index of size of arguments descriptions (i.e. offset of proc. name string)"
	ReturnTypeIndex := 8.
	ReturnParmIndex := 7.
	ArgumentStartIndex := 9! !

!ExternalMethod class categoriesForMethods!
initialize!development!initializing!private! !
!

