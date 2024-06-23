"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange
	subclass: #'Refactory.Browser.RemoveClassConstantChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RemoveClassConstantChange guid: (Core.GUID fromString: '{aee0ae9c-20ed-457d-85bb-913ea38ea2ab}')!

Refactory.Browser.RemoveClassConstantChange comment: ''!

!Refactory.Browser.RemoveClassConstantChange categoriesForClass!Refactory-Change Objects! !

!Refactory.Browser.RemoveClassConstantChange methodsFor!

asUndoOperation
	^AddClassConstantChange add: variable to: self changeClass!

changeString
	^'Remove class constant named, <1s>, from <2d>' << {variable key. classReference}!

changeSymbol
	^#removeClassConstant:!

mutateClassDetails: aClassDetails
	aClassDetails
		classConstants: (aClassDetails classConstants asDictionary
				removeKey: variable key ifAbsent: nil;
				yourself) associations
				sort!

primitiveExecute
	self changeClass removeClassConstant: variable! !

!Refactory.Browser.RemoveClassConstantChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
changeSymbol!constants!private! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
!

