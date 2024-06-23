"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.ProtectInstanceVariableRefactoring'
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
			[| inlineSenders |
			inlineSenders := InlineAllSendersRefactoring
						model: self model
						sendersOf: aSelector
						in: class.
			"We are attempting to inline a method that returns the instance variable that is being protected. Inlining involves first replacing the self sends with the body of the inline method, and then removing the method.However, If the selector of the inlined method is sent elsewhere, then removing the method would not be behaviour preserving. In the standard RB implementation this precondition is handled by raising a RefactoringWarning which is just trapped with the effect that inline refactoring is aborted halfway through without having removed the method. This preserves behaviour, but means that the 'protect' is not really complete. It seems that a deliberate choice was made to proceed here, rather than aborting the entire refactoring, perhaps because the operation is still useful with this final state and/or just too likely to fail if the the existance of senders of a current accessor were to be treated as a precondition for the 'protect'. In Dolphin we could do something different here since the normal warning for senders has been replaced with a refactoring option. The handler for the option can choose to return false to abort the refactoring, or true to continue it, which in this case would remove the accessor regardless of senders. The latter behaviour is in place to allow a normal 'Remove Method' refactoring to be used for all method deletes - the user can choose to ignore that it is not behaviour preserving. However, since the removal here is a component of a larger refactoring, it may be difficult for the user to understand the consequences of the 'continue' option when offered. Another possibility would be to raise a warning that the accessor could not be removed. This would maintain the safety of the refactoring and provide the user with more information. For now, however, we will emulate the default RB behaviour of completing the 'protect' without removing any accessors that might be in use. A small difference is that a message will be written to the Transcript, but this is likely to be missed.."
			inlineSenders setOption: #removeReferencedSelector toUse: [:ref :symbol :references | 
				#todo. "Raise a notification here (could be suppressible) that the accessor will not be removed because it has references."
				"Abort the remove part of the inline for this particular selector"
				false].
			self performComponentRefactoring: inlineSenders]
		do: [:ex | ex toTrace]!

preconditions
	^RBCondition definesInstanceVariable: variableName in: class!

transform
	self setOption: #inlineExpression toUse: [:ref :string | true].
	self getterSetterMethods do: [:each | self inline: each]! !

!Refactory.Browser.ProtectInstanceVariableRefactoring categoriesForMethods!
getterSetterMethods!accessing!private! !
inline:!public!transforming! !
preconditions!preconditions!public! !
transform!public!transforming! !
!

