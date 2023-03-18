"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.StVariable'
	instanceVariableNames: 'scope'
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

addAssignment: aStVariableNode fromScope: aStSemanticScope
	"We don't need to track variable accesses for all variable types, only locals."

	!

addRead: aStVariableNode fromScope: aStSemanticScope
	"We don't need to track variable accesses for all variable types, only locals."

	!

binding
	"Answer the <VariableBinding> which is the underlying representation of the static variable described by the receiver."

	^nil!

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
	"Answer whether the variable described by the receiver is read from anywhere within the method under semantic analysis."

	^true!

isStaticVariable
	"Answer whether the receiver describes a reference to a 'static' variable such as a class
	variable, pool constant, or a global."

	^false!

isTempVariable
	"Answer whether the receiver describes a temporary variable."

	^false!

isWritten
	"Answer whether the variable described by the receiver is written to anywhere within the method under semantic analysis. This is only tracked for temporary variables."

	^false!

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
	"Answer the <sequencedReadableCollection> of <StVariableNode>'s that describe reads from the variable described by the receiver."

	^#()!

scope
	"Answer the <StSemanticScope> in which the variable described by the receiver is defined."

	^scope!

scope: aStSemanticScope
	"Set the <StSemanticScope> in which the variable described by the receiver is defined."

	scope := aStSemanticScope!

writes
	"Answer the <sequencedReadableCollection> of <StVariableNode>'s that describe writes into the variable described by the receiver."

	^#()! !
!Kernel.StVariable categoriesForMethods!
addAssignment:fromScope:!public! !
addRead:fromScope:!public! !
binding!accessing!public! !
isArgument!public!testing! !
isConstant!public!testing! !
isInstanceVariable!public!testing! !
isLocalVariable!public!testing! !
isRead!public!testing! !
isStaticVariable!public!testing! !
isTempVariable!public!testing! !
isWritten!public!testing! !
name!accessing!public! !
printOn:!printing!public! !
reads!accessing!public! !
scope!accessing!public! !
scope:!accessing!public! !
writes!accessing!public! !
!

