"Filed out from Dolphin Smalltalk 7"!

Object subclass: #LintRuleTest
	instanceVariableNames: 'name foo1'
	classVariableNames: 'Foo1'
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
LintRuleTest guid: (GUID fromString: '{ae7ff107-496e-46a9-8127-3cc651c7ccf7}')!
LintRuleTest isAbstract: true!
LintRuleTest comment: ''!
!LintRuleTest categoriesForClass!Refactory-Test data! !
!LintRuleTest methodsFor!

checkClass: aSmalllintContext!

checkMethod: aSmalllintContext!

displayName
	| nameStream |
	nameStream := WriteStream on: (String new: 64).
	nameStream nextPutAll: self name;
		nextPutAll: ' ('.
	self problemCount printOn: nameStream.
	nameStream nextPut: $).
	^nameStream contents!

failedRules
	^self isEmpty
		ifTrue: [#()]
		ifFalse: [Array with: self]!

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
	| rules |
	rules := self failedRules.
	rules isEmpty ifTrue: [^self].
	rules size == 1 ifTrue: [^rules first viewResults].
	SmalllintResultEditor openOn: self label: name!

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
	^Smalllint runRule: self onEnvironment: anEnvironment!

viewResults
	self subclassResponsibility! !
!LintRuleTest categoriesFor: #checkClass:!accessing!public! !
!LintRuleTest categoriesFor: #checkMethod:!accessing!public! !
!LintRuleTest categoriesFor: #displayName!accessing!public! !
!LintRuleTest categoriesFor: #failedRules!private! !
!LintRuleTest categoriesFor: #hasConflicts!public!testing! !
!LintRuleTest categoriesFor: #initialize!initialize/release!public! !
!LintRuleTest categoriesFor: #isComposite!public!testing! !
!LintRuleTest categoriesFor: #isEmpty!public!testing! !
!LintRuleTest categoriesFor: #junk!public!testing! !
!LintRuleTest categoriesFor: #name!accessing!public! !
!LintRuleTest categoriesFor: #name:!accessing!public! !
!LintRuleTest categoriesFor: #openEditor!accessing!public! !
!LintRuleTest categoriesFor: #printOn:!printing!public! !
!LintRuleTest categoriesFor: #problemCount!accessing!public! !
!LintRuleTest categoriesFor: #resetResult!initialize/release!public! !
!LintRuleTest categoriesFor: #run!accessing!public! !
!LintRuleTest categoriesFor: #runOnEnvironment:!accessing!public! !
!LintRuleTest categoriesFor: #viewResults!private! !

!LintRuleTest class methodsFor!

new
	^super new initialize! !
!LintRuleTest class categoriesFor: #new!instance creation!public! !

