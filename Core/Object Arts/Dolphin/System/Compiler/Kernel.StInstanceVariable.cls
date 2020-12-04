"Filed out from Dolphin Smalltalk 7"!

Kernel.StVariable subclass: #'Kernel.StInstanceVariable'
	instanceVariableNames: 'index name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StInstanceVariable guid: (Core.GUID fromString: '{9e27c3fe-9793-4a23-9fcd-4f2cb4c86f2b}')!
Kernel.StInstanceVariable comment: '<StInstanceVariable> is a concrete class of <StVariable> to describe instance variables.

Instance Variables:
	index		<SmallInteger> index of the instance variable slot in object''s of the type of which the receiver describes an instance variable.
	name		<String> identifier of the instance variable.

'!
!Kernel.StInstanceVariable categoriesForClass!Kernel-Objects! !
!Kernel.StInstanceVariable methodsFor!

index
	"Answer the one-based <integer> index of the instance variable slot in the class of object of the reference instance variable."

	^index!

isInstanceVariable
	"Answer whether the receiver describes an instance variable."

	^true!

name
	"Answer the <readableString> identifier of the variable described by the receiver, i.e. the
	instance variable name."

	^name!

setIndex: anInteger name: aString
	index := anInteger.
	name := aString.
	self initialize! !
!Kernel.StInstanceVariable categoriesFor: #index!accessing!public! !
!Kernel.StInstanceVariable categoriesFor: #isInstanceVariable!public!testing! !
!Kernel.StInstanceVariable categoriesFor: #name!accessing!public! !
!Kernel.StInstanceVariable categoriesFor: #setIndex:name:!initializing!private! !

!Kernel.StInstanceVariable class methodsFor!

index: anInteger name: aString
	^self new setIndex: anInteger name: aString! !
!Kernel.StInstanceVariable class categoriesFor: #index:name:!public! !

