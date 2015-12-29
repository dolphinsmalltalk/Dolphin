"Filed out from Dolphin Smalltalk XP"!

RBSourceFormatter subclass: #RBFormatter
	instanceVariableNames: 'firstLineLength'
	classVariableNames: 'MaximumArgumentsPerLine SelectorsToLeaveOnLine SelectorsToStartOnNewLine'
	poolDictionaries: 'ExtCallArgTypes'
	classInstanceVariableNames: ''!
RBFormatter guid: (GUID fromString: '{75E99F13-8BA7-47C0-87C4-8987B5A20900}')!
RBFormatter comment: 'RBFormatter is an <StParseNodeVisitor> for pretty printing Smalltalk methods.
'!
!RBFormatter categoriesForClass!System-Compiler-Formatters! !
!RBFormatter methodsFor!

acceptAssignmentNode: anAssignmentNode 
	self indent: 2
		around: 
			[self visitNode: anAssignmentNode variable.
			codeStream nextPutAll: ' := '.
			self visitNode: anAssignmentNode value]!

acceptBlockNode: aBlockNode 
	self 
		acceptBlockNode: aBlockNode
		startBlockString: '['
		endBlockString: ']'!

acceptBlockNode: aBlockNode startBlockString: startBlockString endBlockString: endBlockString 
	| seqNode multiline formattedBody formatter |
	seqNode := aBlockNode body.
	formatter := (self copy)
				lineStart: 0;
				yourself.
	formattedBody := formatter format: seqNode.
	multiline := self lineLength + formattedBody size > self maxLineSize 
				or: [formatter isMultiLine].
	multiline ifTrue: [self newLine].
	codeStream nextPutAll: startBlockString.
	aBlockNode arguments do: 
			[:each | 
			codeStream nextPut: $:.
			self visitNode: each.
			self space].
	aBlockNode arguments notEmpty 
		ifTrue: 
			[codeStream nextPutAll: '| '.
			multiline ifTrue: [self newLine]].
	codeStream
		nextPutAll: formattedBody;
		nextPutAll: endBlockString!

acceptCascadeNode: aCascadeNode 
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

acceptLiteralArrayNode: aRBArrayLiteralNode 
	codeStream 
		nextPutAll: (aRBArrayLiteralNode isForByteArray ifTrue: ['#['] ifFalse: ['#(']).
	self 
		for: aRBArrayLiteralNode contents
		do: [:each | self visitNode: each]
		separatedBy: [self space].
	codeStream nextPut: (aRBArrayLiteralNode isForByteArray ifTrue: [$]] ifFalse: [$)])!

acceptLiteralNode: aLiteralNode 
	aLiteralNode token storeOn: codeStream!

acceptMessageNode: aMessageNode 
	| newFormatter code |
	newFormatter := self copy.
	code := newFormatter format: aMessageNode receiver.
	codeStream nextPutAll: code.
	self space.
	newFormatter isMultiLine 
		ifTrue: [lineStart := codeStream position - newFormatter lastLineLength].
	self indent: (newFormatter isMultiLine ifTrue: [2] ifFalse: [1])
		around: [self formatMessage: aMessageNode cascade: false]!

acceptOptimizedNode: anOptimizedNode 
	codeStream nextPutAll: '##('.
	self visitNode: anOptimizedNode body.
	codeStream nextPut: $)!

acceptPatternBlockNode: aRBPatternBlockNode 
	self 
		acceptBlockNode: aRBPatternBlockNode
		startBlockString: '`{'
		endBlockString: '}'!

acceptReturnNode: aReturnNode 
	codeStream nextPut: $^.
	self visitNode: aReturnNode value!

acceptSequenceNode: aSequenceNode 
	self formatMethodCommentFor: aSequenceNode indentBefore: false.
	self formatTemporariesFor: aSequenceNode.
	self tagBeforeTemporaries 
		ifFalse: 
			[| parent |
			parent := aSequenceNode parent.
			(parent notNil and: [parent isMethod]) ifTrue: [self formatTagFor: parent]].
	self formatStatementsFor: aSequenceNode!

firstLineLength
	^firstLineLength isNil
		ifTrue: [codeStream position]
		ifFalse: [firstLineLength]!

for: aValue do: doBlock separatedBy: separatorBlock 
	"This is implemented here since IBM Smalltalk doesn't implement a do:separatedBy: method"

	aValue isEmpty ifTrue: [^self].
	1 to: aValue size - 1
		do: 
			[:i | 
			doBlock value: (aValue at: i).
			separatorBlock value].
	doBlock value: aValue last!

formatMessage: aMessageNode cascade: cascadeBoolean 
	| selectorParts arguments multiLine formattedArgs indentFirst firstArgLength length |
	selectorParts := aMessageNode selectorParts.
	arguments := aMessageNode arguments.
	formattedArgs := OrderedCollection new.
	#rbFix.	"Use #argumentCount"
	multiLine := aMessageNode selector argumentCount > self maximumArgumentsPerLine.
	length := aMessageNode selector size + arguments size + 1.
	firstArgLength := 0.
	self indentWhile: 
			[1 to: arguments size
				do: 
					[:i | 
					| formatter string |
					formatter := (self copy)
								lineStart: (selectorParts at: i) length negated;
								yourself.
					string := formatter format: (arguments at: i).
					formattedArgs add: string.
					i == 1 ifTrue: [firstArgLength := formatter firstLineLength].
					length := length + string size.
					multiLine := multiLine or: [formatter isMultiLine]]].
	multiLine := multiLine or: [length + self lineLength > self maxLineSize].
	indentFirst := cascadeBoolean not and: 
					[multiLine and: 
							[(self startMessageSendOnNewLine: aMessageNode) 
								or: [self lineLength + selectorParts first length + 2 + firstArgLength > self maxLineSize]]].
	indentFirst ifTrue: [self newLine].
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
						nextPut: $ ;
						nextPutAll: (formattedArgs at: i).
					(multiLine and: [i < formattedArgs size]) ifTrue: [self newLine]]]!

formatMethodBodyFor: aMethodNode 
	self indentWhile: 
			[self formatMethodCommentFor: aMethodNode indentBefore: true.
			self newLine.
			self tagBeforeTemporaries ifTrue: [self formatTagFor: aMethodNode].
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
	| selectorParts arguments |
	selectorParts := aMethodNode selectorParts.
	arguments := aMethodNode arguments.
	arguments isEmpty 
		ifTrue: [codeStream nextPutAll: selectorParts first value]
		ifFalse: 
			[selectorParts with: arguments
				do: 
					[:selector :arg | 
					codeStream
						nextPutAll: selector value;
						nextPut: $ .
					self visitArgument: arg.
					self space]]!

formatStatementCommentFor: aNode 
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
			self formatStatementCommentFor: (statements at: i).
			self newLine].
	self visitNode: statements last.
	aSequenceNode parent 
		ifNotNil: [:parent | (parent isMethod and: [self class periodsAtEndOfMethod]) ifTrue: [codeStream nextPut: $.]].
	self formatStatementCommentFor: statements last.!

formatTemporariesFor: aSequenceNode 
	| temps |
	temps := aSequenceNode temporaries.
	temps isEmpty ifTrue: [^self].
	codeStream nextPutAll: '| '.
	temps do: 
			[:each | 
			self visitArgument: each.
			self space].
	codeStream nextPut: $|.
	self newLine!

indentWhile: aBlock 
	self indent: 1 around: aBlock!

isMultiLine
	^firstLineLength notNil!

lastLineLength
	^codeStream position - (lineStart max: 0)!

lineLength
	^codeStream position - lineStart!

lineStart: aPosition 
	lineStart := aPosition!

maximumArgumentsPerLine
	^self class maximumArgumentsPerLine!

maxLineSize
	#rbFix.	"Refactor to class variable so configurable"
	^self class maxLineLength!

needsParenthesisFor: aNode 
	| parent |
	aNode isValue ifFalse: [^false].
	parent := aNode parent.
	parent isNil ifTrue: [^false].
	(aNode isMessage and: [parent isMessage and: [parent receiver == aNode]]) 
		ifTrue: 
			[| grandparent |
			grandparent := parent parent.
			(grandparent notNil and: [grandparent isCascade]) ifTrue: [^true]].
	aNode precedence < parent precedence ifTrue: [^false].
	aNode isAssignment & parent isAssignment ifTrue: [^false].
	aNode isAssignment | aNode isCascade ifTrue: [^true].
	aNode precedence == 0 ifTrue: [^false].
	aNode isMessage ifFalse: [^true].
	aNode precedence = parent precedence ifFalse: [^true].
	aNode isUnary ifTrue: [^false].
	aNode isKeyword ifTrue: [^true].
	parent receiver == aNode ifFalse: [^true].
	^self precedenceOf: parent selector greaterThan: aNode selector!

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
			char isSeparator]] 
		whileTrue: 
			[char == lf 
				ifTrue: 
					[count := count + 1.
					(aString at: (index - 1 max: 1)) == cr ifTrue: [index := index - 1]].
			char == cr ifTrue: [count := count + 1].
			index := index - 1].
	^count!

postCopy
	super postCopy.
	lineStart := self lineLength negated.
	codeStream := WriteStream on: (String new: 60).
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
			((operators at: i) includes: parentSelector first) 
				ifTrue: [parentIndex := i].
			((operators at: i) includes: childSelector first) 
				ifTrue: [childIndex := i]].
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

visitNode: aNode 
	| parenthesis |
	parenthesis := self needsParenthesisFor: aNode.
	parenthesis ifTrue: [codeStream nextPut: $(].
	aNode acceptVisitor: self.
	parenthesis ifTrue: [codeStream nextPut: $)]! !
!RBFormatter categoriesFor: #acceptAssignmentNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptBlockNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptBlockNode:startBlockString:endBlockString:!private!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptCascadeNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptLiteralArrayNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptLiteralNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptMessageNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptOptimizedNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptPatternBlockNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptReturnNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #acceptSequenceNode:!public!visitor/double dispatching! !
!RBFormatter categoriesFor: #firstLineLength!accessing!public! !
!RBFormatter categoriesFor: #for:do:separatedBy:!enumerating!private! !
!RBFormatter categoriesFor: #formatMessage:cascade:!formatting!private! !
!RBFormatter categoriesFor: #formatMessageSelector:withArguments:multiline:!formatting!private! !
!RBFormatter categoriesFor: #formatMethodBodyFor:!private!visitor/double dispatching! !
!RBFormatter categoriesFor: #formatMethodCommentFor:indentBefore:!formatting!private! !
!RBFormatter categoriesFor: #formatMethodPatternFor:!formatting!private! !
!RBFormatter categoriesFor: #formatStatementCommentFor:!formatting!private! !
!RBFormatter categoriesFor: #formatStatementsFor:!formatting!private! !
!RBFormatter categoriesFor: #formatTemporariesFor:!formatting!private! !
!RBFormatter categoriesFor: #indentWhile:!helpers!private! !
!RBFormatter categoriesFor: #isMultiLine!accessing!public! !
!RBFormatter categoriesFor: #lastLineLength!accessing!public! !
!RBFormatter categoriesFor: #lineLength!accessing!private! !
!RBFormatter categoriesFor: #lineStart:!accessing!private! !
!RBFormatter categoriesFor: #maximumArgumentsPerLine!constants!public! !
!RBFormatter categoriesFor: #maxLineSize!constants!private! !
!RBFormatter categoriesFor: #needsParenthesisFor:!helpers!private! !
!RBFormatter categoriesFor: #newLine!helpers!private! !
!RBFormatter categoriesFor: #newLinesFor:startingAt:!formatting!private! !
!RBFormatter categoriesFor: #postCopy!copying!public! !
!RBFormatter categoriesFor: #precedenceOf:greaterThan:!helpers!private! !
!RBFormatter categoriesFor: #selectorsToLeaveOnLine!constants!public! !
!RBFormatter categoriesFor: #selectorsToStartOnNewLine!constants!public! !
!RBFormatter categoriesFor: #startMessageSendOnNewLine:!private!testing! !
!RBFormatter categoriesFor: #visitNode:!public!visiting! !

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

