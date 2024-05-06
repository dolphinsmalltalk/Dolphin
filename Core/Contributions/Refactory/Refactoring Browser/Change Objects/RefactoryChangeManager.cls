"Filed out from Dolphin Smalltalk"!

Object subclass: #RefactoryChangeManager
	instanceVariableNames: 'undo redo isPerformingRefactoring'
	classVariableNames: 'Instance UndoSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RefactoryChangeManager guid: (GUID fromString: '{5bc74f5c-1bcd-4890-ad8b-bf8a58b6df7f}')!

RefactoryChangeManager comment: ''!

!RefactoryChangeManager categoriesForClass!Refactory-Change Objects! !

!RefactoryChangeManager methodsFor!

addUndo: aRefactoringChange 
	undo addLast: aRefactoringChange.
	undo size > UndoSize ifTrue: [undo removeFirst].
	redo := OrderedCollection new!

clearUndoRedoList
	undo := OrderedCollection new.
	redo := OrderedCollection new!

connectToChanges
	ChangeSet addDependent: self!

discardLastChange
	undo isEmpty ifTrue: [^self].
	undo removeLast!

disconnectFromChanges
	ChangeSet removeDependent: self!

hasRedoableOperations
	^redo notEmpty!

hasUndoableOperations
	^undo notEmpty!

ignoreChangesWhile: aBlock 
	isPerformingRefactoring ifTrue: [^aBlock value].
	isPerformingRefactoring := true.
	aBlock ensure: [isPerformingRefactoring := false]!

initialize
	undo := OrderedCollection new.
	redo := OrderedCollection new.
	isPerformingRefactoring := false.
	self connectToChanges!

performChange: aRefactoringChange 
	self ignoreChangesWhile: [self addUndo: aRefactoringChange execute]!

redoChange
	^redo last!

redoOperation
	redo isEmpty ifTrue: [^self].
	self ignoreChangesWhile: 
			[| change |
			change := redo removeLast.
			undo add: change execute]!

release
	super release.
	self disconnectFromChanges!

undoChange
	^undo last!

undoOperation
	undo isEmpty ifTrue: [^self].
	self ignoreChangesWhile: 
			[| change |
			change := undo removeLast.
			redo add: change execute]!

update: anAspectSymbol with: aParameter from: aSender 
	| changeType |
	(aSender == ChangeSet and: [isPerformingRefactoring not]) ifFalse: [^self].
	anAspectSymbol == #reorganizeClass: ifTrue: [^self].
	changeType := (anAspectSymbol isString 
				ifTrue: [anAspectSymbol asString]
				ifFalse: ['class']) asLowercase.
	(changeType indexOfSubCollection: 'class' startingAt: 1) 
		+ (changeType indexOfSubCollection: 'selector' startingAt: 1) > 0 
		ifTrue: [self clearUndoRedoList]! !

!RefactoryChangeManager categoriesForMethods!
addUndo:!public!public access! !
clearUndoRedoList!private! !
connectToChanges!initialize/release!public! !
discardLastChange!public!public access! !
disconnectFromChanges!initialize/release!public! !
hasRedoableOperations!public! !
hasUndoableOperations!public! !
ignoreChangesWhile:!public!public access! !
initialize!initialize/release!public! !
performChange:!public!public access! !
redoChange!public!public access! !
redoOperation!public!public access! !
release!initialize/release!public! !
undoChange!public!public access! !
undoOperation!public!public access! !
update:with:from:!public!updating! !
!

!RefactoryChangeManager class methodsFor!

initialize
	self nuke.
	UndoSize := 25!

instance
	Instance isNil 
		ifTrue: 
			[Instance := self basicNew.
			Instance initialize].
	^Instance!

new
	^self shouldNotImplement!

nuke
	Instance notNil ifTrue: [Instance release].
	Instance := nil!

onPreStripImage
	"Private - The image is about to be stripped. Nil any lazily initialized class variables."

	self nuke!

undoSize
	^UndoSize!

undoSize: anInteger 
	UndoSize := anInteger max: 0!

uninitialize
	self nuke! !

!RefactoryChangeManager class categoriesForMethods!
initialize!class initialization!public! !
instance!instance creation!public! !
new!instance creation!public! !
nuke!public!public access! !
onPreStripImage!class hierarchy-removing!private! !
undoSize!class initialization!public! !
undoSize:!class initialization!public! !
uninitialize!class initialization!public! !
!

