"Filed out from Dolphin Smalltalk XP"!

Set variableSubclass: #SmaCCItemSet
	instanceVariableNames: 'type'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCItemSet guid: (GUID fromString: '{128223EE-D68E-4593-9F5C-EECD9FB3212F}')!
SmaCCItemSet comment: 'SmaCCItemSet represents a LALR(1) or a LR(1) item set.

Instance Variables:
	type	<Symbol>	#LALR1 or #LR1

'!
!SmaCCItemSet categoriesForClass!SmaCC Runtime! !
!SmaCCItemSet methodsFor!

= anItemSet 
	self class = anItemSet class 
		ifTrue: 
			[type == #LALR1
				ifTrue: [^self isLALREqualTo: anItemSet]
				ifFalse: [^self isLREqualTo: anItemSet]].
	^false!

action: aGrammarSymbol prefer: aClass 
	| action actionItem eachAction |
	action := SmaCCRejectAction new.
	self do: 
			[:each | 
			eachAction := each action: aGrammarSymbol.
			action class = SmaCCRejectAction 
				ifTrue: 
					[action := eachAction.
					actionItem := each]
				ifFalse: 
					[(eachAction = action or: [eachAction class = SmaCCRejectAction]) 
						ifFalse: 
							[eachAction class = SmaCCShiftAction | (action class = SmaCCShiftAction) 
								ifTrue: 
									["Shift/Reduce conflict -- check precedence"

									(aGrammarSymbol precedence isNil 
										or: [each precedence isNil or: [actionItem precedence isNil]]) 
											ifTrue: 
												["No precedence, choose shift"

												eachAction class = SmaCCShiftAction 
													ifTrue: 
														[self 
															raiseXReduceNotification: each
															with: actionItem
															type: 'Shift/Reduce Conflict'.
														action := eachAction.
														actionItem := each]
													ifFalse: 
														[self 
															raiseXReduceNotification: actionItem
															with: each
															type: 'Shift/Reduce Conflict']]
											ifFalse: 
												[(each precedence > actionItem precedence 
													or: [each precedence = actionItem precedence and: [eachAction class = aClass]]) 
														ifTrue: 
															[self 
																raiseXReduceNotification: each
																with: actionItem
																type: 'Shift/Reduce Conflict (handled by precedence rules)'.
															action := eachAction.
															actionItem := each]
														ifFalse: 
															[(each precedence = actionItem precedence and: [SmaCCRejectAction = aClass]) 
																ifTrue: 
																	[self 
																		raiseXReduceNotificationWithNoPreferredItem: actionItem
																		with: each
																		type: 'Shift/Reduce Conflict (handled by precedence rules)'.
																	^aClass new]
																ifFalse: 
																	[self 
																		raiseXReduceNotification: actionItem
																		with: each
																		type: 'Shift/Reduce Conflict (handled by precedence rules)']]]]
								ifFalse: 
									["Reduce/Reduce conflict -- just pick one and proceed"

									self 
										raiseXReduceNotification: actionItem
										with: each
										type: 'Reduce/Reduce Conflict']]]].
	^action!

add: aLR1Item
	| index item |
	aLR1Item == nil ifTrue: [^aLR1Item].
	index := self findElementOrNil: aLR1Item.
	item := self basicAt: index.
	item == nil 
		ifTrue: 
			[self privateAt: index put: aLR1Item.
			self performClosureOn: aLR1Item]
		ifFalse: [item mergeWith: aLR1Item].
	^aLR1Item!

copyEmpty: aSize 
	^(super copyEmpty: aSize)
		type: type;
		yourself!

hash
	^self inject: self class hash into: [:sum :each | sum bitXor: each hash]!

initialize
	(self class superclass canUnderstand: #initialize) 
		ifTrue: [super initialize].
	type := #LALR1!

isLALREqualTo: anItemSet 
	^anItemSet size = self size 
		and: [self allSatisfy: [:each | anItemSet includes: each]]!

isLREqualTo: anItemSet 
	^anItemSet size = self size and: 
			[self allSatisfy: 
					[:each | 
					| item |
					(item := anItemSet itemFor: each) notNil and: [each isLR1EqualTo: item]]]!

itemFor: anObject 
	^self basicAt: (self findElementOrNil: anObject)!

mergeWith: anItemSet 
	self == anItemSet ifTrue: [^self].
	anItemSet do: [:each | self add: each]!

moveOn: aGrammarSymbol 
	| anItemSet |
	anItemSet := self class new.
	anItemSet type: type.
	self 
		do: [:each | each nextSymbol == aGrammarSymbol ifTrue: [anItemSet add: each moveNext]].
	^anItemSet!

performClosureOn: aLR1Item 
	| nextSymbol rest first followers |
	nextSymbol := aLR1Item nextSymbol.
	nextSymbol isTerminal ifTrue: [^self].
	rest := aLR1Item rest.
	first := rest firstTerminals.
	followers := SmaCCSymbolSet new.
	(first includes: SmaCCSymbol empty) 
		ifTrue: 
			[first remove: SmaCCSymbol empty.
			followers baseOn: aLR1Item followers].
	followers addAll: first.
	nextSymbol productionsDo: 
			[:each | 
			self add: (SmaCCLR1Item 
						symbol: nextSymbol
						rhs: each
						follow: followers)]!

printOn: aStream 
	self do: 
			[:each | 
			aStream
				tab;
				nextPutAll: each printString;
				cr]!

raiseXReduceNotification: preferredItem with: otherItem type: aString
	| stream |
	stream := WriteStream on: (String new: 200).
	stream
		nextPutAll: preferredItem printString;
		nextPutAll: '	*****';
		cr;
		nextPutAll: otherItem printString.
	SmaCCCompilationNotification signal: aString with: stream contents!

raiseXReduceNotificationWithNoPreferredItem: firstItem with: secondItem type: aString
	| stream |
	stream := WriteStream on: (String new: 200).
	stream
		nextPutAll: firstItem printString;
		cr;
		nextPutAll: secondItem printString.
	SmaCCCompilationNotification signal: aString with: stream contents!

type: aSymbol 
	type := aSymbol! !
!SmaCCItemSet categoriesFor: #=!comparing!public! !
!SmaCCItemSet categoriesFor: #action:prefer:!accessing!public! !
!SmaCCItemSet categoriesFor: #add:!adding!public! !
!SmaCCItemSet categoriesFor: #copyEmpty:!copying!public! !
!SmaCCItemSet categoriesFor: #hash!comparing!public! !
!SmaCCItemSet categoriesFor: #initialize!initialize-release!public! !
!SmaCCItemSet categoriesFor: #isLALREqualTo:!public!testing! !
!SmaCCItemSet categoriesFor: #isLREqualTo:!public!testing! !
!SmaCCItemSet categoriesFor: #itemFor:!private! !
!SmaCCItemSet categoriesFor: #mergeWith:!accessing!public! !
!SmaCCItemSet categoriesFor: #moveOn:!accessing!public! !
!SmaCCItemSet categoriesFor: #performClosureOn:!private! !
!SmaCCItemSet categoriesFor: #printOn:!printing!public! !
!SmaCCItemSet categoriesFor: #raiseXReduceNotification:with:type:!accessing!public! !
!SmaCCItemSet categoriesFor: #raiseXReduceNotificationWithNoPreferredItem:with:type:!accessing!public! !
!SmaCCItemSet categoriesFor: #type:!initialize-release!public! !

!SmaCCItemSet class methodsFor!

new: anInteger 
	^(super new: anInteger)
		initialize;
		yourself! !
!SmaCCItemSet class categoriesFor: #new:!instance creation!public! !

