"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBSourceFormatter
	subclass: #'Refactory.Browser.RBFormatter'
	instanceVariableNames: 'firstLineLength'
	classVariableNames: 'MaximumArgumentsPerLine SelectorsToLeaveOnLine SelectorsToStartOnNewLine'
	imports: #(#{External.ExtCallArgTypes})
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RBFormatter guid: (Core.GUID fromString: '{75e99f13-8ba7-47c0-87c4-8987b5a20900}')!

Refactory.Browser.RBFormatter comment: 'RBFormatter is an <StParseNodeVisitor> for pretty printing Smalltalk methods.
'!

!Refactory.Browser.RBFormatter categoriesForClass!System-Compiler-Formatters! !

!Refactory.Browser.RBFormatter methodsFor!

acceptBlockNode: aBlockNode startBlockString: startBlockString
	| multiline formattedBody formatter |
	formatter := self copy
				lineStart: 0;
				yourself.
	formattedBody := formatter format: aBlockNode body.
	multiline := self currentLineLength + formattedBody size > MaxLineLength or: [formatter isMultiLine].
	multiline ifTrue: [self newLine].
	codeStream nextPutAll: startBlockString.
	aBlockNode arguments do: 
			[:each |
			codeStream nextPut: $:.
			self visitNode: each.
			self space].
	aBlockNode arguments notEmpty
		ifTrue: 
			[codeStream nextPut: $|.
			multiline ifTrue: [self newLine] ifFalse: [codeStream space]].
	codeStream nextPutAll: formattedBody!

firstLineLength
	^firstLineLength isNil ifTrue: [codeStream position] ifFalse: [firstLineLength]!

formatArray: anArrayNode
	| formattedArgs multiline length statements count |
	statements := anArrayNode statements.
	count := statements size.
	count == 0 ifTrue: [^self].
	formattedArgs := Array writeStream: count.
	multiline := false.
	length := 0.
	indent := indent + 1.
	statements do: 
			[:each |
			| formatter string |
			formatter := self copy.
			string := formatter format: each.
			formattedArgs nextPut: string.
			length := length + string size + 2.
			multiline := multiline or: [formatter isMultiLine]].
	formattedArgs := formattedArgs collection.
	multiline := multiline or: [length + 1 + self currentLineLength > MaxLineLength].
	formattedArgs do: 
			[:each |
			multiline ifTrue: [self newLine] ifFalse: [self space].
			codeStream nextPutAll: each]
		separatedBy: [codeStream nextPut: $.].
	indent := indent - 1.
	multiline ifTrue: [self newLine] ifFalse: [self space]!

formatMessage: aMessageNode cascade: cascadeBoolean
	| selectorParts arguments multiLine formattedArgs length firstArgLength argumentCount |
	selectorParts := aMessageNode selectorParts.
	arguments := aMessageNode arguments.
	argumentCount := arguments size.
	formattedArgs := Array new: argumentCount.
	multiLine := argumentCount > MaximumArgumentsPerLine.
	length := aMessageNode selector size + argumentCount + 1.
	firstArgLength := 0.
	indent := indent + 1.
	1 to: argumentCount
		do: 
			[:i |
			| formatter string |
			formatter := self copy
						lineStart: 0 - (selectorParts at: i) length;
						yourself.
			string := formatter format: (arguments at: i).
			formattedArgs at: i put: string.
			i == 1 ifTrue: [firstArgLength := formatter firstLineLength].
			length := length + string size.
			multiLine := multiLine or: [formatter isMultiLine]].
	indent := indent - 1.
	multiLine := multiLine or: [length + 1 + self currentLineLength > MaxLineLength].
	cascadeBoolean
		ifFalse: 
			[(multiLine and: 
					[(self startMessageSendOnNewLine: aMessageNode)
						or: [self currentLineLength + selectorParts first length + 2 + firstArgLength > MaxLineLength]])
				ifTrue: [self newLine]
				ifFalse: [codeStream space]].
	self
		formatMessageSelector: selectorParts
		withArguments: formattedArgs
		multiline: multiLine!

formatMessageSelector: selectorParts withArguments: formattedArgs multiline: multiLine
	| count |
	count := formattedArgs size.
	count == 0
		ifTrue: [codeStream nextPutAll: selectorParts first value]
		ifFalse: 
			[| i |
			i := 1.
			
			[codeStream
				nextPutAll: (selectorParts at: i) value;
				space;
				nextPutAll: (formattedArgs at: i).
			i < count]
					whileTrue: 
						[i := i + 1.
						multiLine ifTrue: [self newLine] ifFalse: [self space]]]!

formatMethodBodyFor: aMethodNode
	self indentWhile: 
			[self formatMethodCommentFor: aMethodNode indentBefore: true.
			self newLine.
			self formatTagsFor: aMethodNode.
			self visitNode: aMethodNode body]!

formatMethodCommentFor: aNode indentBefore: aBoolean
	| source comments |
	source := aNode source.
	source isNil ifTrue: [^self].
	comments := aNode methodComments.
	comments isEmpty ifTrue: [^self].
	comments do: 
			[:each |
			aBoolean ifTrue: [self newLine].
			codeStream nextPutAll: (aNode source copyFrom: each first to: each last)]
		separatedBy: 
			[codeStream cr.
			aBoolean ifFalse: [self newLine]].
	aBoolean ifTrue: [codeStream cr] ifFalse: [self newLine]!

formatMethodPatternFor: aMethodNode
	| selectorParts arguments argumentCount |
	selectorParts := aMethodNode selectorParts.
	arguments := aMethodNode arguments.
	argumentCount := arguments size.
	argumentCount isZero
		ifTrue: [codeStream nextPutAll: selectorParts first value]
		ifFalse: 
			[1 to: argumentCount
				do: 
					[:i |
					i > 1 ifTrue: [codeStream space].
					codeStream
						nextPutAll: (selectorParts at: i) value;
						space.
					self visitArgumentNode: (arguments at: i)]]!

formatStatementCommentsFor: aNode
	| source |
	source := aNode source.
	source isNil ifTrue: [^self].
	aNode statementComments do: 
			[:each |
			| crs |
			crs := self newLinesFor: source startingAt: each first.
			(crs - 1 max: 0) timesRepeat: [codeStream cr].
			crs == 0 ifTrue: [codeStream tab] ifFalse: [self newLine].
			codeStream nextPutAll: (source copyFrom: each first to: each last)]!

formatStatementsFor: aSequenceNode
	| statements count statement |
	statements := aSequenceNode statements.
	count := statements size.
	count == 0 ifTrue: [^self].
	1 to: count - 1
		do: 
			[:i |
			self visitNode: (statement := statements at: i).
			codeStream nextPut: $..
			self
				formatStatementCommentsFor: statement;
				newLine].
	self visitNode: (statement := statements at: count).
	(PeriodsAtEndOfMethod and: 
			[| parent |
			(parent := aSequenceNode parent) notNil and: [parent isMethod]])
		ifTrue: [codeStream nextPut: $.].
	self formatStatementCommentsFor: statement!

formatTemporariesFor: aSequenceNode
	| temps |
	temps := aSequenceNode temporaries.
	temps isEmpty ifTrue: [^self].
	codeStream nextPut: $|.
	self space.
	temps do: 
			[:each |
			self visitArgumentNode: each.
			self space].
	codeStream nextPut: $|.
	self newLine!

indent: anInteger around: aBlock
	| answer |
	indent := indent + anInteger.
	answer := aBlock value.
	indent := indent - anInteger.
	^answer!

indentWhile: aBlock
	indent := indent + 1.
	aBlock value.
	indent := indent - 1!

isMultiLine
	^firstLineLength notNil!

lastLineLength
	^codeStream position - (lineStart max: 0)!

lineStart: aPosition
	lineStart := aPosition!

needsParenthesisFor: aNode
	| parent |
	aNode isValue ifFalse: [^false].
	parent := aNode parent ifNil: [^false].
	parent isDynamicArray ifTrue: [^false].
	(aNode isMessage and: [parent isMessage and: [parent receiver == aNode and: [aNode isUnary not]]])
		ifTrue: 
			[| grandparent |
			grandparent := parent parent.
			(grandparent notNil and: [grandparent isCascade]) ifTrue: [^true]].
	aNode precedence < parent precedence ifTrue: [^false].
	(aNode isAssignment and: [parent isAssignment]) ifTrue: [^false].
	(aNode isAssignment or: [aNode isCascade]) ifTrue: [^true].
	aNode precedence == 0 ifTrue: [^false].
	aNode isMessage ifFalse: [^true].
	aNode precedence = parent precedence ifFalse: [^true].
	aNode isUnary ifTrue: [^false].
	aNode isKeyword ifTrue: [^true].
	parent receiver == aNode ifFalse: [^true].
	^self precedenceOf: parent selector greaterThan: aNode selector

!

newLine
	firstLineLength isNil ifTrue: [firstLineLength := codeStream position].
	codeStream cr.
	indent timesRepeat: [codeStream tab].
	lineStart := codeStream position!

newLinesFor: aString startingAt: anIndex
	| count cr lf index char |
	cr := Character value: 13.
	lf := Character value: 10.
	count := 0.
	index := anIndex - 1.
	[index > 0 and: 
			[char := aString at: index.
			char isSeparator]] whileTrue: 
			[char == lf
				ifTrue: 
					[count := count + 1.
					(aString at: (index - 1 max: 1)) == cr ifTrue: [index := index - 1]].
			char == cr ifTrue: [count := count + 1].
			index := index - 1].
	^count!

postCopy
	super postCopy.
	lineStart := 0 - self currentLineLength.
	codeStream := WriteStream on: (Utf8String new: 60).
	firstLineLength := nil.
	^self!

precedenceOf: parentSelector greaterThan: childSelector
	"Put parenthesis around things that are perceived to have 'lower' precedence. For example, 'a + b * c' 
	-> '(a + b) * c' but 'a * b + c' -> 'a * b + c'"

	| childIndex parentIndex operators |
	operators := #(#($| $& $?) #($= $~ $< $>) #($- $+) #($* $/ $% $\) #($@)).
	childIndex := 0.
	parentIndex := 0.
	1 to: operators size
		do: 
			[:i |
			((operators at: i) includes: parentSelector first) ifTrue: [parentIndex := i].
			((operators at: i) includes: childSelector first) ifTrue: [childIndex := i]].
	^childIndex < parentIndex!

startMessageSendOnNewLine: aMessageNode
	(SelectorsToStartOnNewLine includes: aMessageNode selector) ifTrue: [^true].
	(SelectorsToLeaveOnLine includes: aMessageNode selector) ifTrue: [^false].
	^aMessageNode selector argumentCount > MaximumArgumentsPerLine!

visitAssignmentNode: anAssignmentNode
	indent := indent + 2.
	self visitNode: anAssignmentNode variable.
	codeStream nextPutAll: ' := '.
	self visitNode: anAssignmentNode value.
	indent := indent - 2!

visitBlockNode: aBlockNode
	self acceptBlockNode: aBlockNode startBlockString: '['.
	codeStream nextPut: $]!

visitCascadeNode: aCascadeNode
	| messages |
	messages := aCascadeNode messages.
	self visitNode: messages first receiver.
	self indentWhile: 
			[messages do: 
					[:each |
					self
						newLine;
						indentWhile: [self formatMessage: each cascade: true]]
				separatedBy: [codeStream nextPut: $;].
			self]!

visitLiteralNode: aLiteralNode
	aLiteralNode token formatOn: codeStream source: aLiteralNode source!

visitMessageNode: aMessageNode
	| newFormatter messageIndent |
	newFormatter := self copy.
	codeStream nextPutAll: (newFormatter format: aMessageNode receiver).
	messageIndent := newFormatter isMultiLine
				ifTrue: 
					[lineStart := codeStream position - newFormatter lastLineLength.
					2]
				ifFalse: [1].
	indent := indent + messageIndent.
	self formatMessage: aMessageNode cascade: false.
	indent := indent - messageIndent!

visitNode: aNode
	(self needsParenthesisFor: aNode)
		ifTrue: 
			[codeStream nextPut: $(.
			aNode acceptVisitor: self.
			codeStream nextPut: $)]
		ifFalse: [aNode acceptVisitor: self]!

visitOptimizedNode: anOptimizedNode
	codeStream nextPutAll: '##('.
	self visitNode: anOptimizedNode body.
	codeStream nextPut: $)!

visitPatternBlockNode: aRBPatternBlockNode
	self acceptBlockNode: aRBPatternBlockNode startBlockString: '`{'.
	codeStream nextPut: $}!

visitReturnNode: aReturnNode
	codeStream nextPut: $^.
	self visitNode: aReturnNode value!

visitSequenceNode: aSequenceNode
	self formatTemporariesFor: aSequenceNode.
	self formatMethodCommentFor: aSequenceNode indentBefore: false.
	self formatStatementsFor: aSequenceNode! !

!Refactory.Browser.RBFormatter categoriesForMethods!
acceptBlockNode:startBlockString:!private!visitor/double dispatching! !
firstLineLength!accessing!public! !
formatArray:!formatting!private! !
formatMessage:cascade:!formatting!private! !
formatMessageSelector:withArguments:multiline:!formatting!private! !
formatMethodBodyFor:!private!visitor/double dispatching! !
formatMethodCommentFor:indentBefore:!formatting!private! !
formatMethodPatternFor:!formatting!private! !
formatStatementCommentsFor:!formatting!private! !
formatStatementsFor:!formatting!private! !
formatTemporariesFor:!formatting!private! !
indent:around:!formatting!private! !
indentWhile:!helpers!private! !
isMultiLine!accessing!public! !
lastLineLength!accessing!public! !
lineStart:!accessing!private! !
needsParenthesisFor:!helpers!private! !
newLine!helpers!private! !
newLinesFor:startingAt:!formatting!private! !
postCopy!copying!public! !
precedenceOf:greaterThan:!helpers!private! !
startMessageSendOnNewLine:!private!testing! !
visitAssignmentNode:!public!visitor/double dispatching! !
visitBlockNode:!public!visitor/double dispatching! !
visitCascadeNode:!public!visitor/double dispatching! !
visitLiteralNode:!public!visitor/double dispatching! !
visitMessageNode:!public!visitor/double dispatching! !
visitNode:!public!visiting! !
visitOptimizedNode:!public!visitor/double dispatching! !
visitPatternBlockNode:!public!visitor/double dispatching! !
visitReturnNode:!public!visitor/double dispatching! !
visitSequenceNode:!public!visitor/double dispatching! !
!

!Refactory.Browser.RBFormatter class methodsFor!

initialize
	"
		self initialize
	"

	#rbFix.	"Added"
	self maxLineLength: 100.
	self maximumArgumentsPerLine: 2.
	self selectorsToLeaveOnLine: #(#to:do: #to:by: #to:by:do:).
	self
		selectorsToStartOnNewLine: #(#ifTrue:ifFalse: #ifFalse:ifTrue: #ifTrue: #ifFalse: #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:)!

maximumArgumentsPerLine
	#rbFix.	"Added"
	^MaximumArgumentsPerLine!

maximumArgumentsPerLine: anInteger
	MaximumArgumentsPerLine := anInteger!

selectorsToLeaveOnLine
	^SelectorsToLeaveOnLine!

selectorsToLeaveOnLine: anArrayOfSymbols
	SelectorsToLeaveOnLine := anArrayOfSymbols!

selectorsToStartOnNewLine
	^SelectorsToStartOnNewLine!

selectorsToStartOnNewLine: anArrayOfSymbols
	SelectorsToStartOnNewLine := anArrayOfSymbols! !

!Refactory.Browser.RBFormatter class categoriesForMethods!
initialize!initializing!public! !
maximumArgumentsPerLine!options!public! !
maximumArgumentsPerLine:!options!public! !
selectorsToLeaveOnLine!options!public! !
selectorsToLeaveOnLine:!options!public! !
selectorsToStartOnNewLine!options!public! !
selectorsToStartOnNewLine:!options!public! !
!

