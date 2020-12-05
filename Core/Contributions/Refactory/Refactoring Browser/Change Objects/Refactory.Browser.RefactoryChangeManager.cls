"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.RefactoryChangeManager'
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
	changeType := (anAspectSymbol isString ifTrue: [anAspectSymbol asString] ifFalse: ['class'])
				asLowercase.
	(changeType indexOfSubCollection: 'class' startingAt: 1)
		+ (changeType indexOfSubCollection: 'selector' startingAt: 1) > 0
		ifTrue: [self clearUndoRedoList]! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #addUndo:!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #clearUndoRedoList!private! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #connectToChanges!initialize/release!public! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #discardLastChange!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #disconnectFromChanges!initialize/release!public! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #hasRedoableOperations!public! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #hasUndoableOperations!public! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #ignoreChangesWhile:!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #performChange:!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #redoChange!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #redoOperation!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #release!initialize/release!public! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #undoChange!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #undoOperation!public!public access! !
!Refactory.Browser.RefactoryChangeManager categoriesFor: #update:with:from:!public!updating! !

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
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #initialize!class initialization!public! !
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #instance!instance creation!public! !
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #nuke!public!public access! !
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #undoSize!class initialization!public! !
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #undoSize:!class initialization!public! !
!Refactory.Browser.RefactoryChangeManager class categoriesFor: #uninitialize!class initialization!public! !

