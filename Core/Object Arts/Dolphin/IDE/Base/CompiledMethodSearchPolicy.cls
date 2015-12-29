"Filed out from Dolphin Smalltalk X6"!

SingletonSearchPolicy subclass: #CompiledMethodSearchPolicy
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompiledMethodSearchPolicy guid: (GUID fromString: '{8CB67A35-E7CC-4C00-A9E0-72DCEDE9D3CF}')!
CompiledMethodSearchPolicy comment: 'CompiledMethodSearchPolicy is a specialised <searchPolicy> to be used in conjunction with collections of <CompiledMethod>s where one wishes to compare by class and selector only. This is used in the development system for most method lists.'!
!CompiledMethodSearchPolicy categoriesForClass!Development! !
!CompiledMethodSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <CompiledMethod>, operand1, is considered equivalent to the 
	<CompiledMethod> argument, operand2, by this search policy (which considers two
	method to be the same if they are for the same class and have the same selector)."

	^operand1 == operand2 or: [
		operand1 methodClass == operand2 methodClass
			and: [operand1 selector == operand2 selector]]! !
!CompiledMethodSearchPolicy categoriesFor: #compare:with:!comparing!public! !

!CompiledMethodSearchPolicy class methodsFor!

current
	"Answer the singleton instance of the receiver."

	Current isNil ifTrue: [Current := self new].
	^Current!

onPreStripImage
	"Private - Tidy up the receiver's lazily initialized class vars in preparation for image stripping."

	self uninitialize!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	Current := nil! !
!CompiledMethodSearchPolicy class categoriesFor: #current!instance creation!public! !
!CompiledMethodSearchPolicy class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!CompiledMethodSearchPolicy class categoriesFor: #uninitialize!class hierarchy-removing!private! !

