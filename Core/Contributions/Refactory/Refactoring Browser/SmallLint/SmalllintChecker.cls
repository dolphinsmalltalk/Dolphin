"Filed out from Dolphin Smalltalk"!

Object subclass: #SmalllintChecker
	instanceVariableNames: 'rule environment context methodBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!SmalllintChecker categoriesForMethods!
checkClass:!private! !
checkMethodsForClass:!private! !
context:!accessing!public! !
environment:!accessing!public! !
initialize!initialize/release!public! !
methodBlock:!accessing!public! !
release!initialize/release!public! !
rule:!accessing!public! !
run!actions!public! !
!

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
!SmalllintChecker class categoriesForMethods!
new!instance creation!public! !
newWithContext!instance creation!public! !
runRule:onEnvironment:!instance creation!public! !
!

