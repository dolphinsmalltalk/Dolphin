"Filed out from Dolphin Smalltalk"!

Kernel.StVariable subclass: #'Kernel.StStaticVariable'
	instanceVariableNames: 'binding'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StStaticVariable guid: (Core.GUID fromString: '{b667998a-be56-4e79-bf77-13e991611554}')!
Kernel.StStaticVariable comment: '<StStaticVariable> is a concrete class of <StVariable> to describe static variables, i.e. class variables, pool variables, and global variables.'!
!Kernel.StStaticVariable categoriesForClass!Kernel-Objects! !
!Kernel.StStaticVariable methodsFor!

binding
	"Answer the <VariableBinding> which is the underlying representation of the static variable
	described by the receiver."

	^binding!

isConstant
	"Answer whether the receiver describes a reference to a variable that has a constant value."

	^binding isImmutable!

isStaticVariable
	"Answer whether the receiver describes a reference to a 'static' variable such as a class
	variable, pool constant, or a global."

	^true!

name
	"Answer the <readableString> identifier of the variable described by the receiver."

	^binding key!

setScope: anStLexicalScope binding: aVariableBinding
	scope := anStLexicalScope.
	binding := aVariableBinding.
	self initialize! !
!Kernel.StStaticVariable categoriesForMethods!
binding!accessing!public! !
isConstant!public!testing! !
isStaticVariable!constants!public! !
name!accessing!public! !
setScope:binding:!initializing!private! !
!

!Kernel.StStaticVariable class methodsFor!

scope: anStLexicalScope binding: aVariableBinding
	^self new setScope: anStLexicalScope binding: aVariableBinding! !
!Kernel.StStaticVariable class categoriesForMethods!
scope:binding:!public! !
!

