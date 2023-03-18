"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange
	subclass: #'Refactory.Browser.AddClassConstantChange'
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

changeString
	^'Add class constant named, <1s>, to <2d>' << {variable key. classReference}!

changeSymbol
	^#addClassConstant:!

mutateClassDetails: aClassDetails
	aClassDetails
		classConstants: (aClassDetails classConstants asDictionary
				removeKey: variable key ifAbsent: nil;
				add: variable;
				yourself) associations
				sort!

primitiveExecute
	self changeClass addClassConstant: variable! !
!Refactory.Browser.AddClassConstantChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
changeSymbol!constants!private! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
!

