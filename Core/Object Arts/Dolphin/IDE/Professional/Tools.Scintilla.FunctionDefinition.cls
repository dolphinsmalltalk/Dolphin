"Filed out from Dolphin Smalltalk 7"!

Tools.Scintilla.InterfaceDefinition subclass: #'Tools.Scintilla.FunctionDefinition'
	instanceVariableNames: 'funcType returnType lParam wParam returnTypeName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.FunctionDefinition guid: (Core.GUID fromString: '{1c19ff8a-f7a5-4f32-ad24-5ddb1990984f}')!
Tools.Scintilla.FunctionDefinition comment: ''!
!Tools.Scintilla.FunctionDefinition categoriesForClass!Development! !
!Tools.Scintilla.FunctionDefinition methodsFor!

constPrefix
	^'SCI_'!

defaultReturnValue
	^self hasReturnValue ifTrue: [self returnType default]!

displayOn: aStream
	aStream nextPutAll: returnTypeName;
		space;
		nextPutAll: name;
		nextPut: $(.
	wParam name ifNotNil: [
		aStream display: wParam].
	lParam name ifNotNil: [
		aStream nextPutAll: ', '.
		aStream display: lParam].
	aStream nextPut: $)!

emitBasicNullLParamFunctionOn: aPuttableStream
	aPuttableStream
		nextPutAll: self selector;
		space;
		nextPutAll: lParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitBasicWParamLParamFunctionOn: aPuttableStream
	| keywords |
	keywords := self selector subStrings: $:.
	aPuttableStream
		nextPutAll: keywords first;
		nextPut: $:;
		space;
		nextPutAll: wParam parameterName;
		space;
		nextPutAll: keywords second;
		nextPut: $:;
		space;
		nextPutAll: lParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitCommentOn: aPuttableStream
	| target devsys |
	self comment isEmpty ifTrue: [^self].
	target := String writeStream.
	target nextPut: $".
	self isPrivate ifTrue: [target nextPutAll: 'Private - '].
	self emitCommentString: self comment on: target.
	target nextPut: $".
	devsys := SmalltalkSystem current.
	aPuttableStream
		nextPutAll: (devsys
					wrapText: target contents
					indent: devsys workspaceClass defaultTabWidth + 1
					tabWidth: devsys workspaceClass defaultTabWidth);
		cr!

emitCommentString: aString on: aPuttableStream 
	aString do: [:each | aPuttableStream nextPut: (each == $" ifTrue: [$'] ifFalse: [each])]!

emitMethodBodyOn: aPuttableStream
	self emitMethodPreambleOn: aPuttableStream.
	self hasReturnValue
		ifTrue: 
			[| default |
			aPuttableStream nextPutAll: '^(this '.
			default := self defaultReturnValue.
			default isNil
				ifTrue: []
				ifFalse: 
					[aPuttableStream
						nextPutAll: 'ifNil: [';
						print: default;
						nextPutAll: '] '].
			aPuttableStream nextPutAll: 'ifNotNil: ['.
			self returnType emitReturnConversionAround: [self emitScintillaCallOn: aPuttableStream]
				on: aPuttableStream]
		ifFalse: 
			[aPuttableStream nextPutAll: '(this ifNotNil: ['.
			self emitScintillaCallOn: aPuttableStream].
	aPuttableStream nextPutAll: '])'!

emitMethodPreambleOn: aPuttableStream 
	self emitCommentOn: aPuttableStream.
	self isDeprecated 
		ifTrue: 
			[aPuttableStream
				print: 'deprecated' asSymbol;
				nextPut: $.;
				crtab]!

emitMethodTextOn: aWriteStream
	^wParam isUnused
		ifTrue: 
			[lParam isUnused
				ifTrue: [self emitNullNullFunctionOn: aWriteStream]
				ifFalse: [self emitNullLParamFunctionOn: aWriteStream]]
		ifFalse: 
			[lParam isUnused
				ifTrue: [self emitWParamNullFunctionOn: aWriteStream]
				ifFalse: [self emitWParamLParamFunctionOn: aWriteStream]]!

emitNullLParamFunctionOn: aWriteStream 
	^self hasStringResult 
		ifTrue: [self emitStringResultFunctionOn: aWriteStream]
		ifFalse: [self emitBasicNullLParamFunctionOn: aWriteStream]!

emitNullNullFunctionOn: aWriteStream
	aWriteStream
		nextPutAll: self selector;
		crtab.
	self emitMethodBodyOn: aWriteStream!

emitScintillaCallOn: aPuttableStream
	aPuttableStream
		nextPutAll: 'Library directFunction: this msg: ';
		nextPutAll: constName.
	wParam emitOutParam: $w on: aPuttableStream.
	lParam emitOutParam: $l on: aPuttableStream!

emitStringResultFunctionOn: aPuttableStream
	| resultClassExpression |
	aPuttableStream
		nextPutAll: self selector;
		crtab.
	self emitMethodPreambleOn: aPuttableStream.
	resultClassExpression := self fixedClassStringResults at: constName ifAbsent: ['stringClass'].
	aPuttableStream
		nextPutAll: '| len | len := this ifNil: [0] ifNotNil: [Library directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: nil]. ^len = 0 ifTrue: [';
		display: resultClassExpression;
		nextPutAll: ' empty] ifFalse: [| result | result := ';
		display: resultClassExpression;
		nextPutAll: ' newFixed: len'.
	(self stringResultsCountNull includes: self constName) ifTrue: [aPuttableStream nextPutAll: '-1'].
	aPuttableStream
		nextPutAll: '. Library directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: result. result]'!

emitWParamLParamFunctionOn: aPuttableStream
	^self hasStringResult
		ifTrue: [self emitWParamStringResultFunctionOn: aPuttableStream]
		ifFalse: [self emitBasicWParamLParamFunctionOn: aPuttableStream]!

emitWParamNullFunctionOn: aPuttableStream
	aPuttableStream
		nextPutAll: self selector;
		space;
		nextPutAll: wParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitWParamStringResultFunctionOn: aWriteStream
	| ignoreWParam resultClassExpression |
	ignoreWParam := self selector argumentCount = 0.
	aWriteStream
		nextPutAll: self selector;
		space.
	ignoreWParam ifFalse: [aWriteStream nextPutAll: wParam parameterName].
	aWriteStream crtab.
	self emitMethodPreambleOn: aWriteStream.
	resultClassExpression := self fixedClassStringResults at: constName ifAbsent: ['stringClass'].
	aWriteStream
		nextPutAll: '| len | len := this ifNil: [0] ifNotNil: [Library directFunction: this msg: ';
		nextPutAll: self constName.
	ignoreWParam
		ifTrue: [aWriteStream nextPutAll: ' wParam: 0']
		ifFalse: [wParam emitOutParam: $w on: aWriteStream].
	aWriteStream
		nextPutAll: ' lpParam: nil]. ^len = 0 ifTrue: [';
		display: resultClassExpression;
		nextPutAll: ' empty] ifFalse: [| result | result := ';
		display: resultClassExpression;
		nextPutAll: ' newFixed: len'.
	(self stringResultsCountNull includes: constName) ifTrue: [aWriteStream display: -1].
	aWriteStream
		nextPutAll: '. Library directFunction: this msg: ';
		nextPutAll: constName.
	ignoreWParam
		ifTrue: [aWriteStream nextPutAll: ' wParam: len']
		ifFalse: [wParam emitOutParam: $w on: aWriteStream].
	aWriteStream nextPutAll: ' lpParam: result. result]'!

fixedClassStringResults
	"Answer the set of Scintilla functions declared as returning strings, but which need to
	return either a ByteArray or a specific class of String that doesn't depend on the view's
	current encoding."

	^##(LookupTable new
		at: 'SCI_MARGINGETSTYLES' put: ByteArray;
		at: 'SCI_ANNOTATIONGETSTYLES' put: ByteArray;
		at: 'SCI_GETSUBSTYLEBASES' put: ByteArray;
		at: 'SCI_TARGETASUTF8' put: Utf8String;
		yourself)!

funcType: aString 
	funcType := aString!

hasReturnValue
	^self returnType isVoid not!

hasStringResult
	^lParam typeName = 'stringresult'!

isCommand
	"void functions with no parameters that have been given a specific name are considered to be commands."

	^self isFunction and: 
			[self hasReturnValue not
				and: [wParam isUnused and: [lParam isUnused and: [(self selector beginsWith: 'sci') not]]]]!

isFunction
	^funcType = 'fun'!

isPrivate
	| sel |
	sel := ScintillaViewGenerator renamedFunctions at: constName ifAbsent: [].
	^sel isNil or: [sel beginsWith: 'basic']!

isPropGet
	^funcType = 'get'!

isPropSet
	^funcType = 'set'!

lParam: anArray
	lParam := self makeParam: anArray!

makeParam: anArray
	| paramName paramTypeName |
	paramName := anArray last.
	paramTypeName := anArray first.
	((paramTypeName = 'position' and: 
			[(##(#('bytes' 'space' 'lines' 'columns' 'relative') asSet) includes: paramName)
				or: [paramName beginsWith: 'length']])
		or: [paramTypeName = 'line' and: [paramName = 'lines']]) ifTrue: [paramTypeName := 'int'].
	^ParameterDefinition newName: paramName typeName: paramTypeName!

name
	^name!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; display: self; nextPut: $).!

remappedReturnTypes
	"As of Scintilla 4.20 there are some helpful new parameter and return types intended to more closely describe
	usage in order to allow for better auto-generation of language bindings. However the 'position' type has been 
	abused to also describe lengths/sizes. Since we want to map from Scintilla's zero-based positions to Smalltalk
	1-based indexes, we need to distinguish between genuine positions, and misuses of the type."

	^##(| remappedReturnTypes |
	remappedReturnTypes := LookupTable new.
	#('SCI_GETSTYLEDTEXT' 'SCI_COUNTCHARACTERS' 'SCI_COUNTCODEUNITS' 'SCI_GETLINECOUNT' 'SCI_GETTEXTRANGE' 'SCI_GETTEXTLENGTH' 'SCI_REPLACETARGET' 'SCI_REPLACETARGETRE' 'SCI_WRAPCOUNT' 'SCI_LINESONSCREEN' 'SCI_POSITIONRELATIVE' 'SCI_POSITIONRELATIVECODEUNITS' 'SCI_GETSELECTIONNCARETVIRTUALSPACE' 'SCI_GETSELECTIONNANCHORVIRTUALSPACE' 'SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE' 'SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE')
		do: [:each | remappedReturnTypes at: each put: 'int'].
	remappedReturnTypes)!

retType: aString
	returnTypeName := self remappedReturnTypes at: constName ifAbsent: [aString]!

returnType
	^returnType ifNil: [returnType := TypeReference named: returnTypeName]!

selector
	selector ifNotNil: [^selector].
	selector := ScintillaViewGenerator renamedFunctions at: constName
				ifAbsent: 
					[| stream |
					stream := String writeStream.
					stream
						nextPutAll: 'sci';
						nextPutAll: name capitalized.
					wParam isUnused
						ifTrue: [(lParam isUnused or: [self hasStringResult]) ifFalse: [stream nextPut: $:]]
						ifFalse: 
							[stream nextPut: $:.
							(lParam isUnused or: [self hasStringResult])
								ifFalse: 
									[stream
										nextPutAll: lParam name;
										nextPut: $:]].
					stream contents asSymbol].
	^selector!

stringResultsCountNull
	"Answer the set of all Scintilla control stringresult messages that include the null
	terminator in the count returned. Most do not (this inconsistency is a Scintilla bug
	really as it defeats the ability to generate a correct wrapper from the interface 
	metadata alone)."

	^##((Set new)
		add: 'SCI_GETSELTEXT';
		add: 'SCI_GETTEXT';
		add: 'SCI_GETCURLINE';
		shrink;
		yourself)!

wParam: anArray
	wParam := self makeParam: anArray! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #constPrefix!initializing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #defaultReturnValue!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #displayOn:!displaying!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitBasicNullLParamFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitBasicWParamLParamFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitCommentOn:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitCommentString:on:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitMethodBodyOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitMethodPreambleOn:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitMethodTextOn:!generating!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitNullLParamFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitNullNullFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitScintillaCallOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitStringResultFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitWParamLParamFunctionOn:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitWParamNullFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitWParamStringResultFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #fixedClassStringResults!accessing!constants!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #funcType:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #hasReturnValue!helpers!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #hasStringResult!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isCommand!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isFunction!public!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isPrivate!private!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isPropGet!public!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isPropSet!public!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #lParam:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #makeParam:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #name!accessing!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #printOn:!printing!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #remappedReturnTypes!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #retType:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #returnType!accessing!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #selector!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #stringResultsCountNull!constants!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #wParam:!accessing!private! !

!Tools.Scintilla.FunctionDefinition class methodsFor!

tokens: anArray 
	| func |
	func := super tokens: anArray.
	func wParam: (anArray at: 4).
	func lParam: (anArray at: 5).
	^func! !
!Tools.Scintilla.FunctionDefinition class categoriesFor: #tokens:!instance creation!public! !

