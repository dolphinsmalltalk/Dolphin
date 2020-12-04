"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.StVariable'
	instanceVariableNames: 'scope reads writes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StVariable guid: (Core.GUID fromString: '{c0f71430-b170-427f-a259-f06ca5fc44d7}')!
Kernel.StVariable isNonInstantiable: true!
Kernel.StVariable comment: '<StVariable> is an abstract metadata type used by the Smalltalk compiler''s semantic analyzer to describe variable definitions. There are subtypes to describe instance variables, arguments, temporaries, static variables (i.e. class, pool, and global variables), and the special (aka pseudo) variables ''self'', ''super'' and ''thisContext''.

Instance Variables:
	scope		<StSemanticScope>. The defining (declaring) scope of the variable.
	reads		<OrderedCollection> of <StVariableNode>, being references to the variable that read the value.
	writes		<OrderedCollection> of <StVariableNode>, being writes to the variable that assign a value.

'!
!Kernel.StVariable categoriesForClass!Kernel-Objects! !
!Kernel.StVariable methodsFor!

addAssignment: anStVariableNode fromScope: anStSemanticScope
	self isConstant ifTrue: [self error: 'Illegal assignment to constant.'].
	(writes ifNil: [writes := OrderedCollection new]) addLast: anStVariableNode!

addRead: anStVariableNode fromScope: anStSemanticScope
	(reads ifNil: [reads := OrderedCollection new]) addLast: anStVariableNode!

isArgument
	"Answer whether the receiver describes an argument variable."

	^false!

isConstant
	"Answer whether the receiver describes a variable that has a constant value."

	^false!

isInstanceVariable
	"Answer whether the receiver describes an instance variable."

	^false!

isLocalVariable
	"Answer whether the receiver describes a local variable, i.e. a temp or argument."

	^false!

isRead
	"Answer whether the variable described by the receiver is read from anywhere within the
	method under semantic analysis."

	^reads notNil!

isStaticVariable
	"Answer whether the receiver describes a reference to a 'static' variable such as a class
	variable, pool constant, or a global."

	^false!

isTempVariable
	"Answer whether the receiver describes a temporary variable."

	^false!

isWritten
	"Answer whether the variable described by the receiver is written to anywhere within the
	method under semantic analysis."

	^writes notNil!

name
	"Answer the <readableString> identifier of the variable described by the receiver."

	^self subclassResponsibility!

printOn: aPuttableStream
	self basicPrintOn: aPuttableStream.
	aPuttableStream
		nextPut: $(;
		display: self name;
		nextPut: $)!

reads
	"Answer the <sequencedReadableCollection> of <StVariableNode>'s that describe reads from the
	variable described by the receiver."

	^reads ?? #()!

scope
	"Answer the <StSemanticScope> in which the variable described by the receiver is defined."

	^scope!

scope: anStSemanticScope
	"Set the <StSemanticScope> in which the variable described by the receiver is defined."

	scope := anStSemanticScope!

writes
	"Answer the <sequencedReadableCollection> of <StVariableNode>'s that describe writes into
	the variable described by the receiver."

	^writes ?? #()! !
!Kernel.StVariable categoriesFor: #addAssignment:fromScope:!public! !
!Kernel.StVariable categoriesFor: #addRead:fromScope:!public! !
!Kernel.StVariable categoriesFor: #isArgument!public!testing! !
!Kernel.StVariable categoriesFor: #isConstant!public!testing! !
!Kernel.StVariable categoriesFor: #isInstanceVariable!public!testing! !
!Kernel.StVariable categoriesFor: #isLocalVariable!public!testing! !
!Kernel.StVariable categoriesFor: #isRead!public!testing! !
!Kernel.StVariable categoriesFor: #isStaticVariable!public!testing! !
!Kernel.StVariable categoriesFor: #isTempVariable!public!testing! !
!Kernel.StVariable categoriesFor: #isWritten!public!testing! !
!Kernel.StVariable categoriesFor: #name!accessing!public! !
!Kernel.StVariable categoriesFor: #printOn:!public! !
!Kernel.StVariable categoriesFor: #reads!accessing!public! !
!Kernel.StVariable categoriesFor: #scope!accessing!public! !
!Kernel.StVariable categoriesFor: #scope:!accessing!public! !
!Kernel.StVariable categoriesFor: #writes!accessing!public! !

