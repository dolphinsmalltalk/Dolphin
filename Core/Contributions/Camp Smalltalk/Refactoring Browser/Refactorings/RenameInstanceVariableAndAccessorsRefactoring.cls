"Filed out from Dolphin Smalltalk 7"!

RenameInstanceVariableRefactoring subclass: #RenameInstanceVariableAndAccessorsRefactoring
	instanceVariableNames: 'accessorsRefactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RenameInstanceVariableAndAccessorsRefactoring guid: (GUID fromString: '{9d161ae8-1686-4173-b598-1114660c578b}')!
RenameInstanceVariableAndAccessorsRefactoring comment: ''!
!RenameInstanceVariableAndAccessorsRefactoring categoriesForClass!Unclassified! !
!RenameInstanceVariableAndAccessorsRefactoring methodsFor!

initializeAccessorsRefactoring

	accessorsRefactoring :=
		RenameAccessorsForVariableRefactoring 
			model: self model
			variable: variableName
			class: class
			classVariable: false.
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
!RenameInstanceVariableAndAccessorsRefactoring categoriesFor: #initializeAccessorsRefactoring!initialize-release!public! !
!RenameInstanceVariableAndAccessorsRefactoring categoriesFor: #rename:to:in:!initialize/release!public! !
!RenameInstanceVariableAndAccessorsRefactoring categoriesFor: #transform!public!transform! !

