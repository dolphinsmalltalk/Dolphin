"Filed out from Dolphin Smalltalk 7"!

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

acceptVisitor: anStParseNodeVisitor
	^anStParseNodeVisitor visitArrayNode: self!

left
	^left!

left: anInteger 
	left := anInteger!

periods
	^periods!

periods: anOrderedCollection 
	periods := anOrderedCollection!

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

statements: anOrderedCollection
	statements := anOrderedCollection.
	statements do: [:statement | statement parent: self]!

stopWithoutParentheses
	^right! !
!StBraceArrayNode categoriesFor: #acceptVisitor:!public! !
!StBraceArrayNode categoriesFor: #left!public! !
!StBraceArrayNode categoriesFor: #left:!public! !
!StBraceArrayNode categoriesFor: #periods!public! !
!StBraceArrayNode categoriesFor: #periods:!public! !
!StBraceArrayNode categoriesFor: #precedence!constants!public! !
!StBraceArrayNode categoriesFor: #right!public! !
!StBraceArrayNode categoriesFor: #right:!public! !
!StBraceArrayNode categoriesFor: #startWithoutParentheses!public! !
!StBraceArrayNode categoriesFor: #statements!public! !
!StBraceArrayNode categoriesFor: #statements:!public! !
!StBraceArrayNode categoriesFor: #stopWithoutParentheses!public! !

