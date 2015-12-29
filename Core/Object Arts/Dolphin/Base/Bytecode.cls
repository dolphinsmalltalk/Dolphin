"Filed out from Dolphin Smalltalk X6"!

Object subclass: #Bytecode
	instanceVariableNames: 'instruction args jumpTarget ip'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Bytecode guid: (GUID fromString: '{189ED4BC-E69B-44E3-8815-7B6D0BDF24B6}')!
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
!Bytecode categoriesFor: #args!accessing!public! !
!Bytecode categoriesFor: #instruction!accessing!public! !
!Bytecode categoriesFor: #instruction:!accessing!public! !
!Bytecode categoriesFor: #ip!accessing!public! !
!Bytecode categoriesFor: #ip:!accessing!public! !
!Bytecode categoriesFor: #jumpOffset:!accessing!public! !
!Bytecode categoriesFor: #jumpTarget!accessing!public! !
!Bytecode categoriesFor: #jumpTarget:!accessing!public! !
!Bytecode categoriesFor: #setInstruction:arguments:ip:!initializing!private! !

!Bytecode class methodsFor!

instruction: bytecodeInteger arguments: anArray ip: aSmallInteger 
	^self new 
		setInstruction: bytecodeInteger
		arguments: anArray
		ip: aSmallInteger! !
!Bytecode class categoriesFor: #instruction:arguments:ip:!instance creation!public! !

