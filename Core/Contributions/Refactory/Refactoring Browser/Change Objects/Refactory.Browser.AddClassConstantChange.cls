"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryVariableChange subclass: #'Refactory.Browser.AddClassConstantChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddClassConstantChange guid: (Core.GUID fromString: '{1971f618-b2fa-4d5a-bf1d-36b364eb34cc}')!
Refactory.Browser.AddClassConstantChange comment: ''!
!Refactory.Browser.AddClassConstantChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.AddClassConstantChange methodsFor!

asUndoOperation
	^RemoveClassConstantChange remove: variable from: self changeClass!

changeStringFormat
	^'Add class constant named, <1s>, to <2s>'!

changeSymbol
	^#addClassConstant:!

variableName
	^variable key! !
!Refactory.Browser.AddClassConstantChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.AddClassConstantChange categoriesFor: #changeStringFormat!constants!printing!private! !
!Refactory.Browser.AddClassConstantChange categoriesFor: #changeSymbol!constants!private! !
!Refactory.Browser.AddClassConstantChange categoriesFor: #variableName!accessing!private! !

