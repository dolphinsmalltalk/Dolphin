"Filed out from Dolphin Smalltalk"!

RBAbstractClass subclass: #RBClass
	instanceVariableNames: 'classVariableNames poolDictionaryNames category'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBClass guid: (GUID fromString: '{e6a15c71-6c8c-437d-856c-42cd447df930}')!
RBClass comment: 'RBClass represents a Class.

Instance Variables:
	category	<Symbol>	name of the category that the class should be compiled in
	classVariableNames	<SequenceableCollection of: Symbol>	class variables defined by the class
	poolDictionaryNames	<Collection of: Symbol>	pool variables included by the class'!
!RBClass categoriesForClass!Refactory-Model! !
!RBClass methodsFor!

addClassVariable: aString 
	self privateClassVariableNames add: aString asSymbol.
	model addClassVariable: aString to: self!

addPoolDictionary: aString 
	self privatePoolDictionaryNames add: aString asSymbol.
	model addPool: aString to: self!

allClassVariableNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [self classVariableNames]
		ifFalse: [sprClass allClassVariableNames , self classVariableNames]!

allPoolDictionaryNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [self poolDictionaryNames]
		ifFalse: [sprClass allPoolDictionaryNames , self poolDictionaryNames]!

category
	^category isNil 
		ifTrue: [model environment whichCategoryIncludes: self name]
		ifFalse: [category]!

category: aSymbol 
	category := aSymbol!

classVariableNames
	^self privateClassVariableNames copy!

classVariableNames: aCollectionOfStrings 
	classVariableNames := (aCollectionOfStrings 
				collect: [:each | each asSymbol]) asOrderedCollection!

definitionString
	| definitionStream |
	#rbFix.	"Refactor out definition printing and take account of variable, bytes, class instance variables, etc"
	definitionStream := WriteStream on: String new.
	self printDefinitionOn: definitionStream.
	^definitionStream contents!

directlyDefinesClassVariable: aString
	^self privateClassVariableNames includes: aString asSymbol!

directlyDefinesPoolDictionary: aString 
	^self poolDictionaryNames includes: aString asSymbol!

getPoolDictionaryNames
	#rbFix.	"Dolphin stores the pool names in its classes, rather than the pools themselves."
	^self realClass sharedPoolNames
	"sharedPools collect: [:each | Smalltalk keyAtValue: each]"!

isMeta
	^false!

kindOfSubclass
	"Private - Answer a string describing the kind of subclassing method used to create the receiver 
	(part of its definition)."

	^self isVariable 
		ifTrue: [self isBytes ifTrue: ['variableByteSubclass:'] ifFalse: ['variableSubclass:']]
		ifFalse: ['subclass:']!

nonMetaclass
	^self!

poolDictionaryNames
	^self privatePoolDictionaryNames copy!

poolDictionaryNames: aCollectionOfStrings 
	poolDictionaryNames := (aCollectionOfStrings 
				collect: [:each | each asSymbol]) asOrderedCollection!

printDefinitionOn: puttableStream 
	puttableStream
		nextPutAll: self superclass name;
		space;
		nextPutAll: self kindOfSubclass;
		space;
		print: self name;
		crtab;
		nextPutAll: 'instanceVariableNames: '''.
	self instanceVariableNames do: 
			[:each | 
			puttableStream
				space;
				nextPutAll: each].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'classVariableNames: '''.
	self classVariableNames do: 
			[:each | 
			puttableStream
				space;
				nextPutAll: each].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'poolDictionaries: '''.
	self poolDictionaryNames do: 
			[:each | 
			puttableStream
				space;
				nextPutAll: each].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'classInstanceVariableNames: '''.
	self metaclass instanceVariableNames do: 
			[:each | 
			puttableStream
				space;
				nextPutAll: each].
	puttableStream nextPut: $'!

privateClassVariableNames
	(classVariableNames isNil and: [self isDefined])
		ifTrue: [self classVariableNames: self realClass classVarNames].
	^classVariableNames!

privatePoolDictionaryNames
	(self isDefined and: [poolDictionaryNames isNil]) 
		ifTrue: 
			[#rbFix.	"Extract to #getPoolDictionaryName methods"
			self poolDictionaryNames: self getPoolDictionaryNames].
	^poolDictionaryNames!

realName: aSymbol 
	self realClass: (Smalltalk at: aSymbol)!

removeClassVariable: aString 
	self privateClassVariableNames remove: aString asSymbol.
	model removeClassVariable: aString from: self!

removePoolDictionary: aString 
	self privatePoolDictionaryNames remove: aString asSymbol!

renameClassVariable: oldName to: newName around: aBlock 
	self privateClassVariableNames 
		at: (self privateClassVariableNames indexOf: oldName asSymbol)
		put: newName asSymbol.
	model 
		renameClassVariable: oldName
		to: newName
		in: self
		around: aBlock!

sharedPools
	^self allPoolDictionaryNames 
		collect: [:each | Smalltalk at: each asSymbol ifAbsent: [Dictionary new]]! !
!RBClass categoriesForMethods!
addClassVariable:!public!variable accessing! !
addPoolDictionary:!public!variable accessing! !
allClassVariableNames!accessing!public! !
allPoolDictionaryNames!accessing!public! !
category!accessing!public! !
category:!accessing!public! !
classVariableNames!accessing!public! !
classVariableNames:!accessing!public! !
definitionString!accessing!public! !
directlyDefinesClassVariable:!public!testing! !
directlyDefinesPoolDictionary:!public!testing! !
getPoolDictionaryNames!helpers!private! !
isMeta!public!testing! !
kindOfSubclass!class hierarchy-testing!private! !
nonMetaclass!accessing!public! !
poolDictionaryNames!accessing!public! !
poolDictionaryNames:!accessing!public! !
printDefinitionOn:!accessing!public! !
privateClassVariableNames!private! !
privatePoolDictionaryNames!private! !
realName:!initialize/release!public! !
removeClassVariable:!public!variable accessing! !
removePoolDictionary:!public!variable accessing! !
renameClassVariable:to:around:!public!variable accessing! !
sharedPools!accessing!public! !
!

!RBClass class methodsFor!

existingNamed: aSymbol 
	^(self named: aSymbol)
		realName: aSymbol;
		yourself!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!RBClass class categoriesForMethods!
existingNamed:!instance creation!public! !
named:!instance creation!public! !
!

