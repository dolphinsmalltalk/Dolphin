"Filed out from Dolphin Smalltalk 2000 release 5.00"!

ClassBrowserShell subclass: #RefactoringBrowserShell
	instanceVariableNames: 'navigator tools currentTool policyClass horizontal manager bufferMenu'
	classVariableNames: 'ErrorInRefactoring'
	poolDictionaries: ''
	classInstanceVariableNames: 'horizontal'!
RefactoringBrowserShell comment: ''!

RefactoringBrowserShell guid: (GUID fromString: '{349C7574-C30B-11D4-B802-0050047218A6}')!

!RefactoringBrowserShell categoriesForClass!Unclassified! !
!RefactoringBrowserShell methodsFor!

aboutRefactoringBrowser
	
	self class about!

abstractClassVar

	| refactoring classVar |

	classVar := self selectClassVar.
	classVar isNil
		ifTrue: [^self].

	self handleError: 
		[(AbstractClassVariableRefactoring
						variable: classVar
						class: self selectedClass) execute].!

abstractInstVar

	| refactoring instVar |

	instVar := self selectInstVar.
	instVar isNil
		ifTrue: [^nil]. 

	self handleError: 
		[(AbstractInstanceVariableRefactoring variable: instVar class: self selectedClass) execute].		



!

addClassVar

	|  newName  |

	newName := self getClassVarName: 'Add a Class Variable'. 
	(newName isNil )
		ifTrue: [^nil]. 

	self handleError: 
			[ (AddClassVariableRefactoring variable: newName class: self selectedClass ) execute.].
	self refreshTheClassesPresenter: self selectedClass name


!

addInstVar

	|  newName |

	newName := self getInstVarName: 'Add an Instance Variable'. 
	(newName isNil )
		ifTrue: [^nil]. 

	self handleError: 
			[(AddInstanceVariableRefactoring variable: newName class: self selectedClass) execute.].

	!

addParameter
	| refactoring initialAnswer aSelector newSelector initializer |
	aSelector := self method selector. 
	initialAnswer := aSelector numArgs == 0 
				ifTrue: [aSelector , ':']
				ifFalse: [aSelector].
	newSelector := Prompter 
				on: initialAnswer
				prompt: 'Enter new selector:'
				caption: 'Add parameter to method'.
	newSelector isEmpty ifTrue: [^nil].
	newSelector := newSelector asSymbol.
	initializer := Prompter 
				on: 'nil'
				prompt: 'Enter default value for parameter:'
				caption: 'Add parameter to method'.
	initializer isEmpty ifTrue: [^nil].
	
	self handleError: 
		[(AddParameterRefactoring
				addParameterToMethod: aSelector
				in: self selectedClass
				newSelector: newSelector
				initializer: initializer ) execute].!

beHorizontal
	horizontal := true!

beVertical
	horizontal := false!

browseDefinitions
	(MessageBox new)
		text: 'browseDefinitions';
		open
!

browseGlobals

	| searchString association refs compiledMethods both  |
	
	searchString := (Prompter 
		on: ''
		prompt: 'Enter a class or global'
		caption: 'References to a class or global').

	(searchString isNil or: [searchString isEmpty])
		ifTrue: [^self].

	searchString := searchString asSymbol.
	association := Smalltalk associationAt: searchString
			ifAbsent: [self findPoolAssociationFor: searchString].
	association isNil ifTrue: [^self].
	refs := self navigator browseReferencesTo: association.

	both := IdentityDictionary new.
	refs metaClassSelectors keysAndValuesDo: [:key :value | both at: key put: value].
	refs classSelectors keysAndValuesDo: [:key :value | both at: key put: value]. 
	compiledMethods := OrderedCollection new.
	both keysAndValuesDo: [:key :values | | class | 
		class := Smalltalk at: key.
		values do: [:each | compiledMethods addAll: (self model definitionsOf: each asSymbol inLocalHierarchyOf: class)]].

	self model	browseMethods: compiledMethods
		caption: 'References to ', searchString  asString
		findString: nil
		filter: nil.!

browseImplementors	

	| searchString |

	searchString := (Prompter 
		on: ''
		prompt: 'Enter a method name:'
		caption: 'Implementors matching').

	(searchString isNil or: [searchString isEmpty])
		ifTrue: [^self].
	Cursor wait showWhile: [ (model browseDefinitionsOf: searchString trimBlanks asSymbol) ].
!

browseInstVarReaders: aBoolean

	| instVar readers compiledMethods |

	instVar := self selectInstVarSupers: aBoolean subs: false.
	instVar isNil
		ifTrue: [^self].
	readers := (VariableEnvironment readersOfInstanceVariable: instVar in: self actualClass) instanceVariableReaders.
	compiledMethods := OrderedCollection new.
	readers keysAndValuesDo: [:key :values | | class | 
		class := Smalltalk at: key.
		values do: [:each | compiledMethods addAll: (self model definitionsOf: each asSymbol inLocalHierarchyOf: class)]].

	self model	browseMethods: compiledMethods
		caption: 'Readers of ', instVar  printString
		findString: nil
		filter: nil.!

browseInstVarWriters: aBoolean

	| instVar compiledMethods writers |

	instVar := self selectInstVarSupers: aBoolean subs: false.
	instVar isNil
		ifTrue: [^self]. 
	instVar := instVar, ':'.
	writers := (VariableEnvironment writersOfInstanceVariable: instVar in: self actualClass) instanceVariableWriters.
	compiledMethods := OrderedCollection new. 
	writers keysAndValuesDo: [:key :values | | class | 
		class := Smalltalk at: key.
		values do: [:each | compiledMethods addAll: (self model definitionsOf: each asSymbol inLocalHierarchyOf: class)]].

	self model	browseMethods: compiledMethods
		caption: 'Writers of ', instVar  printString
		findString: nil
		filter: nil.
!

browseStringMatches	

	self browseSource!

browseSymbols

	| searchString |
	
	searchString := (Prompter 
		on: ''
		prompt: 'Enter a symbol without the leading ''#'':'
		caption: 'References to a Symbol').

	(searchString isNil or: [searchString isEmpty])
		ifTrue: [^self]. 
	self model browseReferencesTo: searchString asSymbol!

browseVariables	
	
	|  searchString env both  |

	searchString := (Prompter 
		on: ''
		prompt: 'Enter a variable name'
		caption: 'Classes Defining Variable'). 
	(searchString isNil or: [searchString isEmpty])
		ifTrue: [^nil]. 

	env := SelectorEnvironment onEnvironment: self environment.
	self environment classesDo: 
		[:each | 
			(each instVarNames detect: [:name | searchString match: name] ifNone: [nil]) 
				notNil ifTrue: [env addClass: each].
			(each classVarNames detect: [:name | searchString match: name]
				ifNone: [nil]) notNil 
					ifTrue: 
					[env
						addClass: each;
						addClass: each class]].

	both := OrderedCollection new. 
	env classSelectors keysDo: [:key | both add: (Smalltalk at: key ifAbsent: [])].
	env metaClassSelectors keysDo: [:key | both add: (Smalltalk at: key ifAbsent: [])].
	both isEmpty ifTrue: [^MessageBox warning: 'No classes define variable ', searchString].
	 RBClassesDefiningShell show caption: 'Classes defining ',searchString; updateClasses: both.
!

categoriesPresenter

	^categoriesPresenter!

changePublicPrivate

	"rbDmmFix - works, but does not add to the refactoring change list so cannot be undone.
	swap the public and private categories. "

	| categories originalMethod publicCategory privateCategory originalCategory chosenCategory |

	originalMethod := self method.
	publicCategory := originalMethod methodClass methodCategoryClass public.
	privateCategory := originalMethod methodClass methodCategoryClass private.
	categories :=  self method categories.
	(categories includes:  publicCategory)
		ifTrue: [originalCategory := publicCategory. chosenCategory := privateCategory]
		ifFalse: [originalCategory := privateCategory. chosenCategory := publicCategory].

	chosenCategory addMethod: originalMethod.
	originalCategory removeMethod: originalMethod.
	originalMethod storeCategories

!

classesPresenter

	^classesPresenter!

classReferences

	self model browseLocalClassReferences: self selectedClass
	!

classVarRefs
	
	self model browseLocalClassVariables: self selectedClass
!

clearUndoRedoList

	manager  clearUndoRedoList!

codeModelClass
	^CodeModel!

convertToSibling

	| newParent subclasses refactoring originalSelection  |

	newParent := self getValidClassName: 'Convert to Sibling' prompt: 'Enter name for new parent class'.
	newParent isNil
		ifTrue: [^self].
	
	originalSelection := self selectedClass name.
	self handleError: 
		[(ChildrenToSiblingsRefactoring name:  newParent asSymbol
			class: self selectedClass
			subclasses: self selectedClass subclasses) execute]. 
	self refreshTheClassesPresenter: originalSelection
	!

createBuffer
	| newBuffer |

	newBuffer := self codeModelClass navigator: navigator.
	newBuffer lockPolicyClass: policyClass.
	tools add: newBuffer.
	self setTool: newBuffer.
	self currentTool tool updateContents.
	self createCommandMenuItem!

createClassVarAccessors

	| refactoring classVar |

	classVar := self selectClassVar.
	classVar isNil
		ifTrue: [^self].

	self handleError: 
		[(CreateAccessorsForVariableRefactoring
						variable: classVar
						class: self selectedClass
						classVariable: true ) execute].!

createCommandMenuItem

	| cmd |

	cmd := CommandDescription command: (Message selector: #restoreBrowser: argument: currentTool timeStamp).
	cmd description: currentTool timeStamp.
	bufferMenu addItem: (CommandMenuItem commandDescription: cmd).

!

createInstVarAccessors

	self generateAccessors!

createSubclass

	| subclass selectedClass refactoring  |

	subclass  := self getValidClassName:  'Create a subclass' prompt: 'Enter the new subclass name'.
	subclass  isNil 
		ifTrue: [^self].
	
	selectedClass := self selectedClass.
 	self handleError: 
			[(AddClassRefactoring
				addClass: subclass 
				superclass:  selectedClass name
				subclasses:  selectedClass subclasses
				category: #'Refactoring') execute.].	
	self refreshTheClassesPresenter: subclass

	!

currentCard: anObject
	
	"cards currentCard := anObject"!

currentTool

	^currentTool!

currentView

	"determine and return the currentView"

	| cardView sourceView definitionView commentView currentView |
	cardView := view viewNamed: 'cards'.
	sourceView := view viewNamed: 'source'.
	definitionView := view viewNamed: 'definition'.
	commentView := view viewNamed: 'comment'.
	cardView currentCard==sourceView ifTrue: [
		currentView := sourceView].
	cardView currentCard==definitionView ifTrue: [
		currentView := definitionView].
	cardView currentCard==commentView ifTrue: [
		currentView := commentView].
	^currentView

!

definitionPresenter

	^definitionPresenter!

environment

	^navigator environment!

environment: anEnvironment 
	| navigatorClass |

	manager := RefactoryChangeManager instance.
	navigatorClass := anEnvironment navigatorClass.
	navigator := navigatorClass forEnvironment: anEnvironment.
	tools do: [:each | each navigator: navigator].!

filterPresenter

	^filterPresenter!

findAllReferencePathsTo

	| paths block |

	block := self promptForReferencePathBlock.
	block isNil ifTrue: [^self].
	
	Cursor wait showWhile: [paths := self referenceFinderClass new findAllPaths: block.].
	paths isEmpty 
		ifTrue: [MessageBox warning: 'No paths found']
		ifFalse: [paths inspect]	
!

findAllReferencesToInstances

	| path |
		
	path := self referenceFinderClass findAllPathsToInstanceOf: self selectedClass. 
	path notNil 
		ifTrue: [path inspect]
		ifFalse: [MessageBox warning:  'No reference paths exist']!

findAssociationForClassVariable: classVar 
	| association definingClass name |

	definingClass := self actualClass.
	association := nil.
	
	[definingClass notNil and: 
			[name := definingClass classPool keys 
						detect: [:each | each asString = classVar asString]
						ifNone: [nil].
			association := definingClass classPool associationAt: name ifAbsent: [nil].
			association isNil]] 
			whileTrue: [definingClass := definingClass superclass].
	^association!

findPoolAssociationFor: aSymbol 
	| pools poolName |
	pools := OrderedCollection new.
	Smalltalk associationsDo: 
			[:assoc | 
			((assoc value isKindOf: Dictionary) 
				and: [assoc value includesKey: aSymbol]) ifTrue: [pools add: assoc key]].
	pools isEmpty 
		ifTrue: 
			[MessageBox warning: 'No variables named ', aSymbol, ' were found'.
			^nil].
	poolName := pools size = 1 
				ifTrue: [pools first]
				ifFalse: 
					[self 
						choose: 'The variable is defined in multiple pools.<n>Which reference do you want?' 
								expandMacros
						fromList: pools
						values: pools
						lines: 5
						cancel: [^nil]].
	^(Smalltalk at: poolName) associationAt: aSymbol
!

findReferencePathTo

	| paths block |

	block := self promptForReferencePathBlock.
	block isNil ifTrue: [^self].
	
	Cursor wait showWhile: [paths := self referenceFinderClass new findPath: block.].
	paths isEmpty 
		ifTrue: [MessageBox warning: 'No paths found']
		ifFalse: [paths inspect]!

findReferencePathToInstance

	| path |
		
	path := self referenceFinderClass findPathToInstanceOf: self selectedClass. 
	path notNil 
		ifTrue: [path inspect]
		ifFalse: [MessageBox warning:  'No reference path exists']!

forClasses: aCollection showVariableMenu: generatorBlock collect: valueBlock type: aString
	| variables ignore values index |
	index := 0.
	variables := OrderedCollection new.
	ignore := OrderedCollection new.
	values := OrderedCollection new.
	aCollection do: 
			[:each | 
			| varList |
			varList := generatorBlock value: each.
			varList isEmpty ifFalse: 
					[variables add: '    ' , each name.
					values add: nil.
					ignore add: variables size.
					index := variables size + 1.
					varList do: 
							[:var | 
							variables add: (valueBlock value: var).
							values add: var]]].
	^ChoicePrompter choices:  variables
		caption: 'Choose a ', aString, ' variable'.

	!

getBufferMenu

	bufferMenu := self view menuBar items detect: [:each | each text = 'Buffers'] 
		ifNone: [^MessageBox warning: 'getBufferMenu cannot find Buffers menu']. 
	self createCommandMenuItem.
!

getClassVarName: aString

	|  newName    |

	newName := (Prompter 
		on: ''
		prompt: 'Enter a class variable name'
		caption: aString). 
	(newName isNil or: [newName isEmpty])
		ifTrue: [^nil].  

	[ClassBuilder validateClassVars: (Array with: newName)
		againstSuperclass: self actualClass superclass]  on: Error, Warning  do: [:e | MessageBox errorMsg: e messageText. ^nil].

	^newName

!

getInstVarName: aString

	|  newName    |

	newName := (Prompter 
		on: ''
		prompt: 'Enter an instance variable name'
		caption: aString). 
	(newName isNil or: [newName isEmpty])
		ifTrue: [^nil]. 
	
	^newName.

	!

getValidClassName: aString prompt: anotherString
	|  newName    |

	newName := (Prompter 
		on: ''
		prompt: anotherString
		caption: aString). 
	(newName isNil or: [newName isEmpty])
		ifTrue: [^nil]. 

	(ClassBuilder  isValidClassName: newName) ifFalse:
		[MessageBox new
				confirm:  ('"', newName, '" is not a valid class name.'). ^nil].

	^newName asSymbol.
	!

globalClassReferences

	self browseClassReferences.
	!

globalClassVarRefs

	self browseClassVariables
!

globalInstVarReaders

	self browseInstVarReaders: true!

globalInstVarRefs

	self browseInstanceVariables!

globalInstVarWriters

	self browseInstVarWriters: true!

handleError: aBlock 

	^[self navigator showWaitCursorWhile: aBlock] on: self refactoringError do: 
			[:ex | 
			ex isResumable 
				ifTrue: 
					[(MessageBox confirm: (ex messageText last == $? 
								ifTrue: [ex messageText]
								ifFalse: [ex messageText , '\Do you want to proceed?' withCRs])) 
						ifTrue: [ex resume]]
				ifFalse: 
					[ex tag notNil 
						ifTrue: [(MessageBox confirm: ex messageText) ifTrue: [ex tag value]]
						ifFalse: [MessageBox warning: ex messageText]].
			ex return: nil]!

initializeOnEnvironment: anEnvironment 
	
	policyClass := StateLockPolicy. 
	tools := OrderedCollection new.
	self environment: anEnvironment.  
	self setTool: (self codeModelClass navigator: navigator).
	self currentTool lockPolicyClass: policyClass.
	tools add: self currentTool.
	horizontal := true!

inlineAllSelfSends 

	self handleError: 
		[(InlineAllSendersRefactoring sendersOf: self method selector
				in: self selectedClass  ) execute].	!

inspectAllInstances

	self selectedClass allInstances inspect!

instVarReaders

	self browseInstVarReaders: false
!

instVarRefs

	| instVar |

	instVar := self selectInstVarSupers: false subs: false. 
	instVar notNil
		ifTrue: [self model browseReferencesToInstVar: instVar inLocalHierarchyOf: self actualClass]!

instVarWriters

	self browseInstVarWriters: false.
!

methodBrowserPresenter

	^methodBrowserPresenter!

modePresenter

	^modePresenter!

moveMethods: methods toNewClass: newClass in: newApp 
	methods do: 
			[:each | 
			each methodClass == newClass ifFalse: 
					[(newClass copy: each selector
						from: each methodClass
						ifNewAddTo: newApp) isNil
						ifTrue: [self warn: ('<1p> was not moved.' expandMacrosWith: each)]
						ifFalse: [self managerInterface removeMethod: each]]]!

moveMethodToNewCategory
	"RbDmm this method is a copy of categorizeMethod with a removeMethod added
	probably should be refactored. Note that it cannot be undone."

	| originalMethod originalCategory chosenCategory categories |
	originalMethod := self method.
	originalCategory := self category. 
	originalCategory class == AllMethodsCategory 
		ifTrue: [^MessageBox warning: 'Please first select a category for the method other than ''All'''].
	categories := originalMethod methodClass methodCategoryClass allMethodCategories.
	chosenCategory := (CategoryPrompter
						on: originalCategory
						list: categories
						caption: 'Categorize ', originalMethod selector printString) showModal.

	(chosenCategory notNil and: [chosenCategory ~= originalCategory]) ifTrue: [
		chosenCategory addMethod: originalMethod.
		originalCategory removeMethod: originalMethod.
		originalMethod storeCategories].

!

moveMethodToNewClass
	"rbDmm - works, but does not add to the refactoring change list so cannot be undone."	

	|  newClass methods  newApp  selectedClass   |

	newClass  := self getValidClassName:  'Move method to a new class' prompt: 'Enter the name of the class to move to'.
	newClass  isNil 
		ifTrue: [^self]. 

	(Smalltalk at: newClass) addSelector: self method selector withMethod: self method.
	self actualClass removeSelector: self method selector ifAbsent: [].


"rbDmmFix? executing the code below does not work.
gets a subscript out of bounds in conditions check

self handleError: 
		[(MoveMethodRefactoring
						selector: self method selector 
						class: self selectedClass
						variable: self selectedClass name ) execute].
"
!

navigator

	^navigator!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	self updateCurrentTool.
	self getBufferMenu. 

!

policyClass: aLockPolicyClass
	policyClass := aLockPolicyClass.
	tools do: [:each | each lockPolicyClass: policyClass]!

promptForReferencePathBlock

	| source block |

	source := self request: 'Find what?'
				initialAnswer: '[:each | each == 10000]'.
	source isEmpty ifTrue: [^nil].
	block := Compiler evaluate: source.
	(block respondsTo: #value:) 
		ifFalse: 
			[MessageBox warning:  'Source did not evaluate to a block'.
			^nil].
	^block!

protectInstVar
	|  instVar |

	instVar := self selectInstVar.
	instVar isNil
		ifTrue: [^nil]. 

	self handleError: 
		[(ProtectInstanceVariableRefactoring variable: instVar class: self selectedClass ) execute].



!

protocolsPresenter

	^protocolsPresenter!

pullUpClassVar

	| refactoring classVar |

	classVar := self selectSubclassClassVar.
	classVar isNil
		ifTrue: [^nil]. 

	self handleError: 
		[(PullUpClassVariableRefactoring variable: classVar class: self selectedClass) execute.].
	self refreshTheClassesPresenter: self selectedClass name

!

pullUpInstVar

	| refactoring instVar |
	
	instVar := self selectSubclassInstVar.
	instVar isNil
		ifTrue: [^nil]. 

	self handleError: 
		[(PullUpInstanceVariableRefactoring variable: instVar class: self selectedClass) execute]. 



!

pullUpSelector 

	self handleError: 
		[(PushUpMethodRefactoring pushUp: (Array with: self method selector)
			from: self selectedClass ) execute].	!

pushDownClassVar

"rbDmmFix does not work 
 if there is no reference to the classVar in a subclass, the classVar is simply removed
 if there is a reference, it is detected, a warning issued, but it is still not pushed down.
does not work in VA either"

	| refactoring classVar |

	classVar := self selectClassVarSupers: false subs: false. 
	classVar isNil
		ifTrue: [^nil]. 

	refactoring := [(PushDownClassVariableRefactoring variable: classVar class: self selectedClass) execute].
	[self navigator showWaitCursorWhile: refactoring] on: self refactoringError do: 
			[:ex | 
				ex tag notNil 
						ifTrue: [(MessageBox confirm: ex messageText) 
							ifTrue: [ ^self model browseAClassVariable: classVar class: self selectedClass]]
						ifFalse: [^MessageBox warning: ex messageText]].
!

pushDownInstVar

	| refactoring instVar |

	instVar := self selectInstVarSupers: false subs: false.
	instVar isNil
		ifTrue: [^nil]. 

	refactoring := [(PushDownInstanceVariableRefactoring variable: instVar class: self selectedClass name) execute.].
  
	[self navigator showWaitCursorWhile: refactoring] on: self refactoringError do: 
			[:ex | 
				ex tag notNil 
						ifTrue: [(MessageBox confirm: ex messageText) 
							ifTrue: [^self model browseReferencesToInstVar: instVar inLocalHierarchyOf: self actualClass]]
						ifFalse: [^MessageBox warning: ex messageText]].
	self refreshTheClassesPresenter: self selectedClass name		


!

pushDownSelector 

	self handleError: 
		[(PushDownMethodRefactoring pushDown: (Array with: self method selector)
			from: self selectedClass ) execute].		

	!

pushUpSelector 

	self handleError: 
		[(PushUpMethodRefactoring pushUp: (Array with: self method selector)
			from: self selectedClass ) execute].	!

queryCommand: query
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."
	| selector methodCommands  |

	methodCommands := #( #moveMethodToNewCategory #moveMethodToNewClass #renameMethod #removeMethod #removeMethodSafe #pushUp #pushDown #changePublicPrivate #inlineAllSelfSends #addParameter).

	(super queryCommand: query) == true ifTrue: [^true].
	selector := query commandSymbol.

	selector == #renameClassAs ifTrue: [
		query enabled: self hasClassSelected.
		^true].

	selector  == #undoOperation
		ifTrue: [query enabled: ((manager hasUndoableOperations) 
					ifTrue: [ query text:  '&Undo ' , manager undoChange changes first name. true]
					ifFalse: [query text:  '&Undo ' . false	])].

	selector  == #redoOperation
		ifTrue: [query enabled: ((manager hasRedoableOperations)
					ifTrue: [ query text:  '&Redo ' , manager redoChange changes first name. true]
					ifFalse: [query text:  '&Redo ' . false	])].

	selector  == #restoreBrowser:
		ifTrue: [query enabled: true.
				(query commandDescription description = currentTool timeStamp) 
					ifTrue: [query beChecked. query text: self updateCurrentTool.]
					ifFalse: [query beUnchecked]].

	selector  == #removeBuffer
		ifTrue: [query enabled: (tools size > 1)].


	(methodCommands includes: selector) ifTrue: [ 
		query enabled: (self method notNil ). ^true].!

redoOperation
	
	Cursor wait showWhile: [manager redoOperation]

!

refactoringError

	^self class refactoringError
!

referenceFinderClass
	^ReferenceFinder!

refreshTheClassesPresenter: aSymbol

	classesPresenter view refreshContents.
	classesPresenter selection: (Smalltalk at: aSymbol).!

remove
	(MessageBox new)
		text: 'remove';
		open
!

removeBuffer
	
	| item items index menuBar |
	
	tools size < 2 ifTrue: [^self].

	bufferMenu := self view menuBar items detect: [:each | each text = 'Buffers'] 
		ifNone: [^MessageBox warning: 'getBufferMenu cannot find Buffers menu']. 
	items := bufferMenu items select: [:each | each class ~= DividerMenuItem].
	item := items detect: [:each | each description = currentTool timeStamp] ifNone: [nil].
	bufferMenu removeItem: item.
	
	tools remove: self currentTool. 
	self currentTool release.
	self setTool: tools first. 
	self restoreBrowserState: currentTool state.


!

removeBufferDQ
"rbDmm - remove soon"	
	| item items index menuBar |
	
	tools size < 2 ifTrue: [^self].

	bufferMenu := self view menuBar items detect: [:each | each text = 'Buffers'] 
		ifNone: [^MessageBox warning: 'getBufferMenu cannot find Buffers menu']. 
	menuBar := self view topShell menuBar.
	self view topShell menuBar: nil.
	menuBar free.
	items := bufferMenu items select: [:each | each class ~= DividerMenuItem].
	item := items detect: [:each | each description = currentTool timeStamp] ifNone: [nil].
	bufferMenu removeItem: item.
	self view topShell menuBar: menuBar.

	tools remove: self currentTool. 
	self currentTool release.
	self setTool: tools first. 
	self restoreBrowserState: currentTool state.



!

removeClass
"rbfix - is this any better/different than the remove that is already there?"
	|  classToRemove |

	(MessageBox confirm: 'Are you certain that you want to remove the selected class?') 
		ifFalse: [^false].

	classToRemove := Smalltalk at: self selectedClass name ifAbsent: [^self].
	(classToRemove subclasses isEmpty 
		or: [MessageBox confirm: classToRemove name , ' has subclasses. Remove anyway?']) 
			ifFalse: [^false].

	self handleError: 
		[(RemoveClassChange remove: classToRemove ) execute].	!

removeClassSafe

	| refactoring  |

	refactoring := RemoveClassRefactoring classNames: (Array with: self selectedClass name). 
	[refactoring execute] on: self refactoringError do: 
		[:ex | (MessageBox confirm: ex messageText) 
			ifTrue: [self browseClassReferences.]].


!

removeClassVar

	|  classVar |

	classVar := self selectClassVarSupers: false subs: false.
	classVar isNil
		ifTrue: [^nil]. 

	self actualClass withAllSubclasses do: [:subclass |
			(Array with: subclass with: subclass class) do:
				[:classOrMeta |
				(classOrMeta whichSelectorsReferTo: (self actualClass classPool associationAt: classVar))
					isEmpty
						ifFalse: [(MessageBox confirm: classVar
									, ' is still used in code of class '
									, classOrMeta name, '. Remove anyway?')
								ifFalse: [^false]]]].

	self handleError: 
		[ (RemoveClassVariableRefactoring variable: classVar class: self selectedClass) execute.].
	self refreshTheClassesPresenter: self selectedClass name!

removeInstVar

	|  instVar |

	instVar := self selectInstVarSupers: false subs: false.
	instVar isNil
		ifTrue: [^nil]. 

	self handleError: 
		[ (RemoveInstanceVariableRefactoring variable: instVar class: self selectedClass ) execute.].


!

removeMethodSafe

	self handleError: 
		[(RemoveMethodRefactoring removeMethods: (Array with: self method selector) 
		from: self selectedClass ) execute].	
!

renameClassAs
"is this any better/different than the rename that is already there? Yes, because it rewrites all referenciing
	methods to use the new class name."
	|  newName  selectedClass newClass |

	#todo "Replace the standard #renameClass command and use label editing instead of prompter".

	[newName := (Prompter 
		on: self selectedClass name
		prompt: 'Enter a class name'
		caption: 'Rename a class'). 
	(newName isNil or: [newName isEmpty])
		ifTrue: [^nil]. 

	ClassBuilder  isValidClassName: newName] whileFalse: [
		(MessageBox new
				confirm:  ('"', newName, '" is not a valid class name. Try again?'))
				ifTrue: []
				ifFalse: [^self]].

	newClass := newName asSymbol.
	self handleError: 
		[(RenameClassRefactoring rename: self selectedClass to: newClass ) execute].

	self refreshTheClassesPresenter: newClass!

renameClassVar
	| refactoring newName classVar |

	classVar := self selectClassVarSupers: false subs: false.
	classVar isNil
		ifTrue: [^self].

	newName := self getClassVarName: 'Rename an Class Variable'. 
	(newName isNil )
		ifTrue: [^nil]. 

	self handleError: 
		[(RenameClassVariableRefactoring rename: classVar
				to: newName asSymbol
				in: self actualClass name) execute]. 
	self refreshTheClassesPresenter: self selectedClass name.
	!

renameInstVar
	| refactoring newName instVar |

	instVar := self selectInstVarSupers: false subs: false.
	instVar isNil
		ifTrue: [^self].

	newName := self getInstVarName: 'Rename an Instance Variable'. 
	(newName isNil )
		ifTrue: [^nil]. 
	
	self handleError: 
			[(RenameInstanceVariableRefactoring rename: instVar
				to: newName
				in: self actualClass) execute.].
!

renameMethod
	
	| newSelector |
	
	newSelector := self renameMethod: self method selector in: self selectedClass.
	newSelector isNil 
		ifFalse: [self refreshTheClassesPresenter: self selectedClass name.]
	!

renameMethod: aSelector in: aClass 

	|  tree  args newArgs map methodName newName |
	tree := aClass parseTreeFor: aSelector.
	tree isNil 
		ifTrue: 
			[MessageBox warning:  'Could not parse the method'.
			^nil].

	args := OrderedCollection withAll: tree argumentNames.
	methodName := RBMethodName selector: aSelector arguments: args.
	methodName := (RenameInstVarDialog createOn: methodName) showModal.
	self halt.
	methodName isNil ifTrue: [^nil].
	newName := methodName selector.
	newArgs := methodName arguments asOrderedCollection.
	map := (1 to: args size) collect: [:i | args indexOf: (newArgs at: i)].
	
	self handleError: 
		[(RenameMethodRefactoring
				renameMethod: aSelector
				in: aClass
				to: newName
				permuation: map ) execute].
	^newName
	!

request: aString initialAnswer: anAnswerString 

	| answer |

	answer := Prompter 
		on: anAnswerString
		prompt: aString
		caption: ''.
	^answer isNil ifTrue: [''] ifFalse: [answer]!

restoreBrowser: aString 
	"Private - restore the browser state to what is in toolNumber"

	| selectedTool |

	selectedTool := tools detect: [:each | each timeStamp = aString] 
		ifNone: [^MessageBox warning: 'cannot find selected tool'].
	selectedTool timeStamp = currentTool timeStamp ifTrue: [^self].
	self setTool: selectedTool.
	currentTool := selectedTool.
	self restoreBrowserState: selectedTool state.!

restoreBrowserState: aDolphinNavigatorState
	"Private - restore the browser state "

	| richTextEdit method card |
	
	"try to reset the class first"
	[self classesPresenter selection: aDolphinNavigatorState selectedClass]
		on: Error do: [:e | ^classesPresenter view refreshContents.].

	"now set the class/instance mode"
	self modePresenter selection: aDolphinNavigatorState mode. 

	aDolphinNavigatorState filterPresenter notNil
		"filterPresenter is set to categories by default"
		ifTrue: [self categoriesPresenter view:  aDolphinNavigatorState filterPresenter currentCard].

	self variablesPresenter selection: aDolphinNavigatorState variables.
	self protocolsPresenter selection: aDolphinNavigatorState protocols.

	"handle the special case where 'All' categories are selected"
	aDolphinNavigatorState category class ~= AllMethodsCategory 
		ifTrue: [self categoriesPresenter selection: aDolphinNavigatorState category.]
		ifFalse: [categoriesPresenter expand: categoriesPresenter model title.
			categoriesPresenter selection: categoriesPresenter model title.].
	
	"set the right card"
	card := aDolphinNavigatorState currentView name.
	card = 'definition' ifTrue:
		[definitionPresenter ensureVisible].
	card = 'comment' ifTrue:
		[commentPresenter ensureVisible].
	card = 'source' ifTrue:
		[methodBrowserPresenter ensureVisible].

	[method := self methodBrowserPresenter findEquivalentMethod: aDolphinNavigatorState method.
	self methodBrowserPresenter method:  method]
		on: Error do: [:e | "rbDmmFix? is this needed?"].

	"get the text out of the saved definitionPresenter, and set it to cyan if different
	richTextEdit := self definitionPresenter view.
	richTextEdit ~= aDolphinNavigatorState currentView referee
		ifTrue: [richTextEdit forecolor: Color cyan. ].
	not sure when to do this ^^ so we will skip it for now	rbDmmFix?	"

!

rewrite	
	(MessageBox new)
		text: 'not yet implemented!!';
		open
"rbfix"
" openRewriter
	RewriteRuleEditor rewrite: ''"
!

selectClassVar

	^ChoicePrompter choices:  self actualClass classVarNames asOrderedCollection
		caption: 'Choose a class variable'.!

selectClassVarSupers: superBoolean subs: subBoolean 
	| classes |
	classes := OrderedCollection with: self selectedClass.
	superBoolean
		ifTrue: [classes addAllFirst: self nonMetaClass allSuperclasses reverse].
	subBoolean ifTrue: [classes addAllLast: self nonMetaClass allSubclasses].
	^self forClasses: classes
		showVariableMenu: [:class | class classPool keys asSortedCollection]
		collect: [:name | name]
		type: 'class'.!

selectInstVar

	^ChoicePrompter choices:  self actualClass instVarNames 
		caption: 'Choose an instance variable'.

	!

selectInstVarSupers: superBoolean subs: subBoolean
	| classes |
	classes := OrderedCollection with: self selectedClass.
	superBoolean ifTrue: [classes addAllFirst: self selectedClass allSuperclasses reverse].
	subBoolean ifTrue: [classes addAllLast: self selectedClass allSubclasses].
	^self
		forClasses: classes
		showVariableMenu: [:class | class instVarNames]
		collect: [:cname | cname]
		type: 'instance'!

selectSubclassClassVar
	| varNames |
	varNames := (self selectedClass allSubclasses inject: Set new
				into: 
					[:set :each | 
					set addAll: each classVarNames;
						yourself])
					asSortedCollection.
	varNames isEmpty ifTrue: [^nil].
	^ChoicePrompter choices:  varNames asOrderedCollection
		caption: 'Choose a class variable'.


	!

selectSubclassInstVar
	| varNames |
	varNames := (self selectedClass allSubclasses inject: Set new
				into: 
					[:set :each | 
					set addAll: each instVarNames;
						yourself])
					asSortedCollection.
	varNames isEmpty ifTrue: [^nil].
	^ChoicePrompter choices:  varNames
		caption: 'Choose a instance variable'.!

setTool: aTool 
	currentTool notNil ifTrue: [currentTool lock].
	currentTool := aTool.
	aTool unlock.
"rbDmm --------------------
	self buildCurrentTool.
not needed -----------------"
	aTool updateDisplay!

setUndoCount

	|  newSize oldSize   |
	
	oldSize := manager class undoSize printString.
	newSize := (Prompter 
		on: oldSize
		prompt: 'Enter undo stack size:'
		caption: 'Undo Size'). 
	newSize isNil ifTrue: [^self].
	newSize := newSize asNumber.

	newSize positive ifTrue: [manager class undoSize: newSize].

		
!

spawnBrowser

	RefactoringBrowserShell show: 'Default view'.!

undoOperation

	Cursor wait showWhile: [
		manager undoOperation]
!

updateCaption
	"Private - The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| newCaption |

	super updateCaption.
	newCaption := 'RB-', self caption.
	self caption: newCaption
!

updateCurrentTool
	"Private - the browser has change, so we need to update the  current tool"

	^currentTool updateTool: self.
	
!

variablesPresenter

	^variablesPresenter! !
!RefactoringBrowserShell categoriesFor: #aboutRefactoringBrowser!commands!public! !
!RefactoringBrowserShell categoriesFor: #abstractClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #abstractInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #addClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #addInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #addParameter!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #beHorizontal!commands!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #beVertical!commands!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #browseDefinitions!commands!public! !
!RefactoringBrowserShell categoriesFor: #browseGlobals!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #browseImplementors!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #browseInstVarReaders:!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #browseInstVarWriters:!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #browseStringMatches!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #browseSymbols!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #browseVariables!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #categoriesPresenter!accessing!public! !
!RefactoringBrowserShell categoriesFor: #changePublicPrivate!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #classesPresenter!accessing!public! !
!RefactoringBrowserShell categoriesFor: #classReferences!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #classVarRefs!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #clearUndoRedoList!commands!public! !
!RefactoringBrowserShell categoriesFor: #codeModelClass!*-unclassified!private! !
!RefactoringBrowserShell categoriesFor: #convertToSibling!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #createBuffer!commands!public! !
!RefactoringBrowserShell categoriesFor: #createClassVarAccessors!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #createCommandMenuItem!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #createInstVarAccessors!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #createSubclass!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #currentCard:!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #currentTool!accessing!public! !
!RefactoringBrowserShell categoriesFor: #currentView!accessing!public! !
!RefactoringBrowserShell categoriesFor: #definitionPresenter!accessing!public! !
!RefactoringBrowserShell categoriesFor: #environment!accessing!public! !
!RefactoringBrowserShell categoriesFor: #environment:!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #filterPresenter!accessing!public! !
!RefactoringBrowserShell categoriesFor: #findAllReferencePathsTo!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #findAllReferencesToInstances!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #findAssociationForClassVariable:!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #findPoolAssociationFor:!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #findReferencePathTo!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #findReferencePathToInstance!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #forClasses:showVariableMenu:collect:type:!*-unclassified!private! !
!RefactoringBrowserShell categoriesFor: #getBufferMenu!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #getClassVarName:!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #getInstVarName:!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #getValidClassName:prompt:!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #globalClassReferences!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #globalClassVarRefs!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #globalInstVarReaders!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #globalInstVarRefs!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #globalInstVarWriters!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #handleError:!*-unclassified!public! !
!RefactoringBrowserShell categoriesFor: #initializeOnEnvironment:!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #inlineAllSelfSends!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #inspectAllInstances!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #instVarReaders!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #instVarRefs!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #instVarWriters!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #methodBrowserPresenter!accessing!public! !
!RefactoringBrowserShell categoriesFor: #modePresenter!accessing!public! !
!RefactoringBrowserShell categoriesFor: #moveMethods:toNewClass:in:!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #moveMethodToNewCategory!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #moveMethodToNewClass!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #navigator!accessing!public! !
!RefactoringBrowserShell categoriesFor: #onViewOpened!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #policyClass:!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #promptForReferencePathBlock!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #protectInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #protocolsPresenter!accessing!public! !
!RefactoringBrowserShell categoriesFor: #pullUpClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #pullUpInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #pullUpSelector!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #pushDownClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #pushDownInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #pushDownSelector!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #pushUpSelector!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #queryCommand:!commands!public! !
!RefactoringBrowserShell categoriesFor: #redoOperation!commands!public! !
!RefactoringBrowserShell categoriesFor: #refactoringError!*-unclassified!private! !
!RefactoringBrowserShell categoriesFor: #referenceFinderClass!*-unclassified!public! !
!RefactoringBrowserShell categoriesFor: #refreshTheClassesPresenter:!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #remove!commands!public! !
!RefactoringBrowserShell categoriesFor: #removeBuffer!commands!public! !
!RefactoringBrowserShell categoriesFor: #removeBufferDQ!commands!public! !
!RefactoringBrowserShell categoriesFor: #removeClass!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #removeClassSafe!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #removeClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #removeInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #removeMethodSafe!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #renameClassAs!commands - class!public! !
!RefactoringBrowserShell categoriesFor: #renameClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #renameInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #renameMethod!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #renameMethod:in:!commands - method!private! !
!RefactoringBrowserShell categoriesFor: #request:initialAnswer:!commands!public! !
!RefactoringBrowserShell categoriesFor: #restoreBrowser:!event handling!public! !
!RefactoringBrowserShell categoriesFor: #restoreBrowserState:!event handling!public! !
!RefactoringBrowserShell categoriesFor: #rewrite!commands - browse!public! !
!RefactoringBrowserShell categoriesFor: #selectClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #selectClassVarSupers:subs:!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #selectInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #selectInstVarSupers:subs:!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #selectSubclassClassVar!commands - class variables!public! !
!RefactoringBrowserShell categoriesFor: #selectSubclassInstVar!commands - instance variables!public! !
!RefactoringBrowserShell categoriesFor: #setTool:!initialize/release!public! !
!RefactoringBrowserShell categoriesFor: #setUndoCount!commands!public! !
!RefactoringBrowserShell categoriesFor: #spawnBrowser!commands!public! !
!RefactoringBrowserShell categoriesFor: #undoOperation!commands!public! !
!RefactoringBrowserShell categoriesFor: #updateCaption!*-unclassified!private! !
!RefactoringBrowserShell categoriesFor: #updateCurrentTool!event handling!private! !
!RefactoringBrowserShell categoriesFor: #variablesPresenter!accessing!public! !

!RefactoringBrowserShell class methodsFor!

about
	
	MessageBox new
		caption: 'About Refactoring Browser';
		icon: self icon;
		text: '                   The Refactoring Browser

was originally developed in VisualWorks by Don Roberts and 
John  Brant.  The Dolphin port was done by Andy Bower and
Blair McGlashan at Camp Smalltalk San Diego in March 2000 
with guidance from Don and John.  Gui by Donald MacQueen.  

This software is in the public domain. It is provided ''as is'', with
no warranty, express or implied, etc. See the Refactoring
Browser page on the Dolphin wiki at www.Object-arts.com.';
		open
		
!

beHorizontal
	"self beHorizontal"

	horizontal := true
!

beVertical
	"self beVertical"

	horizontal := false
!

create: aResourceNameString
	"override method in Shell"

	| newOne |

	newOne := self  openOnEnvironment: BrowserEnvironment new.
	newOne view: (self loadViewResource: aResourceNameString inContext: View desktop).
	^newOne
!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Refactoring Browser'!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"
	super initialize.
	SmalltalkSystem current addAdditionalToolsFolderIcon: self toolsFolderIcon.
	ErrorInRefactoring := Refactoring preconditionSignal
!

isVertical
	horizontal isNil ifTrue: [self beHorizontal].
	^horizontal not
!

onEnvironment: anEnvironment 

	| browser |
	browser := self new. 
	browser initializeOnEnvironment: anEnvironment.
	horizontal
		ifTrue: [browser beHorizontal]
		ifFalse: [browser beVertical].
	browser policyClass: StateLockPolicy. 
	^browser
!

openOnEnvironment: anEnvironment
	^self openOnEnvironment: anEnvironment vertical: self isVertical
!

openOnEnvironment: anEnvironment vertical: aBoolean 

	| browser |
	anEnvironment isEmpty ifTrue: [^MessageBox warning:  'Nobody'].
	browser := self onEnvironment: anEnvironment.
	aBoolean ifTrue: [browser beVertical] ifFalse: [browser beHorizontal].
	^browser
!

refactoringError

	^ErrorInRefactoring!

samplesFolderIcon
	"Private - Answer an instance of SmalltalkSystemIcon suitable for representing the
	receiver in the system folder."

	^SmalltalkSystemIcon show: self description: self displayString!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."
	
	Smalltalk developmentSystem removeSystemFolderIcon: self samplesFolderIcon.
! !
!RefactoringBrowserShell class categoriesFor: #about!enquiries!private! !
!RefactoringBrowserShell class categoriesFor: #beHorizontal!initialize/release!private! !
!RefactoringBrowserShell class categoriesFor: #beVertical!initialize/release!private! !
!RefactoringBrowserShell class categoriesFor: #create:!initialize/release!private! !
!RefactoringBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!RefactoringBrowserShell class categoriesFor: #initialize!initialize/release!private! !
!RefactoringBrowserShell class categoriesFor: #isVertical!initialize/release!private! !
!RefactoringBrowserShell class categoriesFor: #onEnvironment:!initialize/release!public! !
!RefactoringBrowserShell class categoriesFor: #openOnEnvironment:!initialize/release!private! !
!RefactoringBrowserShell class categoriesFor: #openOnEnvironment:vertical:!initialize/release!public! !
!RefactoringBrowserShell class categoriesFor: #refactoringError!accessing!private! !
!RefactoringBrowserShell class categoriesFor: #samplesFolderIcon!accessing!private! !
!RefactoringBrowserShell class categoriesFor: #uninitialize!initialize/release!private! !

