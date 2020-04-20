"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RBAbstractClass
	instanceVariableNames: 'name newMethods instanceVariableNames model superclass subclasses removedMethods realClass'
	classVariableNames: 'LookupSuperclass'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBAbstractClass guid: (GUID fromString: '{99469076-f20a-4a7f-91f1-c2d06d948a14}')!
RBAbstractClass isAbstract: true!
RBAbstractClass comment: 'RBAbstractClass is an abstract class. It represents classes in the system. Refactorings operate on these objects, producing change objects. These change objects are then performed on the real code.

Subclasses must implement the following messages:
	accessing
		allClassVariableNames
		allPoolDictionaryNames
	testing
		directlyDefinesClassVariable:
		directlyDefinesPoolDictionary:
		isAbstract
		isMeta

Instance Variables:
	instanceVariableNames	<SequenceableCollection of: String>	instance variables that the class defines
	model	<RBNamespace>	where the class is defined
	name	<ByteSymbol>	the class'' name for metaclasses it is the name of the nonMetaclass
	newMethods	<Dictionary of: RBMethod>	methods that have been added to the class
	realClass	<Behavior>	if the class already exists in the system, then this variable holds that class
	removedMethods	<Collection of: Symbol>	method names that have been removed
	subclasses	<Collection of: RBAbstractClass>	my subclasses
	superclass	<RBAbstractClass>	the superclass (or LookupSuperclass if we haven''t assigned it yet).

Class Variables:
	LookupSuperclass	<Object>	a special object denoting that our superclass hasn''t been assigned yet

'!
!RBAbstractClass categoriesForClass!Refactory-Model! !
!RBAbstractClass methodsFor!

= aRBClass 
	^self class = aRBClass class 
		and: [self name = aRBClass name and: [self model = aRBClass model]]!

addInstanceVariable: aString 
	self privateInstanceVariableNames add: aString.
	model addInstanceVariable: aString to: self!

addMethod: aRBMethod 
	self newMethods at: aRBMethod selector put: aRBMethod.
	removedMethods notNil 
		ifTrue: [removedMethods remove: aRBMethod selector ifAbsent: []]!

addSubclass: aRBClass 
	self subclasses add: aRBClass!

allClassVariableNames
	^self subclassResponsibility!

allInstanceVariableNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [self instanceVariableNames]
		ifFalse: [sprClass allInstanceVariableNames , self instanceVariableNames]!

allPoolDictionaryNames
	^self subclassResponsibility!

allSelectors
	| class selectors |
	class := self.
	selectors := Set new.
	[class notNil] whileTrue: 
			[selectors addAll: class selectors.
			class := class superclass].
	^selectors!

allSubclasses
	| allSubclasses index |
	index := 1.
	#rbFix. "asOrderedCollection non-copying in Dolphin"
	allSubclasses := OrderedCollection withAll: self subclasses.
	[index <= allSubclasses size] whileTrue: 
			[allSubclasses addAllLast: (allSubclasses at: index) subclasses.
			index := index + 1].
	^allSubclasses!

allSuperclasses
	| supers sprClass |
	supers := OrderedCollection new.
	sprClass := self superclass.
	[sprClass notNil] whileTrue: 
			[supers add: sprClass.
			sprClass := sprClass superclass].
	^supers!

bindingFor: aString 
	^self realClass classPool associationAt: aString asSymbol
		ifAbsent: [self realClass classPool associationAt: aString asString ifAbsent: [nil]]!

classBinding
	^self name asQualifiedReference binding!

classVarNames
	^self nonMetaclass classVariableNames!

compile: aString 
	#rbFix. "Support multiple method categories for Dolphin"
	^self compile: aString
		classified: (self protocolsFor: (RBParser parseMethodPattern: aString))!

compile: aString classified: aSymbolCollection
	| change method |
	change := model 
				compile: aString
				in: self
				classified: aSymbolCollection.
	method := RBMethod 
				for: self
				source: aString
				selector: change selector.
	self addMethod: method.
	#rbFix.	"Return the AddMethodChange object"
	^change!

compileTree: aBRMethodNode 
	^self compileTree: aBRMethodNode
		classified: (self protocolsFor: aBRMethodNode selector)!

compileTree: aBRMethodNode classified: aSymbolCollection 
	| source |
	source := aBRMethodNode formattedCode.
	^self compile: source classified: aSymbolCollection!

definesClassVariable: aSymbol 
	(self directlyDefinesClassVariable: aSymbol) ifTrue: [^true].
	^self superclass notNil 
		and: [self superclass definesClassVariable: aSymbol]!

definesInstanceVariable: aString 
	(self directlyDefinesInstanceVariable: aString) ifTrue: [^true].
	^self superclass notNil 
		and: [self superclass definesInstanceVariable: aString]!

definesMethod: aSelector 
	(self directlyDefinesMethod: aSelector) ifTrue: [^true].
	^self superclass notNil and: [self superclass definesMethod: aSelector]!

definesPoolDictionary: aSymbol 
	(self directlyDefinesPoolDictionary: aSymbol) ifTrue: [^true].
	^self inheritsPoolDictionaries and: 
			[self superclass notNil 
				and: [self superclass definesPoolDictionary: aSymbol]]!

definesVariable: aVariableName 
	^(self definesClassVariable: aVariableName) 
		or: [self definesInstanceVariable: aVariableName]!

directlyDefinesClassVariable: aString 
	self subclassResponsibility!

directlyDefinesInstanceVariable: aString 
	^self instanceVariableNames includes: aString!

directlyDefinesMethod: aSelector 
	self isDefined 
		ifTrue: 
			[(self hasRemoved: aSelector) ifTrue: [^false].
			(self realClass includesSelector: aSelector) ifTrue: [^true]].
	^newMethods notNil and: [newMethods includesKey: aSelector]!

directlyDefinesPoolDictionary: aString 
	self subclassResponsibility!

directlyDefinesVariable: aVariableName 
	^(self directlyDefinesClassVariable: aVariableName) 
		or: [self directlyDefinesInstanceVariable: aVariableName]!

existingMethodsThatReferTo: aSymbol 
	| existingMethods |
	existingMethods := self realClass whichSelectorsReferTo: aSymbol.
	(newMethods isNil and: [removedMethods isNil]) ifTrue: [^existingMethods].
	^existingMethods 
		reject: [:each | (self hasRemoved: each) or: [self newMethods includesKey: each]]!

hash
	^self name hash bitXor: self class hash!

hasRemoved: aSelector 
	^removedMethods notNil and: [removedMethods includes: aSelector]!

hierarchyDefinesClassVariable: aString 
	(self definesClassVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesClassVariable: aString]!

hierarchyDefinesInstanceVariable: aString 
	(self definesInstanceVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesInstanceVariable: aString]!

hierarchyDefinesMethod: aSelector 
	(self definesMethod: aSelector) ifTrue: [^true].
	^self subclassRedefines: aSelector!

hierarchyDefinesPoolDictionary: aString 
	(self definesPoolDictionary: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesPoolDictionary: aString]!

hierarchyDefinesVariable: aString 
	(self definesVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesVariable: aString]!

includesClass: aRBClass 
	| currentClass |
	currentClass := self.
	[currentClass notNil and: [currentClass ~= aRBClass]] 
		whileTrue: [currentClass := currentClass superclass].
	^currentClass = aRBClass!

inheritsPoolDictionaries
	#rbFix.	"Dolphin inherits pool dictionaries"
	^true!

initialize
	name := #'Unknown Class'!

instanceClass
	#rbFix.	"Added because Dolphin uses this message rather than #soleInstance"
	^self nonMetaclass!

instanceVariableNames
	^self privateInstanceVariableNames copy!

instanceVariableNames: aCollectionOfStrings 
	instanceVariableNames := OrderedCollection withAll: aCollectionOfStrings!

isAbstract
	self realClass ifNotNil: [:real | real isNonInstantiable ifTrue: [^true]].
	(self whichMethodsReferToSymbol: #subclassResponsibility) notEmpty ifTrue: [^true].
	model allReferencesToClass: self do: [:each | ^false].
	^true!

isBytes
	"Answer whether the variables of instances of the receiver are stored as bytes (8-bit integers)."

	^self isPointers not!

isDefined
	^self realClass notNil!

isMeta
	self subclassResponsibility!

isPointers
	#rbFix. "Added"
	^self nearestRealClass ifNil: [true] ifNotNil: [:class | class isPointers]!

isVariable
	#rbFix. "Added"
	^self nearestRealClass ifNil: [true] ifNotNil: [:class | class isVariable]!

metaclass
	^model metaclassNamed: self name!

methodFor: aSelector 
	^self newMethods at: aSelector
		ifAbsent: 
			[| compiledMethod class |
			(self hasRemoved: aSelector) ifTrue: [^nil].
			class := self realClass.
			class isNil ifTrue: [^nil].
			compiledMethod := class compiledMethodAt: aSelector ifAbsent: [nil].
			compiledMethod isNil 
				ifTrue: [nil]
				ifFalse: 
					[RBMethod 
						for: self
						fromMethod: compiledMethod
						andSelector: aSelector]]!

model
	^model!

model: aRBNamespace 
	model := aRBNamespace!

name
	^name!

name: aSymbol 
	name := aSymbol!

nearestRealClass
	#rbFix.	"Added"
	^self realClass isNil 
		ifTrue: [superclass notNil ifTrue: [superclass nearestRealClass]]
		ifFalse: [self realClass]!

newMethods
	^newMethods isNil 
		ifTrue: [newMethods := IdentityDictionary new]
		ifFalse: [newMethods]!

nonMetaclass
	^model classNamed: self name!

parseTreeFor: aSelector 
	| class |
	class := self whoDefinesMethod: aSelector.
	class isNil ifTrue: [^nil].
	^(class methodFor: aSelector) parseTree!

primaryInstance
	^self nonMetaclass!

printOn: aStream 
	aStream nextPutAll: self name!

privateInstanceVariableNames
	instanceVariableNames isNil 
		ifTrue: 
			[self isDefined 
				ifTrue: [self instanceVariableNames: self realClass instVarNames]
				ifFalse: [instanceVariableNames := OrderedCollection new]].
	^instanceVariableNames!

protocolsFor: aSelector 
	| change |
	#rbFix. "Added to support Dolphin's multiple method categories"
	change := self isMeta 
				ifTrue: [model changes changeForMetaclass: name selector: aSelector]
				ifFalse: [model changes changeForClass: name selector: aSelector].
	^change isNil 
		ifTrue: 
			[self isDefined 
				ifTrue: 
					[BrowserEnvironment new whichProtocolsInclude: aSelector in: self realClass]
				ifFalse: [#(#accessing)]]
		ifFalse: [change protocols]!

realClass
	^realClass!

realClass: aClass 
	realClass := aClass.
	superclass isNil ifTrue: [superclass := LookupSuperclass]!

removedMethods
	^removedMethods isNil 
		ifTrue: [removedMethods := Set new]
		ifFalse: [removedMethods]!

removeInstanceVariable: aString 
	self privateInstanceVariableNames remove: aString.
	model removeInstanceVariable: aString from: self!

removeMethod: aSelector 
	self newMethods removeKey: aSelector ifAbsent: [].
	model removeMethod: aSelector from: self.
	self removedMethods add: aSelector!

removeSubclass: aRBClass 
	self subclasses remove: aRBClass ifAbsent: []!

renameInstanceVariable: oldName to: newName around: aBlock 
	self privateInstanceVariableNames 
		at: (self privateInstanceVariableNames indexOf: oldName asString)
		put: newName asString.
	model 
		renameInstanceVariable: oldName
		to: newName
		in: self
		around: aBlock!

selectors
	| selectors |
	selectors := Set new.
	selectors addAll: self newMethods keys.
	self isDefined 
		ifTrue: 
			[selectors addAll: self realClass selectors.
			removedMethods notNil 
				ifTrue: [removedMethods do: [:each | selectors remove: each ifAbsent: []]]].
	^selectors!

soleInstance
	^self nonMetaclass!

sourceCodeFor: aSelector 
	| class |
	class := self whoDefinesMethod: aSelector.
	class isNil ifTrue: [^nil].
	^(class methodFor: aSelector) source!

storeOn: aStream 
	aStream nextPutAll: self name!

subclasses
	#rbFix.	"Dolphin doesn't include Object class as a subclass of class, so we implement #subBehaviors which does"
	subclasses isNil 
		ifTrue: 
			[#rbFix.	"If the model's environment doesn't include all the subclasses, then the original code ends up with nils in the collection"
			subclasses := OrderedCollection new.
			self isDefined 
				ifTrue: 
					[self realClass subBehaviors 
						do: [:each | (model classFor: each) ifNotNil: [:class | subclasses addLast: class]]]].
	^subclasses!

subclassRedefines: aSelector 
	"Return true, if one of your subclasses redefines the method with name, aMethod"

	self allSubclasses 
		do: [:each | (each directlyDefinesMethod: aSelector) ifTrue: [^true]].
	^false!

superclass
	^superclass == LookupSuperclass 
		ifTrue: [model classFor: self realClass superclass]
		ifFalse: [superclass]!

superclass: aRBClass 
	self superclass notNil ifTrue: [self superclass removeSubclass: self].
	superclass := aRBClass.
	superclass notNil ifTrue: [superclass addSubclass: self].!

typeOfClassVariable: aSymbol 
	^model classNamed: #Object!

whichMethodsReferToSymbol: aSymbol 
	| selectors |
	selectors := Set new.
	self newMethods 
		do: [:each | (each refersToSymbol: aSymbol) ifTrue: [selectors add: each selector]].
	self isDefined ifTrue: [selectors addAll: (self existingMethodsThatReferTo: aSymbol)].
	^selectors collect: [:sel | self methodFor: sel]!

whichSelectorsReferToClass: aRBClass
	| selectors |
	selectors := IdentitySet new.
	self newMethods
		do: [:each | (each refersToClassNamed: aRBClass name) ifTrue: [selectors add: each selector]].
	(self isDefined and: [aRBClass isDefined])
		ifTrue: 
			[selectors addAll: (self existingMethodsThatReferTo: aRBClass classBinding).
			selectors addAll: (self existingMethodsThatReferTo: aRBClass name)].
	^selectors!

whichSelectorsReferToClassVariable: aString 
	| selectors |
	#rbFix. "From John Brant, 2001-08-03, supercedes wiki patch"
	selectors := Set new.
	self newMethods 
		do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
	self nonMetaclass isDefined 
		ifTrue: 
			[| binding definingClass |
			definingClass := self nonMetaclass realClass 
						whichClassDefinesClassVar: aString asString.
			definingClass notNil 
				ifTrue: [binding := (model classFor: definingClass) bindingFor: aString].
			binding isNil ifTrue: [^selectors].
			selectors addAll: ((self realClass whichSelectorsReferTo: binding) 
						reject: [:each | self hasRemoved: each])].
	^selectors!

whichSelectorsReferToInstanceVariable: aString 
	| selectors |
	selectors := Set new.
	self newMethods 
		do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
	self isDefined 
		ifTrue: 
			[selectors addAll: ((self realClass whichSelectorsAccess: aString) 
						reject: [:each | self hasRemoved: each])].
	^selectors!

whoDefinesClassVariable: aString 
	| sprClass |
	(self directlyDefinesClassVariable: aString) ifTrue: [^self].
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [nil]
		ifFalse: [sprClass whoDefinesClassVariable: aString]!

whoDefinesInstanceVariable: aString 
	| sprClass |
	(self directlyDefinesInstanceVariable: aString) ifTrue: [^self].
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [nil]
		ifFalse: [sprClass whoDefinesInstanceVariable: aString]!

whoDefinesMethod: aSelector 
	| sprClass |
	(self directlyDefinesMethod: aSelector) ifTrue: [^self].
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [nil]
		ifFalse: [sprClass whoDefinesMethod: aSelector]!

withAllSubclasses
	^(self allSubclasses)
		add: self;
		yourself!

withAllSuperclasses
	#rbFix.	"Ensure in reverse hierarchy order"
	^(self allSuperclasses)
		addFirst: self;
		yourself! !
!RBAbstractClass categoriesFor: #=!comparing!public! !
!RBAbstractClass categoriesFor: #addInstanceVariable:!public!variable accessing! !
!RBAbstractClass categoriesFor: #addMethod:!method accessing!public! !
!RBAbstractClass categoriesFor: #addSubclass:!private! !
!RBAbstractClass categoriesFor: #allClassVariableNames!accessing!public! !
!RBAbstractClass categoriesFor: #allInstanceVariableNames!accessing!public! !
!RBAbstractClass categoriesFor: #allPoolDictionaryNames!accessing!public! !
!RBAbstractClass categoriesFor: #allSelectors!method accessing!public! !
!RBAbstractClass categoriesFor: #allSubclasses!accessing!public! !
!RBAbstractClass categoriesFor: #allSuperclasses!accessing!public! !
!RBAbstractClass categoriesFor: #bindingFor:!method accessing!public! !
!RBAbstractClass categoriesFor: #classBinding!accessing!public! !
!RBAbstractClass categoriesFor: #classVarNames!public! !
!RBAbstractClass categoriesFor: #compile:!method accessing!public! !
!RBAbstractClass categoriesFor: #compile:classified:!method accessing!public! !
!RBAbstractClass categoriesFor: #compileTree:!method accessing!public! !
!RBAbstractClass categoriesFor: #compileTree:classified:!method accessing!public! !
!RBAbstractClass categoriesFor: #definesClassVariable:!public!testing! !
!RBAbstractClass categoriesFor: #definesInstanceVariable:!public!testing! !
!RBAbstractClass categoriesFor: #definesMethod:!public!testing! !
!RBAbstractClass categoriesFor: #definesPoolDictionary:!public!testing! !
!RBAbstractClass categoriesFor: #definesVariable:!public!testing! !
!RBAbstractClass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!RBAbstractClass categoriesFor: #directlyDefinesInstanceVariable:!public!testing! !
!RBAbstractClass categoriesFor: #directlyDefinesMethod:!public!testing! !
!RBAbstractClass categoriesFor: #directlyDefinesPoolDictionary:!public!testing! !
!RBAbstractClass categoriesFor: #directlyDefinesVariable:!public!testing! !
!RBAbstractClass categoriesFor: #existingMethodsThatReferTo:!method accessing!public! !
!RBAbstractClass categoriesFor: #hash!comparing!public! !
!RBAbstractClass categoriesFor: #hasRemoved:!public!testing! !
!RBAbstractClass categoriesFor: #hierarchyDefinesClassVariable:!public!testing! !
!RBAbstractClass categoriesFor: #hierarchyDefinesInstanceVariable:!public!testing! !
!RBAbstractClass categoriesFor: #hierarchyDefinesMethod:!public!testing! !
!RBAbstractClass categoriesFor: #hierarchyDefinesPoolDictionary:!public!testing! !
!RBAbstractClass categoriesFor: #hierarchyDefinesVariable:!public!testing! !
!RBAbstractClass categoriesFor: #includesClass:!public!testing! !
!RBAbstractClass categoriesFor: #inheritsPoolDictionaries!public!testing! !
!RBAbstractClass categoriesFor: #initialize!initialize/release!public! !
!RBAbstractClass categoriesFor: #instanceClass!accessing!public! !
!RBAbstractClass categoriesFor: #instanceVariableNames!accessing!public! !
!RBAbstractClass categoriesFor: #instanceVariableNames:!accessing!public! !
!RBAbstractClass categoriesFor: #isAbstract!public!testing! !
!RBAbstractClass categoriesFor: #isBytes!instance specification-testing!public! !
!RBAbstractClass categoriesFor: #isDefined!public!testing! !
!RBAbstractClass categoriesFor: #isMeta!public!testing! !
!RBAbstractClass categoriesFor: #isPointers!public!testing! !
!RBAbstractClass categoriesFor: #isVariable!public!testing! !
!RBAbstractClass categoriesFor: #metaclass!accessing!public! !
!RBAbstractClass categoriesFor: #methodFor:!method accessing!public! !
!RBAbstractClass categoriesFor: #model!accessing!public! !
!RBAbstractClass categoriesFor: #model:!initialize/release!public! !
!RBAbstractClass categoriesFor: #name!accessing!public! !
!RBAbstractClass categoriesFor: #name:!accessing!public! !
!RBAbstractClass categoriesFor: #nearestRealClass!accessing!private! !
!RBAbstractClass categoriesFor: #newMethods!accessing!public! !
!RBAbstractClass categoriesFor: #nonMetaclass!accessing!public! !
!RBAbstractClass categoriesFor: #parseTreeFor:!method accessing!public! !
!RBAbstractClass categoriesFor: #primaryInstance!accessing!public! !
!RBAbstractClass categoriesFor: #printOn:!printing!public! !
!RBAbstractClass categoriesFor: #privateInstanceVariableNames!accessing!private! !
!RBAbstractClass categoriesFor: #protocolsFor:!accessing!public! !
!RBAbstractClass categoriesFor: #realClass!accessing!public! !
!RBAbstractClass categoriesFor: #realClass:!accessing!public! !
!RBAbstractClass categoriesFor: #removedMethods!accessing!public! !
!RBAbstractClass categoriesFor: #removeInstanceVariable:!public!variable accessing! !
!RBAbstractClass categoriesFor: #removeMethod:!method accessing!public! !
!RBAbstractClass categoriesFor: #removeSubclass:!accessing!public! !
!RBAbstractClass categoriesFor: #renameInstanceVariable:to:around:!public!variable accessing! !
!RBAbstractClass categoriesFor: #selectors!method accessing!public! !
!RBAbstractClass categoriesFor: #soleInstance!accessing!public! !
!RBAbstractClass categoriesFor: #sourceCodeFor:!method accessing!public! !
!RBAbstractClass categoriesFor: #storeOn:!printing!public! !
!RBAbstractClass categoriesFor: #subclasses!accessing!public! !
!RBAbstractClass categoriesFor: #subclassRedefines:!public!testing! !
!RBAbstractClass categoriesFor: #superclass!accessing!public! !
!RBAbstractClass categoriesFor: #superclass:!accessing!private! !
!RBAbstractClass categoriesFor: #typeOfClassVariable:!public!variable accessing! !
!RBAbstractClass categoriesFor: #whichMethodsReferToSymbol:!method accessing!public! !
!RBAbstractClass categoriesFor: #whichSelectorsReferToClass:!method accessing!public! !
!RBAbstractClass categoriesFor: #whichSelectorsReferToClassVariable:!method accessing!public! !
!RBAbstractClass categoriesFor: #whichSelectorsReferToInstanceVariable:!method accessing!public! !
!RBAbstractClass categoriesFor: #whoDefinesClassVariable:!public!variable accessing! !
!RBAbstractClass categoriesFor: #whoDefinesInstanceVariable:!public!variable accessing! !
!RBAbstractClass categoriesFor: #whoDefinesMethod:!method accessing!public! !
!RBAbstractClass categoriesFor: #withAllSubclasses!accessing!public! !
!RBAbstractClass categoriesFor: #withAllSuperclasses!accessing!public! !

!RBAbstractClass class methodsFor!

initialize
	LookupSuperclass := Object new!

new
	^(super new)
		initialize;
		yourself! !
!RBAbstractClass class categoriesFor: #initialize!class initialization!public! !
!RBAbstractClass class categoriesFor: #new!instance creation!public! !

