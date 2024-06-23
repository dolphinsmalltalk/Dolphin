"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange
	subclass: #'Refactory.Browser.AddClassVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.AddClassVariableChange guid: (Core.GUID fromString: '{bf346b83-3f40-4ec7-bc19-26c86114e7e2}')!

Refactory.Browser.AddClassVariableChange comment: ''!

!Refactory.Browser.AddClassVariableChange categoriesForClass!Refactory-Change Objects! !

!Refactory.Browser.AddClassVariableChange methodsFor!

asUndoOperation
	^RemoveClassVariableChange remove: variable from: self changeClass!

changeString
	^'Add class variable named, <1s>, to <2d>' << {variable. classReference}!

changeSymbol
	^#addClassVarNamed:!

mutateClassDetails: aClassDetails
	| classVars |
	classVars := aClassDetails classVariableNames.
	(classVars includes: variable)
		ifFalse: [aClassDetails classVariableNames: (classVars copyWith: variable) sort]!

primitiveExecute
	self changeClass addClassVarNamed: variable! !

!Refactory.Browser.AddClassVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
changeSymbol!constants!private! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
!

