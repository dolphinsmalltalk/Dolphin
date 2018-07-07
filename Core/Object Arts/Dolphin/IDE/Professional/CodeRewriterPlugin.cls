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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 576 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 722 971 601 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 100 9 0 0 54 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 832 nil 482 512 nil 5 nil nil nil 832 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 832 34 2 8 1140850688 131073 944 nil 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 722 193 193 nil 944 914 1 11 nil 410 ##(Smalltalk.PushButton) 34 20 nil 944 34 2 8 1140924416 1 1152 nil 482 512 nil 5 nil nil nil 1152 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #search 8 '&Search' 1 1 nil nil false nil nil nil 610 138 144 34 3 674 #createAt:extent: 34 2 722 11 235 722 181 51 1152 674 #isEnabled: 8 #(false) 1152 674 #text: 34 1 8 '&Search' 1152 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 117 0 0 0 95 0 0 0 142 0 0 0] 8 #() 722 193 193 nil 29 nil nil 410 ##(Smalltalk.StaticText) 34 16 nil 944 34 2 8 1140850944 1 1552 nil nil nil 517 nil nil nil 1552 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil nil 610 138 144 34 2 674 #createAt:extent: 34 2 722 11 11 722 181 215 1552 674 #text: 34 1 8 '` = meta var
@ = list
`` = recurse into
. = statement
# = literal
; = cascade list
{ = use a block' 1552 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 95 0 0 0 112 0 0 0] 8 #() 1536 nil 27 170 192 576 590342 ##(Smalltalk.Rectangle) 722 11 11 722 11 11 610 138 144 34 1 674 #createAt:extent: 34 2 722 771 1 722 201 295 944 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 34 2 1552 1152 1536 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 832 34 2 8 1143017796 1025 2112 nil 482 512 nil 5 nil nil nil 2112 nil 8 1906818384 1634 nil nil 9 610 138 144 34 2 674 #createAt:extent: 34 2 722 1 1 722 771 295 2112 674 #setMarginWidths: 34 1 8 #(3 3) 2112 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 147 0 0 0] 8 #() 1536 nil 27 170 192 34 2 2112 8 'searchText' nil 610 138 144 34 1 674 #createAt:extent: 34 2 722 1 1 722 971 295 832 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 1 0 0 147 0 0 0] 34 2 2112 944 1536 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2640 nil 482 512 nil 517 nil nil nil 2640 610 138 144 34 1 674 #createAt:extent: 34 2 722 1 295 722 971 11 2640 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 147 0 0 0 229 1 0 0 152 0 0 0] 8 #() 1536 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131137 2880 nil 482 512 nil 5 nil nil nil 2880 914 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2880 34 2 8 1140850688 131073 2976 nil 1010 31 nil 5 nil 1042 nil true 1074 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1120 nil 2976 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 2 410 ##(Smalltalk.CheckBox) 34 16 nil 2976 34 2 8 1140924419 1 3168 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 482 512 nil 5 nil nil nil 3168 nil 8 1906824432 1634 nil nil nil 610 138 144 34 2 674 #createAt:extent: 34 2 722 11 1 722 171 71 3168 674 #text: 34 1 8 'Match whole method?' 3168 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 90 0 0 0 35 0 0 0] 8 #() 1536 nil 27 8 'isMethod' 1890 722 11 1 722 1 1 610 138 144 34 1 674 #createAt:extent: 34 2 722 771 1 722 201 297 2976 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 129 1 0 0 0 0 0 0 229 1 0 0 148 0 0 0] 34 4 3168 410 ##(Smalltalk.PushButton) 34 20 nil 2976 34 2 8 1140924416 1 3776 nil 482 512 nil 5 nil nil nil 3776 nil 8 1906824432 1250 #replace 8 '&Replace...' 1 1 nil nil false nil nil nil 610 138 144 34 3 674 #createAt:extent: 34 2 722 11 81 722 181 51 3776 674 #isEnabled: 8 #(false) 3776 674 #text: 34 1 8 '&Replace...' 3776 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 40 0 0 0 95 0 0 0 65 0 0 0] 8 #() 1536 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 2976 34 2 8 1140924416 1 4144 nil 482 512 nil 5 nil nil nil 4144 nil 8 1906824432 1250 #transform 8 '&Transform...' 1 1 nil nil false nil nil nil 610 138 144 34 3 674 #createAt:extent: 34 2 722 11 141 722 181 51 4144 674 #isEnabled: 8 #(false) 4144 674 #text: 34 1 8 '&Transform...' 4144 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 95 0 0 0 95 0 0 0] 8 #() 1536 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 2976 34 2 8 1140924416 1 4512 nil 482 512 nil 5 nil nil nil 4512 nil 8 1906824432 1250 #renameMethodArgument 8 '&Rename Arg...' 1 1 nil nil false nil nil nil 610 138 144 34 3 674 #createAt:extent: 34 2 722 11 201 722 181 51 4512 674 #isEnabled: 8 #(false) 4512 674 #text: 34 1 8 '&Rename Arg...' 4512 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 100 0 0 0 95 0 0 0 125 0 0 0] 8 #() 1536 nil 29 1536 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 2880 34 2 8 1143017796 1025 4880 nil 482 512 nil 5 nil nil nil 4880 nil 8 1906818384 1634 nil nil 9 610 138 144 34 2 674 #createAt:extent: 34 2 722 1 1 722 771 297 4880 674 #setMarginWidths: 34 1 8 #(3 3) 4880 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 148 0 0 0] 8 #() 1536 nil 27 170 192 34 2 4880 8 'replaceText' nil 610 138 144 34 1 674 #createAt:extent: 34 2 722 1 305 722 971 297 2880 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 152 0 0 0 229 1 0 0 44 1 0 0] 34 2 4880 2976 1536 nil 27 1536 nil 27 )! !
!CodeRewriterPlugin class categoriesFor: #icon!constants!public! !
!CodeRewriterPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

