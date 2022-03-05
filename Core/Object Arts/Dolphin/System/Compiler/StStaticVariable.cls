"Filed out from Dolphin Smalltalk"!

StVariable subclass: #StStaticVariable
	instanceVariableNames: 'binding'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StStaticVariable guid: (GUID fromString: '{b667998a-be56-4e79-bf77-13e991611554}')!
StStaticVariable comment: '<StStaticVariable> is a concrete class of <StVariable> to describe static variables, i.e. class variables, pool variables, and global variables.'!
!StStaticVariable categoriesForClass!Kernel-Objects! !
!StStaticVariable methodsFor!

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
!StStaticVariable categoriesForMethods!
binding!public! !
isConstant!public!testing! !
isStaticVariable!constants!public! !
name!accessing!public! !
setScope:binding:!initializing!private! !
!

!StStaticVariable class methodsFor!

scope: anStLexicalScope binding: aVariableBinding
	^self new setScope: anStLexicalScope binding: aVariableBinding! !
!StStaticVariable class categoriesForMethods!
scope:binding:!public! !
!

