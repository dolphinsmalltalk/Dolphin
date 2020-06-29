"Filed out from Dolphin Smalltalk 7"!

StValueNode subclass: #StBraceArrayNode
	instanceVariableNames: 'left statements periods right'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StBraceArrayNode guid: (GUID fromString: '{296a5d5c-f22a-48c3-a889-53df20fcd4b2}')!
StBraceArrayNode comment: 'StBraceArrayNode is a parse tree node for runtime arrays.

Instance Variables
	left:	 		<Integer | nil> position of {
	periods: 		<SequenceableCollection> of <Integer> the positions of all the periods that separate the statements
	right: 		<Integer | nil> position of }
	statements: 	<SequenceableCollection> of <StStatementNode> the statement nodes'!
!StBraceArrayNode categoriesForClass!System-Compiler! !
!StBraceArrayNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	self statements size = anObject statements size ifFalse: [^false].
	self statements with: anObject statements do: [:first :second | first = second ifFalse: [^false]].
	^true!

acceptVisitor: anStParseNodeVisitor
	^anStParseNodeVisitor visitArrayNode: self!

children
	^statements!

childrenDo: aMonadicValuable
	statements do: aMonadicValuable!

hash
	^self hashForCollection: self statements!

isDynamicArray
	^true!

lastIsReturn
	statements isEmpty ifTrue: [^false].
	^statements last lastIsReturn!

left
	^left!

left: anInteger 
	left := anInteger!

needsParenthesis
	^false!

periods
	^periods!

periods: anOrderedCollection 
	periods := anOrderedCollection!

postCopy
	super postCopy.
	self statements: (statements collect: [:each | each copy]).
	^self!

precedence
	^0!

right
	^right!

right: anInteger 
	right := anInteger!

startWithoutParentheses
	^left!

statements
	^statements!

statements: stmtCollection 
	statements := stmtCollection.
	statements do: [:each | each parent: self]!

stopWithoutParentheses
	^right!

uses: aNode
	^(statements anySatisfy: [:each | each == aNode]) or: [self isUsed]! !
!StBraceArrayNode categoriesFor: #=!comparing!public! !
!StBraceArrayNode categoriesFor: #acceptVisitor:!public!visitor! !
!StBraceArrayNode categoriesFor: #children!accessing!public! !
!StBraceArrayNode categoriesFor: #childrenDo:!accessing!enumerating!public! !
!StBraceArrayNode categoriesFor: #hash!comparing!public! !
!StBraceArrayNode categoriesFor: #isDynamicArray!public!testing! !
!StBraceArrayNode categoriesFor: #lastIsReturn!public!testing! !
!StBraceArrayNode categoriesFor: #left!accessing!public! !
!StBraceArrayNode categoriesFor: #left:!accessing!public! !
!StBraceArrayNode categoriesFor: #needsParenthesis!public!testing! !
!StBraceArrayNode categoriesFor: #periods!accessing!public! !
!StBraceArrayNode categoriesFor: #periods:!accessing!public! !
!StBraceArrayNode categoriesFor: #postCopy!copying!public! !
!StBraceArrayNode categoriesFor: #precedence!constants!public! !
!StBraceArrayNode categoriesFor: #right!accessing!public! !
!StBraceArrayNode categoriesFor: #right:!accessing!public! !
!StBraceArrayNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StBraceArrayNode categoriesFor: #statements!accessing!public! !
!StBraceArrayNode categoriesFor: #statements:!accessing!public! !
!StBraceArrayNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StBraceArrayNode categoriesFor: #uses:!public!testing! !

!StBraceArrayNode class methodsFor!

statements: statements
	^self new statements: statements! !
!StBraceArrayNode class categoriesFor: #statements:!instance creation!public! !

