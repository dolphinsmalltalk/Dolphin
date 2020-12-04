"Filed out from Dolphin Smalltalk 7"!

Kernel.StTagNode subclass: #'Kernel.StExternalCallNode'
	instanceVariableNames: 'nameOrOrdinal returnType argumentTypes flags callingConvention'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'OverlappedMask' -> 16r1.
		'VirtualMask' -> 16r2
	}!
Kernel.StExternalCallNode guid: (Core.GUID fromString: '{66add179-2714-4fbb-b856-33dee83e11f4}')!
Kernel.StExternalCallNode comment: ''!
!Kernel.StExternalCallNode categoriesForClass!System-Compiler! !
!Kernel.StExternalCallNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	#todo "Implement more efficiently".
	^self formattedCode = anObject formattedCode!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitExternalCallNode: self!

argumentTypes
	^argumentTypes!

argumentTypes: anObject
	argumentTypes := anObject!

callingConvention
	^callingConvention!

callingConvention: anInteger 
	callingConvention := anInteger!

initialize
	flags := 0.
	argumentTypes := #().!

isExternalCall
	^true!

isOverlapped
	^flags allMask: OverlappedMask!

isOverlapped: aBoolean
	flags := flags mask: OverlappedMask set: aBoolean!

isVirtual
	^flags allMask: VirtualMask!

isVirtual: aBoolean
	flags := flags mask: VirtualMask set: aBoolean!

nameOrOrdinal
	^nameOrOrdinal!

nameOrOrdinal: anObject
	nameOrOrdinal := anObject!

primitiveIndex
	^self isVirtual ifTrue: [80] ifFalse: [self isOverlapped ifTrue: [48] ifFalse: [96]]!

returnType
	^returnType!

returnType: anAssociation 
	returnType := anAssociation! !
!Kernel.StExternalCallNode categoriesFor: #=!comparing!public! !
!Kernel.StExternalCallNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StExternalCallNode categoriesFor: #argumentTypes!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #argumentTypes:!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #callingConvention!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #callingConvention:!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #initialize!initializing!public! !
!Kernel.StExternalCallNode categoriesFor: #isExternalCall!public!testing! !
!Kernel.StExternalCallNode categoriesFor: #isOverlapped!public!testing! !
!Kernel.StExternalCallNode categoriesFor: #isOverlapped:!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #isVirtual!public!testing! !
!Kernel.StExternalCallNode categoriesFor: #isVirtual:!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #nameOrOrdinal!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #nameOrOrdinal:!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #primitiveIndex!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #returnType!accessing!public! !
!Kernel.StExternalCallNode categoriesFor: #returnType:!accessing!public! !

!Kernel.StExternalCallNode class methodsFor!

new
	^super new initialize! !
!Kernel.StExternalCallNode class categoriesFor: #new!instance creation!public! !

