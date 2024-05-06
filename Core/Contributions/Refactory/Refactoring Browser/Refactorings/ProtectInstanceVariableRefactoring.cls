"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #ProtectInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProtectInstanceVariableRefactoring guid: (GUID fromString: '{5175a912-5f59-47e5-ab30-66893c7043e5}')!

ProtectInstanceVariableRefactoring comment: ''!

!ProtectInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !

!ProtectInstanceVariableRefactoring methodsFor!

getterSetterMethods
	| matcher |
	matcher := ParseTreeSearcher new.
	matcher
		answer: Set new;
		matchesAnyMethodOf: (Array 
					with: '`method ^' , variableName
					with: ('`method: `arg <1s> := `arg' expandMacrosWith: variableName)
					with: ('`method: `arg ^<1s> := `arg' expandMacrosWith: variableName))
			do: 
				[:aNode :answer | 
				(class subclassRedefines: aNode selector) 
					ifFalse: [answer add: aNode selector].
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

!ProtectInstanceVariableRefactoring categoriesForMethods!
getterSetterMethods!accessing!private! !
inline:!public!transforming! !
preconditions!preconditions!public! !
transform!public!transforming! !
!

