"Filed out from Dolphin Smalltalk 7"!

StVariable subclass: #StStaticVariable
	instanceVariableNames: 'binding'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StStaticVariable guid: (GUID fromString: '{b667998a-be56-4e79-bf77-13e991611554}')!
StStaticVariable comment: ''!
!StStaticVariable categoriesForClass!Kernel-Objects! !
!StStaticVariable methodsFor!

binding
	^binding!

isConstant
	^binding isImmutable!

isStaticVariable
	^true!

name
	^binding key!

setScope: anStLexicalScope binding: aVariableBinding
	scope := anStLexicalScope.
	binding := aVariableBinding.
	self initialize!

valueClass
	"Answer the class of the variables value, if this is known, or nil if unknown."

	"In the case of static variables, we can only offer a variable type with confidence (without
	resort to type inference) if the variable binding is constant. If it isn't then the variable
	could assume different types through the course of the method or even across different
	invocations (if a global, or class variable). This might cause false reports of
	unimplemented messages in the debugger. Therefore we have to be conservative here in
	suggesting the variable type."

	^binding isImmutable ifTrue: [binding value basicClass]! !
!StStaticVariable categoriesFor: #binding!public! !
!StStaticVariable categoriesFor: #isConstant!public!testing! !
!StStaticVariable categoriesFor: #isStaticVariable!constants!public! !
!StStaticVariable categoriesFor: #name!accessing!public! !
!StStaticVariable categoriesFor: #setScope:binding:!initializing!private! !
!StStaticVariable categoriesFor: #valueClass!accessing!public! !

!StStaticVariable class methodsFor!

scope: anStLexicalScope binding: aVariableBinding
	^self new setScope: anStLexicalScope binding: aVariableBinding! !
!StStaticVariable class categoriesFor: #scope:binding:!public! !

