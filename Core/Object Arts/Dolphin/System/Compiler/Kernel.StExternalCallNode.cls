"Filed out from Dolphin Smalltalk 7"!

StTagNode subclass: #StExternalCallNode
	instanceVariableNames: 'nameOrOrdinal returnType argumentTypes flags callingConvention'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'OverlappedMask' -> 16r1.
		'VirtualMask' -> 16r2
	}!
StExternalCallNode guid: (GUID fromString: '{66add179-2714-4fbb-b856-33dee83e11f4}')!
StExternalCallNode comment: ''!
!StExternalCallNode categoriesForClass!System-Compiler! !
!StExternalCallNode methodsFor!

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
!StExternalCallNode categoriesFor: #=!comparing!public! !
!StExternalCallNode categoriesFor: #acceptVisitor:!public!visitor! !
!StExternalCallNode categoriesFor: #argumentTypes!accessing!public! !
!StExternalCallNode categoriesFor: #argumentTypes:!accessing!public! !
!StExternalCallNode categoriesFor: #callingConvention!accessing!public! !
!StExternalCallNode categoriesFor: #callingConvention:!accessing!public! !
!StExternalCallNode categoriesFor: #initialize!initializing!public! !
!StExternalCallNode categoriesFor: #isExternalCall!public!testing! !
!StExternalCallNode categoriesFor: #isOverlapped!public!testing! !
!StExternalCallNode categoriesFor: #isOverlapped:!accessing!public! !
!StExternalCallNode categoriesFor: #isVirtual!public!testing! !
!StExternalCallNode categoriesFor: #isVirtual:!accessing!public! !
!StExternalCallNode categoriesFor: #nameOrOrdinal!accessing!public! !
!StExternalCallNode categoriesFor: #nameOrOrdinal:!accessing!public! !
!StExternalCallNode categoriesFor: #primitiveIndex!accessing!public! !
!StExternalCallNode categoriesFor: #returnType!accessing!public! !
!StExternalCallNode categoriesFor: #returnType:!accessing!public! !

!StExternalCallNode class methodsFor!

new
	^super new initialize! !
!StExternalCallNode class categoriesFor: #new!instance creation!public! !

