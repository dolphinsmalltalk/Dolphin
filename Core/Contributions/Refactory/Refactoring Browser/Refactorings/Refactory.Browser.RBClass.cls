"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBAbstractClass subclass: #'Refactory.Browser.RBClass'
	instanceVariableNames: 'classVariableNames imports category classConstants comment'
	classVariableNames: 'LookupComment'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBClass guid: (Core.GUID fromString: '{e6a15c71-6c8c-437d-856c-42cd447df930}')!
Refactory.Browser.RBClass comment: 'RBClass represents a Class.

Instance Variables:
	category	<Symbol>	name of the category that the class should be compiled in
	classVariableNames	<SequenceableCollection of: Symbol>	class variables defined by the class
	poolDictionaryNames	<Collection of: Symbol>	pool variables included by the class'!
!Refactory.Browser.RBClass categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBClass methodsFor!

addClassVariable: aString 
	self classVariableNames add: aString.
	model addClassVariable: aString to: self!

addImport: aString
	| ref |
	ref := aString asQualifiedReference.
	imports := self imports copyWith: ref.
	model addImport: ref to: self!

allClassVariableNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil
		ifTrue: [self classVariableNames]
		ifFalse: [sprClass allClassVariableNames , self classVariableNames]!

allImports
	^self superclass ifNil: [self imports] ifNotNil: [:sprClass | sprClass allImports , self imports]!

category
	^category isNil 
		ifTrue: [model environment whichCategoryIncludes: self name]
		ifFalse: [category]!

category: aSymbol 
	category := aSymbol!

classBindingNames
	^self classVariableNames , (self classConstants collect: [:each | each key])!

classConstants
	classConstants
		ifNil: [self classConstants: (self isDefined ifTrue: [self realClass classConstants] ifFalse: [#()])].
	^classConstants!

classConstants: aCollectionOfVariableBindings
	classConstants := aCollectionOfVariableBindings asOrderedCollection!

classVariableNames
	(classVariableNames isNil and: [self isDefined])
		ifTrue: [self classVariableNames: self realClass classVariableNames].
	^classVariableNames!

classVariableNames: aCollectionOfStrings 
	classVariableNames := aCollectionOfStrings asOrderedCollection!

comment
	^comment == LookupComment
		ifTrue: [comment := self isDefined ifTrue: [self realClass comment]]
		ifFalse: [comment]!

comment: aString
	model comment: (comment := aString) in: self!

definitionString
	| definitionStream |
	definitionStream := (String writeStream: 256)
				locale: SmalltalkLocale.Hex;
				yourself.
	self printDefinitionOn: definitionStream.
	^definitionStream contents!

directlyDefinesClassVariable: aString
	^self classVariableNames includes: aString!

directlyImportsNamespace: aString
	^self imports includes: aString asQualifiedReference!

fullyQualifiedReference
	^BindingReference pathString: name!

getImports
	#rbFix.	"Dolphin stores the pool names in its classes, rather than the pools themselves."
	^self realClass imports
	"sharedPools collect: [:each | Smalltalk keyAtValue: each]"!

imports
	(self isDefined and: [imports isNil]) ifTrue: [self imports: self realClass imports].
	^imports!

imports: aCollectionOfStrings
	imports := (aCollectionOfStrings collect: [:each | each asQualifiedReference]) asArray!

isMeta
	^false!

kindOfSubclass
	"Private - Answer a string describing the kind of subclassing method used to create the receiver 
	(part of its definition)."

	^self isVariable 
		ifTrue: [self isBytes ifTrue: ['variableByteSubclass:'] ifFalse: ['variableSubclass:']]
		ifFalse: ['subclass:']!

name: aSymbol 
	name := aSymbol!

nonMetaclass
	^self!

printDefinitionOn: puttableStream
	| constants |
	puttableStream
		nextPutAll: self superclass name;
		space;
		nextPutAll: self kindOfSubclass;
		space;
		print: self name;
		crtab;
		nextPutAll: 'instanceVariableNames: '''.
	self instanceVariableNames do: [:each | puttableStream nextPutAll: each]
		separatedBy: [puttableStream space].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'classVariableNames: '''.
	self classVariableNames do: [:each | puttableStream nextPutAll: each]
		separatedBy: [puttableStream space].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'imports: ';
		print: self imports;
		crtab;
		nextPutAll: 'classInstanceVariableNames: '''.
	self metaclass instanceVariableNames do: [:each | puttableStream nextPutAll: each]
		separatedBy: [puttableStream space].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'classConstants: {'.
	constants := self classConstants.
	constants isEmpty
		ifFalse: 
			[constants do: 
					[:each |
					puttableStream
						crtab: 2;
						print: each]
				separatedBy: [puttableStream nextPut: $.].
			puttableStream crtab].
	puttableStream nextPut: $}!

realName: aSymbol 
	self realClass: aSymbol asQualifiedReference value!

removeClassVariable: aString
	self classVariableNames remove: aString ifAbsent: [self classConstants remove: aString].
	model removeClassVariable: aString from: self!

removeImport: aString
	| ref |
	ref := aString asQualifiedReference.
	imports := self imports copyWithout: ref.
	model removeImport: ref from: self!

renameClassVariable: oldName to: newName around: aBlock
	| varNames |
	varNames := self classVariableNames.
	varNames at: (varNames indexOf: oldName) put: newName.
	model
		renameClassVariable: oldName
		to: newName
		in: self
		around: aBlock!

setName: aSymbol 
	name := aSymbol.
	comment := LookupComment!

unqualifiedName
	^(BindingReference splitQualifiedName: name) last asSymbol! !
!Refactory.Browser.RBClass categoriesFor: #addClassVariable:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #addImport:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #allClassVariableNames!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #allImports!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #category!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #category:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classBindingNames!public! !
!Refactory.Browser.RBClass categoriesFor: #classConstants!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classConstants:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classVariableNames!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classVariableNames:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #comment!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #comment:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #definitionString!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!Refactory.Browser.RBClass categoriesFor: #directlyImportsNamespace:!public!testing! !
!Refactory.Browser.RBClass categoriesFor: #fullyQualifiedReference!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #getImports!helpers!private! !
!Refactory.Browser.RBClass categoriesFor: #imports!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #imports:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #isMeta!public!testing! !
!Refactory.Browser.RBClass categoriesFor: #kindOfSubclass!class hierarchy-testing!private! !
!Refactory.Browser.RBClass categoriesFor: #name:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #nonMetaclass!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #printDefinitionOn:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #realName:!initialize/release!public! !
!Refactory.Browser.RBClass categoriesFor: #removeClassVariable:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #removeImport:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #renameClassVariable:to:around:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #setName:!initializing!private! !
!Refactory.Browser.RBClass categoriesFor: #unqualifiedName!public! !

!Refactory.Browser.RBClass class methodsFor!

existing: aBehavior
	| class |
	class := aBehavior instanceClass.
	^(self named: class fullName asSymbol)
		realClass: class;
		yourself!

initialize
	LookupComment := Object new! !
!Refactory.Browser.RBClass class categoriesFor: #existing:!instance creation!public! !
!Refactory.Browser.RBClass class categoriesFor: #initialize!class initialization!public! !

