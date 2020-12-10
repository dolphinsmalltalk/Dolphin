"Filed out from Dolphin Smalltalk 7"!

Tools.ClassBrowserPlugin subclass: #'Tools.SmalllintPlugin'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalllintPlugin guid: (Core.GUID fromString: '{321fcbfb-84d2-40ae-bf8f-f4b816723a1b}')!
Tools.SmalllintPlugin isNonInstantiable: true!
Tools.SmalllintPlugin comment: ''!
!Tools.SmalllintPlugin categoriesForClass!MVP-Presenters! !
!Tools.SmalllintPlugin methodsFor!

browserEnvironment
	^self browser selectionEnvironment!

checkerForRule: aLintRule environment: env 
	^(SmalllintChecker newWithCachingContext)
		rule: aLintRule;
		environment: env;
		yourself!

methodFilterForRule: aLintRule inEnvironment: aBrowserEnvironment
	^
	[:method |
	(aBrowserEnvironment includesMethod: method) and: 
			[(self checkerForRule: aLintRule
				environment: (SelectorEnvironment
						onMethods: {method selector}
						forClass: method methodClass
						in: aBrowserEnvironment))
					run.
			aLintRule failedMethods notEmpty]]!

runRule: aLintRule
	| checker env |
	env := self browserEnvironment.
	checker := self checkerForRule: aLintRule environment: env.
	^env numberClasses > 20
		ifTrue: 
			[| progress |
			progress := ProgressDialog create.
			progress
				caption: 'Running Rule... ';
				text: aLintRule name.
			progress operation: 
					[:progressPresenter |
					| checkedSoFar numberSelectors |
					numberSelectors := env numberSelectors.
					checkedSoFar := 0.0.
					checker
						methodBlock: 
								[checkedSoFar := checkedSoFar + 1.
								progressPresenter value: (checkedSoFar / numberSelectors * 100) asInteger];
						run].
			progress showModal]
		ifFalse: [Cursor wait showWhile: [checker run]]!

runTransformation: aTransformationRule
	(self runRule: aTransformationRule) isNil
		ifFalse: [RewriteChangesBrowser showOn: aTransformationRule changes]!

status: text 
	^self browser statusText: text!

systemModel
	"Private - Answer the development system model."

	^Smalltalk developmentSystem! !
!Tools.SmalllintPlugin categoriesFor: #browserEnvironment!operations!private! !
!Tools.SmalllintPlugin categoriesFor: #checkerForRule:environment:!helpers!private! !
!Tools.SmalllintPlugin categoriesFor: #methodFilterForRule:inEnvironment:!helpers!private! !
!Tools.SmalllintPlugin categoriesFor: #runRule:!helpers!private! !
!Tools.SmalllintPlugin categoriesFor: #runTransformation:!helpers!private! !
!Tools.SmalllintPlugin categoriesFor: #status:!operations!private! !
!Tools.SmalllintPlugin categoriesFor: #systemModel!commands!private! !

