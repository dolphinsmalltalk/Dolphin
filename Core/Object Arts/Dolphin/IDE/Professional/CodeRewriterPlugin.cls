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
	rules := (MethodCategory name: 'transformations') 
				methodsInBehavior: TransformationRule class.
	rules := (rules collect: [:each | TransformationRule perform: each selector]) asSortedCollection: [:a :b | a displayString < b displayString].
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 0 16 234 256 592 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 754 971 601 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 92 7 0 0 54 1 0 0] 98 3 410 432 98 15 0 416 98 2 8 1140850688 131073 864 0 498 528 0 5 0 0 0 864 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 410 432 98 15 0 864 98 2 8 1140850688 131073 976 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 97 104 111 109 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 976 946 1 11 0 410 8 ##(Smalltalk.PushButton)  98 17 0 976 98 2 8 1140924416 1 1184 0 498 528 0 5 0 0 0 1184 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #search 8 '&Search' 1 1 0 0 32 626 202 208 98 3 690 720 98 2 754 11 235 754 171 51 1184 690 8 #isEnabled: 98 1 32 1184 690 8 #text: 98 1 8 '&Search' 1184 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 117 0 0 0 90 0 0 0 142 0 0 0] 98 0 754 193 193 0 27 0 0 410 8 ##(Smalltalk.StaticText)  98 16 0 976 98 2 8 1140850944 1 1648 0 0 0 517 0 0 0 1648 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 626 202 208 98 2 690 720 98 2 754 11 11 754 171 215 1648 690 1536 98 1 8 '` = meta var
@ = list
`` = recurse into
. = statement
# = literal
; = cascade list
{ = use a block' 1648 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 90 0 0 0 112 0 0 0] 98 0 1632 0 27 234 256 592 590342 ##(Smalltalk.Rectangle)  754 11 11 754 11 11 626 202 208 98 1 690 720 98 2 754 781 1 754 191 295 976 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 1 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 98 2 1648 1184 1632 0 27 0 410 8 ##(Smalltalk.MultilineTextEdit)  98 16 0 864 98 2 8 1143017796 1025 2224 0 498 528 0 5 0 0 0 2224 0 8 4294903807 1746 0 0 9 626 202 208 98 4 690 720 98 2 754 1 1 754 781 295 2224 690 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 2224 690 8 #isTextModified: 98 1 32 2224 690 8 #setMarginWidths: 98 1 98 2 7 7 2224 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 134 1 0 0 147 0 0 0] 98 0 1632 0 27 234 256 98 2 2224 8 'searchText' 0 626 202 208 98 1 690 720 98 2 754 1 1 754 971 295 864 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 98 2 2224 976 1632 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 2912 0 498 528 0 517 0 0 0 2912 626 202 208 98 1 690 720 98 2 754 1 295 754 971 11 2912 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 147 0 0 0 229 1 0 0 152 0 0 0] 98 0 1632 0 27 410 432 98 15 0 416 98 2 8 1140850688 131137 3168 0 498 528 0 5 0 0 0 3168 946 1 1 0 0 410 432 98 15 0 3168 98 2 8 1140850688 131073 3264 0 1042 31 0 5 0 1074 0 16 1106 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 97 104 111 109 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 3264 656198 1 ##(Smalltalk.FlowLayout)  1 11 1 234 256 98 2 410 8 ##(Smalltalk.CheckBox)  98 16 0 3264 98 2 8 1140924419 1 3472 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 498 528 0 5 0 0 0 3472 0 8 4294903631 1746 0 0 0 626 202 208 98 2 690 720 98 2 754 11 1 754 171 71 3472 690 1536 98 1 8 'Match whole method?' 3472 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 90 0 0 0 35 0 0 0] 98 0 1632 0 27 8 'isMethod' 2002 754 11 1 754 1 1 626 202 208 98 1 690 720 98 2 754 781 1 754 191 297 3264 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 1 0 0 0 0 0 0 229 1 0 0 148 0 0 0] 98 4 3472 410 1200 98 17 0 3264 98 2 8 1140924416 1 4096 0 498 528 0 5 0 0 0 4096 0 8 4294903631 1298 8 #replace 8 '&Replace...' 1 1 0 0 32 626 202 208 98 3 690 720 98 2 754 11 81 754 161 51 4096 690 1488 98 1 32 4096 690 1536 98 1 8 '&Replace...' 4096 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 40 0 0 0 85 0 0 0 65 0 0 0] 98 0 1632 0 27 410 1200 98 17 0 3264 98 2 8 1140924416 1 4480 0 498 528 0 5 0 0 0 4480 0 8 4294903631 1298 8 #transform 8 '&Transform...' 1 1 0 0 32 626 202 208 98 3 690 720 98 2 754 11 141 754 161 51 4480 690 1488 98 1 32 4480 690 1536 98 1 8 '&Transform...' 4480 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 85 0 0 0 95 0 0 0] 98 0 1632 0 27 410 1200 98 17 0 3264 98 2 8 1140924416 1 4864 0 498 528 0 5 0 0 0 4864 0 8 4294903631 1298 8 #renameMethodArgument 8 '&Rename Arg...' 1 1 0 0 32 626 202 208 98 3 690 720 98 2 754 11 201 754 161 51 4864 690 1488 98 1 32 4864 690 1536 98 1 8 '&Rename Arg...' 4864 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 100 0 0 0 85 0 0 0 125 0 0 0] 98 0 1632 0 27 1632 0 27 0 410 2240 98 16 0 3168 98 2 8 1143017796 1025 5248 0 498 528 0 5 0 0 0 5248 0 8 4294903807 1746 0 0 9 626 202 208 98 4 690 720 98 2 754 1 1 754 781 297 5248 690 2480 98 1 2514 3 1 3 5248 690 2560 98 1 32 5248 690 2608 98 1 98 2 7 7 5248 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 134 1 0 0 148 0 0 0] 98 0 1632 0 27 234 256 98 2 5248 8 'replaceText' 0 626 202 208 98 1 690 720 98 2 754 1 305 754 971 297 3168 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 152 0 0 0 229 1 0 0 44 1 0 0] 98 2 5248 3264 1632 0 27 1632 0 27 )! !
!CodeRewriterPlugin class categoriesFor: #icon!constants!public! !
!CodeRewriterPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

