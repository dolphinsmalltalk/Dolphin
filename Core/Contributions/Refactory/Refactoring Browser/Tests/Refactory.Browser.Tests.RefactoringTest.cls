"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.RefactoringTest'
	instanceVariableNames: 'manager model'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RefactoringTest guid: (Core.GUID fromString: '{bab50ae8-d54a-4645-9a41-ea07018cedf6}')!
Refactory.Browser.Tests.RefactoringTest isNonInstantiable: true!
Refactory.Browser.Tests.RefactoringTest comment: ''!
!Refactory.Browser.Tests.RefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RefactoringTest methodsFor!

abstractVariableTestData
	| testModel |
	(testModel := Refactory.Browser.RBModel
				onEnvironment: ((Refactory.Browser.ClassEnvironment
						onEnvironment: Refactory.Browser.BrowserEnvironment new)
							classes: (#(#{Smalltalk.Bar} #{Smalltalk.Foo}) inject: OrderedCollection new
									into: 
										[:sum :each |
										| class |
										class := each valueOrNil.
										class notNil
											ifTrue: 
												[sum
													add: class;
													add: class class].
										sum]))
							not)
			name: 'Test'.
	#('Core.Object subclass: #Foo
	instanceVariableNames: ''instVarName1 instVarName2 ''
	classVariableNames: ''ClassVarName1 ClassVarName2 ''
	poolDictionaries: ''''
	category: ''Testing''' 'Foo subclass: #Bar
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Testing''')
		do: [:each | testModel defineClass: each].
	#(#(#Bar #(#('instVarName1
	^1242321' #tests) #('foo
	instVarName1 := instVarName1 + instVarName2 + ClassVarName1' #tests))) #(#Foo #(#('foo
	^instVarName2 := 3' #tests) #('bar
	"Add one to instVarName1"

	instVarName1 := instVarName1 + 1' #tests) #('classVarName1
	^ClassVarName1' #tests) #('instVarName1: anObject
	^anObject' #tests) #('asdf
	^self classVarName1: (ClassVarName1 := ClassVarName1 + 1)' #tests) #('instVarName2
	^instVarName2' #tests) #('instVarName2: anObject
	instVarName2 := anObject' #tests) #('classVarName1: anObject
	^ClassVarName1 := anObject' #tests))) #('Bar class' #(#('classVarName2: anObject
	ClassVarName2 := anObject' #tests) #('classVarName2
	^ClassVarName2' #tests))) #('Foo class' #(#('foo
	^ClassVarName1 := ClassVarName1 * ClassVarName1 * ClassVarName1' #tests))))
		do: 
			[:each |
			| class |
			class := testModel classNamed: each first.
			each last do: [:meth | class compile: meth first classified: meth last]].
	^testModel!

childrenToSiblingTestData
	| testModel |
	(testModel := Refactory.Browser.RBModel
				onEnvironment: ((Refactory.Browser.ClassEnvironment
						onEnvironment: Refactory.Browser.BrowserEnvironment new)
							classes: (#(#ConcreteSubclass #ConcreteSuperclass #NoMoveSubclass) inject: OrderedCollection new
									into: 
										[:sum :each |
										| class |
										class := Refactory.Browser.Tests at: each ifAbsent: [nil].
										class notNil ifTrue: [sum add: class].
										sum])
										, (#(#ConcreteSubclass #ConcreteSuperclass #NoMoveSubclass) inject: OrderedCollection new
												into: 
													[:sum :each |
													| class |
													class := Refactory.Browser.Tests at: each ifAbsent: [nil].
													class notNil ifTrue: [sum add: class class].
													sum]))
							not)
			name: 'Test'.
	#('Core.Object subclass: #''Refactory.Browser.Tests.ConcreteSuperclass''
instanceVariableNames: ''instVarName1 instVarName2 ''
classVariableNames: ''ClassVarName1 ClassVarName2 ''
poolDictionaries: ''''
category: ''Testing''' 'Refactory.Browser.Tests.ConcreteSuperclass subclass: #''Refactory.Browser.Tests.NoMoveSubclass''
instanceVariableNames: ''''
classVariableNames: ''''
poolDictionaries: ''''
category: ''Testing''' 'Refactory.Browser.Tests.ConcreteSuperclass subclass: #''Refactory.Browser.Tests.ConcreteSubclass''
instanceVariableNames: ''''
classVariableNames: ''''
poolDictionaries: ''''
category: ''Testing''')
		do: [:each | testModel defineClass: each].
	(testModel metaclassNamed: #'Refactory.Browser.Tests.ConcreteSuperclass')
		addInstanceVariable: 'classInstVarName1'.
	#(#(#ConcreteSubclass #(#('initialize
super initialize.
instVarName1 := nil' #everyone) #('different
^0' #everyone))) #(#ConcreteSuperclass #(#('same
^self initialize isKindOf: ConcreteSuperclass' #'one def') #('different
^instVarName1 + instVarName2' #everyone) #('initialize
instVarName1 := instVarName2 := ClassVarName1 := ClassVarName2 := 0' #everyone))) #(#NoMoveSubclass #(#('same
^123' #'one def') #('qualifiedRef
^self initialize isKindOf: Refactory.Browser.Tests.ConcreteSuperclass "Hello"' #'one def'))) #('ConcreteSubclass class' #(#('bar
^self storeString' #testing))) #('ConcreteSuperclass class' #(#('foo
^classInstVarName1 + ClassVarName1 + ClassVarName2' #testing) #('new
^super new initialize' #testing) #('bar
^self printString' #testing))) #('NoMoveSubclass class' #()))
		do: 
			[:each |
			| class |
			class := testModel classNamed: 'Refactory.Browser.Tests.' , each first.
			each last do: [:meth | class compile: meth first classified: meth last]].
	^testModel!

inlineMethodTestData
	| testModel |
	(testModel := Refactory.Browser.RBModel
				onEnvironment: ((Refactory.Browser.ClassEnvironment
						onEnvironment: Refactory.Browser.BrowserEnvironment new)
							classes: (#(#{RenameClassVariableChange} #{VariableCompositeRefactoryChange} #{RenameInstanceVariableChange} #{CompositeRefactoryChange} #{RenameVariableChange} #{RefactoryChange})
									inject: OrderedCollection new
									into: 
										[:sum :each |
										| class |
										class := each valueOrNil.
										class notNil ifTrue: [sum add: class].
										sum])
										, (#() inject: OrderedCollection new
												into: 
													[:sum :each |
													| class |
													class := each valueOrNil.
													class notNil ifTrue: [sum add: class class].
													sum]))
							not)
			name: 'Test'.
	#('Object subclass: #RefactoryChange
	instanceVariableNames: ''name ''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Refactory-Support''' 'RefactoryChange subclass: #CompositeRefactoryChange
	instanceVariableNames: ''changes ''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Refactory-Support''' 'CompositeRefactoryChange subclass: #VariableCompositeRefactoryChange
	instanceVariableNames: ''className isMeta ''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Refactory-Support''' 'VariableCompositeRefactoryChange subclass: #RenameVariableChange
	instanceVariableNames: ''oldName newName ''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Refactory-Support''' 'RenameVariableChange subclass: #RenameClassVariableChange
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Refactory-Support''' 'RenameVariableChange subclass: #RenameInstanceVariableChange
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Refactory-Support''')
		do: [:each | testModel defineClass: each].
	#(#(#RenameClassVariableChange #(#('removeOldVariable
	(RemoveClassVariableChange remove: oldName from: self changeClass) execute' #private) #('addNewVariable
	(AddClassVariableChange add: newName to: self changeClass) execute' #private) #('executeNotifying: aBlock 
	| undo |
	self addNewVariable.
	self copyOldValuesToNewVariable.
	undo := super executeNotifying: aBlock.
	self removeOldVariable.
	^undo' #private) #('copyOldValuesToNewVariable
	| oldValue |
	oldValue := self changeClass classPool at: oldName ifAbsent: [].
	self changeClass at: newName asSymbol put: oldValue' #private))) #(#VariableCompositeRefactoryChange #(#('displayClassName
	^isMeta 
		ifTrue: [self changeClassName , '' class'']
		ifFalse: [self changeClassName asString]' #printing) #('isMeta
	^isMeta' #private) #('changeClass: aBehavior 
	isMeta := aBehavior isMeta.
	className := isMeta 
				ifTrue: [aBehavior soleInstance name]
				ifFalse: [aBehavior name]' #accessing) #('hash
	^self changeClassName hash' #comparing) #('changeClassName: aSymbol 
	className := aSymbol.
	isMeta isNil ifTrue: [isMeta := false]' #accessing) #('changeClass
	| class |
	class := Smalltalk at: self changeClassName ifAbsent: [^nil].
	^isMeta ifTrue: [class class] ifFalse: [class]' #accessing) #('printOn: aStream
	aStream nextPutAll: self displayString' #printing) #('changeClassName
	^className' #accessing) #('= aRefactoryClassChange 
	self class = aRefactoryClassChange class ifFalse: [^false].
	^className = aRefactoryClassChange changeClassName 
		and: [isMeta = aRefactoryClassChange isMeta]' #comparing))) #(#RenameInstanceVariableChange #(#('removeOldVariable
	(RemoveInstanceVariableChange remove: oldName from: self changeClass) 
		execute' #private) #('addNewVariable
	(AddInstanceVariableChange add: newName to: self changeClass) execute' #private) #('executeNotifying: aBlock 
	| undo |
	self addNewVariable.
	self copyOldValuesToNewVariable.
	undo := super executeNotifying: aBlock.
	self removeOldVariable.
	^undo' #private) #('copyOldValuesToNewVariable
	| newIndex oldIndex |
	oldIndex := self changeClass allInstVarNames indexOf: oldName asString.
	newIndex := self changeClass allInstVarNames indexOf: newName asString.
	self changeClass withAllSubclasses do: 
			[:each | 
			each allInstances 
				do: [:inst | each instVarAt: newIndex put: (each instVarAt: oldIndex)]]' #private))) #(#CompositeRefactoryChange #(#('compile: source in: class 
	^self addChange: (AddMethodChange compile: source in: class)' #'refactory-changes') #('addClassVariable: variableName to: aClass 
	^self addChange: (AddClassVariableChange add: variableName to: aClass)' #'refactory-changes') #('addChangeFirst: aRefactoryChange 
	changes addFirst: aRefactoryChange.
	^aRefactoryChange' #accessing) #('removeChange: aChange 
	changes remove: aChange ifAbsent: []' #'private-inspector accessing') #('addPool: aPoolVariable to: aClass 
	^self addChange: (AddPoolVariableChange add: aPoolVariable to: aClass)' #'refactory-changes') #('initialize
	super initialize.
	changes := OrderedCollection new' #'initialize-release') #('defineClass: aString 
	^self addChange: (AddClassChange definition: aString)' #'refactory-changes') #('changeForClass: aRBClass selector: aSelector 
	changes reverseDo: 
			[:each | 
			| change |
			change := each changeForClass: aRBClass selector: aSelector.
			change notNil ifTrue: [^change]].
	^nil' #accessing) #('removeInstanceVariable: variableName from: aClass 
	^self 
		addChange: (RemoveInstanceVariableChange remove: variableName from: aClass)' #'refactory-changes') #('printOn: aStream 
	aStream nextPutAll: name' #printing) #('inspect
	RefactoryBuilderInspector openOn: self' #'user interface') #('flattenOnto: aCollection 
	changes do: [:each | each flattenOnto: aCollection]' #private) #('hash
	^changes size' #comparing) #('= aRefactoryBuilder 
	self class = aRefactoryBuilder class ifFalse: [^false].
	changes size = aRefactoryBuilder changes size ifFalse: [^false].
	changes with: aRefactoryBuilder changes
		do: [:each :change | each = change ifFalse: [^false]].
	^true' #comparing) #('renameClass: class to: newName 
	^self addChange: (RenameClassChange rename: class name to: newName)' #'refactory-changes') #('renameChangesForClass: aClassName to: newClassName 
	^(self copy)
		changes: (self changes 
					collect: [:each | each renameChangesForClass: aClassName to: newClassName]);
		yourself' #accessing) #('postCopy
	super postCopy.
	changes := changes collect: [:each | each copy]' #copying) #('changes: aCollection 
	changes := aCollection' #'private-inspector accessing') #('addInstanceVariable: variableName to: aClass 
	^self addChange: (AddInstanceVariableChange add: variableName to: aClass)' #'refactory-changes') #('compile: source in: class classified: aProtocol 
	^self addChange: (AddMethodChange 
				compile: source
				in: class
				classified: aProtocol)' #'refactory-changes') #('changeForMetaclass: aSymbol selector: aSelector 
	changes reverseDo: 
			[:each | 
			| change |
			change := each changeForMetaclass: aSymbol selector: aSelector.
			change notNil ifTrue: [^change]].
	^nil' #accessing) #('removeClassVariable: variableName from: aClass 
	^self 
		addChange: (RemoveClassVariableChange remove: variableName from: aClass)' #'refactory-changes') #('executeNotifying: aBlock 
	| undos undo |
	undos := changes collect: [:each | each executeNotifying: aBlock].
	undo := self copy.
	undo changes: undos reverse.
	^undo' #private) #('changes
	^changes' #'private-inspector accessing') #('removeMethod: aSelector from: aClass 
	^self addChange: (RemoveMethodChange remove: aSelector from: aClass)' #'refactory-changes') #('removeClass: aClass 
	^self addChange: (RemoveClassChange removeClassName: aClass)' #'refactory-changes') #('addChange: aRefactoryChange 
	changes add: aRefactoryChange.
	^aRefactoryChange' #accessing) #('changesSize
	^changes inject: 0 into: [:sum :each | sum + each changesSize]' #accessing) #('displayString
	^super displayString asText allBold' #printing) #('problemCount
	^self changesSize' #accessing))) #(#RenameVariableChange #(#('oldName: aString
	oldName := aString' #private) #('executeNotifying: aBlock 
	| undo |
	undo := super executeNotifying: aBlock.
	undo
		oldName: newName;
		newName: oldName.
	^undo' #private) #('newName: aString 
	newName := aString' #private) #('changeString
	^''Rename '' , oldName , '' to '' , newName' #printing))) #(#RefactoryChange #(#('flattenedChanges
	| changes |
	changes := OrderedCollection new.
	self flattenOnto: changes.
	^changes' #private) #('name: aString
	name := aString' #'initialize-release') #('initialize' #'initialize-release') #('changeForMetaclass: aSymbol selector: aSelector 
	^nil' #accessing) #('changeString
	^self class name' #printing) #('changeForClass: aRBClass selector: aSelector 
	^nil' #accessing) #('executeWithMessage: aString 
	| tally controller model done |
	model := 0 asValue.
	done := 0.
	tally := self changesSize.
	controller := aString isNil 
				ifTrue: [nil]
				ifFalse: [ProgressWidgetView progressOpenOn: model label: aString].
	model value: 0.
	^
	[self executeNotifying: 
			[done := done + 1.
			model value: done asFloat / tally]] 
			ensure: [controller notNil ifTrue: [controller closeAndUnschedule]]' #'performing-changes') #('executeNotifying: aBlock 
	self subclassResponsibility' #private) #('changes
	^Array with: self' #accessing) #('execute
	^self executeNotifying: []' #'performing-changes') #('inspect
	^((CompositeRefactoryChange new)
		changes: (Array with: self);
		yourself) inspect' #'user interface') #('flattenOnto: aCollection 
	aCollection add: self' #private) #('name
	^name isNil ifTrue: [self changeString] ifFalse: [name]' #accessing) #('changesSize
	^1' #accessing) #('displayString
	^name isNil ifTrue: [self changeString] ifFalse: [name]' #printing) #('renameChangesForClass: aClassName to: newClassName 
	"We''re in the middle of performing a rename operation. If we stored 
	the class name, we need to change the class name to the new 
	name to perform the compiles."

	self subclassResponsibility' #accessing))))
		do: 
			[:each |
			| class |
			class := testModel classNamed: each first.
			each last do: [:meth | class compile: meth first classified: meth last]].
	^testModel!

setUp
	| assoc |
	super setUp.
	assoc := RefactoringManager localBindingFor: 'Instance'.
	manager := assoc value.
	assoc value: nil.
	model := RBModel new!

setupImplementorToInlineFor: aRefactoring toReturn: anObject
	aRefactoring setOption: #implementorToInline toUse: [anObject]!

setupInlineExpressionFor: aRefactoring toReturn: aBoolean
	aRefactoring setOption: #inlineExpression toUse: [aBoolean]!

setupMethodNameFor: aRefactoring toReturn: aSelector
	aRefactoring setOption: #methodName
		toUse: 
			[:ref :aMethodName |
			aMethodName
				selector: aSelector;
				yourself]!

setupMethodNameFor: aRefactoring toReturn: aSelector withArguments: stringCollection
	aRefactoring setOption: #methodName
		toUse: 
			[:ref :aMethodName |
			aMethodName
				selector: aSelector;
				arguments: stringCollection;
				yourself]!

setupSelfArgumentNameFor: aRefactoring toReturn: aString 
	aRefactoring setOption: #selfArgumentName toUse: [aString]!

setupVariableToMoveToFor: aRefactoring toReturn: aString 
	aRefactoring setOption: #selectVariableToMoveTo toUse: [aString]!

setupVariableTypesFor: aRefactoring toReturn: anObject
	aRefactoring setOption: #variableTypes toUse: [anObject]!

shouldAbort: refactoring
	self assert: ([self executeRefactoring: refactoring. false] on: Refactoring abortSignal do: [:ex | true]) description: 'Refactoring failed to abort'!

shouldFail: aRefactoring existingVariable: aString
	self shouldFail: aRefactoring withMessage: '<1s> is an existing class or static variable' << aString!

shouldFail: aRefactoring withMessage: aString
	| exception |
	exception := 
			[self executeRefactoring: aRefactoring.
			nil] on: RefactoringError do: [:ex | ex].
	self assertNotNil: exception.
	self assert: (aString match: exception messageText)!

tearDown
	super tearDown.
	RefactoringManager instance release.
	(RefactoringManager classPool associationAt: #Instance
		ifAbsent: [RefactoringManager classPool associationAt: 'Instance']) value: manager.
	manager := model := nil!

verifyMethod: aSymbol of: aClass equals: aString
	| parseTree modelClass method |
	modelClass := aClass classInModel: model.
	method := modelClass methodFor: aSymbol.
	self assertNotNil: method.
	parseTree := method boundParseTree.
	self assert: parseTree equals: (self parseMethod: aString in: modelClass)! !
!Refactory.Browser.Tests.RefactoringTest categoriesForMethods!
abstractVariableTestData!constants!private! !
childrenToSiblingTestData!constants!private! !
inlineMethodTestData!constants!private! !
setUp!public!set up! !
setupImplementorToInlineFor:toReturn:!public!set up! !
setupInlineExpressionFor:toReturn:!public!set up! !
setupMethodNameFor:toReturn:!public!set up! !
setupMethodNameFor:toReturn:withArguments:!public!set up! !
setupSelfArgumentNameFor:toReturn:!public!set up! !
setupVariableToMoveToFor:toReturn:!public!set up! !
setupVariableTypesFor:toReturn:!public!set up! !
shouldAbort:!helpers!private! !
shouldFail:existingVariable:!helpers!private! !
shouldFail:withMessage:!helpers!private! !
tearDown!public!set up! !
verifyMethod:of:equals:!helpers!private! !
!

