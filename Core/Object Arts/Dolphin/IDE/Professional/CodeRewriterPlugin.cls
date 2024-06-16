"Filed out from Dolphin Smalltalk"!

SmalllintPlugin subclass: #CodeRewriterPlugin
	instanceVariableNames: 'searchTextPresenter replaceTextPresenter isMethodPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CodeRewriterPlugin guid: (GUID fromString: '{622a0d86-ee77-4d68-abc4-24f3e47ece4b}')!

CodeRewriterPlugin comment: ''!

!CodeRewriterPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !

!CodeRewriterPlugin methodsFor!

browseRuleResults: aLintRule 
	| matching |
	matching := aLintRule result.
	self systemModel 
		browseMethodsIn: matching
		filter: (self methodFilterForRule: aLintRule inEnvironment: self browserEnvironment)!

buildReplaceRule
	| searchText replaceText |
	searchText := self searchText.
	replaceText := self replaceText.
	^
	[TransformationRule 
		rewrite: (Array with: (Array with: searchText with: replaceText))
		methods: isMethodPresenter value
		name: ('Replace: <1s> with: <2s>' expandMacrosWith: (self captionText: searchText)
				with: (self captionText: replaceText))] 
			on: SmalltalkParser errorClass
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
	^
	[ParseTreeLintRule 
		createParseTreeRule: (Array with: self searchText)
		method: isMethodPresenter value
		name: caption contents] 
			on: SmalltalkParser errorClass
			do: 
				[:ex | 
				searchTextPresenter selectionRange: ex range.
				self browser statusModel value: ex.
				ex return]!

captionText: searchText 
	| stream |
	stream := String writeStream.
	searchText aspectDisplayOn: stream.
	^stream contents!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	searchTextPresenter := self add: TextPresenter new name: 'searchText'.
	replaceTextPresenter := self add: TextPresenter new name: 'replaceText'.
	isMethodPresenter := self add: BooleanPresenter new name: 'isMethod'!

defaultHelpId
	^10751!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Code Rewriter'!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#search == selector 
		ifTrue: 
			[aCommandQuery isEnabled: searchTextPresenter value notEmpty.
			^true].
	#replace == selector 
		ifTrue: 
			[aCommandQuery isEnabled: searchTextPresenter value notEmpty.
			^true].
	^super queryCommand: aCommandQuery!

renameMethodArgument
	| pair |
	pair := 'anObject' -> ''.
	(KeyValuePrompter 
		createOn: pair
		prompt: 'Enter the old and new arugment names:'
		caption: 'Rename Method Argument...') showModal 
		isNil ifTrue: [^self].
	self runTransformation: (TransformationRule renameArgument: pair key to: pair value)!

replace
	self buildReplaceRule ifNotNil: [:rule | self runTransformation: rule]!

replaceText
	^replaceTextPresenter value!

search
	self buildSearchRule 
		ifNotNil: [:searchRule | (self runRule: searchRule) isNil ifFalse: [self browseRuleResults: searchRule]]!

searchText
	^searchTextPresenter value!

transform
	| rules |
	rules := 'transformations' asMethodCategory methodsInBehavior: TransformationRule class.
	rules := (rules collect: [:each | TransformationRule perform: each selector])
				asSortedCollection: [:a :b | a displayString < b displayString].
	(ChoicePrompter choices: rules caption: 'Choose Transformation...')
		ifNotNil: [:rule | self runTransformation: rule]! !

!CodeRewriterPlugin categoriesForMethods!
browseRuleResults:!helpers!private! !
buildReplaceRule!commands!private! !
buildSearchRule!helpers!private! !
captionText:!helpers!private! !
createComponents!initializing!public! !
defaultHelpId!public! !
displayOn:!displaying!public! !
queryCommand:!commands!private! !
renameMethodArgument!commands!public! !
replace!commands!public! !
replaceText!accessing!private! !
search!commands!public! !
searchText!accessing!private! !
transform!commands!public! !
!

!CodeRewriterPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^TransformationRule icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 528 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 100 9 0 0 54 1 0 0] 193 448 8 '' 416 1 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 784 nil nil nil 5 nil nil nil 784 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 784 34 2 8 1140850688 131073 880 nil nil nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 880 850 1 11 nil 410 ##(Smalltalk.PushButton) 34 20 nil 880 34 2 8 1140924416 1 1040 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1040 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #search 8 '&Search' 1 1 nil nil false nil nil nil 562 138 144 34 2 626 #createWindow: 34 1 674 706 8 #[5 0 0 0 117 0 0 0 95 0 0 0 142 0 0 0] 193 1072 8 '&Search' 1040 626 #isEnabled: 8 #(false) 1040 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 nil nil 410 ##(Smalltalk.StaticText) 34 16 nil 880 34 2 8 1140850944 1 1424 nil nil nil 517 nil nil nil 1424 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 562 138 144 34 2 626 #createWindow: 34 1 674 706 8 #[5 0 0 0 5 0 0 0 95 0 0 0 112 0 0 0] 193 1456 nil 1424 626 #text: 34 1 8 '` = meta var
@ = list
`` = recurse into
. = statement
# = literal
; = cascade list
{ = use a block' 1424 3 8 #() 1394 193 193 nil 27 170 192 528 590342 ##(Smalltalk.Rectangle) 1394 11 11 1394 11 11 562 138 144 34 1 626 #createWindow: 34 1 674 706 8 #[129 1 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 193 912 8 '' 880 3 34 2 1424 1040 1394 193 193 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 784 34 2 8 1143017796 262145 2000 nil 1120 nil 5 nil nil nil 2000 nil 8 1759000288 1506 nil nil 9 562 138 144 34 2 626 #createWindow: 34 1 674 706 8 #[0 0 0 0 0 0 0 0 129 1 0 0 147 0 0 0] 193 2032 nil 2000 626 #setMarginWidths: 34 1 8 #(3 3) 2000 3 8 #() 1394 193 193 nil 27 170 192 34 2 2000 8 'searchText' nil 562 138 144 34 1 626 #createWindow: 34 1 674 706 8 #[0 0 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 193 816 8 '' 784 3 34 2 2000 880 1394 193 193 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2528 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2528 nil 1 #left nil nil nil 1394 1 1 1394 9 9 nil 2624 nil 562 138 144 34 1 626 #createWindow: 34 1 674 706 8 #[0 0 0 0 147 0 0 0 229 1 0 0 152 0 0 0] 193 2560 8 '' 2528 3 8 #() 1394 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131137 2832 nil nil nil 5 nil nil nil 2832 850 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2832 34 2 8 1140850688 131073 2912 nil nil nil 5 nil 946 nil true 978 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2912 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 2 410 ##(Smalltalk.CheckBox) 34 16 nil 2912 34 2 8 1140924419 1 3088 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 3088 nil 8 1759007584 1506 nil nil nil 562 138 144 34 1 626 #createWindow: 34 1 674 706 8 #[5 0 0 0 0 0 0 0 90 0 0 0 35 0 0 0] 193 3120 8 'Match whole method?' 3088 3 8 #() 1394 193 193 nil 27 8 'isMethod' 1762 1394 11 1 1394 1 1 562 138 144 34 1 626 #createWindow: 34 1 674 706 8 #[129 1 0 0 0 0 0 0 229 1 0 0 148 0 0 0] 193 2944 8 '' 2912 3 34 4 3088 410 ##(Smalltalk.PushButton) 34 20 nil 2912 34 2 8 1140924416 1 3648 nil 1120 nil 5 nil nil nil 3648 nil 8 1759007584 1154 #replace 8 '&Replace...' 1 1 nil nil false nil nil nil 562 138 144 34 2 626 #createWindow: 34 1 674 706 8 #[5 0 0 0 40 0 0 0 95 0 0 0 65 0 0 0] 193 3680 8 '&Replace...' 3648 626 #isEnabled: 8 #(false) 3648 3 8 #() 1394 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 2912 34 2 8 1140924416 1 3968 nil 1120 nil 5 nil nil nil 3968 nil 8 1759007584 1154 #transform 8 '&Transform...' 1 1 nil nil false nil nil nil 562 138 144 34 2 626 #createWindow: 34 1 674 706 8 #[5 0 0 0 70 0 0 0 95 0 0 0 95 0 0 0] 193 4000 8 '&Transform...' 3968 626 #isEnabled: 8 #(false) 3968 3 8 #() 1394 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 2912 34 2 8 1140924416 1 4288 nil 1120 nil 5 nil nil nil 4288 nil 8 1759007584 1154 #renameMethodArgument 8 '&Rename Arg...' 1 1 nil nil false nil nil nil 562 138 144 34 2 626 #createWindow: 34 1 674 706 8 #[5 0 0 0 100 0 0 0 95 0 0 0 125 0 0 0] 193 4320 8 '&Rename Arg...' 4288 626 #isEnabled: 8 #(false) 4288 3 8 #() 1394 193 193 nil 29 1394 193 193 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 2832 34 2 8 1143017796 262145 4624 nil 1120 nil 5 nil nil nil 4624 nil 8 1759000288 1506 nil nil 9 562 138 144 34 2 626 #createWindow: 34 1 674 706 8 #[0 0 0 0 0 0 0 0 129 1 0 0 148 0 0 0] 193 4656 nil 4624 626 #setMarginWidths: 34 1 8 #(3 3) 4624 3 8 #() 1394 193 193 nil 27 170 192 34 2 4624 8 'replaceText' nil 562 138 144 34 1 626 #createWindow: 34 1 674 706 8 #[0 0 0 0 152 0 0 0 229 1 0 0 44 1 0 0] 193 2864 8 '' 2832 3 34 2 4624 2912 1394 193 193 nil 27 1394 193 193 nil 27 )! !

!CodeRewriterPlugin class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

