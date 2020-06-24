"Filed out from Dolphin Smalltalk 7"!

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
		rewrite: {{searchText. replaceText}}
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
		createParseTreeRule: {self searchText}
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
!CodeRewriterPlugin categoriesFor: #browseRuleResults:!helpers!private! !
!CodeRewriterPlugin categoriesFor: #buildReplaceRule!commands!private! !
!CodeRewriterPlugin categoriesFor: #buildSearchRule!helpers!private! !
!CodeRewriterPlugin categoriesFor: #captionText:!helpers!private! !
!CodeRewriterPlugin categoriesFor: #createComponents!initializing!public! !
!CodeRewriterPlugin categoriesFor: #defaultHelpId!public! !
!CodeRewriterPlugin categoriesFor: #displayOn:!displaying!public! !
!CodeRewriterPlugin categoriesFor: #queryCommand:!commands!private! !
!CodeRewriterPlugin categoriesFor: #renameMethodArgument!commands!public! !
!CodeRewriterPlugin categoriesFor: #replace!commands!public! !
!CodeRewriterPlugin categoriesFor: #replaceText!accessing!private! !
!CodeRewriterPlugin categoriesFor: #search!commands!public! !
!CodeRewriterPlugin categoriesFor: #searchText!accessing!private! !
!CodeRewriterPlugin categoriesFor: #transform!commands!public! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 528 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 674 971 601 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 100 9 0 0 54 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 784 nil nil nil 5 nil nil nil 784 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 784 34 2 8 1140850688 131073 880 nil nil nil 5 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 880 850 1 11 nil 410 ##(Smalltalk.PushButton) 34 20 nil 880 34 2 8 1140924416 1 1056 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1056 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #search 8 '&Search' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 11 235 674 181 51 1056 626 #isEnabled: 8 #(false) 1056 626 #text: 34 1 8 '&Search' 1056 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 117 0 0 0 95 0 0 0 142 0 0 0] 8 #() 674 193 193 nil 29 nil nil 410 ##(Smalltalk.StaticText) 34 16 nil 880 34 2 8 1140850944 1 1472 nil nil nil 517 nil nil nil 1472 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 11 11 674 181 215 1472 626 #text: 34 1 8 '` = meta var
@ = list
`` = recurse into
. = statement
# = literal
; = cascade list
{ = use a block' 1472 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 95 0 0 0 112 0 0 0] 8 #() 1456 nil 27 170 192 528 590342 ##(Smalltalk.Rectangle) 674 11 11 674 11 11 562 138 144 34 1 626 #createAt:extent: 34 2 674 771 1 674 201 295 880 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 34 2 1472 1056 1456 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 784 34 2 8 1143017796 262145 2032 nil 1136 nil 5 nil nil nil 2032 nil 8 1903872368 1554 nil nil 9 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 1 674 771 295 2032 626 #setMarginWidths: 34 1 8 #(3 3) 2032 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 147 0 0 0] 8 #() 1456 nil 27 170 192 34 2 2032 8 'searchText' nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 1 674 971 295 784 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 34 2 2032 880 1456 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2544 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2544 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 2640 nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 295 674 971 11 2544 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 147 0 0 0 229 1 0 0 152 0 0 0] 8 #() 1456 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131137 2832 nil nil nil 5 nil nil nil 2832 850 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2832 34 2 8 1140850688 131073 2912 nil nil nil 5 nil 946 nil true 978 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1024 nil 2912 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 2 410 ##(Smalltalk.CheckBox) 34 16 nil 2912 34 2 8 1140924419 1 3088 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 3088 nil 8 1903885040 1554 nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 11 1 674 171 71 3088 626 #text: 34 1 8 'Match whole method?' 3088 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 90 0 0 0 35 0 0 0] 8 #() 1456 nil 27 8 'isMethod' 1810 674 11 1 674 1 1 562 138 144 34 1 626 #createAt:extent: 34 2 674 771 1 674 201 297 2912 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 148 0 0 0] 34 4 3088 410 ##(Smalltalk.PushButton) 34 20 nil 2912 34 2 8 1140924416 1 3680 nil 1136 nil 5 nil nil nil 3680 nil 8 1903885040 1170 #replace 8 '&Replace...' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 11 81 674 181 51 3680 626 #isEnabled: 8 #(false) 3680 626 #text: 34 1 8 '&Replace...' 3680 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 40 0 0 0 95 0 0 0 65 0 0 0] 8 #() 1456 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 2912 34 2 8 1140924416 1 4032 nil 1136 nil 5 nil nil nil 4032 nil 8 1903885040 1170 #transform 8 '&Transform...' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 11 141 674 181 51 4032 626 #isEnabled: 8 #(false) 4032 626 #text: 34 1 8 '&Transform...' 4032 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 95 0 0 0 95 0 0 0] 8 #() 1456 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 2912 34 2 8 1140924416 1 4384 nil 1136 nil 5 nil nil nil 4384 nil 8 1903885040 1170 #renameMethodArgument 8 '&Rename Arg...' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 11 201 674 181 51 4384 626 #isEnabled: 8 #(false) 4384 626 #text: 34 1 8 '&Rename Arg...' 4384 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 100 0 0 0 95 0 0 0 125 0 0 0] 8 #() 1456 nil 29 1456 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 2832 34 2 8 1143017796 262145 4736 nil 1136 nil 5 nil nil nil 4736 nil 8 1903872368 1554 nil nil 9 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 1 674 771 297 4736 626 #setMarginWidths: 34 1 8 #(3 3) 4736 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 148 0 0 0] 8 #() 1456 nil 27 170 192 34 2 4736 8 'replaceText' nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 305 674 971 297 2832 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 152 0 0 0 229 1 0 0 44 1 0 0] 34 2 4736 2912 1456 nil 27 1456 nil 27 )! !
!CodeRewriterPlugin class categoriesFor: #icon!constants!public! !
!CodeRewriterPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

