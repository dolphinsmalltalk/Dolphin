"Filed out from Dolphin Smalltalk 7"!

Kernel.SingletonSearchPolicy subclass: #'Tools.CompiledMethodSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CompiledMethodSearchPolicy guid: (Core.GUID fromString: '{8cb67a35-e7cc-4c00-a9e0-72dcede9d3cf}')!
Tools.CompiledMethodSearchPolicy comment: 'CompiledMethodSearchPolicy is a specialised <searchPolicy> to be used in conjunction with collections of <CompiledMethod>s where one wishes to compare by class and selector only. This is used in the development system for most method lists.'!
!Tools.CompiledMethodSearchPolicy categoriesForClass!Collections-Support! !
!Tools.CompiledMethodSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <CompiledMethod>, operand1, is considered equivalent to the 
	<CompiledMethod> argument, operand2, by this search policy (which considers two
	method to be the same if they are for the same class and have the same selector)."

	^operand1 == operand2 or: [
		operand1 methodClass == operand2 methodClass
			and: [operand1 selector == operand2 selector]]!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^#method! !
!Tools.CompiledMethodSearchPolicy categoriesFor: #compare:with:!comparing!public! !
!Tools.CompiledMethodSearchPolicy categoriesFor: #name!accessing!public! !

