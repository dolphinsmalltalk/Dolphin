"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryChange subclass: #'Refactory.Browser.CompositeRefactoryChange'
	instanceVariableNames: 'changes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.CompositeRefactoryChange guid: (Core.GUID fromString: '{74a295ee-f099-43f1-bd6e-d82d0b07d9d9}')!
Refactory.Browser.CompositeRefactoryChange comment: 'RefactoryBuilder represents a series of changes (RefactoryChange) that need to be performed. It provides transaction-like behavior by defering all changes until it is told to commit them (#doIt).

Instance Variables:
	changes	<SequenceableCollection of: RefactoryChange>	the changes that need to be performed'!
!Refactory.Browser.CompositeRefactoryChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.CompositeRefactoryChange methodsFor!

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

addClassVariable: aString to: aClass
	^self addChange: (AddClassVariableChange add: aString to: aClass)!

addInstanceVariable: aString to: aClass
	^self addChange: (AddInstanceVariableChange add: aString to: aClass)!

afterText
	| stream |
	stream := String writeStream.
	self changesDo: 
			[:each |
			stream position == 0
				ifFalse: 
					[stream
						cr;
						cr].
			stream print: each].
	^stream contents!

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

changesDo: aMonadicValuable
	changes do: [:each | each changesDo: aMonadicValuable]!

changesSize
	^changes inject: 0 into: [:sum :each | sum + each changesSize]!

comment: aString in: aClass
	^self addChange: (ClassCommentChange comment: aString in: aClass)!

compile: aString in: aClassDescription
	^self addChange: (AddMethodChange compile: aString in: aClassDescription)!

compile: aString in: aClass categories: anArray
	^self addChange: (AddMethodChange
				compile: aString
				in: aClass
				categories: anArray)!

compile: source in: class classified: aProtocol
	Notification deprecated.
	^self addChange: (AddMethodChange
				compile: source
				in: class
				classified: aProtocol)!

compile: aString in: aRBClass environment: aRBNamespaceClass categories: aCollection package: aPackage
	^self addChange: (AddMethodChange
				compile: aString
				in: aRBClass
				environment: aRBNamespaceClass
				categories: aCollection
				package: aPackage)!

defineClass: aString
	^self addChange: (AddClassChange definition: aString)!

executeNotifying: aBlock
	#rbFix.	"Extract to method so can invoke from subclass of subclass where both override"
	^self basicExecuteNotifying: aBlock!

hash
	^changes size!

initialize
	super initialize.
	changes := OrderedCollection new!

lastChangeMatching: aMonadicValuable
	changes reverseDo: 
			[:each |
			| change |
			change := each lastChangeMatching: aMonadicValuable.
			change notNil ifTrue: [^change]].
	^nil!

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
	changes remove: aChange ifAbsent: nil!

removeClass: aClass
	^self removeClassNamed: aClass fullName!

removeClassNamed: aString
	^self addChange: (RemoveClassChange removeClassName: aString)!

removeClassVariable: aString from: aClass
	^self addChange: (RemoveClassVariableChange remove: aString from: aClass)!

removeInstanceVariable: aString from: aClass
	^self addChange: (RemoveInstanceVariableChange remove: aString from: aClass)!

removeSelector: aSymbol from: aClass
	^self addChange: (RemoveMethodChange remove: aSymbol from: aClass)!

renameChangesForClass: aClassName to: newClassName 
	^(self copy)
		changes: (self changes 
					collect: [:each | each renameChangesForClass: aClassName to: newClassName]);
		yourself!

renameClass: aClass to: aString
	^self addChange: (RenameClassChange rename: aClass name to: aString)! !
!Refactory.Browser.CompositeRefactoryChange categoriesForMethods!
=!comparing!public! !
addChange:!adding!public! !
addChangeFirst:!adding!public! !
addClassVariable:to:!adding!public! !
addInstanceVariable:to:!adding!public! !
afterText!printing!public! !
basicExecuteNotifying:!applying!private! !
changeForClass:selector:!public!searching! !
changeForMetaclass:selector:!public!searching! !
changes!accessing!private! !
changes:!accessing!private! !
changesDo:!enumerating!public! !
changesSize!accessing!public! !
comment:in:!adding!public! !
compile:in:!adding!public! !
compile:in:categories:!adding!public! !
compile:in:classified:!adding!public! !
compile:in:environment:categories:package:!adding!public! !
defineClass:!adding!public! !
executeNotifying:!applying!private! !
hash!comparing!public! !
initialize!initializing!private! !
lastChangeMatching:!public!searching! !
postCopy!copying!private! !
printOn:!printing!public! !
problemCount!accessing!public! !
removeChange:!private!removing! !
removeClass:!adding!public! !
removeClassNamed:!adding!public! !
removeClassVariable:from:!adding!public! !
removeInstanceVariable:from:!adding!public! !
removeSelector:from:!adding!public! !
renameChangesForClass:to:!helpers!private! !
renameClass:to:!adding!public! !
!

!Refactory.Browser.CompositeRefactoryChange class methodsFor!

named: aString 
	^(self new)
		name: aString;
		yourself! !
!Refactory.Browser.CompositeRefactoryChange class categoriesForMethods!
named:!instance creation!public! !
!

