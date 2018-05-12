"Filed out from Dolphin Smalltalk 7"!

FileOpenDialog subclass: #MultipleFileOpenDialog
	instanceVariableNames: 'buffer maxFileCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultipleFileOpenDialog guid: (GUID fromString: '{6bf5baa9-0551-40bd-a72f-e1e38b778543}')!
MultipleFileOpenDialog comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!MultipleFileOpenDialog categoriesForClass!IDB Goodies! !
!MultipleFileOpenDialog methodsFor!

defaultMaxFileCount
	"Answers the default number of selections that are expected  to fit into the buffer"

	^25!

defaultStyle
	"Answers the style for the receiver."

	^super defaultStyle bitOr: ##(OFN_ALLOWMULTISELECT | OFN_EXPLORER)!

extractResult: result 
	"Extract the result from the buffer. The possible outcomes are
		result == false. 
			The user cancelled. Don't change the model.
		result == true.
			If the user made one selection then the buffer contains a full path.
			If the user made multiple selections then the first item in the buffer contains the
				 path (minus any filename) and the subsequent entries contain the selected 
				filenames.
			In both cases we construct a collection of full paths to  set the receivers value.
	Items are stored in the buffer separated by 0, the end of the buffer indicated by an empty
	entry (double 0)"

	result 
		ifTrue: 
			[| endIndex pathNames |
			endIndex := buffer indexOfSubCollection: ##(String with: Character null with: Character null).
			pathNames := (buffer copyFrom: 1 to: endIndex) subStrings: Character null.
			pathNames size > 1 
				ifTrue: 
					[pathNames := (pathNames copyFrom: 2) 
								collect: [:each | File composePath: pathNames first subPath: each]].
			self value: pathNames.
			self apply]!

maxFileCount
	"Answers the maximum number of selections that can be expected to fit into the buffer.
	Maintain a minimum size of 10, just in case"

	maxFileCount isNil ifTrue: [^self defaultMaxFileCount].
	^maxFileCount max: 10!

maxFileCount: anInteger 
	"Sets the maximum number of paths that can be expected to fit into the buffer"

	maxFileCount := anInteger!

prepareStruct
	"Prepare the structure expected by the dialog. The size of the buffer is set to the 
	maximum size of a Windows path (the buffer will only ever contain one path) plus
	maxFileCount instVar multiplied by 30 (i.e. 3 times the average file name size). 
	If the buffer specified is too small then the Dialog just answers nil, no error is raised.
	NB We keep a reference to the buffer in an instVar as we need to scan it later to 
	extract multiple Strings (see #extractResult). If we try to use the winStruct reference
	we can only recover the first String."

	| filename |
	buffer := Utf16String newFixed: self maxFileCount * 30 + File maxPath.
	filename := self value.
	filename notNil
		ifTrue: 
			[buffer
				replaceFrom: 1
				to: filename size
				with: filename].
	self winStruct
		fileTypes: (self fileTypesStringFromSpecs: self fileTypes);
		nMaxFile: buffer size;
		fileName: buffer;
		flags: self style! !
!MultipleFileOpenDialog categoriesFor: #defaultMaxFileCount!accessing!public! !
!MultipleFileOpenDialog categoriesFor: #defaultStyle!constants!public! !
!MultipleFileOpenDialog categoriesFor: #extractResult:!helpers!public! !
!MultipleFileOpenDialog categoriesFor: #maxFileCount!accessing!public! !
!MultipleFileOpenDialog categoriesFor: #maxFileCount:!accessing!public! !
!MultipleFileOpenDialog categoriesFor: #prepareStruct!public!realizing/unrealizing! !

