"Filed out from Dolphin Smalltalk"!

ClassBrowserPlugin subclass: #SmalllintPlugin
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalllintPlugin guid: (GUID fromString: '{321fcbfb-84d2-40ae-bf8f-f4b816723a1b}')!
SmalllintPlugin isAbstract: true!
SmalllintPlugin comment: ''!
!SmalllintPlugin categoriesForClass!MVP-Presenters! !
!SmalllintPlugin methodsFor!

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
						onMethods: (Array with: method selector)
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
!SmalllintPlugin categoriesForMethods!
browserEnvironment!operations!private! !
checkerForRule:environment:!helpers!private! !
methodFilterForRule:inEnvironment:!helpers!private! !
runRule:!helpers!private! !
runTransformation:!helpers!private! !
status:!operations!private! !
systemModel!commands!private! !
!

