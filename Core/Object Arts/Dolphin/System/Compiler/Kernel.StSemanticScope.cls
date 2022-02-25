"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.StSemanticScope'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSemanticScope guid: (Core.GUID fromString: '{6613bf75-bf16-4a7f-92f0-72a8a84738c9}')!
Kernel.StSemanticScope isNonInstantiable: true!
Kernel.StSemanticScope comment: ''!
!Kernel.StSemanticScope categoriesForClass!Kernel-Objects! !
!Kernel.StSemanticScope methodsFor!

classScope
	^self outer classScope!

environment: aNamespace
	self outer environment: aNamespace!

isInlined
	^false!

methodScope
	^self outer methodScope!

outer
	^self subclassResponsibility!

resolveVariable: aStVariableNode
	"Private - Lookup and return an <StVariable> describing the variable definition in this scope matching the variable reference specified by the <StVariableNode> argument. The argument is assumed to be a real variable, as opposed to one of the special variables self, super, or thisContext."

	^self subclassResponsibility!

selfVariable
	^self outer selfVariable!

superVariable
	^self outer superVariable!

thisContextVariable
	^nil! !
!Kernel.StSemanticScope categoriesForMethods!
classScope!accessing!public! !
environment:!accessing!public! !
isInlined!accessing!public! !
methodScope!accessing!public! !
outer!accessing!public! !
resolveVariable:!operations!private! !
selfVariable!accessing!public! !
superVariable!accessing!public! !
thisContextVariable!accessing!public! !
!

