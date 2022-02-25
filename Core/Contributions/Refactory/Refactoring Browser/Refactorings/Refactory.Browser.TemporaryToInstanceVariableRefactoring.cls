"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring subclass: #'Refactory.Browser.TemporaryToInstanceVariableRefactoring'
	instanceVariableNames: 'selector temporaryVariableName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.TemporaryToInstanceVariableRefactoring guid: (Core.GUID fromString: '{c0ad3ff1-c5d3-48f7-9104-4ee2542c6ba6}')!
Refactory.Browser.TemporaryToInstanceVariableRefactoring comment: ''!
!Refactory.Browser.TemporaryToInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.TemporaryToInstanceVariableRefactoring methodsFor!

checkForValidTemporaryVariable
	| parseTree |
	parseTree := class parseTreeFor: selector.
	(parseTree allTemporaryVariables includes: temporaryVariableName)
		ifFalse: [self refactoringError: temporaryVariableName , ' isn''t a valid temporary variable name'].
	(parseTree allArgumentVariables includes: temporaryVariableName)
		ifTrue: [self refactoringError: temporaryVariableName , ' is a block parameter'].
	((RBReadBeforeWrittenTester isVariable: temporaryVariableName readBeforeWrittenIn: parseTree)
		and: [(self shouldConvertReadBeforeWritten: temporaryVariableName) not])
			ifTrue: [self refactoringAborted]!

class: aClass selector: aSelector variable: aVariableName 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	temporaryVariableName := aVariableName.
	class := self classObjectFor: aClass.
!

preconditions
	^(RBCondition definesSelector: selector in: class) 
		& (RBCondition hierarchyOf: class
				definesVariable: temporaryVariableName asString) not 
			& (RBCondition withBlock: 
						[self checkForValidTemporaryVariable.
						true])!

shouldConvertReadBeforeWritten: aString
	^(self lookupOption: #convertReadBeforeWritten) cull: self cull: aString!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: ';
		print: selector;
		nextPutAll: ' variable: ''';
		nextPutAll: temporaryVariableName;
		nextPut: $'.
	aStream nextPut: $)!

transform
	| method parseTree matcher |
	method := class methodFor: selector.
	parseTree := method parseTree.
	parseTree isNil ifTrue: [self refactoringError: 'Could not parse method'].
	"Note that it is not necessary to remove the method first - it is not an error to shadow an inst var with a temp"
	class addInstanceVariable: temporaryVariableName.
	(matcher := ParseTreeRewriter removeTemporaryNamed: temporaryVariableName) executeTree: parseTree.
	"We must maintain any custom packaging or namespace of the original method, or the new method may not compile"
	model compileTree: matcher tree forMethod: method! !
!Refactory.Browser.TemporaryToInstanceVariableRefactoring categoriesForMethods!
checkForValidTemporaryVariable!preconditions!public! !
class:selector:variable:!initialize/release!public! !
preconditions!preconditions!public! !
shouldConvertReadBeforeWritten:!private!requests! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.TemporaryToInstanceVariableRefactoring class methodsFor!

class: aClass selector: aSelector variable: aVariableName 
	^self new 
		class: aClass
		selector: aSelector
		variable: aVariableName!

model: aRBModel class: aClass selector: aSelector variable: aVariableName
	^self new
		model: aRBModel;
		class: aClass
			selector: aSelector
			variable: aVariableName;
		yourself! !
!Refactory.Browser.TemporaryToInstanceVariableRefactoring class categoriesForMethods!
class:selector:variable:!instance creation!public! !
model:class:selector:variable:!instance creation!public! !
!

