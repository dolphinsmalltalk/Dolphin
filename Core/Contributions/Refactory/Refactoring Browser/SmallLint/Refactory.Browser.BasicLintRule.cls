"Filed out from Dolphin Smalltalk"!

Refactory.Browser.LintRule
	subclass: #'Refactory.Browser.BasicLintRule'
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
!Refactory.Browser.BasicLintRule categoriesForMethods!
defaultResultClass!constants!private! !
filteredResult!accessing!public! !
initialize!initialize/release!public! !
isEmpty!public!testing! !
openUsing:!initialize/release!public! !
openWithFilters!operations!private! !
openWithoutFilters!operations!private! !
problemCount!accessing!public! !
resetResult!initialize/release!public! !
result!accessing!public! !
result:!initialize/release!public! !
resultClass:!initialize/release!public! !
viewResults!helpers!private! !
!

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
!Refactory.Browser.BasicLintRule class categoriesForMethods!
addFilter:for:!accessing!public! !
filterDictionary!accessing!public! !
filterDictionary:!accessing!public! !
filterFor:!accessing!public! !
lintProtocols!accessing!public! !
storeFiltersOn:!public!storing! !
!

