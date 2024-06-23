"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.ReferenceFinder'
	instanceVariableNames: 'backlinks objectsLeft testBlock foundBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.ReferenceFinder guid: (Core.GUID fromString: '{bfcfc047-1208-409c-965c-bda23170a192}')!

Refactory.Browser.ReferenceFinder comment: ''!

!Refactory.Browser.ReferenceFinder categoriesForClass!Refactory-Browser! !

!Refactory.Browser.ReferenceFinder methodsFor!

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
			(path := self searchVariablesIn: each) notNil ifTrue: [foundBlock value: path].
			(path := self searchIndicesIn: each) notNil ifTrue: [foundBlock value: path]].
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

!Refactory.Browser.ReferenceFinder categoriesForMethods!
addBacklinkFrom:to:!helpers!private! !
addBacklinkLevel!helpers!private! !
backlinkFor:!private! !
computePathFor:!private! !
find!private! !
findAllPaths:!accessing!public! !
findPath:!accessing!public! !
hasSearched:!private! !
identityDictionaryClass!private! !
initialize!initialize/release!private! !
printToDoNotice!private! !
processLinkTo:from:!private! !
searchForObject!private! !
searchIndicesIn:!private! !
searchVariablesIn:!private! !
startFrom:!initialize/release!public! !
!

!Refactory.Browser.ReferenceFinder class methodsFor!

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

!Refactory.Browser.ReferenceFinder class categoriesForMethods!
findAllPathsTo:!accessing!public! !
findAllPathsTo:from:!accessing!public! !
findAllPathsToInstanceOf:!accessing!public! !
findAllPathsToInstanceOf:from:!accessing!public! !
findPathTo:!accessing!public! !
findPathTo:from:!accessing!public! !
findPathToInstanceOf:!accessing!public! !
findPathToInstanceOf:from:!accessing!public! !
new!instance creation!public! !
!

