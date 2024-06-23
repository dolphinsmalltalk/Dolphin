"Filed out from Dolphin Smalltalk"!

Tools.SmalllintPlugin
	subclass: #'Tools.CodeRewriterPlugin'
	instanceVariableNames: 'searchTextPresenter replaceTextPresenter isMethodPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.CodeRewriterPlugin guid: (Core.GUID fromString: '{622a0d86-ee77-4d68-abc4-24f3e47ece4b}')!

Tools.CodeRewriterPlugin comment: ''!

!Tools.CodeRewriterPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !

!Tools.CodeRewriterPlugin methodsFor!

browseRuleResults: aLintRule 
	| matching |
	matching := aLintRule result.
	self developmentSystem 
		browseMethodsIn: matching
		filter: (self methodFilterForRule: aLintRule inEnvironment: self browserEnvironment)!

buildReplaceRule
	| searchText replaceText |
	searchText := self searchText.
	replaceText := self replaceText.
	^
	[TransformationRule
		rewrite: {{searchText. replaceText}}
		methods: isMethodPresenter value
		name: 'Replace: <1s> with: <2s> in <3p>'
				<< {self captionText: searchText. self captionText: replaceText. self browserEnvironment}]
			on: Parser errorClass
			do: 
				[:ex |
				(ex source = searchText ifTrue: [searchTextPresenter] ifFalse: [replaceTextPresenter])
					selectionRange: ex range.
				self browser statusModel value: ex.
				nil]!

buildSearchRule
	| caption |
	caption := String writeStream.
	caption nextPutAll: 'Methods matching: '.
	self searchText aspectDisplayOn: caption.
	caption
		nextPutAll: ' in ';
		print: self browserEnvironment.
	^
	[ParseTreeLintRule
		createParseTreeRule: {self searchText}
		method: isMethodPresenter value
		name: caption contents]
			on: Parser errorClass
			do: 
				[:ex |
				searchTextPresenter showError: ex offset: 0.
				nil]!

captionText: searchText 
	| stream |
	stream := String writeStream.
	searchText aspectDisplayOn: stream.
	^stream contents!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	searchTextPresenter := self add: SmalltalkWorkspace new name: 'searchText'.
	replaceTextPresenter := self add: SmalltalkWorkspace new name: 'replaceText'.
	isMethodPresenter := self add: BooleanPresenter new name: 'isMethod'!

defaultHelpId
	^10751!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed as a plugin within the Class Browser."

	aPuttableStream nextPutAll: 'Code Rewriter'!

hasSearchText
	^searchTextPresenter textLength > 0!

model: anObject
	super model: anObject.
	searchTextPresenter errorModel: self model statusModel.!

renameMethodArgument
	| pair prompter |
	pair := 'anObject' -> ''.
	prompter := KeyValuePrompter
				createOn: pair
				prompt: 'Enter the old and new argument names:'
				caption: 'Rename Method Argument…'.
	prompter
		keyLabel: 'Old:';
		valueLabel: 'New:'.
	prompter validater: 
			[:a |
			| result |
			{ prompter keyPresenter. prompter valuePresenter } allSatisfy: 
					[:each |
					result := (RBCondition isValidTemporaryVariableName: each value) validate.
					result presenter: each.
					result value].
			(result value and: [a key = a value]) ifTrue: [
				result errorMessage: 'New argument name must differ from old'; presenter: prompter valuePresenter].
			result].
	prompter showModal ifNil: [^self].
	self runTransformation: (TransformationRule renameArgument: pair key to: pair value)!

replace
	<commandQuery: #hasSearchText>
	self buildReplaceRule ifNotNil: [:rule | self runTransformation: rule]!

replaceText
	^replaceTextPresenter text!

search
	<commandQuery: #hasSearchText>
	searchTextPresenter clearStatus.
	self buildSearchRule
		ifNotNil: [:searchRule | (self runRule: searchRule) isNil ifFalse: [self browseRuleResults: searchRule]]!

searchText
	^searchTextPresenter text!

transform
	| rules |
	rules := 'transformations' asMethodCategory methodsInBehavior: TransformationRule class.
	rules := (rules collect: [:each | TransformationRule perform: each selector])
				asSortedCollection: [:a :b | a displayString < b displayString].
	(ChoicePrompter choices: rules caption: 'Choose Transformation…')
		ifNotNil: [:rule | self runTransformation: rule]! !

!Tools.CodeRewriterPlugin categoriesForMethods!
browseRuleResults:!helpers!private! !
buildReplaceRule!helpers!private! !
buildSearchRule!helpers!private! !
captionText:!helpers!private! !
createComponents!initializing!public! !
defaultHelpId!public! !
displayOn:!displaying!public! !
hasSearchText!private!testing! !
model:!accessing!public! !
renameMethodArgument!commands-actions!public! !
replace!commands-actions!public! !
replaceText!accessing!private! !
search!commands-actions!public! !
searchText!accessing!private! !
transform!commands-actions!public! !
!

!Tools.CodeRewriterPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^TransformationRule icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 550 #{Core.IdentityDictionary} 0 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 306 971 601 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 228 13 0 0 54 1 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 1798 #{UI.BorderLayout} 1 1 nil nil 18 #{UI.ContainerView} 50 15 nil 416 50 2 8 1140850688 131073 512 nil nil nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 306 193 193 nil 512 482 1 11 nil 18 #{UI.PushButton} 50 20 nil 512 50 2 8 1140924416 1 688 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 688 nil nil 1350 4 #{UI.CommandDescription} #search 8 '&Search' 1 1 nil nil false nil nil nil 210 50 3 258 #createAt:extent: 50 2 306 11 235 306 181 51 688 258 #isEnabled: 8 #(false) 688 258 #text: 50 1 8 '&Search' 688 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 117 0 0 0 95 0 0 0 142 0 0 0] 8 #() 306 193 193 nil 29 nil nil 18 #{UI.StaticText} 50 16 nil 512 50 2 8 1140850944 1 1072 nil nil nil 517 nil nil nil 1072 nil nil 518 #{UI.NullConverter} nil nil nil 210 50 2 258 #createAt:extent: 50 2 306 11 11 306 181 215 1072 258 #text: 50 1 8 '` = meta var
@ = list
`` = recurse into
. = statement
# = literal
; = cascade list
{ = use a block' 1072 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 95 0 0 0 112 0 0 0] 8 #() 1056 nil 27 178 0 518 #{Graphics.Rectangle} 306 11 11 306 11 11 210 50 1 258 #createAt:extent: 50 2 306 771 1 306 201 295 512 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 50 2 1072 688 1056 nil 27 nil 18 #{UI.ReferenceView} 50 14 nil 416 50 2 8 1140916224 131073 1584 nil nil nil 5 nil nil nil 1584 582 1 #{UI.ResourceIdentifier} #{Tools.ValueWorkspace} #resource_Default_view nil 210 50 1 258 #createAt:extent: 50 2 306 1 1 306 771 295 1584 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 147 0 0 0] 8 #() 1056 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} 176 50 2 1584 8 'searchText' nil 210 50 1 258 #createAt:extent: 50 2 306 1 1 306 971 295 416 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 50 2 1584 512 1056 nil 27 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2032 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2032 nil 1 #left nil nil nil 306 1 1 306 9 9 nil 2128 nil 210 50 1 258 #createAt:extent: 50 2 306 1 295 306 971 11 2032 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 147 0 0 0 229 1 0 0 152 0 0 0] 8 #() 1056 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131137 2304 nil nil nil 5 nil nil nil 2304 482 1 1 nil nil 18 #{UI.ContainerView} 50 15 nil 2304 50 2 8 1140850688 131073 2384 nil nil nil 5 nil 578 nil true 610 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 656 nil 2384 838 1 #{UI.FlowLayout} 1 11 1 1826 176 50 2 18 #{UI.CheckBox} 50 16 nil 2384 50 2 8 1140924419 1 2560 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 2560 nil nil 1138 nil nil nil 210 50 2 258 #createAt:extent: 50 2 306 11 1 306 171 71 2560 258 #text: 50 1 8 'Match whole method?' 2560 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 90 0 0 0 35 0 0 0] 8 #() 1056 nil 27 8 'isMethod' 1378 306 11 1 306 1 1 210 50 1 258 #createAt:extent: 50 2 306 771 1 306 201 297 2384 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 148 0 0 0] 50 4 2560 18 #{UI.PushButton} 50 20 nil 2384 50 2 8 1140924416 1 3104 nil 768 nil 5 nil nil nil 3104 nil nil 786 #replace 8 '&Replace…' 1 1 nil nil false nil nil nil 210 50 3 258 #createAt:extent: 50 2 306 11 81 306 181 51 3104 258 #isEnabled: 8 #(false) 3104 258 #text: 50 1 8 '&Replace…' 3104 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 40 0 0 0 95 0 0 0 65 0 0 0] 8 #() 1056 nil 29 18 #{UI.PushButton} 50 20 nil 2384 50 2 8 1140924416 1 3424 nil 768 nil 5 nil nil nil 3424 nil nil 786 #transform 8 '&Transform…' 1 1 nil nil false nil nil nil 210 50 3 258 #createAt:extent: 50 2 306 11 141 306 181 51 3424 258 #isEnabled: 8 #(false) 3424 258 #text: 50 1 8 '&Transform…' 3424 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 95 0 0 0 95 0 0 0] 8 #() 1056 nil 29 18 #{UI.PushButton} 50 20 nil 2384 50 2 8 1140924416 1 3744 nil 768 nil 5 nil nil nil 3744 nil nil 786 #renameMethodArgument 8 '&Rename Arg…' 1 1 nil nil false nil nil nil 210 50 3 258 #createAt:extent: 50 2 306 11 201 306 181 51 3744 258 #isEnabled: 8 #(false) 3744 258 #text: 50 1 8 '&Rename Arg…' 3744 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 100 0 0 0 95 0 0 0 125 0 0 0] 8 #() 1056 nil 29 1056 nil 27 nil 18 #{UI.ReferenceView} 50 14 nil 2304 50 2 8 1140916224 131073 4064 nil 768 nil 5 nil nil nil 4064 1650 #{Tools.ValueWorkspace} #resource_Default_view nil 210 50 1 258 #createAt:extent: 50 2 306 1 1 306 771 297 4064 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 148 0 0 0] 1808 1056 nil 27 1826 176 50 2 4064 8 'replaceText' nil 210 50 1 258 #createAt:extent: 50 2 306 1 305 306 971 297 2304 354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 152 0 0 0 229 1 0 0 44 1 0 0] 50 2 4064 2384 1056 nil 27 1056 nil 27)! !

!Tools.CodeRewriterPlugin class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

