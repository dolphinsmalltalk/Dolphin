"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StVariable
	instanceVariableNames: 'scope reads writes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StVariable guid: (GUID fromString: '{c0f71430-b170-427f-a259-f06ca5fc44d7}')!
StVariable isAbstract: true!
StVariable comment: '<StVariable> is an abstract metadata type used by the Smalltalk compiler''s semantic analyzer to describe variable definitions. There are subtypes to describe instance variables, arguments, temporaries, static variables (i.e. class, pool, and global variables), and the special (aka pseudo) variables ''self'', ''super'' and ''thisContext''.

Instance Variables:
	scope		<StSemanticScope>. The defining (declaring) scope of the variable.
	reads		<OrderedCollection> of <StVariableNode>, being references to the variable that read the value.
	writes		<OrderedCollection> of <StVariableNode>, being writes to the variable that assign a value.

'!
!StVariable categoriesForClass!Kernel-Objects! !
!StVariable methodsFor!

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
!StVariable categoriesFor: #addAssignment:fromScope:!public! !
!StVariable categoriesFor: #addRead:fromScope:!public! !
!StVariable categoriesFor: #isArgument!public!testing! !
!StVariable categoriesFor: #isConstant!public!testing! !
!StVariable categoriesFor: #isInstanceVariable!public!testing! !
!StVariable categoriesFor: #isLocalVariable!public!testing! !
!StVariable categoriesFor: #isRead!public!testing! !
!StVariable categoriesFor: #isStaticVariable!public!testing! !
!StVariable categoriesFor: #isTempVariable!public!testing! !
!StVariable categoriesFor: #isWritten!public!testing! !
!StVariable categoriesFor: #name!accessing!public! !
!StVariable categoriesFor: #printOn:!public! !
!StVariable categoriesFor: #reads!accessing!public! !
!StVariable categoriesFor: #scope!accessing!public! !
!StVariable categoriesFor: #scope:!accessing!public! !
!StVariable categoriesFor: #writes!accessing!public! !

