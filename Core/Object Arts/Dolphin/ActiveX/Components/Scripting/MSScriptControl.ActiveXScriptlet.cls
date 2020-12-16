"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'MSScriptControl.ActiveXScriptlet'
	instanceVariableNames: 'language expression procedures description globalBindings'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSScriptControl.ActiveXScriptlet guid: (Core.GUID fromString: '{9271a3a3-d270-11d3-93da-00a024ca708a}')!
MSScriptControl.ActiveXScriptlet comment: 'ActiveXScriplet represents an executable piece of script code, e.g. in VBScript. 

It consists of a set of the name of the script language, the text of a set of procedures (may be empty), and an expression to be evaluated.

Instance Variables:
	language		<String>. Name of the scripting language, e.g. VBScript.
	expression		<String>. Expression evaluated to get the value of the scriptlet.
	procedures	<String>. Optional procedures to support the expression.
'!
!MSScriptControl.ActiveXScriptlet categoriesForClass!Unclassified! !
!MSScriptControl.ActiveXScriptlet methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent."

	^comparand species == self species and: [
		comparand language = self language and: [
			comparand expression = self expression and: [
				comparand procedures = self procedures]]]!

addGlobalBinding: anAssociation
	self globalBindings add: anAssociation!

description
	"Answer the <readableString> description associated with the receiver."

	^description!

description: aString
	"Set the <readableString> description associated with the receiver."

	description := aString!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream display: self description!

expression
	"Answer the <readableString> script expression evaluated when the receiver is sent #value."

	^expression!

expression: aString
	"Private - Set the value of the receiver's ''expression'' instance variable to the argument, aString."

	expression := aString!

globalBindings
	^globalBindings!

globalBindings: aLookupTable 
	globalBindings := aLookupTable!

initialize
	"Private - Initialize the receiver with some default values."

	self 
		setLanguage: 'VBScript'
		expression: 'add(1,1)'
		procedures: 'function add(x,y)
	add = x+y
end function'
		description: 'Example'!

language
	"Answer the <readableString> name of the scripting language in which the receiver's 
	procedures and expression are expressed."

	^language!

language: aString
	"Private - Set the value of the receiver's ''language'' instance variable to the argument, aString."

	language := aString!

procedures
	"Answer the <readableString> script text of the receiver's procedures."

	^procedures!

procedures: code
	"Private - Set the value of the receiver's ''procedures'' instance variable to the
	script text, code."

	procedures := code asString!

removeGlobalBindings
	globalBindings := LookupTable new!

setLanguage: languageName expression: expressionText procedures: proceduresText description: descriptionText 
	language := languageName.
	expression := expressionText.
	procedures := proceduresText.
	description := descriptionText.
	self removeGlobalBindings!

value
	"Evaluate the scriptlet."

	| engine result |
	engine := MSScriptControl.IScriptControl new.
	engine
		language: self language;
		addCode: self procedures.
	self globalBindings
		keysAndValuesDo: [:eachKey :eachValue | engine addObject: eachKey object: (eachValue queryInterface: IDispatch)].
	result := engine eval: self expression.
	engine free.
	^result! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #=!comparing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #addGlobalBinding:!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #description!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #description:!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #displayOn:!displaying!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #expression!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #expression:!accessing!private! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #globalBindings!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #globalBindings:!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #initialize!initializing!private! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #language!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #language:!accessing!private! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #procedures!accessing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #procedures:!accessing!private! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #removeGlobalBindings!initializing!public! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #setLanguage:expression:procedures:description:!initializing!private! !
!MSScriptControl.ActiveXScriptlet categoriesFor: #value!evaluating!public! !

!MSScriptControl.ActiveXScriptlet class methodsFor!

language: languageName expression: expressionText procedures: proceduresText
	"Use #language:expression:procedures:description: which allows description
	to be associated with the scriptlet. Present for backwards compatibility."
	
	^self 
		language: languageName
		expression: expressionText
		procedures: proceduresText
		description: expressionText
!

language: languageName expression: expressionText procedures: proceduresText description: descriptionText
	"Answer a new instance of the receiver populated with the specified script details."

	^self new
		language: languageName;
		expression: expressionText;
		procedures: proceduresText;
		description: descriptionText
!

new
	"Answer an instance of the receiver which describes an attribute
	which can be both read from and written to."

	^super new initialize! !
!MSScriptControl.ActiveXScriptlet class categoriesFor: #language:expression:procedures:!instance creation!public! !
!MSScriptControl.ActiveXScriptlet class categoriesFor: #language:expression:procedures:description:!instance creation!public! !
!MSScriptControl.ActiveXScriptlet class categoriesFor: #new!instance creation!public! !

