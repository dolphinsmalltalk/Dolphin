"Filed out from Dolphin Smalltalk"!

StValueNode subclass: #StBraceArrayNode
	instanceVariableNames: 'left statements periods right'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!StBraceArrayNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
children!accessing!public! !
childrenDo:!accessing!enumerating!public! !
hash!comparing!public! !
isDynamicArray!public!testing! !
lastIsReturn!public!testing! !
left!accessing!public! !
left:!accessing!public! !
needsParenthesis!public!testing! !
periods!accessing!public! !
periods:!accessing!public! !
postCopy!copying!public! !
precedence!constants!public! !
right!accessing!public! !
right:!accessing!public! !
startWithoutParentheses!accessing!public! !
statements!accessing!public! !
statements:!accessing!public! !
stopWithoutParentheses!accessing!public! !
uses:!public!testing! !
!

!StBraceArrayNode class methodsFor!

statements: statements
	^self new statements: statements! !
!StBraceArrayNode class categoriesForMethods!
statements:!instance creation!public! !
!

