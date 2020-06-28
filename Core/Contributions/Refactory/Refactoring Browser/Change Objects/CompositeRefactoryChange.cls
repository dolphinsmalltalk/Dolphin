"Filed out from Dolphin Smalltalk 7"!

RefactoryChange subclass: #CompositeRefactoryChange
	instanceVariableNames: 'changes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompositeRefactoryChange guid: (GUID fromString: '{74a295ee-f099-43f1-bd6e-d82d0b07d9d9}')!
CompositeRefactoryChange comment: 'RefactoryBuilder represents a series of changes (RefactoryChange) that need to be performed. It provides transaction-like behavior by defering all changes until it is told to commit them (#doIt).

Instance Variables:
	changes	<SequenceableCollection of: RefactoryChange>	the changes that need to be performed'!
!CompositeRefactoryChange categoriesForClass!Refactory-Change Objects! !
!CompositeRefactoryChange methodsFor!

= aRefactoryBuilder 
	self class = aRefactoryBuilder class ifFalse: [^false].
	changes size = aRefactoryBuilder changes size ifFalse: [^false].
	changes with: aRefactoryBuilder changes
		do: [:each :change | each = change ifFalse: [^false]].
	^true!

addChange: aRefactoryChange 
	changes add: aRefactoryChange.
	^aRefactoryChange!

addChangeFirst: aRefactoryChange 
	changes addFirst: aRefactoryChange.
	^aRefactoryChange!

addClassVariable: variableName to: aClass 
	^self addChange: (AddClassVariableChange add: variableName to: aClass)!

addInstanceVariable: variableName to: aClass 
	^self addChange: (AddInstanceVariableChange add: variableName to: aClass)!

addPool: aPoolVariable to: aClass 
	^self addChange: (AddPoolVariableChange add: aPoolVariable to: aClass)!

basicExecuteNotifying: aBlock
	| undo undos |
	undos := changes collect: [:each | each executeNotifying: aBlock].
	undo := self copy.
	undo changes: undos reverse.
	^undo!

changeForClass: aRBClass selector: aSelector 
	changes reverseDo: 
			[:each | 
			| change |
			change := each changeForClass: aRBClass selector: aSelector.
			change notNil ifTrue: [^change]].
	^nil!

changeForMetaclass: aSymbol selector: aSelector 
	changes reverseDo: 
			[:each | 
			| change |
			change := each changeForMetaclass: aSymbol selector: aSelector.
			change notNil ifTrue: [^change]].
	^nil!

changes
	^changes!

changes: aCollection 
	changes := aCollection!

changesSize
	^changes inject: 0 into: [:sum :each | sum + each changesSize]!

compile: source in: class 
	^self addChange: (self addMethodChangeClass compile: source in: class)!

compile: aString in: aClass categories: anArray 
	^self addChange: (self addMethodChangeClass 
				compile: aString
				in: aClass
				categories: anArray)!

compile: source in: class classified: aProtocol 
	^self addChange: (self addMethodChangeClass
				compile: source
				in: class
				classified: aProtocol)!

defineClass: aString 
	^self addChange: (self addClassChangeClass definition: aString)!

executeNotifying: aBlock
	#rbFix.	"Extract to method so can invoke from subclass of subclass where both override"
	^self basicExecuteNotifying: aBlock!

flattenOnto: aCollection 
	changes do: [:each | each flattenOnto: aCollection]!

hash
	^changes size!

initialize
	super initialize.
	changes := OrderedCollection new!

postCopy
	super postCopy.
	changes := changes collect: [:each | each copy].
	^self!

printOn: aStream 
	aStream
		basicPrint: self;
		nextPut: $(;
		print: name;
		nextPut: $)!

problemCount
	^self changesSize!

removeChange: aChange 
	changes remove: aChange ifAbsent: []!

removeClass: aClass 
	^self addChange: (RemoveClassChange removeClassName: aClass name)!

removeClassNamed: aSymbol 
	self addChange: (RemoveClassChange removeClassName: aSymbol)!

removeClassVariable: variableName from: aClass 
	^self 
		addChange: (RemoveClassVariableChange remove: variableName from: aClass)!

removeInstanceVariable: variableName from: aClass 
	^self 
		addChange: (RemoveInstanceVariableChange remove: variableName from: aClass)!

removeMethod: aSelector from: aClass 
	^self addChange: (RemoveMethodChange remove: aSelector from: aClass)!

renameChangesForClass: aClassName to: newClassName 
	^(self copy)
		changes: (self changes 
					collect: [:each | each renameChangesForClass: aClassName to: newClassName]);
		yourself!

renameClass: class to: newName 
	^self addChange: (RenameClassChange rename: class name to: newName)! !
!CompositeRefactoryChange categoriesFor: #=!comparing!public! !
!CompositeRefactoryChange categoriesFor: #addChange:!accessing!public! !
!CompositeRefactoryChange categoriesFor: #addChangeFirst:!accessing!public! !
!CompositeRefactoryChange categoriesFor: #addClassVariable:to:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #addInstanceVariable:to:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #addPool:to:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #basicExecuteNotifying:!private! !
!CompositeRefactoryChange categoriesFor: #changeForClass:selector:!accessing!public! !
!CompositeRefactoryChange categoriesFor: #changeForMetaclass:selector:!accessing!public! !
!CompositeRefactoryChange categoriesFor: #changes!inspector accessing!private! !
!CompositeRefactoryChange categoriesFor: #changes:!inspector accessing!private! !
!CompositeRefactoryChange categoriesFor: #changesSize!accessing!public! !
!CompositeRefactoryChange categoriesFor: #compile:in:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #compile:in:categories:!public! !
!CompositeRefactoryChange categoriesFor: #compile:in:classified:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #defineClass:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #executeNotifying:!private! !
!CompositeRefactoryChange categoriesFor: #flattenOnto:!private! !
!CompositeRefactoryChange categoriesFor: #hash!comparing!public! !
!CompositeRefactoryChange categoriesFor: #initialize!initializing!public! !
!CompositeRefactoryChange categoriesFor: #postCopy!copying!public! !
!CompositeRefactoryChange categoriesFor: #printOn:!printing!public! !
!CompositeRefactoryChange categoriesFor: #problemCount!accessing!public! !
!CompositeRefactoryChange categoriesFor: #removeChange:!inspector accessing!private! !
!CompositeRefactoryChange categoriesFor: #removeClass:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #removeClassNamed:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #removeClassVariable:from:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #removeInstanceVariable:from:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #removeMethod:from:!public!refactory/changes! !
!CompositeRefactoryChange categoriesFor: #renameChangesForClass:to:!accessing!public! !
!CompositeRefactoryChange categoriesFor: #renameClass:to:!public!refactory/changes! !

!CompositeRefactoryChange class methodsFor!

named: aString 
	^(self new)
		name: aString;
		yourself! !
!CompositeRefactoryChange class categoriesFor: #named:!instance creation!public! !

