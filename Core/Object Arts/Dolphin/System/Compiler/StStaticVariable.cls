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
	self initialize! !
!StStaticVariable categoriesFor: #binding!public! !
!StStaticVariable categoriesFor: #isConstant!public!testing! !
!StStaticVariable categoriesFor: #isStaticVariable!constants!public! !
!StStaticVariable categoriesFor: #name!accessing!public! !
!StStaticVariable categoriesFor: #setScope:binding:!initializing!private! !

!StStaticVariable class methodsFor!

scope: anStLexicalScope binding: aVariableBinding
	^self new setScope: anStLexicalScope binding: aVariableBinding! !
!StStaticVariable class categoriesFor: #scope:binding:!public! !

