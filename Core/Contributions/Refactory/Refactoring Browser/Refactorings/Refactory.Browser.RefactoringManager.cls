"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.RefactoringManager'
	instanceVariableNames: 'refactorings'
	classVariableNames: 'Instance'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoringManager guid: (Core.GUID fromString: '{91adefd7-2941-4e19-bea0-6541c7033e57}')!
Refactory.Browser.RefactoringManager comment: ''!
!Refactory.Browser.RefactoringManager categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RefactoringManager methodsFor!

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
!Refactory.Browser.RefactoringManager categoriesFor: #addRefactoring:!public!public access! !
!Refactory.Browser.RefactoringManager categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.RefactoringManager categoriesFor: #printOn:!printing!public! !

!Refactory.Browser.RefactoringManager class methodsFor!

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
!Refactory.Browser.RefactoringManager class categoriesFor: #instance!instance creation!public! !
!Refactory.Browser.RefactoringManager class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.RefactoringManager class categoriesFor: #nuke!public!public access! !
!Refactory.Browser.RefactoringManager class categoriesFor: #onPreStripImage!class hierarchy-removing!public! !
!Refactory.Browser.RefactoringManager class categoriesFor: #preUnloadActionFor:!parcel load/unload/save!public! !
!Refactory.Browser.RefactoringManager class categoriesFor: #uninitialize!class hierarchy-removing!public! !

