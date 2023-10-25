"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #'Kernel.STBStaticVariableProxy'
	instanceVariableNames: 'reference'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBStaticVariableProxy guid: (Core.GUID fromString: '{b2c4348c-fb81-4102-bc55-4d4e668749ec}')!
Kernel.STBStaticVariableProxy comment: ''!
!Kernel.STBStaticVariableProxy categoriesForClass!System-Binary storage! !
!Kernel.STBStaticVariableProxy methodsFor!

reference: aBindingReference
	reference := aBindingReference.
	^self!

stbFixup: aSTxInFiler at: anInteger
	"Answer the value of the static variable that this proxy represents.
	We must not use #become: to swap the receiver with the represented variable value. We need to tell the in-filer to replace its readMap entry for the resolved value."

	| anObject |
	anObject := self value.
	aSTxInFiler fixup: anInteger to: anObject.
	^anObject!

value
	^reference value! !
!Kernel.STBStaticVariableProxy categoriesForMethods!
reference:!public! !
stbFixup:at:!converting!public! !
value!public! !
!

!Kernel.STBStaticVariableProxy class methodsFor!

reference: aBindingReference
	^self basicNew reference: aBindingReference! !
!Kernel.STBStaticVariableProxy class categoriesForMethods!
reference:!public! !
!

