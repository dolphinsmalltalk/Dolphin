"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ReferenceFinder
	instanceVariableNames: 'backlinks objectsLeft testBlock foundBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ReferenceFinder guid: (GUID fromString: '{bfcfc047-1208-409c-965c-bda23170a192}')!
ReferenceFinder comment: ''!
!ReferenceFinder categoriesForClass!Refactory-Browser! !
!ReferenceFinder methodsFor!

addBacklinkFrom: newObject to: anObject 
	backlinks last at: newObject put: anObject!

addBacklinkLevel
	backlinks addLast: self identityDictionaryClass new!

backlinkFor: anObject
	backlinks do: 
			[:each |
			| toObject |
			toObject := each lookup: anObject.
			toObject notNil ifTrue: [^toObject]].
	^nil!

computePathFor: anObject 
	| path object |
	path := OrderedCollection new.
	object := anObject.
	[object isNil] whileFalse: 
			[path addLast: object.
			object := self backlinkFor: object].
	^path reverse!

find
	self searchForObject!

findAllPaths: aBlock 
	| paths |
	paths := OrderedCollection new.
	foundBlock := [:path | paths add: path].
	testBlock := aBlock.
	self find.
	^paths!

findPath: aBlock 
	foundBlock := [:path | ^path].
	testBlock := aBlock.
	self find.
	^nil!

hasSearched: newObject
	^backlinks anySatisfy: [:each | each includesKey: newObject]!

identityDictionaryClass
	^IdentityDictionary!

initialize
	self startFrom: Smalltalk!

printToDoNotice
	Transcript
		nextPutAll: 'Level ';
		print: backlinks size;
		nextPutAll: ' with ';
		print: objectsLeft size;
		nextPutAll: ' objects to search';
		cr!

processLinkTo: newObject from: anObject
	newObject basicClass instSize + newObject basicSize = 0
		ifTrue: 
			[^(testBlock value: newObject)
				ifTrue: 
					[(self computePathFor: anObject)
						addLast: newObject;
						yourself]
				ifFalse: [nil]].
	(self hasSearched: newObject)
		ifFalse: 
			[(testBlock value: newObject)
				ifTrue: 
					[^(self computePathFor: anObject)
						addLast: newObject;
						yourself].
			objectsLeft addLast: newObject.
			self addBacklinkFrom: newObject to: anObject].
	^nil!

searchForObject
	
	[| objects |
	self printToDoNotice.
	objects := objectsLeft.
	objectsLeft := OrderedCollection new.
	self addBacklinkLevel.
	objects do: 
			[:each | 
			| path |
			(path := self searchVariablesIn: each) notNil 
				ifTrue: [foundBlock value: path].
			(path := self searchIndicesIn: each) notNil 
				ifTrue: [foundBlock value: path]].
	objectsLeft isEmpty] 
			whileFalse!

searchIndicesIn: anObject 
	#rbFix.	"Ignore weak pointers - in Dolphin only indexable instance variables can be weak"
	anObject isWeak ifTrue: [^nil].
	1 to: anObject basicSize
		do: 
			[:i | 
			| path |
			(path := self processLinkTo: (anObject basicAt: i) from: anObject) notNil ifTrue: [^path]].
	^nil!

searchVariablesIn: anObject 
	1 to: anObject basicClass instSize
		do: 
			[:i | 
			| path |
			(path := self processLinkTo: (anObject instVarAt: i) from: anObject) 
				notNil ifTrue: [^path]].
	^nil!

startFrom: anObject 
	backlinks := OrderedCollection new.
	self addBacklinkLevel.
	objectsLeft := OrderedCollection with: anObject.
	backlinks last at: anObject put: nil.
	#rbFix.	"Because an Object will be found on the path Smalltalk->Processor->active Process->obj, we add the active process to the backlinks so it appears that it has already been searched"
	backlinks last at: Processor activeProcess put: nil! !
!ReferenceFinder categoriesFor: #addBacklinkFrom:to:!helpers!private! !
!ReferenceFinder categoriesFor: #addBacklinkLevel!helpers!private! !
!ReferenceFinder categoriesFor: #backlinkFor:!private! !
!ReferenceFinder categoriesFor: #computePathFor:!private! !
!ReferenceFinder categoriesFor: #find!private! !
!ReferenceFinder categoriesFor: #findAllPaths:!accessing!public! !
!ReferenceFinder categoriesFor: #findPath:!accessing!public! !
!ReferenceFinder categoriesFor: #hasSearched:!private! !
!ReferenceFinder categoriesFor: #identityDictionaryClass!private! !
!ReferenceFinder categoriesFor: #initialize!initialize/release!private! !
!ReferenceFinder categoriesFor: #printToDoNotice!private! !
!ReferenceFinder categoriesFor: #processLinkTo:from:!private! !
!ReferenceFinder categoriesFor: #searchForObject!private! !
!ReferenceFinder categoriesFor: #searchIndicesIn:!private! !
!ReferenceFinder categoriesFor: #searchVariablesIn:!private! !
!ReferenceFinder categoriesFor: #startFrom:!initialize/release!public! !

!ReferenceFinder class methodsFor!

findAllPathsTo: anObject 
	"self findAllPathsTo: (Object compiledMethodAt: #printString)"

	^self findAllPathsTo: anObject from: Smalltalk!

findAllPathsTo: anObject from: fromObject 
	"self findAllPathsTo: (Object compiledMethodAt: #printString) from: Object"

	^(self new)
		startFrom: fromObject;
		findAllPaths: [:each | each == anObject]!

findAllPathsToInstanceOf: aBehavior 
	"self findAllPathsToInstanceOf: RefactoringBrowser"

	^self findAllPathsToInstanceOf: aBehavior from: Smalltalk!

findAllPathsToInstanceOf: aBehavior from: fromObject 
	"self findAllPathsToInstanceOf: RefactoringBrowser from: ScheduledControllers"

	^(self new)
		startFrom: fromObject;
		findAllPaths: [:each | each basicClass == aBehavior]!

findPathTo: anObject 
	^self findPathTo: anObject from: Smalltalk!

findPathTo: anObject from: fromObject 
	"self findPathTo: RefactoringManager instance from: Object"

	^(self new)
		startFrom: fromObject;
		findPath: [:each | each == anObject]!

findPathToInstanceOf: aBehavior 
	^self findPathToInstanceOf: aBehavior from: Smalltalk!

findPathToInstanceOf: aBehavior from: fromObject 
	"self findPathToInstanceOf: RefactoringManager from: Object"

	^(self new)
		startFrom: fromObject;
		findPath: [:each | each basicClass == aBehavior]!

new
	^(super new)
		initialize;
		yourself! !
!ReferenceFinder class categoriesFor: #findAllPathsTo:!accessing!public! !
!ReferenceFinder class categoriesFor: #findAllPathsTo:from:!accessing!public! !
!ReferenceFinder class categoriesFor: #findAllPathsToInstanceOf:!accessing!public! !
!ReferenceFinder class categoriesFor: #findAllPathsToInstanceOf:from:!accessing!public! !
!ReferenceFinder class categoriesFor: #findPathTo:!accessing!public! !
!ReferenceFinder class categoriesFor: #findPathTo:from:!accessing!public! !
!ReferenceFinder class categoriesFor: #findPathToInstanceOf:!accessing!public! !
!ReferenceFinder class categoriesFor: #findPathToInstanceOf:from:!accessing!public! !
!ReferenceFinder class categoriesFor: #new!instance creation!public! !

