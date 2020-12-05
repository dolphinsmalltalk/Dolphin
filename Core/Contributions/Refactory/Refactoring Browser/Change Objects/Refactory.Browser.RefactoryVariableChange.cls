"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.RefactoryVariableChange'
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
	^self variable!

changeSymbol
	^self subclassResponsibility!

class: aBehavior variable: aString 
	self changeClass: aBehavior.
	variable := aString!

hash
	^self class hash bitXor: variable hash!

primitiveExecute
	| changeSymbol |
	changeSymbol := self changeSymbol.
	self changeClass perform: changeSymbol with: self changeObject.
	
	"ChangeSet current changeClass: self changeClass.
	SourceFileManager default logChange: (self changesFileTemplate 
				expandMacrosWith: self changeClass
				with: changeSymbol
				with: self variable)"!

variable
	^variable! !
!Refactory.Browser.RefactoryVariableChange categoriesFor: #=!comparing!public! !
!Refactory.Browser.RefactoryVariableChange categoriesFor: #changeObject!private! !
!Refactory.Browser.RefactoryVariableChange categoriesFor: #changeSymbol!constants!private! !
!Refactory.Browser.RefactoryVariableChange categoriesFor: #class:variable:!initialize/release!public! !
!Refactory.Browser.RefactoryVariableChange categoriesFor: #hash!comparing!public! !
!Refactory.Browser.RefactoryVariableChange categoriesFor: #primitiveExecute!private! !
!Refactory.Browser.RefactoryVariableChange categoriesFor: #variable!private! !

!Refactory.Browser.RefactoryVariableChange class methodsFor!

add: aVariable to: aBehavior 
	"This should only be called on the Add*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable!

remove: aVariable from: aBehavior 
	"This should only be called on the Remove*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable! !
!Refactory.Browser.RefactoryVariableChange class categoriesFor: #add:to:!instance creation!public! !
!Refactory.Browser.RefactoryVariableChange class categoriesFor: #remove:from:!instance creation!public! !

