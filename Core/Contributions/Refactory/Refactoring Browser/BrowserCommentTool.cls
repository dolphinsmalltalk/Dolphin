"Filed out from Dolphin Smalltalk 2000 release 4.01"!

BrowserTextTool subclass: #BrowserCommentTool
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserCommentTool comment: ''!

BrowserCommentTool guid: (GUID fromString: '{A8B6C1C3-0E73-11D5-B80B-000102677BBF}')!

!BrowserCommentTool categoriesForClass!Unclassified! !
!BrowserCommentTool methodsFor!

accept
	| items isApplication |
	items := self selectedEnvyItems.
	isApplication := self className isNil.
	items do: 
			[:each | 
			isApplication
				ifTrue: [each applicationComment: self text]
				ifFalse: [each comment: self text]].
	self updateContents!

defaultComment
	| commentStream class vars typer |
	class := self nonMetaClass.
	typer := (RefactoryTyper new)
				runOn: class;
				yourself.
	commentStream := WriteStream on: String new.
	commentStream
		nextPutAll: class name;
		nextPutAll: ' has not been commented.';
		nextPutAll: '  The comment should state the purpose of the class and also explain any unobvious aspects of the implementation.';
		cr;
		cr.
	self printSubclassResponsibilitiesFor: class on: commentStream.
	vars := class instVarNames.
	vars isEmpty 
		ifFalse: 
			[commentStream
				nextPutAll: 'Instance Variables:';
				cr.
			self 
				printVariables: vars
				types: typer
				on: commentStream].
	vars := class classVarNames.
	vars isEmpty 
		ifFalse: 
			[commentStream
				nextPutAll: 'Class Variables:';
				cr.
			self 
				printVariables: vars
				types: typer
				on: commentStream].
	^commentStream contents!

generateDefaultComment
	self textNoChange: self defaultComment!

isEnabled
	^self selectedEnvyItem notNil!

printSubclassResponsibilitiesFor: class on: commentStream 
	| protocols selectors |
	selectors := class whichSelectorsReferTo: 'subclassResponsibility' asSymbol.
	selectors isEmpty ifTrue: [^self].
	commentStream
		nextPutAll: 'Subclasses must implement the following messages:';
		cr.
	protocols := (selectors
				collect: [:each | BrowserEnvironment new whichProtocolIncludes: each in: class])
					asSet asSortedCollection.
	selectors := selectors asSortedCollection.
	protocols do: 
			[:protocol | 
			commentStream tab;
				nextPutAll: protocol;
				cr.
			selectors do: 
					[:sel | 
					protocol == (BrowserEnvironment new whichProtocolIncludes: sel in: class)
						ifTrue: 
							[commentStream tab;
								tab;
								nextPutAll: sel;
								cr]]].
	commentStream cr!

printVariables: vars types: aRefactoryTyper on: commentStream 
	vars asSortedCollection do: 
			[:each | 
			commentStream
				tab;
				nextPutAll: each;
				tab;
				nextPut: $<.
			aRefactoryTyper printTypeFor: each on: commentStream.
			commentStream
				nextPutAll: '>	description of ';
				nextPutAll: each;
				cr].
	commentStream cr!

updateContents
	| item comment |
	item := self selectedEnvyItem.
	item isNil ifTrue: [^self text: 'Cannot comment protocols, but you can use this as a workspace.'].
	comment := self className isNil
				ifTrue: [item applicationComment]
				ifFalse: [item comment].
	(comment isEmpty and: [self selector isNil and: [self className notNil]])
		ifTrue: [comment := self defaultComment].
	self text: (comment isEmpty ifTrue: ['Enter a comment'] ifFalse: [comment])! !
!BrowserCommentTool categoriesFor: #accept!*-unclassified!public! !
!BrowserCommentTool categoriesFor: #defaultComment!*-unclassified!public! !
!BrowserCommentTool categoriesFor: #generateDefaultComment!*-unclassified!public! !
!BrowserCommentTool categoriesFor: #isEnabled!*-unclassified!public! !
!BrowserCommentTool categoriesFor: #printSubclassResponsibilitiesFor:on:!*-unclassified!public! !
!BrowserCommentTool categoriesFor: #printVariables:types:on:!*-unclassified!public! !
!BrowserCommentTool categoriesFor: #updateContents!*-unclassified!public! !

!BrowserCommentTool class methodsFor!

menu
	^MenuHolder 
		fromSpec: #(#('&Find' '&Replace' '&Find/Replace...' nil '&Undo' 'Redo' nil '&Copy' 'Cu&t' '&Paste' nil '&Do It' 'Pri&nt It' '&Inspect It' nil '&Accept' 'Cancel' nil 'Default Co&mment' nil 'Print') #(#find #replace #findReplace nil #undo #redo nil #copySelection #cut #paste nil #doIt #printIt #inspectIt nil #accept #cancelText nil #generateDefaultComment nil #hardcopy))! !
!BrowserCommentTool class categoriesFor: #menu!*-compilation failures!*-unclassified!public! !

