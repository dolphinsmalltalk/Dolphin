"Filed out from Dolphin Smalltalk 7"!

ClassBuilder subclass: #AnonymousClassBuilder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AnonymousClassBuilder guid: (GUID fromString: '{cd7cc2b6-31a1-41e9-ad2d-50f3f9b109ab}')!
AnonymousClassBuilder comment: ''!
!AnonymousClassBuilder categoriesForClass!System-Support! !
!AnonymousClassBuilder methodsFor!

installInSuperclass: aClass
	"Anonymous classes are not included among their superclass' subclasses"

	!

installNewClass
	"Private - Install aClassDescription into its environment; but not if anonymous."
!

superclass: aClass
	super superclass: aClass.
	self instanceSpec: (aClass instanceSpec bitAnd: Behavior._ShapeMask)!

validateClassName
	className isNil ifFalse: [self error: 'An anonymous class cannot have a name']!

validateSuperclassChainForCreate
	"The superclass just validates that no superclass has the same name, which is not relevant for the unnamed."! !
!AnonymousClassBuilder categoriesFor: #installInSuperclass:!helpers!private! !
!AnonymousClassBuilder categoriesFor: #installNewClass!environment!private! !
!AnonymousClassBuilder categoriesFor: #superclass:!accessing!private! !
!AnonymousClassBuilder categoriesFor: #validateClassName!public! !
!AnonymousClassBuilder categoriesFor: #validateSuperclassChainForCreate!public! !

