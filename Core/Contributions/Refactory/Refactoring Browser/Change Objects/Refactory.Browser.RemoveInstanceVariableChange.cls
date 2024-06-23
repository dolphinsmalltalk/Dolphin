"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange
	subclass: #'Refactory.Browser.RemoveInstanceVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RemoveInstanceVariableChange guid: (Core.GUID fromString: '{e9c39339-a730-4cfc-a1e7-c0c44ec0e681}')!

Refactory.Browser.RemoveInstanceVariableChange comment: ''!

!Refactory.Browser.RemoveInstanceVariableChange categoriesForClass!Refactory-Change Objects! !

!Refactory.Browser.RemoveInstanceVariableChange methodsFor!

asUndoOperation
	^AddInstanceVariableChange add: variable to: self changeClass!

changeString
	^'Remove instance variable named, <1s>, from <2d>' << {variable. classReference}!

changeSymbol
	^#removeInstVarName:!

mutateClassDetails: aClassDetails
	aClassDetails instanceVariableNames: (aClassDetails instanceVariableNames copyWithout: variable)!

primitiveExecute
	self changeClass removeInstVarName: variable! !

!Refactory.Browser.RemoveInstanceVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
changeSymbol!constants!private! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
!

