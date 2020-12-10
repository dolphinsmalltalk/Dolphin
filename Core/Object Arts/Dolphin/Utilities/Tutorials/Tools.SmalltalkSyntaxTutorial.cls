"Filed out from Dolphin Smalltalk 7"!

AbstractTutorial subclass: #SmalltalkSyntaxTutorial
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SmalltalkSyntaxTutorial guid: (GUID fromString: '{3692cc24-6c4c-4441-a0f0-ea8235ac2d25}')!
SmalltalkSyntaxTutorial comment: 'The default ProfStef tutorial to learn Smalltalk syntax'!
!SmalltalkSyntaxTutorial categoriesForClass!Kernel-Objects! !
!SmalltalkSyntaxTutorial methodsFor!

basicTypesArray
	^ Lesson
title: 'Basic types: Array' 
contents: 
'"Literal arrays are created at parse time:"

#(1 2 3).

#( 1 2 3 #(4 5 6)) size.

#(1 2 4) isEmpty.

#(1 2 3) first.

#(''hello'' ''Dolphin'') at: 2.

ProfStef next.'
!

basicTypesCharacters
	^ Lesson
title: 'Basic types: Characters' 
contents: 
'"A Character can be instantiated using $ operator:"

$A.

$A class.

$B asciiValue.

Character cr asciiValue.

Character space asciiValue.

"You can print all 256 characters of the ASCII extended set:"

Character byteCharacterSet.

"Any Unicode character can be instantiated using its hex code point"

$\x1F42C asString.

ProfStef next.'
!

basicTypesNumbers
	^ Lesson
title: 'Basic types: Numbers' 
contents: 
'"You now know how to execute Smalltalk code. 

Now let''s talk about basic objects.

1, 2, 100, 2/3 ... are Numbers, and respond to many messages evaluating mathematical expressions.
Display these ones:"

2.

"Notice that fractions are kept as fractions and not reduced to floats"

(1/3).

(1/3) + (4/5).

(18/5) rounded.

"Also Smalltalk can represent VERY large integers"

200 factorial.

1 class.

200 factorial class.

1 negated.

1 negated negated.

(1 + 3) odd.

ProfStef next.'
!

basicTypesString
	^ Lesson
title: 'Basic types: Strings' 
contents: 
'"A String is a collection of characters. Use single quotes to create a String object. Display these expressions:"

''ProfStef''.

''ProfStef'' size.

''abc'' asUppercase.

''Hello World'' reverse. 

"You can access each character using at: message"

''ProfStef'' at: 1.

"String concatenation uses the comma operator:"

''ProfStef'', '' is cool''.

ProfStef next.'
!

basicTypesSymbol
	^ Lesson
title: 'Basic types: Symbols' 
contents: 
'"A Symbol is a special String which is guaranteed to be globally unique. 

There is one and only one Symbol #ProfStef. There may be several ''ProfStef'' String objects.

(Message == returns true if the two objects are the SAME)"

''ProfStef'' asSymbol.

#ProfStef asString.

(2 displayString) == (2 displayString).

(2 displayString) asSymbol == (2 displayString) asSymbol.


(Smalltalk at: #ProfStef) next.'
!

blocks
	^ Lesson
title: 'Blocks' 
contents: 
'"Cascade is cool !! Let''s talk about blocks.

Blocks are anonymous methods that can be stored into variables and executed on demand.

Blocks are delimited by square brackets: []"

[Transcript show].

"does not open a Transcript because the block is not executed.

Here is a block that adds 2 to its argument (its argument is named x):"

[:x | x+2].

"We can execute a block by sending it value messages."

[:x | x+2] value: 5.

[Transcript show] value.

[:x | x+2] value: 10.

[:x :y| x + y] value:3 value:5.

[ProfStef next] value.'
!

blocksAssignation
	^ Lesson
title: 'Block assignation' 
contents: 
'"Blocks can be assigned to a variable then executed later.

Note that |b| is the declaration of a variable named ''b'' and that '':='' assigns a value to a variable.

Select the three lines then Display It:"

|b|
b := [:x | x+2].
b value: 12.


ProfStef next.'
!

conditionals
	^ Lesson
title: 'Conditionals' 
contents: 
'"Conditionals are just messages sent to Boolean objects"

1 < 2
  ifTrue: [100]
  ifFalse: [42].

"Here the message is ifTrue:ifFalse:

Try this:"

Transcript show.

3 > 10 
	ifTrue: [Transcript show: ''maybe there''''s a bug ....'']
	ifFalse: [Transcript show: ''Everything''''s cool: 3 is less than 10''].

3 = 3 ifTrue: [ProfStef next].'.
!

debugger
	^ Lesson
title: 'Debugger' 
contents: '"The Debugger may be the most famous tool of Smalltalk environments. 

The following code will open the debugger. Either hit Go or step through the code to the next lesson.

self halt. ProfStef default next.

 '
!

displaying 
	^ Lesson
title: 'Evaluating Vs Displaying: Displaying' 
contents: 
'"Now you''re an Evaluate It master !! Let''s talk about displaying results.
It''s an Evaluate It which displays the result next to the expression you''ve selected.
For example, select the text below, and click on ''DisplayIt'':"

1 + 2.

"As with ''EvaluateIt'', there is also a shortcut to execute this command.

Try CTRL-d on the following expressions:"

TimeStamp current.

"The result is selected, so you can erase it using the backspace key. Try it !!"

TimeStamp current date.

TimeStamp current time.

ProfStef next.'
!

dolphinEnvironment
	^Lesson title: 'Dolphin environment'
		contents: '"Every Smalltalk system is full of objects.
There are windows, text, numbers, dates, colors, points and much more.
You can interact with objects in a much more direct way than is possible with other programming languages.

Every object understands the message ''inspect''. As a result, you get an Inspector window that shows details about the object."

TimeStamp current inspect.

"This shows that the timestamp object consists of two internal objects; a date and a time. If you expand these you can see that the date holds a number of days and the time a number of milliseconds."

"Let''s take a look at my code:"

ProfStef browse.

"My methods are in the upper right hand pane. Hmm.. there''s not much in there. So how come I''m so clever. Well, most of the work is done by the class I Inherit from; my superclass."

ProfStef superclass browse.

ProfStef next.'!

evaluatingVsDisplaying
	^Lesson title: 'Evaluating vs Displaying: Evaluating'
		contents: '"Cool !! (I like to say Cooool :) ).
You''ve just executed a Smalltalk expression.
More precisely, you sent the message ''next'' to ProfStef class (it''s me !!).

Note you can run this tutorial again by evaluating: ''ProfStef go''. 
''ProfStef previous'' returns to the previous lesson.

You can also Evaluate It using the keyboard shortcut ''CTRL e''

Try to evaluate this expression:"

MessageBox notify: ''hello world!!''.

"Then go to the next lesson:"

ProfStef next.'!

instantiation
	^Lesson title: 'Instantiation'
		contents: '"Objects are instances of their class. Usually, we send the message #new to a class for creating an instance of this class.

For example, let''s create an instance of the class OrderedCollection"

OrderedCollection new
	add: ''Some text'';
	add: 3;
	yourself.

"See the collection we''ve created? An OrderedCollection is like an Array but items can be added or removed from it. With Arrays, their size is fixed."

"If we use a variable to keep track of this object, we''ll be able to do stuff with it."

"The following code must be ran all at one, as the ''aCollection'' variable will cease to exist once the execution finishes:"

|aCollection|
aCollection := OrderedCollection new
	add: ''Some text'';
	add: 3;
	yourself.
Transcript show: aCollection printString; cr.
aCollection remove: 3.
Transcript show: aCollection printString; cr.
aCollection add: ''Some more text!!''.
Transcript show: aCollection printString; cr.

"Note in the above we used printString rather than displayString, since this includes more information about the object - such as it''s class."
	
ProfStef next'!

iterators
	^ Lesson
title: 'Iterators' 
contents: 
'"The message do: is sent to a collection of objects (Array, Dictionary, String, etc), evaluating the block for each element.

Here we want to print all the numbers on the Transcript (a console)"

#(11 38 3 -2 10) do: [:each |
     Transcript show: each displayString; cr].

"Some other really nice iterators"

#(11 38 3 -2 10) collect: [:each | each negated].

#(11 38 3 -2 10) collect: [:each | each odd].

#(11 38 3 -2 10) select: [:each | each odd].

#(11 38 3 -2 10) select: [:each | each > 10].

#(11 38 3 -2 10) reject: [:each | each > 10].

#(11 38 3 -2 10) 
     do: [:each | Transcript show: each displayString]
     separatedBy: [Transcript show: ''.''].


(Smalltalk allClasses select: [:eachClass | eachClass name = #ProfStef]) do: [:eachProfstef | eachProfstef next].'
!

loops
	^ Lesson
title: 'Loops' 
contents: 
'"Loops are high-level collection iterators, implemented as regular methods."

"Basic loops:
  to:do:
  to:by:do"

1 to: 100 do:
  [:i | Transcript show: i displayString; cr ].

1 to: 100 by: 3 do: [:i | Transcript show: i displayString; cr].

100 to: 0 by: -2 do: 
    [:i | Transcript show: i displayString; cr].

1 to: 1 do: [:i | ProfStef next].'
!

mathematicalPrecedence
	^ Lesson
title: 'Mathematical precedence'
contents: 
'"Traditional precedence rules from mathematics do not follow in Smalltalk."

2 * 10 + 2.

"Here the message * is sent to 2, which answers 20, then 20 receive the message +

Remember that all messages always follow a simple left-to-right precedence rule, * without exceptions *."

2 + 2 * 10.

2 + (2 * 10).

8 - 5 / 2.

(8 - 5) / 2.

8 - (5 / 2).

ProfStef next.'
!

messageSyntaxBinary
	^ Lesson
title: 'Message syntax: Binary messages' 
contents: 
'"Binary messages have the following form:
    anObject + anotherObject"

3 * 2.

Date today year = 2016.

false | false.

true & true.

true & false.

10 @ 100.

10 <= 12.

''ab'', ''cd''.

ProfStef next.'
!

messageSyntaxCascade
	^ Lesson
title: 'Message syntax: Cascade' 
contents: 
'"; is the cascade operator. It''s useful to send message to the SAME receiver
Open a Transcript (like a console):"

Transcript show.

"Then:"

Transcript show: ''hello ''.
Transcript show: ''Smalltalk''.
Transcript cr.

"is equivalent to:"

Transcript 
	   show: ''hello '';
	   show: ''Smalltalk'' ;
	   cr.

"You can close the Transcript window now.
Try to go to the next lesson by writing a cascade of two ''next'' messages:"

ProfStef'.
!

messageSyntaxCascadeShouldNotBeHere
	^ Lesson
title: 'Lost ?' 
contents: 
'"Hey, you should not be here !!!! 

Go back and use a cascade !!"

ProfStef previous.'.
!

messageSyntaxExecutionOrder
	^ Lesson
title: 'Message syntax: Execution order' 
contents: 
'"Unary messages are executed first, then binary messages and finally keyword messages:
    Unary > Binary > Keywords"

2.5 + 3.8 rounded.

3 max: 2 + 2.
  
(0@0) class.

0@0 x: 100.

(0@0 x: 100) class.

"Between messages of similar precedence, expressions are executed from left to right"

-12345 negated displayString reverse.

ProfStef next.'
!

messageSyntaxExecutionOrderParentheses
	^ Lesson
title: 'Message syntax: Parentheses'
contents: 
'"Use parentheses to change order of evaluation"

(2.5 + 3.8) rounded.

(3 max: 2) + 2.

ProfStef next.'
!

messageSyntaxKeyword
	^ Lesson
title: 'Message syntax: Keyword messages' 
contents: 
'"Keyword Messages are messages with arguments. They have the following form:
    anObject akey: anotherObject akey2: anotherObject2"

''Smalltalk development is a good deal of pain'' copyFrom: 1 to: 36

"The message is copyFrom:to: sent to the String ''Smalltalk development is a good deal of pain''"

1 max: 3.

Array with: ''hello'' with: 2 with: ''Smalltalk''.

"The message is with:with:with: implemented on class Array. Note you can also write"

Array
	with: ''Hi there!!''
	with: 2
	with: ''Smalltalk''.
	
ProfStef perform: ''next''.'
!

messageSyntaxUnary
	^ Lesson
title: 'Message syntax: Unary messages' 
contents: 
'"Messages are sent to objects. There are three types of message: Unary, Binary and Keyword.

Unary messages have the following form:
    anObject aMessage 

You''ve already sent unary messages. For example:"

1 class.

false not.

Date today.

Float pi.

"And of course: "

ProfStef next.'
!

name	
	^'Prof Stef Says - Let''s Learn Smalltalk'
!

reflection
	^ Lesson
title: 'Reflection' 
contents: 
'"You can inspect and change the system at runtime.

Take a look at the source code of the method #and: of the class Boolean:"

(True methodDictionary at: #and:) getSource.

"Or all the methods it sends:"

(True methodDictionary at: #and:) messages.

"Here''s all the methods I implement:"

ProfStef class methodDictionary.

"Let''s create a new method to go to the next lesson:"

ProfStef class compile: ''goToNextLesson ProfStef next.''

"Wow!! I can''t wait to use my new method!!"

ProfStef goToNextLesson.'
!

reflectionContinued
	^ Lesson
title: 'Reflection continued' 
contents: 
'"So cool, isn''t it ?  Before going further, let''s remove this method:"

ProfStef class compiledMethodAt: #goToNextLesson.

ProfStef class removeSelector: #goToNextLesson.

"So now this should fail - try it and hit Terminate in the box that appears."

ProfStef class methodAt: #goToNextLesson.


"Then move forward:"

ProfStef perform: #next'
!

tableOfContents
	^#(#welcome #evaluatingVsDisplaying #displaying #basicTypesNumbers #basicTypesCharacters #basicTypesString #basicTypesSymbol #basicTypesArray #messageSyntaxUnary #messageSyntaxBinary #messageSyntaxKeyword #messageSyntaxExecutionOrder #messageSyntaxExecutionOrderParentheses #mathematicalPrecedence #messageSyntaxCascade #messageSyntaxCascadeShouldNotBeHere #blocks #blocksAssignation #conditionals #loops #iterators #instantiation #reflection #reflectionContinued #dolphinEnvironment #debugger #theEnd)!

theEnd
	^ Lesson
title: 'The End !!' 
contents: 
'"This tutorial is done. Enjoy programming Smalltalk with Dolphin. 

You can run this tutorial again by evaluating: ProfStef go.

See you soon !!"
'
!

welcome
	^ Lesson
title: 'Welcome' 
contents: 
'"Hello!! I''m Professor Stef. 

You must want me to help you learn Smalltalk.

So let''s go to the first lesson.  Select the text below and click on the ''EvaluateIt'' button"

ProfStef next.'
! !
!SmalltalkSyntaxTutorial categoriesFor: #basicTypesArray!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #basicTypesCharacters!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #basicTypesNumbers!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #basicTypesString!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #basicTypesSymbol!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #blocks!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #blocksAssignation!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #conditionals!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #debugger!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #displaying!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #dolphinEnvironment!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #evaluatingVsDisplaying!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #instantiation!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #iterators!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #loops!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #mathematicalPrecedence!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #messageSyntaxBinary!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #messageSyntaxCascade!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #messageSyntaxCascadeShouldNotBeHere!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #messageSyntaxExecutionOrder!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #messageSyntaxExecutionOrderParentheses!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #messageSyntaxKeyword!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #messageSyntaxUnary!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #name!accessing!public! !
!SmalltalkSyntaxTutorial categoriesFor: #reflection!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #reflectionContinued!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #tableOfContents!contents!public! !
!SmalltalkSyntaxTutorial categoriesFor: #theEnd!pages!public! !
!SmalltalkSyntaxTutorial categoriesFor: #welcome!pages!public! !

