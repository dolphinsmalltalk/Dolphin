"Filed out from Dolphin Smalltalk 7"!

SmalllintPlugin subclass: #CodeMentorPlugin
	instanceVariableNames: 'failuresPresenter infoSitePresenter infoBrowserPresenter progressPresenter checkerProcess rulesTreeModel isRefreshPending refreshMode'
	classVariableNames: 'DefaultRefreshMode LintIconMap LintRulesDoc'
	poolDictionaries: 'SHDocVwConstants'
	classInstanceVariableNames: ''!
CodeMentorPlugin guid: (GUID fromString: '{b1e97c3c-3c35-43e0-99aa-97d69135e2ea}')!
CodeMentorPlugin comment: 'CodeMentorPlugin is a <classBrowserPlugin> that tests the quality of code currently seen by a browser using Refactory Inc''s SmallLint package.  Since the time taken to perform the SmallLint analysis can be lengthy, the evaluation is performed in a background thread.

Instance Variables:
	failuresPresenter		<treePresenter> showing the hierarchy of failed rules
	infoSitePresenter		<compositePresenter> site to install the infoBrowserPresenter (below)
	infoBrowserPresenter	<URLPresenter> used to display the failure descriptions
	progressPresenter		<NumberPresenter> displaying the progress of the background checker process.
	checkerProcess		<Process> running the SmallLint analysis in the background
	rulesTreeModel		<VirtualTreeModel> holding the tree of SmallLint rules to analyse
	lintRulesDoc		<IXMLDOMDocument> for looking up the SmallLint rule descriptions
	isRefreshPending		<boolean> indicating whether the current content is up to date.
	refreshMode		<ValueModel> on a <Symbol>, the name of the current refresh/update mode.

Class Variables:
	LintRulesDoc		<IXMLDOMDocument>. XML DOM of document containing rule descriptions, etc
	LintIconMap		<LookupTable> mapping rules to their icon representations.
	DefaultRefreshMode	<Symbol>. The name of the default refresh/update mode.

'!
!CodeMentorPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!CodeMentorPlugin methodsFor!

addFailedRule: aLintRule
	| parentRule |
	parentRule := self parentRuleOf: aLintRule.
	(parentRule isNil or: [failuresPresenter model includes: parentRule]) 
		ifFalse: [failuresPresenter model add: parentRule asChildOf: nil].
	failuresPresenter model add: aLintRule asChildOf: parentRule!

allRules
	^self rulesTreeModel roots first!

applyTransform: transformationSelector 
	self runTransformation: (TransformationRule perform: transformationSelector asSymbol)!

autoRefresh
	isRefreshPending := true.
	self refreshIcon.
	self resetProgressBar.
	self refreshMode == #manual ifTrue: [^self].
	self stopCheckerProcess.
	(self isCurrentCard or: [self refreshMode == #continuous]) ifTrue: [self refresh]!

browseAllFailedMethods
	"Private - Browser the failure list of the selected rule"

	self lintRuleFailuresBrowserClass show lintRule: self failedRule.
!

browseFailedClass: aString 
	"Private - Browser the class identified by aString"

	(self class environment at: aString asSymbol ifAbsent: []) ifNotNil: 
			[:failedClass | 
			(Smalltalk developmentSystem browseClass: failedClass) caption: self failedRule name]!

browseFailedMethodName: aString 
	"Private - Browser the method identified by aString"

	(CompiledMethod fromString: aString) 
		ifNotNil: 
			[:failedMethod | 
			| env |
			env := BrowserEnvironment new forMethods: (Array with: failedMethod).
			env
				label: aString;
				filter: (self methodFilterForRule: self failedRule inEnvironment: self browserEnvironment).
			self browseFailedMethods: env]!

browseFailedMethods: aBrowserEnvironment 
	| failuresBrowser failedRule |
	failedRule := self failedRule.
	failuresBrowser := self lintRuleFailuresBrowserClass show.
	failuresBrowser
		lintRule: failedRule;
		methods: aBrowserEnvironment!

clearFailures
	failuresPresenter model clear.
	self status: nil.
	self resetProgressBar!

clearIgnoredRules
	"Clear Smalllint rules filters used by the receiver to ignore rule failures"

	(MessageBox 
		confirm: 'Are you sure you wish to clear all of the ignored rules for this image?'
		caption: 'Code Mentor') ifFalse: [^self].
	self class resetFilters.
	self autoRefresh!

createComponents
	"Create the presenters contained by the receiver"

	| refreshModes |
	super createComponents.
	failuresPresenter := self add: TreePresenter new name: 'failures'.
	infoSitePresenter := self add: Presenter new name: 'infoSite'.
	progressPresenter := self add: NumberPresenter new name: 'progress'.
	refreshModes := self class refreshModes.
	refreshMode := self class defaultRefreshMode.
	self add: ((ChoicePresenter new)
				model: (ValueConverter subject: ((self aspectValue: #refreshMode)
									aspectTriggers: #refreshModeChanged;
									yourself)
							typeConverter: (MappingConverter rightToLeft: refreshModes));
				choices: refreshModes keys asSortedCollection;
				yourself)
		name: 'refreshMode'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self model)
		when: #methodSelected
			send: #onBrowserEnvironmentSelected
			to: self;
		when: #classSelected
			send: #onBrowserEnvironmentSelected
			to: self.
	(self systemModel)
		when: #classUpdated:
			send: #onClassUpdated:
			to: self;
		when: #methodAdded:
			send: #onMethodUpdated:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #lintRuleFilterChanged:
			send: #onLintRuleFilterChanged:
			to: self.
	failuresPresenter 
		when: #selectionChanged
		send: #onFailureSelected
		to: self!

defaultHelpId
	^10750!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Code Mentor'!

exportIgnoredRules
	"Export the Smalllint rules filters used by the receiver to ignore rule failures"

	self class exportFilters!

failedClassesFor: aLintRule 
	"Private - Answer a collection of classes that failed aLintRule"

	| failedClasses |
	failedClasses := Set new: 64.
	aLintRule isComposite 
		ifFalse: 
			[aLintRule result isClassEnvironment 
				ifTrue: [aLintRule result classesDo: [:eachClass | failedClasses add: eachClass instanceClass]]].
	^failedClasses asSortedCollection!

failedRule
	^failuresPresenter selectionOrNil!

filteredRuleNames
	"Private - Answer the <Set> of LintRules names that are filtered out for the current browser environment"

	^(BasicLintRule filterDictionary 
		select: [:each | (self browserEnvironment & each) notEmpty]) keys!

filteredRules
	"Answer the <Set> of LintRules that are filtered out for the current browser environment"

	| filteredRuleNames |
	filteredRuleNames := self filteredRuleNames.
	^self allRules allRules select: [:each | filteredRuleNames includes: each name]!

filterInRules: rules 
	"Private - Removed filters for all the supplied rules"

	rules do: 
			[:eachRule | 
			| environment filter |
			filter := BasicLintRule filterFor: eachRule name.
			environment := self browserEnvironment & filter.
			environment classesAndSelectorsDo: 
					[:eachClass :eachSelector | 
					| method |
					method := eachClass compiledMethodAt: eachSelector.
					self systemModel removeFilteredMethod: method forLintRule: eachRule]]!

filterOutRule
	"Add the current method to the filters for the current failed rule(s) so that it won't be classed as a failure next time around"

	self filterOutRules: self failedRule failedRules.
!

filterOutRules: rules 
	"Private - Add filters for the supplied rules"

	rules do: 
			[:eachRule | 
			| methods |
			methods := eachRule failedMethods.
			methods do: [:each | self systemModel addFilteredMethod: each forLintRule: eachRule]]!

htmlDescriptionFor: aLintRule 
	"Private - Answers the failures description for aLintRule as HTML"

	"#2139"

	| xpath name stream |
	aLintRule isNil ifTrue: [^''].
	stream := String writeStream.
	stream nextPutAll: self htmlStyle.
	aLintRule isComposite 
		ifFalse: 
			[stream
				nextPutAll: '<A href="';
				nextPutAll: self smalltalkUrlTag;
				nextPutAll: 'self%20';
				display: #browseAllFailedMethods;
				nextPutAll: '">'].
	stream
		nextPutAll: '<H4>';
				nextPutAll: aLintRule name;
		nextPutAll: '</H4>'.
	aLintRule isComposite ifFalse: [stream nextPutAll: '</A>'].
	stream nextPutAll: '<P>'.
			self printTransformationRuleHtmlFor: aLintRule on: stream.
	name := aLintRule name copyReplaceAll: '"' with: '\"'.
	xpath := './/LintRule[name="<1s>"]/description' expandMacrosWith: name.
	(self class lintRulesDoc selectSingleNode: xpath) 
		ifNotNil: [:ruleNode | stream nextPutAll: ruleNode innerXML].
	stream nextPutAll: '</P><P>'.
			self printClassFailuresHtmlFor: aLintRule on: stream.
			stream nextPutAll: '</P><P>'.
			self printMethodFailuresHtmlFor: aLintRule on: stream.
	stream nextPutAll: '</P>'.
	^stream contents!

htmlStyle
	^'<font size="2" face="Arial">'!

icon
	isRefreshPending ifTrue: [^self class sleepIcon].
	^self isBusy 
		ifTrue: [Icon fromFile: 'Wait.ico']
		ifFalse: 
			[| failedRule |
			failedRule := failuresPresenter model asArray detect: [:each | each problemCount > 0]
						ifNone: [].
			failedRule notNil 
				ifTrue: 
					[Processor sleep: 100.
					self class lintIconOfRule: failedRule]
				ifFalse: [self class lintPassIcon]]!

importIgnoredRules
	"Import the Smalllint rules filters used by the receiver to ignore rule failures"

	self class importFilters.
	self refreshResults!

indicateFailures: failedRules 
	failedRules do: [:each | self addFailedRule: each].
	failuresPresenter
		expandAll: nil;
		selection: failuresPresenter model roots first.
!

indicateStatus
	self status: (self filteredRules notEmpty 
				ifTrue: ['Some code mentor issues have been explicitly ignored']
				ifFalse: [nil])!

indicateSuccess
	failuresPresenter model addRoot: self class lintPassRule.
	failuresPresenter
		expandAll: nil;
		selection: failuresPresenter model roots first.
!

infoBrowser
	^self infoBrowserPresenter view controlDispatch!

infoBrowserPresenter
	"Private - Answer an HTML browser than can be used to display LintRule descriptions. We create this lazily
	to avoid slowing down the opening of browsers that make use of the Code Mentor"

	infoBrowserPresenter isNil 
		ifTrue: 
			[infoBrowserPresenter := URLPresenter createIn: infoSitePresenter.
			[self infoBrowser readyState == READYSTATE_COMPLETE] 
				whileFalse: [SessionManager inputState pumpMessages].
			"Suppress the standard IE context menu"
			infoBrowserPresenter view allowContextMenu: false.
			infoBrowserPresenter 
				when: #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:
				send: #onBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:
				to: self].
	^infoBrowserPresenter!

initialize
	"Private - Initialize the receiver"

	super initialize.
	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self.
	isRefreshPending := false.
	self refreshIcon!

isBusy
	^checkerProcess notNil!

isFilterActive
	"Private - Answer true if one or more rule failures are omitted due to active filters"

	^self filteredRules notEmpty!

lintRuleFailuresBrowserClass
	^LintRuleFailuresBrowserShell!

lintRules
	"Private - Answer the roots of the rules hieerarchy to use for checking"

	^CompositeLintRule lintChecks!

onBeforeNavigate2: anIDispatch URL: urlVARIANT Flags: flagsVARIANT TargetFrameName: targetVARIANT PostData: postDataVARIANT Headers: headersVARIANT Cancel: aBooleanValue 
	| url |
	url := urlVARIANT value.
	(url beginsWith: self smalltalkUrlTag) 
		ifTrue: 
			[| expression |
			expression := (url allButFirst: self smalltalkUrlTag size) unescapePercents.
			Compiler 
				evaluate: expression
				for: self
				evaluationPools: nil
				logged: false].
	aBooleanValue value: true!

onBrowserEnvironmentSelected
	"Event handler for a method or class being selected within the receiver's associated browser. "

	self clearFailures.
	self autoRefresh!

onClassUpdated: aClass 
	(self browserEnvironment includesClass: aClass) ifTrue: [self autoRefresh]!

onFailureSelected
	self isCurrentCard ifTrue: [self showDescriptionFor: self failedRule]!

onGetCursor: aSymbol 
	"The named area of the view associated with the receiver has been hit.
	If the checker process is running, then display the 'processing but not
	disabled' cursor (i.e. the app starting cursor)."

	^self isBusy ifTrue: [Cursor appStarting] ifFalse: [super onGetCursor: aSymbol]!

onLintRuleFilterChanged: aLintRule
	self refreshResults!

onMethodUpdated: aCompilationResult 
	(self browserEnvironment includesMethod: aCompilationResult method) 
		ifTrue: [self autoRefresh]!

onShownInBrowser
	"Event handler indicating that the receiver has been displayed within it's browser. "

	super onShownInBrowser.
	isRefreshPending ifTrue: [self autoRefresh] ifFalse: [self onFailureSelected]!

onStartup
	"Private - Ensure that the receiver is reset after an image start"

	SessionManager inputState queueDeferredAction: [self onStartup2]!

onStartup2
	"Private - Ensure that the receiver is reset after an image start"

	self isOpen ifFalse: [^self].
	infoBrowserPresenter notNil 
		ifTrue: 
			[infoSitePresenter remove: infoBrowserPresenter.
			infoBrowserPresenter := nil].
	self onFailureSelected!

onViewClosed
	"Sent by the receiver's view when it has been closed.
	Disconnect from any events triggered by the devlopment system"

	super onViewClosed.
	self systemModel removeEventsTriggeredFor: self
!

onViewDestroyed
	self stopCheckerProcess.
	^super onViewDestroyed!

parentRuleOf: rule 
	"Helper method to enable the rules treeModel to locate a parent node"

	self rulesTreeModel 
		preOrderDo: [:each | (each isComposite and: [each rules includes: rule]) ifTrue: [^each]].

	"Virtual tree no longer checks roots for us"
	(self rulesTreeModel roots includes: rule) 
		ifFalse: [self error: 'Should have found parent'].
	^nil!

printClassFailuresHtmlFor: aLintRule on: aStream 
	| failuresList |
	failuresList := self failedClassesFor: aLintRule.
	failuresList isEmpty ifTrue: [^self].
	aStream nextPutAll: '<P>Please review the following classes:</P>'.
	aStream
		nextPutAll: '<BLOCKQUOTE><I>';
		cr.
	failuresList do: 
			[:each | 
			aStream
				nextPutAll: '<a href="';
				nextPutAll: self smalltalkUrlTag;
				nextPutAll: 'self%20';
				display: #browseFailedClass:;
				nextPutAll: '%20';
				print: each printString;
				nextPutAll: '">';
				print: each;
				nextPutAll: '</a><BR>';
				cr].
	aStream
		nextPutAll: '</BLOCKQUOTE></I>';
		cr!

printMethodFailuresHtmlFor: aLintRule on: aStream 
	| failuresList |
	failuresList := aLintRule failedMethodsSorted.
	failuresList isEmpty ifTrue: [^self].
	aStream nextPutAll: '<P>Please review the following methods:</P>'.
	aStream
		nextPutAll: '<BLOCKQUOTE><I>';
		cr.
	failuresList do: 
			[:each | 
			aStream
				nextPutAll: '<a href="';
				nextPutAll: self smalltalkUrlTag;
				nextPutAll: 'self%20';
				display: #browseFailedMethodName:;
				nextPutAll: '%20';
				print: each displayString;
				nextPutAll: '">';
				display: each;
				nextPutAll: '</a><BR>';
				cr].
	aStream
		nextPutAll: '</BLOCKQUOTE></I>';
		cr.
	aStream
		nextPutAll: '<p>Click <a href="';
		nextPutAll: self smalltalkUrlTag;
		nextPutAll: 'self%20';
		display: #browseAllFailedMethods;
		nextPutAll: '">here</a> to browse all.</p>'!

printTransformationRuleHtmlFor: aLintRule on: aStream 
	| name xpath node |
	name := aLintRule name copyReplaceAll: '"' with: '\"'.
	xpath := './/LintRule[name="<1s>"]/<2s>' expandMacrosWith: name with: 'transformationRuleSelector'.
	node := CodeMentorPlugin lintRulesDoc selectSingleNode: xpath.
	node isNil ifTrue: [^self].
	aStream
		nextPutAll: '<p><i>There is an <a href="';
		nextPutAll: self smalltalkUrlTag;
		nextPutAll: 'self%20';
		display: #applyTransform:;
		display: '%20';
		print: node innerXML;
		nextPutAll: '"> automatic transformation</a> available to address this issue.</i></p>'!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#filterOutRule == selector 
		ifTrue: 
			[| failedRule text |
			failedRule := self failedRule.
			text := (failedRule notNil and: [failedRule problemCount > 1]) 
						ifTrue: ['Ignore these <1d> rule failures' expandMacrosWith: failedRule problemCount]
						ifFalse: ['Ignore this rule failure'].
			aCommandQuery
				isEnabled: (failedRule notNil and: [failedRule notEmpty]);
				text: text.
			^true].
	#selectIgnoredRules == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self isFilterActive.
			^true].
	#refresh == selector 
		ifTrue: 
			[aCommandQuery isEnabled: (isRefreshPending or: [self refreshMode == #manual]).
			^true].
	^super queryCommand: aCommandQuery!

refresh
	"Refresh the receiver's display after first re-running the checks"

	self clearFailures.
	self startCheckerProcess.
	isRefreshPending := false.
	self refreshIcon!

refreshIcon
	self view arrangement: self!

refreshMode
	^refreshMode!

refreshMode: aSymbol 
	refreshMode == aSymbol ifTrue: [^self].
	refreshMode := aSymbol.
	self invalidateUserInterface.
	self trigger: #refreshModeChanged!

refreshResults
	"Refresh the receiver's display without re-running the checks"

	failuresPresenter view invalidate.
	self
		onFailureSelected;
		refreshIcon;
		indicateStatus!

resetProgressBar
	progressPresenter value: 0!

rulesTreeModel
	"Private - Answer a TreeModel that provides a <treeModel> interface on LintRules"

	rulesTreeModel isNil 
		ifTrue: 
			[rulesTreeModel := VirtualTreeModel withRoots: (Array with: self lintRules).
			rulesTreeModel
				hasChildrenBlock: [:each | each isComposite];
				getChildrenBlock: 
						[:each | 
						each isComposite 
							ifTrue: [each rules reject: [:r | r hasConflicts]]
							ifFalse: [OrderedCollection new]];
				getParentBlock: [:each | self parentRuleOf: each]].
	^rulesTreeModel!

runLintChecks
	| environment allRules |
	environment := self browserEnvironment.
	allRules := self allRules.
	environment notNil 
		ifTrue: 
			[| checker numberSelectors checkedSoFar |
			numberSelectors := environment numberSelectors.
			checkedSoFar := 0.
			progressPresenter value: 0.
			checker := SmalllintChecker newWithCachingContext.
			checker
				rule: allRules;
				environment: environment;
				methodBlock: 
						[checkedSoFar := checkedSoFar + 1.
						progressPresenter value: checkedSoFar / numberSelectors * 100];
				run].
	
	[| failedRules |
	failedRules := allRules failedRules.
	failedRules isEmpty ifTrue: [self indicateSuccess] ifFalse: [self indicateFailures: failedRules].
	self indicateStatus.
	self refreshIcon.
	self class report: failedRules for: self browserEnvironment] 
			postToMessageQueue!

selectFilteredRules
	| filteredRules originalFilteredRules addFilters removeFilters |
	originalFilteredRules := self filteredRules.
	filteredRules := ChoicePrompter 
				on: originalFilteredRules
				multipleChoices: ((self filteredRules , self allRules failedRules) asSet 
						asSortedCollection: [:x :y | x name <= y name])
				caption: 'Select Rules to Ignore'.
	filteredRules isNil ifTrue: [^self].
	addFilters := filteredRules difference: originalFilteredRules.
	removeFilters := originalFilteredRules difference: filteredRules.
	addFilters notEmpty ifTrue: [self filterOutRules: addFilters].
	removeFilters isEmpty ifTrue: [^self].
	self filterInRules: removeFilters.
	self autoRefresh!

showDescriptionFor: aLintRule
	self infoBrowser document body setProperty: 'InnerHTML' value: (self htmlDescriptionFor: aLintRule)!

smalltalkUrlTag
	^'smalltalk:'!

startCheckerProcess
	self stopCheckerProcess.
	checkerProcess := 
			[self
				refreshIcon;
				runLintChecks.
			checkerProcess := nil] 
					forkAt: Processor userBackgroundPriority!

stopCheckerProcess
	self isBusy ifFalse: [^self].
	checkerProcess terminate.
	checkerProcess := nil! !
!CodeMentorPlugin categoriesFor: #addFailedRule:!helpers!private! !
!CodeMentorPlugin categoriesFor: #allRules!operations!private! !
!CodeMentorPlugin categoriesFor: #applyTransform:!helpers!private! !
!CodeMentorPlugin categoriesFor: #autoRefresh!operations!private! !
!CodeMentorPlugin categoriesFor: #browseAllFailedMethods!commands!private! !
!CodeMentorPlugin categoriesFor: #browseFailedClass:!commands!private! !
!CodeMentorPlugin categoriesFor: #browseFailedMethodName:!commands!private! !
!CodeMentorPlugin categoriesFor: #browseFailedMethods:!commands!private! !
!CodeMentorPlugin categoriesFor: #clearFailures!operations!private! !
!CodeMentorPlugin categoriesFor: #clearIgnoredRules!commands!public! !
!CodeMentorPlugin categoriesFor: #createComponents!initializing!public! !
!CodeMentorPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!CodeMentorPlugin categoriesFor: #defaultHelpId!constants!public! !
!CodeMentorPlugin categoriesFor: #displayOn:!displaying!public! !
!CodeMentorPlugin categoriesFor: #exportIgnoredRules!commands!public! !
!CodeMentorPlugin categoriesFor: #failedClassesFor:!accessing!private! !
!CodeMentorPlugin categoriesFor: #failedRule!commands!private! !
!CodeMentorPlugin categoriesFor: #filteredRuleNames!accessing!private! !
!CodeMentorPlugin categoriesFor: #filteredRules!accessing!public! !
!CodeMentorPlugin categoriesFor: #filterInRules:!commands!private! !
!CodeMentorPlugin categoriesFor: #filterOutRule!commands!public! !
!CodeMentorPlugin categoriesFor: #filterOutRules:!commands!private! !
!CodeMentorPlugin categoriesFor: #htmlDescriptionFor:!helpers!private! !
!CodeMentorPlugin categoriesFor: #htmlStyle!helpers!private! !
!CodeMentorPlugin categoriesFor: #icon!accessing!public! !
!CodeMentorPlugin categoriesFor: #importIgnoredRules!commands!public! !
!CodeMentorPlugin categoriesFor: #indicateFailures:!operations!private! !
!CodeMentorPlugin categoriesFor: #indicateStatus!operations!private! !
!CodeMentorPlugin categoriesFor: #indicateSuccess!operations!private! !
!CodeMentorPlugin categoriesFor: #infoBrowser!accessing!private! !
!CodeMentorPlugin categoriesFor: #infoBrowserPresenter!accessing!private! !
!CodeMentorPlugin categoriesFor: #initialize!initializing!private! !
!CodeMentorPlugin categoriesFor: #isBusy!accessing!public! !
!CodeMentorPlugin categoriesFor: #isFilterActive!commands!private! !
!CodeMentorPlugin categoriesFor: #lintRuleFailuresBrowserClass!constants!private! !
!CodeMentorPlugin categoriesFor: #lintRules!accessing!private! !
!CodeMentorPlugin categoriesFor: #onBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:!event handling!private! !
!CodeMentorPlugin categoriesFor: #onBrowserEnvironmentSelected!event handling!private! !
!CodeMentorPlugin categoriesFor: #onClassUpdated:!event handling!public! !
!CodeMentorPlugin categoriesFor: #onFailureSelected!event handling!private! !
!CodeMentorPlugin categoriesFor: #onGetCursor:!event handling!public! !
!CodeMentorPlugin categoriesFor: #onLintRuleFilterChanged:!event handling!public! !
!CodeMentorPlugin categoriesFor: #onMethodUpdated:!event handling!public! !
!CodeMentorPlugin categoriesFor: #onShownInBrowser!event handling!public! !
!CodeMentorPlugin categoriesFor: #onStartup!event handling!private! !
!CodeMentorPlugin categoriesFor: #onStartup2!event handling!private! !
!CodeMentorPlugin categoriesFor: #onViewClosed!event handling!public! !
!CodeMentorPlugin categoriesFor: #onViewDestroyed!event handling!public! !
!CodeMentorPlugin categoriesFor: #parentRuleOf:!helpers!private! !
!CodeMentorPlugin categoriesFor: #printClassFailuresHtmlFor:on:!helpers!printing!private! !
!CodeMentorPlugin categoriesFor: #printMethodFailuresHtmlFor:on:!helpers!printing!private! !
!CodeMentorPlugin categoriesFor: #printTransformationRuleHtmlFor:on:!helpers!printing!private! !
!CodeMentorPlugin categoriesFor: #queryCommand:!commands!private! !
!CodeMentorPlugin categoriesFor: #refresh!commands!public! !
!CodeMentorPlugin categoriesFor: #refreshIcon!operations!private! !
!CodeMentorPlugin categoriesFor: #refreshMode!accessing!public! !
!CodeMentorPlugin categoriesFor: #refreshMode:!accessing!public! !
!CodeMentorPlugin categoriesFor: #refreshResults!commands!public! !
!CodeMentorPlugin categoriesFor: #resetProgressBar!operations!private! !
!CodeMentorPlugin categoriesFor: #rulesTreeModel!accessing!private! !
!CodeMentorPlugin categoriesFor: #runLintChecks!operations!public! !
!CodeMentorPlugin categoriesFor: #selectFilteredRules!commands!public! !
!CodeMentorPlugin categoriesFor: #showDescriptionFor:!operations!private! !
!CodeMentorPlugin categoriesFor: #smalltalkUrlTag!constants!private! !
!CodeMentorPlugin categoriesFor: #startCheckerProcess!operations!private! !
!CodeMentorPlugin categoriesFor: #stopCheckerProcess!operations!private! !

!CodeMentorPlugin class methodsFor!

defaultFilterFilename
	"Private - Answer a default filename for the receiver's ignored rules"

	^File default: SessionManager current imagePath extension: self defaultFilterFileType!

defaultFilterFileType
	"Private - Answer the extension for the receiver's ignored rules file"

	^'cmf'!

defaultRefreshMode
	"Answers true if instances of the receiver default to autochecking mode"

	^DefaultRefreshMode!

defaultRefreshMode: aBoolean 
	"Sets autochecking mode for instances of the receiver to aBoolean"

	DefaultRefreshMode := aBoolean!

exportFilters
	| filename stream |
	filename := (FileSaveDialog on: self defaultFilterFilename)
				fileTypes: self filterFileTypes;
				defaultExtension: self defaultFilterFileType;
				caption: 'Export ignored rules';
				showModal.
	filename isNil ifTrue: [^self].
	stream := FileStream write: filename text: true.
	BasicLintRule storeFiltersOn: stream.
	stream close!

filterFileTypes
	"Private - Answer an <Array> of two element Arrays suitable for adding to a FileDialog
	with the fileTypes: message to display filter files."

	^#(('Code Mentor Filter Files (*.cmf)' '*.cmf'))
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

importFilters
	| filename |
	filename := (FileOpenDialog on: self defaultFilterFilename)
				fileTypes: self filterFileTypes;
				defaultExtension: self defaultFilterFileType;
				caption: 'Import ignored rules';
				showModal.
	filename notNil ifTrue: [SourceManager default fileIn: filename]!

initialize
	"Private - Initialize the receiver by installing it as a plugin for all class browsers
		self initialize
	"

	DefaultRefreshMode := #whenVisible!

lintErrorIcon
	^Icon fromFile: 'LintError.ico'!

lintIconMap
	"Private - Answers a <LookupTable> mapping lint protocol names to icons

	LintIconMap := nil
	"

	LintIconMap isNil 
		ifTrue: 
			[LintIconMap := (LookupTable new)
						at: 'bugs' put: self lintErrorIcon;
						at: 'possible bugs' put: self lintErrorIcon;
						at: 'unnecessary code' put: self lintWarningIcon;
						at: 'intention revealing' put: self lintWarningIcon;
						at: 'miscellaneous' put: self lintInfoIcon;
						at: 'all checks passed' put: self lintPassIcon;
						shrink;
						isImmutable: true;
						yourself].
	^LintIconMap!

lintIconOfRule: aLintRule
	^self lintIconMap at: aLintRule name asLowercase ifAbsent: [false icon]
!

lintInfoIcon
	^Icon fromFile: 'LintInfo.ico'!

lintPassIcon
	^Icon fromFile: 'LintPass.ico'!

lintPassRule
	"Answer a <LintRule> that we can use to indicate no failures"

	^BasicLintRule new name: 'All checks passed'; yourself
!

lintRules
	^CompositeLintRule lintChecks!

lintRulesDoc
	"Private - Answer the IXMLDOMDocument that represents the lint rules document"

	LintRulesDoc isNull 
		ifTrue: 
			[LintRulesDoc := (IXMLDOMDocument new)
						loadURL: self lintRulesDocURL;
						yourself].
	^LintRulesDoc!

lintRulesDocURL
	"Private - Answers the URL for the XML document that describes the lint rules"

	^'file://',(FileLocator installRelative localFileSpecFor: 'Resources\LintRules.xml')!

lintWarningIcon
	^Icon fromFile: 'LintWarning.ico'!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect 
					choice: #defaultRefreshMode
					fromMap: self refreshModes
					nullValue: nil);
		yourself!

refreshModes
	^##((LookupTable new)
		at: 'Update on request' put: #manual;
		at: 'Update in background' put: #continuous;
		at: 'Update in foreground' put: #whenVisible;
		shrink;
		isImmutable: true;
		yourself)!

report: failedRules for: environment
	"Private - Report the current set of failed rules for the supplied browser environment to all observers"

	self trigger: #report:for: with: failedRules with: environment!

resetFilters
	"Private - Clear down all the Smalllint rule filters"

	BasicLintRule filterDictionary: nil!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 432 98 15 0 416 98 2 8 1140850688 393217 576 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 0 0 576 546 11 1 0 0 410 8 ##(Smalltalk.ComboBox)  98 17 0 576 98 2 8 1144063491 1025 688 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  196934 1 ##(Smalltalk.RGB)  33554431 0 5 0 0 0 688 0 8 4294903803 8 ##(Smalltalk.BasicListAbstract)  816 401 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  649 9 1058 371 43 688 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 68 1 0 0 4 0 0 0 253 1 0 0 25 0 0 0] 98 0 1058 193 193 0 27 410 8 ##(Smalltalk.PushButton)  98 17 0 576 98 2 8 1140924416 1 1184 0 498 528 1058 141 43 517 0 0 0 1184 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #refresh 8 '&Update Now' 1 1 0 0 32 930 202 208 98 3 994 1024 98 2 1058 11 9 1058 141 43 1184 994 8 #isEnabled: 98 1 32 1184 994 8 #text: 98 1 8 '&Update Now' 1184 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 4 0 0 0 75 0 0 0 25 0 0 0] 98 0 1168 0 27 410 8 ##(Smalltalk.ProgressBar)  98 15 0 576 98 2 8 1140850688 1 1648 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  1 498 528 0 5 0 0 0 1648 0 8 4294903757 852486 ##(Smalltalk.NullConverter)  0 0 930 202 208 98 2 994 1024 98 2 1058 161 9 1058 479 43 1648 994 8 #range: 98 1 525062 ##(Smalltalk.Interval)  1 201 3 1648 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 4 0 0 0 63 1 0 0 25 0 0 0] 98 0 1168 0 27 234 256 98 4 688 8 'refreshMode' 1648 8 'progress' 590342 ##(Smalltalk.Rectangle)  1058 11 9 1058 9 7 930 202 208 98 1 994 1024 98 2 1058 1 531 1058 1031 61 576 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 9 1 0 0 3 2 0 0 39 1 0 0] 98 3 1648 688 1184 1168 0 27 0 0 410 432 98 15 0 416 98 2 8 1140850688 131073 2384 0 498 528 0 5 0 0 0 2384 1180166 ##(Smalltalk.ProportionalLayout)  234 240 816 32 234 256 98 4 410 432 98 15 0 2384 98 2 8 1140850688 393217 2544 0 498 528 0 5 0 0 0 2544 656390 ##(Smalltalk.GridLayout)  3 1 1 1 234 256 816 0 930 202 208 98 1 994 1024 98 2 1058 521 1 1058 511 531 2544 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 1 0 0 0 0 0 0 3 2 0 0 9 1 0 0] 98 0 1168 0 27 8 'infoSite' 410 8 ##(Smalltalk.TreeView)  98 27 0 2384 98 2 8 1140918306 262145 2848 590918 3 ##(Smalltalk.TreeModel)  0 848 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 816 498 528 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 7 984134 2 ##(Smalltalk.CommandMenuItem)  1 1314 8 #filterOutRule 8 'Ignore this rule failure' 1 1 0 0 0 3074 1 1314 8 #selectFilteredRules 8 'Show ignored rules...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3074 1 1314 8 #exportIgnoredRules 8 'Export all ignored rules...' 1 1 0 0 0 3074 1 1314 8 #importIgnoredRules 8 'Import all ignored rules...' 1 1 0 0 0 3218 4097 3074 1 1314 8 #clearIgnoredRules 8 'Clear all ignored rules' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2848 0 8 4294903619 912 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  4 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | (CodeMentorPlugin lintIconOfRule: x) imageIndex]' 8 #[32 105 45 17 177 160 106] 721414 ##(Smalltalk.Association)  8 #CodeMentorPlugin 8 ##(Smalltalk.CodeMentorPlugin)  8 #lintIconOfRule: 8 #imageIndex 3504 7 257 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 1058 65 65 0 234 240 816 17 8 #smallIcons 1 0 930 202 208 98 2 994 1024 98 2 1058 1 1 1058 511 531 2848 994 8 #contextMenu: 98 1 3040 2848 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 255 0 0 0 9 1 0 0] 98 0 1168 0 27 8 'failures' 0 930 202 208 98 1 994 1024 98 2 1058 1 1 1058 1031 531 2384 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 3 2 0 0 9 1 0 0] 98 3 2848 410 8 ##(Smalltalk.Splitter)  98 12 0 2384 98 2 8 1140850688 1 4176 0 498 528 0 517 0 0 0 4176 930 202 208 98 1 994 1024 98 2 1058 511 1 1058 11 531 4176 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 4 1 0 0 9 1 0 0] 98 0 1168 0 27 2544 1168 0 27 234 256 816 0 930 202 208 98 1 994 1024 98 2 1058 2799 21 1058 1031 591 416 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 122 7 0 0 49 1 0 0] 98 2 2384 576 1168 0 27 )!

sleepIcon
	^Icon fromFile: 'Sleep.ico'! !
!CodeMentorPlugin class categoriesFor: #defaultFilterFilename!accessing!private! !
!CodeMentorPlugin class categoriesFor: #defaultFilterFileType!constants!private! !
!CodeMentorPlugin class categoriesFor: #defaultRefreshMode!accessing!public! !
!CodeMentorPlugin class categoriesFor: #defaultRefreshMode:!accessing!public! !
!CodeMentorPlugin class categoriesFor: #exportFilters!operations!public! !
!CodeMentorPlugin class categoriesFor: #filterFileTypes!constants!private! !
!CodeMentorPlugin class categoriesFor: #icon!constants!public! !
!CodeMentorPlugin class categoriesFor: #importFilters!operations!private! !
!CodeMentorPlugin class categoriesFor: #initialize!initializing!private! !
!CodeMentorPlugin class categoriesFor: #lintErrorIcon!constants!private! !
!CodeMentorPlugin class categoriesFor: #lintIconMap!helpers!private! !
!CodeMentorPlugin class categoriesFor: #lintIconOfRule:!helpers!private! !
!CodeMentorPlugin class categoriesFor: #lintInfoIcon!constants!private! !
!CodeMentorPlugin class categoriesFor: #lintPassIcon!constants!private! !
!CodeMentorPlugin class categoriesFor: #lintPassRule!constants!private! !
!CodeMentorPlugin class categoriesFor: #lintRules!accessing!private! !
!CodeMentorPlugin class categoriesFor: #lintRulesDoc!accessing!private! !
!CodeMentorPlugin class categoriesFor: #lintRulesDocURL!constants!private! !
!CodeMentorPlugin class categoriesFor: #lintWarningIcon!constants!private! !
!CodeMentorPlugin class categoriesFor: #publishedAspects!development!public! !
!CodeMentorPlugin class categoriesFor: #refreshModes!constants!private! !
!CodeMentorPlugin class categoriesFor: #report:for:!operations!private! !
!CodeMentorPlugin class categoriesFor: #resetFilters!operations!private! !
!CodeMentorPlugin class categoriesFor: #resource_Default_view!public!resources-views! !
!CodeMentorPlugin class categoriesFor: #sleepIcon!constants!private! !

