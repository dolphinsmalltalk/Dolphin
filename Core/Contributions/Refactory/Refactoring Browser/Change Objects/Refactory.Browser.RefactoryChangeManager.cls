"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.RefactoryChangeManager'
	instanceVariableNames: 'undo redo isPerformingRefactoring'
	classVariableNames: 'Instance UndoSize'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoryChangeManager guid: (Core.GUID fromString: '{5bc74f5c-1bcd-4890-ad8b-bf8a58b6df7f}')!
Refactory.Browser.RefactoryChangeManager comment: ''!
!Refactory.Browser.RefactoryChangeManager categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RefactoryChangeManager methodsFor!

addUndo: aRefactoringChange
	undo addLast: aRefactoringChange.
	undo size > UndoSize ifTrue: [undo removeFirst].
	redo := OrderedCollection new!

clearUndoRedoList
	undo := OrderedCollection new.
	redo := OrderedCollection new!

discardLastChange
	undo isEmpty ifTrue: [^self].
	undo removeLast!

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
	isPerformingRefactoring := false!

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

undoChange
	^undo last!

undoOperation
	undo isEmpty ifTrue: [^self].
	self ignoreChangesWhile: 
			[| change |
			change := undo removeLast.
			redo add: change execute]! !
!Refactory.Browser.RefactoryChangeManager categoriesForMethods!
addUndo:!public!public access! !
clearUndoRedoList!private! !
discardLastChange!public!public access! !
hasRedoableOperations!public! !
hasUndoableOperations!public! !
ignoreChangesWhile:!public!public access! !
initialize!initialize/release!public! !
performChange:!public!public access! !
redoChange!public!public access! !
redoOperation!public!public access! !
undoChange!public!public access! !
undoOperation!public!public access! !
!

!Refactory.Browser.RefactoryChangeManager class methodsFor!

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
!Refactory.Browser.RefactoryChangeManager class categoriesForMethods!
initialize!class initialization!public! !
instance!instance creation!public! !
new!instance creation!public! !
nuke!public!public access! !
onPreStripImage!class hierarchy-removing!private! !
undoSize!class initialization!public! !
undoSize:!class initialization!public! !
uninitialize!class initialization!public! !
!

