"Filed out from Dolphin Smalltalk 7"!

RefactoryClassChange subclass: #RefactoryVariableChange
	instanceVariableNames: 'variable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RefactoryVariableChange guid: (GUID fromString: '{e776f08f-009c-4de7-ae6e-6658922002a0}')!
RefactoryVariableChange isAbstract: true!
RefactoryVariableChange comment: ''!
!RefactoryVariableChange categoriesForClass!Refactory-Change Objects! !
!RefactoryVariableChange methodsFor!

= aRefactoryVariableChange 
	^super = aRefactoryVariableChange 
		and: [variable = aRefactoryVariableChange variable]!

changeObject
	^self variable!

changesFileTemplate
	^'<1p> <2s> <3p>'!

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
!RefactoryVariableChange categoriesFor: #=!comparing!public! !
!RefactoryVariableChange categoriesFor: #changeObject!private! !
!RefactoryVariableChange categoriesFor: #changesFileTemplate!private! !
!RefactoryVariableChange categoriesFor: #changeSymbol!constants!private! !
!RefactoryVariableChange categoriesFor: #class:variable:!initialize/release!public! !
!RefactoryVariableChange categoriesFor: #hash!comparing!public! !
!RefactoryVariableChange categoriesFor: #primitiveExecute!private! !
!RefactoryVariableChange categoriesFor: #variable!private! !

!RefactoryVariableChange class methodsFor!

add: aVariable to: aBehavior 
	"This should only be called on the Add*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable!

remove: aVariable from: aBehavior 
	"This should only be called on the Remove*Change subclasses, 
	but is here so we don't need to copy it to all subclasses"

	^self new class: aBehavior variable: aVariable! !
!RefactoryVariableChange class categoriesFor: #add:to:!instance creation!public! !
!RefactoryVariableChange class categoriesFor: #remove:from:!instance creation!public! !

