"Filed out from Dolphin Smalltalk"!

Kernel.StVariable
	subclass: #'Kernel.StSpecialVariable'
	instanceVariableNames: 'reads'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StSpecialVariable guid: (Core.GUID fromString: '{83bccab3-8ad0-4dbb-bbf0-dba008295503}')!

Kernel.StSpecialVariable isNonInstantiable: true!

Kernel.StSpecialVariable comment: '<StSpecialVariable> is an abstract class of <StVariable> with concrete subclasses to describe the special variables, ''self'', ''super'', and ''thisContext''. '!

!Kernel.StSpecialVariable categoriesForClass!Kernel-Objects! !

!Kernel.StSpecialVariable methodsFor!

addAssignment: aStVariableNode fromScope: aStSemanticScope
	self error: 'Illegal assignment to constant.'!

addRead: aStVariableNode fromScope: aStSemanticScope
	(reads ifNil: [reads := OrderedCollection new]) addLast: aStVariableNode!

isConstant
	"Answer whether the receiver describes a variable that has a constant value. The special
	variables self, super and thisContext, cannot be assigned to."

	^true!

isRead
	"Answer whether the variable described by the receiver is read from anywhere within the method under semantic analysis."

	^reads notNil!

isSpecialVariable
	"Answer whether the variable described by the receiver is one of the special (aka pseudo) variables 'self', 'super' or 'thisContext'."

	^true!

reads
	"Answer the <sequencedReadableCollection> of <StVariableNode>'s that describe reads from the
	variable described by the receiver."

	^reads ?? #()! !

!Kernel.StSpecialVariable categoriesForMethods!
addAssignment:fromScope:!public! !
addRead:fromScope:!public! !
isConstant!public!testing! !
isRead!public!testing! !
isSpecialVariable!public!testing! !
reads!accessing!public! !
!

