"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.TestData.LintRuleTestData'
	instanceVariableNames: 'name foo1'
	classVariableNames: 'Foo1'
	imports: #(#{OS.CRTConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.TestData.LintRuleTestData guid: (Core.GUID fromString: '{ae7ff107-496e-46a9-8127-3cc651c7ccf7}')!
Refactory.Browser.TestData.LintRuleTestData isNonInstantiable: true!
Refactory.Browser.TestData.LintRuleTestData comment: ''!
!Refactory.Browser.TestData.LintRuleTestData categoriesForClass!Refactory-Test data! !
!Refactory.Browser.TestData.LintRuleTestData methodsFor!

checkClass: aSmalllintContext!

checkMethod: aSmalllintContext!

displayName
	| nameStream |
	nameStream := WriteStream on: (String new: 64).
	nameStream
		nextPutAll: self name;
		nextPutAll: ' ('.
	self problemCount printOn: nameStream.
	nameStream nextPut: $).
	^nameStream contents!

failedRules
	^self isEmpty ifTrue: [#()] ifFalse: [Array with: self]!

hasConflicts
	^false!

initialize
	name := ''!

isComposite
	^false!

isEmpty
	self subclassResponsibility!

junk
	^RefactoryTestDataApp printString copyFrom: 1 to: _EM_INVALID!

name
	^name!

name: aString 
	name := aString!

openEditor
	<namespace: Tools>
	| rules |
	rules := self failedRules.
	rules isEmpty ifTrue: [^self].
	rules size == 1 ifTrue: [^rules first viewResults].
	self result openEditor!

printOn: aStream 
	name isNil
		ifTrue: [super printOn: aStream]
		ifFalse: [aStream nextPutAll: name]!

problemCount
	^self subclassResponsibility!

resetResult!

run
	^Smalllint runRule: self!

runOnEnvironment: anEnvironment
	^Smalllint runRule: (#{BlockLintRule} value perform: self name) onEnvironment: anEnvironment!

viewResults
	self subclassResponsibility! !
!Refactory.Browser.TestData.LintRuleTestData categoriesForMethods!
checkClass:!accessing!public! !
checkMethod:!accessing!public! !
displayName!accessing!public! !
failedRules!private! !
hasConflicts!public!testing! !
initialize!initialize/release!public! !
isComposite!public!testing! !
isEmpty!public!testing! !
junk!public!testing! !
name!accessing!public! !
name:!accessing!public! !
openEditor!accessing!public! !
printOn:!printing!public! !
problemCount!accessing!public! !
resetResult!initialize/release!public! !
run!accessing!public! !
runOnEnvironment:!accessing!public! !
viewResults!private! !
!

!Refactory.Browser.TestData.LintRuleTestData class methodsFor!

new
	^super new initialize! !
!Refactory.Browser.TestData.LintRuleTestData class categoriesForMethods!
new!instance creation!public! !
!

