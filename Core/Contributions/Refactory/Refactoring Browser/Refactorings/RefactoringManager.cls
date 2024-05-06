"Filed out from Dolphin Smalltalk"!

Object subclass: #RefactoringManager
	instanceVariableNames: 'refactorings'
	classVariableNames: 'Instance'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!RefactoringManager categoriesForMethods!
addRefactoring:!public!public access! !
initialize!initialize/release!public! !
printOn:!printing!public! !
!

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

!RefactoringManager class categoriesForMethods!
instance!instance creation!public! !
new!instance creation!public! !
nuke!public!public access! !
onPreStripImage!class hierarchy-removing!public! !
preUnloadActionFor:!parcel load/unload/save!public! !
uninitialize!class hierarchy-removing!public! !
!

