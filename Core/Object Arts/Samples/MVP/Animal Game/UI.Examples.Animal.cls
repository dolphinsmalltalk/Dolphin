﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.Animal'
	instanceVariableNames: 'name'
	classVariableNames: 'KnowledgeBase'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.Animal guid: (Core.GUID fromString: '{87b4c454-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Examples.Animal comment: 'This class forms part of a tutorial for the Dolphin Beginner''s Guide. An Animal represents a potential guess in the animal guessing game. Animal instances are always the leaf nodes in the game''s knowledge tree which is held in the class variable, KnowledgeBase. The main part of the tree is built from instances of Question. 

The game can be played by evaluating: 

Animal playGame. 

The knowledge base is initially set up in Animal>>initialize to only know about a single animal; a dog. This method can be re-executed at any point to reset the knowledge tree to its starting point: 

Animal initialize. '!

!UI.Examples.Animal categoriesForClass!Samples! !

!UI.Examples.Animal methodsFor!

ask
	"Ask whether the receiver is the animal that the player is thinking of.
	If it is then the game is over. If it is not then prompt for the true answer
	and install it and a question which will distinguish this new animal from
	the receiver. This allows the game to learn."

	(MessageBox confirm: 'Are you thinking of ' , self displayString , '?')
		ifTrue: [MessageBox notify: 'I guessed your animal correctly.' caption: 'GREAT, I WIN']
		ifFalse: 
			[| newAnimal newQuestion |
			newAnimal := Animal prompt.
			newQuestion := Question promptToDistinguish: self from: newAnimal].
	(MessageBox confirm: 'Do you wish to play again?' caption: 'I''m getting better all the time...')
		ifTrue: [Animal playGame]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	We use the name of the receiver prepended by 'a' or 'an' as appropriate."

	| aOrAn |
	aOrAn := name first isVowel ifTrue: ['an '] ifFalse: ['a '].
	aPuttableStream
		nextPutAll: aOrAn;
		nextPutAll: self name!

knowledgeBase
	"Answer the Animal game knowledge base."

	^self class knowledgeBase

!

name
	"Answer the name of the receiver"
	
	^name!

name: aStringName
	"Private - Initialize the name of the receiver to aString"
	
	name := aStringName!

printOn: aStream
	"Answer the name of the receiver as a developer would wish to see it ."

	super printOn: aStream.
	aStream nextPut: $(.
	self displayOn: aStream.
	aStream nextPut: $)! !

!UI.Examples.Animal categoriesForMethods!
ask!operations!public! !
displayOn:!displaying!public! !
knowledgeBase!accessing!public! !
name!accessing!public! !
name:!accessing!private! !
printOn:!printing!public! !
!

!UI.Examples.Animal class methodsFor!

icon
	^##(TextTileIcon text: '🐼')!

knowledgeBase
	"Answer the Animal game knowledge base."

	KnowledgeBase isNil ifTrue: [KnowledgeBase := self name: 'Dog'].
	^KnowledgeBase.
!

name: aStringName
	"Answer an instance of the receiver with aStringName"

	^self new name: aStringName
!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	KnowledgeBase := nil.!

playGame
	"Start a new game using the existing knowledge base held in the
	KnowledgeBase class variable"

	MessageBox notify: 'Think of an animal and I will try to guess what it is.
Are you ready?' caption: 'The Animal Game' .
	self knowledgeBase ask!

prompt
	"Prompt for a new animal to add to the game"

	| newName |
	[newName isNil or: [newName isEmpty]] whileTrue: [
		newName := Prompter prompt: 'Tell me, what animal were you thinking of?
It was a...' caption: 'So, you win...'].
	^self name: newName!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	KnowledgeBase := nil.! !

!UI.Examples.Animal class categoriesForMethods!
icon!constants!public! !
knowledgeBase!accessing!public! !
name:!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
playGame!operations!public! !
prompt!instance creation!public! !
uninitialize!class hierarchy-removing!private! !
!

