"Filed out from Dolphin Smalltalk 2000 release 4.01"!

NavigatorState subclass: #VariableNavigatorState
	instanceVariableNames: 'instanceVariable classVariable variableClassName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VariableNavigatorState comment: ''!

VariableNavigatorState guid: (GUID fromString: '{A8B6C1CA-0E73-11D5-B80B-000102677BBF}')!

!VariableNavigatorState categoriesForClass!Unclassified! !
!VariableNavigatorState methodsFor!

classVariable
	^classVariable!

classVariable: aSymbol 
	classVariable := aSymbol!

instanceVariable
	^instanceVariable!

instanceVariable: aString 
	instanceVariable := aString!

variableClassName
	^variableClassName!

variableClassName: aSymbol 
	variableClassName := aSymbol! !
!VariableNavigatorState categoriesFor: #classVariable!*-unclassified!public! !
!VariableNavigatorState categoriesFor: #classVariable:!*-unclassified!public! !
!VariableNavigatorState categoriesFor: #instanceVariable!*-unclassified!public! !
!VariableNavigatorState categoriesFor: #instanceVariable:!*-unclassified!public! !
!VariableNavigatorState categoriesFor: #variableClassName!*-unclassified!public! !
!VariableNavigatorState categoriesFor: #variableClassName:!*-unclassified!public! !

