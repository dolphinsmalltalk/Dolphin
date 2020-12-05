"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.SmalllintChecker'
	instanceVariableNames: 'rule environment context methodBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.SmalllintChecker guid: (Core.GUID fromString: '{b66e8888-4615-4250-b1d6-66ec532f9df1}')!
Refactory.Browser.SmalllintChecker comment: ''!
!Refactory.Browser.SmalllintChecker categoriesForClass!Refactory-Lint! !
!Refactory.Browser.SmalllintChecker methodsFor!

checkClass: aClass 
	context selectedClass: aClass.
	(environment definesClass: aClass) ifTrue: [rule checkClass: context]!

checkMethodsForClass: aClass 
	^environment selectorsForClass: aClass
		do: 
			[:each | 
			context selector: each.
			rule checkMethod: context.
			methodBlock value]!

context: aSmalllintContext 
	context := aSmalllintContext!

environment: aBrowserEnvironment 
	environment := aBrowserEnvironment!

initialize
	methodBlock := [].
	environment := SelectorEnvironment new.
	context := SmalllintContext newNoCache!

methodBlock: aBlock 
	methodBlock := aBlock!

release
	context release.
	super release!

rule: aLintRule 
	rule := aLintRule!

run
	rule resetResult.
	environment classesDo: 
			[:aClass | 
			self checkClass: aClass.
			self checkMethodsForClass: aClass]! !
!Refactory.Browser.SmalllintChecker categoriesFor: #checkClass:!private! !
!Refactory.Browser.SmalllintChecker categoriesFor: #checkMethodsForClass:!private! !
!Refactory.Browser.SmalllintChecker categoriesFor: #context:!accessing!public! !
!Refactory.Browser.SmalllintChecker categoriesFor: #environment:!accessing!public! !
!Refactory.Browser.SmalllintChecker categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.SmalllintChecker categoriesFor: #methodBlock:!accessing!public! !
!Refactory.Browser.SmalllintChecker categoriesFor: #release!initialize/release!public! !
!Refactory.Browser.SmalllintChecker categoriesFor: #rule:!accessing!public! !
!Refactory.Browser.SmalllintChecker categoriesFor: #run!actions!public! !

!Refactory.Browser.SmalllintChecker class methodsFor!

new
	^(super new)
		initialize;
		yourself!

newWithContext
	^self new
		context: SmalllintContext new;
		yourself!

runRule: aLintRule onEnvironment: aBrowserEnvironment 
	(self new)
		rule: aLintRule;
		environment: aBrowserEnvironment;
		run.
	^aLintRule! !
!Refactory.Browser.SmalllintChecker class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.SmalllintChecker class categoriesFor: #newWithContext!instance creation!public! !
!Refactory.Browser.SmalllintChecker class categoriesFor: #runRule:onEnvironment:!instance creation!public! !

