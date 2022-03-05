"Filed out from Dolphin Smalltalk"!

BasicLintRule subclass: #BlockLintRule
	instanceVariableNames: 'classBlock methodBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BlockLintRule guid: (GUID fromString: '{7468dd67-0d2d-4f26-8882-01746170e78a}')!
BlockLintRule comment: ''!
!BlockLintRule categoriesForClass!Refactory-Lint! !
!BlockLintRule methodsFor!

checkClass: aSmalllintContext 
	^classBlock value: aSmalllintContext value: result!

checkMethod: aSmalllintContext 
	^methodBlock value: aSmalllintContext value: result!

classBlock: aBlock
	classBlock := aBlock!

initialize
	super initialize.
	classBlock := [:context :aResult | ].
	methodBlock := [:context :aResult | ]!

methodBlock: aBlock
	methodBlock := aBlock!

undeclaredVariables
	"Answer the Dictionary holding undeclared global variables."

	#rbFix. "Dolphin does not support forward refs. to undeclared variables"
	^Dictionary new! !
!BlockLintRule categoriesForMethods!
checkClass:!accessing!public! !
checkMethod:!accessing!public! !
classBlock:!initialize/release!public! !
initialize!initialize/release!public! !
methodBlock:!initialize/release!public! !
undeclaredVariables!public! !
!

!BlockLintRule class methodsFor!

abstractClass
	| detector subclassResponsibilitySymbol |
	detector := self new.
	detector name: 'References an abstract class'.
	detector resultClass: ClassEnvironment.
	subclassResponsibilitySymbol := 'subclassResponsibility' asSymbol.
	detector classBlock: 
			[:context :result | 
			(context selectedClass whichSelectorsReferTo: subclassResponsibilitySymbol) notEmpty 
				ifTrue: 
					[(context uses: context selectedClass) ifTrue: [result addClass: context selectedClass]]].
	^detector!

addRemoveDependents
	| detector |
	detector := self new.
	detector resultClass: ClassEnvironment.
	detector name: 'Number of addDependent: messages > removeDependent:'.
	detector classBlock: 
			[:context :result | 
			| count |
			count := 0.
			((Set withAll: (context selectedClass whichSelectorsReferTo: #addDependent:))
				addAll: (context selectedClass whichSelectorsReferTo: #removeDependent:);
				yourself) do: 
						[:sel | 
						(context selectedClass compiledMethodAt: sel) messagesDo: 
								[:each | 
								each == #addDependent: ifTrue: [count := count + 1].
								each == #removeDependent: ifTrue: [count := count - 1]]].
			count > 0 ifTrue: [result addClass: context selectedClass]].
	^detector!

badMessage
	| detector badMessages |
	detector := self new.
	detector name: 'Sends "questionable" message'.
	badMessages := self badSelectors.
	#rbfix.	"Should really be using a methodBlock rather than a classBlock (an inappropriate optimization)"
	detector methodBlock: 
			[:context :result | 
			| method |
			method := context compiledMethod.
			badMessages do: 
					[:each | 
					#rbFix.	"Ignore references which are not actual message sends"
					((method refersToLiteral: each) and: [method messages includes: each]) 
						ifTrue: 
							[result addClass: method methodClass selector: method selector.
							result addSearchString: each]]].
	^detector!

badSelectors
	"Answer a list of selectors that may indicate a bad code smell. This is somewhat dialect specific."

	#rbFix.	"Modified to a more suitable set for Dolphin"
	^#(#become: #swappingBecome: #oneWayBecome: #becomeA: #becomeAn: #isKindOf: #includesBehavior: #respondsTo: #isMemberOf: #canUnderstand: #allReferences #allInstances #instVarAt: #instVarAt:put: #halt)!

classInstVarNotInitialized
	| detector |
	detector := self new.
	detector name: 'Has class instance variables but no initialize method'.
	detector resultClass: ClassEnvironment.
	detector classBlock: 
			[:context :result | 
			context selectedClass isMeta 
				ifTrue: 
					[(context selectedClass instVarNames notEmpty 
						and: [(context selectedClass includesSelector: #initialize) not]) 
							ifTrue: [result addClass: context selectedClass]]].
	^detector!

classNameInSelector
	| detector |
	detector := self new.
	detector name: 'Redundant class name in selector'.
	detector methodBlock: 
			[:context :result | 
			(context selectedClass isMeta and: 
					[(context selector
						indexOfSubCollection: context selectedClass soleInstance name
						startingAt: 1) > 0])
				ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector!

classNotReferenced
	| detector |
	detector := self new.
	detector name: 'Class not referenced'.
	detector resultClass: ClassEnvironment.
	detector classBlock: 
			[:context :result | 
			(context selectedClass isMeta or: [context selectedClass subclasses notEmpty]) 
				ifFalse: 
					[((context uses: context selectedClass) or: [context uses: context selectedClass name]) 
						ifFalse: 
							[result
								addClass: context selectedClass;
								addClass: context selectedClass class]]].
	^detector!

classShouldNotOverride
	#rbFix.	"Extend to include Dolphin's optimized selector"
	^#(#== #class #basicAt: #basicAt:put: #basicClass #basicSize #isNil #notNil)	"#class can be overridden, but it is worth flagging"!

collectionCopyEmpty
	| detector |
	detector := self new.
	detector 
		name: 'Subclass of collection that has instance variable but doesn''t define copyEmpty:'.
	detector resultClass: ClassEnvironment.
	detector classBlock: 
			[:context :result | 
			(context selectedClass isVariable and: 
					[(context selectedClass includesSelector: #copyEmpty:) not and: 
							[context selectedClass instVarNames notEmpty 
								and: [context selectedClass inheritsFrom: Collection]]]) 
				ifTrue: [result addClass: context selectedClass]].
	^detector!

collectionMessagesToExternalObject
	| detector matcher smalllintContext |
	detector := self new.
	detector name: 'Sends add:/remove: to external collection'.
	matcher := ParseTreeSearcher new.
	matcher matchesAnyOf: (#(#add: #remove: #addAll: #removeAll:) 
				collect: [:each | ('(`@Object `@message: `@args) <1s> `@Arg' expandMacrosWith: each) asString])
		do: 
			[:aNode :answer | 
			answer isNil 
				ifTrue: 
					[((aNode receiver selector copyFrom: 1 to: (aNode receiver selector size min: 2)) ~= 'as' 
						and: 
							[| receiver |
							receiver := aNode receiver receiver.
							receiver isVariable not or: 
									[((#('self' 'super') includes: receiver name) 
										or: [(smalllintContext selectedClass environment bindingFor: receiver name asSymbol) notNil]) 
											not]]) 
							ifTrue: [aNode]
							ifFalse: [nil]]
				ifFalse: [answer]].
	detector methodBlock: 
			[:context :result | 
			smalllintContext := context.
			((matcher canMatchMethod: context compiledMethod) 
				and: [(matcher executeTree: context parseTree initialAnswer: nil) notNil]) 
					ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector!

definesEqualNotHash
	| detector |
	detector := self new.
	detector name: 'Defines = but not hash'.
	detector resultClass: ClassEnvironment.
	detector classBlock: 
			[:context :result | 
			((context selectedClass includesSelector: #=) 
				and: [(context selectedClass includesSelector: #hash) not]) 
					ifTrue: [result addClass: context selectedClass]].
	^detector!

doesLiteralArrayContainComma: aLiteral 
	aLiteral class == Array ifFalse: [^false].
	(aLiteral includes: #,) ifTrue: [^true].
	^aLiteral anySatisfy: [:each | self doesLiteralArrayContainComma: each]!

equivalentSuperclassMethods
	| detector |
	detector := self new.
	detector name: 'Methods equivalently defined in superclass'.
	detector methodBlock: 
			[:context :result | 
			context selectedClass superclass notNil 
				ifTrue: 
					[(context selectedClass superclass canUnderstand: context selector) 
						ifTrue: 
							[(((context selectedClass superclass whichClassIncludesSelector: context selector) 
								compiledMethodAt: context selector) equivalentTo: context compiledMethod) 
								ifTrue: [result addClass: context selectedClass selector: context selector]]]].
	^detector!

fullBlocks
	| detector |
	detector := self new.
	detector name: 'Methods with full blocks'.
	detector methodBlock: 
			[:context :result | 
			context compiledMethod withAllBlockMethodsDo: 
					[:method | 
					method needsHybridFrame
						ifTrue: [result addClass: context selectedClass selector: context selector]]].
	^detector!

implementedNotSent
	| detector |
	detector := self new.
	detector name: 'Methods that implement messages which are never sent'.
	detector methodBlock: 
			[:context :result | 
			(context uses: context selector) 
				ifFalse: [result addClass: context selectedClass selector: context selector]].
	^detector!

instVarInSubclasses
	| detector |
	detector := self new.
	detector
		name: 'Instance variables defined in all subclasses';
		resultClass: VariableEnvironment;
		openUsing: #openWithoutFilters.
	detector classBlock: 
			[:context :result | 
			| subs |
			subs := context selectedClass subclasses.
			subs size > 1 
				ifTrue: 
					[| sels |
					sels := Bag new.
					subs do: [:each | sels addAll: each instVarNames].
					sels asSet do: 
							[:val | 
							| count |
							count := sels occurrencesOf: val.
							count == subs size 
								ifTrue: [result addClass: context selectedClass instanceVariable: val]]]].
	^detector!

justSendsSuper
	| detector matcher |
	detector := self new.
	detector name: 'Method just sends super message'.
	matcher := ParseTreeSearcher justSendsSuper.
	detector methodBlock: 
			[:context :result | 
			(context parseTree isPrimitive not 
				and: [matcher executeMethod: context parseTree initialAnswer: false]) 
					ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector!

literalArrayContainsComma
	| detector |
	detector := self new.
	detector name: 'Literal array contains a #,'.
	detector methodBlock: 
			[:context :result | 
			(context compiledMethod allLiterals 
				anySatisfy: [:each | self doesLiteralArrayContainComma: each]) 
					ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector!

longMethods
	| detector matcher |
	detector := self new.
	detector name: 'Long methods'.
	matcher := ParseTreeSearcher new.
	matcher matches: '`.Stmt'
		do: 
			[:aNode :answer | 
			(aNode children inject: answer
				into: [:sum :each | matcher executeTree: each initialAnswer: sum]) + 1].
	detector methodBlock: 
			[:context :result | 
			(matcher executeTree: context parseTree initialAnswer: 0) 
				>= self longMethodSize 
					ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector!

longMethodSize
	^10!

metaclassShouldNotOverride
	^#(#name #comment #basicAt: #basicAt:put: #basicClass #basicSize #isNil #notNil)!

missingSubclassResponsibility
	| detector |
	detector := self new.
	detector
		name: 'Method defined in all subclasses, but not in superclass';
		resultClass: MultiEnvironment;
		openUsing: #openWithoutFilters.
	detector classBlock: 
			[:context :result | 
			| subs |
			subs := context selectedClass subclasses.
			(subs size > 1 and: [context selectedClass isMeta not]) 
				ifTrue: 
					[| sels |
					sels := Bag new.
					subs do: [:each | sels addAll: each selectors].
					sels asSet do: 
							[:each | 
							((sels occurrencesOf: each) == subs size 
								and: [(context selectedClass canUnderstand: each) not]) 
									ifTrue: 
										[| envName |
										envName := context selectedClass name , '>>' , each.
										subs do: 
												[:subClass | 
												result 
													addClass: subClass
													selector: each
													into: envName]]]]].
	^detector!

onlyReadOrWritten
	| detector |
	detector := self new.
	detector
		name: 'Instance variables not read AND written';
		resultClass: VariableEnvironment;
		openUsing: #openWithoutFilters.
	detector classBlock: 
			[:context :result | 
			| allSubclasses |
			allSubclasses := context selectedClass withAllSubclasses.
			#rbFix.	"Ignore system/reserved inst. vars with underscore prefix"
			(context selectedClass instVarNames reject: [:each | each first = $_]) do: 
					[:each | 
					| isRead isWritten |
					isRead := false.
					isWritten := false.
					allSubclasses detect: 
							[:class | 
							isRead ifFalse: [isRead := (class whichMethodsRead: each) notEmpty].
							isWritten ifFalse: [isWritten := (class whichMethodsAssign: each) notEmpty].
							isRead & isWritten]
						ifNone: [result addClass: context selectedClass instanceVariable: each]]].
	^detector!

overridesSpecialMessage
	| detector |
	detector := self new.
	detector name: 'Overrides a "special" message'.
	#rbfix.	"Should really be using a methodBlock rather than a classBlock (an inappropriate optimization), and result should be a SelectorEnvironment"
	detector methodBlock: 
			[:context :result | 
			| class |
			class := context selectedClass.
			((class isMeta 
				ifTrue: [self metaclassShouldNotOverride]
				ifFalse: [self classShouldNotOverride]) includes: context selector) 
				ifTrue: 
					[(class superclass notNil and: [class superclass canUnderstand: context selector]) 
						ifTrue: [result addClass: class selector: context selector]]].
	^detector!

refersToClass
	| detector |
	detector := self new.
	detector name: 'Refers to class name instead of "self class"'.
	#rbfix.	"Should really be using a methodBlock rather than a classBlock (an inappropriate optimization)"
	detector methodBlock: 
			[:context :result |
			| method nonMeta |
			method := context compiledMethod.
			nonMeta := method methodClass instanceBehavior.
			(method refersToLiteral: (nonMeta environment bindingFor: nonMeta name))
				ifTrue: 
					[result addClass: method methodClass selector: method selector.
					result addSearchString: nonMeta name]].
	^detector!

returnsBooleanAndOther
	| detector matcher |
	detector := self new.
	detector name: 'Returns a boolean and non boolean'.
	matcher := ParseTreeSearcher new.
	matcher matches: '^``@xObject'
		do: 
			[:aNode :answer |
			answer
				add: aNode value;
				yourself].
	detector methodBlock: 
			[:context :result |
			| hasBool hasSelf |
			hasBool := false.
			hasSelf := context parseTree lastIsReturn not.
			(matcher executeTree: context parseTree initialAnswer: Set new) do: 
					[:each |
					hasBool := hasBool or: 
									[(each isLiteralNode and: [#(true false) includes: each value])
										or: [each isMessage and: [#(#and: #or:) includes: each selector]]].
					hasSelf := hasSelf
								or: [each isSelfVariable or: [each isLiteralNode and: [(#(true false) includes: each value) not]]]].
			hasSelf & hasBool ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector!

sendsDifferentSuper
	| detector |
	detector := self new.
	detector name: 'Sends different super message'.
	detector methodBlock: 
			[:context :result | 
			| message |
			(message := context superMessages detect: [:each | each ~= context selector] ifNone: [nil]) 
				notNil 
					ifTrue: 
						[result addSearchString: message.
						result addClass: context selectedClass selector: context selector]].
	^detector!

sentNotImplemented
	| detector |
	detector := self new.
	detector name: 'Messages sent but not implemented'.
	detector methodBlock: 
			[:context :result | 
			| message |
			message := context messages detect: [:each | (context implements: each) not] ifNone: [nil].
			message isNil 
				ifTrue: 
					[message := context superMessages detect: 
									[:each | 
									context selectedClass superclass isNil 
										or: [(context selectedClass superclass canUnderstand: each) not]]
								ifNone: [nil].
					message isNil 
						ifTrue: 
							[message := context selfMessages 
										detect: [:each | (context selectedClass canUnderstand: each) not]
										ifNone: [nil]]].
			message notNil 
				ifTrue: 
					[result addSearchString: message.
					result addClass: context selectedClass selector: context selector]].
	^detector!

subclassOf: aClass overrides: aSelector 
	^aClass subclasses anySatisfy: 
			[:each | 
			(each includesSelector: aSelector) or: [self subclassOf: each overrides: aSelector]]!

subclassResponsibilityNotDefined
	| detector |
	detector := self new.
	detector name: 'Subclass responsibility not defined'.
	detector classBlock: 
			[:context :result |
			#rbFix.	"Prevent false positive matches against any method that happens to include the symbol #subclassResponsibility"
			(context selectedClass whichMethodsOnlySelfSend: #subclassResponsibility) do: 
					[:method |
					(context selectedClass withAllSubclasses anySatisfy: 
							[:class |
							class subclasses isEmpty
								and: [(class whichClassIncludesSelector: method selector) == context selectedClass]])
						ifTrue: [result addClass: context selectedClass selector: method selector]]].
	^detector!

superMessages
	#rbFix.	"Modified to Dolphin specific set of selectors that must be supersent"

	^#(#release #postCopy #setUp #onViewOpened #createComponents #createSchematicWiring #queryCommand: #validateUserInterface #onViewClosed #onViewDestroyed #publishedAspects #publishedAspectsOfInstances #publishedEvents #publishedEventsOfInstances)
!

superSends
	| detector |
	detector := self new.
	detector name: 'Missing super sends'.
	detector methodBlock: 
			[:context :result | 
			(context selectedClass isMeta not and: [self superMessages includes: context selector]) 
				ifTrue: 
					[(context selectedClass superclass notNil 
						and: [context selectedClass superclass canUnderstand: context selector]) 
							ifTrue: 
								[(context superMessages includes: context selector) 
									ifFalse: [result addClass: context selectedClass selector: context selector]]]].
	^detector!

tempsReadBeforeWritten
	| detector |
	detector := self new.
	detector name: 'Temporaries read before written'.
	detector methodBlock: 
			[:context :result | 
			(RBReadBeforeWrittenTester variablesReadBeforeWrittenIn: context parseTree) do: 
					[:each | 
					result addClass: context selectedClass selector: context selector.
					result addSearchString: each]].
	^detector!

tempsUnused
	"rbDMM - Waring"

	| detector |
	#rbFix	. "Added for Dolphin"
	detector := self new.
	detector name: 'Unused temporary variables'.
	detector methodBlock: 
			[:context :result | 
			(context parseTree allTemporaryVariables 
				allSatisfy: [:each | context parseTree references: each]) 
					ifFalse: [result addClass: context selectedClass selector: context selector]].
	^detector!

tempVarOverridesInstVar
	| detector matcher vars varName |
	detector := self new.
	detector name: 'Instance variable overridden by temporary variable'.
	matcher := (ParseTreeSearcher new)
				matchesArgument: '`xxxvar'
					do: [:aNode :answer | answer or: 
								[varName := aNode name.
								vars includes: varName]];
				yourself.
	detector methodBlock: 
			[:context :result | 
			vars := context instVarNames.
			(matcher executeTree: context parseTree initialAnswer: false) 
				ifTrue: 
					[result addClass: context selectedClass selector: context selector.
					result addSearchString: varName]].
	^detector!

undeclaredVariables
	"Private - Answer the Dictionary holding undeclared global variables."

	#rbFix.	"DMM: Dolphin does not support forward refs. to undeclared variables"
	^Dictionary new!

unreferencedVariables
	| detector |
	detector := self new.
	detector
		name: 'Unreferenced instance variables';
		resultClass: VariableEnvironment;
		openUsing: #openWithoutFilters.
	detector classBlock: 
			[:context :result | 
			| allSubclasses |
			allSubclasses := context selectedClass withAllSubclasses.
			#rbFix.	"Ignore inst vars with names that start with an underscore"
			(context selectedClass instVarNames reject: [:each | each first = $_]) do: 
					[:each | 
					allSubclasses detect: [:class | (class whichMethodsAccess: each) notEmpty]
						ifNone: [result addClass: context selectedClass instanceVariable: each]]].
	^detector!

usesTrue
	| detector trueBinding falseBinding trueClass falseClass |
	detector := self new.
	trueBinding := self environment bindingFor: #True.
	trueClass := trueBinding value.
	falseBinding := self environment bindingFor: #False.
	falseClass := falseBinding value.
	detector name: 'Uses True/False instead of true/false'.
	detector methodBlock: 
			[:context :result | 
			| method |
			method := context compiledMethod.
			((method refersToLiteral: trueClass) or: [method refersToLiteral: falseClass]) 
				ifTrue: 
					[result addClass: context selectedClass selector: context selector.
					result searchStrings: #('True' 'False')]].
	^detector!

utilityMethods
	| detector |
	detector := self new.
	detector name: 'Utility methods'.
	detector methodBlock: 
			[:context :result | 
			(context selectedClass isMeta | (context selector numArgs == 0) or: 
					[#rbFix.	"#protocols renamed to #lintProtocols"
					context lintProtocols 
						anySatisfy: [:each | self utilityProtocols anySatisfy: [:protocol | protocol match: each asString]]]) 
				ifFalse: 
					[(self subclassOf: context selectedClass overrides: context selector) 
						ifFalse: 
							[(context superMessages isEmpty and: [context selfMessages isEmpty]) 
								ifTrue: 
									[(context parseTree isPrimitive or: 
											[context selectedClass allInstVarNames , context selectedClass allClassVarNames asArray 
												, #('self') anySatisfy: [:each | context parseTree references: each]]) 
										ifFalse: [result addClass: context selectedClass selector: context selector]]]]].
	^detector!

utilityProtocols
	"If a method is defined in one of these protocols, then don't check if its a utility method."

	#rbFix. "SW: Added Dolphin's helpers category"

	^#('*utilit*' 'helpers')!

variableAssignedLiteral
	| detector |
	detector := self new.
	detector
		name: 'Variable is only assigned a single literal value';
		resultClass: VariableEnvironment;
		openUsing: #openWithoutFilters.
	detector classBlock: 
			[:context :result | 
			| allSubclasses |
			allSubclasses := context selectedClass withAllSubclasses.
			context selectedClass instVarNames do: 
					[:each | 
					| defClass selector |
					(allSubclasses inject: 0
						into: 
							[:sum :class | 
							| sels |
							sels := class whichSelectorsAssign: each.
							sels size == 1 
								ifTrue: 
									[selector := sels asArray first.
									defClass := class].
							sum + sels size]) 
							== 1 
							ifTrue: 
								[| tree searcher |
								searcher := ParseTreeSearcher new.
								searcher matches: each , ' := ``@object'
									do: [:aNode :answer | answer isNil and: [aNode value isLiteral]].
								tree := defClass parseTreeFor: selector.
								tree notNil 
									ifTrue: 
										[(searcher executeTree: tree initialAnswer: nil) == true 
											ifTrue: [result addClass: context selectedClass instanceVariable: each]]]]].
	^detector!

variableNotDefined
	| detector |
	#rbFix.	"Extract hard-coded ref. to Undeclared"
	detector := self new.
	detector name: 'Variable used, but not defined anywhere'.
	detector methodBlock: 
			[:context :result | 
			context compiledMethod withAllBlockMethodsDo: 
					[:each | 
					each literalsDo: 
							[:lit | 
							lit isVariableBinding 
								ifTrue: 
									[| binding |
									(((binding := context selectedClass bindingFor: lit key) notNil 
										and: [binding binding == lit binding]) or: 
												[((binding := context selectedClass environment bindingFor: lit key) notNil 
													and: [binding binding == lit binding]) or: 
															[(binding := self undeclaredVariables bindingFor: lit key) notNil 
																and: [binding binding == lit binding]]]) 
										ifFalse: 
											[result addClass: context selectedClass selector: context selector.
											result addSearchString: lit key]]]]].
	^detector!

variableReferencedOnce
	| detector |
	detector := self new.
	detector 
		name: 'Variable referenced in only one method and always assigned first'.
	detector classBlock: 
			[:context :result | 
			| allSubclasses |
			allSubclasses := context selectedClass withAllSubclasses.
			context selectedClass instVarNames do: 
					[:each | 
					| defClass selector |
					(allSubclasses inject: 0
						into: 
							[:sum :class | 
							| sels |
							sels := class whichSelectorsAccess: each.
							sels size == 1 
								ifTrue: 
									[selector := sels asArray first.
									defClass := class].
							sum + sels size]) 
							== 1 
							ifTrue: 
								[| tree |
								tree := defClass parseTreeFor: selector.
								tree notNil 
									ifTrue: 
										[(RBReadBeforeWrittenTester isVariable: each writtenBeforeReadIn: tree) 
											ifTrue: 
												[result addClass: defClass selector: selector.
												result addSearchString: each]]]]].
	^detector!

vernacularSelector
	| detector |
	detector := self new.
	detector name: 'Uses a vernacular selector'.
	detector methodBlock: 
			[:context :result | 
			(self vernacularSelectors includes: context selector) 
				ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector!

vernacularSelectors
	^#(#arse #fart)! !
!BlockLintRule class categoriesForMethods!
abstractClass!possible bugs!public! !
addRemoveDependents!possible bugs!public! !
badMessage!miscellaneous!public! !
badSelectors!constants!private! !
classInstVarNotInitialized!possible bugs!public! !
classNameInSelector!miscellaneous!public! !
classNotReferenced!public!unnecessary code! !
classShouldNotOverride!constants!private! !
collectionCopyEmpty!possible bugs!public! !
collectionMessagesToExternalObject!intention revealing!public! !
definesEqualNotHash!possible bugs!public! !
doesLiteralArrayContainComma:!helpers!private! !
equivalentSuperclassMethods!public!unnecessary code! !
fullBlocks!miscellaneous!public! !
implementedNotSent!public!unnecessary code! !
instVarInSubclasses!miscellaneous!public! !
justSendsSuper!public!unnecessary code! !
literalArrayContainsComma!possible bugs!public! !
longMethods!miscellaneous!public! !
longMethodSize!constants!private! !
metaclassShouldNotOverride!constants!private! !
missingSubclassResponsibility!intention revealing!public! !
onlyReadOrWritten!public!unnecessary code! !
overridesSpecialMessage!bugs!public! !
refersToClass!miscellaneous!public! !
returnsBooleanAndOther!possible bugs!public! !
sendsDifferentSuper!possible bugs!public! !
sentNotImplemented!bugs!public! !
subclassOf:overrides:!helpers!private! !
subclassResponsibilityNotDefined!bugs!public! !
superMessages!constants!private! !
superSends!possible bugs!public! !
tempsReadBeforeWritten!possible bugs!public! !
tempsUnused!public!unnecessary code! !
tempVarOverridesInstVar!possible bugs!public! !
undeclaredVariables!accessing!constants!private! !
unreferencedVariables!public!unnecessary code! !
usesTrue!possible bugs!public! !
utilityMethods!miscellaneous!public! !
utilityProtocols!constants!private! !
variableAssignedLiteral!miscellaneous!public! !
variableNotDefined!possible bugs!public! !
variableReferencedOnce!public!unnecessary code! !
vernacularSelector!intention revealing!public! !
vernacularSelectors!constants!private! !
!

