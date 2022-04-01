"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassModificationChange subclass: #'Refactory.Browser.RefactoryVariableChange'
	instanceVariableNames: 'variable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoryVariableChange guid: (Core.GUID fromString: '{e776f08f-009c-4de7-ae6e-6658922002a0}')!
Refactory.Browser.RefactoryVariableChange isNonInstantiable: true!
Refactory.Browser.RefactoryVariableChange comment: ''!
!Refactory.Browser.RefactoryVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RefactoryVariableChange methodsFor!

= aRefactoryVariableChange 
	^super = aRefactoryVariableChange 
		and: [variable = aRefactoryVariableChange variable]!

changeObject
	^variable!

changeString
	^self subclassResponsibility!

changeSymbol
	^self subclassResponsibility!

class: aBehavior variable: aString
	self changeClass: aBehavior.
	self variable: aString!

hash
	^self class hash bitXor: variable hash!

printOn: aStream
	aStream
		display: classReference;
		space;
		nextPutAll: self changeSymbol;
		space;
		print: variable;
		nextPut: $!!!

variable
	^variable!

variable: aString
	variable := aString! !
!Refactory.Browser.RefactoryVariableChange categoriesForMethods!
=!comparing!public! !
changeObject!accessing!private! !
changeString!printing!public! !
changeSymbol!constants!private! !
class:variable:!initializing!private! !
hash!comparing!public! !
printOn:!printing!public! !
variable!accessing!private! !
variable:!initializing!private! !
!

!Refactory.Browser.RefactoryVariableChange class methodsFor!

add: aVariable to: aBehavior 
	"This should only be called on the Add*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable!

remove: aVariable from: aBehavior 
	"This should only be called on the Remove*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable! !
!Refactory.Browser.RefactoryVariableChange class categoriesForMethods!
add:to:!instance creation!public! !
remove:from:!instance creation!public! !
!

