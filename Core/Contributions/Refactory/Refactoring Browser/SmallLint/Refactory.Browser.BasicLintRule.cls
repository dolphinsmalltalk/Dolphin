"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.LintRule subclass: #'Refactory.Browser.BasicLintRule'
	instanceVariableNames: 'result openSymbol'
	classVariableNames: 'FilterDictionary'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.BasicLintRule guid: (Core.GUID fromString: '{b3fa342a-eaee-404e-b9a5-c8bc9276f559}')!
Refactory.Browser.BasicLintRule comment: 'BasicLintRule represents a check on the code.

Instance Variables:
	classBlock	<BlockClosure>	a block that is evaluated for each class that is checked
	methodBlock	<BlockClosure>	a block that is evaluated for each method checked
	result	<Object>	some object that represents the results found (it must understand openEditor, isEmpty, problemCount, and copyEmpty). Most of the time, this is a BrowserEnvironment object.

'!
!Refactory.Browser.BasicLintRule categoriesForClass!Refactory-Lint! !
!Refactory.Browser.BasicLintRule methodsFor!

defaultResultClass
	^SelectorEnvironment!

filteredResult
	^(SmalllintFilterEnvironment onEnvironment: result
		and: (self class filterDictionary at: self name ifAbsent: [result copyEmpty]) copy not)
		label: result label;
		lintRuleName: self name;
		yourself!

initialize
	super initialize.
	openSymbol := #openWithFilters.
	self resultClass: self defaultResultClass!

isEmpty
	^self result isEmpty!

openUsing: aSymbol 
	openSymbol := aSymbol!

openWithFilters
	^self filteredResult openEditor!

openWithoutFilters
	^self result openEditor!

problemCount
	^self result problemCount!

resetResult
	result := result copyEmpty.
	result label: name!

result
	^(self class filterDictionary includesKey: self name) 
		ifTrue: [self filteredResult]
		ifFalse: [result]!

result: aResult 
	result := aResult copyEmpty!

resultClass: aClass 
	result := aClass new!

viewResults
	^self perform: openSymbol! !
!Refactory.Browser.BasicLintRule categoriesFor: #defaultResultClass!constants!private! !
!Refactory.Browser.BasicLintRule categoriesFor: #filteredResult!accessing!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.BasicLintRule categoriesFor: #openUsing:!initialize/release!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #openWithFilters!operations!private! !
!Refactory.Browser.BasicLintRule categoriesFor: #openWithoutFilters!operations!private! !
!Refactory.Browser.BasicLintRule categoriesFor: #problemCount!accessing!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #resetResult!initialize/release!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #result!accessing!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #result:!initialize/release!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #resultClass:!initialize/release!public! !
!Refactory.Browser.BasicLintRule categoriesFor: #viewResults!helpers!private! !

!Refactory.Browser.BasicLintRule class methodsFor!

addFilter: anEnvironment for: aString 
	self filterDictionary at: aString put: anEnvironment copy!

filterDictionary
	^FilterDictionary isNil ifTrue: [FilterDictionary := Dictionary new] ifFalse: [FilterDictionary]!

filterDictionary: aDictionary 
	FilterDictionary := aDictionary!

filterFor: aName
	^self filterDictionary at: aName ifAbsentPut: [SelectorEnvironment new]!

lintProtocols
	#rbFix. "Renamed from #protocols, clash with Dolphin protocols mech."
	^#('bugs' 'possible bugs' 'unnecessary code' 'intention revealing' 'miscellaneous')!

storeFiltersOn: aStream 
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPutAll: ' filterDictionary: (Dictionary new'.
	self filterDictionary keysAndValuesDo: 
			[:key :value | 
			aStream nextPutAll: ' at: '.
			key storeOn: aStream.
			aStream nextPutAll: ' put: '.
			value storeOn: aStream.
			aStream
				nextPutAll: ';';
				cr].
	aStream
		tab;
		nextPutAll: 'yourself))'! !
!Refactory.Browser.BasicLintRule class categoriesFor: #addFilter:for:!accessing!public! !
!Refactory.Browser.BasicLintRule class categoriesFor: #filterDictionary!accessing!public! !
!Refactory.Browser.BasicLintRule class categoriesFor: #filterDictionary:!accessing!public! !
!Refactory.Browser.BasicLintRule class categoriesFor: #filterFor:!accessing!public! !
!Refactory.Browser.BasicLintRule class categoriesFor: #lintProtocols!accessing!public! !
!Refactory.Browser.BasicLintRule class categoriesFor: #storeFiltersOn:!public!storing! !

