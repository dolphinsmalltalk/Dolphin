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

children
	^statements!

childrenDo: aMonadicValuable
	self statements do: aMonadicValuable!

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
!StBraceArrayNode categoriesFor: #acceptVisitor:!public!visitor! !
!StBraceArrayNode categoriesFor: #children!accessing!public! !
!StBraceArrayNode categoriesFor: #childrenDo:!accessing!enumerating!public! !
!StBraceArrayNode categoriesFor: #left!accessing!public! !
!StBraceArrayNode categoriesFor: #left:!accessing!public! !
!StBraceArrayNode categoriesFor: #periods!accessing!public! !
!StBraceArrayNode categoriesFor: #periods:!accessing!public! !
!StBraceArrayNode categoriesFor: #precedence!constants!public! !
!StBraceArrayNode categoriesFor: #right!accessing!public! !
!StBraceArrayNode categoriesFor: #right:!accessing!public! !
!StBraceArrayNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StBraceArrayNode categoriesFor: #statements!accessing!public! !
!StBraceArrayNode categoriesFor: #statements:!accessing!public! !
!StBraceArrayNode categoriesFor: #stopWithoutParentheses!accessing!public! !

