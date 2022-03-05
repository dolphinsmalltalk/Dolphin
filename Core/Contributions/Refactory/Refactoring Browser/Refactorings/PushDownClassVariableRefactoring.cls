"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #PushDownClassVariableRefactoring
	instanceVariableNames: 'destinationClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushDownClassVariableRefactoring guid: (GUID fromString: '{e2937b6b-aa4b-4464-8c56-b8b005f6c4f9}')!
PushDownClassVariableRefactoring comment: ''!
!PushDownClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!PushDownClassVariableRefactoring methodsFor!

findDestinationClass
	| classVarName classes |
	classVarName := variableName asSymbol.
	classes := class withAllSubclasses reject: 
					[:each | 
					(each whichSelectorsReferToClassVariable: classVarName) isEmpty and: 
							[(each metaclass whichSelectorsReferToClassVariable: classVarName) isEmpty]].
	destinationClass := classes isEmpty ifTrue: [nil] ifFalse: [classes first].
	classes do: 
			[:each | 
			(destinationClass includesClass: each) 
				ifTrue: [destinationClass := each]
				ifFalse: 
					[(each includesClass: destinationClass) 
						ifFalse: [self signalMultipleReferenceError]]].
	destinationClass = class ifTrue: [self signalStillReferencedError].
	^destinationClass!

preconditions
	"Preconditions are that only one subclass refers to the class variable."

	^(RBCondition definesClassVariable: variableName in: class) 
		& (RBCondition withBlock: 
					[self findDestinationClass.
					true])!

signalMultipleReferenceError
	self signalReferenceError: ('Multiple subclasses reference <1s>' 
				expandMacrosWith: variableName)!

signalReferenceError: errorString 
	class realClass isNil 
		ifTrue: [self refactoringError: errorString]
		ifFalse: 
			[| classVarName error |
			error := '<1s><n>Browse references?' expandMacrosWith: errorString.
			classVarName := variableName asSymbol.
			self refactoringError: error
				with: 
					[#rbFix.	"Should only browse references within the environment visible to the refactoring here"
					self openBrowserOn: (self model environment classVarRefsTo: classVarName in: class realClass)]]!

signalStillReferencedError
	self signalReferenceError: ('<1p> has references to <2s>' 
				expandMacrosWith: class
				with: variableName)!

transform
	class removeClassVariable: variableName.
	destinationClass isNil ifTrue: [^self].
	destinationClass addClassVariable: variableName! !
!PushDownClassVariableRefactoring categoriesForMethods!
findDestinationClass!preconditions!public! !
preconditions!preconditions!public! !
signalMultipleReferenceError!preconditions!public! !
signalReferenceError:!preconditions!public! !
signalStillReferencedError!preconditions!public! !
transform!public!transforming! !
!

