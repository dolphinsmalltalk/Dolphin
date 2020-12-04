"Filed out from Dolphin Smalltalk 7"!

Kernel.StSpecialVariable subclass: #'Kernel.StThisContextVariable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StThisContextVariable guid: (Core.GUID fromString: '{dbebe810-ee05-4346-aa77-6131cf03eca2}')!
Kernel.StThisContextVariable comment: '<StThisContextVariable> is a concrete class of <StSpecialVariable> to describe the ''thisContext'' pseudo-variable in a particular <StLexicalScope>.'!
!Kernel.StThisContextVariable categoriesForClass!Kernel-Objects! !
!Kernel.StThisContextVariable methodsFor!

name
	"Answer the <readableString> identifier of the variable described by the receiver."

	^'thisContext'! !
!Kernel.StThisContextVariable categoriesFor: #name!accessing!public! !

