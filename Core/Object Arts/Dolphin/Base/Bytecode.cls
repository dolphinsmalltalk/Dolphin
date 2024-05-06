"Filed out from Dolphin Smalltalk"!

Object subclass: #Bytecode
	instanceVariableNames: 'instruction args jumpTarget ip'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Bytecode guid: (GUID fromString: '{189ed4bc-e69b-44e3-8815-7b6d0bdf24b6}')!

Bytecode comment: 'BytecodeRewrite is a private system utility class that supports the <BytecodeRewriter>.'!

!Bytecode categoriesForClass!Kernel-Objects! !

!Bytecode methodsFor!

args
	^args!

instruction
	^instruction!

instruction: anObject
	instruction := anObject!

ip
	^ip!

ip: anObject
	ip := anObject!

jumpOffset: anInteger 
	| jumpSize |
	self assert: 
			[(args size = 1 and: [anInteger between: -128 and: 127]) 
				or: [args size >= 2 and: [anInteger between: -32768 and: 32767]]].
	jumpSize := args size min: 2.
	args := args 
				replaceFrom: args size - jumpSize + 1
				to: args size
				with: ((1 to: jumpSize) collect: [:each | anInteger digitAt: each])
				startingAt: 1!

jumpTarget
	^jumpTarget!

jumpTarget: anObject
	jumpTarget := anObject!

setInstruction: aSymbol arguments: anArray ip: aSmallInteger 
	instruction := aSymbol.
	args := anArray.
	ip := aSmallInteger.
! !

!Bytecode categoriesForMethods!
args!accessing!public! !
instruction!accessing!public! !
instruction:!accessing!public! !
ip!accessing!public! !
ip:!accessing!public! !
jumpOffset:!accessing!public! !
jumpTarget!accessing!public! !
jumpTarget:!accessing!public! !
setInstruction:arguments:ip:!initializing!private! !
!

!Bytecode class methodsFor!

instruction: bytecodeInteger arguments: anArray ip: aSmallInteger 
	^self new 
		setInstruction: bytecodeInteger
		arguments: anArray
		ip: aSmallInteger! !

!Bytecode class categoriesForMethods!
instruction:arguments:ip:!instance creation!public! !
!

