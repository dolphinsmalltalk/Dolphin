"Filed out from Dolphin Smalltalk"!

Kernel.StTagNode
	subclass: #'Kernel.AbstractPrimitiveCallNode'
	instanceVariableNames: 'errorTemp'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.AbstractPrimitiveCallNode guid: (Core.GUID fromString: '{cda70e7a-3497-4e79-a795-0e299811460e}')!

Kernel.AbstractPrimitiveCallNode isNonInstantiable: true!

Kernel.AbstractPrimitiveCallNode comment: ''!

!Kernel.AbstractPrimitiveCallNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self primitiveIndex = anObject primitiveIndex!

childrenDo: aMonadicValuable
	aMonadicValuable value: errorTemp!

defines: aName
	^errorTemp name = aName!

errorTemp
	^errorTemp!

errorTemp: aStTempDeclNode
	errorTemp := aStTempDeclNode.
	aStTempDeclNode parent: self!

hasDefaultErrorTemp
	^self subclassResponsibility!

postCopy
	super postCopy.
	self errorTemp: errorTemp copy.
	^self!

primitiveIndex
	^self subclassResponsibility!

setDefaultErrorTemp
	self errorTemp: (StTempDeclNode named: '_failureCode')! !

!Kernel.AbstractPrimitiveCallNode categoriesForMethods!
=!comparing!public! !
childrenDo:!accessing!public! !
defines:!public!testing! !
errorTemp!accessing!public! !
errorTemp:!accessing!private! !
hasDefaultErrorTemp!accessing!public! !
postCopy!copying!public! !
primitiveIndex!accessing!public! !
setDefaultErrorTemp!private! !
!

