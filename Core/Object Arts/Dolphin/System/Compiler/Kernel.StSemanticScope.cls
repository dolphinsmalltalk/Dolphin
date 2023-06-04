"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.StSemanticScope'
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

environment
	^self outer environment!

environment: aNamespace
	self outer environment: aNamespace!

isInlined
	^false!

methodClass
	^self outer methodClass!

methodScope
	^self outer methodScope!

outer
	^self subclassResponsibility!

resolveIdentifier: aString
	"Private - Lookup and return an <StVariable> describing the variable definition in this scope matching the specified identifier."

	^self subclassResponsibility!

selfVariable
	^self outer selfVariable!

superVariable
	^self outer superVariable!

thisContextVariable
	^nil!

visibleVariablesDo: aMonadicValuable
	self visibleVariablesDo: aMonadicValuable visited: Set new!

visibleVariablesDo: aMonadicValuable visited: aSet
	^self subclassResponsibility! !
!Kernel.StSemanticScope categoriesForMethods!
classScope!accessing!public! !
environment!accessing!public! !
environment:!accessing!public! !
isInlined!accessing!public! !
methodClass!accessing!public! !
methodScope!accessing!public! !
outer!accessing!public! !
resolveIdentifier:!operations!private! !
selfVariable!accessing!public! !
superVariable!accessing!public! !
thisContextVariable!accessing!public! !
visibleVariablesDo:!public! !
visibleVariablesDo:visited:!operations!public! !
!

