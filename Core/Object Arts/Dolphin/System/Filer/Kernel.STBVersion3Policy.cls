"Filed out from Dolphin Smalltalk"!

Kernel.STBVersion2Policy
	subclass: #'Kernel.STBVersion3Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion3Policy guid: (Core.GUID fromString: '{0d80f5bc-67f6-4a70-a725-178fb91a9577}')!
Kernel.STBVersion3Policy comment: '`STBVersion3Policy` is the the policy/strateger plugin for writing and reading the STB v3 serialization format.

This was the format used in Dolphin 5.x. It differed from v0 in the following ways:
  - Some commonly used and pre-requisite classes were pre-registered, fixing some obscure chicken-before-egg issues.
  - `String` was pre-registered, but the rarely used `UnicodeString` was not. `String` was effectively equivalent to `AnsiString` in Dolphin post the addition of full Unicode support in 7.1, and `UnicodeString` was the predecessor of `Utf16String`.
'!
!Kernel.STBVersion3Policy methodsFor!

readObjectSize: aClass
	"As of STB version 3, the out-filer only writes the object size for indexable objects."

	^aClass isVariable ifTrue: [stream nextInt32] ifFalse: [0]!

writeInstanceVariables: anObject
	| instanceSpec |
	instanceSpec := anObject basicClass instanceSpec.
	(instanceSpec anyMask: Behavior._VariableMask)
		ifTrue: 
			[| basicSize |
			"As of V3, the indexed size was only written for indexable objects"
			stream nextInt32Put: (basicSize := anObject basicSize).
			(instanceSpec anyMask: Behavior._PointersMask)
				ifFalse: 
					[1 to: basicSize
						do: 
							[:i |
							"Bytes written directly"
							stream nextPut: (anObject basicAt: i)]]
				ifTrue: 
					[1 to: (instanceSpec bitAnd: Behavior._SizeMask) + basicSize
						do: [:i | filer nextPut: (anObject instVarAt: i)]]]
		ifFalse: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask) do: [:i | filer nextPut: (anObject instVarAt: i)]]! !
!Kernel.STBVersion3Policy categoriesForMethods!
readObjectSize:!operations!public! !
writeInstanceVariables:!operations!private! !
!

!Kernel.STBVersion3Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^3! !
!Kernel.STBVersion3Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

