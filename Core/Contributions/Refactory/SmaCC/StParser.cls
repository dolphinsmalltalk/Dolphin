"Filed out from Dolphin Smalltalk XP"!

SmaCCParser subclass: #StParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StParser guid: (GUID fromString: '{4C58E141-E776-4CEF-91E2-A4D7E1883AD1}')!
StParser comment: ''!
!StParser categoriesForClass!SmaCC Runtime! !
!StParser methodsFor!

actionForCurrentToken
	| ids action |
	ids := currentToken id.
	1 to: ids size
		do: 
			[:i | 
			action := self actionFor: (ids at: i).
			(action bitAnd: self actionMask) = self errorAction ifFalse: [^action].
			(ids at: i) = scanner negative_numberId 
				ifTrue: 
					[currentToken := SmaCCToken 
								value: '-'
								start: currentToken startPosition
								id: (Array with: scanner binary_symbolId).
					scanner position: currentToken stopPosition - 1.
					^self actionForCurrentToken]].
	^self errorAction!

createMessageNodeFrom: aCollection 
	^RBMessageNode 
		receiver: aCollection first
		selector: (aCollection at: 2) first contents asSymbol
		arguments: (aCollection at: 2) last!

reduceActionForArray1: nodes
	^WriteStream on: Array new!

reduceActionForArray2: nodes
	^(nodes at: 1)
		nextPut: (nodes at: 2);
		yourself!

reduceActionForArray3: nodes
	(nodes at: 2) stopPosition + 1 = (nodes at: 3) startPosition 
		ifTrue: [(nodes at: 1) nextPut: ((nodes at: 2) value , ':') asSymbol]
		ifFalse: 
			[(nodes at: 1)
				nextPut: (nodes at: 2) value asSymbol;
				nextPut: #':'].
	scanner position: (nodes at: 3) startPosition.
	currentToken := nil.
	^nodes at: 1!

reduceActionForArrayLiteral10: nodes
	^(nodes at: 1) value asSymbol!

reduceActionForArrayLiteral11: nodes
	^(nodes at: 1) value!

reduceActionForArrayLiteral2: nodes
	^(nodes at: 1) value asSymbol!

reduceActionForArrayLiteral3: nodes
	^(nodes at: 1) value asSymbol!

reduceActionForArrayLiteral4: nodes
	^(nodes at: 1) value asSymbol!

reduceActionForArrayLiteral5: nodes
	^(nodes at: 1) value asSymbol!

reduceActionForArrayLiteral6: nodes
	^(nodes at: 2) value asQualifiedReference!

reduceActionForArrayLiteral7: nodes
	^(nodes at: 2) value asQualifiedReference!

reduceActionForArrayLiteral8: nodes
	^(nodes at: 2) contents!

reduceActionForArrayLiteral9: nodes
	^(nodes at: 2) contents!

reduceActionForBinaryMessage1: nodes
	^Array with: (ReadStream on: (nodes at: 1) value) with: (Array with: (nodes at: 2))!

reduceActionForBinaryMethodName1: nodes
	^Array with: (nodes at: 1) value asSymbol with: (Array with: (nodes at: 2))!

reduceActionForBlock1: nodes
	^RBBlockNode arguments: (nodes at: 2) body: (nodes at: 4)!

reduceActionForBlock2: nodes
	^RBBlockNode body: (nodes at: 2)!

reduceActionForBlock3: nodes
	^RBBlockNode arguments: (nodes at: 2) body: (RBSequenceNode statements: #())!

reduceActionForBlock4: nodes
	^RBBlockNode arguments: (nodes at: 2)
		body: (RBSequenceNode temporaries: (nodes at: 4) statements: (nodes at: 6))!

reduceActionForBlockArgs1: nodes
	^OrderedCollection with: (nodes at: 2)!

reduceActionForBlockArgs2: nodes
	^(nodes at: 1)
		add: (nodes at: 3);
		yourself!

reduceActionForByteArray1: nodes
	^WriteStream on: ByteArray new!

reduceActionForByteArray2: nodes
	^(nodes at: 1)
		nextPut: (nodes at: 2) value;
		yourself!

reduceActionForCascade1: nodes
	| messages |
	(nodes at: 2) isEmpty ifTrue: [^nodes at: 1].
	messages := OrderedCollection new: (nodes at: 2) size + 1.
	messages add: (nodes at: 1).
	(nodes at: 2) do: 
			[:each | 
			messages add: (RBMessageNode 
						receiver: (nodes at: 1) receiver
						selector: each first contents asSymbol
						arguments: each last)].
	^RBCascadeNode messages: messages!

reduceActionForCascadeList1: nodes
	^OrderedCollection new!

reduceActionForCascadeList2: nodes
	^(nodes at: 1)
		add: (nodes at: 3);
		yourself!

reduceActionForExpression1: nodes
	^RBAssignmentNode variable: (nodes at: 1) value: (nodes at: 3)!

reduceActionForKeywordMessage1: nodes
	| stream |
	stream := WriteStream on: (String new: 30).
	stream nextPutAll: (nodes at: 1) value.
	^Array with: stream with: (OrderedCollection with: (nodes at: 2))!

reduceActionForKeywordMessage2: nodes
	(nodes at: 1) first nextPutAll: (nodes at: 2) value.
	(nodes at: 1) last add: (nodes at: 3).
	^nodes at: 1!

reduceActionForKeywordMethodName1: nodes
	| stream |
	stream := WriteStream on: (String new: 30).
	stream nextPutAll: (nodes at: 1) value.
	^Array with: stream with: (OrderedCollection with: (nodes at: 2))!

reduceActionForKeywordMethodName2: nodes
	(nodes at: 1) first nextPutAll: (nodes at: 2) value.
	(nodes at: 1) last add: (nodes at: 3).
	^nodes at: 1!

reduceActionForLiteral1: nodes
	^true!

reduceActionForLiteral10: nodes
	^(nodes at: 2) value asSymbol!

reduceActionForLiteral11: nodes
	^(nodes at: 2) value asSymbol!

reduceActionForLiteral12: nodes
	^(nodes at: 2) value asSymbol!

reduceActionForLiteral13: nodes
	^(nodes at: 3) contents!

reduceActionForLiteral14: nodes
	^(nodes at: 3) contents!

reduceActionForLiteral15: nodes
	^(nodes at: 3) value asQualifiedReference!

reduceActionForLiteral16: nodes
	^(nodes at: 3) value asQualifiedReference!

reduceActionForLiteral2: nodes
	^false!

reduceActionForLiteral3: nodes
	^nil!

reduceActionForLiteral4: nodes
	^(nodes at: 1) value!

reduceActionForLiteral5: nodes
	^(nodes at: 1) value!

reduceActionForLiteral6: nodes
	^(nodes at: 1) value at: 2!

reduceActionForLiteral7: nodes
	^((nodes at: 1) value copyFrom: 2 to: (nodes at: 1) value size - 1) 
		copyReplaceAll: ''''''
		with: ''''!

reduceActionForLiteral8: nodes
	^(((nodes at: 2) value copyFrom: 2 to: (nodes at: 2) value size - 1) 
		copyReplaceAll: ''''''
		with: '''') asSymbol!

reduceActionForLiteral9: nodes
	^(nodes at: 2) value asSymbol!

reduceActionForMethod1: nodes
	^RBMethodNode 
		selector: (nodes at: 1) value asSymbol
		arguments: #()
		body: (nodes at: 2) last!

reduceActionForMethod2: nodes
	^RBMethodNode 
		selector: (nodes at: 1) first
		arguments: (nodes at: 1) last
		body: (nodes at: 2) last!

reduceActionForMethod3: nodes
	^RBMethodNode 
		selector: (nodes at: 1) first contents asSymbol
		arguments: (nodes at: 1) last
		body: (nodes at: 2) last!

reduceActionForMethodSequenceNode1: nodes
	^Array with: ((nodes at: 1)
				addAll: (nodes at: 5);
				yourself)
		with: (RBSequenceNode temporaries: (nodes at: 3) statements: (nodes at: 6))!

reduceActionForMethodSequenceNode2: nodes
	^Array with: ((nodes at: 1)
				addAll: (nodes at: 3);
				yourself)
		with: (RBSequenceNode temporaries: #() statements: (nodes at: 4))!

reduceActionForMethodSequenceNode3: nodes
	^Array with: (nodes at: 1)
		with: (RBSequenceNode temporaries: #() statements: (nodes at: 2))!

reduceActionForOptional_____1: nodes
	^nil!

reduceActionForOptional_____2: nodes
	^nodes at: 1!

reduceActionForPrimary2: nodes
	^RBLiteralNode value: (nodes at: 1)!

reduceActionForPrimitiveMessageSend10: nodes
	^nil!

reduceActionForPrimitiveMessageSend11: nodes
	^nil!

reduceActionForPrimitiveMessageSend2: nodes
	^nil!

reduceActionForPrimitiveMessageSend3: nodes
	^nil!

reduceActionForPrimitiveMessageSend4: nodes
	^nil!

reduceActionForPrimitiveMessageSend5: nodes
	^nil!

reduceActionForPrimitiveMessageSend6: nodes
	^nil!

reduceActionForPrimitiveMessageSend7: nodes
	^nil!

reduceActionForPrimitiveMessageSend8: nodes
	^nil!

reduceActionForPrimitiveMessageSend9: nodes
	^nil!

reduceActionForPrimitives1: nodes
	^OrderedCollection new!

reduceActionForPrimitives2: nodes
	^(nodes at: 1)
		add: ((nodes at: 2) startPosition to: (nodes at: 4) startPosition);
		yourself!

reduceActionForSequenceNode1: nodes
	^RBSequenceNode temporaries: (nodes at: 1) statements: (nodes at: 2)!

reduceActionForStatementList2: nodes
	^(nodes at: 1)
		add: (nodes at: 3);
		yourself!

reduceActionForStatements1: nodes
	^OrderedCollection new!

reduceActionForStatements3: nodes
	^(nodes at: 1)
		add: (RBReturnNode value: (nodes at: 4));
		yourself!

reduceActionForStatements4: nodes
	^OrderedCollection with: (RBReturnNode value: (nodes at: 2))!

reduceActionForTemporaries1: nodes
	^#()!

reduceActionForTemporaries2: nodes
	^#()!

reduceActionForTemporaries3: nodes
	^nodes at: 2!

reduceActionForTemporaryVariables1: nodes
	^OrderedCollection new!

reduceActionForTemporaryVariables2: nodes
	^(nodes at: 1)
		add: (nodes at: 2);
		yourself!

reduceActionForUnaryMessage1: nodes
	^Array with: (ReadStream on: (nodes at: 1) value) with: #()!

reduceActionForVariable1: nodes
	^RBVariableNode named: (nodes at: 1) value!

reduceActionForVariable2: nodes
	^RBVariableNode named: (nodes at: 1) value!

reduceTable
	^#(
#(33 0 #reduceActionForTemporaries1:)
#(33 1 #reduceActionForTemporaries2:)
#(33 3 #reduceActionForTemporaries3:)
#(34 0 #reduceActionForStatements1:)
#(34 2 #liftFirstValue:)
#(34 5 #reduceActionForStatements3:)
#(34 3 #reduceActionForStatements4:)
#(35 1 #reduceActionForVariable1:)
#(35 1 #reduceActionForVariable2:)
#(36 1 #reduceFor:)
#(36 3 #reduceActionForStatementList2:)
#(37 0 #reduceActionForTemporaryVariables1:)
#(37 2 #reduceActionForTemporaryVariables2:)
#(38 3 #reduceActionForExpression1:)
#(38 1 #liftFirstValue:)
#(39 2 #reduceActionForBlockArgs1:)
#(39 3 #reduceActionForBlockArgs2:)
#(40 5 #reduceActionForBlock1:)
#(40 3 #reduceActionForBlock2:)
#(40 3 #reduceActionForBlock3:)
#(40 7 #reduceActionForBlock4:)
#(41 2 #reduceActionForCascade1:)
#(41 1 #liftFirstValue:)
#(42 1 #liftFirstValue:)
#(42 1 #liftFirstValue:)
#(42 1 #liftFirstValue:)
#(43 0 #reduceActionForCascadeList1:)
#(43 3 #reduceActionForCascadeList2:)
#(44 3 #liftSecondValue:)
#(44 1 #reduceActionForPrimary2:)
#(44 1 #liftFirstValue:)
#(44 1 #liftFirstValue:)
#(45 0 #reduceActionForOptional_____1:)
#(45 1 #reduceActionForOptional_____2:)
#(46 2 #createMessageNodeFrom:)
#(46 2 #createMessageNodeFrom:)
#(46 2 #createMessageNodeFrom:)
#(47 2 #createMessageNodeFrom:)
#(47 2 #createMessageNodeFrom:)
#(48 1 #liftFirstValue:)
#(48 1 #liftFirstValue:)
#(48 1 #liftFirstValue:)
#(49 0 #reduceFor:)
#(49 2 #reduceActionForPrimitiveMessageSend2:)
#(49 2 #reduceActionForPrimitiveMessageSend3:)
#(49 2 #reduceActionForPrimitiveMessageSend4:)
#(49 2 #reduceActionForPrimitiveMessageSend5:)
#(49 2 #reduceActionForPrimitiveMessageSend6:)
#(49 2 #reduceActionForPrimitiveMessageSend7:)
#(49 2 #reduceActionForPrimitiveMessageSend8:)
#(49 2 #reduceActionForPrimitiveMessageSend9:)
#(49 2 #reduceActionForPrimitiveMessageSend10:)
#(49 2 #reduceActionForPrimitiveMessageSend11:)
#(50 1 #reduceActionForUnaryMessage1:)
#(51 2 #reduceActionForBinaryMessage1:)
#(52 2 #reduceActionForKeywordMessage1:)
#(52 3 #reduceActionForKeywordMessage2:)
#(53 1 #liftFirstValue:)
#(53 1 #liftFirstValue:)
#(53 1 #liftFirstValue:)
#(54 1 #liftFirstValue:)
#(54 1 #liftFirstValue:)
#(55 1 #reduceFor:)
#(56 2 #reduceActionForMethod1:)
#(56 2 #reduceActionForMethod2:)
#(56 2 #reduceActionForMethod3:)
#(57 2 #reduceActionForKeywordMethodName1:)
#(57 3 #reduceActionForKeywordMethodName2:)
#(58 2 #reduceActionForBinaryMethodName1:)
#(59 0 #reduceActionForByteArray1:)
#(59 2 #reduceActionForByteArray2:)
#(60 0 #reduceActionForArray1:)
#(60 2 #reduceActionForArray2:)
#(60 3 #reduceActionForArray3:)
#(61 1 #liftFirstValue:)
#(61 1 #reduceActionForArrayLiteral2:)
#(61 1 #reduceActionForArrayLiteral3:)
#(61 1 #reduceActionForArrayLiteral4:)
#(61 1 #reduceActionForArrayLiteral5:)
#(61 3 #reduceActionForArrayLiteral6:)
#(61 3 #reduceActionForArrayLiteral7:)
#(61 3 #reduceActionForArrayLiteral8:)
#(61 3 #reduceActionForArrayLiteral9:)
#(61 1 #reduceActionForArrayLiteral10:)
#(61 1 #reduceActionForArrayLiteral11:)
#(62 2 #createMessageNodeFrom:)
#(62 2 #createMessageNodeFrom:)
#(62 2 #createMessageNodeFrom:)
#(65 6 #reduceActionForMethodSequenceNode1:)
#(65 4 #reduceActionForMethodSequenceNode2:)
#(65 2 #reduceActionForMethodSequenceNode3:)
#(66 2 #reduceActionForSequenceNode1:)
#(67 1 #reduceActionForLiteral1:)
#(67 1 #reduceActionForLiteral2:)
#(67 1 #reduceActionForLiteral3:)
#(67 1 #reduceActionForLiteral4:)
#(67 1 #reduceActionForLiteral5:)
#(67 1 #reduceActionForLiteral6:)
#(67 1 #reduceActionForLiteral7:)
#(67 2 #reduceActionForLiteral8:)
#(67 2 #reduceActionForLiteral9:)
#(67 2 #reduceActionForLiteral10:)
#(67 2 #reduceActionForLiteral11:)
#(67 2 #reduceActionForLiteral12:)
#(67 4 #reduceActionForLiteral13:)
#(67 4 #reduceActionForLiteral14:)
#(67 4 #reduceActionForLiteral15:)
#(67 4 #reduceActionForLiteral16:)
#(68 0 #reduceActionForPrimitives1:)
#(68 4 #reduceActionForPrimitives2:)
)!

transitionTable
	^#(
#[1 0 13 0 20 0 17 0 24 0 21 0 26 0 25 0 56 0 29 0 57 0 33 0 58]
#[1 0 6 0 2 0 6 0 4 0 6 0 10 0 6 0 13 0 6 0 14 0 37 0 15 0 41 0 17 0 6 0 18 0 6 0 19 0 6 0 20 0 6 0 21 0 6 0 22 0 6 0 23 0 6 0 29 0 6 0 30 0 45 0 33 0 6 0 63 0 49 0 66]
#[1 1 182 0 2 1 182 0 4 1 182 0 8 1 182 0 10 1 182 0 13 1 182 0 14 1 182 0 15 1 182 0 17 1 182 0 18 1 182 0 19 1 182 0 20 1 182 0 21 1 182 0 22 1 182 0 23 1 182 0 29 1 182 0 30 1 182 0 63 0 53 0 65 0 57 0 68]
#[1 0 61 0 20 0 65 0 29 0 69 0 35]
#[1 0 61 0 20 0 65 0 29 0 73 0 35]
#[0 0 0 0 63]
#[1 1 182 0 2 1 182 0 4 1 182 0 8 1 182 0 10 1 182 0 13 1 182 0 14 1 182 0 15 1 182 0 17 1 182 0 18 1 182 0 19 1 182 0 20 1 182 0 21 1 182 0 22 1 182 0 23 0 77 0 24 1 182 0 29 1 182 0 30 1 182 0 63 0 81 0 65 0 57 0 68]
#[1 1 182 0 2 1 182 0 4 1 182 0 8 1 182 0 10 1 182 0 13 1 182 0 14 1 182 0 15 1 182 0 17 1 182 0 18 1 182 0 19 1 182 0 20 1 182 0 21 1 182 0 22 1 182 0 23 1 182 0 29 1 182 0 30 1 182 0 63 0 85 0 65 0 57 0 68]
#[0 0 10 0 2 0 4 0 10 0 12 0 13 0 14 0 18 0 19 0 20 0 21 0 22 0 23 0 29 0 30 0 63]
#[1 0 50 0 17 0 50 0 20 0 50 0 29 0 89 0 37]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 18 0 12 0 105 0 13 0 109 0 14 0 113 0 18 0 117 0 19 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 0 137 0 34 0 141 0 35 0 145 0 36 0 149 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 18 0 63 0 181 0 67]
#[0 0 0 0 63]
#[0 1 2 0 63]
#[1 0 93 0 2 0 97 0 4 0 185 0 8 0 101 0 10 0 105 0 13 0 109 0 14 0 189 0 15 0 193 0 17 0 113 0 18 0 117 0 19 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 0 197 0 34 0 141 0 35 0 145 0 36 0 149 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 18 0 63 0 181 0 67]
#[0 0 34 0 1 0 2 0 4 0 5 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 26 0 29 0 30 0 63]
#[0 0 38 0 1 0 2 0 4 0 5 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 26 0 29 0 30 0 63]
#[0 1 14 0 2 0 4 0 8 0 10 0 13 0 14 0 15 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 29 0 30 0 63]
#[0 1 22 0 2 0 4 0 8 0 10 0 13 0 14 0 15 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 29 0 30 0 63]
#[1 0 61 0 20 0 65 0 29 0 201 0 35]
#[0 1 10 0 63]
#[0 1 6 0 63]
#[1 0 205 0 17 0 61 0 20 0 65 0 29 0 209 0 35]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 0 141 0 35 0 213 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 181 0 67]
#[1 0 217 0 2 0 221 0 6 0 225 0 18 0 229 0 20 0 233 0 23 0 237 0 24 0 241 0 25 0 245 0 26]
#[0 1 126 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 122 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 118 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[1 0 6 0 2 0 6 0 4 0 6 0 10 0 6 0 12 0 6 0 13 0 6 0 14 0 37 0 15 0 249 0 16 0 41 0 17 0 6 0 18 0 6 0 19 0 6 0 20 0 6 0 21 0 6 0 22 0 6 0 23 0 6 0 29 0 6 0 30 0 45 0 33 0 253 0 39 1 1 0 66]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 0 141 0 35 1 5 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 181 0 67]
#[0 1 130 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 134 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 142 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 138 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 114 0 12 0 63]
#[1 0 126 0 1 0 126 0 5 1 9 0 11 0 126 0 12 0 126 0 20 0 126 0 24 0 126 0 26 0 126 0 63]
#[1 1 13 0 5 0 134 0 12 1 17 0 45 0 134 0 63]
#[0 0 42 0 5 0 12 0 63]
#[0 0 130 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[0 0 62 0 1 0 5 0 12 0 63]
#[1 0 110 0 1 0 110 0 5 0 110 0 9 0 110 0 12 1 21 0 43 0 110 0 63]
#[1 0 94 0 1 0 94 0 5 0 94 0 12 1 25 0 20 1 29 0 24 1 33 0 26 1 37 0 50 1 41 0 51 1 45 0 52 0 94 0 63]
#[1 0 102 0 1 0 102 0 5 0 102 0 9 0 102 0 12 1 29 0 24 1 33 0 26 1 49 0 51 1 53 0 52 0 102 0 63]
#[1 0 106 0 1 0 106 0 5 0 106 0 9 0 106 0 12 1 25 0 20 1 29 0 24 1 33 0 26 1 57 0 50 1 61 0 51 1 65 0 52 0 106 0 63]
#[0 0 98 0 1 0 5 0 9 0 12 0 63]
#[0 0 122 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[1 0 174 0 1 0 174 0 2 0 174 0 3 0 174 0 4 0 174 0 5 0 174 0 6 0 174 0 7 0 174 0 9 0 174 0 10 0 174 0 13 0 174 0 14 0 174 0 20 0 174 0 21 0 174 0 22 0 174 0 23 0 174 0 24 0 174 0 26 0 174 0 30 1 69 0 49]
#[1 1 182 0 2 1 182 0 4 1 182 0 8 1 182 0 10 1 182 0 13 1 182 0 14 1 182 0 18 1 182 0 19 1 182 0 20 1 182 0 21 1 182 0 22 1 182 0 23 1 182 0 29 1 182 0 30 1 182 0 63 1 73 0 68]
#[1 0 50 0 17 0 50 0 20 0 50 0 29 1 77 0 37]
#[0 1 110 0 63]
#[0 1 18 0 2 0 4 0 8 0 10 0 13 0 14 0 15 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 29 0 30 0 63]
#[0 0 14 0 2 0 4 0 10 0 12 0 13 0 14 0 18 0 19 0 20 0 21 0 22 0 23 0 29 0 30 0 63]
#[0 0 54 0 17 0 20 0 29]
#[0 1 81 0 1]
#[1 1 34 0 1 1 34 0 2 1 34 0 4 1 34 0 6 1 34 0 10 1 34 0 13 1 34 0 14 1 34 0 18 1 34 0 20 1 34 0 21 1 34 0 22 1 34 0 23 1 34 0 24 1 34 0 25 1 34 0 26 1 34 0 29 1 34 0 30 1 34 0 32 1 85 0 60]
#[1 1 89 0 20 1 93 0 29]
#[1 1 26 0 12 1 26 0 21 1 97 0 59]
#[0 1 150 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 146 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 158 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 162 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 154 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[1 0 61 0 20 0 65 0 29 1 101 0 35]
#[1 1 105 0 12 1 109 0 15 1 113 0 16 1 117 0 17]
#[0 1 121 0 12]
#[1 1 125 0 5 0 134 0 12 1 129 0 45 0 134 0 63]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 0 141 0 35 1 133 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 181 0 67]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 138 0 12 0 105 0 13 0 109 0 14 0 113 0 18 1 137 0 19 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 0 141 0 35 1 141 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 138 0 63 0 181 0 67]
#[0 0 22 0 12 0 63]
#[1 0 90 0 1 0 90 0 5 1 145 0 9 0 90 0 12 0 90 0 63]
#[0 0 218 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 1 149 0 35 0 153 0 40 1 153 0 44 1 157 0 46 1 161 0 47 1 165 0 53 0 181 0 67]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 1 149 0 35 0 153 0 40 1 169 0 44 1 173 0 47 1 177 0 54 0 181 0 67]
#[0 0 158 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[0 0 150 0 1 0 5 0 9 0 12 0 24 0 26 0 63]
#[1 1 98 0 1 1 98 0 5 1 98 0 9 1 98 0 12 1 181 0 24 1 98 0 63]
#[0 0 142 0 1 0 5 0 9 0 12 0 24 0 26 0 63]
#[1 1 90 0 1 1 90 0 5 1 90 0 9 1 90 0 12 1 181 0 24 1 90 0 63]
#[0 0 154 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[0 0 146 0 1 0 5 0 9 0 12 0 24 0 26 0 63]
#[1 1 94 0 1 1 94 0 5 1 94 0 9 1 94 0 12 1 181 0 24 1 94 0 63]
#[1 1 185 0 1 1 189 0 2 1 193 0 3 0 97 0 4 1 197 0 5 1 201 0 6 1 205 0 7 1 209 0 9 0 101 0 10 0 105 0 13 0 109 0 14 1 213 0 20 0 121 0 21 0 125 0 22 0 129 0 23 1 217 0 24 1 221 0 26 0 133 0 30 1 225 0 67]
#[1 0 93 0 2 0 97 0 4 0 185 0 8 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 117 0 19 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 1 229 0 34 0 141 0 35 0 145 0 36 0 149 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 18 0 63 0 181 0 67]
#[1 1 233 0 17 0 61 0 20 0 65 0 29 0 209 0 35]
#[0 0 118 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[1 1 237 0 1 1 241 0 2 0 97 0 4 1 245 0 6 0 101 0 10 0 105 0 13 0 109 0 14 1 249 0 18 1 253 0 20 0 121 0 21 0 125 0 22 0 129 0 23 2 1 0 24 2 5 0 25 2 9 0 26 2 13 0 29 0 133 0 30 2 17 0 32 2 21 0 61 2 25 0 67]
#[0 2 29 0 3]
#[0 2 33 0 3]
#[1 2 37 0 12 2 41 0 21]
#[0 0 66 0 12 0 15 0 16 0 17]
#[0 0 82 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[1 0 50 0 17 0 50 0 20 0 50 0 29 2 45 0 37]
#[1 0 61 0 20 0 65 0 29 2 49 0 35]
#[1 0 6 0 2 0 6 0 4 0 6 0 10 0 6 0 12 0 6 0 13 0 6 0 14 0 37 0 15 0 41 0 17 0 6 0 18 0 6 0 19 0 6 0 20 0 6 0 21 0 6 0 22 0 6 0 23 0 6 0 29 0 6 0 30 0 45 0 33 2 53 0 66]
#[0 0 78 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[0 0 138 0 12 0 63]
#[0 0 30 0 12 0 63]
#[0 0 58 0 1 0 5 0 12 0 63]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 0 141 0 35 2 57 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 181 0 67]
#[0 0 46 0 5 0 12 0 63]
#[1 1 25 0 20 1 29 0 24 1 33 0 26 2 61 0 48 2 65 0 50 2 69 0 51 2 73 0 52]
#[0 0 126 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[1 0 242 0 1 0 242 0 5 0 242 0 9 0 242 0 12 1 25 0 20 0 242 0 24 1 33 0 26 1 37 0 50 1 41 0 51 0 242 0 63]
#[1 0 234 0 1 0 234 0 5 0 234 0 9 0 234 0 12 0 234 0 24 1 33 0 26 1 49 0 51 0 234 0 63]
#[1 0 238 0 1 0 238 0 5 0 238 0 9 0 238 0 12 1 25 0 20 0 238 0 24 1 33 0 26 1 57 0 50 1 61 0 51 0 238 0 63]
#[0 0 226 0 1 0 5 0 9 0 12 0 24 0 63]
#[1 0 250 0 1 0 250 0 5 0 250 0 9 0 250 0 12 1 25 0 20 0 250 0 24 0 250 0 26 1 37 0 50 0 250 0 63]
#[1 0 246 0 1 0 246 0 5 0 246 0 9 0 246 0 12 1 25 0 20 0 246 0 24 0 246 0 26 1 57 0 50 0 246 0 63]
#[0 0 222 0 1 0 5 0 9 0 12 0 24 0 26 0 63]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 1 149 0 35 0 153 0 40 1 153 0 44 1 157 0 46 1 161 0 47 2 77 0 53 0 181 0 67]
#[0 0 190 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 186 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 198 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 206 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 194 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 1 186 0 2 0 4 0 8 0 10 0 13 0 14 0 15 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 29 0 30 0 63]
#[0 0 202 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 210 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 178 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 214 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 0 182 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 13 0 14 0 20 0 21 0 22 0 23 0 24 0 26 0 30]
#[0 1 106 0 63]
#[1 1 182 0 2 1 182 0 4 1 182 0 8 1 182 0 10 1 182 0 13 1 182 0 14 1 182 0 18 1 182 0 19 1 182 0 20 1 182 0 21 1 182 0 22 1 182 0 23 1 182 0 29 1 182 0 30 1 182 0 63 2 81 0 68]
#[0 1 170 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[1 1 34 0 1 1 34 0 2 1 34 0 4 1 34 0 6 1 34 0 10 1 34 0 13 1 34 0 14 1 34 0 18 1 34 0 20 1 34 0 21 1 34 0 22 1 34 0 23 1 34 0 24 1 34 0 25 1 34 0 26 1 34 0 29 1 34 0 30 1 34 0 32 2 85 0 60]
#[1 2 89 0 20 2 93 0 29]
#[1 1 26 0 12 1 26 0 21 2 97 0 59]
#[1 1 50 0 1 1 50 0 2 1 50 0 4 1 50 0 6 1 50 0 10 2 101 0 11 1 50 0 13 1 50 0 14 1 50 0 18 1 50 0 20 1 50 0 21 1 50 0 22 1 50 0 23 1 50 0 24 1 50 0 25 1 50 0 26 1 50 0 29 1 50 0 30 1 50 0 32]
#[0 1 58 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 62 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 54 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 86 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 82 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 38 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 46 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 174 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 178 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 166 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 9 0 10 0 12 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32 0 63]
#[0 1 30 0 12 0 21]
#[1 2 105 0 17 0 61 0 20 0 65 0 29 0 209 0 35]
#[0 0 70 0 12 0 15 0 16 0 17]
#[0 2 109 0 12]
#[1 1 125 0 5 0 134 0 12 2 113 0 45 0 134 0 63]
#[0 0 114 0 1 0 5 0 9 0 12 0 63]
#[0 0 162 0 1 0 5 0 9 0 12 0 63]
#[0 0 166 0 1 0 5 0 9 0 12 0 63]
#[1 0 170 0 1 0 170 0 5 0 170 0 9 0 170 0 12 1 181 0 24 0 170 0 63]
#[0 0 230 0 1 0 5 0 9 0 12 0 24 0 63]
#[1 0 93 0 2 0 97 0 4 0 185 0 8 0 101 0 10 0 105 0 13 0 109 0 14 0 113 0 18 0 117 0 19 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 2 117 0 34 0 141 0 35 0 145 0 36 0 149 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 18 0 63 0 181 0 67]
#[1 2 121 0 1 1 241 0 2 0 97 0 4 1 245 0 6 0 101 0 10 0 105 0 13 0 109 0 14 1 249 0 18 1 253 0 20 0 121 0 21 0 125 0 22 0 129 0 23 2 1 0 24 2 5 0 25 2 9 0 26 2 13 0 29 0 133 0 30 2 17 0 32 2 21 0 61 2 25 0 67]
#[0 2 125 0 3]
#[0 2 129 0 3]
#[1 2 133 0 12 2 41 0 21]
#[0 1 42 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[1 0 93 0 2 0 97 0 4 0 101 0 10 0 18 0 12 0 105 0 13 0 109 0 14 0 113 0 18 0 117 0 19 0 61 0 20 0 121 0 21 0 125 0 22 0 129 0 23 0 65 0 29 0 133 0 30 2 137 0 34 0 141 0 35 0 145 0 36 0 149 0 38 0 153 0 40 0 157 0 41 0 161 0 42 0 165 0 44 0 169 0 46 0 173 0 47 0 177 0 62 0 181 0 67]
#[0 0 74 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
#[0 0 26 0 12 0 63]
#[0 1 102 0 63]
#[0 1 74 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 66 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 70 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 1 78 0 1 0 2 0 4 0 6 0 10 0 13 0 14 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 29 0 30 0 32]
#[0 2 141 0 12]
#[0 0 86 0 1 0 5 0 9 0 12 0 20 0 24 0 26 0 63]
)! !
!StParser categoriesFor: #actionForCurrentToken!private! !
!StParser categoriesFor: #createMessageNodeFrom:!private! !
!StParser categoriesFor: #reduceActionForArray1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArray2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArray3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral10:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral11:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral4:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral5:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral6:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral7:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral8:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForArrayLiteral9:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBinaryMessage1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBinaryMethodName1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBlock1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBlock2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBlock3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBlock4:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBlockArgs1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForBlockArgs2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForByteArray1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForByteArray2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForCascade1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForCascadeList1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForCascadeList2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForExpression1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForKeywordMessage1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForKeywordMessage2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForKeywordMethodName1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForKeywordMethodName2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral10:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral11:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral12:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral13:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral14:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral15:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral16:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral4:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral5:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral6:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral7:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral8:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForLiteral9:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForMethod1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForMethod2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForMethod3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForMethodSequenceNode1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForMethodSequenceNode2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForMethodSequenceNode3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForOptional_____1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForOptional_____2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimary2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend10:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend11:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend4:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend5:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend6:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend7:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend8:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitiveMessageSend9:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitives1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForPrimitives2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForSequenceNode1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForStatementList2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForStatements1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForStatements3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForStatements4:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForTemporaries1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForTemporaries2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForTemporaries3:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForTemporaryVariables1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForTemporaryVariables2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForUnaryMessage1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForVariable1:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceActionForVariable2:!generated-reduction actions!public! !
!StParser categoriesFor: #reduceTable!generated-tables!public! !
!StParser categoriesFor: #transitionTable!generated-tables!public! !

!StParser class methodsFor!

parseExpression: aString 
	^self simplifyExpression: (self parse: aString
				startingAt: self startingStateForSequenceNode)!

parseExpression: aString onError: aBlock 
	^self simplifyExpression: (self 
				parse: aString
				startingAt: self startingStateForSequenceNode
				onError: aBlock)!

parseMethod: aString 
	^self parse: aString startingAt: self startingStateForMethod!

parseMethod: aString onError: aBlock 
	^self 
		parse: aString
		startingAt: self startingStateForMethod
		onError: aBlock!

parserDefinitionComment

	"%id <number> <negative_number> <name> <binary_symbol>;
%start SequenceNode ;

Method:
	  <name> MethodSequenceNode {(RBMethodNode selector: '1' value asSymbol arguments: #() body: '2' last) ""tags: '2' first; yourself""}
	| BinaryMethodName MethodSequenceNode {(RBMethodNode selector: '1' first arguments: '1' last body: '2' last) ""tags: '2' first; yourself""}
	| KeywordMethodName MethodSequenceNode {(RBMethodNode selector: '1' first contents asSymbol arguments: '1' last body: '2' last) ""tags: '2' first; yourself""};

BinaryMethodName:
	<binary_symbol> Variable {Array with: '1' value asSymbol with: (Array with: '2')} ;

KeywordMethodName:
	<keyword> Variable {| stream | stream := WriteStream on: (String new: 30). stream nextPutAll: '1' value. Array with: stream with: (OrderedCollection with: '2')}
	| KeywordMethodName <keyword> Variable {'1' first nextPutAll: '2' value. '1' last add: '3'. '1'};

Primitives:
	{OrderedCollection new}
	| Primitives ""<"" PrimitiveMessageSend "">"" {'1' add: ('2' startPosition to: '4' startPosition); yourself};

PrimitiveMessageSend:
	| PrimitiveMessageSend <keyword> {nil}
	| PrimitiveMessageSend Literal {nil}
	| PrimitiveMessageSend ""("" {nil}
	| PrimitiveMessageSend "")"" {nil}
	| PrimitiveMessageSend ""{"" {nil}
	| PrimitiveMessageSend ""}"" {nil}
	| PrimitiveMessageSend "";"" {nil}
	| PrimitiveMessageSend ""."" {nil}
	| PrimitiveMessageSend <name> {nil}
	| PrimitiveMessageSend <binary_symbol> {nil};

MethodSequenceNode:
	Primitives ""|"" TemporaryVariables ""|"" Primitives Statements {Array with: ('1' addAll: '5'; yourself) with: (RBSequenceNode temporaries: '3' statements: '6')}
	| Primitives ""||"" Primitives Statements {Array with: ('1' addAll: '3'; yourself) with: (RBSequenceNode temporaries: #() statements: '4')}
	| Primitives Statements {Array with: '1' with: (RBSequenceNode temporaries: #() statements: '2')};

SequenceNode:
	Temporaries Statements {RBSequenceNode temporaries: '1' statements: '2'};

Temporaries:
	{#()}
	| ""||"" {#()}
	| ""|"" TemporaryVariables ""|"" {'2'};

TemporaryVariables:
	{OrderedCollection new}
	| TemporaryVariables Variable {'1' add: '2'; yourself};

Statements:
	{OrderedCollection new}
	| StatementList "".""? {#liftFirstValue:}
	| StatementList ""."" ""^"" Expression "".""? {'1' add: (RBReturnNode value: '4'); yourself}
	| ""^"" Expression "".""? {OrderedCollection with: (RBReturnNode value: '2')};

StatementList:
	Expression
	| StatementList ""."" Expression {'1' add: '3'; yourself};

Block:
	""["" BlockArgs ""|"" SequenceNode ""]"" {RBBlockNode arguments: '2' body: '4'}
	| ""["" SequenceNode ""]"" {RBBlockNode body: '2'}
	| ""["" BlockArgs ""]"" {RBBlockNode arguments: '2' body: (RBSequenceNode statements: #())}
	| ""["" BlockArgs ""||"" TemporaryVariables ""|"" Statements ""]"" {RBBlockNode arguments: '2' body: (RBSequenceNode temporaries: '4' statements: '6')};

BlockArgs:
	"":"" Variable {OrderedCollection with: '2'}
	| BlockArgs "":"" Variable {'1' add: '3'; yourself};


Expression:
	Variable "":="" Expression {RBAssignmentNode variable: '1' value: '3'}
|	Cascade {#liftFirstValue:};

Cascade:
	MessageSend CascadeList 
				{| messages |
				'2' isEmpty ifTrue: [^'1'].
				messages := OrderedCollection new: '2' size + 1.
				messages add: '1'.
				'2' do: [:each | messages add: (RBMessageNode receiver: '1' receiver selector: each first contents asSymbol arguments: each last)].
				RBCascadeNode messages: messages}
|	Primary {#liftFirstValue:};

MessageSend:
	KeywordMessageSend {#liftFirstValue:}
|	BinaryMessageSend {#liftFirstValue:}
|	UnaryMessageSend {#liftFirstValue:};

CascadeList:
	{OrderedCollection new}
|	CascadeList "";"" SimpleMessage {'1' add: '3'; yourself};

SimpleMessage:
	UnaryMessage {#liftFirstValue:}
|	BinaryMessage {#liftFirstValue:}
|	KeywordMessage {#liftFirstValue:};

KeywordMessageSend:
	BinaryMessageSend KeywordMessage {#createMessageNodeFrom:}
|	UnaryMessageSend KeywordMessage {#createMessageNodeFrom:}
|	Primary KeywordMessage {#createMessageNodeFrom:};

KeywordMessage:
	<keyword> KeywordArgument {| stream | stream := WriteStream on: (String new: 30). stream nextPutAll: '1' value. Array with: stream with: (OrderedCollection with: '2')}
|	KeywordMessage <keyword> KeywordArgument {'1' first nextPutAll: '2' value. '1' last add: '3'. '1'};

KeywordArgument:
	BinaryMessageSend {#liftFirstValue:}
|	UnaryMessageSend {#liftFirstValue:}
|	Primary {#liftFirstValue:};

BinaryMessageSend:
	BinaryMessageSend BinaryMessage {#createMessageNodeFrom:}
|	UnaryMessageSend BinaryMessage {#createMessageNodeFrom:}
|	Primary BinaryMessage {#createMessageNodeFrom:} ;

BinaryMessage :
	<binary_symbol> BinaryArgument {Array with: (ReadStream on: '1' value) with: (Array with: '2')};

BinaryArgument:
	UnaryMessageSend {#liftFirstValue:}
|	Primary {#liftFirstValue:};

UnaryMessageSend :
	UnaryMessageSend UnaryMessage {#createMessageNodeFrom:}
|	Primary UnaryMessage {#createMessageNodeFrom:};

UnaryMessage :
	<name> {Array with: (ReadStream on: '1' value) with: #()};


Primary: 
	""("" Expression "")"" {#liftSecondValue:}
|	Literal {RBLiteralNode value: '1'}
|	Variable {#liftFirstValue:}
|	Block {#liftFirstValue:};

Variable: 
	<name> {RBVariableNode named: '1' value}
|	<dotted_name> {RBVariableNode named: '1' value};

Literal:
	""true"" {true}
|	""false"" {false}
|	""nil"" {nil}
|	<number> {'1' value}
|	<negative_number> {'1' value}
|	<character> {'1' value at: 2}
|	<string> {('1' value copyFrom: 2 to: '1' value size - 1) copyReplaceAll: '''''' with: ''''}
|	 ""#"" <string> {(('2' value copyFrom: 2 to: '2' value size - 1) copyReplaceAll: '''''' with: '''') asSymbol}
|	""#"" <name> {'2' value asSymbol}
|	""#"" <binary_symbol> {'2' value asSymbol}
|	""#"" <keyword> {'2' value asSymbol}
|	""#"" <multikeyword> {'2' value asSymbol}
|	""#"" ""["" ByteArray ""]"" {'3' contents}
|	""#"" ""("" Array "")"" {'3' contents}
|	""#"" ""{"" <name> ""}"" {'3' value asQualifiedReference}
|	""#"" ""{"" <dotted_name> ""}"" {'3' value asQualifiedReference};

ByteArray: 
	{WriteStream on: ByteArray new}
|	ByteArray <number> {'1' nextPut: '2' value; yourself};

Array: 
	{WriteStream on: Array new}
|	Array ArrayLiteral {'1' nextPut: '2'; yourself} 
|	Array <name> "":="" {'2' stopPosition + 1 = '3' startPosition ifTrue: ['1' nextPut: ('2' value, ':') asSymbol] ifFalse: ['1' nextPut: '2' value asSymbol; nextPut: #':']. scanner position: '3' startPosition. currentToken := nil. '1'};

ArrayLiteral:
	Literal {#liftFirstValue:}
|	<name> {'1' value asSymbol}
|	<binary_symbol> {'1' value asSymbol}
|	<keyword> {'1' value asSymbol}
|	<multikeyword> {'1' value asSymbol}
|	""{"" <name> ""}"" {'2' value asQualifiedReference}
|	""{"" <dotted_name> ""}"" {'2' value asQualifiedReference}
|	""("" Array "")"" {'2' contents}
|	""["" ByteArray ""]"" {'2' contents}
|	<any_char> {'1' value asSymbol}
|	<dotted_name> {'1' value};"!

scannerClass
	^StScanner!

simplifyExpression: aSequenceNode 
	^(aSequenceNode statements size == 1 
		and: [aSequenceNode temporaries isEmpty]) 
			ifTrue: [aSequenceNode statements first]
			ifFalse: [aSequenceNode]!

startingStateForMethod
	^1!

startingStateForSequenceNode
	^2! !
!StParser class categoriesFor: #parseExpression:!accessing!public! !
!StParser class categoriesFor: #parseExpression:onError:!accessing!public! !
!StParser class categoriesFor: #parseMethod:!accessing!public! !
!StParser class categoriesFor: #parseMethod:onError:!accessing!public! !
!StParser class categoriesFor: #parserDefinitionComment!generated-comments!public! !
!StParser class categoriesFor: #scannerClass!generated-accessing!public! !
!StParser class categoriesFor: #simplifyExpression:!private! !
!StParser class categoriesFor: #startingStateForMethod!generated-starting states!public! !
!StParser class categoriesFor: #startingStateForSequenceNode!generated-starting states!public! !

