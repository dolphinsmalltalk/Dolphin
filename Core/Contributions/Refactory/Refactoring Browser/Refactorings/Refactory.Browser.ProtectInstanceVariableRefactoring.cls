"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.VariableRefactoring subclass: #'Refactory.Browser.ProtectInstanceVariableRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ProtectInstanceVariableRefactoring guid: (Core.GUID fromString: '{5175a912-5f59-47e5-ab30-66893c7043e5}')!
Refactory.Browser.ProtectInstanceVariableRefactoring comment: ''!
!Refactory.Browser.ProtectInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ProtectInstanceVariableRefactoring methodsFor!

getterSetterMethods
	| matcher |
	matcher := ParseTreeSearcher new.
	matcher
		answer: Set new;
		matchesAnyMethodOf: {'`method ^' , variableName.
					'`method: `arg <1s> := `arg' expandMacrosWith: variableName.
					'`method: `arg ^<1s> := `arg' expandMacrosWith: variableName}
			do: 
				[:aNode :answer |
				(class subclassRedefines: aNode selector) ifFalse: [answer add: aNode selector].
				answer].
	(class whichSelectorsReferToInstanceVariable: variableName) do: 
			[:each |
			self
				checkClass: class
				selector: each
				using: matcher].
	^matcher answer!

inline: aSelector
	self onError: 
			[self performComponentRefactoring: (InlineAllSendersRefactoring
						model: self model
						sendersOf: aSelector
						in: class)]
		do: []!

preconditions
	^RBCondition definesInstanceVariable: variableName in: class!

transform
	self setOption: #inlineExpression toUse: [:ref :string | true].
	self getterSetterMethods do: [:each | self inline: each]! !
!Refactory.Browser.ProtectInstanceVariableRefactoring categoriesFor: #getterSetterMethods!accessing!private! !
!Refactory.Browser.ProtectInstanceVariableRefactoring categoriesFor: #inline:!public!transforming! !
!Refactory.Browser.ProtectInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.ProtectInstanceVariableRefactoring categoriesFor: #transform!public!transforming! !

