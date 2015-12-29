"Filed out from Dolphin Smalltalk 2000 release 5.00"!

Object subclass: #LintRuleTest
	instanceVariableNames: 'name foo1'
	classVariableNames: 'Foo1'
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
LintRuleTest guid: (GUID fromString: '{AE7FF107-496E-46A9-8127-3CC651C7CCF7}')!
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
!LintRuleTest categoriesFor: #failedRules!*-unclassified!private! !
!LintRuleTest categoriesFor: #hasConflicts!public!testing! !
!LintRuleTest categoriesFor: #initialize!initialize/release!public! !
!LintRuleTest categoriesFor: #isComposite!public!testing! !
!LintRuleTest categoriesFor: #isEmpty!*-subclass responsibility!public!testing! !
!LintRuleTest categoriesFor: #junk!public!testing! !
!LintRuleTest categoriesFor: #name!accessing!public! !
!LintRuleTest categoriesFor: #name:!accessing!public! !
!LintRuleTest categoriesFor: #openEditor!*-compilation failures!accessing!public! !
!LintRuleTest categoriesFor: #printOn:!printing!public! !
!LintRuleTest categoriesFor: #problemCount!*-subclass responsibility!accessing!public! !
!LintRuleTest categoriesFor: #resetResult!initialize/release!public! !
!LintRuleTest categoriesFor: #run!*-compilation failures!accessing!public! !
!LintRuleTest categoriesFor: #runOnEnvironment:!*-compilation failures!accessing!public! !
!LintRuleTest categoriesFor: #viewResults!*-subclass responsibility!*-unclassified!private! !

!LintRuleTest class methodsFor!

new
	^super new initialize! !
!LintRuleTest class categoriesFor: #new!instance creation!public! !

