"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Refactory.Browser.MultiEnvironment'
	instanceVariableNames: 'environmentDictionaries'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.MultiEnvironment guid: (Core.GUID fromString: '{402838a2-3847-41d1-bfba-ef695abb9d9d}')!

Refactory.Browser.MultiEnvironment comment: 'MultiEnvironment is a special environment for the "Method defined in all subclasses, but not in superclass" lint rule. It''s basically a hack to get a browser to display the results.

Instance Variables:
	environmentDictionaries	<Dictionary key: String value: BrowserEnvironment>	the individual results from each failure. Each value stores the methods that are defined in the subclasses'!

!Refactory.Browser.MultiEnvironment categoriesForClass!Refactory-Environments! !

!Refactory.Browser.MultiEnvironment methodsFor!

addClass: aClass into: aValue
	(environmentDictionaries at: aValue ifAbsentPutClean: [SelectorEnvironment new]) addClass: aClass!

addClass: aClass selector: aSymbol into: aValue
	(environmentDictionaries at: aValue ifAbsentPutClean: [SelectorEnvironment new]) addClass: aClass
		selector: aSymbol!

definesClass: aClass
	^environmentDictionaries anySatisfy: [:each | each definesClass: aClass]!

environmentNamed: aString
	^environmentDictionaries at: aString ifAbsent: [SelectorEnvironment new]!

environments
	^environmentDictionaries keys!

includesClass: aClass 
	#rbFix.	"Added"
	^environmentDictionaries anySatisfy: [:each | each includesClass: aClass]!

includesSelector: aSelector in: aClass 
	#rbFix.	"Added"
	^(environment includesSelector: aSelector in: aClass) and: 
			[environmentDictionaries anySatisfy: [:each | each includesSelector: aSelector in: aClass]]!

initialize
	super initialize.
	environmentDictionaries := Dictionary new.
	environment := SelectorEnvironment new!

isEmpty
	^environmentDictionaries isEmpty!

problemCount
	^environmentDictionaries size!

removeClass: aClass into: aValue
	(environmentDictionaries at: aValue ifAbsent: [SelectorEnvironment new]) removeClass: aClass!

removeClass: aClass selector: aSelector into: aValue
	(environmentDictionaries at: aValue ifAbsentPutClean: [SelectorEnvironment new]) removeClass: aClass
		selector: aSelector!

selectEnvironment: aValue
	environment := environmentDictionaries at: aValue ifAbsent: [SelectorEnvironment new]! !

!Refactory.Browser.MultiEnvironment categoriesForMethods!
addClass:into:!adding!public! !
addClass:selector:into:!adding!public! !
definesClass:!public!testing! !
environmentNamed:!accessing!public! !
environments!accessing!public! !
includesClass:!public!testing! !
includesSelector:in:!public!testing! !
initialize!initialize/release!public! !
isEmpty!public!testing! !
problemCount!accessing!public! !
removeClass:into:!public!removing! !
removeClass:selector:into:!public!removing! !
selectEnvironment:!accessing!public! !
!

