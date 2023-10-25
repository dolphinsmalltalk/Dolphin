"Filed out from Dolphin Smalltalk"!

Kernel.STBOutFiler2
	subclass: #'Kernel.STBOutFiler3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler3 guid: (Core.GUID fromString: '{ab6c3f09-f3f5-4324-8d0e-0a146a8f3c93}')!
Kernel.STBOutFiler3 comment: '`STBOutFiler3` is an `STBOutFiler` for writing the STB 3 binary object serialization format.

STB 3 was introduced in Dolphin 6. The key difference from STB 2 was that an object size was only written for indexable objects, rather than all objects. This was done to reduce the size of the serialized data.'!
!Kernel.STBOutFiler3 categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler3 methodsFor!

inFilerClass
	^STBInFiler3!

register: anObject asGlobal: aSymbol
	"Add anObject to the globals dictionary.
	When this object is output it will be wrapped in an STBGlobalObjectProxy.
	When the proxy is subsequently loaded it be added to Smalltalk with the
	name aSymbol. If the same object is registered as several global symbols
	then it must be #nextPut: a corresponding number of times." 

	(anObject isNil
		ifTrue: [globalNils]
		ifFalse: [globals at: anObject ifAbsentPut: [OrderedCollection new]]) add: aSymbol!

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
						do: [:i | self nextPut: (anObject instVarAt: i)]]]
		ifFalse: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask) do: [:i | self nextPut: (anObject instVarAt: i)]]! !
!Kernel.STBOutFiler3 categoriesForMethods!
inFilerClass!constants!private! !
register:asGlobal:!globals!public! !
writeInstanceVariables:!operations!private! !
!

!Kernel.STBOutFiler3 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^3! !
!Kernel.STBOutFiler3 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

