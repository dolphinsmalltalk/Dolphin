"Filed out from Dolphin Smalltalk"!

Tools.SmalllintPlugin
	subclass: #'Tools.CodeMentorPlugin'
	instanceVariableNames: 'failuresPresenter infoSitePresenter infoBrowserPresenter progressPresenter checkerProcess rulesTreeModel isRefreshPending refreshMode'
	classVariableNames: 'DefaultRefreshMode LintIconMap LintRulesDoc'
	imports: #()
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
		ifNotNil: [:failedClass | (SmalltalkSystem current browseClass: failedClass) caption: self failedRule name]!

browseFailedMethod: aCompiledMethod
	| env |
	env := BrowserEnvironment new forMethods: {aCompiledMethod}.
	env
		label: '<1p>: <2p>' << {self failedRule. aCompiledMethod printString};
		filter: (self methodFilterForRule: self failedRule inEnvironment: self browserEnvironment).
	self browseFailedMethods: env!

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
	self model
		when: #methodSelected
			send: #onBrowserEnvironmentSelected
			to: self;
		when: #classSelected
			send: #onBrowserEnvironmentSelected
			to: self.
	self developmentSystem
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
					self developmentSystem removeFilteredMethod: method forLintRule: eachRule]]!

filterOutRule
	"Add the current method to the filters for the current failed rule(s) so that it won't be classed as a failure next time around"

	<commandQuery: #queryFilterOutRule:>
	self filterOutRules: self failedRule failedRules!

filterOutRules: rules
	"Private - Add filters for the supplied rules"

	rules do: 
			[:eachRule |
			| methods |
			methods := eachRule failedMethods.
			methods do: [:each | self developmentSystem addFilteredMethod: each forLintRule: eachRule]]!

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
			failedRule := failuresPresenter model asArray detect: [:each | each problemCount > 0] ifNone: nil.
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

infoBrowserPresenter
	"Private - Answer an HTML browser than can be used to display LintRule descriptions. We create this lazily
	to avoid slowing down the opening of browsers that make use of the Code Mentor"

	infoBrowserPresenter isNil
		ifTrue: 
			[infoBrowserPresenter := URLPresenter createIn: infoSitePresenter.
			"Attempt to suppress the standard context menu"
			infoBrowserPresenter view
				canNavigateToStrings: true;
				allowContextMenu: false;
				areBrowserAcceleratorKeysEnabled: false.
			infoBrowserPresenter
				when: #navigationStarting:
				send: #onNavigationStarting:
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

isRefreshable
	^isRefreshPending or: [self refreshMode == #manual]!

lintRuleFailuresBrowserClass
	^LintRuleFailuresBrowserShell!

lintRules
	"Private - Answer the roots of the rules hieerarchy to use for checking"

	^CompositeLintRule lintChecks!

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

onNavigationStarting: anICoreWebView2NavigationStartingEventArgs
	| url expression |
	url := anICoreWebView2NavigationStartingEventArgs uri.
	(url beginsWith: self smalltalkUrlTag) ifFalse: [^self].
	expression := (url allButFirst: self smalltalkUrlTag size) urlDecoded.
	Compiler
		evaluate: expression
		for: self
		environment: nil
		logged: false.
	anICoreWebView2NavigationStartingEventArgs cancel: true!

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
	self developmentSystem removeEventsTriggeredFor: self!

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
				nextPutAll: (String writeStream
							nextPutAll: 'self';
							space;
							display: #browseFailedClass:;
							space;
							nextPutAll: each fullName;
							contents) urlEncoded;
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
				nextPutAll: (String writeStream
							nextPutAll: 'self ';
							display: #browseFailedMethod:;
							space;
							nextPutAll: each methodClass fullName;
							nextPutAll: #>>;
							print: each selector;
							contents) urlEncoded;
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

queryFilterOutRule: aCommandQuery
	| text failedRule |
	failedRule := self failedRule.
	text := (failedRule notNil and: [failedRule problemCount > 1])
				ifTrue: ['Ignore these <d> rule failures' << failedRule problemCount]
				ifFalse: ['Ignore this rule failure'].
	aCommandQuery
		isEnabled: (failedRule notNil and: [failedRule notEmpty]);
		text: text!

refresh
	"Refresh the receiver's display after first re-running the checks"

	<commandQuery: #isRefreshable>
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
	<commandQuery: #isFilterActive>
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
	self infoBrowserPresenter model value: (self htmlDescriptionFor: aLintRule)!

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

!Tools.CodeMentorPlugin categoriesForMethods!
addFailedRule:!helpers!private! !
allRules!operations!private! !
applyTransform:!helpers!private! !
autoRefresh!operations!private! !
browseAllFailedMethods!commands-actions!private! !
browseFailedClass:!operations!private! !
browseFailedMethod:!operations!public! !
browseFailedMethods:!operations!private! !
clearFailures!operations!private! !
clearIgnoredRules!commands-actions!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!constants!public! !
displayOn:!displaying!public! !
exportIgnoredRules!commands-actions!public! !
failedClassesFor:!accessing!private! !
failedRule!commands-actions!private! !
filteredRuleNames!accessing!private! !
filteredRules!accessing!public! !
filterInRules:!operations!private! !
filterOutRule!commands-actions!public! !
filterOutRules:!operations!private! !
getRuleInfo:!helpers!private! !
htmlDescriptionFor:!helpers!private! !
htmlStyle!helpers!private! !
icon!accessing!public! !
importIgnoredRules!commands-actions!public! !
indicateFailures:!operations!private! !
indicateStatus!operations!private! !
indicateSuccess!operations!private! !
infoBrowserPresenter!accessing!private! !
initialize!initializing!private! !
isBusy!accessing!public! !
isFilterActive!private!testing! !
isRefreshable!private!testing! !
lintRuleFailuresBrowserClass!constants!private! !
lintRules!accessing!private! !
onBrowserEnvironmentSelected!event handling!private! !
onClassUpdated:!event handling!public! !
onFailureSelected!event handling!private! !
onGetCursor:!event handling!public! !
onLintRuleFilterChanged:!event handling!public! !
onMethodUpdated:!event handling!public! !
onNavigationStarting:!event handling!private! !
onShownInBrowser!event handling!public! !
onStartup!event handling!private! !
onStartup2!event handling!private! !
onViewClosed!event handling!public! !
onViewDestroyed!event handling!public! !
parentRuleOf:!helpers!private! !
printClassFailuresHtmlFor:on:!helpers!printing!private! !
printMethodFailuresHtmlFor:on:!helpers!printing!private! !
printTransformationRuleHtmlFor:on:!helpers!printing!private! !
queryFilterOutRule:!commands-queries!private! !
refresh!commands-actions!public! !
refreshIcon!operations!private! !
refreshMode!accessing!public! !
refreshMode:!accessing!public! !
refreshResults!commands-actions!public! !
resetProgressBar!operations!private! !
rulesTreeModel!accessing!private! !
runLintChecks!operations!public! !
selectFilteredRules!commands-actions!public! !
showDescriptionFor:!operations!private! !
smalltalkUrlTag!constants!private! !
splitName:!helpers!private! !
startCheckerProcess!operations!private! !
stopCheckerProcess!operations!private! !
!

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
			[LintIconMap := LookupTable new
						at: 'bugs' put: self lintErrorIcon;
						at: 'possible bugs' put: self lintErrorIcon;
						at: 'unnecessary code' put: self lintWarningIcon;
						at: 'intention revealing' put: self lintWarningIcon;
						at: 'miscellaneous' put: self lintInfoIcon;
						at: 'all checks passed' put: self lintPassIcon;
						shrink;
						beImmutableObject;
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
			[LintRulesDoc := MSXML newDocument
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
	^##(LookupTable new
		at: 'Update on request' put: #manual;
		at: 'Update in background' put: #continuous;
		at: 'Update in foreground' put: #whenVisible;
		shrink;
		beImmutableObject;
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 144 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 144 114 11 1 nil nil 18 #{UI.ComboBox} 50 17 nil 144 50 2 8 1144063491 1025 304 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 304 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[70 1 0 0 4 0 0 0 255 1 0 0 226 0 0 0] 193 336 8 '' 304 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 18 #{UI.PushButton} 50 20 nil 144 50 2 8 1140924416 1 800 nil 480 nil 517 nil nil nil 800 nil nil 1350 4 #{UI.CommandDescription} #refresh 8 '&Update Now' 1 1 nil nil false nil nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[5 0 0 0 4 0 0 0 79 0 0 0 27 0 0 0] 193 832 8 '&Update Now' 800 610 #isEnabled: 8 #(false) 800 3 8 #() 770 193 193 nil 29 18 #{UI.ProgressBar} 50 15 nil 144 50 2 8 1140850688 1 1104 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 1 480 nil 5 nil nil nil 1104 nil nil 518 #{UI.NullConverter} nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[84 0 0 0 4 0 0 0 65 1 0 0 27 0 0 0] 193 1136 8 '' 1104 610 #range: 50 1 774 #{Core.Interval} 1 201 3 1104 3 8 #() 770 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 1104 8 'progress' 304 8 'refreshMode' 518 #{Graphics.Rectangle} 770 11 9 770 9 7 562 50 1 610 #createWindow: 50 1 658 690 8 #[0 0 0 0 9 1 0 0 3 2 0 0 39 1 0 0] 193 176 8 '' 144 3 50 3 1104 304 800 770 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1792 nil nil nil 5 nil nil nil 1792 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 1490 #{Core.IdentityDictionary} 50 4 18 #{UI.TreeView} 50 35 nil 1792 50 2 8 1140918818 1 1952 1094 3 #{UI.TreeModel} nil 448 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 480 nil 5 2886 4 #{UI.Menu} nil true 50 7 1094 2 #{UI.CommandMenuItem} 1 866 #filterOutRule 8 'Ignore this rule failure' 1 1 nil nil nil 2162 1 866 #selectFilteredRules 8 'Show ignored rules…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2162 1 866 #exportIgnoredRules 8 'Export all ignored rules…' 1 1 nil nil nil 2162 1 866 #importIgnoredRules 8 'Import all ignored rules…' 1 1 nil nil nil 2274 4097 2162 1 866 #clearIgnoredRules 8 'Clear all ignored rules' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1952 nil nil 512 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 4 1 2480 8 'doIt' 8 '[:x | (Tools.CodeMentorPlugin lintIconOfRule: x) imageIndex]' 8 #[32 105 45 17 177 160 106] 1094 2 #{Kernel.VariableBinding} #CodeMentorPlugin #{Tools.CodeMentorPlugin} #{Tools} 1 #lintIconOfRule: #imageIndex 2496 7 257 nil 1350 1 #{Graphics.IconImageManager} nil nil nil 770 65 65 nil 1890 0 nil #smallIcons 1 2082 0 1 262 #{UI.TreeViewDynamicUpdateMode} 1952 nil nil nil nil nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[0 0 0 0 0 0 0 0 255 0 0 0 9 1 0 0] 193 1984 8 '' 1952 610 #contextMenu: 50 1 2128 1952 3 8 #() 770 193 193 nil 29 8 'failures' 18 #{UI.ContainerView} 50 15 nil 1792 50 2 8 1140850688 131073 2944 nil nil nil 5 nil nil nil 2944 1030 #{UI.GridLayout} 3 1 1 1 2082 0 nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[4 1 0 0 0 0 0 0 3 2 0 0 9 1 0 0] 193 2976 8 '' 2944 3 8 #() 770 193 193 nil 27 8 'infoSite' nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[0 0 0 0 0 0 0 0 3 2 0 0 9 1 0 0] 193 1824 8 '' 1792 3 50 3 1952 18 #{UI.Splitter} 50 12 nil 1792 50 2 8 1140850688 1 3376 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 3376 nil 1 #left nil nil nil 770 1 1 770 9 9 nil 3472 nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[255 0 0 0 0 0 0 0 4 1 0 0 9 1 0 0] 193 3408 8 '' 3376 3 8 #() 770 193 193 nil 27 2944 770 193 193 nil 27 2082 0 nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[255 14 0 0 10 0 0 0 2 17 0 0 49 1 0 0] 193 80 8 '' 32 1 50 2 1792 144 770 193 193 nil 27)!

sleepIcon
	^Icon fromId: 'LintSleep.ico'! !

!Tools.CodeMentorPlugin class categoriesForMethods!
busyIcon!constants!private! !
defaultFilterFilename!accessing!private! !
defaultFilterFileType!constants!private! !
defaultRefreshMode!accessing!public! !
defaultRefreshMode:!accessing!public! !
exportFilters!operations!public! !
filterFileTypes!constants!private! !
icon!constants!public! !
importFilters!operations!private! !
initialize!initializing!private! !
lintErrorIcon!constants!private! !
lintIconMap!helpers!private! !
lintIconOfRule:!helpers!private! !
lintInfoIcon!constants!private! !
lintPassIcon!constants!private! !
lintPassRule!constants!private! !
lintRules!accessing!private! !
lintRulesDoc!accessing!private! !
lintRulesDocURL!constants!private! !
lintWarningIcon!constants!private! !
publishedAspects!development!public! !
refreshModes!constants!private! !
report:for:!operations!private! !
resetFilters!operations!private! !
resource_Default_view!public!resources-views! !
sleepIcon!constants!private! !
!

