"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RefactoryChangeManager
	instanceVariableNames: 'undo redo isPerformingRefactoring'
	classVariableNames: 'Instance UndoSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!RefactoryChangeManager categoriesFor: #addUndo:!public!public access! !
!RefactoryChangeManager categoriesFor: #clearUndoRedoList!private! !
!RefactoryChangeManager categoriesFor: #connectToChanges!initialize/release!public! !
!RefactoryChangeManager categoriesFor: #discardLastChange!public!public access! !
!RefactoryChangeManager categoriesFor: #disconnectFromChanges!initialize/release!public! !
!RefactoryChangeManager categoriesFor: #hasRedoableOperations!public! !
!RefactoryChangeManager categoriesFor: #hasUndoableOperations!public! !
!RefactoryChangeManager categoriesFor: #ignoreChangesWhile:!public!public access! !
!RefactoryChangeManager categoriesFor: #initialize!initialize/release!public! !
!RefactoryChangeManager categoriesFor: #performChange:!public!public access! !
!RefactoryChangeManager categoriesFor: #redoChange!public!public access! !
!RefactoryChangeManager categoriesFor: #redoOperation!public!public access! !
!RefactoryChangeManager categoriesFor: #release!initialize/release!public! !
!RefactoryChangeManager categoriesFor: #undoChange!public!public access! !
!RefactoryChangeManager categoriesFor: #undoOperation!public!public access! !
!RefactoryChangeManager categoriesFor: #update:with:from:!public!updating! !

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
!RefactoryChangeManager class categoriesFor: #initialize!class initialization!public! !
!RefactoryChangeManager class categoriesFor: #instance!instance creation!public! !
!RefactoryChangeManager class categoriesFor: #new!instance creation!public! !
!RefactoryChangeManager class categoriesFor: #nuke!public!public access! !
!RefactoryChangeManager class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!RefactoryChangeManager class categoriesFor: #undoSize!class initialization!public! !
!RefactoryChangeManager class categoriesFor: #undoSize:!class initialization!public! !
!RefactoryChangeManager class categoriesFor: #uninitialize!class initialization!public! !

