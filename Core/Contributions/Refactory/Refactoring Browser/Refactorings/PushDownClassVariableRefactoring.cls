"Filed out from Dolphin Smalltalk XP"!

VariableRefactoring subclass: #PushDownClassVariableRefactoring
	instanceVariableNames: 'destinationClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushDownClassVariableRefactoring guid: (GUID fromString: '{E2937B6B-AA4B-4464-8C56-B8B005F6C4F9}')!
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
!PushDownClassVariableRefactoring categoriesFor: #findDestinationClass!preconditions!public! !
!PushDownClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!PushDownClassVariableRefactoring categoriesFor: #signalMultipleReferenceError!preconditions!public! !
!PushDownClassVariableRefactoring categoriesFor: #signalReferenceError:!preconditions!public! !
!PushDownClassVariableRefactoring categoriesFor: #signalStillReferencedError!preconditions!public! !
!PushDownClassVariableRefactoring categoriesFor: #transform!public!transforming! !

