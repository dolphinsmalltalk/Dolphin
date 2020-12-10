"Filed out from Dolphin Smalltalk 7"!

UI.Scintilla.Styler subclass: #'Tools.SmalltalkStyler'
	instanceVariableNames: 'arrayDepth view last inTag stack'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkStyler guid: (Core.GUID fromString: '{eb307480-e6d7-4715-934e-59caf9618538}')!
Tools.SmalltalkStyler isNonInstantiable: true!
Tools.SmalltalkStyler comment: 'SmalltalkStyler is a <ScintillaStyler> that is capable of colouring Smalltalk source text according to the established Dolphin syntax colouring convention; in fact it is somewhat more sophisticated than the earlier compiler based colouring, and can differentiate a larger set of syntactic elements. The text styles emitted are:

#argDecl			Formal parameter name in method signature
#assignment			Assignment token, i.e. :=
#binaryMessage		Selector of binary message send, e.g. the + in 1+2.
#binarySelector		Binary selector in a method signature.
#blockArgDecl		Formal parameter name of a block argument
#comment			Comments
#identifier			Variable references
#illegal				Illegal characters that are not valid in ANSI Smalltalk
#keywordMessage	Each part of a keyword selector in a message send
#keywordSelector	Each part of a keyword selector in a method signature
#literalArray			Opening and closing brackets of a literal array, including the initial #.
#literalBytes			Literal byte array (brackets and values).
#literalCharacter		Character constants, e.g. $A
#literalNumber		Numeric constants, e.g. -1, or 1.2e10
#literalPseudo		The constants nil, true, and false.
#literalString			String constants, e.g. ''abc''
#literalSymbol		Symbolic constants, e.g. #abc
#normal 			Used for whitespace if a #whitespace style is not defined
#specialCharacter	Other characters with syntactice relevance, such as the period used for statement termination, parentheses, block brackets, etc
#tag				Primitive or external call declaration
#tempCloseBar		Closing bar of temporary declarations
#tempDecl			Temporary variable declaration in a method or block.
#tempOpenBar		Opening bar of temporary declarations
#unaryMessage 		Selector of a unary message send.
#unarySelector		Selector of a unary method, in the signature.
#whitespace			Whitespace between tokens (but not in comments or literal strings).

Note that the #whitespace style is optional. If it is not set up in the View, then whitespace is set to the #normal style, but will use the whitespace foreground and background colours configured in the view (if any), although these will only be used when the whitespaceVisibility mode is other than #invisible.

The actual visual styles associated with these classifications can be configured by modifying the view configuration. This is exposed as the #textStyles published aspect of SmalltalkWorkspace.

The colouring is largely based on identification of tokens through lexical analysis. This has three significant advantages over colouring based on syntax analysis: i) it is faster, ii) it can be initiated in the middle of some source text much more easily, iii) it is tolerant of syntax errors. These features allow the colouring to be performed in "real-time" as the user types, and also allow reasonable colouring of very large workspaces. Large amounts of text are coloured in chunks. 

Pure lexical analysis has the drawback that it isn''t able to distinguish between different uses of the same token type. In Smalltalk there are a number of such ambiguities, for example identifiers that might be variable names or unary selectors. Another example is the use of the vertical bar symbol as a temporary declaration delimiter and also as a binary selector. In order to handle these cases efficiently a number of extra style names are introduced to record an informal parse state as the colouring progresses. Since the style set up for the last token (mostly) encodes the parse state, it is possible to style the current token without looking any further back. This does, however, mean that there are more styles than are strictly needed for visual purposes - for example there are styles for opening and closing temp bars, but it is unlikely one would want these to have a different appearance. There is one case, that of literal arrays, where it is necessary to look back further when styling. This is because literal arrays may contain unquoted literal symbols and nester arrays, at least in Smalltalk-80 syntax.
'!
!Tools.SmalltalkStyler categoriesForClass!Kernel-Objects! !
!Tools.SmalltalkStyler methodsFor!

applyStyle: aSymbol toNext: anInteger 
	anInteger < 1 ifTrue: [^self].
	(arrayDepth > 0 or: [aSymbol == #literalArray]) 
		ifTrue: 
			[view 
				setIndicator: self literalArrayIndicatorId
				from: view stylingPosition
				length: anInteger].
	view styleNext: anInteger
		mask: ((view styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id])!

atStart
	^last isNil!

colorComments: aCollection startingAt: anInteger 
	"Note that the anInteger is the start position in the text of the token stream, not the text
	of the view."

	| currentPos |
	currentPos := anInteger.
	aCollection do: 
			[:each | 
			self applyStyle: #whitespace toNext: each start - currentPos.
			currentPos := each stop + 1.
			self applyStyle: #comment toNext: currentPos - each start].
	^currentPos!

colorText: aString in: aScintillaView startingAt: anInteger 
	| scanner currentPos |
	view := aScintillaView.
	arrayDepth := 0.
	stack := OrderedCollection new.
	scanner := self scannerClass on: aString readStream.
	currentPos := self colourTokens: scanner startingAt: anInteger.
	"Colour any remaining comments"
	scanner getComments 
		ifNotNil: [:comments | currentPos := self colorComments: comments startingAt: currentPos].
	"And finally any terminal whitespace up to EOF"
	self applyStyle: #whitespace toNext: aString size - currentPos + 1!

colourBefore: aStToken startingAt: anInteger 
	| position |
	position := self colorComments: aStToken preComments startingAt: anInteger.
	self applyStyle: #whitespace toNext: aStToken start - position!

colourTokens: aSmalltalkScanner startingAt: anInteger 
	| position offset |
	position := 1.
	offset := anInteger - 1.
	last := self tokenBefore: offset.
	[aSmalltalkScanner atEnd] whileFalse: 
			[| nextAfter aStToken styleName |
			aStToken := aSmalltalkScanner next.
			self colourBefore: aStToken startingAt: position.
			nextAfter := aStToken stop + 1.
			styleName := self styleForToken: aStToken.
			self applyStyle: styleName toNext: nextAfter - aStToken start.
			position := self colorComments: aStToken postComments startingAt: nextAfter.
			last := aStToken sourceInterval + offset -> styleName].
	^position!

initialBinaryStyle: aStBinarySelectorToken 
	^self subclassResponsibility!

initialize
	arrayDepth := 0.
	inTag := false.
	stack := OrderedCollection new!

initialKeywordStyle
	^self subclassResponsibility!

initialLiteralStyle: aStLiteralToken 
	^aStLiteralToken textStyle!

initialUnaryStyle
	^self subclassResponsibility!

isInArray
	^arrayDepth > 0 and: [stack last isLiteralArrayToken]!

isLiteralArrayAt: anInteger in: aScintillaView 
	^aScintillaView isIndicator: self literalArrayIndicatorId setAt: anInteger!

lastCharacter
	"Private - Answer the last styled character."

	^view characterAt: last key stop!

lastIsLiteralByte
	^self lastStyle == #literalBytes and: [self lastCharacter ~~ $]]!

lastIsSpecial: aCharacter 
	^self lastStyle == #specialCharacter and: [self lastCharacter == aCharacter]!

lastIsStyle: aSymbol char: aCharacter 
	^self lastStyle == aSymbol and: [self lastCharacter == aCharacter]!

lastIsStyle: aSymbol chars: aString 
	^self lastStyle == aSymbol and: [aString identityIncludes: self lastCharacter]!

lastStyle
	^last ifNotNil: [last value]!

lastToken
	^view plainTextRange: last key!

literalArrayIndicatorId
	^INDICATOR_CONTAINER - 1!

prepareToStyleView: aScintillaView 
	"The receiver has been set up as the styler for the specified <ScintillaView>. This is an
	opportunity to initialise that view appropriately for this styler."

	"Set up the Smalltalk brace chars grouped into the various styles used by the receiver."

	aScintillaView braceChars: ##((IdentityDictionary new)
				at: #specialCharacter put: '()[]<>';
				at: #literalBytes put: '[]';
				at: #literalArray put: '()';
				yourself)!

resetStylingIn: aScintillaView from: startInteger to: stopInteger 
	super 
		resetStylingIn: aScintillaView
		from: startInteger
		to: stopInteger.
	aScintillaView 
		clearIndicator: self literalArrayIndicatorId
		from: startInteger
		to: stopInteger!

scannerClass
	^SmalltalkStylingScanner!

styleForBar
	| lastStyle |
	lastStyle := self lastStyle.
	lastStyle == #specialCharacter 
		ifTrue: 
			[^(self lastCharacter == $[ or: [self lastToken = '##(']) 
				ifTrue: [#tempOpenBar]
				ifFalse: [#binaryMessage]].
	^##((IdentityDictionary new)
		at: #tempOpenBar put: #tempCloseBar;
		at: #tempDecl put: #tempCloseBar;
		at: #blockArgDecl put: #tempCloseBar;
		at: #argDecl put: #tempOpenBar;
		at: #unarySelector put: #tempOpenBar;
		at: #tempCloseBar put: #tempOpenBar;
		shrink;
		yourself) at: lastStyle ifAbsent: [#binaryMessage]!

styleForToken: aStToken 
	inTag 
		ifTrue: 
			[(aStToken isBinary and: [#(#> #*> #**>) includes: aStToken value]) ifTrue: [inTag := false].
			^#tag].
	^aStToken acceptVisitor: self!

stylingStartBefore: startInteger in: aScintillaView 
	"Private - Locate the position before the <integer>, startInteger, from which to start styling in the
	<ScintillaView>, aScintillaView. This needs to be a position from which we can safely start
	the scanner from its start state."

	| start arrayRange |
	start := super stylingStartBefore: startInteger in: aScintillaView.
	arrayRange := aScintillaView rangeOfIndicator: self literalArrayIndicatorId at: start.
	^arrayRange isEmpty 
		ifTrue: 
			[| styleMask |
			styleMask := aScintillaView styleIdAt: start.
			inTag := (aScintillaView styleNamed: #tag) ifNil: [false] ifNotNil: [:style | style id = styleMask].
			start]
		ifFalse: 
			["If the start token is inside a literal array, we must start styling from
			 the start of that array. This is the one case where significant look back
			 might be required (because of literal array nesting)."
			arrayRange start]!

tokenBefore: anInteger 
	| start id white comment stop |
	anInteger < 1 ifTrue: [^nil].
	start := anInteger.
	id := nil.
	white := view idOfStyleNamed: #whitespace.
	comment := view idOfStyleNamed: #comment.
	
	[id := view styleIdAt: start.
	id == comment or: [id == white and: [(view characterAt: start) isSeparator]]] 
			whileTrue: 
				[start := start - 1.
				start == 0 ifTrue: [^nil]].
	stop := start.
	[(start := start - 1) == 0 or: [(view styleIdAt: start) ~~ id]] whileFalse.
	^(start + 1 to: stop) -> (view styleWithId: id) name!

visitAssignmentToken: aStAssignmentToken
	^#assignment!

visitBinarySelectorToken: aStBinarySelectorToken
	| lastStyle selector |
	self atStart ifTrue: [^self initialBinaryStyle: aStBinarySelectorToken].
	self isInArray ifTrue: [^#literalSymbol].
	selector := aStBinarySelectorToken value.
	selector == #| ifTrue: [^self styleForBar].
	lastStyle := self lastStyle.
	selector == #<
		ifTrue: 
			[^(lastStyle == #unarySelector or: [lastStyle == #argDecl or: [lastStyle == #tempCloseBar]])
				ifTrue: 
					[inTag := true.
					#tag]
				ifFalse: [#binaryMessage]].
	"The scanner may have wrongly interpreted adjacent temp open/close bars as a binary
	selector. If it has we must emit appropriate bar styling, and then hack the token to include
	only the last bar."
	selector == #'||'
		ifTrue: 
			[lastStyle == #blockArgDecl
				ifTrue: 
					[self applyStyle: #tempCloseBar toNext: 1.
					aStBinarySelectorToken start: aStBinarySelectorToken start + 1.
					^#tempOpenBar].
			(lastStyle == #tempCloseBar or: 
					[lastStyle == #argDecl
						or: [lastStyle == #unarySelector or: [lastStyle == #specialCharacter and: [self lastToken = '##(']]]])
				ifTrue: 
					[self applyStyle: #tempOpenBar toNext: 1.
					aStBinarySelectorToken start: aStBinarySelectorToken start + 1.
					^#tempCloseBar]].
	(selector == #||| and: [lastStyle == #blockArgDecl])
		ifTrue: 
			[self
				applyStyle: #tempCloseBar toNext: 1;
				applyStyle: #tempOpenBar toNext: 1.
			aStBinarySelectorToken start: aStBinarySelectorToken stop.
			^#tempCloseBar].
	^#binaryMessage!

visitErrorToken: aStErrorToken
	^#illegal!

visitIdentifierToken: aStIdentifierToken
	| lastStyle |
	self atStart ifTrue: [^self initialUnaryStyle].
	self isInArray ifTrue: [^#literalSymbol].
	lastStyle := self lastStyle.
	lastStyle == #specialCharacter
		ifTrue: 
			[| char |
			char := self lastCharacter.
			char == $: ifTrue: [^#blockArgDecl].
			(');]}' includes: char) ifTrue: [^#unaryMessage].
			^#identifier].
	^##(IdentityDictionary new
		at: #identifier put: #unaryMessage;
		at: #unaryMessage put: #unaryMessage;
		at: #literalPseudo put: #unaryMessage;
		at: #literalString put: #unaryMessage;
		at: #literalNumber put: #unaryMessage;
		at: #literalCharacter put: #unaryMessage;
		at: #literalSymbol put: #unaryMessage;
		at: #literalBytes put: #unaryMessage;
		at: #literalBindingReference put: #unaryMessage;
		at: #tempOpenBar put: #tempDecl;
		at: #tempDecl put: #tempDecl;
		at: #keywordSelector put: #argDecl;
		at: #binarySelector put: #argDecl;
		at: #literalArray put: #unaryMessage;
		shrink;
		yourself) at: lastStyle ifAbsent: [#identifier]!

visitIllegalCharacterToken: anStIllegalCharacterToken
	^#illegal!

visitKeywordToken: aStKeywordToken
	self atStart ifTrue: [^self initialKeywordStyle].
	self isInArray ifTrue: [^#literalSymbol].
	^(self lastStyle == #argDecl or: [self lastIsSpecial: $!!])
		ifTrue: [#keywordSelector]
		ifFalse: [#keywordMessage]!

visitLiteralArrayToken: aStLiteralArrayToken
	^aStLiteralArrayToken isForByteArray
		ifTrue: [#literalBytes]
		ifFalse: 
			[arrayDepth := arrayDepth + 1.
			stack addLast: aStLiteralArrayToken.
			#literalArray]!

visitLiteralToken: aStLiteralToken
	self atStart ifTrue: [^self initialLiteralStyle: aStLiteralToken].
	^aStLiteralToken textStyle!

visitNumberLiteralToken: aStNumberLiteralToken
	self atStart ifTrue: [^#literalNumber].
	self lastIsLiteralByte ifTrue: [^#literalBytes].
	self isInArray ifTrue: [^#literalNumber].
	"Handle 'x-1' ambiguity: invalid: binary selector, block arg decl, keyword selector, literal
	array start, static start, temp decl, temp open must be a literal if previous was keyword
	message, period, hat, assignment, binary message, arg decl, close temp, unary selector can
	be a message if previous was: literal (of any sort), identifier, special: paren, special:
	block paren, unaryMessage"
	(aStNumberLiteralToken isNegative and: 
			[(#(#identifier #literalPseudo #literalNumber #literalString #literalCharacter #literalArray #literalBytes #literalSymbol #unaryMessage)
				identityIncludes: self lastStyle) or: [self lastIsStyle: #specialCharacter chars: '])']])
		ifTrue: 
			[self applyStyle: #binaryMessage toNext: 1.
			aStNumberLiteralToken start: aStNumberLiteralToken start + 1].
	^#literalNumber!

visitOptimizedToken: aStOptimizedToken
	stack addLast: aStOptimizedToken.
	^#specialCharacter!

visitQualifiedReferenceToken: aStQualifiedReferenceToken
	"We should never actually get here because the SmalltalkStylingScanner scans literal binding refs as literal tokens."
	^#specialCharacter!

visitSpecialCharacterToken: aStSpecialCharacterToken
	"Special case for Smalltalk-80 literal syntax, which allows nested arrays in literal arrays to be unquoted."

	| char |
	char := aStSpecialCharacterToken value.
	char == $(
		ifTrue: 
			[^self isInArray
				ifTrue: 
					[stack addLast: (StLiteralArrayToken
								start: aStSpecialCharacterToken start
								comments: nil
								value: '(').
					arrayDepth := arrayDepth + 1.
					#literalArray]
				ifFalse: 
					[stack addLast: aStSpecialCharacterToken.
					#specialCharacter]].
	char == $)
		ifTrue: 
			[(stack removeLastIfAbsent: [])
				ifNotNil: 
					[:token |
					token isLiteralArrayToken
						ifTrue: 
							[arrayDepth := arrayDepth - 1.
							^#literalArray]].
			^#specialCharacter].
	(char == $] and: [self lastIsLiteralByte]) ifTrue: [^#literalBytes].
	^#specialCharacter! !
!Tools.SmalltalkStyler categoriesFor: #applyStyle:toNext:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #atStart!private!testing! !
!Tools.SmalltalkStyler categoriesFor: #colorComments:startingAt:!operations!private! !
!Tools.SmalltalkStyler categoriesFor: #colorText:in:startingAt:!operations!private! !
!Tools.SmalltalkStyler categoriesFor: #colourBefore:startingAt:!operations!private! !
!Tools.SmalltalkStyler categoriesFor: #colourTokens:startingAt:!operations!private! !
!Tools.SmalltalkStyler categoriesFor: #initialBinaryStyle:!constants!private! !
!Tools.SmalltalkStyler categoriesFor: #initialize!initializing!private! !
!Tools.SmalltalkStyler categoriesFor: #initialKeywordStyle!constants!private! !
!Tools.SmalltalkStyler categoriesFor: #initialLiteralStyle:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #initialUnaryStyle!constants!private! !
!Tools.SmalltalkStyler categoriesFor: #isInArray!private!testing! !
!Tools.SmalltalkStyler categoriesFor: #isLiteralArrayAt:in:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #lastCharacter!accessing!private! !
!Tools.SmalltalkStyler categoriesFor: #lastIsLiteralByte!private!testing! !
!Tools.SmalltalkStyler categoriesFor: #lastIsSpecial:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #lastIsStyle:char:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #lastIsStyle:chars:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #lastStyle!accessing!private! !
!Tools.SmalltalkStyler categoriesFor: #lastToken!accessing!private! !
!Tools.SmalltalkStyler categoriesFor: #literalArrayIndicatorId!constants!private! !
!Tools.SmalltalkStyler categoriesFor: #prepareToStyleView:!initializing!public! !
!Tools.SmalltalkStyler categoriesFor: #resetStylingIn:from:to:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #scannerClass!constants!private! !
!Tools.SmalltalkStyler categoriesFor: #styleForBar!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #styleForToken:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #stylingStartBefore:in:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #tokenBefore:!helpers!private! !
!Tools.SmalltalkStyler categoriesFor: #visitAssignmentToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitBinarySelectorToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitErrorToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitIdentifierToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitIllegalCharacterToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitKeywordToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitLiteralArrayToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitLiteralToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitNumberLiteralToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitOptimizedToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitQualifiedReferenceToken:!public!visiting! !
!Tools.SmalltalkStyler categoriesFor: #visitSpecialCharacterToken:!public!visiting! !

Tools.SmalltalkStyler methodProtocol: #stTokenVisitor attributes: #(#readOnly) selectors: #(#visitAssignmentToken: #visitBinarySelectorToken: #visitErrorToken: #visitIdentifierToken: #visitIllegalCharacterToken: #visitKeywordToken: #visitLiteralArrayToken: #visitLiteralToken: #visitNumberLiteralToken: #visitOptimizedToken: #visitQualifiedReferenceToken: #visitSpecialCharacterToken:)!

!Tools.SmalltalkStyler class methodsFor!

language
	^'Smalltalk'! !
!Tools.SmalltalkStyler class categoriesFor: #language!constants!public! !

