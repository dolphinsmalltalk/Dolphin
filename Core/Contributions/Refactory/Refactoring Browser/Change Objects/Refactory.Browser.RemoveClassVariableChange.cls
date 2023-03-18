"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange
	subclass: #'Refactory.Browser.RemoveClassVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveClassVariableChange guid: (Core.GUID fromString: '{b2ce8c91-bd3b-4c5a-9210-f0443a0bd159}')!
Refactory.Browser.RemoveClassVariableChange comment: ''!
!Refactory.Browser.RemoveClassVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveClassVariableChange methodsFor!

asUndoOperation
	^AddClassVariableChange add: variable to: self changeClass!

changeString
	^'Remove class variable named, <1s>, from <2d>' << {variable. classReference}!

changeSymbol
	^#removeClassVarName:!

mutateClassDetails: aClassDetails
	aClassDetails classVariableNames: (aClassDetails classVariableNames copyWithout: variable)!

primitiveExecute
	self changeClass removeClassVarName: variable! !
!Refactory.Browser.RemoveClassVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
changeSymbol!constants!private! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
!

