"Filed out from Dolphin Smalltalk"!

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
	^Smalltalk associationAt: self name!

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

!RBAbstractClass categoriesForMethods!
=!comparing!public! !
addInstanceVariable:!public!variable accessing! !
addMethod:!method accessing!public! !
addSubclass:!private! !
allClassVariableNames!accessing!public! !
allInstanceVariableNames!accessing!public! !
allPoolDictionaryNames!accessing!public! !
allSelectors!method accessing!public! !
allSubclasses!accessing!public! !
allSuperclasses!accessing!public! !
bindingFor:!method accessing!public! !
classBinding!accessing!public! !
classVarNames!public! !
compile:!method accessing!public! !
compile:classified:!method accessing!public! !
compileTree:!method accessing!public! !
compileTree:classified:!method accessing!public! !
definesClassVariable:!public!testing! !
definesInstanceVariable:!public!testing! !
definesMethod:!public!testing! !
definesPoolDictionary:!public!testing! !
definesVariable:!public!testing! !
directlyDefinesClassVariable:!public!testing! !
directlyDefinesInstanceVariable:!public!testing! !
directlyDefinesMethod:!public!testing! !
directlyDefinesPoolDictionary:!public!testing! !
directlyDefinesVariable:!public!testing! !
existingMethodsThatReferTo:!method accessing!public! !
hash!comparing!public! !
hasRemoved:!public!testing! !
hierarchyDefinesClassVariable:!public!testing! !
hierarchyDefinesInstanceVariable:!public!testing! !
hierarchyDefinesMethod:!public!testing! !
hierarchyDefinesPoolDictionary:!public!testing! !
hierarchyDefinesVariable:!public!testing! !
includesClass:!public!testing! !
inheritsPoolDictionaries!public!testing! !
initialize!initialize/release!public! !
instanceClass!accessing!public! !
instanceVariableNames!accessing!public! !
instanceVariableNames:!accessing!public! !
isAbstract!public!testing! !
isBytes!instance specification-testing!public! !
isDefined!public!testing! !
isMeta!public!testing! !
isPointers!public!testing! !
isVariable!public!testing! !
metaclass!accessing!public! !
methodFor:!method accessing!public! !
model!accessing!public! !
model:!initialize/release!public! !
name!accessing!public! !
name:!accessing!public! !
nearestRealClass!accessing!private! !
newMethods!accessing!public! !
nonMetaclass!accessing!public! !
parseTreeFor:!method accessing!public! !
primaryInstance!accessing!public! !
printOn:!printing!public! !
privateInstanceVariableNames!accessing!private! !
protocolsFor:!accessing!public! !
realClass!accessing!public! !
realClass:!accessing!public! !
removedMethods!accessing!public! !
removeInstanceVariable:!public!variable accessing! !
removeMethod:!method accessing!public! !
removeSubclass:!accessing!public! !
renameInstanceVariable:to:around:!public!variable accessing! !
selectors!method accessing!public! !
soleInstance!accessing!public! !
sourceCodeFor:!method accessing!public! !
storeOn:!printing!public! !
subclasses!accessing!public! !
subclassRedefines:!public!testing! !
superclass!accessing!public! !
superclass:!accessing!private! !
typeOfClassVariable:!public!variable accessing! !
whichMethodsReferToSymbol:!method accessing!public! !
whichSelectorsReferToClass:!method accessing!public! !
whichSelectorsReferToClassVariable:!method accessing!public! !
whichSelectorsReferToInstanceVariable:!method accessing!public! !
whoDefinesClassVariable:!public!variable accessing! !
whoDefinesInstanceVariable:!public!variable accessing! !
whoDefinesMethod:!method accessing!public! !
withAllSubclasses!accessing!public! !
withAllSuperclasses!accessing!public! !
!

!RBAbstractClass class methodsFor!

initialize
	LookupSuperclass := Object new!

new
	^(super new)
		initialize;
		yourself! !

!RBAbstractClass class categoriesForMethods!
initialize!class initialization!public! !
new!instance creation!public! !
!

