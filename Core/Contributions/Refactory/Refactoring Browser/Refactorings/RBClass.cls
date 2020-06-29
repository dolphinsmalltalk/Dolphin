"Filed out from Dolphin Smalltalk 7"!

RBAbstractClass subclass: #RBClass
	instanceVariableNames: 'classVariableNames poolDictionaryNames category'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
	self realClass: aSymbol asQualifiedReference value!

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
		collect: [:each | each asQualifiedReference valueOrNil ifNil: [Dictionary new]]! !
!RBClass categoriesFor: #addClassVariable:!public!variable accessing! !
!RBClass categoriesFor: #addPoolDictionary:!public!variable accessing! !
!RBClass categoriesFor: #allClassVariableNames!accessing!public! !
!RBClass categoriesFor: #allPoolDictionaryNames!accessing!public! !
!RBClass categoriesFor: #category!accessing!public! !
!RBClass categoriesFor: #category:!accessing!public! !
!RBClass categoriesFor: #classVariableNames!accessing!public! !
!RBClass categoriesFor: #classVariableNames:!accessing!public! !
!RBClass categoriesFor: #definitionString!accessing!public! !
!RBClass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!RBClass categoriesFor: #directlyDefinesPoolDictionary:!public!testing! !
!RBClass categoriesFor: #getPoolDictionaryNames!helpers!private! !
!RBClass categoriesFor: #isMeta!public!testing! !
!RBClass categoriesFor: #kindOfSubclass!class hierarchy-testing!private! !
!RBClass categoriesFor: #nonMetaclass!accessing!public! !
!RBClass categoriesFor: #poolDictionaryNames!accessing!public! !
!RBClass categoriesFor: #poolDictionaryNames:!accessing!public! !
!RBClass categoriesFor: #printDefinitionOn:!accessing!public! !
!RBClass categoriesFor: #privateClassVariableNames!private! !
!RBClass categoriesFor: #privatePoolDictionaryNames!private! !
!RBClass categoriesFor: #realName:!initialize/release!public! !
!RBClass categoriesFor: #removeClassVariable:!public!variable accessing! !
!RBClass categoriesFor: #removePoolDictionary:!public!variable accessing! !
!RBClass categoriesFor: #renameClassVariable:to:around:!public!variable accessing! !
!RBClass categoriesFor: #sharedPools!accessing!public! !

!RBClass class methodsFor!

existingNamed: aSymbol 
	^(self named: aSymbol)
		realName: aSymbol;
		yourself!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!RBClass class categoriesFor: #existingNamed:!instance creation!public! !
!RBClass class categoriesFor: #named:!instance creation!public! !

