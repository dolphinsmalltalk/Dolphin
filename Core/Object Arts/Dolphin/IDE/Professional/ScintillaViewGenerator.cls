"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaViewGenerator
	instanceVariableNames: 'events commentQueue lexerConstantPrefixes previewChanges commands parsingDeprecated namespace constantsPool generatedSelectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaViewGenerator guid: (GUID fromString: '{BABB8E5D-5EE9-43B2-A88B-0959484C008E}')!
ScintillaViewGenerator comment: 'This class reads the Scintilla.iface definition and autogenerates wrapper methods into the ScintillaView class, and defines constants in the ScintillaConstants pool.

The parsing is not sophisticated, but adequate for purpose.

self new parseFile'!
!ScintillaViewGenerator categoriesForClass!Development! !
!ScintillaViewGenerator methodsFor!

applyChanges
	RefactoryChangeManager instance performChange: namespace changes.
	self scintillaViewClass initializeNotificationMap.
	ScintillaKeyBinding initializeCommands!

autoGenCategory
	^MethodCategory name: self autoGenCategoryName!

autoGenCategoryName
	"Private - Answer the name of the special method category for auto-generated
	methods."

	^'**auto generated**'!

autoGenEventCategories
	"Private - Answer the special method categories for auto-generated
	property accessors in the receivers wrapper class."

	^Array with: self autoGenCategory with: (MethodCategory name: 'event handling-scintilla')!

autoGenMethodCategories
	"Private - Answer the special method categories for auto-generated
	property accessors in the receivers wrapper class."

	^Array with: self autoGenCategory with: (MethodCategory name: 'scintilla interface')!

browseChanges
	RewriteChangesBrowser showOn: namespace changes!

compile: aString selector: aSymbol in: targetClass categories: aCollectionOfMethodCategory 
	| source allCategories |
	(generatedSelectors at: targetClass ifAbsentPut: [Set new]) add: aSymbol.
	source := (SmalltalkParser parseMethod: aString) formattedCode.
	((targetClass includesSelector: aSymbol) and: [(targetClass sourceCodeAt: aSymbol) = source]) 
		ifTrue: [^self].
	allCategories := aCollectionOfMethodCategory 
				union: ((targetClass compiledMethodAt: aSymbol ifAbsent: []) 
						ifNotNil: [:value | value categories]
						ifNil: [#()]).
	(namespace classFor: targetClass) compile: source classified: allCategories!

compileMethod: selector source: aString 
	self 
		compileMethod: selector
		source: aString
		categories: self autoGenMethodCategories!

compileMethod: selector source: aString categories: aCollection 
	self 
		compile: aString
		selector: selector
		in: self scintillaViewClass
		categories: aCollection!

constantsPool
	^constantsPool!

defineAdditionalConstants
	(self constantsPool)
		at: 'STYLE_NORMAL' put: 0!

generateCommandMap
	| stream selector |
	stream := String writeStream.
	selector := #initializeCommands.
	stream
		display: selector;
		cr;
		nextPutAll: 'Commands := (IdentityDictionary new)';
		cr.
	commands at: 'SCI_NULL' put: #yourself.
	(self sciCommands asSortedCollection asArray copyWith: 'SCI_NULL') do: 
			[:each | 
			stream
				nextPutAll: 'at: ';
				display: each;
				nextPutAll: ' put: ';
				print: (commands at: each);
				nextPut: $;].
	stream
		display: #shrink;
		nextPut: $;;
		display: #isImmutable:;
		display: true;
		nextPut: $;;
		nextPutAll: 'yourself'.
	self 
		compile: stream contents
		selector: selector
		in: ScintillaKeyBinding class
		categories: self autoGenMethodCategories 
				, (Array with: MethodCategory private with: (MethodCategory name: 'development'))!

generateConstantsPool
	| stream changes source |
	stream := String writeStream: 4096.
	stream
		nextPutAll: #defineConstantsPool;
		cr;
		nextPutAll: '##(';
		cr;
		nextPutAll: '(Smalltalk at: #ScintillaConstants put: (PoolConstantsDictionary named: #ScintillaConstants))';
		cr.
	self constantsPool associations asSortedCollection do: 
			[:each | 
			stream
				nextPutAll: 'at: ';
				print: each key;
				nextPutAll: ' put: ';
				print: each value;
				nextPut: $;;
				cr].
	stream nextPutAll: 'shrink; yourself)'.
	changes := namespace changes.
	source := (SmalltalkParser parseMethod: stream contents) formattedCode.
	((self scintillaViewClass class includesSelector: #defineConstantsPool) not 
		or: [source ~= (self scintillaViewClass class sourceCodeAt: #defineConstantsPool)]) 
			ifTrue: 
				[changes addChangeFirst: (changes addMethodChangeClass 
							compile: source
							in: self scintillaViewClass class
							categories: (Array with: self autoGenCategory with: (MethodCategory name: 'development')))]!

generateEventHandler: aScintillaEventDef 
	| stream |
	aScintillaEventDef isDeprecated 
		ifTrue: 
			[Transcript
				display: 'Ignoring deprecated event ';
				print: aScintillaEventDef constName;
				cr.
			^self].
	(self scintillaViewClass compiledMethodAt: aScintillaEventDef selector ifAbsent: []) 
		ifNotNil: 
			[:existingMethod | 
			(existingMethod categories includes: self autoGenCategory) 
				ifFalse: 
					[Transcript
						display: 'Default handler for ';
						print: aScintillaEventDef selector;
						display: ' not generated due to selector clash';
						cr.
					^self]].
	stream := String writeStream.
	aScintillaEventDef generateHandlerOn: stream.
	self 
		compileMethod: aScintillaEventDef selector
		source: stream contents
		categories: self autoGenEventCategories!

generateNotificationMap
	| stream scnFirst |
	events isEmpty ifTrue: [^self].
	stream := String writeStream.
	stream
		display: #initializeNotificationMap;
		crtab;
		nextPutAll: 'ScnMap := (Array new: ';
		print: events last id + 1 - self scnFirst;
		nextPut: $);
		crtab: 2.
	scnFirst := self scnFirst.
	events do: 
			[:each | 
			| constName |
			constName := each constName.
			stream
				nextPutAll: 'at: (';
				nextPutAll: constName;
				nextPutAll: ' - ';
				print: scnFirst - 1;
				nextPutAll: ') put: ';
				print: (each isDeprecated ifFalse: [each selector]);
				nextPut: $;;
				crtab: 2].
	stream
		display: #isImmutable:;
		space;
		display: true;
		nextPut: $;;
		crtab: 2;
		nextPutAll: 'yourself'.
	self 
		compile: stream contents
		selector: #initializeNotificationMap
		in: self scintillaViewClass class
		categories: (self autoGenMethodCategories copyWith: (MethodCategory name: 'must not strip'))!

getAndResetCommentQueue
	| answer |
	answer := commentQueue contents.
	commentQueue := WriteStream on: (String new: 160).
	^answer!

ignoredMessages
	^##(| ignoredMessages |
	ignoredMessages := (Set new)
				add: 'SCI_NULL';
				add: 'SCI_COPYTEXT';
				add: 'SCI_GETREADONLY';
				add: 'SCI_USEPOPUP';
				add: 'SCI_SETCURRENTPOS';
				add: 'SCI_LINELENGTH';
				add: 'SCI_GETSTYLEAT';
				yourself.

	"We use the direct function exported by the DLL, and don't need a wrapper method for SCI_GETDIRECTPOINTER as we need to send it directly."
	ignoredMessages addAll: #('SCI_GETDIRECTFUNCTION' 'SCI_GETDIRECTPOINTER').
	"We don't use direct/unsafe access to the scintilla character buffer."
	ignoredMessages addAll: #('SCI_GETCHARACTERPOINTER' 'SCI_GETRANGEPOINTER' 'SCI_GETGAPPOSITION').
	"We don't support background loading"
	ignoredMessages add: 'SCI_CREATELOADER'.

	"The idFrom field of the notification header is not needed to identify the Scintilla
	control, as we have an object instance associated with each control instance that receives
	the notifications directly."
	ignoredMessages addAll: #('SCI_GETIDENTIFIER' 'SCI_SETIDENTIFIER').

	"Scintilla supports standard Windows focus messages, which are used in the MVP framework already"
	ignoredMessages
		add: 'SCI_GETFOCUS';
		add: 'SCI_SETFOCUS';
		add: 'SCI_GRABFOCUS';
		yourself.

	"Margin attributes managed by ScintillaMargin"
	ignoredMessages
		addAll: #('SCI_GETMARGINMASKN' 'SCI_SETMARGINMASKN');
		addAll: #('SCI_GETMARGINTYPEN' 'SCI_SETMARGINTYPEN');
		addAll: #('SCI_GETMARGINWIDTHN' 'SCI_SETMARGINWIDTHN');
		addAll: #('SCI_GETMARGINSENSITIVEN' 'SCI_SETMARGINSENSITIVEN');
		addAll: #('SCI_GETMARGINCURSORN' 'SCI_SETMARGINCURSORN');
		yourself.

	"Indicator attributes managed by ScintillaIndicatorStyle"
	ignoredMessages
		addAll: #('SCI_INDICGETFORE' 'SCI_INDICSETFORE');
		addAll: #('SCI_INDICGETSTYLE' 'SCI_INDICSETSTYLE');
		addAll: #('SCI_INDICGETHOVERSTYLE' 'SCI_INDICSETHOVERSTYLE');
		addAll: #('SCI_INDICGETHOVERFORE' 'SCI_INDICSETHOVERFORE');
		addAll: #('SCI_INDICGETUNDER' 'SCI_INDICSETUNDER');
		addAll: #('SCI_INDICGETALPHA' 'SCI_INDICSETALPHA');
		addAll: #('SCI_INDICGETFLAGS' 'SCI_INDICSETFLAGS');
		addAll: #('SCI_INDICGETOUTLINEALPHA' 'SCI_INDICSETOUTLINEALPHA');
		yourself.

	"Indicator attributes managed by ScintillaMarkerDefinition"
	ignoredMessages
		add: 'SCI_MARKERSETBACK';
		add: 'SCI_MARKERSETBACKSELECTED';
		add: 'SCI_MARKERSETFORE';
		add: 'SCI_MARKERADD';
		add: 'SCI_MARKERDEFINE';
		add: 'SCI_MARKERDELETE';
		yourself.

	"Annotation attributes are managed by ScintillaAnnotation"
	ignoredMessages
		addAll: #('SCI_ANNOTATIONGETSTYLE' 'SCI_ANNOTATIONSETSTYLE');
		yourself.

	"Style attributes managed by ScintillaTextStyle, but note that as Scintilla wrapping
	predates when style definitions were queryable, so we don't use these at all"
	ignoredMessages
		addAll: #('SCI_STYLESETFORE' 'SCI_STYLEGETFORE');
		addAll: #('SCI_STYLESETBACK' 'SCI_STYLEGETBACK');
		addAll: #('SCI_STYLESETFONT' 'SCI_STYLEGETFONT');
		addAll: #('SCI_STYLESETBOLD' 'SCI_STYLEGETBOLD');
		addAll: #('SCI_STYLESETITALIC' 'SCI_STYLEGETITALIC');
		addAll: #('SCI_STYLESETUNDERLINE' 'SCI_STYLEGETUNDERLINE');
		addAll: #('SCI_STYLESETCASE' 'SCI_STYLEGETCASE');
		addAll: #('SCI_STYLESETCHARACTERSET' 'SCI_STYLEGETCHARACTERSET');
		addAll: #('SCI_STYLESETSIZE' 'SCI_STYLEGETSIZE');
		addAll: #('SCI_STYLESETEOLFILLED' 'SCI_STYLEGETEOLFILLED');
		addAll: #('SCI_STYLESETCHANGEABLE' 'SCI_STYLEGETCHANGEABLE');
		addAll: #('SCI_STYLESETHOTSPOT' 'SCI_STYLEGETHOTSPOT');
		addAll: #('SCI_STYLESETVISIBLE' 'SCI_STYLEGETVISIBLE');
		addAll: #('SCI_STYLESETSIZEFRACTIONAL' 'SCI_STYLEGETSIZEFRACTIONAL');
		addAll: #('SCI_STYLESETWEIGHT' 'SCI_STYLEGETWEIGHT');
		add: 'SCI_STYLERESETDEFAULT';
		yourself.

	"SCI_GETLENGTH is ignored because it duplicates SCI_GETTEXTLENGTH"
	ignoredMessages add: 'SCI_GETLENGTH'.

	"Don't make use of document ref. stuff at present."
	"ignoredMessages add: 'SCI_ADDREFDOCUMENT'."

	"Scintilla's cursor management is not required in Dolphin which has its own mechanisms."
	ignoredMessages addAll: #('SCI_GETCURSOR' 'SCI_SETCURSOR').

	"We don't need SCI_GETMODEVENTMASK because we store the event mask in an instance variable (for some reason that I no longer know)"
	ignoredMessages add: 'SCI_GETMODEVENTMASK'.

	"We don't need these as they are for the GTK+ platform only"
	ignoredMessages 
		addAll: #('SCI_GETRECTANGULARSELECTIONMODIFIER' 'SCI_SETRECTANGULARSELECTIONMODIFIER').

	"We always set the selection range start and end as a pair."
	ignoredMessages addAll: #('SCI_SETSELECTIONEND' 'SCI_SETSELECTIONSTART').

	"Likewise the old messages to set the target start and end separately are no longer needed, as we always set an interval and can use SCI_SETTARGETRANGE"
	ignoredMessages addAll: #('SCI_SETTARGETSTART' 'SCI_SETTARGETEND').
	ignoredMessages
		shrink;
		isImmutable: true;
		yourself)

	"We use the direct function exported by the DLL, and don't need a wrapper method for SCI_GETDIRECTPOINTER as we need to send it directly."
	"We don't use direct/unsafe access to the scintilla character buffer."
	"We don't support background loading"

	"The idFrom field of the notification header is not needed to identify the Scintilla
	control, as we have an object instance associated with each control instance that receives
	the notifications directly."

	"Scintilla supports standard Windows focus messages, which are used in the MVP framework already"

	"Margin attributes managed by ScintillaMargin"

	"Indicator attributes managed by ScintillaIndicatorStyle"

	"Indicator attributes managed by ScintillaMarkerDefinition"

	"Annotation attributes are managed by ScintillaAnnotation"

	"Style attributes managed by ScintillaTextStyle, but note that as Scintilla wrapping
	predates when style definitions were queryable, so we don't use these at all"

	"SCI_GETLENGTH is ignored because it duplicates SCI_GETTEXTLENGTH"

	"Don't make use of document ref. stuff at present."
	"ignoredMessages add: 'SCI_ADDREFDOCUMENT'."

	"Scintilla's cursor management is not required in Dolphin which has its own mechanisms."

	"We don't need SCI_GETMODEVENTMASK because we store the event mask in an instance variable (for some reason that I no longer know)"

	"We don't need these as they are for the GTK+ platform only"

	"We always set the selection range start and end as a pair."

	"Likewise the old messages to set the target start and end separately are no longer needed, as we always set an interval and can use SCI_SETTARGETRANGE"

	"We use the direct function exported by the DLL, and don't need a wrapper method for SCI_GETDIRECTPOINTER as we need to send it directly."
	"We don't use direct/unsafe access to the scintilla character buffer."
	"We don't support background loading"

	"The idFrom field of the notification header is not needed to identify the Scintilla
	control, as we have an object instance associated with each control instance that receives
	the notifications directly."

	"Scintilla supports standard Windows focus messages, which are used in the MVP framework already"

	"Margin attributes managed by ScintillaMargin"

	"Indicator attributes managed by ScintillaIndicatorStyle"

	"Indicator attributes managed by ScintillaMarkerDefinition"

	"Annotation attributes are managed by ScintillaAnnotation"

	"Style attributes managed by ScintillaTextStyle, but note that as Scintilla wrapping
	predates when style definitions were queryable, so we don't use these at all"

	"SCI_GETLENGTH is ignored because it duplicates SCI_GETTEXTLENGTH"

	"Don't make use of document ref. stuff at present."
	"ignoredMessages add: 'SCI_ADDREFDOCUMENT'."

	"Scintilla's cursor management is not required in Dolphin which has its own mechanisms."

	"We don't need SCI_GETMODEVENTMASK because we store the event mask in an instance variable (for some reason that I no longer know)"

	"We don't need these as they are for the GTK+ platform only"

	"We always set the selection range start and end as a pair."

	"Likewise the old messages to set the target start and end separately are no longer needed, as we always set an interval and can use SCI_SETTARGETRANGE"

	"We use the direct function exported by the DLL, and don't need a wrapper method for SCI_GETDIRECTPOINTER as we need to send it directly."
	"We don't use direct/unsafe access to the scintilla character buffer."
	"We don't support background loading"

	"The idFrom field of the notification header is not needed to identify the Scintilla
	control, as we have an object instance associated with each control instance that receives
	the notifications directly."

	"Scintilla supports standard Windows focus messages, which are used in the MVP framework already"

	"Margin attributes managed by ScintillaMargin"

	"Indicator attributes managed by ScintillaIndicatorStyle"

	"Indicator attributes managed by ScintillaMarkerDefinition"

	"Annotation attributes are managed by ScintillaAnnotation"

	"Style attributes managed by ScintillaTextStyle, but note that as Scintilla wrapping
	predates when style definitions were queryable, so we don't use these at all"

	"SCI_GETLENGTH is ignored because it duplicates SCI_GETTEXTLENGTH"

	"Don't make use of document ref. stuff at present."
	"ignoredMessages add: 'SCI_ADDREFDOCUMENT'."

	"Scintilla's cursor management is not required in Dolphin which has its own mechanisms."

	"We don't need SCI_GETMODEVENTMASK because we store the event mask in an instance variable (for some reason that I no longer know)"

	"We don't need these as they are for the GTK+ platform only"

	"We always set the selection range start and end as a pair."

	"Likewise the old messages to set the target start and end separately are no longer needed, as we always set an interval and can use SCI_SETTARGETRANGE"!

initialize
	events := OrderedCollection new: 256.
	commentQueue := WriteStream on: (String new: 160).
	lexerConstantPrefixes := Set new.
	previewChanges := true.
	commands := LookupTable new.
	"Special case"
	commands at: 'SCI_SETZOOM' put: #resetZoom.
	parsingDeprecated := false.
	namespace := RBNamespace new.
	generatedSelectors := LookupTable new.
	constantsPool := PoolConstantsDictionary new!

parseCategory: aReadableStream 
	| category |
	category := aReadableStream
				skipSeparators;
				upToEnd.
	parsingDeprecated := category asLowercase = 'deprecated'!

parseEnum: aReadableStream 
	Transcript
		display: 'Enumeration definition ignored: ';
		nextPutAll: aReadableStream upToEnd;
		cr!

parseEvent: aReadableStream 
	| event |
	event := (ScintillaEventDef tokens: (self splitDefinition: aReadableStream))
				comment: self getAndResetCommentQueue;
				isDeprecated: parsingDeprecated;
				yourself.
	self constantsPool at: event constName put: event id.
	self generateEventHandler: event.
	events add: event!

parseFile
	| filename |
	filename := (FileOpenDialog on: 'scintilla.iface')
				initialDirectory: ScintillaView owningPackage path;
				fileTypes: #(#('Scintilla Interface Files (*.iface)' '*.iface') #('All Files (*.*)' '*.*'));
				defaultExtension: 'iface';
				showModal.
	self parseFile: filename!

parseFile: aFileName 
	| cFile |
	self constantsPool removeAllKeys: self constantsPool keys.
	self defineAdditionalConstants.
	cFile := FileStream read: aFileName.
	[cFile atEnd] whileFalse: [self parseLine: cFile nextLine].
	cFile close.
	self generateConstantsPool.
	self generateNotificationMap.
	self generateCommandMap.
	self removeStaleAutoGeneratedMethods.
	previewChanges 
		ifTrue: [self browseChanges]
		ifFalse: 
			["Apply the changes."
			self applyChanges]!

parseFileComment: aReadableStream 
	"File comment lines are ignored"

	!

parseFunction: aReadableStream type: aString 
	| func stream |
	func := (ScintillaFunctionDef tokens: (self splitDefinition: aReadableStream))
				funcType: aString;
				isDeprecated: parsingDeprecated;
				comment: self getAndResetCommentQueue;
				yourself.
	self constantsPool at: func constName put: func id.
	(self ignoredMessages includes: func constName) 
		ifTrue: 
			[Notification signal: 'Ignoring message ' , func constName.
			^self].
	stream := String writeStream: 256.
	func emitMethodTextOn: stream.
	func isCommand ifTrue: [commands at: func constName put: func selector].
	self compileMethod: func selector source: stream contents!

parseInterfaceComment: aReadableStream 
	commentQueue isEmpty ifFalse: [commentQueue space].
	commentQueue nextPutAll: aReadableStream upToEnd trimBlanks!

parseLex: aReadableStream 
	| lexerName lexerId |
	lexerName := aReadableStream upTo: $=.
	lexerId := aReadableStream nextWord.
	lexerConstantPrefixes addAll: aReadableStream upToEnd subStrings!

parseLine: aString 
	| lineStream lineType |
	lineStream := aString readStream.
	lineType := lineStream nextWord.
	lineType ifNil: [^self].
	lineType = 'cat' ifTrue: [^self parseCategory: lineStream].
	(#('fun' 'get' 'set') includes: lineType) ifTrue: [^self parseFunction: lineStream type: lineType].
	lineType = 'val' ifTrue: [^self parseValue: lineStream].
	lineType = 'evt' ifTrue: [^self parseEvent: lineStream].
	lineType = '#!!' ifTrue: [^self parseShBang: lineStream].
	lineType = '#' ifTrue: [^self parseInterfaceComment: lineStream].
	lineType = 'enu' ifTrue: [^self parseEnum: lineStream].
	lineType = 'lex' ifTrue: [^self parseLex: lineStream].
	(lineType beginsWith: '##') ifTrue: [^self parseFileComment: lineStream].

	"Catch all"
	Transcript
		show: 'Unrecognised line: ';
		show: aString;
		cr!

parseShBang: aReadableStream 
	"You aint gonna need these, even if there were any"

	!

parseValue: aReadableStream 
	| value numberStream radix constName |
	self getAndResetCommentQueue.
	constName := aReadableStream upTo: $=.
	"We don't want to bloat the constants pool with a load of lexer defines that we don't need in Dolphin"
	(lexerConstantPrefixes anySatisfy: [:each | constName beginsWith: each]) ifTrue: [^self].
	value := aReadableStream upToEnd.
	numberStream := value readStream.
	radix := (value beginsWith: '0x') 
				ifTrue: 
					[numberStream skip: 2.
					16]
				ifFalse: [10].
	value := Integer readFrom: numberStream radix: radix.
	numberStream atEnd ifFalse: [^self].
	self constantsPool at: constName put: value!

previewChanges: aBoolean 
	"Set whether the parser is in preview mode. When in preview mode the generator will not apply the
	changes it generates, but just open a change browser on them instead."

	previewChanges := aBoolean!

removeStaleAutoGeneratedMethods
	| aClassDescription autogen methods selectors class classification |
	aClassDescription := self scintillaViewClass.
	autogen := aClassDescription methodCategoryClass name: self autoGenCategoryName.
	methods := autogen methodsInBehavior: aClassDescription.
	classification := LookupTable new.
	methods do: 
			[:each | 
			classification at: each selector
				put: (each categories reject: [:cat | cat isPrivacy or: [cat == autogen]])].
	selectors := (methods collect: [:method | method selector]) 
				difference: (generatedSelectors at: aClassDescription).
	class := namespace classFor: aClassDescription.
	(selectors difference: class newMethods keys) do: [:each | class removeMethod: each]!

sciCommands
	"Answer the set of all Scintilla control message id's that identify keyboard-bindable
	commands."

	^##((Set new)
		add: 'SCI_BACKTAB';
		add: 'SCI_CANCEL';
		add: 'SCI_CHARLEFT';
		add: 'SCI_CHARLEFTEXTEND';
		add: 'SCI_CHARLEFTRECTEXTEND';
		add: 'SCI_CHARRIGHT';
		add: 'SCI_CHARRIGHTEXTEND';
		add: 'SCI_CHARRIGHTRECTEXTEND';
		add: 'SCI_CLEAR';
		add: 'SCI_CLEARALL';
		add: 'SCI_COPY';
		add: 'SCI_CUT';
		add: 'SCI_DELETEBACK';
		add: 'SCI_DELETEBACKNOTLINE';
		add: 'SCI_DELLINELEFT';
		add: 'SCI_DELLINERIGHT';
		add: 'SCI_DELWORDLEFT';
		add: 'SCI_DELWORDRIGHT';
		add: 'SCI_DOCUMENTEND';
		add: 'SCI_DOCUMENTENDEXTEND';
		add: 'SCI_DOCUMENTSTART';
		add: 'SCI_DOCUMENTSTARTEXTEND';
		add: 'SCI_EDITTOGGLEOVERTYPE';
		add: 'SCI_FORMFEED';
		add: 'SCI_HOME';
		add: 'SCI_HOMEDISPLAY';
		add: 'SCI_HOMEDISPLAYEXTEND';
		add: 'SCI_HOMEEXTEND';
		add: 'SCI_HOMERECTEXTEND';
		add: 'SCI_HOMEWRAP';
		add: 'SCI_HOMEWRAPEXTEND';
		add: 'SCI_LINECOPY';
		add: 'SCI_LINECUT';
		add: 'SCI_LINEDELETE';
		add: 'SCI_LINEDOWN';
		add: 'SCI_LINEDOWNEXTEND';
		add: 'SCI_LINEDOWNRECTEXTEND';
		add: 'SCI_LINEDUPLICATE';
		add: 'SCI_LINEEND';
		add: 'SCI_LINEENDDISPLAY';
		add: 'SCI_LINEENDDISPLAYEXTEND';
		add: 'SCI_LINEENDEXTEND';
		add: 'SCI_LINEENDRECTEXTEND';
		add: 'SCI_LINEENDWRAP';
		add: 'SCI_LINEENDWRAPEXTEND';
		add: 'SCI_LINESCROLLDOWN';
		add: 'SCI_LINESCROLLUP';
		add: 'SCI_LINESJOIN';
		add: 'SCI_LINETRANSPOSE';
		add: 'SCI_LINEUP';
		add: 'SCI_LINEUPEXTEND';
		add: 'SCI_LINEUPRECTEXTEND';
		add: 'SCI_LOWERCASE';
		add: 'SCI_MOVECARETINSIDEVIEW';
		add: 'SCI_NEWLINE';
		add: 'SCI_PAGEDOWN';
		add: 'SCI_PAGEDOWNEXTEND';
		add: 'SCI_PAGEDOWNRECTEXTEND';
		add: 'SCI_PAGEUP';
		add: 'SCI_PAGEUPEXTEND';
		add: 'SCI_PAGEUPRECTEXTEND';
		add: 'SCI_PARADOWN';
		add: 'SCI_PARADOWNEXTEND';
		add: 'SCI_PARAUP';
		add: 'SCI_PARAUPEXTEND';
		add: 'SCI_PASTE';
		add: 'SCI_REDO';
		add: 'SCI_SEARCHANCHOR';
		add: 'SCI_SELECTALL';
		add: 'SCI_SETSAVEPOINT';
		add: 'SCI_STARTRECORD';
		add: 'SCI_STOPRECORD';
		add: 'SCI_STUTTEREDPAGEDOWN';
		add: 'SCI_STUTTEREDPAGEDOWNEXTEND';
		add: 'SCI_STUTTEREDPAGEUP';
		add: 'SCI_STUTTEREDPAGEUPEXTEND';
		add: 'SCI_TAB';
		add: 'SCI_TARGETFROMSELECTION';
		add: 'SCI_TOGGLECARETSTICKY';
		add: 'SCI_UNDO';
		add: 'SCI_UPPERCASE';
		add: 'SCI_VCHOME';
		add: 'SCI_VCHOMEDISPLAY';
		add: 'SCI_VCHOMEEXTEND';
		add: 'SCI_VCHOMERECTEXTEND';
		add: 'SCI_VCHOMEWRAP';
		add: 'SCI_VCHOMEWRAPEXTEND';
		add: 'SCI_VCHOMEDISPLAYEXTEND';
		add: 'SCI_WORDLEFT';
		add: 'SCI_WORDLEFTEND';
		add: 'SCI_WORDLEFTENDEXTEND';
		add: 'SCI_WORDLEFTEXTEND';
		add: 'SCI_WORDPARTLEFT';
		add: 'SCI_WORDPARTLEFTEXTEND';
		add: 'SCI_WORDPARTRIGHT';
		add: 'SCI_WORDPARTRIGHTEXTEND';
		add: 'SCI_WORDRIGHT';
		add: 'SCI_WORDRIGHTEND';
		add: 'SCI_WORDRIGHTENDEXTEND';
		add: 'SCI_WORDRIGHTEXTEND';
		add: 'SCI_ZOOMIN';
		add: 'SCI_ZOOMOUT';
		add: 'SCI_SETZOOM';
		add: 'SCI_MOVESELECTEDLINESUP';
		add: 'SCI_MOVESELECTEDLINESDOWN';
		add: 'SCI_SCROLLTOSTART';
		add: 'SCI_SCROLLTOEND';
		add: 'SCI_VERTICALCENTRECARET';
		shrink;
		yourself)!

scintillaViewClass
	^ScintillaView!

scnFirst
	^2000!

splitDefinition: aReadableStream 
	| tokens |
	tokens := Array writeStream.
	"return type"
	tokens nextPut: aReadableStream nextWord.
	"func name"
	tokens nextPut: (aReadableStream upTo: $=).
	"message id (integer)"
	tokens nextPut: (Integer fromString: (aReadableStream upTo: $()).
	"Parameter {type, name} pairs"
	
	[aReadableStream
		skipSeparators;
		atEnd] whileFalse: 
				[(aReadableStream peekFor: $,) 
					ifTrue: 
						["Empty param"
						tokens nextPut: #('int' nil)]
					ifFalse: 
						[(aReadableStream peekFor: $)) 
							ifTrue: 
								["Final empty param"
								tokens nextPut: #('int' nil).
								aReadableStream setToEnd]
							ifFalse: 
								[| type name |
								type := aReadableStream nextWord.
								name := String writeStream.
								[aReadableStream atEnd or: [aReadableStream peekFor: $,]] whileFalse: 
										[| ch |
										ch := aReadableStream next.
										ch == $) ifTrue: [aReadableStream setToEnd] ifFalse: [ch isSeparator ifFalse: [name nextPut: ch]]].
								tokens nextPut: (Array with: type with: name contents)]]].
	^tokens contents! !
!ScintillaViewGenerator categoriesFor: #applyChanges!helpers!private! !
!ScintillaViewGenerator categoriesFor: #autoGenCategory!constants!private! !
!ScintillaViewGenerator categoriesFor: #autoGenCategoryName!constants!private! !
!ScintillaViewGenerator categoriesFor: #autoGenEventCategories!constants!private! !
!ScintillaViewGenerator categoriesFor: #autoGenMethodCategories!constants!private! !
!ScintillaViewGenerator categoriesFor: #browseChanges!helpers!private! !
!ScintillaViewGenerator categoriesFor: #compile:selector:in:categories:!private! !
!ScintillaViewGenerator categoriesFor: #compileMethod:source:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #compileMethod:source:categories:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #constantsPool!helpers!private! !
!ScintillaViewGenerator categoriesFor: #defineAdditionalConstants!helpers!private! !
!ScintillaViewGenerator categoriesFor: #generateCommandMap!generating!private! !
!ScintillaViewGenerator categoriesFor: #generateConstantsPool!operations!private! !
!ScintillaViewGenerator categoriesFor: #generateEventHandler:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #generateNotificationMap!generating!private! !
!ScintillaViewGenerator categoriesFor: #getAndResetCommentQueue!helpers!private! !
!ScintillaViewGenerator categoriesFor: #ignoredMessages!constants!private! !
!ScintillaViewGenerator categoriesFor: #initialize!helpers!initializing!public! !
!ScintillaViewGenerator categoriesFor: #parseCategory:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseEnum:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseEvent:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseFile!helpers!public! !
!ScintillaViewGenerator categoriesFor: #parseFile:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseFileComment:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseFunction:type:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseInterfaceComment:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseLex:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseLine:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseShBang:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #parseValue:!helpers!private! !
!ScintillaViewGenerator categoriesFor: #previewChanges:!public! !
!ScintillaViewGenerator categoriesFor: #removeStaleAutoGeneratedMethods!helpers!private! !
!ScintillaViewGenerator categoriesFor: #sciCommands!constants!private! !
!ScintillaViewGenerator categoriesFor: #scintillaViewClass!constants!private! !
!ScintillaViewGenerator categoriesFor: #scnFirst!constants!private! !
!ScintillaViewGenerator categoriesFor: #splitDefinition:!private! !

!ScintillaViewGenerator class methodsFor!

icon
	^ScintillaView icon!

new
	^super new initialize! !
!ScintillaViewGenerator class categoriesFor: #icon!constants!development!public! !
!ScintillaViewGenerator class categoriesFor: #new!instance creation!public! !

