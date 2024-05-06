"Filed out from Dolphin Smalltalk"!

StTagNode subclass: #StExternalCallNode
	instanceVariableNames: 'nameOrOrdinal returnType argumentTypes flags callingConvention'
	classVariableNames: 'OverlappedMask VirtualMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!StExternalCallNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
argumentTypes!accessing!public! !
argumentTypes:!accessing!public! !
callingConvention!accessing!public! !
callingConvention:!accessing!public! !
initialize!initializing!public! !
isExternalCall!public!testing! !
isOverlapped!public!testing! !
isOverlapped:!accessing!public! !
isVirtual!public!testing! !
isVirtual:!accessing!public! !
nameOrOrdinal!accessing!public! !
nameOrOrdinal:!accessing!public! !
primitiveIndex!accessing!public! !
returnType!accessing!public! !
returnType:!accessing!public! !
!

!StExternalCallNode class methodsFor!

initialize
	"
	self initialize
	"

	OverlappedMask := 16r1.
	VirtualMask := 16r2.!

new
	^super new initialize! !

!StExternalCallNode class categoriesForMethods!
initialize!initializing!public! !
new!instance creation!public! !
!

