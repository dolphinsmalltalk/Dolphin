"Filed out from Dolphin Smalltalk"!

Kernel.ClassBuilder
	subclass: #'Kernel.AnonymousClassBuilder'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.AnonymousClassBuilder guid: (Core.GUID fromString: '{cd7cc2b6-31a1-41e9-ad2d-50f3f9b109ab}')!

Kernel.AnonymousClassBuilder comment: ''!

!Kernel.AnonymousClassBuilder categoriesForClass!System-Support! !

!Kernel.AnonymousClassBuilder methodsFor!

installInSuperclass: aClass
	"Anonymous classes are not included among their superclass' subclasses"
	!

installNewClass
	"Private - Install aClassDescription into its environment; but not if anonymous."
!

superclass: aClass
	super superclass: aClass.
	self instanceSpec: (aClass instanceSpec bitAnd: Behavior._ShapeMask).
	environment := aClass environment!

validateClassName
	className isNil ifFalse: [self error: 'An anonymous class cannot have a name']!

validateSuperclassChainForCreate
	"The superclass just validates that no superclass has the same name, which is not relevant for the unnamed."! !

!Kernel.AnonymousClassBuilder categoriesForMethods!
installInSuperclass:!helpers!private! !
installNewClass!environment!private! !
superclass:!accessing!private! !
validateClassName!public! !
validateSuperclassChainForCreate!public! !
!

