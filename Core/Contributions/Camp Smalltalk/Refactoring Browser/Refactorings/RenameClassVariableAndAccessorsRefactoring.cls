"Filed out from Dolphin Smalltalk 7"!

RenameClassVariableRefactoring subclass: #RenameClassVariableAndAccessorsRefactoring
	instanceVariableNames: 'accessorsRefactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RenameClassVariableAndAccessorsRefactoring guid: (GUID fromString: '{57103af9-2346-41c7-b725-60356588c950}')!
RenameClassVariableAndAccessorsRefactoring comment: ''!
!RenameClassVariableAndAccessorsRefactoring categoriesForClass!Unclassified! !
!RenameClassVariableAndAccessorsRefactoring methodsFor!

initializeAccessorsRefactoring

	accessorsRefactoring :=
		RenameAccessorsForVariableRefactoring 
			model: self model
			variable: variableName
			class: class
			classVariable: true.
	accessorsRefactoring newName: newName.

"$QA Ignore:Direct state variable access(class, variableName, newName, accessorsRefactoring)$"
			!

rename: aVarName to: aName in: aClass 
	super 
		rename: aVarName
		to: aName
		in: aClass.
	self initializeAccessorsRefactoring!

transform
	"Find the accessors, if present, then change the instvar, then rename any accessors found.  We must find the accessors first before the instVar renaming makes them more complicated to detect.  We cannot both find and rename them before the super transform, because its call of #performChange:around: partially hides uneffected prior changes, so it renames the instVar in the renamed accessors but then cannot find their protocols to recompile them."

	accessorsRefactoring setGetterMethod.
	accessorsRefactoring setSetterMethod.
	super transform.
	self performComponentRefactoring: accessorsRefactoring.
			! !
!RenameClassVariableAndAccessorsRefactoring categoriesFor: #initializeAccessorsRefactoring!initialize-release!public! !
!RenameClassVariableAndAccessorsRefactoring categoriesFor: #rename:to:in:!initialize/release!public! !
!RenameClassVariableAndAccessorsRefactoring categoriesFor: #transform!public!transform! !

