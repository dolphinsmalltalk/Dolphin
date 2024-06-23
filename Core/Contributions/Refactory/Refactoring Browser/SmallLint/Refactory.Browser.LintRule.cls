"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.LintRule'
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.LintRule guid: (Core.GUID fromString: '{0a5056c9-9803-42b3-9c34-5bf472b5d967}')!

Refactory.Browser.LintRule isNonInstantiable: true!

Refactory.Browser.LintRule comment: 'LintRule is an abstract class that represents some check on the code.

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

!Refactory.Browser.LintRule categoriesForClass!Refactory-Lint! !

!Refactory.Browser.LintRule methodsFor!

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
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

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

!Refactory.Browser.LintRule categoriesForMethods!
allRules!accessing!public! !
checkClass:!accessing!public! !
checkMethod:!accessing!public! !
displayName!printing!public! !
displayOn:!printing!public! !
failedMethodsSorted!accessing!private! !
failedRules!private! !
hasConflicts!public!testing! !
initialize!initialize/release!public! !
isComposite!public!testing! !
isEmpty!public!testing! !
name!accessing!public! !
name:!accessing!public! !
notEmpty!public!testing! !
printOn:!printing!public! !
problemCount!accessing!public! !
resetResult!initialize/release!public! !
rules!accessing!public! !
viewResults!private! !
!

!Refactory.Browser.LintRule class methodsFor!

new
	^super new initialize! !

!Refactory.Browser.LintRule class categoriesForMethods!
new!instance creation!public! !
!

