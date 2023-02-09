"Filed out from Dolphin Smalltalk"!

Tools.SmalllintPlugin subclass: #'Tools.CodeRewriterPlugin'
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

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#search == selector
		ifTrue: 
			[aCommandQuery isEnabled: self hasSearchText.
			^true].
	#replace == selector
		ifTrue: 
			[aCommandQuery isEnabled: self hasSearchText.
			^true].
	^super queryCommand: aCommandQuery!

renameMethodArgument
	| pair |
	pair := 'anObject' -> ''.
	(KeyValuePrompter 
		createOn: pair
		prompt: 'Enter the old and new arugment names:'
		caption: 'Rename Method Argument…') showModal 
		isNil ifTrue: [^self].
	self runTransformation: (TransformationRule renameArgument: pair key to: pair value)!

replace
	self buildReplaceRule ifNotNil: [:rule | self runTransformation: rule]!

replaceText
	^replaceTextPresenter text!

search
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
buildReplaceRule!commands!private! !
buildSearchRule!helpers!private! !
captionText:!helpers!private! !
createComponents!initializing!public! !
defaultHelpId!public! !
displayOn:!displaying!public! !
hasSearchText!commands!private! !
model:!accessing!public! !
queryCommand:!commands!private! !
renameMethodArgument!commands!public! !
replace!commands!public! !
replaceText!accessing!private! !
search!commands!public! !
searchText!accessing!private! !
transform!commands!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 8 #() true 170 192 528 nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 658 971 601 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 228 25 0 0 54 1 0 0] 34 3 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 768 nil nil nil 5 nil nil nil 768 984838 #{UI.BorderLayout} 1 1 nil nil 410 #{UI.ContainerView} 34 15 nil 768 34 2 8 1140850688 131073 864 nil nil nil 5 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 658 193 193 nil 864 834 1 11 nil 410 #{UI.PushButton} 34 20 nil 864 34 2 8 1140924416 1 1040 nil 917510 #{Graphics.Color} #default nil 5 nil nil nil 1040 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #search 8 '&Search' 1 1 nil nil false nil nil nil 562 34 3 610 #createAt:extent: 34 2 658 11 235 658 181 51 1040 610 #isEnabled: 8 #(false) 1040 610 #text: 34 1 8 '&Search' 1040 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 117 0 0 0 95 0 0 0 142 0 0 0] 8 #() 658 193 193 nil 29 nil nil 410 #{UI.StaticText} 34 16 nil 864 34 2 8 1140850944 1 1440 nil nil nil 517 nil nil nil 1440 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 562 34 2 610 #createAt:extent: 34 2 658 11 11 658 181 215 1440 610 #text: 34 1 8 '` = meta var
@ = list
`` = recurse into
. = statement
# = literal
; = cascade list
{ = use a block' 1440 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 95 0 0 0 112 0 0 0] 8 #() 1424 nil 27 170 192 528 1180166 #{Graphics.Rectangle} 658 11 11 658 11 11 562 34 1 610 #createAt:extent: 34 2 658 771 1 658 201 295 864 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 34 2 1440 1040 1424 nil 27 nil 410 #{UI.ReferenceView} 34 14 nil 768 34 2 8 1140916224 131073 1968 nil nil nil 5 nil nil nil 1968 1376838 1 #{UI.ResourceIdentifier} #{Tools.ValueWorkspace} #resource_Default_view nil 562 34 1 610 #createAt:extent: 34 2 658 1 1 658 771 295 1968 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 147 0 0 0] 528 1424 nil 27 170 192 34 2 1968 8 'searchText' nil 562 34 1 610 #createAt:extent: 34 2 658 1 1 658 971 295 768 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 34 2 1968 864 1424 nil 27 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 2384 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2384 nil 1 #left nil nil nil 658 1 1 658 9 9 nil 2480 nil 562 34 1 610 #createAt:extent: 34 2 658 1 295 658 971 11 2384 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 147 0 0 0 229 1 0 0 152 0 0 0] 8 #() 1424 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131137 2656 nil nil nil 5 nil nil nil 2656 834 1 1 nil nil 410 #{UI.ContainerView} 34 15 nil 2656 34 2 8 1140850688 131073 2736 nil nil nil 5 nil 930 nil true 962 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1008 nil 2736 852806 1 #{UI.FlowLayout} 1 11 1 170 192 34 2 410 #{UI.CheckBox} 34 16 nil 2736 34 2 8 1140924419 1 2912 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 2912 nil 8 1815097472 1522 nil nil nil 562 34 2 610 #createAt:extent: 34 2 658 11 1 658 171 71 2912 610 #text: 34 1 8 'Match whole method?' 2912 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 90 0 0 0 35 0 0 0] 8 #() 1424 nil 27 8 'isMethod' 1762 658 11 1 658 1 1 562 34 1 610 #createAt:extent: 34 2 658 771 1 658 201 297 2736 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 148 0 0 0] 34 4 2912 410 #{UI.PushButton} 34 20 nil 2736 34 2 8 1140924416 1 3472 nil 1120 nil 5 nil nil nil 3472 nil 8 1815097472 1154 #replace 8 '&Replace…' 1 1 nil nil false nil nil nil 562 34 3 610 #createAt:extent: 34 2 658 11 81 658 181 51 3472 610 #isEnabled: 8 #(false) 3472 610 #text: 34 1 8 '&Replace…' 3472 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 40 0 0 0 95 0 0 0 65 0 0 0] 8 #() 1424 nil 29 410 #{UI.PushButton} 34 20 nil 2736 34 2 8 1140924416 1 3808 nil 1120 nil 5 nil nil nil 3808 nil 8 1815097472 1154 #transform 8 '&Transform…' 1 1 nil nil false nil nil nil 562 34 3 610 #createAt:extent: 34 2 658 11 141 658 181 51 3808 610 #isEnabled: 8 #(false) 3808 610 #text: 34 1 8 '&Transform…' 3808 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 95 0 0 0 95 0 0 0] 8 #() 1424 nil 29 410 #{UI.PushButton} 34 20 nil 2736 34 2 8 1140924416 1 4144 nil 1120 nil 5 nil nil nil 4144 nil 8 1815097472 1154 #renameMethodArgument 8 '&Rename Arg…' 1 1 nil nil false nil nil nil 562 34 3 610 #createAt:extent: 34 2 658 11 201 658 181 51 4144 610 #isEnabled: 8 #(false) 4144 610 #text: 34 1 8 '&Rename Arg…' 4144 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 100 0 0 0 95 0 0 0 125 0 0 0] 8 #() 1424 nil 29 1424 nil 27 nil 410 #{UI.ReferenceView} 34 14 nil 2656 34 2 8 1140916224 131073 4480 nil 1120 nil 5 nil nil nil 4480 2034 #{Tools.ValueWorkspace} #resource_Default_view nil 562 34 1 610 #createAt:extent: 34 2 658 1 1 658 771 297 4480 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 148 0 0 0] 528 1424 nil 27 170 192 34 2 4480 8 'replaceText' nil 562 34 1 610 #createAt:extent: 34 2 658 1 305 658 971 297 2656 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 152 0 0 0 229 1 0 0 44 1 0 0] 34 2 4480 2736 1424 nil 27 1424 nil 27)! !
!Tools.CodeRewriterPlugin class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

