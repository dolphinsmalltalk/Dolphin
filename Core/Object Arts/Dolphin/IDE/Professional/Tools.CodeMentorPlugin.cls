"Filed out from Dolphin Smalltalk 7"!

Tools.SmalllintPlugin subclass: #'Tools.CodeMentorPlugin'
	instanceVariableNames: 'failuresPresenter infoSitePresenter infoBrowserPresenter progressPresenter checkerProcess rulesTreeModel isRefreshPending refreshMode'
	classVariableNames: 'DefaultRefreshMode LintIconMap LintRulesDoc'
	imports: #(#{Smalltalk.SHDocVwConstants private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CodeMentorPlugin guid: (Core.GUID fromString: '{b1e97c3c-3c35-43e0-99aa-97d69135e2ea}')!
Tools.CodeMentorPlugin comment: 'CodeMentorPlugin is a <classBrowserPlugin> that tests the quality of code currently seen by a browser using Refactory Inc''s SmallLint package.  Since the time taken to perform the SmallLint analysis can be lengthy, the evaluation is performed in a background thread.

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
!Tools.CodeMentorPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!Tools.CodeMentorPlugin methodsFor!

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

	aString asQualifiedReference valueOrNil
		ifNotNil: [:failedClass | (Smalltalk developmentSystem browseClass: failedClass) caption: self failedRule name]!

browseFailedMethodName: aString
	"Private - Browser the method identified by aString"

	(CompiledMethod fromString: aString)
		ifNotNil: 
			[:failedMethod |
			| env |
			env := BrowserEnvironment new forMethods: {failedMethod}.
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed as a plugin within the Class Browser."

	aPuttableStream nextPutAll: 'Code Mentor'!

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

getRuleInfo: aLintRule
	| xpath parts |
	parts := self splitName: aLintRule name.
	xpath := String writeStream.
	xpath nextPutAll: './/LintRule[name='.
	parts size = 1
		ifTrue: 
			[xpath
				nextPut: $";
				nextPutAll: parts first;
				nextPutAll: $"]
		ifFalse: 
			[xpath nextPutAll: 'concat('.
			parts do: [:each | xpath print: each] separatedBy: [xpath nextPut: $,].
			xpath nextPutAll: ')'].
	xpath nextPut: $].
	^CodeMentorPlugin lintRulesDoc selectSingleNode: xpath contents!

htmlDescriptionFor: aLintRule
	"Private - Answers the failures description for aLintRule as HTML"

	"#2139"

	| stream node |
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
	node := self getRuleInfo: aLintRule.
	self printTransformationRuleHtmlFor: node on: stream.
	(node selectSingleNode: 'description') ifNotNil: [:ruleNode | stream nextPutAll: ruleNode innerXML].
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
		ifTrue: [self class busyIcon]
		ifFalse: 
			[| failedRule |
			failedRule := failuresPresenter model asArray detect: [:each | each problemCount > 0]
						ifNone: [].
			failedRule notNil 
				ifTrue: 
					[Processor sleep: 100 milliseconds.
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
			[infoBrowserPresenter := Smalltalk.URLPresenter createIn: infoSitePresenter.
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
			expression := (url allButFirst: self smalltalkUrlTag size) urlDecoded.
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

printTransformationRuleHtmlFor: anIXMLDOMElement on: aStream
	(anIXMLDOMElement selectSingleNode: 'transformationRuleSelector')
		ifNotNil: 
			[:node |
			aStream
				nextPutAll: '<p><i>There is an <a href="';
				nextPutAll: self smalltalkUrlTag;
				nextPutAll: 'self%20';
				display: #applyTransform:;
				display: '%20';
				print: node innerXML;
				nextPutAll: '"> automatic transformation</a> available to address this issue.</i></p>']!

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
						ifTrue: ['Ignore these <1p> rule failures' expandMacrosWith: failedRule problemCount]
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
			[rulesTreeModel := VirtualTreeModel withRoots: {self lintRules}.
			rulesTreeModel
				hasChildrenBlock: [:each | each isComposite];
				getChildrenBlock: 
						[:each |
						each isComposite ifTrue: [each rules reject: [:r | r hasConflicts]] ifFalse: [OrderedCollection new]];
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

splitName: aString
	| stream answer wordStream word |
	answer := OrderedCollection new.
	stream := aString readStream.
	wordStream := String writeStream: 10.
	wordStream reset.
	[stream atEnd] whileFalse: 
			[| next |
			next := stream next.
			next == $"
				ifTrue: 
					[word := wordStream contents.
					word notEmpty
						ifTrue: 
							[answer add: word.
							wordStream reset].
					answer add: '"']
				ifFalse: [wordStream nextPut: next]].
	word := wordStream contents.
	word notEmpty ifTrue: [answer add: word].
	^answer asArray!

startCheckerProcess
	self stopCheckerProcess.
	checkerProcess := 
			[self
				refreshIcon;
				runLintChecks.
			checkerProcess := nil] 
					forkAt: Processor userBackgroundPriority
					maxStack: 128*1024!

stopCheckerProcess
	self isBusy ifFalse: [^self].
	checkerProcess terminate.
	checkerProcess := nil! !
!Tools.CodeMentorPlugin categoriesFor: #addFailedRule:!helpers!private! !
!Tools.CodeMentorPlugin categoriesFor: #allRules!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #applyTransform:!helpers!private! !
!Tools.CodeMentorPlugin categoriesFor: #autoRefresh!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #browseAllFailedMethods!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #browseFailedClass:!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #browseFailedMethodName:!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #browseFailedMethods:!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #clearFailures!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #clearIgnoredRules!commands!public! !
!Tools.CodeMentorPlugin categoriesFor: #createComponents!initializing!public! !
!Tools.CodeMentorPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.CodeMentorPlugin categoriesFor: #defaultHelpId!constants!public! !
!Tools.CodeMentorPlugin categoriesFor: #displayOn:!displaying!public! !
!Tools.CodeMentorPlugin categoriesFor: #exportIgnoredRules!commands!public! !
!Tools.CodeMentorPlugin categoriesFor: #failedClassesFor:!accessing!private! !
!Tools.CodeMentorPlugin categoriesFor: #failedRule!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #filteredRuleNames!accessing!private! !
!Tools.CodeMentorPlugin categoriesFor: #filteredRules!accessing!public! !
!Tools.CodeMentorPlugin categoriesFor: #filterInRules:!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #filterOutRule!commands!public! !
!Tools.CodeMentorPlugin categoriesFor: #filterOutRules:!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #getRuleInfo:!helpers!private! !
!Tools.CodeMentorPlugin categoriesFor: #htmlDescriptionFor:!helpers!private! !
!Tools.CodeMentorPlugin categoriesFor: #htmlStyle!helpers!private! !
!Tools.CodeMentorPlugin categoriesFor: #icon!accessing!public! !
!Tools.CodeMentorPlugin categoriesFor: #importIgnoredRules!commands!public! !
!Tools.CodeMentorPlugin categoriesFor: #indicateFailures:!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #indicateStatus!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #indicateSuccess!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #infoBrowser!accessing!private! !
!Tools.CodeMentorPlugin categoriesFor: #infoBrowserPresenter!accessing!private! !
!Tools.CodeMentorPlugin categoriesFor: #initialize!initializing!private! !
!Tools.CodeMentorPlugin categoriesFor: #isBusy!accessing!public! !
!Tools.CodeMentorPlugin categoriesFor: #isFilterActive!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #lintRuleFailuresBrowserClass!constants!private! !
!Tools.CodeMentorPlugin categoriesFor: #lintRules!accessing!private! !
!Tools.CodeMentorPlugin categoriesFor: #onBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:!event handling!private! !
!Tools.CodeMentorPlugin categoriesFor: #onBrowserEnvironmentSelected!event handling!private! !
!Tools.CodeMentorPlugin categoriesFor: #onClassUpdated:!event handling!public! !
!Tools.CodeMentorPlugin categoriesFor: #onFailureSelected!event handling!private! !
!Tools.CodeMentorPlugin categoriesFor: #onGetCursor:!event handling!public! !
!Tools.CodeMentorPlugin categoriesFor: #onLintRuleFilterChanged:!event handling!public! !
!Tools.CodeMentorPlugin categoriesFor: #onMethodUpdated:!event handling!public! !
!Tools.CodeMentorPlugin categoriesFor: #onShownInBrowser!event handling!public! !
!Tools.CodeMentorPlugin categoriesFor: #onStartup!event handling!private! !
!Tools.CodeMentorPlugin categoriesFor: #onStartup2!event handling!private! !
!Tools.CodeMentorPlugin categoriesFor: #onViewClosed!event handling!public! !
!Tools.CodeMentorPlugin categoriesFor: #onViewDestroyed!event handling!public! !
!Tools.CodeMentorPlugin categoriesFor: #parentRuleOf:!helpers!private! !
!Tools.CodeMentorPlugin categoriesFor: #printClassFailuresHtmlFor:on:!helpers!printing!private! !
!Tools.CodeMentorPlugin categoriesFor: #printMethodFailuresHtmlFor:on:!helpers!printing!private! !
!Tools.CodeMentorPlugin categoriesFor: #printTransformationRuleHtmlFor:on:!helpers!printing!private! !
!Tools.CodeMentorPlugin categoriesFor: #queryCommand:!commands!private! !
!Tools.CodeMentorPlugin categoriesFor: #refresh!commands!public! !
!Tools.CodeMentorPlugin categoriesFor: #refreshIcon!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #refreshMode!accessing!public! !
!Tools.CodeMentorPlugin categoriesFor: #refreshMode:!accessing!public! !
!Tools.CodeMentorPlugin categoriesFor: #refreshResults!commands!public! !
!Tools.CodeMentorPlugin categoriesFor: #resetProgressBar!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #rulesTreeModel!accessing!private! !
!Tools.CodeMentorPlugin categoriesFor: #runLintChecks!operations!public! !
!Tools.CodeMentorPlugin categoriesFor: #selectFilteredRules!commands!public! !
!Tools.CodeMentorPlugin categoriesFor: #showDescriptionFor:!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #smalltalkUrlTag!constants!private! !
!Tools.CodeMentorPlugin categoriesFor: #splitName:!helpers!private! !
!Tools.CodeMentorPlugin categoriesFor: #startCheckerProcess!operations!private! !
!Tools.CodeMentorPlugin categoriesFor: #stopCheckerProcess!operations!private! !

!Tools.CodeMentorPlugin class methodsFor!

busyIcon
	^Icon fromId: 'LintWait.ico'!

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
	^Icon fromId: 'LintError.ico'!

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
	^Icon fromId: 'LintInfo.ico'!

lintPassIcon
	^Icon fromId: 'LintPass.ico'!

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
			[LintRulesDoc := (Smalltalk.IXMLDOMDocument new)
						loadURL: self lintRulesDocURL;
						yourself].
	^LintRulesDoc!

lintRulesDocURL
	"Private - Answers the URL for the XML document that describes the lint rules"

	^'file://',(FileLocator installRelative localFileSpecFor: 'Resources\LintRules.xml')!

lintWarningIcon
	^Icon fromId: 'LintWarning.ico'!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
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

report: failedRules for: aBrowserEnvionment
	"Private - Report the current set of failed rules for the supplied browser environment to all observers"

	self
		trigger: #report:for:
		with: failedRules
		with: aBrowserEnvionment!

resetFilters
	"Private - Clear down all the Smalllint rule filters"

	BasicLintRule filterDictionary: nil!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 512 482 11 1 nil nil 410 ##(UI.ComboBox) 34 17 nil 512 34 2 8 1144063491 1025 704 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 5 nil nil nil 704 nil 8 1801138208 ##(UI.BasicListAbstract) 8 #() 401 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 658 653 9 658 371 47 704 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 1 0 0 4 0 0 0 255 1 0 0 27 0 0 0] 8 #() 658 193 193 nil 27 410 ##(UI.PushButton) 34 20 nil 512 34 2 8 1140924416 1 1152 nil 880 nil 517 nil nil nil 1152 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #refresh 8 '&Update Now' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 658 11 9 658 171 47 1152 994 #isEnabled: 8 #(false) 1152 994 #text: 34 1 8 '&Update Now' 1152 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 4 0 0 0 90 0 0 0 27 0 0 0] 8 #() 1136 nil 29 410 ##(UI.ProgressBar) 34 15 nil 512 34 2 8 1140850688 1 1520 918598 2 ##(UI.ValueHolder) nil nil 1572870 ##(Kernel.NeverSearchPolicy) 1 880 nil 5 nil nil nil 1520 nil 8 1801010736 1049094 ##(UI.NullConverter) nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 658 191 9 658 453 47 1520 994 #range: 34 1 852742 ##(Core.Interval) 1 201 3 1520 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 4 0 0 0 65 1 0 0 27 0 0 0] 8 #() 1136 nil 27 170 192 34 4 704 8 'refreshMode' 1520 8 'progress' 1180166 ##(Graphics.Rectangle) 658 11 9 658 9 7 930 138 144 34 1 994 #createAt:extent: 34 2 658 1 531 658 1031 61 512 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 9 1 0 0 3 2 0 0 39 1 0 0] 34 3 1520 704 1152 1136 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2208 nil nil nil 5 nil nil nil 2208 1376774 ##(UI.ProportionalLayout) 170 176 816 false 170 192 34 4 410 ##(UI.ContainerView) 34 15 nil 2208 34 2 8 1140850688 131073 2352 nil nil nil 5 nil nil nil 2352 852998 ##(UI.GridLayout) 3 1 1 1 170 192 816 nil 930 138 144 34 1 994 #createAt:extent: 34 2 658 521 1 658 511 531 2352 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 1 0 0 0 0 0 0 3 2 0 0 9 1 0 0] 8 #() 1136 nil 27 8 'infoSite' 410 ##(UI.TreeView) 34 27 nil 2208 34 2 8 1140918818 1 2640 787526 3 ##(UI.TreeModel) nil 848 721670 ##(UI.TreeNode) nil nil nil 170 192 816 880 nil 5 461638 4 ##(UI.Menu) nil true 34 7 1180742 2 ##(UI.CommandMenuItem) 1 1234 #filterOutRule 8 'Ignore this rule failure' 1 1 nil nil nil 2834 1 1234 #selectFilteredRules 8 'Show ignored rules...' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 2834 1 1234 #exportIgnoredRules 8 'Export all ignored rules...' 1 1 nil nil nil 2834 1 1234 #importIgnoredRules 8 'Import all ignored rules...' 1 1 nil nil nil 2946 4097 2834 1 1234 #clearIgnoredRules 8 'Clear all ignored rules' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2640 nil 8 1801125840 ##(UI.BasicListAbstract) 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | (CodeMentorPlugin lintIconOfRule: x) imageIndex]' 8 #[32 105 45 17 177 160 106] 1049094 ##(Core.Association) #'Tools.CodeMentorPlugin' ##(Tools.CodeMentorPlugin) #lintIconOfRule: #imageIndex 3184 7 257 nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil 658 65 65 nil 170 176 816 nil #smallIcons 1 170 192 816 930 138 144 34 2 994 #createAt:extent: 34 2 658 1 1 658 511 531 2640 994 #contextMenu: 34 1 2800 2640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 255 0 0 0 9 1 0 0] 8 #() 1136 nil 27 8 'failures' nil 930 138 144 34 1 994 #createAt:extent: 34 2 658 1 1 658 1031 531 2208 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 3 2 0 0 9 1 0 0] 34 3 2640 410 ##(UI.Splitter) 34 12 nil 2208 34 2 8 1140850688 1 3760 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3760 nil 1 #left nil nil nil 658 1 1 658 9 9 nil 3856 nil 930 138 144 34 1 994 #createAt:extent: 34 2 658 511 1 658 11 531 3760 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 4 1 0 0 9 1 0 0] 8 #() 1136 nil 27 2352 1136 nil 27 170 192 816 nil 930 138 144 34 1 994 #createAt:extent: 34 2 658 6143 21 658 1031 591 416 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 2 14 0 0 49 1 0 0] 34 2 2208 512 1136 nil 27 )!

sleepIcon
	^Icon fromId: 'LintSleep.ico'! !
!Tools.CodeMentorPlugin class categoriesFor: #busyIcon!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #defaultFilterFilename!accessing!private! !
!Tools.CodeMentorPlugin class categoriesFor: #defaultFilterFileType!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #defaultRefreshMode!accessing!public! !
!Tools.CodeMentorPlugin class categoriesFor: #defaultRefreshMode:!accessing!public! !
!Tools.CodeMentorPlugin class categoriesFor: #exportFilters!operations!public! !
!Tools.CodeMentorPlugin class categoriesFor: #filterFileTypes!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #icon!constants!public! !
!Tools.CodeMentorPlugin class categoriesFor: #importFilters!operations!private! !
!Tools.CodeMentorPlugin class categoriesFor: #initialize!initializing!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintErrorIcon!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintIconMap!helpers!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintIconOfRule:!helpers!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintInfoIcon!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintPassIcon!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintPassRule!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintRules!accessing!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintRulesDoc!accessing!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintRulesDocURL!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #lintWarningIcon!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #publishedAspects!development!public! !
!Tools.CodeMentorPlugin class categoriesFor: #refreshModes!constants!private! !
!Tools.CodeMentorPlugin class categoriesFor: #report:for:!operations!private! !
!Tools.CodeMentorPlugin class categoriesFor: #resetFilters!operations!private! !
!Tools.CodeMentorPlugin class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.CodeMentorPlugin class categoriesFor: #sleepIcon!constants!private! !

