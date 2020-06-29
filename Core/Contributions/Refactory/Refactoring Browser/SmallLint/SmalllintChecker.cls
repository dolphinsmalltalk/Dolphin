"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SmalllintChecker
	instanceVariableNames: 'rule environment context methodBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SmalllintChecker guid: (GUID fromString: '{b66e8888-4615-4250-b1d6-66ec532f9df1}')!
SmalllintChecker comment: ''!
!SmalllintChecker categoriesForClass!Refactory-Lint! !
!SmalllintChecker methodsFor!

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
!SmalllintChecker categoriesFor: #checkClass:!private! !
!SmalllintChecker categoriesFor: #checkMethodsForClass:!private! !
!SmalllintChecker categoriesFor: #context:!accessing!public! !
!SmalllintChecker categoriesFor: #environment:!accessing!public! !
!SmalllintChecker categoriesFor: #initialize!initialize/release!public! !
!SmalllintChecker categoriesFor: #methodBlock:!accessing!public! !
!SmalllintChecker categoriesFor: #release!initialize/release!public! !
!SmalllintChecker categoriesFor: #rule:!accessing!public! !
!SmalllintChecker categoriesFor: #run!actions!public! !

!SmalllintChecker class methodsFor!

new
	^(super new)
		initialize;
		yourself!

newWithContext
	^(self new)
		context: SmalllintContext new;
		yourself!

runRule: aLintRule onEnvironment: aBrowserEnvironment 
	(self new)
		rule: aLintRule;
		environment: aBrowserEnvironment;
		run.
	^aLintRule! !
!SmalllintChecker class categoriesFor: #new!instance creation!public! !
!SmalllintChecker class categoriesFor: #newWithContext!instance creation!public! !
!SmalllintChecker class categoriesFor: #runRule:onEnvironment:!instance creation!public! !

