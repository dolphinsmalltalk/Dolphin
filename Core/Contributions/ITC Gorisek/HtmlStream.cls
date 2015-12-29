"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #HtmlStream
	instanceVariableNames: 'indent lineBegin stream compact'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlStream guid: (GUID fromString: '{9C2C5B7F-6CD7-4A6A-A9D6-9A10327D6579}')!
HtmlStream comment: ''!
!HtmlStream categoriesForClass!Unclassified! !
!HtmlStream methodsFor!

checkIndent
	compact ifTrue: [^self].
	lineBegin 
		ifTrue: 
			[indent timesRepeat: [stream nextPutAll: '  '].
			lineBegin := false]!

code: code 
	code isString ifTrue: [^self write: code].
	code isNil ifTrue: [^self].
	code isBlockClosure 
		ifTrue: 
			[code argumentCount = 0 ifTrue: [^code value].
			^code value: self].

	"Otherwise convert into string and write as string code."
	self write: code printString!

contents
	^stream contents!

cr
	self checkIndent.
	stream cr!

dec
	" Decrease indent and start new line automatically. "

	indent := indent - 1.
	self newLine!

inc
	" Increase indent and start new line automatically. "

	indent := indent + 1.
	self newLine!

initialize: aStream compact: compactBoolean 
	indent := 0.
	lineBegin := true.
	compact := compactBoolean.
	stream := aStream!

newLine
	compact ifTrue: [^self].
	lineBegin ifTrue: [^self].
	stream cr.
	lineBegin := true!

nextPut: char 
	stream nextPut: char!

nextPutAll: string 
	stream nextPutAll: string!

position
	^stream position!

stream
	^stream!

text: text 
	text isString ifTrue: [^stream nextPutAll: text webHtmlEncoded].
	text isNil ifTrue: [^self].
	text isBlockClosure 
		ifTrue: 
			[text argumentCount = 0 ifTrue: [^text value].
			^text value: self].


	"Otherwise convert into string and write as string code."
	stream nextPutAll: text printString webHtmlEncoded!

write: string 
	self checkIndent.
	stream nextPutAll: string!

writeFragment: fragment 
	fragment isNil ifTrue: [^self].
	fragment isBlockClosure 
		ifTrue: 
			[fragment argumentCount = 0 ifTrue: [^fragment value].
			^fragment value: self].
	fragment isString ifTrue: [^stream nextPutAll: fragment].

	"Otherwise convert into string and write as text."
	stream nextPutAll: fragment printString webHtmlEncoded! !
!HtmlStream categoriesFor: #checkIndent!public! !
!HtmlStream categoriesFor: #code:!public! !
!HtmlStream categoriesFor: #contents!public! !
!HtmlStream categoriesFor: #cr!public! !
!HtmlStream categoriesFor: #dec!public! !
!HtmlStream categoriesFor: #inc!public! !
!HtmlStream categoriesFor: #initialize:compact:!public! !
!HtmlStream categoriesFor: #newLine!public! !
!HtmlStream categoriesFor: #nextPut:!public! !
!HtmlStream categoriesFor: #nextPutAll:!public! !
!HtmlStream categoriesFor: #position!public! !
!HtmlStream categoriesFor: #stream!public! !
!HtmlStream categoriesFor: #text:!public! !
!HtmlStream categoriesFor: #write:!public! !
!HtmlStream categoriesFor: #writeFragment:!public! !

!HtmlStream class methodsFor!

new: aStream 
	^super new initialize: aStream compact: true!

new: aStream compact: compactBoolean 
	^super new initialize: aStream compact: compactBoolean! !
!HtmlStream class categoriesFor: #new:!public! !
!HtmlStream class categoriesFor: #new:compact:!public! !

