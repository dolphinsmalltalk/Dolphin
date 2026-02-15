"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Filename'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: { 'PathDelimiter' -> $\. 'PathDelimiters' -> '/\' }!

Core.Filename guid: (Core.GUID fromString: '{38ace293-bc16-491a-820b-d9059a7e6dfe}')!

Core.Filename comment: ''!

!Core.Filename class methodsFor!

appendPathDelimiter: aString
	"Answer a <readableString> that is the argument with a path separator appended to create the correct syntax for
	a path. If aString already ends in a path separator then the answer is equivalent."

	| count |
	count := aString size.
	(count ~~ 0 and: [PathDelimiters identityIncludes: (aString at: count)]) ifTrue: [^aString].
	^aString copyWith: PathDelimiter!

canonicalizePath: aString
	"Converts the path <String> argument into a canonical form, removing any embedded '..' and '.' components, and adding a long path prefix if required."

	^PathCch pathCanonicalize: aString dwFlags: PathCchLibrary.PATHCCH_ALLOW_LONG_PATHS!

commonPrefixOf: pathString1 and: pathString2
	"Answer the <readableString> common prefix shared between the two paths.
	This will be empty if the paths share no common prefix."

	| prefix len path1 path2 |
	path1 := pathString1 asUtf16String.
	path2 := pathString2 asUtf16String.
	len := Shlwapi
				pathCommonPrefix: path1
				pszFile2: path2
				achPath: nil.
	len == 0 ifTrue: [^''].
	prefix := Utf16String newFixed: len.
	Shlwapi
		pathCommonPrefix: path1
		pszFile2: path2
		achPath: prefix.
	^prefix!

composePath: aPathString stem: aStemString extension: anExtensionString
	"Composes a full pathname from its components. The path or extension components 
	can be nil if necessary. The path can include the drive letter."

	^self makePath: {nil. aPathString. aStemString. anExtensionString}!

composePath: pathString subPath: subpathString
	"Composes a full pathname from path and subpath components."

	^PathCch
		pathCombine: pathString
		pszMore: subpathString
		dwFlags: PathCchLibrary.PATHCCH_ALLOW_LONG_PATHS!

composeShortStem: aStemString extension: anExtensionString 
	"Answer a String which is a file name abbreviated from aStemString and anExtensionString.
	Lower case vowels are dropped from the right of aStemString until it is less than
	or equal to 8 characters.
	If still longer than 8 chars, then other lowercase letters are dropped from the
	right of the stem until it is less than or equal to 8 characters."

	| stemResult extResult |
	stemResult := self shortenComponent: aStemString max: 8.
	extResult := self shortenComponent: anExtensionString max: 3.
	^self composeStem: stemResult extension: extResult!

composeStem: aStemString extension: anExtensionString
	"Composes a full pathname from aStemString and anExtensionString components. Note that the dot separator may be specified in the extension, or not."

	"Implementation Note: This could be implemented in terms of #composePath:stem:extension:, which ultimately is implemented in terms of #makePath:, however it is a very frequently used method so an optimized version which takes advantage of private knowledge of how file names are constructed is warranted."

	^(anExtensionString at: 1) == $.
		ifTrue: [aStemString , anExtensionString]
		ifFalse: [aStemString , '.' , anExtensionString]!

default: pathString extension: extString
	"Defaults the extension of pathString to extString if there is no current extension.
	Answers the filename with new or existing extension."

	| i size |
	i := size := pathString size.
	
	[i == 0 or: 
			[| ch |
			ch := pathString at: i.
			ch == $.
				ifTrue: 
					["Extension delimiter located"
					^i = size
						ifTrue: 
							["Existing extension is empty"
							extString size == 0
								ifTrue: [pathString copyFrom: 1 to: i - 1]
								ifFalse: 
									[(extString at: 1) == $.
										ifTrue: [(pathString copyFrom: 1 to: i - 1) , extString]
										ifFalse: [(pathString copyFrom: 1 to: i) , extString]]]
						ifFalse: 
							["Existing non-empty extension, leave unchanged"
							pathString]].
			"If we find another path separator while searching backward, then there is no existing extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^extString size == 0
		ifTrue: [pathString]
		ifFalse: 
			[(extString at: 1) == $. ifTrue: [pathString , extString] ifFalse: [pathString , '.' , extString]]!

fullPathOf: aPathnameString
	"Answers the full path of aPathnameString"

	^Kernel32 getFullPathName: aPathnameString!

fullPathOf: aPathnameString relativeTo: aBasePathString
	"Answers the full path of aPathnameString. If this is a truly relative
	path then it is formed as relative to aBasePathString"

	| actualPath |
	actualPath := (self isRelativePath: aPathnameString) 
		ifTrue: [self composePath: aBasePathString subPath: aPathnameString]
		ifFalse: [aPathnameString].
	^self fullPathOf: actualPath
!

isRelativePath: aString
	"Answers whether the <String> argument is a relative path with no absolute components. See [Fully Qualified vs. Relative Paths](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file#fully-qualified-vs-relative-paths)."

	"The Microsoft documentation does not seem to specify the expected treatment of paths with the long path prefix, '\\?\', but empirically it seems these are always considered absolute. This would be consistent with treatment of UNC paths."

	| size first |
	aString ifNil: [^true].
	size := aString size.
	size == 0 ifTrue: [^true].
	first := aString at: 1.
	(first == $\ or: [first == $/]) ifTrue: [^false].
	(size <= 2 or: [first isEnglishLetter not]) ifTrue: [^true].
	^(aString at: 2) ~~ $: or: 
			[first := aString at: 3.
			first ~~ $\ and: [first ~~ $/]]!

isRootPath: aString
	"Answer whether the <String> argument is a root path, e.g. 'c:\'"

	^PathCch pathCchIsRoot: aString!

locateFilename: aFilenameString in: searchPath 
	"Answers the full pathname of aFilenameString searched for in the ordered collection
	of paths provided in searchPath. If aFilenameString includes a directory then it is
	answered. Otherwise the file is searched for in the directories in searchPath. If the
	file is not found in any of these directories then aFilenameString is answered"

	(self splitPathFrom: aFilenameString) isEmpty 
		ifTrue: 
			[searchPath do: 
					[:each | 
					| fullpath |
					fullpath := self composePath: each subPath: aFilenameString.
					(self exists: fullpath) ifTrue: [^fullpath]]].
	^aFilenameString!

makePath: anArray
	"Composes a full pathname from its path, stem and extension components.
	The path and extension components can be nil or the empty string if the path
	does not have either of these components. The stem must be a non-empty String."

	| size drive dir fname ext path |
	size := 0.
	(anArray at: 1)
		ifNotNil: 
			[:d |
			"Assume the drive doesn't have the colon and that _makepath_s will add it"
			drive := d asUtf8String.
			size := drive size + 1].
	(anArray at: 2)
		ifNotNil: 
			[:d |
			"Assume the terminating path separator is missing"
			dir := d asUtf8String.
			size := size + dir size + 1].
	(anArray at: 3)
		ifNotNil: 
			[:f |
			fname := f asUtf8String.
			size := size + fname size].
	(anArray at: 4)
		ifNotNil: 
			[:e |
			"Assume the dot is missing"
			ext := e asUtf8String.
			size := size + ext size + 1].
	path := Utf8String newFixed: size.
	Ucrt
		_makepath_s: path
		bufferSize: size + 1
		drive: drive
		dir: dir
		fname: fname
		ext: ext.
	^path trimNulls!

path: pathString extension: extString
	"Answer a full pathname with the specified extension, whether or not pathString already has
	an extension."

	| i |
	i := pathString size.
	
	[i == 0 or: 
			[| ch |
			ch := pathString at: i.
			ch == $.
				ifTrue: 
					["We've found the start of the existing extension"
					^extString size == 0
						ifTrue: 
							["New extension is empty, so just remove the existing one"
							pathString copyFrom: 1 to: i - 1]
						ifFalse: 
							[(extString at: 1) == $.
								ifTrue: [(pathString copyFrom: 1 to: i - 1) , extString]
								ifFalse: [(pathString copyFrom: 1 to: i) , extString]]].
			"If we find another path separator while searching backward, then there is no existing extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^extString size == 0
		ifTrue: [pathString]
		ifFalse: [self composeStem: pathString extension: extString]!

pathDelimiter
	"Answers the character that delimits a path (or parts thereof)"

	^PathDelimiter!

pathDelimiters
	"Answers the characters that can be used to delimits a path (or parts thereof).	
	Windows tends to accept the Unix delimiter, a forward slash, as well as its own
	back slash."

	^PathDelimiters!

relativePathOf: aPathString to: aBasePathString
	"Answers the relative path of aPathString relative to aBasePathString.
	Note that if the last component of aBasePathString is to be considered a directory
	then there must be a trailing slash, otherwise the last component is ignored (it is
	treated as if it were a file name)."

	| relPath toPath |
	#todo. "Relative paths cannot be long, but the from/to paths theoretically could be. The API itself does not support long filenames, so will have to be replaced."
	relPath := Utf16String newFixed: MAX_PATH.
	toPath := aPathString asUtf16String.
	relPath := (Shlwapi
				pathRelativePathTo: relPath
				pszFrom: aBasePathString
				dwAttrFrom: 0
				pszTo: toPath
				dwAttrTo: 0) ifTrue: [relPath] ifFalse: [toPath].
	^(relPath beginsWith: '.\')
		ifTrue: [relPath copyFrom: 3 to: relPath strlen]
		ifFalse: [relPath trimNulls]!

removeExtension: aString
	"Answer a <readableString> which is the path argument with the extension component removed."

	| i |
	i := aString size.
	
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $.
				ifTrue: 
					["We've found the start of the extension"
					^aString copyFrom: 1 to: i - 1].
			"If we find another path separator while searching backward, then there is no extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^aString!

removePathDelimiter: aString
	"Answer a <readableString> that is the argument with a path separator at its end, if any, removed."

	| count |
	count := aString size.
	"In this case we know that the path delimiters only ever require one code unit (they are all ascii characters), so it is safe to work with code units"
	^(count ~~ 0 and: 
			[| ch |
			ch := aString at: count.
			ch == $\ or: [ch == $/]])
		ifTrue: [aString copyFrom: 1 to: count - 1]
		ifFalse: [aString]!

replacePath: filePath with: newPath
	"Replace the path component of the full path name, filePath, with the new path name,
	newPath, i.e. only the stem and extension remain intact."

	| oldPathComponents |
	oldPathComponents := self splitPath: filePath.
	oldPathComponents 
		at: 1 put: nil;			"new path can include drive letter"
		at: 2 put: newPath.
	^self makePath: oldPathComponents!

shortenComponent: aString max: anInteger 
	| abbreviated |
	abbreviated := aString.
	abbreviated size > anInteger ifTrue: [abbreviated := abbreviated select: [:c | c isAlphaNumeric]].
	abbreviated size > anInteger 
		ifTrue: 
			[| len |
			len := abbreviated size.
			abbreviated := abbreviated reverse.
			abbreviated := abbreviated select: 
							[:c | 
							| useChar |
							(c isVowel and: [c isLowercase and: [len > anInteger]]) 
								ifTrue: 
									[useChar := false.
									len := len - 1]
								ifFalse: [useChar := true].
							useChar].
			abbreviated := abbreviated reverse].
	abbreviated size > anInteger 
		ifTrue: 
			[| len |
			len := abbreviated size.
			abbreviated := abbreviated reverse.
			abbreviated := abbreviated select: 
							[:c | 
							| useChar |
							(c isLowerCase and: [len > anInteger]) 
								ifTrue: 
									[useChar := false.
									len := len - 1]
								ifFalse: [useChar := true].
							useChar].
			abbreviated := abbreviated reverse].
	abbreviated size > anInteger ifTrue: [abbreviated := abbreviated leftString: anInteger].
	^abbreviated!

shortPathOf: aPathnameString
	"Answers the short path version of aPathnameString"

	^Kernel32 getShortPathName: aPathnameString!

splitDriveFrom: aString
	"Splits the pathname, aString, and answers the drive portion.
	Answers an empty string if there is no drive component in the path."

	| drive |
	Ucrt
		_splitpath_s: aString asUtf8String
		drive: (drive := Utf8String new: CRTConstants._MAX_DRIVE)
		driveLen: ##(CRTConstants._MAX_DRIVE + 1)
		dir: nil
		dirLen: 0
		fname: nil
		fnameLen: 0
		ext: nil
		extLen: 0.
	^drive trimNulls!

splitExtensionFrom: aString
	"Splits aPathname string and answers the extension portion.
	Answers the empty string if there is no extension."

	| i size |
	i := size := aString size.
	
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $.
				ifTrue: 
					["We've found the start of the extension"
					^aString copyFrom: i + 1 to: size].
			"If we find another path separator while searching backward, then there is no extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^''!

splitFilenameFrom: aString
	"Splits the pathname, aString, and answers the file name portion (including extension).
	Answers an empty string if there is no filename component in the path."

	| i size |
	i := size := aString size.
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
		whileFalse: [i := i - 1].
	^aString copyFrom: i + 1 to: size!

splitPath: aString
	"Splits the pathname, aString, into its path, stem and extension components and answers 
	a four element Array of these.
	Note: We use the C-runtime library to implement this, hence either backward or forward
	slashes (i.e. $\ or $/) are acceptable as pathname delimiters."

	| max path drive dir fname ext |
	"To avoid problems with long filenames, we use the length of the input string as the buffer
	sizes - clearly the component parts can never be larger than this.  In order to support
	Unicode paths, we work in UTF-8."
	path := aString asUtf8String.
	max := path size.
	max = 0 ifTrue: [^{''. ''. ''. ''}].
	Ucrt
		_splitpath_s: path
		drive: (drive := Utf8String new: CRTConstants._MAX_DRIVE)
		driveLen: ##(CRTConstants._MAX_DRIVE + 1)
		dir: (dir := Utf8String new: max)
		dirLen: max + 1
		fname: (fname := Utf8String new: max)
		fnameLen: max + 1
		ext: (ext := Utf8String new: max)
		extLen: max + 1.
	"CRT function includes leading period on extension, which we don't"
	^{drive trimNulls.
		dir trimNulls.
		fname trimNulls.
		ext copyFrom: (ext first == $. ifTrue: [2] ifFalse: [1]) to: ext strlen}!

splitPathFrom: aString
	"Splits the <String> argument, assumed to be a file path, and answers the path portion (including the drive letter, if any, and the terminating path separator).
	Answers an  empty <String> if there is no path."

	| i |
	i := aString size.
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
		whileFalse: [i := i - 1].
	^aString copyFrom: 1 to: i !

splitStemFrom: aString
	"Answers the file stem component of the path <String> argument, or an empty string if there
	is none."

	| i size |
	i := size := aString size.
	
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $.
				ifTrue: 
					[| end |
					"There is a file extension - stem must precede that"
					end := i := i - 1.
					[i == 0 or: 
							[ch := aString at: i.
							ch == $\ or: [ch == $/ or: [ch == $:]]]]
						whileFalse: [i := i - 1].
					^aString copyFrom: i + 1 to: end].
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	"No extension"
	^aString copyFrom: i + 1 to: size! !

!Core.Filename class categoriesForMethods!
appendPathDelimiter:!filename manipulation!public! !
canonicalizePath:!filename manipulation!public! !
commonPrefixOf:and:!filename manipulation!public! !
composePath:stem:extension:!filename manipulation!public! !
composePath:subPath:!filename manipulation!public! !
composeShortStem:extension:!filename manipulation!public! !
composeStem:extension:!filename manipulation!public! !
default:extension:!filename manipulation!public! !
fullPathOf:!filename manipulation!public! !
fullPathOf:relativeTo:!filename manipulation!public! !
isRelativePath:!filename manipulation!public! !
isRootPath:!filename manipulation!public! !
locateFilename:in:!filename manipulation!public! !
makePath:!filename manipulation!public! !
path:extension:!filename manipulation!public! !
pathDelimiter!constants!public! !
pathDelimiters!constants!public! !
relativePathOf:to:!filename manipulation!public! !
removeExtension:!filename manipulation!public! !
removePathDelimiter:!filename manipulation!public! !
replacePath:with:!filename manipulation!public! !
shortenComponent:max:!helpers!private! !
shortPathOf:!filename manipulation!public! !
splitDriveFrom:!filename manipulation!public! !
splitExtensionFrom:!filename manipulation!public! !
splitFilenameFrom:!filename manipulation!public! !
splitPath:!filename manipulation!public! !
splitPathFrom:!filename manipulation!public! !
splitStemFrom:!filename manipulation!public! !
!

