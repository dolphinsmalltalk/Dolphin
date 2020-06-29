"Filed out from Dolphin Smalltalk 7"!

RBSourceFormatter subclass: #RBFormatter
	instanceVariableNames: 'firstLineLength'
	classVariableNames: 'MaximumArgumentsPerLine SelectorsToLeaveOnLine SelectorsToStartOnNewLine'
	poolDictionaries: 'ExtCallArgTypes'
	classInstanceVariableNames: ''
	classConstants: {}!
RBFormatter guid: (GUID fromString: '{75e99f13-8ba7-47c0-87c4-8987b5a20900}')!
RBFormatter comment: 'RBFormatter is an <StParseNodeVisitor> for pretty printing Smalltalk methods.
'!
!RBFormatter categoriesForClass!System-Compiler-Formatters! !
!RBFormatter methodsFor!

acceptBlockNode: aBlockNode startBlockString: startBlockString endBlockString: endBlockString
	| seqNode multiline formattedBody formatter |
	seqNode := aBlockNode body.
	formatter := self copy
				lineStart: 0;
				yourself.
	formattedBody := formatter format: seqNode.
	multiline := self currentLineLength + formattedBody size > self maxLineLength or: [formatter isMultiLine].
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
	codeStream
		nextPutAll: formattedBody;
		nextPutAll: endBlockString!

firstLineLength
	^firstLineLength isNil ifTrue: [codeStream position] ifFalse: [firstLineLength]!

for: aValue do: doBlock separatedBy: separatorBlock
	"This is implemented here since IBM Smalltalk doesn't implement a do:separatedBy: method"

	aValue isEmpty ifTrue: [^self].
	1 to: aValue size - 1
		do: 
			[:i |
			doBlock value: (aValue at: i).
			separatorBlock value].
	doBlock value: aValue last!

formatArray: anArrayNode
	| formattedArgs multiline length |
	formattedArgs := Array writeStream: anArrayNode statements size.
	multiline := false.
	length := 0.
	self indent: 1
		around: 
			[anArrayNode statements do: 
					[:each |
					| formatter string |
					formatter := self copy.
					string := formatter format: each.
					formattedArgs nextPut: string.
					length := length + string size + 2.
					multiline := multiline or: [formatter isMultiLine]].
			formattedArgs := formattedArgs collection.
			multiline := multiline or: [length + 1 + self currentLineLength > self maxLineLength].
			formattedArgs do: [:each | codeStream nextPutAll: each]
				separatedBy: 
					[codeStream nextPut: $..
					multiline ifTrue: [self newLine] ifFalse: [self space]]]!

formatMessage: aMessageNode cascade: cascadeBoolean
	| selectorParts arguments multiLine formattedArgs indentFirst firstArgLength length argumentCount |
	selectorParts := aMessageNode selectorParts.
	arguments := aMessageNode arguments.
	argumentCount := arguments size.
	formattedArgs := OrderedCollection new: argumentCount.
	multiLine := argumentCount > self maximumArgumentsPerLine.
	length := aMessageNode selector size + argumentCount + 1.
	firstArgLength := 0.
	self indentWhile: 
			[1 to: argumentCount
				do: 
					[:i |
					| formatter string |
					formatter := self copy
								lineStart: (selectorParts at: i) length negated;
								yourself.
					string := formatter format: (arguments at: i).
					formattedArgs addLast: string.
					i == 1 ifTrue: [firstArgLength := formatter firstLineLength].
					length := length + string size.
					multiLine := multiLine or: [formatter isMultiLine]]].
	multiLine := multiLine or: [length + 1 + self currentLineLength > self maxLineLength].
	indentFirst := cascadeBoolean not and: [multiLine and: [(self startMessageSendOnNewLine: aMessageNode) or: [self currentLineLength + selectorParts first length + 2 + firstArgLength > self maxLineLength]]].
	indentFirst ifTrue: [self newLine] ifFalse: [cascadeBoolean ifFalse: [codeStream space]].
	self
		formatMessageSelector: selectorParts
		withArguments: formattedArgs
		multiline: multiLine!

formatMessageSelector: selectorParts withArguments: formattedArgs multiline: multiLine
	formattedArgs isEmpty
		ifTrue: [codeStream nextPutAll: selectorParts first value]
		ifFalse: 
			[1 to: formattedArgs size
				do: 
					[:i |
					i ~~ 1 & multiLine not ifTrue: [self space].
					codeStream
						nextPutAll: (selectorParts at: i) value;
						space;
						nextPutAll: (formattedArgs at: i).
					(multiLine and: [i < formattedArgs size]) ifTrue: [self newLine]]]!

formatMethodBodyFor: aMethodNode
	self indentWhile: 
			[self formatMethodCommentFor: aMethodNode indentBefore: true.
			self newLine.
			self formatTagFor: aMethodNode.
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
	| statements |
	statements := aSequenceNode statements.
	statements isEmpty ifTrue: [^self].
	1 to: statements size - 1
		do: 
			[:i |
			self visitNode: (statements at: i).
			codeStream nextPut: $..
			self formatStatementCommentsFor: (statements at: i).
			self newLine].
	self visitNode: statements last.
	aSequenceNode parent
		ifNotNil: [:parent | (parent isMethod and: [self class periodsAtEndOfMethod]) ifTrue: [codeStream nextPut: $.]].
	self formatStatementCommentsFor: statements last!

formatTemporariesFor: aSequenceNode
	| temps |
	temps := aSequenceNode temporaries.
	temps isEmpty ifTrue: [^self].
	self bracketWith: '|'
		around: 
			[self space.
			temps do: 
					[:each |
					self visitArgumentNode: each.
					self space]].
	self newLine!

indentWhile: aBlock
	self indent: 1 around: aBlock!

isMultiLine
	^firstLineLength notNil!

lastLineLength
	^codeStream position - (lineStart max: 0)!

lineStart: aPosition
	lineStart := aPosition!

maximumArgumentsPerLine
	^self class maximumArgumentsPerLine!

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
	lineStart := self currentLineLength negated.
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

selectorsToLeaveOnLine
	^self class selectorsToLeaveOnLine!

selectorsToStartOnNewLine
	^self class selectorsToStartOnNewLine!

startMessageSendOnNewLine: aMessageNode
	(self selectorsToStartOnNewLine includes: aMessageNode selector) ifTrue: [^true].
	(self selectorsToLeaveOnLine includes: aMessageNode selector) ifTrue: [^false].
	#rbFix.	"Use ANSI standard #argumentCount message instead of #numArgs"
	^aMessageNode selector argumentCount > self maximumArgumentsPerLine!

visitAssignmentNode: anAssignmentNode
	self indent: 2
		around: 
			[self visitNode: anAssignmentNode variable.
			codeStream nextPutAll: ' := '.
			self visitNode: anAssignmentNode value]!

visitBlockNode: aBlockNode
	self
		acceptBlockNode: aBlockNode
		startBlockString: '['
		endBlockString: ']'!

visitCascadeNode: aCascadeNode
	| messages |
	messages := aCascadeNode messages.
	self visitNode: messages first receiver.
	self indentWhile: 
			[self
				for: messages
				do: 
					[:each |
					self
						newLine;
						indentWhile: [self formatMessage: each cascade: true]]
				separatedBy: [codeStream nextPut: $;]]!

visitLiteralArrayNode: aRBArrayLiteralNode
	| brackets |
	codeStream nextPut: $#.
	brackets := aRBArrayLiteralNode isForByteArray ifTrue: ['[]'] ifFalse: ['()'].
	self bracketWith: brackets
		around: 
			[self
				for: aRBArrayLiteralNode contents
				do: [:each | self visitNode: each]
				separatedBy: [self space]]!

visitLiteralNode: aLiteralNode
	aLiteralNode token formatOn: codeStream source: aLiteralNode source!

visitMessageNode: aMessageNode
	| newFormatter code |
	newFormatter := self copy.
	code := newFormatter format: aMessageNode receiver.
	codeStream nextPutAll: code.
	newFormatter isMultiLine ifTrue: [lineStart := codeStream position - newFormatter lastLineLength].
	self indent: (newFormatter isMultiLine ifTrue: [2] ifFalse: [1])
		around: [self formatMessage: aMessageNode cascade: false]!

visitNode: aNode
	(self needsParenthesisFor: aNode)
		ifTrue: [self bracketWith: '()' around: [aNode acceptVisitor: self]]
		ifFalse: [aNode acceptVisitor: self]!

visitOptimizedNode: anOptimizedNode
	codeStream nextPutAll: '##('.
	self visitNode: anOptimizedNode body.
	codeStream nextPut: $)!

visitPatternBlockNode: aRBPatternBlockNode
	self
		acceptBlockNode: aRBPatternBlockNode
		startBlockString: '`{'
		endBlockString: '}'!

visitReturnNode: aReturnNode
	codeStream nextPut: $^.
	self visitNode: aReturnNode value!

visitSequenceNode: aSequenceNode
	self formatTemporariesFor: aSequenceNode.
	self formatMethodCommentFor: aSequenceNode indentBefore: false.
	self formatStatementsFor: aSequenceNode! !
!RBFormatter categoriesFor: #acceptBlockNode:startBlockString:endBlockString:!private!visitor/double dispatching! !
!RBFormatter categoriesFor: #firstLineLength!accessing!public! !
!RBFormatter categoriesFor: #for:do:separatedBy:!enumerating!private! !
!RBFormatter categoriesFor: #formatArray:!formatting!private! !
!RBFormatter categoriesFor: #formatMessage:cascade:!formatting!private! !
!RBFormatter categoriesFor: #formatMessageSelector:withArguments:multiline:!formatting!private! !
!RBFormatter categoriesFor: #formatMethodBodyFor:!private!visitor/double dispatching! !
!RBFormatter categoriesFor: #formatMethodCommentFor:indentBefore:!formatting!private! !
!RBFormatter categoriesFor: #formatMethodPatternFor:!formatting!private! !
!RBFormatter categoriesFor: #formatStatementCommentsFor:!formatting!private! !
!RBFormatter categoriesFor: #formatStatementsFor:!formatting!private! !
!RBFormatter categoriesFor: #formatTemporariesFor:!formatting!private! !
!RBFormatter categoriesFor: #indentWhile:!helpers!private! !
!RBFormatter categoriesFor: #isMultiLine!accessing!public! !
!RBFormatter categoriesFor: #lastLineLength!accessing!public! !
!RBFormatter categoriesFor: #lineStart:!accessing!private! !
!RBFormatter categoriesFor: #maximumArgumentsPerLine!constants!public! !
!RBFormatter categoriesFor: #needsParenthesisFor:!helpers!private! !
!RBFormatter categoriesFor: #newLine!helpers!private! !
!RBFormatter categoriesFor: #newLinesFor:startingAt:!formatting!private! !
!RBFormatter categoriesFor: #postCopy!copying!public! !
!RBFormatter categoriesFor: #precedenceOf:greaterThan:!helpers!private! !
!RBFormatter categoriesFor: #selectorsToLeaveOnLine!constants!public! !
!RBFormatter categoriesFor: #selectorsToStartOnNewLine!constants!public! !
!RBFormatter categoriesFor: #startMessageSendOnNewLine:!private!testing! !
!RBFormatter categoriesFor: #visitAssignmentNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitBlockNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitCascadeNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitLiteralArrayNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitNode:!public!visiting! !
!RBFormatter categoriesFor: #visitOptimizedNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitPatternBlockNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitReturnNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #visitSequenceNode:!public!visitor/double dispatching! !

!RBFormatter class methodsFor!

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

maximumArgumentsPerLine: anObject
	MaximumArgumentsPerLine := anObject!

selectorsToLeaveOnLine
	^SelectorsToLeaveOnLine!

selectorsToLeaveOnLine: anArrayOfSymbols
	SelectorsToLeaveOnLine := anArrayOfSymbols!

selectorsToStartOnNewLine
	^SelectorsToStartOnNewLine!

selectorsToStartOnNewLine: anArrayOfSymbols
	SelectorsToStartOnNewLine := anArrayOfSymbols! !
!RBFormatter class categoriesFor: #initialize!initializing!public! !
!RBFormatter class categoriesFor: #maximumArgumentsPerLine!options!public! !
!RBFormatter class categoriesFor: #maximumArgumentsPerLine:!options!public! !
!RBFormatter class categoriesFor: #selectorsToLeaveOnLine!options!public! !
!RBFormatter class categoriesFor: #selectorsToLeaveOnLine:!options!public! !
!RBFormatter class categoriesFor: #selectorsToStartOnNewLine!options!public! !
!RBFormatter class categoriesFor: #selectorsToStartOnNewLine:!options!public! !

