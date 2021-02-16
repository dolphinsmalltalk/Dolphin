"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Question
	instanceVariableNames: 'text yes no'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Question guid: (GUID fromString: '{87b4c4ac-026e-11d3-9fd7-00a0cc3e4a32}')!
Question comment: 'This class forms part of a tutorial for the Dolphin Beginner''s Guide. A Question represents a decision node in the animal guessing game. Question instances form the branch nodes in the game''s knowledge tree. Each instance contains the text of a question and a yes/no branch to take depending on the result of that question. These branches can either point to other Question nodes or to an Animal node if this is a leaf in the tree. '!
!Question categoriesForClass!Samples! !
!Question methodsFor!

ask
	"Ask the receiver's question and continue the game appropriately depending on the
	answer that is received"

	(MessageBox confirm: self displayString caption: 'The animal you''re thinking of...')
		ifTrue: [ self yes ask ]
		ifFalse: [ self no ask ].!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: self text;
		nextPutAll: ' ?'!

no
	"Answer the branch in the knowledge tree to take as the result of a 'no' answer
	to the receiver's question."

	^no!

printOn: aStream
	"Answer the name of the receiver as a developer would wish
	to see it."

	super printOn: aStream.
	aStream nextPut: $(.
	self displayOn: aStream.
	aStream nextPut: $)!

text
	"Answer the receiver's question as a text String"

	^text!

text: aString yes: yesPath no: noPath
	"Private - Set the text of the receiver to aString and the yes and no branches to
	yesPath and noPath respectively. This is a bit tricky. At the end of this operation
	we want the receiver to have completely swapped its identity with the original
	noPath. This is a bit of a kludge (since there are better ways to insert the receiver
	in the knowledge tree at the right point) but it is the simplest solution for this
	example program."

	text := aString.
	yes := yesPath.
	no := self.

	self become: noPath!

yes
	"Answer the branch in the knowledge tree to take as the result of a 'yes' answer
	to the receiver's question."

	^yes! !
!Question categoriesFor: #ask!operations!public! !
!Question categoriesFor: #displayOn:!displaying!public! !
!Question categoriesFor: #no!accessing!public! !
!Question categoriesFor: #printOn:!printing!public! !
!Question categoriesFor: #text!accessing!public! !
!Question categoriesFor: #text:yes:no:!accessing!private! !
!Question categoriesFor: #yes!accessing!public! !

!Question class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon question!

promptToDistinguish: anOldAnimal from: aNewAnimal
	"Answers an instance of the receiver (a Question) that will distinguish between
	anOldAnimal and aNewAnimal. The question should be phrased such that the
	answer is 'yes' for aNewAnimal"

	| questionText |
	[questionText isNil or: [questionText isEmpty]] whileTrue: [
		questionText := Prompter prompt: ('Now, please enter a question that will answer Yes for ', 
			aNewAnimal displayString,
			' and No for ',
			anOldAnimal displayString)
			caption: 'Now, so I can learn about ', aNewAnimal displayString ].
	^self text: questionText yes: aNewAnimal no: anOldAnimal

	!

text: aString yes: yesPath no: noPath
	"Answer an instance of the receiver (a Question) having aString as it's text and
	leading to the nodes at yesPath and noPath as the result of those answers to its
	question."

	^self new text: aString yes: yesPath no: noPath
! !
!Question class categoriesFor: #icon!constants!public! !
!Question class categoriesFor: #promptToDistinguish:from:!instance creation!public! !
!Question class categoriesFor: #text:yes:no:!instance creation!public! !

