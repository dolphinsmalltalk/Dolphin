"Filed out from Dolphin Smalltalk"!

StVariable subclass: #StInstanceVariable
	instanceVariableNames: 'index name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StInstanceVariable guid: (GUID fromString: '{9e27c3fe-9793-4a23-9fcd-4f2cb4c86f2b}')!

StInstanceVariable comment: '<StInstanceVariable> is a concrete class of <StVariable> to describe instance variables.

Instance Variables:
	index		<SmallInteger> index of the instance variable slot in object''s of the type of which the receiver describes an instance variable.
	name		<String> identifier of the instance variable.

'!

!StInstanceVariable categoriesForClass!Kernel-Objects! !

!StInstanceVariable methodsFor!

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

!StInstanceVariable categoriesForMethods!
index!accessing!public! !
isInstanceVariable!public!testing! !
name!accessing!public! !
setIndex:name:!initializing!private! !
!

!StInstanceVariable class methodsFor!

index: anInteger name: aString
	^self new setIndex: anInteger name: aString! !

!StInstanceVariable class categoriesForMethods!
index:name:!public! !
!

