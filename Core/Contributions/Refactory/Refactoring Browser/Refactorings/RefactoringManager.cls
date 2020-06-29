"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RefactoringManager
	instanceVariableNames: 'refactorings'
	classVariableNames: 'Instance'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RefactoringManager guid: (GUID fromString: '{91adefd7-2941-4e19-bea0-6541c7033e57}')!
RefactoringManager comment: ''!
!RefactoringManager categoriesForClass!Refactory-Refactorings! !
!RefactoringManager methodsFor!

addRefactoring: aRefactoring 
	RefactoryChangeManager instance performChange: aRefactoring changes.
	refactorings add: aRefactoring class name!

initialize
	refactorings := Bag new!

printOn: aStream 
	aStream nextPutAll: '#		Refactoring';
		cr;
		nextPutAll: '---		-----------------------------------------------';
		cr.
	refactorings asSet asSortedCollection do: 
			[:name | 
			aStream nextPutAll: (refactorings occurrencesOf: name) printString;
				nextPutAll: '		';
				nextPutAll: name;
				cr]! !
!RefactoringManager categoriesFor: #addRefactoring:!public!public access! !
!RefactoringManager categoriesFor: #initialize!initialize/release!public! !
!RefactoringManager categoriesFor: #printOn:!printing!public! !

!RefactoringManager class methodsFor!

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
	#rbFix. "Assist Dolphin's image stripping by clearing away the undo history"
	self nuke!

preUnloadActionFor: aParcel
	^RefactoringManager nuke!

uninitialize
	self nuke! !
!RefactoringManager class categoriesFor: #instance!instance creation!public! !
!RefactoringManager class categoriesFor: #new!instance creation!public! !
!RefactoringManager class categoriesFor: #nuke!public!public access! !
!RefactoringManager class categoriesFor: #onPreStripImage!class hierarchy-removing!public! !
!RefactoringManager class categoriesFor: #preUnloadActionFor:!parcel load/unload/save!public! !
!RefactoringManager class categoriesFor: #uninitialize!class hierarchy-removing!public! !

