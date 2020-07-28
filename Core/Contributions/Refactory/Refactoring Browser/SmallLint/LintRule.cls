"Filed out from Dolphin Smalltalk 7"!

Object subclass: #LintRule
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LintRule guid: (GUID fromString: '{0a5056c9-9803-42b3-9c34-5bf472b5d967}')!
LintRule isAbstract: true!
LintRule comment: 'LintRule is an abstract class that represents some check on the code.

Subclasses must implement the following messages:
	accessing
		problemCount
			"returns the number of problems this rule found"
	private
		viewResults
			"opens an interface to view the problems"
	testing
		isEmpty
			"did this rule find any problems"

Instance Variables:
	name	<String>	the display name of the rule'!
!LintRule categoriesForClass!Refactory-Lint! !
!LintRule methodsFor!

allRules
	| allRules |
	allRules := OrderedCollection withAll: self rules.
	self rules do: [:each | allRules addAll: each allRules].
	^allRules!

checkClass: aSmalllintContext!

checkMethod: aSmalllintContext!

displayName
	| nameStream |
	#rbFix.	"Refactored so #displayName implemented in terms of #displayOn:, rather than vice versa"
	nameStream := WriteStream on: (Utf8String new: 64).
	self displayOn: nameStream.
	^nameStream contents!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: self name;
		nextPutAll: ' ['.
	self problemCount displayOn: aPuttableStream.
	aPuttableStream nextPut: $]!

failedMethodsSorted
	^self failedMethods asSortedCollection: CompiledMethod defaultSortBlock!

failedRules
	^self isEmpty ifTrue: [#()] ifFalse: [{self}]!

hasConflicts
	^false!

initialize!

isComposite
	^false!

isEmpty
	self subclassResponsibility!

name
	^name!

name: aString 
	name := aString!

notEmpty
	^self isEmpty not!

printOn: aStream 
	name isNil
		ifTrue: [super printOn: aStream]
		ifFalse: [aStream nextPutAll: name]!

problemCount
	^self subclassResponsibility!

resetResult!

rules
	^#()!

viewResults
	self subclassResponsibility! !
!LintRule categoriesFor: #allRules!accessing!public! !
!LintRule categoriesFor: #checkClass:!accessing!public! !
!LintRule categoriesFor: #checkMethod:!accessing!public! !
!LintRule categoriesFor: #displayName!printing!public! !
!LintRule categoriesFor: #displayOn:!printing!public! !
!LintRule categoriesFor: #failedMethodsSorted!accessing!private! !
!LintRule categoriesFor: #failedRules!private! !
!LintRule categoriesFor: #hasConflicts!public!testing! !
!LintRule categoriesFor: #initialize!initialize/release!public! !
!LintRule categoriesFor: #isComposite!public!testing! !
!LintRule categoriesFor: #isEmpty!public!testing! !
!LintRule categoriesFor: #name!accessing!public! !
!LintRule categoriesFor: #name:!accessing!public! !
!LintRule categoriesFor: #notEmpty!public!testing! !
!LintRule categoriesFor: #printOn:!printing!public! !
!LintRule categoriesFor: #problemCount!accessing!public! !
!LintRule categoriesFor: #resetResult!initialize/release!public! !
!LintRule categoriesFor: #rules!accessing!public! !
!LintRule categoriesFor: #viewResults!private! !

!LintRule class methodsFor!

new
	^super new initialize! !
!LintRule class categoriesFor: #new!instance creation!public! !

